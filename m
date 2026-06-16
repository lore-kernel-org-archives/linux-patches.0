Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95B3E466B5E;
	Tue, 16 Jun 2026 18:27:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781634452; cv=none; b=OPxn/IaV4jANQTwih9trJgJuWdLTNV0cBvN5kv1q8f5EzF2Csa4tG/70kudR6Z95KLgY6SZUI93xk0ZeNyRGkm9nW9+mtY9/8tJsyOPoWkDVmCciufEXGzDqy2uaWBKlxJ6WClXHEbear03V1A/LylZCkJDATbI1PTfbe72qqvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781634452; c=relaxed/simple;
	bh=snLjWRPFpYZ1xwvvhR80OdWNjRZARunSEL5tUnHj8Qs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sibXlLBhpf49moD/4UO2e0Ps3A9XLqWPvDjMAZZUjCANbZd7GTCufdKrwM1vBATjg9qSrx4lxjXUqqrlY1S3UEmvjg7ogKP67/4c4UgAg8VKwCXrEJOUxx14jz1A4MZAKWpLQCdIHFMCF7LbldL33/Vcuu0uq2z6c0oeuxR+qPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MHPj5RRp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MHPj5RRp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79E051F000E9;
	Tue, 16 Jun 2026 18:27:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781634451;
	bh=qC5H0SdnztO1JWjjVTXkZqU8Uia6JKwCmLgF3o1g1tw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MHPj5RRpFSEVF2YVWjmHPIYeK7VH13Y715vc3C0lofUFomVfRvEAwPo9gGewfykNi
	 2FTeyPbQp2NI3K+5mMRmo/mcJzhyiCs/bYTQ6YAwaxSXQEIfy4BiK+yEneoSwakuo3
	 Ynj7fCgWHjnKKgqUF4W2QbZBKoxU8ESeFF7O94XE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Junrui Luo <moonafterrain@outlook.com>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Chao Yu <chao@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 268/411] erofs: fix the out-of-bounds nameoff handling for trailing dirents
Date: Tue, 16 Jun 2026 20:28:26 +0530
Message-ID: <20260616145115.324914604@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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

From: Gao Xiang <hsiangkao@linux.alibaba.com>

[ Upstream commit d18a3b5d337fa412a38e776e6b4b857a58836575 ]

Currently we already have boundary-checks for nameoffs, but the trailing
dirents are special since the namelens are calculated with strnlen()
with unchecked nameoffs.

If a crafted EROFS has a trailing dirent with nameoff >= maxsize,
maxsize - nameoff can underflow, causing strnlen() to read past the
directory block.

nameoff0 should also be verified to be a multiple of
`sizeof(struct erofs_dirent)` as well [1].

[1] https://sashiko.dev/#/patchset/20260416063511.3173774-1-hsiangkao%40linux.alibaba.com

Fixes: 3aa8ec716e52 ("staging: erofs: add directory operations")
Fixes: 33bac912840f ("staging: erofs: keep corrupted fs from crashing kernel in erofs_readdir()")
Reported-by: Yuhao Jiang <danisjiang@gmail.com>
Reported-by: Junrui Luo <moonafterrain@outlook.com>
Closes: https://lore.kernel.org/r/A0FD7E0F-7558-49B0-8BC8-EB1ECDB2479A@outlook.com
Cc: stable@vger.kernel.org
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Reviewed-by: Chao Yu <chao@kernel.org>
[ replaced upstream `bsz` with `PAGE_SIZE` and `sizeof(*de)` with `sizeof(struct erofs_dirent)` ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/erofs/dir.c |   30 ++++++++++++++++--------------
 1 file changed, 16 insertions(+), 14 deletions(-)

--- a/fs/erofs/dir.c
+++ b/fs/erofs/dir.c
@@ -37,20 +37,18 @@ static int erofs_fill_dentries(struct in
 		nameoff = le16_to_cpu(de->nameoff);
 		de_name = (char *)dentry_blk + nameoff;
 
-		/* the last dirent in the block? */
-		if (de + 1 >= end)
-			de_namelen = strnlen(de_name, maxsize - nameoff);
-		else
+		/* non-trailing dirent in the directory block? */
+		if (de + 1 < end)
 			de_namelen = le16_to_cpu(de[1].nameoff) - nameoff;
+		else if (maxsize <= nameoff)
+			goto err_bogus;
+		else
+			de_namelen = strnlen(de_name, maxsize - nameoff);
 
-		/* a corrupted entry is found */
-		if (nameoff + de_namelen > maxsize ||
-		    de_namelen > EROFS_NAME_LEN) {
-			erofs_err(dir->i_sb, "bogus dirent @ nid %llu",
-				  EROFS_I(dir)->nid);
-			DBG_BUGON(1);
-			return -EFSCORRUPTED;
-		}
+		/* a corrupted entry is found (including negative namelen) */
+		if (!in_range32(de_namelen, 1, EROFS_NAME_LEN) ||
+		    nameoff + de_namelen > maxsize)
+			goto err_bogus;
 
 		debug_one_dentry(d_type, de_name, de_namelen);
 		if (!dir_emit(ctx, de_name, de_namelen,
@@ -62,6 +60,10 @@ static int erofs_fill_dentries(struct in
 	}
 	*ofs = maxsize;
 	return 0;
+err_bogus:
+	erofs_err(dir->i_sb, "bogus dirent @ nid %llu", EROFS_I(dir)->nid);
+	DBG_BUGON(1);
+	return -EFSCORRUPTED;
 }
 
 static int erofs_readdir(struct file *f, struct dir_context *ctx)
@@ -95,8 +97,8 @@ static int erofs_readdir(struct file *f,
 
 		nameoff = le16_to_cpu(de->nameoff);
 
-		if (nameoff < sizeof(struct erofs_dirent) ||
-		    nameoff >= PAGE_SIZE) {
+		if (!nameoff || nameoff >= PAGE_SIZE ||
+		    (nameoff % sizeof(struct erofs_dirent))) {
 			erofs_err(dir->i_sb,
 				  "invalid de[0].nameoff %u @ nid %llu",
 				  nameoff, EROFS_I(dir)->nid);


