Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A47C21AC887;
	Mon, 14 Oct 2024 15:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919695; cv=none; b=fchxLE94VAE+hPd8PAnYp1CPqrv4N6WXKOZpHYzg6gQJ7RHDM/mgX1ZWUTowagaaHI4V1M9MI9d06ycB1fZiGlRH6mpfDQmNyilRAl/or1RJeGaCkhGl+WJljebd6DV6lYfUl9v28ed3aBoXkZozrExpRDxl2mEUvtXFWR2ZweQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919695; c=relaxed/simple;
	bh=xen6wT5ARhlcZPblqQCPFpdJdnqcWjL8oQW29fMw7vs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E1m91hbqyUs20zqSl+oNskKlrBuhoIyxYtU99VJ6Cn6UFbXOHWRhkfVaeZ3rH5cuRDh47Btk2csn6pbcoZY0uu53Moqj+3ggfJZdoDqNadeP+V0ZoZkOhIAVl/qEDiUmPGh3/Pkq2pXFVLKVTGo2S29YFvfO10+sGyC18ve9BWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iMpF1Oxb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iMpF1Oxb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1533DC4CEC3;
	Mon, 14 Oct 2024 15:28:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919695;
	bh=xen6wT5ARhlcZPblqQCPFpdJdnqcWjL8oQW29fMw7vs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iMpF1OxbVr8PMe9UMj2toUHo0qLQr5iTCtgS5h/QejaxEIN/iqs3Rk5m9JXwkqPDC
	 CxskvyzYVsrqEZUGcz5xEaNsCsNkKPgKFgDJvG1Kvxje0rpWla+z8yd8id74GhT7uz
	 KuzYET3lmFfn86H524d1Ijq2I7ac6yNNquSnHdTc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 682/798] fs/ntfs3: Fix sparse warning in ni_fiemap
Date: Mon, 14 Oct 2024 16:20:36 +0200
Message-ID: <20241014141244.863420798@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit 62fea783f96ce825f0ac9e40ce9530ddc1ea2a29 ]

The interface of fiemap_fill_next_extent_k() was modified
to eliminate the sparse warning.

Fixes: d57431c6f511 ("fs/ntfs3: Do copy_to_user out of run_lock")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202406271920.hndE8N6D-lkp@intel.com/
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/frecord.c | 21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)

diff --git a/fs/ntfs3/frecord.c b/fs/ntfs3/frecord.c
index b3299cda59622..e19510f977112 100644
--- a/fs/ntfs3/frecord.c
+++ b/fs/ntfs3/frecord.c
@@ -1901,13 +1901,13 @@ enum REPARSE_SIGN ni_parse_reparse(struct ntfs_inode *ni, struct ATTRIB *attr,
 
 /*
  * fiemap_fill_next_extent_k - a copy of fiemap_fill_next_extent
- * but it accepts kernel address for fi_extents_start
+ * but it uses 'fe_k' instead of fieinfo->fi_extents_start
  */
 static int fiemap_fill_next_extent_k(struct fiemap_extent_info *fieinfo,
-				     u64 logical, u64 phys, u64 len, u32 flags)
+				     struct fiemap_extent *fe_k, u64 logical,
+				     u64 phys, u64 len, u32 flags)
 {
 	struct fiemap_extent extent;
-	struct fiemap_extent __user *dest = fieinfo->fi_extents_start;
 
 	/* only count the extents */
 	if (fieinfo->fi_extents_max == 0) {
@@ -1931,8 +1931,7 @@ static int fiemap_fill_next_extent_k(struct fiemap_extent_info *fieinfo,
 	extent.fe_length = len;
 	extent.fe_flags = flags;
 
-	dest += fieinfo->fi_extents_mapped;
-	memcpy(dest, &extent, sizeof(extent));
+	memcpy(fe_k + fieinfo->fi_extents_mapped, &extent, sizeof(extent));
 
 	fieinfo->fi_extents_mapped++;
 	if (fieinfo->fi_extents_mapped == fieinfo->fi_extents_max)
@@ -1950,7 +1949,6 @@ int ni_fiemap(struct ntfs_inode *ni, struct fiemap_extent_info *fieinfo,
 	      __u64 vbo, __u64 len)
 {
 	int err = 0;
-	struct fiemap_extent __user *fe_u = fieinfo->fi_extents_start;
 	struct fiemap_extent *fe_k = NULL;
 	struct ntfs_sb_info *sbi = ni->mi.sbi;
 	u8 cluster_bits = sbi->cluster_bits;
@@ -2009,7 +2007,6 @@ int ni_fiemap(struct ntfs_inode *ni, struct fiemap_extent_info *fieinfo,
 		err = -ENOMEM;
 		goto out;
 	}
-	fieinfo->fi_extents_start = fe_k;
 
 	end = vbo + len;
 	alloc_size = le64_to_cpu(attr->nres.alloc_size);
@@ -2099,8 +2096,8 @@ int ni_fiemap(struct ntfs_inode *ni, struct fiemap_extent_info *fieinfo,
 			if (vbo + dlen >= end)
 				flags |= FIEMAP_EXTENT_LAST;
 
-			err = fiemap_fill_next_extent_k(fieinfo, vbo, lbo, dlen,
-							flags);
+			err = fiemap_fill_next_extent_k(fieinfo, fe_k, vbo, lbo,
+							dlen, flags);
 
 			if (err < 0)
 				break;
@@ -2121,7 +2118,7 @@ int ni_fiemap(struct ntfs_inode *ni, struct fiemap_extent_info *fieinfo,
 		if (vbo + bytes >= end)
 			flags |= FIEMAP_EXTENT_LAST;
 
-		err = fiemap_fill_next_extent_k(fieinfo, vbo, lbo, bytes,
+		err = fiemap_fill_next_extent_k(fieinfo, fe_k, vbo, lbo, bytes,
 						flags);
 		if (err < 0)
 			break;
@@ -2138,15 +2135,13 @@ int ni_fiemap(struct ntfs_inode *ni, struct fiemap_extent_info *fieinfo,
 	/*
 	 * Copy to user memory out of lock
 	 */
-	if (copy_to_user(fe_u, fe_k,
+	if (copy_to_user(fieinfo->fi_extents_start, fe_k,
 			 fieinfo->fi_extents_max *
 				 sizeof(struct fiemap_extent))) {
 		err = -EFAULT;
 	}
 
 out:
-	/* Restore original pointer. */
-	fieinfo->fi_extents_start = fe_u;
 	kfree(fe_k);
 	return err;
 }
-- 
2.43.0



