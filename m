Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 543AE2EAEA;
	Fri, 24 Nov 2023 19:06:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sX9wYHTS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5486C433C8;
	Fri, 24 Nov 2023 19:06:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700852802;
	bh=R5p9maeyMubWHsvQcM+weCZYlivlrlxmcB7Si3xONsg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sX9wYHTSRmvolMRYVvbkOshmb8ECsWo7KQQlR48merLTEtF/iSggyKvDz4h7yG6dI
	 GH1Q2MQTOw3t1avxiwk89AjgYLIbGW2jobPAaKqFD79WmiCDpvPVhJ7jkNv4l/HrSV
	 WYbHKh3ONbBKdHUpBL9UVRB7kivhkPBFazHdY454=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.10 129/193] jbd2: fix potential data lost in recovering journal raced with synchronizing fs bdev
Date: Fri, 24 Nov 2023 17:54:16 +0000
Message-ID: <20231124171952.389464996@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124171947.127438872@linuxfoundation.org>
References: <20231124171947.127438872@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhihao Cheng <chengzhihao1@huawei.com>

commit 61187fce8600e8ef90e601be84f9d0f3222c1206 upstream.

JBD2 makes sure journal data is fallen on fs device by sync_blockdev(),
however, other process could intercept the EIO information from bdev's
mapping, which leads journal recovering successful even EIO occurs during
data written back to fs device.

We found this problem in our product, iscsi + multipath is chosen for block
device of ext4. Unstable network may trigger kpartx to rescan partitions in
device mapper layer. Detailed process is shown as following:

  mount          kpartx          irq
jbd2_journal_recover
 do_one_pass
  memcpy(nbh->b_data, obh->b_data) // copy data to fs dev from journal
  mark_buffer_dirty // mark bh dirty
         vfs_read
	  generic_file_read_iter // dio
	   filemap_write_and_wait_range
	    __filemap_fdatawrite_range
	     do_writepages
	      block_write_full_folio
	       submit_bh_wbc
	            >>  EIO occurs in disk  <<
	                     end_buffer_async_write
			      mark_buffer_write_io_error
			       mapping_set_error
			        set_bit(AS_EIO, &mapping->flags) // set!
	    filemap_check_errors
	     test_and_clear_bit(AS_EIO, &mapping->flags) // clear!
 err2 = sync_blockdev
  filemap_write_and_wait
   filemap_check_errors
    test_and_clear_bit(AS_EIO, &mapping->flags) // false
 err2 = 0

Filesystem is mounted successfully even data from journal is failed written
into disk, and ext4/ocfs2 could become corrupted.

Fix it by comparing the wb_err state in fs block device before recovering
and after recovering.

A reproducer can be found in the kernel bugzilla referenced below.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=217888
Cc: stable@vger.kernel.org
Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20230919012525.1783108-1-chengzhihao1@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/jbd2/recovery.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/fs/jbd2/recovery.c
+++ b/fs/jbd2/recovery.c
@@ -287,6 +287,8 @@ int jbd2_journal_recover(journal_t *jour
 	journal_superblock_t *	sb;
 
 	struct recovery_info	info;
+	errseq_t		wb_err;
+	struct address_space	*mapping;
 
 	memset(&info, 0, sizeof(info));
 	sb = journal->j_superblock;
@@ -304,6 +306,9 @@ int jbd2_journal_recover(journal_t *jour
 		return 0;
 	}
 
+	wb_err = 0;
+	mapping = journal->j_fs_dev->bd_inode->i_mapping;
+	errseq_check_and_advance(&mapping->wb_err, &wb_err);
 	err = do_one_pass(journal, &info, PASS_SCAN);
 	if (!err)
 		err = do_one_pass(journal, &info, PASS_REVOKE);
@@ -324,6 +329,9 @@ int jbd2_journal_recover(journal_t *jour
 	err2 = sync_blockdev(journal->j_fs_dev);
 	if (!err)
 		err = err2;
+	err2 = errseq_check_and_advance(&mapping->wb_err, &wb_err);
+	if (!err)
+		err = err2;
 	/* Make sure all replayed data is on permanent storage */
 	if (journal->j_flags & JBD2_BARRIER) {
 		err2 = blkdev_issue_flush(journal->j_fs_dev, GFP_KERNEL);


