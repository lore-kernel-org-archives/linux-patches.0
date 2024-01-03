Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C85E81C283;
	Wed,  3 Jan 2024 17:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GON9NSVg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19CD7C433C7;
	Wed,  3 Jan 2024 17:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704301273;
	bh=oChQLymVZTwdHamzmtPSaCwpFtaEwivpTG9oZKbxuFc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GON9NSVgYRVIUAubbGiU7Q283kBxC7ytA2iemywEO9ALZuGZzpUS8rKACPVvk67WO
	 7pzAP9gF9pR57KCSTNsNnJWY15Y7ofGepiloa7/ZKFQ7EHMMSX+8Q0c+X/3z2Uuw7C
	 098id9TKezCbzHMnVEgSPHJFa6Ee1Ni63l+6MnF8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baokun Li <libaokun1@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Christoph Hellwig <hch@infradead.org>,
	Dave Chinner <david@fromorbit.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Theodore Tso <tytso@mit.edu>,
	yangerkun <yangerkun@huawei.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 087/100] mm/filemap: avoid buffered read/write race to read inconsistent data
Date: Wed,  3 Jan 2024 17:55:16 +0100
Message-ID: <20240103164909.170384396@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240103164856.169912722@linuxfoundation.org>
References: <20240103164856.169912722@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baokun Li <libaokun1@huawei.com>

commit e2c27b803bb664748e090d99042ac128b3f88d92 upstream.

The following concurrency may cause the data read to be inconsistent with
the data on disk:

             cpu1                           cpu2
------------------------------|------------------------------
                               // Buffered write 2048 from 0
                               ext4_buffered_write_iter
                                generic_perform_write
                                 copy_page_from_iter_atomic
                                 ext4_da_write_end
                                  ext4_da_do_write_end
                                   block_write_end
                                    __block_commit_write
                                     folio_mark_uptodate
// Buffered read 4096 from 0          smp_wmb()
ext4_file_read_iter                   set_bit(PG_uptodate, folio_flags)
 generic_file_read_iter            i_size_write // 2048
  filemap_read                     unlock_page(page)
   filemap_get_pages
    filemap_get_read_batch
    folio_test_uptodate(folio)
     ret = test_bit(PG_uptodate, folio_flags)
     if (ret)
      smp_rmb();
      // Ensure that the data in page 0-2048 is up-to-date.

                               // New buffered write 2048 from 2048
                               ext4_buffered_write_iter
                                generic_perform_write
                                 copy_page_from_iter_atomic
                                 ext4_da_write_end
                                  ext4_da_do_write_end
                                   block_write_end
                                    __block_commit_write
                                     folio_mark_uptodate
                                      smp_wmb()
                                      set_bit(PG_uptodate, folio_flags)
                                   i_size_write // 4096
                                   unlock_page(page)

   isize = i_size_read(inode) // 4096
   // Read the latest isize 4096, but without smp_rmb(), there may be
   // Load-Load disorder resulting in the data in the 2048-4096 range
   // in the page is not up-to-date.
   copy_page_to_iter
   // copyout 4096

In the concurrency above, we read the updated i_size, but there is no read
barrier to ensure that the data in the page is the same as the i_size at
this point, so we may copy the unsynchronized page out.  Hence adding the
missing read memory barrier to fix this.

This is a Load-Load reordering issue, which only occurs on some weak
mem-ordering architectures (e.g.  ARM64, ALPHA), but not on strong
mem-ordering architectures (e.g.  X86).  And theoretically the problem
doesn't only happen on ext4, filesystems that call filemap_read() but
don't hold inode lock (e.g.  btrfs, f2fs, ubifs ...) will have this
problem, while filesystems with inode lock (e.g.  xfs, nfs) won't have
this problem.

Link: https://lkml.kernel.org/r/20231213062324.739009-1-libaokun1@huawei.com
Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: yangerkun <yangerkun@huawei.com>
Cc: Yu Kuai <yukuai3@huawei.com>
Cc: Zhang Yi <yi.zhang@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/filemap.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2745,6 +2745,15 @@ ssize_t filemap_read(struct kiocb *iocb,
 		end_offset = min_t(loff_t, isize, iocb->ki_pos + iter->count);
 
 		/*
+		 * Pairs with a barrier in
+		 * block_write_end()->mark_buffer_dirty() or other page
+		 * dirtying routines like iomap_write_end() to ensure
+		 * changes to page contents are visible before we see
+		 * increased inode size.
+		 */
+		smp_rmb();
+
+		/*
 		 * Once we start copying data, we don't want to be touching any
 		 * cachelines that might be contended:
 		 */


