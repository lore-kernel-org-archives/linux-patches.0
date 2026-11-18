Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041250;
	b=LYSxIST3WjtqJw3Mi/nSNtTDFUNYGU1CQJwMbk5Dm5g+vrOYh/HfcijBWfDvOZTLn6Vy
	 Xx/sHfYY4SWlJWRdHz+dQE7vkFHRWE5BxW+CCSmkfHfGDJ3vqi66JR8c14f3R4ql0ckRN
	 zsNto67YLZYq1Wfig2t4Tuii79KOB06kh8t19SEIamu7Lw5EbPTlOXTEpEpPPRpxvL+eI
	 93yh89Y/u+s5LPqjCrhKgF7yDgp5VaDFpIpkcQiLq6QpBVgrAzabC9xv0Gl0HrU4x0uLs
	 HI4P6/5DrmNUu1pkLHWl57704YChWtgal7lsQ9o+scIug2E2HFhqdtkZe8pJqxE39pA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041250;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5qU5t1vmukeSLr5p/rL1qtF+qgExBwdl2GmXBr/EEL8=;
	b=K7kFOdq/T7uc5MxWggYyJEFrbJEWzxHpxtSZEbOjpmn7k89ynoFuWx3UmRgmD4wBIFtl
	 T0UF3+l0B40e9W5I52qAwLS8b8fEGz7NDLsucJqQ3S54XDRdcSr2ET98wHgFD+bi2vlb/
	 bD3N1ErDbtOKQUGIx5isWeFuhEbXtiLQDPQCw8xFUlyBFi2oKcBTy11BI4bMuiCz7vK5I
	 xkQYEOfVpHeLruiHsbGmZVXuY0J2jBtNCkbpndQBlUfOavoKOf2nqnRqaJiDdaiRLrkxj
	 aVNNPo3R8XBwsIKE9l7sWeasC9ejaFyIGeqPhXzuGeqCeSJ7Df6DaHN4qUJ/j6pTGkA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m28N9fk4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45308606A325;
	Wed, 18 Nov 2026 22:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m28N9fk4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92C291F000C4;
	Wed, 18 Nov 2026 22:34:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041250;
	bh=5qU5t1vmukeSLr5p/rL1qtF+qgExBwdl2GmXBr/EEL8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m28N9fk4FohNPPFzZqKmTfmr2sDD0bY2WwF4npEcKuDSgZPG/3apoJ5XZEKPwLocp
	 EAX5aVmEJkar3G97c83BFv0HwfqOKpct2sH9yKXSmwZ9F6Ag8+G5QE6U7jd5eIS4pz
	 K6zeynGVQfB/NJtScQFGAnrMlfuOksXjrKBdC8vc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Zetao <lizetao1@huawei.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2745/3318] btrfs: convert read_key_bytes() to take a folio
Date: Wed, 18 Nov 2026 15:56:07 +0100
Message-ID: <20261118150443.120165929@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Zetao <lizetao1@huawei.com>

[ Upstream commit 884937793db595928961397dd3ec2287b40371c6 ]

The old page API is being gradually replaced and converted to use folio
to improve code readability and avoid repeated conversion between page
and folio. Moreover, use kmap_local_folio() instead of kmap_local_page(),
which is more consistent with folio usage.

Signed-off-by: Li Zetao <lizetao1@huawei.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: fdf56b9d03d4 ("btrfs: refactor read_key_bytes() to remove the dest_folio parameter")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/verity.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/verity.c b/fs/btrfs/verity.c
index 73e1ded8e839a..ca0e2a45e18d7 100644
--- a/fs/btrfs/verity.c
+++ b/fs/btrfs/verity.c
@@ -285,7 +285,7 @@ static int write_key_bytes(struct btrfs_inode *inode, u8 key_type, u64 offset,
  *              page and ignore dest, but it must still be non-NULL to avoid the
  *              counting-only behavior.
  * @len:        length in bytes to read
- * @dest_page:  copy into this page instead of the dest buffer
+ * @dest_folio: copy into this folio instead of the dest buffer
  *
  * Helper function to read items from the btree.  This returns the number of
  * bytes read or < 0 for errors.  We can return short reads if the items don't
@@ -295,7 +295,7 @@ static int write_key_bytes(struct btrfs_inode *inode, u8 key_type, u64 offset,
  * Returns number of bytes read or a negative error code on failure.
  */
 static int read_key_bytes(struct btrfs_inode *inode, u8 key_type, u64 offset,
-			  char *dest, u64 len, struct page *dest_page)
+			  char *dest, u64 len, struct folio *dest_folio)
 {
 	struct btrfs_path *path;
 	struct btrfs_root *root = inode->root;
@@ -315,7 +315,7 @@ static int read_key_bytes(struct btrfs_inode *inode, u8 key_type, u64 offset,
 	if (!path)
 		return -ENOMEM;
 
-	if (dest_page)
+	if (dest_folio)
 		path->reada = READA_FORWARD;
 
 	key.objectid = btrfs_ino(inode);
@@ -372,15 +372,15 @@ static int read_key_bytes(struct btrfs_inode *inode, u8 key_type, u64 offset,
 		copy_offset = offset - key.offset;
 
 		if (dest) {
-			if (dest_page)
-				kaddr = kmap_local_page(dest_page);
+			if (dest_folio)
+				kaddr = kmap_local_folio(dest_folio, 0);
 
 			data = btrfs_item_ptr(leaf, path->slots[0], void);
 			read_extent_buffer(leaf, kaddr + dest_offset,
 					   (unsigned long)data + copy_offset,
 					   copy_bytes);
 
-			if (dest_page)
+			if (dest_folio)
 				kunmap_local(kaddr);
 		}
 
@@ -768,7 +768,7 @@ static struct page *btrfs_read_merkle_tree_page(struct inode *inode,
 	 * [ inode objectid, BTRFS_MERKLE_ITEM_KEY, offset in bytes ]
 	 */
 	ret = read_key_bytes(BTRFS_I(inode), BTRFS_VERITY_MERKLE_ITEM_KEY, off,
-			     folio_address(folio), PAGE_SIZE, &folio->page);
+			     folio_address(folio), PAGE_SIZE, folio);
 	if (ret < 0) {
 		folio_unlock(folio);
 		folio_put(folio);
-- 
2.53.0



