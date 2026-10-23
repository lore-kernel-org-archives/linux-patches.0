Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792775037;
	b=a1c5ZUuMKQYSL90kW5dfV6Z4kyY2JetTAEcDQ7Xx6AxmfrmQiKTxWdDXPfwg0T510KYM
	 zq55w+vZ5A5tGEOWmaWuLtcyxcupxHmm1MUWQMQScC7/z/CH9X84d3UJMBBpPsNOjgG5R
	 xpwj19tMTR6Xtn4rR/LPJcnffEC97Y1poRZc+dLRG1mIRyDGYNhEg2DNQM0TN1APGN5F6
	 eZYvWdPFtRiWOWnhPIEuzRCY7cSRmY8PvrJTshIhyMzbK3MnSs4OhLomvkhoa3eGNyRyl
	 6/5kDP9s/0Sfus7ctOOWxb4+4YzTYes4Glu4RA91B+dw0DqcTOChjrodtOi/lHKHcPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792775037;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vQG1/H23fAkUOA2BU2nuAZVhHNmUYkym05Z6uN8p2xY=;
	b=COKGDMzN1ND7X9dbQXqq9Eq3EVpZFXierMKj3YUpdMFuizH1Ky1GjAoDwymcUZyYrnvJ
	 N3QAlTYjJXrU0c6pGVvDmtue1rGf2jhzYZAurNfxJ120LT09AG+jYB+uZ651tKl/uLuVp
	 U5gAvQ/sDuThwTTOiMtliTS3IokYTqkO5ZHKOajwjvygW5WpB3asKCmztmR/qDRBo6kzZ
	 i9V97jjQoT1oXJpc+USzIEIQSqjAtZGwR9j++IKmbv3OpImpK/UjSq2RRSXDqmauR5Ga4
	 0zIxxZw+ugjMd22PdxARKNbuLXj+NUDa6uvPwfxLm0zUKLA1PEYgcklVLzgO7wiu99g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=n1dmulOq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70563606A31D;
	Fri, 23 Oct 2026 17:03:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=n1dmulOq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC6531F01825;
	Fri, 23 Oct 2026 17:03:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792775037;
	bh=vQG1/H23fAkUOA2BU2nuAZVhHNmUYkym05Z6uN8p2xY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n1dmulOqBzSHHE33P3xlOja1jEbotRbMhZVzQICgPFCsUE4EwiQHb4bF+c0aQMdpO
	 2CMGH1Z3wAew1EuCiZTdBfiU2kCvKzH6aOpWI6Y/Z1DEZaSHJm9JwwqRjfsLFGJH4h
	 V7/ni0qOZUy87HjCCpugnFNeft/kJL768MGtLLAE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 239/242] ntfs: fix resident conversion in ntfs_new_attr_flags
Date: Fri, 23 Oct 2026 18:41:21 +0200
Message-ID: <20261023163719.506459395@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hyunchul Lee <hyc.lee@gmail.com>

[ Upstream commit 7ed0028126b5a19f278183abbae2b3166d3ca9ac ]

When setting sparse/compressed flags on a resident attribute, the
function skipped the resident-to-non-resident conversion and
terminated.

Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Stable-dep-of: acb1095fd2db ("ntfs: fix memmove overlap in ntfs_new_attr_flags")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs/ea.c |   94 +++++++++++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 72 insertions(+), 22 deletions(-)

--- a/fs/ntfs/ea.c
+++ b/fs/ntfs/ea.c
@@ -630,6 +630,7 @@ static int ntfs_new_attr_flags(struct nt
 	struct mft_record *m;
 	struct attr_record *a;
 	__le16 new_aflags;
+	u16 old_name_ofs, old_mp_ofs;
 	int mp_size, mp_ofs, name_ofs, arec_size, err;
 
 	m = map_mft_record(ni);
@@ -662,8 +663,10 @@ static int ntfs_new_attr_flags(struct nt
 	else
 		new_aflags &= ~ATTR_IS_COMPRESSED;
 
-	if (new_aflags == a->flags)
-		return 0;
+	if (new_aflags == a->flags) {
+		err = 0;
+		goto err_out;
+	}
 
 	if ((new_aflags & (ATTR_IS_SPARSE | ATTR_IS_COMPRESSED)) ==
 			  (ATTR_IS_SPARSE | ATTR_IS_COMPRESSED)) {
@@ -672,15 +675,40 @@ static int ntfs_new_attr_flags(struct nt
 		goto err_out;
 	}
 
-	if (!a->non_resident)
-		goto out;
+	if (!a->non_resident) {
+		if (!(new_aflags & (ATTR_IS_SPARSE | ATTR_IS_COMPRESSED)))
+			return 0;
+
+		if (le32_to_cpu(a->data.resident.value_length)) {
+			pr_err("Can't change sparse/compressed for non-empty file");
+			err = -EOPNOTSUPP;
+			goto err_out;
+		}
 
-	if (a->data.non_resident.data_size) {
-		pr_err("Can't change sparsed/compressed for non-empty file\n");
-		err = -EOPNOTSUPP;
-		goto err_out;
+		err = ntfs_attr_make_non_resident(ni, 0);
+		if (err)
+			goto err_out;
+
+		ntfs_attr_reinit_search_ctx(ctx);
+		err = ntfs_attr_lookup(ni->type, ni->name,
+				ni->name_len, CASE_SENSITIVE,
+				0, NULL, 0, ctx);
+		if (err) {
+			err = -EINVAL;
+			goto err_out;
+		}
+		a = ctx->attr;
+	} else {
+		if (a->data.non_resident.data_size) {
+			pr_err("Can't change sparsed/compressed for non-empty file");
+			err = -EOPNOTSUPP;
+			goto err_out;
+		}
 	}
 
+	old_name_ofs = le16_to_cpu(a->name_offset);
+	old_mp_ofs = le16_to_cpu(a->data.non_resident.mapping_pairs_offset);
+
 	if (new_aflags & (ATTR_IS_SPARSE | ATTR_IS_COMPRESSED))
 		name_ofs = (offsetof(struct attr_record,
 				     data.non_resident.compressed_size) +
@@ -703,6 +731,25 @@ static int ntfs_new_attr_flags(struct nt
 	if (unlikely(err))
 		goto err_out;
 
+	/*
+	 * When compressed/sparse state changes, the non-resident header grows or
+	 * shrinks by the compressed_size field. Update the in-record payload layout
+	 * to match the new offsets before exposing the new mapping_pairs_offset.
+	 */
+	if (name_ofs > old_name_ofs) {
+		if (mp_ofs != old_mp_ofs)
+			memmove((u8 *)a + mp_ofs, (u8 *)a + old_mp_ofs, mp_size);
+		if (a->name_length)
+			memmove((u8 *)a + name_ofs, (u8 *)a + old_name_ofs,
+				a->name_length * sizeof(__le16));
+	} else {
+		if (a->name_length && name_ofs != old_name_ofs)
+			memmove((u8 *)a + name_ofs, (u8 *)a + old_name_ofs,
+				a->name_length * sizeof(__le16));
+		if (mp_ofs != old_mp_ofs)
+			memmove((u8 *)a + mp_ofs, (u8 *)a + old_mp_ofs, mp_size);
+	}
+
 	if (new_aflags & (ATTR_IS_SPARSE | ATTR_IS_COMPRESSED)) {
 		a->data.non_resident.compression_unit = 0;
 		if (new_aflags & ATTR_IS_COMPRESSED || ni->vol->major_ver < 3)
@@ -723,28 +770,31 @@ static int ntfs_new_attr_flags(struct nt
 			ni->itype.compressed.block_size_bits = 0;
 			ni->itype.compressed.block_clusters = 0;
 		}
-
-		if (new_aflags & ATTR_IS_SPARSE) {
-			NInoSetSparse(ni);
-			ni->flags |= FILE_ATTR_SPARSE_FILE;
-		}
-
-		if (new_aflags & ATTR_IS_COMPRESSED) {
-			NInoSetCompressed(ni);
-			ni->flags |= FILE_ATTR_COMPRESSED;
-		}
 	} else {
-		ni->flags &= ~(FILE_ATTR_SPARSE_FILE | FILE_ATTR_COMPRESSED);
 		a->data.non_resident.compression_unit = 0;
-		NInoClearSparse(ni);
-		NInoClearCompressed(ni);
 	}
 
 	a->name_offset = cpu_to_le16(name_ofs);
 	a->data.non_resident.mapping_pairs_offset = cpu_to_le16(mp_ofs);
 
-out:
 	a->flags = new_aflags;
+
+	if (new_aflags & ATTR_IS_SPARSE) {
+		NInoSetSparse(ni);
+		ni->flags |= FILE_ATTR_SPARSE_FILE;
+	} else {
+		NInoClearSparse(ni);
+		ni->flags &= ~FILE_ATTR_SPARSE_FILE;
+	}
+
+	if (new_aflags & ATTR_IS_COMPRESSED) {
+		NInoSetCompressed(ni);
+		ni->flags |= FILE_ATTR_COMPRESSED;
+	} else {
+		NInoClearCompressed(ni);
+		ni->flags &= ~FILE_ATTR_COMPRESSED;
+	}
+
 	mark_mft_record_dirty(ctx->ntfs_ino);
 err_out:
 	if (ctx)


