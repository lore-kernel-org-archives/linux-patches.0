Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D05C533CC7;
	Fri, 24 Nov 2023 18:45:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YCazpFaK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED4BDC433C8;
	Fri, 24 Nov 2023 18:45:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700851536;
	bh=Fpi7rcjoGI9rMJwGMFUYo354WK/+N3f3s/wH7QueHHM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YCazpFaKqATz4h5HbDvrU5yNpcN/2ljp+vnaBeonwt9P9kHvSSaH90EI7RlrTRxob
	 H+5U8jiwYusNtxqN9x7OJIlF+vI3qgCYPaM1vbGU+h4uJPvyfZIFIpyMR3JTh/KOsy
	 UMNukSejTf92fk82ma3n7H1ewB2Uy88SBfntv60Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	stable@kernel.org,
	Jan Kara <jack@suse.cz>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 6.5 462/491] ext4: mark buffer new if it is unwritten to avoid stale data exposure
Date: Fri, 24 Nov 2023 17:51:38 +0000
Message-ID: <20231124172038.503928374@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172024.664207345@linuxfoundation.org>
References: <20231124172024.664207345@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ojaswin Mujoo <ojaswin@linux.ibm.com>

commit 2cd8bdb5efc1e0d5b11a4b7ba6b922fd2736a87f upstream.

** Short Version **

In ext4 with dioread_nolock, we could have a scenario where the bh returned by
get_blocks (ext4_get_block_unwritten()) in __block_write_begin_int() has
UNWRITTEN and MAPPED flag set. Since such a bh does not have NEW flag set we
never zero out the range of bh that is not under write, causing whatever stale
data is present in the folio at that time to be written out to disk. To fix this
mark the buffer as new, in case it is unwritten, in ext4_get_block_unwritten().

** Long Version **

The issue mentioned above was resulting in two different bugs:

1. On block size < page size case in ext4, generic/269 was reliably
failing with dioread_nolock. The state of the write was as follows:

  * The write was extending i_size.
  * The last block of the file was fallocated and had an unwritten extent
  * We were near ENOSPC and hence we were switching to non-delayed alloc
    allocation.

In this case, the back trace that triggers the bug is as follows:

  ext4_da_write_begin()
    /* switch to nodelalloc due to low space */
    ext4_write_begin()
      ext4_should_dioread_nolock() // true since mount flags still have delalloc
      __block_write_begin(..., ext4_get_block_unwritten)
        __block_write_begin_int()
          for(each buffer head in page) {
            /* first iteration, this is bh1 which contains i_size */
            if (!buffer_mapped)
              get_block() /* returns bh with only UNWRITTEN and MAPPED */
            /* second iteration, bh2 */
              if (!buffer_mapped)
                get_block() /* we fail here, could be ENOSPC */
          }
          if (err)
            /*
             * this would zero out all new buffers and mark them uptodate.
             * Since bh1 was never marked new, we skip it here which causes
             * the bug later.
             */
            folio_zero_new_buffers();
      /* ext4_wrte_begin() error handling */
      ext4_truncate_failed_write()
        ext4_truncate()
          ext4_block_truncate_page()
            __ext4_block_zero_page_range()
              if(!buffer_uptodate())
                ext4_read_bh_lock()
                  ext4_read_bh() -> ... ext4_submit_bh_wbc()
                    BUG_ON(buffer_unwritten(bh)); /* !!! */

2. The second issue is stale data exposure with page size >= blocksize
with dioread_nolock. The conditions needed for it to happen are same as
the previous issue ie dioread_nolock around ENOSPC condition. The issue
is also similar where in __block_write_begin_int() when we call
ext4_get_block_unwritten() on the buffer_head and the underlying extent
is unwritten, we get an unwritten and mapped buffer head. Since it is
not new, we never zero out the partial range which is not under write,
thus writing stale data to disk. This can be easily observed with the
following reproducer:

 fallocate -l 4k testfile
 xfs_io -c "pwrite 2k 2k" testfile
 # hexdump output will have stale data in from byte 0 to 2k in testfile
 hexdump -C testfile

NOTE: To trigger this, we need dioread_nolock enabled and write happening via
ext4_write_begin(), which is usually used when we have -o nodealloc. Since
dioread_nolock is disabled with nodelalloc, the only alternate way to call
ext4_write_begin() is to ensure that delayed alloc switches to nodelalloc ie
ext4_da_write_begin() calls ext4_write_begin(). This will usually happen when
ext4 is almost full like the way generic/269 was triggering it in Issue 1 above.
This might make the issue harder to hit. Hence, for reliable replication, I used
the below patch to temporarily allow dioread_nolock with nodelalloc and then
mount the disk with -o nodealloc,dioread_nolock. With this you can hit the stale
data issue 100% of times:

@@ -508,8 +508,8 @@ static inline int ext4_should_dioread_nolock(struct inode *inode)
  if (ext4_should_journal_data(inode))
    return 0;
  /* temporary fix to prevent generic/422 test failures */
- if (!test_opt(inode->i_sb, DELALLOC))
-   return 0;
+ // if (!test_opt(inode->i_sb, DELALLOC))
+ //  return 0;
  return 1;
 }

After applying this patch to mark buffer as NEW, both the above issues are
fixed.

Signed-off-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Cc: stable@kernel.org
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Link: https://lore.kernel.org/r/d0ed09d70a9733fbb5349c5c7b125caac186ecdf.1695033645.git.ojaswin@linux.ibm.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/inode.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -789,10 +789,22 @@ int ext4_get_block(struct inode *inode,
 int ext4_get_block_unwritten(struct inode *inode, sector_t iblock,
 			     struct buffer_head *bh_result, int create)
 {
+	int ret = 0;
+
 	ext4_debug("ext4_get_block_unwritten: inode %lu, create flag %d\n",
 		   inode->i_ino, create);
-	return _ext4_get_block(inode, iblock, bh_result,
+	ret = _ext4_get_block(inode, iblock, bh_result,
 			       EXT4_GET_BLOCKS_CREATE_UNWRIT_EXT);
+
+	/*
+	 * If the buffer is marked unwritten, mark it as new to make sure it is
+	 * zeroed out correctly in case of partial writes. Otherwise, there is
+	 * a chance of stale data getting exposed.
+	 */
+	if (ret == 0 && buffer_unwritten(bh_result))
+		set_buffer_new(bh_result);
+
+	return ret;
 }
 
 /* Maximum number of blocks we map for direct IO at once. */


