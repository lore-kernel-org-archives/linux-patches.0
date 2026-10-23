Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792775040;
	b=UKCYSNbjbTNUwZbFxmgv70PrptZMWKTfEBrJNrg8rkbfXxFDaUtCZC8lC9qG6kM8Gqoy
	 A99QtwelBn+YXN7AoG+fKdZus2Df08B+fwtgOpH27teaM/uVRfyiFViGCxATjXK8JE1XP
	 4QGNh8oxoF6/AqYPGvrgQyV0nAQj7LNpIxqfwaQlVU1jHyBUSsXlb+VsC5fdFUflvF56C
	 t3VqbXLcmrXvndKrqfWvXnSt07lvnejhrOIi5zYn8adSSbtbnJnXrtP861pJ5VHuou7yu
	 mWybqTwK9yI0uJVSjI1kb7WZ0miLd/1+WXc+0+hMGjJAivD67eXO+BRVrKbe3H9xWNQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792775040;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HJlf+n0QM57hJJPJ2L4/P+DQq3uSxqPWFZC1oyocydA=;
	b=rh/hTJBGchGQ3eAgB4UPO8yukVe6fNjRKj2CmdLD7b62CmLevbvuOdPgGyLJDv5S6seH
	 hGsvasGtUPhZXFhXEAe7C90wHhckiXPWHeldynzYrkQTFZa/cSPd+2YXphA5oGijIaAYY
	 VaV2aYJKCtDqip+fjo6IscrmzwqPb2023xOtl9WxrgbrXz4J2c5ncaZfpPs0488Mz0Iqq
	 lL8QP1d67fCGyOlo31yrF9Q5xDEKUkxWsrOU8FRXrGphTn7hglVq+X9FI+5yvD5qynw7N
	 sO+R8pHBHoTuVAtgzOTB9PCPz78k8hhJ7lLzmRhNiS3GZqKYQQnGw+45eOGkaiMg/5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YYLVBSXz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71D9D606A32E;
	Fri, 23 Oct 2026 17:04:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YYLVBSXz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C42751F01829;
	Fri, 23 Oct 2026 17:03:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792775040;
	bh=HJlf+n0QM57hJJPJ2L4/P+DQq3uSxqPWFZC1oyocydA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YYLVBSXzJqH3ypMCYrV5+Dj5iKxoDwPGcoe1d83mM5RePlQorfDcATYz7/IPU5ssk
	 OKCKWwT4w5guHpeiSTmjUDnei50pQKQXR1uRDYk8sLH52SGWp/I6nRSNEfCSG30PSq
	 tNxKAQ1ebzrfCUkMzssDZf7Br3pvPgqdgIVOmMj8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 240/242] ntfs: move attribute payload before shrinking its record
Date: Fri, 23 Oct 2026 18:41:22 +0200
Message-ID: <20261023163719.530724273@linuxfoundation.org>
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

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 0ab6dc1ac4601c8d79e5448a024daed6b0c5ef64 ]

ntfs_new_attr_flags() resizes the non-resident attribute record before
moving its name and mapping pairs to their shorter-header offsets when
compression or sparse state is cleared.

Shrinking the record first moves the following attribute over the tail of
the old record. The subsequent memmove() therefore copies bytes from that
following attribute instead of the old mapping pairs. Re-enabling
compression on an empty file persists those bytes as a malformed mapping
pairs array, which ntfsck reports as a missing or invalid run length.

Move the payload before shrinking the record, while retaining the existing
resize-before-move ordering when growing it.

Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Stable-dep-of: acb1095fd2db ("ntfs: fix memmove overlap in ntfs_new_attr_flags")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs/ea.c |   23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

--- a/fs/ntfs/ea.c
+++ b/fs/ntfs/ea.c
@@ -631,7 +631,7 @@ static int ntfs_new_attr_flags(struct nt
 	struct attr_record *a;
 	__le16 new_aflags;
 	u16 old_name_ofs, old_mp_ofs;
-	int mp_size, mp_ofs, name_ofs, arec_size, err;
+	int mp_size, mp_ofs, name_ofs, old_arec_size, arec_size, err;
 
 	m = map_mft_record(ni);
 	if (IS_ERR(m))
@@ -726,6 +726,19 @@ static int ntfs_new_attr_flags(struct nt
 
 	mp_ofs = (name_ofs + a->name_length * sizeof(__le16) + 7) & ~7;
 	arec_size = (mp_ofs + mp_size + 7) & ~7;
+	old_arec_size = le32_to_cpu(a->length);
+
+	/*
+	 * Move payloads before shrinking the record.  Otherwise resizing moves
+	 * the following attribute over the old payload before it can be copied.
+	 */
+	if (arec_size < old_arec_size) {
+		if (a->name_length && name_ofs != old_name_ofs)
+			memmove((u8 *)a + name_ofs, (u8 *)a + old_name_ofs,
+				a->name_length * sizeof(__le16));
+		if (mp_ofs != old_mp_ofs)
+			memmove((u8 *)a + mp_ofs, (u8 *)a + old_mp_ofs, mp_size);
+	}
 
 	err = ntfs_attr_record_resize(ctx->mrec, a, arec_size);
 	if (unlikely(err))
@@ -736,18 +749,12 @@ static int ntfs_new_attr_flags(struct nt
 	 * shrinks by the compressed_size field. Update the in-record payload layout
 	 * to match the new offsets before exposing the new mapping_pairs_offset.
 	 */
-	if (name_ofs > old_name_ofs) {
+	if (arec_size > old_arec_size) {
 		if (mp_ofs != old_mp_ofs)
 			memmove((u8 *)a + mp_ofs, (u8 *)a + old_mp_ofs, mp_size);
 		if (a->name_length)
 			memmove((u8 *)a + name_ofs, (u8 *)a + old_name_ofs,
 				a->name_length * sizeof(__le16));
-	} else {
-		if (a->name_length && name_ofs != old_name_ofs)
-			memmove((u8 *)a + name_ofs, (u8 *)a + old_name_ofs,
-				a->name_length * sizeof(__le16));
-		if (mp_ofs != old_mp_ofs)
-			memmove((u8 *)a + mp_ofs, (u8 *)a + old_mp_ofs, mp_size);
 	}
 
 	if (new_aflags & (ATTR_IS_SPARSE | ATTR_IS_COMPRESSED)) {


