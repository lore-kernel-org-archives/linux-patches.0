Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0713544C51B;
	Thu, 20 Aug 2026 17:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787248127; cv=none; b=U8tIiSkh+YgQTSHJcDyiYDCiZLeB+9dyazrF4/QIbp/ikoDTPCW9zb7nqhxA/ABka3I2wnQpVaDqMS155uyOysQVMK+cCSKwRa+nQhKaWbocAWkQx3Ys8W7myVKUGHYPkKxOs+GD7y+NJAiXKdw6J2yGqyNHkq03DFm/NtdJb4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787248127; c=relaxed/simple;
	bh=Z+3hk1mC2PeCSXHIUPqzujRq/VrRwomFEKQql2nY4rg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QkIeEAOfQ5sKsw40txMIll/+Azb+eUB8AV7RUunAaiAWOvMIr9pjghi7XwOp04845V7WXU/pZOb9Ji554HkWdf/1LxDn56heokfMV9uxJO0eeoshMY68PCVzFYphmm+X5VFzWJzhin2HAw+duuXvUNB3XqEPSAAV2YHzCsUbhis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B63gpQ1I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B63gpQ1I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 621B51F000E9;
	Thu, 20 Aug 2026 17:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787248125;
	bh=T45+Zmhmeo2lX301tixt0UUFxkPrNvblgvGDCxMm88E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B63gpQ1IJe2JJ+YXwZcPXb9MGDUWL42H5/hiPY9CxHUfqx5AhscRxG9BvLfA6iteu
	 L+lCWcranUsnorxU8t/GzUvMYn528tBlZqjGSaJHoX65Bo537x5+kIk+oAbJAU92wM
	 yn1NNrekLI5CXsLzcdL2R13XnARdo0InSo03kV44=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 120/303] fs/ntfs3: Undo critial modificatins to keep directory consistency
Date: Thu, 20 Aug 2026 16:54:16 +0200
Message-ID: <20260820145256.886969481@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145253.200766705@linuxfoundation.org>
References: <20260820145253.200766705@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit 63e92a0c5a0d5816803907a3e30a91ef72c903a5 ]

Affect xfstest 320.

Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Stable-dep-of: f1df9d771df4 ("ntfs3: validate split-point offset in indx_insert_into_buffer")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs3/index.c |   30 ++++++++++++++++++++----------
 1 file changed, 20 insertions(+), 10 deletions(-)

--- a/fs/ntfs3/index.c
+++ b/fs/ntfs3/index.c
@@ -1812,10 +1812,11 @@ indx_insert_into_buffer(struct ntfs_inde
 	struct indx_node *n1 = fnd->nodes[level];
 	struct INDEX_HDR *hdr1 = &n1->index->ihdr;
 	struct INDEX_HDR *hdr2;
-	u32 to_copy, used;
+	u32 to_copy, used, used1;
 	CLST new_vbn;
 	__le64 t_vbn, *sub_vbn;
 	u16 sp_size;
+	void *hdr1_saved = NULL;
 
 	/* Try the most easy case. */
 	e = fnd->level - 1 == level ? fnd->de[level] : NULL;
@@ -1848,6 +1849,13 @@ indx_insert_into_buffer(struct ntfs_inde
 		return -ENOMEM;
 	memcpy(up_e, sp, sp_size);
 
+	used1 = le32_to_cpu(hdr1->used);
+	hdr1_saved = kmemdup(hdr1, used1, GFP_NOFS);
+	if (!hdr1_saved) {
+		err = -ENOMEM;
+		goto out;
+	}
+
 	if (!hdr1->flags) {
 		up_e->flags |= NTFS_IE_HAS_SUBNODES;
 		up_e->size = cpu_to_le16(sp_size + sizeof(u64));
@@ -1880,7 +1888,7 @@ indx_insert_into_buffer(struct ntfs_inde
 	hdr_insert_head(hdr2, de_t, to_copy);
 
 	/* Remove all entries (sp including) from hdr1. */
-	used = le32_to_cpu(hdr1->used) - to_copy - sp_size;
+	used = used1 - to_copy - sp_size;
 	memmove(de_t, Add2Ptr(sp, sp_size), used - le32_to_cpu(hdr1->de_off));
 	hdr1->used = cpu_to_le32(used);
 
@@ -1910,8 +1918,6 @@ indx_insert_into_buffer(struct ntfs_inde
 	if (!level) {
 		/* Insert in root. */
 		err = indx_insert_into_root(indx, ni, up_e, NULL, ctx, fnd, 0);
-		if (err)
-			goto out;
 	} else {
 		/*
 		 * The target buffer's parent is another index buffer.
@@ -1919,12 +1925,20 @@ indx_insert_into_buffer(struct ntfs_inde
 		 */
 		err = indx_insert_into_buffer(indx, ni, root, up_e, ctx,
 					      level - 1, fnd);
-		if (err)
-			goto out;
+	}
+
+	if (err) {
+		/*
+		 * Undo critical operations.
+		 */
+		indx_mark_free(indx, ni, new_vbn >> indx->idx2vbn_bits);
+		memcpy(hdr1, hdr1_saved, used1);
+		indx_write(indx, ni, n1, 0);
 	}
 
 out:
 	kfree(up_e);
+	kfree(hdr1_saved);
 
 	return err;
 }
@@ -1983,16 +1997,12 @@ int indx_insert_entry(struct ntfs_index
 		 */
 		err = indx_insert_into_root(indx, ni, new_de, fnd->root_de, ctx,
 					    fnd, undo);
-		if (err)
-			goto out;
 	} else {
 		/*
 		 * Found a leaf buffer, so we'll insert the new entry into it.
 		 */
 		err = indx_insert_into_buffer(indx, ni, root, new_de, ctx,
 					      fnd->level - 1, fnd);
-		if (err)
-			goto out;
 	}
 
 out:


