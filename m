Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66E9D46D0BD;
	Thu, 20 Aug 2026 16:31:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243482; cv=none; b=K7f3N1SV2Ma2Xe2OpB1aeXiDk/IqUQExk6enLeNqBMyMIVaiKl6y6L4ddJb0VzRt5wUTlGisaq0KiI/f4QDtr8TXf4j6ggd8ETgcZweiUiPaiWXFmS0dkl5oqUEkNa2Tecd0Xbh0Cs6tzLQH+JjuPmWkepOi1RS7YnoQ3Oea/T0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243482; c=relaxed/simple;
	bh=Pl/C+1pXhCo6GYeVmG0+X703a9ge2D/OGMxRQh/QFps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M84cmnraTr65X574AqnGKaOMGTuTLPTwkj8UZZXJEn8+xTZW+3J2YkmZeZVtHEVIq8y1NBB5lOzAgdentwxVWsB4wVmjBYMn0r3hcP3IY+33QB2Ecp36BMOuCtF365ZoFVFBWNOJlCLph5Jv48QDTPZZamDpZetTXKOQhpu/S1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O/cbenJv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O/cbenJv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C26651F000E9;
	Thu, 20 Aug 2026 16:31:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243481;
	bh=JC9SMMIBBQsjlJWw9uqkEhh2QyriMBjffN6YBwkFn6s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O/cbenJvxgKbgnhxesGpEXLjkq7+Z5QfyHwtefQB5f85L3GZ7+OGMb4wO4pea3uqT
	 qVdzZAn5T19jN/QWisttIlsXb1mVGSj49Dx//893RxBnROIm2iFNsdD7Djc8spRmnp
	 JzGwtEpQvGHcMxHMoOIRFwFoLiQNKPdH1r7vv9x8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 108/272] fs/ntfs3: Undo critial modificatins to keep directory consistency
Date: Thu, 20 Aug 2026 16:54:52 +0200
Message-ID: <20260820145234.508366998@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145231.229664293@linuxfoundation.org>
References: <20260820145231.229664293@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1819,10 +1819,11 @@ indx_insert_into_buffer(struct ntfs_inde
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
@@ -1855,6 +1856,13 @@ indx_insert_into_buffer(struct ntfs_inde
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
@@ -1887,7 +1895,7 @@ indx_insert_into_buffer(struct ntfs_inde
 	hdr_insert_head(hdr2, de_t, to_copy);
 
 	/* Remove all entries (sp including) from hdr1. */
-	used = le32_to_cpu(hdr1->used) - to_copy - sp_size;
+	used = used1 - to_copy - sp_size;
 	memmove(de_t, Add2Ptr(sp, sp_size), used - le32_to_cpu(hdr1->de_off));
 	hdr1->used = cpu_to_le32(used);
 
@@ -1917,8 +1925,6 @@ indx_insert_into_buffer(struct ntfs_inde
 	if (!level) {
 		/* Insert in root. */
 		err = indx_insert_into_root(indx, ni, up_e, NULL, ctx, fnd, 0);
-		if (err)
-			goto out;
 	} else {
 		/*
 		 * The target buffer's parent is another index buffer.
@@ -1926,12 +1932,20 @@ indx_insert_into_buffer(struct ntfs_inde
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
@@ -1990,16 +2004,12 @@ int indx_insert_entry(struct ntfs_index
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


