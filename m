Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D0AE46444;
	Tue, 10 Sep 2024 10:33:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964385; cv=none; b=NtdbqaEYpUAfyJzmuQC1vaKm9jL3WcAK4kFA3wL1JfUQ/6z11J2d+1iU5hUWE637EjhLmw6Fd5yl62wvyhII5E+00fnqsNU8tCtNwlkuUk1DaMcHiKhApqqRyuFAc5Dxl3yUWQtv2KXzcukLYfgkI+0oZtrOGPLGqerwrgZW/70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964385; c=relaxed/simple;
	bh=XiL+YPDuuAh85q4exmgktBLlxyGGI+5u0z+RnYWiPmw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TVnnVgTl01yGvAx0M4ic4AoUgyeLbbr/Ob+YqSCrA4maxAevId4yrRSk/E5/qnBJGyYEBtkZChR76R/+sndXhfhh+otFZM2MUObLgPl2lT8pv4hYVk5sqk0BVNNdcAApU3ApLaqaS7aOV9t8kpOoiuHLbpotfUN1CjT0YKdRru0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GVXCeZST; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GVXCeZST"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96371C4CEC3;
	Tue, 10 Sep 2024 10:33:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964385;
	bh=XiL+YPDuuAh85q4exmgktBLlxyGGI+5u0z+RnYWiPmw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GVXCeZSTqIXgmtvZifmiBXBMRfS/ocy4/r4IowmH43Ox/fzhgWiDBnBhGLjL2xobM
	 LJKF7sULtcVfHDMOUp3WgmX6AG6loxY5KW752hLReJsuO8ktOvBwLBJAk3jvC4lI0E
	 BVWxeGFBHubqn9uUEYKgwqV+LssyR56SslU/TfQY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 165/269] fs/ntfs3: Check more cases when directory is corrupted
Date: Tue, 10 Sep 2024 11:32:32 +0200
Message-ID: <20240910092614.045287555@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit 744375343662058cbfda96d871786e5a5cbe1947 ]

Mark ntfs dirty in this case.
Rename ntfs_filldir to ntfs_dir_emit.

Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/dir.c | 52 +++++++++++++++++++++++++++++++-------------------
 1 file changed, 32 insertions(+), 20 deletions(-)

diff --git a/fs/ntfs3/dir.c b/fs/ntfs3/dir.c
index 9d0a09f00b38..e1b856ecce61 100644
--- a/fs/ntfs3/dir.c
+++ b/fs/ntfs3/dir.c
@@ -272,9 +272,12 @@ struct inode *dir_search_u(struct inode *dir, const struct cpu_str *uni,
 	return err == -ENOENT ? NULL : err ? ERR_PTR(err) : inode;
 }
 
-static inline int ntfs_filldir(struct ntfs_sb_info *sbi, struct ntfs_inode *ni,
-			       const struct NTFS_DE *e, u8 *name,
-			       struct dir_context *ctx)
+/*
+ * returns false if 'ctx' if full
+ */
+static inline bool ntfs_dir_emit(struct ntfs_sb_info *sbi,
+				 struct ntfs_inode *ni, const struct NTFS_DE *e,
+				 u8 *name, struct dir_context *ctx)
 {
 	const struct ATTR_FILE_NAME *fname;
 	unsigned long ino;
@@ -284,29 +287,29 @@ static inline int ntfs_filldir(struct ntfs_sb_info *sbi, struct ntfs_inode *ni,
 	fname = Add2Ptr(e, sizeof(struct NTFS_DE));
 
 	if (fname->type == FILE_NAME_DOS)
-		return 0;
+		return true;
 
 	if (!mi_is_ref(&ni->mi, &fname->home))
-		return 0;
+		return true;
 
 	ino = ino_get(&e->ref);
 
 	if (ino == MFT_REC_ROOT)
-		return 0;
+		return true;
 
 	/* Skip meta files. Unless option to show metafiles is set. */
 	if (!sbi->options->showmeta && ntfs_is_meta_file(sbi, ino))
-		return 0;
+		return true;
 
 	if (sbi->options->nohidden && (fname->dup.fa & FILE_ATTRIBUTE_HIDDEN))
-		return 0;
+		return true;
 
 	name_len = ntfs_utf16_to_nls(sbi, fname->name, fname->name_len, name,
 				     PATH_MAX);
 	if (name_len <= 0) {
 		ntfs_warn(sbi->sb, "failed to convert name for inode %lx.",
 			  ino);
-		return 0;
+		return true;
 	}
 
 	/*
@@ -336,17 +339,20 @@ static inline int ntfs_filldir(struct ntfs_sb_info *sbi, struct ntfs_inode *ni,
 		}
 	}
 
-	return !dir_emit(ctx, (s8 *)name, name_len, ino, dt_type);
+	return dir_emit(ctx, (s8 *)name, name_len, ino, dt_type);
 }
 
 /*
  * ntfs_read_hdr - Helper function for ntfs_readdir().
+ *
+ * returns 0 if ok.
+ * returns -EINVAL if directory is corrupted.
+ * returns +1 if 'ctx' is full.
  */
 static int ntfs_read_hdr(struct ntfs_sb_info *sbi, struct ntfs_inode *ni,
 			 const struct INDEX_HDR *hdr, u64 vbo, u64 pos,
 			 u8 *name, struct dir_context *ctx)
 {
-	int err;
 	const struct NTFS_DE *e;
 	u32 e_size;
 	u32 end = le32_to_cpu(hdr->used);
@@ -354,12 +360,12 @@ static int ntfs_read_hdr(struct ntfs_sb_info *sbi, struct ntfs_inode *ni,
 
 	for (;; off += e_size) {
 		if (off + sizeof(struct NTFS_DE) > end)
-			return -1;
+			return -EINVAL;
 
 		e = Add2Ptr(hdr, off);
 		e_size = le16_to_cpu(e->size);
 		if (e_size < sizeof(struct NTFS_DE) || off + e_size > end)
-			return -1;
+			return -EINVAL;
 
 		if (de_is_last(e))
 			return 0;
@@ -369,14 +375,15 @@ static int ntfs_read_hdr(struct ntfs_sb_info *sbi, struct ntfs_inode *ni,
 			continue;
 
 		if (le16_to_cpu(e->key_size) < SIZEOF_ATTRIBUTE_FILENAME)
-			return -1;
+			return -EINVAL;
 
 		ctx->pos = vbo + off;
 
 		/* Submit the name to the filldir callback. */
-		err = ntfs_filldir(sbi, ni, e, name, ctx);
-		if (err)
-			return err;
+		if (!ntfs_dir_emit(sbi, ni, e, name, ctx)) {
+			/* ctx is full. */
+			return +1;
+		}
 	}
 }
 
@@ -475,8 +482,6 @@ static int ntfs_readdir(struct file *file, struct dir_context *ctx)
 
 		vbo = (u64)bit << index_bits;
 		if (vbo >= i_size) {
-			ntfs_inode_err(dir, "Looks like your dir is corrupt");
-			ctx->pos = eod;
 			err = -EINVAL;
 			goto out;
 		}
@@ -499,9 +504,16 @@ static int ntfs_readdir(struct file *file, struct dir_context *ctx)
 	__putname(name);
 	put_indx_node(node);
 
-	if (err == -ENOENT) {
+	if (err == 1) {
+		/* 'ctx' is full. */
+		err = 0;
+	} else if (err == -ENOENT) {
 		err = 0;
 		ctx->pos = pos;
+	} else if (err < 0) {
+		if (err == -EINVAL)
+			ntfs_inode_err(dir, "directory corrupted");
+		ctx->pos = eod;
 	}
 
 	return err;
-- 
2.43.0



