Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BA93E571;
	Mon, 14 Oct 2024 14:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728915883; cv=none; b=laegXNas4oJmlOFYrqRDkVcTTfPbs82X6XWQEFgiyo1JmSfUDdM2z95gr6+WjFuDdeXJmayD2e7QEtGs7vwlHuXlHD/xaeQH9/vUnFXA9cv3rFDGcC3PJPMF1qA4YuI244UswgSMP7dO1oJ10Yiyoq14Zu5BrJFW9lPNkhAQ0/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728915883; c=relaxed/simple;
	bh=J93wB9J+L810e+dt1eP5GJILz0qzBwtDs1zKorhtH5c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BkIHP7oepkl561/TTzX8yPpIkhc709dav1HU+CjXtR8gOqdp2NlIzcvZyjqqJKgxbksmL7sLnTLwpgGEOGh9esNWCC3boaM0ULAxEHHGUac9zPrNgi4AlFxkiLe7UctCZuXPHG7qnxRyhTfrS7RFDYDwSMpWPknaPMtqIWwnXEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n67evUJu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n67evUJu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBF08C4CEC3;
	Mon, 14 Oct 2024 14:24:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728915883;
	bh=J93wB9J+L810e+dt1eP5GJILz0qzBwtDs1zKorhtH5c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n67evUJuo4ClouXGffq4GjT3RzBxuQU9H8Opm6h4YTcBUNQ5+i3LcBCurnqR23Mea
	 4/T+Eu4JYmYn1UCpg0kKTrli6vq0oBjFafPUsPKDCvZNDo84XZEnDT13uoIy1Ic6XV
	 llI3FicobElew0PIiBI3G2wPT7f+GSFrKdXBp/yo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 006/214] fs/ntfs3: Fix sparse warning in ni_fiemap
Date: Mon, 14 Oct 2024 16:17:49 +0200
Message-ID: <20241014141045.239896009@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141044.974962104@linuxfoundation.org>
References: <20241014141044.974962104@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index a469c608a3948..60c975ac38e61 100644
--- a/fs/ntfs3/frecord.c
+++ b/fs/ntfs3/frecord.c
@@ -1900,13 +1900,13 @@ enum REPARSE_SIGN ni_parse_reparse(struct ntfs_inode *ni, struct ATTRIB *attr,
 
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
@@ -1930,8 +1930,7 @@ static int fiemap_fill_next_extent_k(struct fiemap_extent_info *fieinfo,
 	extent.fe_length = len;
 	extent.fe_flags = flags;
 
-	dest += fieinfo->fi_extents_mapped;
-	memcpy(dest, &extent, sizeof(extent));
+	memcpy(fe_k + fieinfo->fi_extents_mapped, &extent, sizeof(extent));
 
 	fieinfo->fi_extents_mapped++;
 	if (fieinfo->fi_extents_mapped == fieinfo->fi_extents_max)
@@ -1949,7 +1948,6 @@ int ni_fiemap(struct ntfs_inode *ni, struct fiemap_extent_info *fieinfo,
 	      __u64 vbo, __u64 len)
 {
 	int err = 0;
-	struct fiemap_extent __user *fe_u = fieinfo->fi_extents_start;
 	struct fiemap_extent *fe_k = NULL;
 	struct ntfs_sb_info *sbi = ni->mi.sbi;
 	u8 cluster_bits = sbi->cluster_bits;
@@ -2008,7 +2006,6 @@ int ni_fiemap(struct ntfs_inode *ni, struct fiemap_extent_info *fieinfo,
 		err = -ENOMEM;
 		goto out;
 	}
-	fieinfo->fi_extents_start = fe_k;
 
 	end = vbo + len;
 	alloc_size = le64_to_cpu(attr->nres.alloc_size);
@@ -2098,8 +2095,8 @@ int ni_fiemap(struct ntfs_inode *ni, struct fiemap_extent_info *fieinfo,
 			if (vbo + dlen >= end)
 				flags |= FIEMAP_EXTENT_LAST;
 
-			err = fiemap_fill_next_extent_k(fieinfo, vbo, lbo, dlen,
-							flags);
+			err = fiemap_fill_next_extent_k(fieinfo, fe_k, vbo, lbo,
+							dlen, flags);
 
 			if (err < 0)
 				break;
@@ -2120,7 +2117,7 @@ int ni_fiemap(struct ntfs_inode *ni, struct fiemap_extent_info *fieinfo,
 		if (vbo + bytes >= end)
 			flags |= FIEMAP_EXTENT_LAST;
 
-		err = fiemap_fill_next_extent_k(fieinfo, vbo, lbo, bytes,
+		err = fiemap_fill_next_extent_k(fieinfo, fe_k, vbo, lbo, bytes,
 						flags);
 		if (err < 0)
 			break;
@@ -2137,15 +2134,13 @@ int ni_fiemap(struct ntfs_inode *ni, struct fiemap_extent_info *fieinfo,
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



