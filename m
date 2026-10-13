Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9BC24EE864;
	Tue, 13 Oct 2026 12:10:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893449; cv=none; b=RbE/3tE/ahU52ddN7ec47dKmUASMAFEoChDo04vdMONyRxSE06bodpn3tGFUlFS6bj6WzMxPPpkSIxHS7UxY5jKLwaARFg88JsCsm8H2wEz76MiFB4TuufE4tzYCGxb7O6MilngftPeGmPl3Nx4Tx7qDMPVPg6F7Rd2+712/enY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893449; c=relaxed/simple;
	bh=Vba7a5LlfRseXrwH+Dssn3aJ0geBIpKUEJcTQJJTz2c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I+P8y7j+Ok2V9OHX3s4DQ8a6L8Y6kq+dtxjPaA8AV52wedJNGXUuWSxvfZskDUJS9VGW4LWw4QA4iKl/qZteSOqjM+oEc/4OI0KxMaOxRN3/TH+sJDhn2O//BHc0DskqLzcNAlkNcJfUiSQUXfwBEj3yDBNFOzn/ihg5cLJP0As=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jkl8e3SV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jkl8e3SV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C7891F000FF;
	Tue, 13 Oct 2026 12:10:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893447;
	bh=rF33rtQq72+ccCgVwCh7fI+u+RdV00NFQiXYwujilZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jkl8e3SVhHSFxD4K7OowRLuKv9eO2BtGq3e9bYaqn6baEvaawOJsuoY5gvk/9EFwb
	 ePHXaKibO2jLsZfmJjjsgPdYpPty9+z5I4Fo41q0D65D/Lrn+mKhyGLk8lrWjRswDB
	 6Adxzm9wVBV6W2ylCOZ7AWcPPhAXfAfZij3Vh6H8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikhail Lobanov <m.lobanov@rosa.ru>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 229/621] f2fs: read COW data with the original inode during atomic write
Date: Tue, 13 Oct 2026 13:33:44 +0200
Message-ID: <20261013112926.292542412@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikhail Lobanov <m.lobanov@rosa.ru>

[ Upstream commit a41075acde0124d2f8a5f563068a5d63e8ffd57b ]

When updating an atomic-write file, f2fs_write_begin() may read the
previously written data back from the COW inode:
prepare_atomic_write_begin() locates the block in the COW inode and sets
use_cow, and the read bio is then built with the COW inode:

	f2fs_submit_page_read(use_cow ? F2FS_I(inode)->cow_inode : inode,
			      ...);

and f2fs_grab_read_bio() decides whether to schedule fs-layer decryption
(STEP_DECRYPT) for the bio based on that inode via
fscrypt_inode_uses_fs_layer_crypto().

However, the folio being filled belongs to the original inode
(folio->mapping->host == inode), and the data stored in the COW block was
encrypted (or left as plaintext) using the original inode's context, not
the COW inode's -- see f2fs_encrypt_one_page(), which keys off
fio->page->mapping->host.  fscrypt_decrypt_pagecache_blocks() likewise
operates on folio->mapping->host.

The COW inode is created as a tmpfile in the parent directory and inherits
its encryption policy from there.  With test_dummy_encryption the newly
created COW inode gets the dummy policy and becomes encrypted, while a
pre-existing regular file -- created before the policy applied, e.g.
already present in the on-disk image -- stays unencrypted.  The read
path then sets STEP_DECRYPT based on the encrypted COW inode and calls
fscrypt_decrypt_pagecache_blocks() on a folio whose host (the unencrypted
original inode) has a NULL ->i_crypt_info, dereferencing it:

  Oops: general protection fault, probably for non-canonical address ...
  KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
  RIP: 0010:fscrypt_decrypt_pagecache_blocks+0xa0/0x310
  Workqueue: f2fs_post_read_wq f2fs_post_read_work
  Call Trace:
   fscrypt_decrypt_bio+0x1eb/0x340
   f2fs_post_read_work+0xba/0x140
   process_one_work+0x91c/0x1a40
   worker_thread+0x677/0xe90
   kthread+0x2bc/0x3a0

The COW inode is only needed to locate the on-disk block, and that block
address is already resolved into @blkaddr by prepare_atomic_write_begin()
via __find_data_block(cow_inode, ...); f2fs_submit_page_read() then reads
from that physical @blkaddr directly, so the inode argument only selects
the post-read crypto context, not which block is fetched.  Reading with
@inode therefore returns the same (latest, not-yet-committed) COW data,
while making both the fs-layer decryption decision and the inline crypto
path use the correct (original inode's) key.

With the COW inode no longer used at the read site, the use_cow flag has no
remaining consumer; drop it from f2fs_write_begin() and
prepare_atomic_write_begin().

Fixes: 591fc34e1f98 ("f2fs: use cow inode data when updating atomic write")
Cc: stable@vger.kernel.org
Signed-off-by: Mikhail Lobanov <m.lobanov@rosa.ru>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/data.c | 27 ++++++++++++++++-----------
 1 file changed, 16 insertions(+), 11 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 05ab77446b716..3455565b82451 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -3562,7 +3562,7 @@ static int __reserve_data_block(struct inode *inode, pgoff_t index,
 
 static int prepare_atomic_write_begin(struct f2fs_sb_info *sbi,
 			struct folio *folio, loff_t pos, unsigned int len,
-			block_t *blk_addr, bool *node_changed, bool *use_cow)
+			block_t *blk_addr, bool *node_changed)
 {
 	struct inode *inode = folio->mapping->host;
 	struct inode *cow_inode = F2FS_I(inode)->cow_inode;
@@ -3577,14 +3577,14 @@ static int prepare_atomic_write_begin(struct f2fs_sb_info *sbi,
 
 	/* Look for the block in COW inode first */
 	err = __find_data_block(cow_inode, index, blk_addr);
-	if (err) {
+	if (err)
 		return err;
-	} else if (__is_valid_data_blkaddr(*blk_addr)) {
-		*use_cow = true;
+
+	if (__is_valid_data_blkaddr(*blk_addr))
 		return 0;
-	} else if (*blk_addr == NEW_ADDR) {
+
+	if (*blk_addr == NEW_ADDR)
 		cow_has_reserved_block = true;
-	}
 
 	if (is_inode_flag_set(inode, FI_ATOMIC_REPLACE))
 		goto reserve_block;
@@ -3619,7 +3619,6 @@ static int f2fs_write_begin(const struct kiocb *iocb,
 	struct folio *folio;
 	pgoff_t index = pos >> PAGE_SHIFT;
 	bool need_balance = false;
-	bool use_cow = false;
 	block_t blkaddr = NULL_ADDR;
 	int err = 0;
 
@@ -3681,7 +3680,7 @@ static int f2fs_write_begin(const struct kiocb *iocb,
 
 	if (f2fs_is_atomic_file(inode))
 		err = prepare_atomic_write_begin(sbi, folio, pos, len,
-					&blkaddr, &need_balance, &use_cow);
+					&blkaddr, &need_balance);
 	else
 		err = prepare_write_begin(sbi, folio, pos, len,
 					&blkaddr, &need_balance);
@@ -3721,9 +3720,15 @@ static int f2fs_write_begin(const struct kiocb *iocb,
 			err = -EFSCORRUPTED;
 			goto put_folio;
 		}
-		f2fs_submit_page_read(use_cow ?
-				F2FS_I(inode)->cow_inode : inode,
-				folio, blkaddr, 0, true);
+		/*
+		 * Although the block may be stored in the COW inode, the folio
+		 * belongs to @inode and its data was encrypted (or not) using
+		 * @inode's context (see f2fs_encrypt_one_page()).  Read with
+		 * @inode so the post-read decryption decision matches the
+		 * folio's owner; otherwise an unencrypted @inode whose COW inode
+		 * is encrypted hits a NULL ->i_crypt_info on decryption.
+		 */
+		f2fs_submit_page_read(inode, folio, blkaddr, 0, true);
 
 		folio_lock(folio);
 		if (unlikely(folio->mapping != mapping)) {
-- 
2.53.0



