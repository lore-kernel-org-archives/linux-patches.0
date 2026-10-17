Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15F17374E60;
	Sat, 17 Oct 2026 17:41:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258888; cv=none; b=dEUA6OL1faM/7VYdMiLCgStx3WgxiriUhU+TVsQ5uBwUdV+gQXxW2jGCVMBi/n+bdJqLhjTC+MCPSAqmJDlDjBbNi5tR/D8p+NllVAABAG1NVXCW34GOUFAjlZN/td4gC8LsMffU4/59WGkdv4uaiJYmhDNngHpL6a9l3SeGHDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258888; c=relaxed/simple;
	bh=zASKD1lu4ESVWStmvt6UfhjObPTu/FADjn0efVACQVE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aAkR8YwmI5idtHIPVU6omT8GkHVf9/MTVLYQgMi2G04NkKzuz/jCxCJOred/q5shFcFxyMufTNf24FPzGFl4ze4L5mNMrqTjqcgv/kSPK+iA4ZifWjDWZbxs/rjTyMESUX+NRZknYOTdvSlZGlkCo3FWg5SmOELc4wW0vqfJrkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1WlTSnRb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1WlTSnRb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EE801F000C4;
	Sat, 17 Oct 2026 17:41:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258887;
	bh=4BxiqwrVNTsnDVXLSxfHLHv/IUzJQeXigWFXFvKcQew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1WlTSnRb6xeXVyQLcQRblfspNhwPAHPcS8ZNR78cEyvZIq6N5FyMYs8zMx42VkBm6
	 BOR7v8zQ3MWUdCjlbYZGoJGNS2djxDpAxvj0GSYPaHJUoGzIGzdji6CR2w2AcIzS11
	 ED8lZdUcIof38EReP3V9w3BV6BF6Fldr0dOZECbQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikhail Lobanov <m.lobanov@rosa.ru>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1033/1674] f2fs: read COW data with the original inode during atomic write
Date: Sat, 17 Oct 2026 17:55:05 +0200
Message-ID: <20261017160457.647569126@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 5c47b0eed887d..b0c633c5deb75 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -3551,7 +3551,7 @@ static int __reserve_data_block(struct inode *inode, pgoff_t index,
 
 static int prepare_atomic_write_begin(struct f2fs_sb_info *sbi,
 			struct page *page, loff_t pos, unsigned int len,
-			block_t *blk_addr, bool *node_changed, bool *use_cow)
+			block_t *blk_addr, bool *node_changed)
 {
 	struct inode *inode = page->mapping->host;
 	struct inode *cow_inode = F2FS_I(inode)->cow_inode;
@@ -3566,14 +3566,14 @@ static int prepare_atomic_write_begin(struct f2fs_sb_info *sbi,
 
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
@@ -3606,7 +3606,6 @@ static int f2fs_write_begin(struct file *file, struct address_space *mapping,
 	struct page *page = NULL;
 	pgoff_t index = ((unsigned long long) pos) >> PAGE_SHIFT;
 	bool need_balance = false;
-	bool use_cow = false;
 	block_t blkaddr = NULL_ADDR;
 	int err = 0;
 
@@ -3666,7 +3665,7 @@ static int f2fs_write_begin(struct file *file, struct address_space *mapping,
 
 	if (f2fs_is_atomic_file(inode))
 		err = prepare_atomic_write_begin(sbi, page, pos, len,
-					&blkaddr, &need_balance, &use_cow);
+					&blkaddr, &need_balance);
 	else
 		err = prepare_write_begin(sbi, page, pos, len,
 					&blkaddr, &need_balance);
@@ -3706,9 +3705,15 @@ static int f2fs_write_begin(struct file *file, struct address_space *mapping,
 			f2fs_handle_error(sbi, ERROR_INVALID_BLKADDR);
 			goto fail;
 		}
-		err = f2fs_submit_page_read(use_cow ?
-				F2FS_I(inode)->cow_inode : inode, page,
-				blkaddr, 0, true);
+		/*
+		 * Although the block may be stored in the COW inode, the folio
+		 * belongs to @inode and its data was encrypted (or not) using
+		 * @inode's context (see f2fs_encrypt_one_page()).  Read with
+		 * @inode so the post-read decryption decision matches the
+		 * folio's owner; otherwise an unencrypted @inode whose COW inode
+		 * is encrypted hits a NULL ->i_crypt_info on decryption.
+		 */
+		err = f2fs_submit_page_read(inode, page, blkaddr, 0, true);
 		if (err)
 			goto fail;
 
-- 
2.53.0



