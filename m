Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019599;
	b=rOoRNz2jVt1nh7Y8YRJzRca89LpcCBRkwuv4DqmA9xuCIZXKExcDaHLyteFUcq+kErJv
	 yOBnroGRwBiV45bTctq/tAYqYG53KawsrcowvW4WyX0+aWy3B1+JI4SPovIlSVJJ8p5OI
	 YT6YjI/gBJGP29CIqnGrGnJrb3j0jEC4lcNZlDg78jxVXkZB6haEAA34zUIazipWb5xiT
	 xVgsApoXDVsBK75m2yBbr9LQ21hw6JCWOeirFsL1VjDxptPFjTZl9BOZIXVLIcNKF0CnF
	 WfpQSWZxj+7SVKe049VWcK8Zocgh1vShGqYe/ehbbdzyuQSZBE7v6+TL6asAMixiz/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019599;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PsIt3tz9oPxKrILnUb44QelNT9/FUO7suW1pfTe2HME=;
	b=TXPjAd7MbGR7HZcvlAHVBZlDjxF1Cs4Ae01zqDVH+ggErt+BAgtu85RCOE0hGL8RS/v7
	 sv1t2JRT0O8A0Dofu9nMLsppQAyJsU7giYFROXM4/CP5dlVj5z611Zs6JrdsrD0F2Uz+0
	 0dd6cDsiZE6S8ffMQ3zcZCbnhZr3BMjTvdfVqWdtmPcKBnK+UaLt1rMPIV8CH4tUH5NXO
	 DhGhuKP7tdGVVxLu909VNU7mW79eEpL/4VQzMhPNZqRIVFkGZmKVcGTAjRxTBxqdMmd54
	 cnka7G7+FcRQxiWvFFQKPBLQhBEBuBY0MQk0MmGt1bGBsl3k+QRqItErSM8/5a8P+/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zCHZ8A8i;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31F35606A334;
	Wed, 18 Nov 2026 16:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zCHZ8A8i
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F9FD1F000C6;
	Wed, 18 Nov 2026 16:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019599;
	bh=PsIt3tz9oPxKrILnUb44QelNT9/FUO7suW1pfTe2HME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zCHZ8A8i/MLGfASGRCa3LvPI5vtXcj9Yp2HCXZOa7QjEsUDAHJ57A2iToT75sbbx1
	 3s3ATSD8zaZvXsTR4w03ohXwIAOHBw9asATf0j95QeALK7gaF23Q31RnJ3sZqYHP32
	 lCdqGlHrY+iT8Nw/WPJ7RHJSJIK3HP3OBDz119zQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongling Zeng <zenghongling@kylinos.cn>,
	David Sterba <dsterba@suse.com>,
	Qu Wenruo <wqu@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1652/2651] btrfs: refactor read_key_bytes() to remove the dest_folio parameter
Date: Wed, 18 Nov 2026 15:48:12 +0100
Message-ID: <20261118150347.250137565@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit fdf56b9d03d475881d73b75afbdbe4058db04ffc ]

The function read_key_bytes() have 3 call sites:

- For BTRFS_VERITY_DESC_ITEM_KEY offset 0 inside btrfs_get_verity_descriptor()
- For BTRFS_VERITY_DESC_ITEM_KEY offset 1 inside btrfs_get_verity_descriptor()
  Those are to read the description items, which are pretty small with
  fixed item size.

  Those call sites do not utilize the @dest_folio parameter.

- For btrfs_read_merkle_tree_page()
  This is to read the BTRFS_VERITY_MERKLE_ITEM_KEY, which can be pretty
  large and split into multiple items.

  This is the only call site utilizing the @dest_folio parameter.

Just for the only btrfs_read_merkle_tree_page() call site, we have a
complex scheme for @dest and @dest_folio parameters.
Since @dest can be NULL, it means if we pass @dest as NULL, then no
matter if @dest_folio is provided, the merkle data will not be loaded
into that @dest_folio.

This can lead to a bug where a highmem folio is not mapped, then we pass
folio_address(folio), which is NULL, into read_key_bytes(), causing no
data to be written into @dest_folio.

To address the complex scheme between @dest and @dest_folio, remove the
@dest_folio parameter completely, and let the only caller to map the
folio and pass the mapped kernel address into read_key_bytes() instead.

This not only reduces the parameter list, but also make it much clear on
the @dest parameter handling.
The only downside is a longer duration of locally mapped page, but this
should still be fine, as kmap_local_folio() can survive context switch.

Reported-by: Hongling Zeng <zenghongling@kylinos.cn>
Link: https://lore.kernel.org/linux-btrfs/20260817022012.19658-1-zenghongling@kylinos.cn/
Fixes: 146054090b08 ("btrfs: initial fsverity support")
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/verity.c | 31 ++++++++++++++-----------------
 1 file changed, 14 insertions(+), 17 deletions(-)

diff --git a/fs/btrfs/verity.c b/fs/btrfs/verity.c
index 59ee70bd2374f..c29d92c3bbc3e 100644
--- a/fs/btrfs/verity.c
+++ b/fs/btrfs/verity.c
@@ -286,21 +286,17 @@ static int write_key_bytes(struct btrfs_inode *inode, u8 key_type, u64 offset,
  * @dest:       Buffer to read into. This parameter has slightly tricky
  *              semantics.  If it is NULL, the function will not do any copying
  *              and will just return the size of all the items up to len bytes.
- *              If dest_page is passed, then the function will kmap_local the
- *              page and ignore dest, but it must still be non-NULL to avoid the
- *              counting-only behavior.
  * @len:        length in bytes to read
- * @dest_folio: copy into this folio instead of the dest buffer
  *
  * Helper function to read items from the btree.  This returns the number of
  * bytes read or < 0 for errors.  We can return short reads if the items don't
  * exist on disk or aren't big enough to fill the desired length.  Supports
- * reading into a provided buffer (dest) or into the page cache
+ * reading into a provided buffer (dest).
  *
  * Returns number of bytes read or a negative error code on failure.
  */
 static int read_key_bytes(struct btrfs_inode *inode, u8 key_type, u64 offset,
-			  char *dest, u64 len, struct folio *dest_folio)
+			  char *dest, u64 len)
 {
 	BTRFS_PATH_AUTO_FREE(path);
 	struct btrfs_root *root = inode->root;
@@ -320,7 +316,11 @@ static int read_key_bytes(struct btrfs_inode *inode, u8 key_type, u64 offset,
 	if (!path)
 		return -ENOMEM;
 
-	if (dest_folio)
+	/*
+	 * Merkle items can be large and split across multiple items, so enable
+	 * readahead for such cases.
+	 */
+	if (key_type == BTRFS_VERITY_MERKLE_ITEM_KEY)
 		path->reada = READA_FORWARD;
 
 	key.objectid = btrfs_ino(inode);
@@ -364,7 +364,7 @@ static int read_key_bytes(struct btrfs_inode *inode, u8 key_type, u64 offset,
 				break;
 		}
 
-		/* desc = NULL to just sum all the item lengths */
+		/* dest == NULL to just sum all the item lengths */
 		if (!dest)
 			copy_end = item_end;
 		else
@@ -377,16 +377,10 @@ static int read_key_bytes(struct btrfs_inode *inode, u8 key_type, u64 offset,
 		copy_offset = offset - key.offset;
 
 		if (dest) {
-			if (dest_folio)
-				kaddr = kmap_local_folio(dest_folio, 0);
-
 			data = btrfs_item_ptr(leaf, path->slots[0], void);
 			read_extent_buffer(leaf, kaddr + dest_offset,
 					   (unsigned long)data + copy_offset,
 					   copy_bytes);
-
-			if (dest_folio)
-				kunmap_local(kaddr);
 		}
 
 		offset += copy_bytes;
@@ -678,7 +672,7 @@ int btrfs_get_verity_descriptor(struct inode *inode, void *buf, size_t buf_size)
 
 	memset(&item, 0, sizeof(item));
 	ret = read_key_bytes(BTRFS_I(inode), BTRFS_VERITY_DESC_ITEM_KEY, 0,
-			     (char *)&item, sizeof(item), NULL);
+			     (char *)&item, sizeof(item));
 	if (ret < 0)
 		return ret;
 
@@ -695,7 +689,7 @@ int btrfs_get_verity_descriptor(struct inode *inode, void *buf, size_t buf_size)
 		return -ERANGE;
 
 	ret = read_key_bytes(BTRFS_I(inode), BTRFS_VERITY_DESC_ITEM_KEY, 1,
-			     buf, buf_size, NULL);
+			     buf, buf_size);
 	if (ret < 0)
 		return ret;
 	if (ret != true_size)
@@ -721,6 +715,7 @@ static struct page *btrfs_read_merkle_tree_page(struct inode *inode,
 	struct folio *folio;
 	u64 off = (u64)index << PAGE_SHIFT;
 	loff_t merkle_pos = merkle_file_pos(inode);
+	void *kaddr;
 	int ret;
 
 	if (merkle_pos < 0)
@@ -764,6 +759,7 @@ static struct page *btrfs_read_merkle_tree_page(struct inode *inode,
 	}
 
 read_folio:
+	kaddr = kmap_local_folio(folio, 0);
 	/*
 	 * Merkle item keys are indexed from byte 0 in the merkle tree.
 	 * They have the form:
@@ -771,7 +767,8 @@ static struct page *btrfs_read_merkle_tree_page(struct inode *inode,
 	 * [ inode objectid, BTRFS_MERKLE_ITEM_KEY, offset in bytes ]
 	 */
 	ret = read_key_bytes(BTRFS_I(inode), BTRFS_VERITY_MERKLE_ITEM_KEY, off,
-			     folio_address(folio), PAGE_SIZE, folio);
+			     kaddr, PAGE_SIZE);
+	kunmap_local(kaddr);
 	if (ret < 0) {
 		folio_unlock(folio);
 		folio_put(folio);
-- 
2.53.0



