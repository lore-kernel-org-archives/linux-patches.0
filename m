Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F6FC356742;
	Sat, 12 Sep 2026 09:13:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204435; cv=none; b=tFyocTNmyYSOyBElcu6G+H69oOm/TbZF+QGTwfSssCfZ6flcCEQYjIx0q3ODTKKxF5w/3hcxXD2HuV0SmBy3bwjVd9UdrhvVxdbWcw86GzaAdxVV0yL14ZciplDHHxx8Q9rQW0Wu/k0Vl9a7PbXsIjJSd7NIxt1sFknsFAP1rqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204435; c=relaxed/simple;
	bh=18CNCiaa8gPFkzomC6UwfKN6G3NFqO2fgL/MuE/orZw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WKPeYybBC/GObIIf7hJmwLAS8+uCRc4zrehW6vr5XAe1vTgDUbJ275Hb2s6HA+KzXtfI0wbt42oE+pixSCsclzdwcyj65LbEbLj6CMtulYWAp2AWzJ10J5Y5A2lZtrZuUtKpo51KspnHpkjcXDjgQiL/dm5o1adXAaT5ETFymvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eKQPTcZI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eKQPTcZI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BD4B1F000FF;
	Sat, 12 Sep 2026 09:13:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204434;
	bh=gxW9fvw0Oy51aem6Cin4mw5Lpr8s1CZzVBKplfug3gk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eKQPTcZIpiO9ZqCsX7opzeQ6TC1MO+DGyWTPknsx1fpdfF6RLc5YUnDUog1qa7gcR
	 1vr2oSi3b6x8C2MtT4DjmwO3f1F2Ez2U7qagoCzTySSgx+awBTc1hTwQ1gDZg2WLnc
	 Jky34SMunxF8uknY4/EOxfFlEBDIjhBstx3VsWyI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	yi <691464208@qq.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1613/1815] ntfs: allow index root relocation
Date: Sat, 12 Sep 2026 08:56:03 +0200
Message-ID: <20260912065726.859915927@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 9badcfb91bc3bd5edb530fbcdd16f25d66640f33 ]

Allow a resident attribute record to move to an extent MFT record when the
base record needs room for an attribute list. Retry the root conversion
after creating the list, but do not relocate a root that is already
external.

Roll the root back to the base record if persisting the attribute list
fails, and free extent MFT records left empty by relocation or rollback.
Also preserve bitmap allocation errors in index operations.

Fixes: af0db57d4293 ("ntfs: update inode operations")
Reported-by: yi <691464208@qq.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs/attrib.c |  7 +++-
 fs/ntfs/index.c  | 85 +++++++++++++++++++++++++++++++++++++++---------
 fs/ntfs/inode.c  | 64 ++++++++++++++++++++++++++++++++++--
 fs/ntfs/inode.h  |  1 +
 4 files changed, 137 insertions(+), 20 deletions(-)

diff --git a/fs/ntfs/attrib.c b/fs/ntfs/attrib.c
index 0c147b99d4eea..b4c6137c037b6 100644
--- a/fs/ntfs/attrib.c
+++ b/fs/ntfs/attrib.c
@@ -3553,8 +3553,13 @@ int ntfs_attr_record_move_away(struct ntfs_attr_search_ctx *ctx, int extra)
 	unmap_mft_record(ni);
 
 	err = ntfs_attr_record_move_to(ctx, ni);
-	if (err)
+	if (err) {
 		ntfs_error(sb, "Couldn't move attribute to MFT record");
+		if (ntfs_mft_record_free(base_ni->vol, ni))
+			ntfs_error(sb, "Couldn't free empty MFT record");
+		else
+			ntfs_inode_close(ni);
+	}
 
 	return err;
 }
diff --git a/fs/ntfs/index.c b/fs/ntfs/index.c
index 409759eab55d3..8c8eb13859ab6 100644
--- a/fs/ntfs/index.c
+++ b/fs/ntfs/index.c
@@ -616,6 +616,31 @@ static struct index_root *ntfs_ir_lookup2(struct ntfs_inode *ni, __le16 *name, u
 	return ir;
 }
 
+static int ntfs_ir_move_to_base(struct ntfs_index_context *icx)
+{
+	struct ntfs_attr_search_ctx *ctx = NULL;
+	struct index_root *ir;
+	bool moved = false;
+	int ret = 0;
+
+	ir = ntfs_ir_lookup(icx->idx_ni, icx->name, icx->name_len, &ctx);
+	if (!ir)
+		return -ENOENT;
+
+	if (ctx->ntfs_ino->mft_no != icx->idx_ni->mft_no) {
+		ret = ntfs_attr_record_move_to(ctx, icx->idx_ni);
+		if (!ret) {
+			moved = true;
+			ret = ntfs_attrlist_update(icx->idx_ni);
+		}
+	}
+
+	ntfs_attr_put_search_ctx(ctx);
+	if (!ret && moved)
+		ret = ntfs_inode_free_empty_extents(icx->idx_ni);
+	return ret;
+}
+
 /*
  * Find a key in the index block.
  */
@@ -989,6 +1014,7 @@ static s64 ntfs_ibm_pos_to_vcn(struct ntfs_index_context *icx, s64 pos)
 static int ntfs_ibm_add(struct ntfs_index_context *icx)
 {
 	u8 bmp[8];
+	int ret;
 
 	ntfs_debug("Entering\n");
 
@@ -998,10 +1024,11 @@ static int ntfs_ibm_add(struct ntfs_index_context *icx)
 	 * AT_BITMAP must be at least 8 bytes.
 	 */
 	memset(bmp, 0, sizeof(bmp));
-	if (ntfs_attr_add(icx->idx_ni, AT_BITMAP, icx->name, icx->name_len,
-				bmp, sizeof(bmp))) {
+	ret = ntfs_attr_add(icx->idx_ni, AT_BITMAP, icx->name, icx->name_len,
+			    bmp, sizeof(bmp));
+	if (ret) {
 		ntfs_error(icx->idx_ni->vol->sb, "Failed to add AT_BITMAP");
-		return -EINVAL;
+		return ret;
 	}
 
 	return 0;
@@ -1074,6 +1101,7 @@ static s64 ntfs_ibm_get_free(struct ntfs_index_context *icx)
 {
 	u8 *bm;
 	int bit;
+	int ret;
 	s64 vcn, byte, size;
 
 	ntfs_debug("Entering\n");
@@ -1081,7 +1109,7 @@ static s64 ntfs_ibm_get_free(struct ntfs_index_context *icx)
 	bm = ntfs_attr_readall(icx->idx_ni, AT_BITMAP,  icx->name, icx->name_len,
 			&size);
 	if (!bm)
-		return (s64)-1;
+		return -EIO;
 
 	for (byte = 0; byte < size; byte++) {
 		if (bm[byte] == 255)
@@ -1099,10 +1127,12 @@ static s64 ntfs_ibm_get_free(struct ntfs_index_context *icx)
 out:
 	ntfs_debug("allocated vcn: %lld\n", vcn);
 
-	if (ntfs_ibm_set(icx, vcn))
-		vcn = (s64)-1;
+	ret = ntfs_ibm_set(icx, vcn);
 
 	kvfree(bm);
+	if (ret)
+		return ret;
+
 	return vcn;
 }
 
@@ -1275,7 +1305,7 @@ static int ntfs_ir_reparent(struct ntfs_index_context *icx)
 
 	new_ib_vcn = ntfs_ibm_get_free(icx);
 	if (new_ib_vcn < 0) {
-		ret = -EINVAL;
+		ret = (int)new_ib_vcn;
 		goto out;
 	}
 
@@ -1346,19 +1376,42 @@ static int ntfs_ir_reparent(struct ntfs_index_context *icx)
 	 * When there is no space to build a non-resident
 	 * index, we may have to move the root to an extent
 	 */
-	if ((ret == -ENOSPC) && (ctx->al_entry || !ntfs_inode_add_attrlist(icx->idx_ni))) {
-		ntfs_attr_put_search_ctx(ctx);
-		ctx = NULL;
-		ir = ntfs_ir_lookup(icx->idx_ni, icx->name, icx->name_len, &ctx);
-		if (ir && !ntfs_attr_record_move_away(ctx, ix_root_size -
-				le32_to_cpu(ctx->attr->data.resident.value_length))) {
-			if (ntfs_attrlist_update(ctx->base_ntfs_ino ?
-						 ctx->base_ntfs_ino : ctx->ntfs_ino))
+	if (ret == -ENOSPC) {
+		if (!ctx->al_entry) {
+			ret = ntfs_inode_add_attrlist(icx->idx_ni);
+			if (ret)
 				goto clear_bmp;
+
 			ntfs_attr_put_search_ctx(ctx);
 			ctx = NULL;
 			goto retry;
 		}
+
+		if (ctx->ntfs_ino->mft_no != icx->idx_ni->mft_no)
+			goto clear_bmp;
+
+		ret = ntfs_attr_record_move_away(ctx, ix_root_size -
+				le32_to_cpu(ctx->attr->data.resident.value_length));
+		if (ret)
+			goto clear_bmp;
+
+		ret = ntfs_attrlist_update(icx->idx_ni);
+		if (ret) {
+			int rollback_ret;
+
+			ntfs_attr_put_search_ctx(ctx);
+			ctx = NULL;
+			rollback_ret = ntfs_ir_move_to_base(icx);
+			if (rollback_ret)
+				ntfs_error(icx->idx_ni->vol->sb,
+					   "Failed to roll back INDEX_ROOT relocation: %d",
+					   rollback_ret);
+			goto clear_bmp;
+		}
+
+		ntfs_attr_put_search_ctx(ctx);
+		ctx = NULL;
+		goto retry;
 	}
 clear_bmp:
 	ntfs_ibm_clear(icx, new_ib_vcn);
@@ -1590,7 +1643,7 @@ static int ntfs_ib_split(struct ntfs_index_context *icx, struct index_block *ib)
 	median  = ntfs_ie_get_median(&ib->index);
 	new_vcn = ntfs_ibm_get_free(icx);
 	if (new_vcn < 0) {
-		ret = -EINVAL;
+		ret = (int)new_vcn;
 		goto out;
 	}
 
diff --git a/fs/ntfs/inode.c b/fs/ntfs/inode.c
index 1c9f6cf3ea1d8..f40f35afcda9a 100644
--- a/fs/ntfs/inode.c
+++ b/fs/ntfs/inode.c
@@ -3049,6 +3049,7 @@ int ntfs_inode_add_attrlist(struct ntfs_inode *ni)
 	struct attr_list_entry *ale = NULL;
 	struct mft_record *ni_mrec;
 	u32 attr_al_len;
+	bool free_empty_extents = true;
 
 	if (!ni)
 		return -EINVAL;
@@ -3148,6 +3149,7 @@ int ntfs_inode_add_attrlist(struct ntfs_inode *ni)
 		ntfs_error(ni->vol->sb, "Couldn't add $ATTRIBUTE_LIST to MFT");
 		goto rollback;
 	}
+	free_empty_extents = false;
 
 	err = ntfs_attrlist_update(ni);
 	if (err < 0)
@@ -3167,6 +3169,8 @@ int ntfs_inode_add_attrlist(struct ntfs_inode *ni)
 				CASE_SENSITIVE, 0, NULL, 0, ctx)) {
 		if (ntfs_attr_record_rm(ctx))
 			ntfs_error(ni->vol->sb, "Rollback failed to remove attrlist");
+		else
+			free_empty_extents = true;
 	} else {
 		ntfs_error(ni->vol->sb, "Rollback failed to find attrlist");
 	}
@@ -3205,6 +3209,11 @@ int ntfs_inode_add_attrlist(struct ntfs_inode *ni)
 	ni->attr_list_size = 0;
 	NInoClearAttrList(ni);
 	NInoClearAttrListDirty(ni);
+	ntfs_attr_put_search_ctx(ctx);
+	ctx = NULL;
+	if (free_empty_extents && ntfs_inode_free_empty_extents(ni))
+		ntfs_error(ni->vol->sb, "Rollback failed to free empty extent");
+	goto err_out;
 put_err_out:
 	ntfs_attr_put_search_ctx(ctx);
 err_out:
@@ -3291,6 +3300,55 @@ int ntfs_inode_close(struct ntfs_inode *ni)
 	return err;
 }
 
+/*
+ * ntfs_inode_free_empty_extents - free empty extent MFT records
+ * @ni: base inode whose empty extent records should be freed
+ *
+ * The caller must ensure that no on-disk attribute list references an empty
+ * extent record and must hold @ni->mrec_lock to serialize the extent array.
+ */
+int ntfs_inode_free_empty_extents(struct ntfs_inode *ni)
+{
+	int err = 0, i = 0;
+
+	if (!ni || ni->nr_extents < 0)
+		return -EINVAL;
+
+	mutex_lock(&ni->extent_lock);
+	while (i < ni->nr_extents) {
+		struct ntfs_inode *ext_ni = ni->ext.extent_ntfs_inos[i];
+		struct mft_record *m;
+		int ret;
+
+		m = map_mft_record(ext_ni);
+		if (IS_ERR(m)) {
+			if (!err)
+				err = PTR_ERR(m);
+			i++;
+			continue;
+		}
+		if (le32_to_cpu(m->bytes_in_use) -
+				le16_to_cpu(m->attrs_offset) != 8) {
+			unmap_mft_record(ext_ni);
+			i++;
+			continue;
+		}
+		unmap_mft_record(ext_ni);
+
+		ret = ntfs_mft_record_free(ni->vol, ext_ni);
+		if (ret) {
+			if (!err)
+				err = ret;
+			i++;
+			continue;
+		}
+		ntfs_inode_close(ext_ni);
+		/* ntfs_inode_close() removed this entry from the extent array. */
+	}
+	mutex_unlock(&ni->extent_lock);
+	return err;
+}
+
 void ntfs_destroy_ext_inode(struct ntfs_inode *ni)
 {
 	ntfs_debug("Entering.");
@@ -3390,6 +3448,9 @@ int ntfs_inode_free_space(struct ntfs_inode *ni, int size)
 	 * Chkdsk complain if $STANDARD_INFORMATION is not in the base MFT
 	 * record.
 	 *
+	 * $INDEX_ROOT must remain resident, but its attribute record may be moved
+	 * to an extent MFT record when the base record needs room for the list.
+	 *
 	 * Also we can't move $ATTRIBUTE_LIST from base MFT_RECORD, so position
 	 * search context on first attribute after $STANDARD_INFORMATION and
 	 * $ATTRIBUTE_LIST.
@@ -3431,9 +3492,6 @@ int ntfs_inode_free_space(struct ntfs_inode *ni, int size)
 				ctx->attr->type == AT_DATA)
 			goto retry;
 
-		if (ctx->attr->type == AT_INDEX_ROOT)
-			goto retry;
-
 		record_size = le32_to_cpu(ctx->attr->length);
 
 		/* Move away attribute. */
diff --git a/fs/ntfs/inode.h b/fs/ntfs/inode.h
index 9aacd5787ffea..bb48f55b50ddc 100644
--- a/fs/ntfs/inode.h
+++ b/fs/ntfs/inode.h
@@ -338,6 +338,7 @@ int ntfs_get_block_mft_record(struct ntfs_inode *mft_ni, struct ntfs_inode *ni);
 int __ntfs_write_inode(struct inode *vi, int sync);
 int ntfs_inode_attach_all_extents(struct ntfs_inode *ni);
 int ntfs_inode_add_attrlist(struct ntfs_inode *ni);
+int ntfs_inode_free_empty_extents(struct ntfs_inode *ni);
 void ntfs_destroy_ext_inode(struct ntfs_inode *ni);
 int ntfs_inode_free_space(struct ntfs_inode *ni, int size);
 s64 ntfs_inode_attr_pread(struct inode *vi, s64 pos, s64 count, u8 *buf);
-- 
2.53.0



