Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9518240096A;
	Tue, 21 Jul 2026 17:19:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654374; cv=none; b=Z5NuadkQSWI1o9hfZWVdZjU013/xnpXstbuJnf/+mkJthKJpoWZX/6MTd1rAKlsNZZBVa++1tUjn9GGn1G/VZrAf4f/SGHLOMNF3CCk/4AuXa7pZSj20Ql8Mm6psSidgVojw3/HlGAwWP/hhkJkSb874r6Pb5/JVZs2h8lHbj/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654374; c=relaxed/simple;
	bh=UwnH24OOUZoomzj2sJAIQjGCGPSJTJmQNMsJsVOkVJs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QAXXWiZGHknes6jmTzmF099RfyckyMzBtwWWF+1GcO08HUdojhz2hbwGZhwsI4PBzXTqYD17kz/lxhOptieTpo+JBuSk0CvAgf3SV3dcKCO41weJfqwbjaWayOnX48FyZTlWZELMpGx15rrcx0MtkuYskzRaTcMDuDyW5cmQJKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kmHltR/d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kmHltR/d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5E651F000E9;
	Tue, 21 Jul 2026 17:19:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654373;
	bh=0DsvfBvtRVRgek9Hzr/DjAX6NexVgjO1Civ27UzzqY8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kmHltR/dSrNdgxxVqcs4nuYvrnYq6K1IpTyjArkZF8zOTyG0WSOzzBgHprAsGVVJ3
	 7e3AGf760cegyyw4KDeKYLW2IhckmX7vlfGm6mccwV8CrC/jprhVtxHN2s9i5Km74s
	 X5ZJg31XhhMli5u1ArvPv8lK0NXvnIMLL/g3+Yus=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	DaeMyung Kang <charsyam@gmail.com>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 7.1 1680/2077] ntfs: grow index root value before reparent header update
Date: Tue, 21 Jul 2026 17:22:33 +0200
Message-ID: <20260721152632.372586242@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: DaeMyung Kang <charsyam@gmail.com>

commit 0bb508fb3b97e4802ec727fd2af4d608f65dd190 upstream.

ntfs_ir_reparent() moves the resident index root entries into an index
block and leaves a small root stub containing the child VCN. That root
stub can be larger than the existing resident value. For example, an
empty root with value_length 48 has an index area of 32 bytes, while the
large-index root stub needs index_length and allocated_size of 40 bytes.

The current code publishes the larger index.index_length and
index.allocated_size before resizing the resident value. If the resize
returns -ENOSPC, the recovery path can call ntfs_inode_add_attrlist(),
which looks attributes up again while the root header says
allocated_size 40 but the resident value still only provides 32 bytes of
index area. Lookup-time $INDEX_ROOT validation then correctly rejects
that transient layout as corrupt.

This reproduces as a generic/013 failure under qemu. In the failing run,
the transient root had value_len=48, index_size=32, index_length=40, and
allocated_size=40, and ntfsprogs-plus ntfsck reported "Corrupt index
root in MFT record 1177".

When the root stub grows, resize the resident value before publishing the
larger root header. If the resize fails, the old root remains valid for
recovery lookups. Keep the existing header-before-resize ordering for
shrink or same-size cases so the resident value never temporarily
exposes an allocated_size beyond its bounds.

Cc: stable@vger.kernel.org # v7.1
Signed-off-by: DaeMyung Kang <charsyam@gmail.com>
Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs/index.c |   78 ++++++++++++++++++++++++++++++++++----------------------
 1 file changed, 48 insertions(+), 30 deletions(-)

--- a/fs/ntfs/index.c
+++ b/fs/ntfs/index.c
@@ -1176,6 +1176,8 @@ static int ntfs_ir_reparent(struct ntfs_
 	struct index_entry *ie;
 	struct index_block *ib = NULL;
 	s64 new_ib_vcn;
+	u32 index_length;
+	u32 old_value_length;
 	int ix_root_size;
 	int ret = 0;
 
@@ -1223,6 +1225,21 @@ retry:
 		goto clear_bmp;
 	}
 
+	old_value_length = le32_to_cpu(ctx->attr->data.resident.value_length);
+	index_length = le32_to_cpu(ir->index.entries_offset) +
+		sizeof(struct index_entry_header) + sizeof(s64);
+	ix_root_size = offsetof(struct index_root, index) + index_length;
+	/* Grow the resident value before publishing the larger root header. */
+	if (ix_root_size > old_value_length) {
+		ret = ntfs_resident_attr_value_resize(ctx->mrec, ctx->attr, ix_root_size);
+		if (ret)
+			goto resize_failed;
+
+		icx->idx_ni->data_size = ix_root_size;
+		icx->idx_ni->initialized_size = ix_root_size;
+		icx->idx_ni->allocated_size = (ix_root_size + 7) & ~7;
+	}
+
 	ntfs_ir_nill(ir);
 
 	ie = ntfs_ie_get_first(&ir->index);
@@ -1231,48 +1248,49 @@ retry:
 
 	ir->index.flags = LARGE_INDEX;
 	NInoSetIndexAllocPresent(icx->idx_ni);
-	ir->index.index_length = cpu_to_le32(le32_to_cpu(ir->index.entries_offset) +
-			le16_to_cpu(ie->length));
+	ir->index.index_length = cpu_to_le32(index_length);
 	ir->index.allocated_size = ir->index.index_length;
 
-	ix_root_size = sizeof(struct index_root) - sizeof(struct index_header) +
-		le32_to_cpu(ir->index.allocated_size);
-	ret  = ntfs_resident_attr_value_resize(ctx->mrec, ctx->attr, ix_root_size);
-	if (ret) {
-		/*
-		 * When there is no space to build a non-resident
-		 * index, we may have to move the root to an extent
-		 */
-		if ((ret == -ENOSPC) && (ctx->al_entry || !ntfs_inode_add_attrlist(icx->idx_ni))) {
+	if (ix_root_size <= old_value_length) {
+		ret = ntfs_resident_attr_value_resize(ctx->mrec, ctx->attr, ix_root_size);
+		if (ret)
+			goto resize_failed;
+
+		icx->idx_ni->data_size = ix_root_size;
+		icx->idx_ni->initialized_size = ix_root_size;
+		icx->idx_ni->allocated_size = (ix_root_size + 7) & ~7;
+	}
+	ntfs_ie_set_vcn(ie, new_ib_vcn);
+	goto err_out;
+
+resize_failed:
+	/*
+	 * When there is no space to build a non-resident
+	 * index, we may have to move the root to an extent
+	 */
+	if ((ret == -ENOSPC) && (ctx->al_entry || !ntfs_inode_add_attrlist(icx->idx_ni))) {
+		ntfs_attr_put_search_ctx(ctx);
+		ctx = NULL;
+		ir = ntfs_ir_lookup(icx->idx_ni, icx->name, icx->name_len, &ctx);
+		if (ir && !ntfs_attr_record_move_away(ctx, ix_root_size -
+				le32_to_cpu(ctx->attr->data.resident.value_length))) {
+			if (ntfs_attrlist_update(ctx->base_ntfs_ino ?
+						 ctx->base_ntfs_ino : ctx->ntfs_ino))
+				goto clear_bmp;
 			ntfs_attr_put_search_ctx(ctx);
 			ctx = NULL;
-			ir = ntfs_ir_lookup(icx->idx_ni, icx->name, icx->name_len, &ctx);
-			if (ir && !ntfs_attr_record_move_away(ctx, ix_root_size -
-					le32_to_cpu(ctx->attr->data.resident.value_length))) {
-				if (ntfs_attrlist_update(ctx->base_ntfs_ino ?
-							 ctx->base_ntfs_ino : ctx->ntfs_ino))
-					goto clear_bmp;
-				ntfs_attr_put_search_ctx(ctx);
-				ctx = NULL;
-				goto retry;
-			}
+			goto retry;
 		}
-		goto clear_bmp;
-	} else {
-		icx->idx_ni->data_size = icx->idx_ni->initialized_size = ix_root_size;
-		icx->idx_ni->allocated_size = (ix_root_size  + 7) & ~7;
 	}
-	ntfs_ie_set_vcn(ie, new_ib_vcn);
-
+clear_bmp:
+	ntfs_ibm_clear(icx, new_ib_vcn);
+	goto err_out;
 err_out:
 	kvfree(ib);
 	if (ctx)
 		ntfs_attr_put_search_ctx(ctx);
 out:
 	return ret;
-clear_bmp:
-	ntfs_ibm_clear(icx, new_ib_vcn);
-	goto err_out;
 }
 
 /*


