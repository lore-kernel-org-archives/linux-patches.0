Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049599;
	b=cNzjoBVXvinCllgcFqRAnNYyGUpYy+Pivg1WQDIwuZzuD7UJFYwp7F6+dfJ8LKY79yH5
	 JCKfOekTybWb8N/fDh20tv086VBLHKJJJ+qXBZ3h3nKItxHa09WEV+8qv+dyzV06mlZxf
	 Bala96F6v4FFRW1m4+isHREBwUUVmWopaUly2w7abVv5TvErUwIJMff9NBkv36BPdeqWn
	 0VtBjL8mQ6fO5gMKxO0UR1hh3egHLBBYRDcPNdxXKsa49PA9C3uFz7lgYYGpzemeZ0Xtu
	 P/fH4zWg6zJgy7DTlEdQB5coF5YgMcXONWzYfQ3JfhOE7568A7TynTrEgUFaOPd9b6g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049599;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=69wAvyWLGxOWb0b96qhuknlcwWBl6gLdNRp4ognqABQ=;
	b=1ebC7yH72kDRhEiUR2DYRIz5Kl5wecULZ10MYiMP67JgrKFtBE3OvKTHCvNegars3mpA
	 flT9h+4HfFsx3yBr7eWD+6OX0zBAy3Oc38wY9pJmKKPaxrT7PEXXuYK8/tin8nPHCKIws
	 hzzrMlDjAPZfzKoCOczEfds8OCUrVUk2eqo6NDKazPjHyvcjS638HTyNhm7zpLE/dS8mm
	 4GZRxsO5oSa5pz7fmMprxXyLrIQdwt7TGpKuywzk4aksj7f7k0aVLoUxoeqG/AU09J4ix
	 nkKehDXnxQWY+0tME/pwQ19OY9eOz+pNDkggMJk9OXNfVVfDiyi4qBNzQtsQgKTuWVA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MITBJKZs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FDD3606A320;
	Thu, 19 Nov 2026 00:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MITBJKZs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9D3B1F000C4;
	Thu, 19 Nov 2026 00:53:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049599;
	bh=69wAvyWLGxOWb0b96qhuknlcwWBl6gLdNRp4ognqABQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MITBJKZs8hXmwDFNgq1jhoiYCON0cjv6O5Y0aBMAKLy7A1et0+IZOIVTSZGiijgi2
	 ITj49eCy7ZgZzXzZiB0labxedRljPRpxc/ZYw/BWUMtXFiExGfTgVlqVBbdb5XvRNJ
	 IimpLw5zYIBXzmCCQwmDRGb+rP/SqAuk8mgYTSIQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Zetao <lizetao1@huawei.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2368/2857] btrfs: convert read_key_bytes() to take a folio
Date: Wed, 18 Nov 2026 15:56:42 +0100
Message-ID: <20261118150326.782519368@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index abd76905daa00..e2507dbaabbfe 100644
--- a/fs/btrfs/verity.c
+++ b/fs/btrfs/verity.c
@@ -279,7 +279,7 @@ static int write_key_bytes(struct btrfs_inode *inode, u8 key_type, u64 offset,
  *              page and ignore dest, but it must still be non-NULL to avoid the
  *              counting-only behavior.
  * @len:        length in bytes to read
- * @dest_page:  copy into this page instead of the dest buffer
+ * @dest_folio: copy into this folio instead of the dest buffer
  *
  * Helper function to read items from the btree.  This returns the number of
  * bytes read or < 0 for errors.  We can return short reads if the items don't
@@ -289,7 +289,7 @@ static int write_key_bytes(struct btrfs_inode *inode, u8 key_type, u64 offset,
  * Returns number of bytes read or a negative error code on failure.
  */
 static int read_key_bytes(struct btrfs_inode *inode, u8 key_type, u64 offset,
-			  char *dest, u64 len, struct page *dest_page)
+			  char *dest, u64 len, struct folio *dest_folio)
 {
 	struct btrfs_path *path;
 	struct btrfs_root *root = inode->root;
@@ -309,7 +309,7 @@ static int read_key_bytes(struct btrfs_inode *inode, u8 key_type, u64 offset,
 	if (!path)
 		return -ENOMEM;
 
-	if (dest_page)
+	if (dest_folio)
 		path->reada = READA_FORWARD;
 
 	key.objectid = btrfs_ino(inode);
@@ -366,15 +366,15 @@ static int read_key_bytes(struct btrfs_inode *inode, u8 key_type, u64 offset,
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
 
@@ -757,7 +757,7 @@ static struct page *btrfs_read_merkle_tree_page(struct inode *inode,
 	 * [ inode objectid, BTRFS_MERKLE_ITEM_KEY, offset in bytes ]
 	 */
 	ret = read_key_bytes(BTRFS_I(inode), BTRFS_VERITY_MERKLE_ITEM_KEY, off,
-			     folio_address(folio), PAGE_SIZE, &folio->page);
+			     folio_address(folio), PAGE_SIZE, folio);
 	if (ret < 0) {
 		folio_put(folio);
 		return ERR_PTR(ret);
-- 
2.53.0



