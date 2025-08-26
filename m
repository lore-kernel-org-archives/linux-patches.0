Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C22D1A83ED;
	Tue, 26 Aug 2025 12:52:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756212725; cv=none; b=kgMhkkDgxB93SjJmDLXwSdyiyvnnibnXWqLPLvAp64rKBEkjVQhwvD1v5Bar789APWdCdYKzDGgzYffiKYngCoBGjLiYyqXVht66mIkevvtqFOyWSp8DDkL6Y1nv9BhQmKOgy/C5PGivIvKFDs7T0saj5i+Q2wYUTVJjSLgNd7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756212725; c=relaxed/simple;
	bh=vPlwNojVTQII08IGi9mmM9KLd/jJA9hITGaweZ+hMbE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RJUZOoDZYC/U6wXHhpWgAi+dgmV7SKV9ofuVnyzljDb6dNe7ZU3ioTa1elmEQIq0lEG6jA+NlLmnt+gCuJOfx12DYkcX8TK6lreZCiSzuRkmftI5+gDMWNJ0kCDqYRlHYl87/7cvomj+O7TmAjYyUHSzAjZNjoHr9QurKbJA+AU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qNRL3Pcw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qNRL3Pcw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BD11C4CEF1;
	Tue, 26 Aug 2025 12:52:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756212725;
	bh=vPlwNojVTQII08IGi9mmM9KLd/jJA9hITGaweZ+hMbE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qNRL3Pcw4sMJ3VK6m0ruy9E16dw3WWCJF6GyYM9KaYCz933Rn3s0WhalXfBhEuF2N
	 XR7rUjJ1GXDVNkpNTrGPqMOrJ0ziWQ+pmd9FQ99h7tUZ1KXBwmar0SujnhYalCyLjt
	 uT6pV2HSHTHhe/HFPhBAuYs9off20sAcFaGz1Xro=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rong Zhang <ulin0208@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 078/587] fs/ntfs3: correctly create symlink for relative path
Date: Tue, 26 Aug 2025 13:03:47 +0200
Message-ID: <20250826110954.919261976@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Rong Zhang <ulin0208@gmail.com>

[ Upstream commit b1e9d89408f402858c00103f9831b25ffa0994d3 ]

After applying this patch, could correctly create symlink:

ln -s "relative/path/to/file" symlink

Signed-off-by: Rong Zhang <ulin0208@gmail.com>
[almaz.alexandrovich@paragon-software.com: added cpu_to_le32 macro to
rs->Flags assignment]
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/inode.c | 31 ++++++++++++++++++-------------
 1 file changed, 18 insertions(+), 13 deletions(-)

diff --git a/fs/ntfs3/inode.c b/fs/ntfs3/inode.c
index af7c0cbba74e..0150a2210209 100644
--- a/fs/ntfs3/inode.c
+++ b/fs/ntfs3/inode.c
@@ -1130,10 +1130,10 @@ int inode_write_data(struct inode *inode, const void *data, size_t bytes)
  * Number of bytes for REPARSE_DATA_BUFFER(IO_REPARSE_TAG_SYMLINK)
  * for unicode string of @uni_len length.
  */
-static inline u32 ntfs_reparse_bytes(u32 uni_len)
+static inline u32 ntfs_reparse_bytes(u32 uni_len, bool is_absolute)
 {
 	/* Header + unicode string + decorated unicode string. */
-	return sizeof(short) * (2 * uni_len + 4) +
+	return sizeof(short) * (2 * uni_len + (is_absolute ? 4 : 0)) +
 	       offsetof(struct REPARSE_DATA_BUFFER,
 			SymbolicLinkReparseBuffer.PathBuffer);
 }
@@ -1146,8 +1146,11 @@ ntfs_create_reparse_buffer(struct ntfs_sb_info *sbi, const char *symname,
 	struct REPARSE_DATA_BUFFER *rp;
 	__le16 *rp_name;
 	typeof(rp->SymbolicLinkReparseBuffer) *rs;
+	bool is_absolute;
 
-	rp = kzalloc(ntfs_reparse_bytes(2 * size + 2), GFP_NOFS);
+	is_absolute = (strlen(symname) > 1 && symname[1] == ':');
+
+	rp = kzalloc(ntfs_reparse_bytes(2 * size + 2, is_absolute), GFP_NOFS);
 	if (!rp)
 		return ERR_PTR(-ENOMEM);
 
@@ -1162,7 +1165,7 @@ ntfs_create_reparse_buffer(struct ntfs_sb_info *sbi, const char *symname,
 		goto out;
 
 	/* err = the length of unicode name of symlink. */
-	*nsize = ntfs_reparse_bytes(err);
+	*nsize = ntfs_reparse_bytes(err, is_absolute);
 
 	if (*nsize > sbi->reparse.max_size) {
 		err = -EFBIG;
@@ -1182,7 +1185,7 @@ ntfs_create_reparse_buffer(struct ntfs_sb_info *sbi, const char *symname,
 
 	/* PrintName + SubstituteName. */
 	rs->SubstituteNameOffset = cpu_to_le16(sizeof(short) * err);
-	rs->SubstituteNameLength = cpu_to_le16(sizeof(short) * err + 8);
+	rs->SubstituteNameLength = cpu_to_le16(sizeof(short) * err + (is_absolute ? 8 : 0));
 	rs->PrintNameLength = rs->SubstituteNameOffset;
 
 	/*
@@ -1190,16 +1193,18 @@ ntfs_create_reparse_buffer(struct ntfs_sb_info *sbi, const char *symname,
 	 * parse this path.
 	 * 0-absolute path 1- relative path (SYMLINK_FLAG_RELATIVE).
 	 */
-	rs->Flags = 0;
+	rs->Flags = cpu_to_le32(is_absolute ? 0 : SYMLINK_FLAG_RELATIVE);
 
-	memmove(rp_name + err + 4, rp_name, sizeof(short) * err);
+	memmove(rp_name + err + (is_absolute ? 4 : 0), rp_name, sizeof(short) * err);
 
-	/* Decorate SubstituteName. */
-	rp_name += err;
-	rp_name[0] = cpu_to_le16('\\');
-	rp_name[1] = cpu_to_le16('?');
-	rp_name[2] = cpu_to_le16('?');
-	rp_name[3] = cpu_to_le16('\\');
+	if (is_absolute) {
+		/* Decorate SubstituteName. */
+		rp_name += err;
+		rp_name[0] = cpu_to_le16('\\');
+		rp_name[1] = cpu_to_le16('?');
+		rp_name[2] = cpu_to_le16('?');
+		rp_name[3] = cpu_to_le16('\\');
+	}
 
 	return rp;
 out:
-- 
2.39.5



