Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04CDE19E7F5;
	Thu, 15 Aug 2024 13:38:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729100; cv=none; b=dKYhZtO0gnu6xIUjSdM3ATm5/C1dIwumGpr5XAL0JN8bTxeqxp+LIg1DaAqzXd2GNWJfQKykzAuKnnpIg23aIpJ1Myw1W2kV/0emvA2MnsgbZt1U9py+J8vZEX/89FZGTi/uc6+z3pvCLu+oh9vfFujVY4Xt20zgrSxpCevkUJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729100; c=relaxed/simple;
	bh=aOpIzDSzZqYiXEefkQSfvZY52wwaL1a9IqEgOn+M1lQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mpuG7eCQvRBlwSTATJqiEb69uuv/31DEKTYv+DdgTa4z5hdtLJdjF+r2Btpy6ay31+iXIzvcBYk95bBtnxDd/wFvduAMh//a5UPfXkb8Bo9ekcV3WWwJUAAZT1uQ9q5PmNmz63cnW9DIqph9WH3lbillFaqxHCv/oWliO6prjdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hglwSt8M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hglwSt8M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28D84C4AF0A;
	Thu, 15 Aug 2024 13:38:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729099;
	bh=aOpIzDSzZqYiXEefkQSfvZY52wwaL1a9IqEgOn+M1lQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hglwSt8MlyBBBNctNraB3teJxtFSbpILKXU/cNHy3UdLkAIRZRDry87s9SjZtkCJE
	 0t9uzQk9QngPsnZq1SRxLSFrp8vqjfxHsZWIp62AF1IW2RggiQfofc4XnONrclXw5j
	 d1znoIb7Vy5MgL/M8bYEpHTrJSIt7a37E9t+LUWM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+36bb70085ef6edc2ebb9@syzkaller.appspotmail.com,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 14/22] fs/ntfs3: Do copy_to_user out of run_lock
Date: Thu, 15 Aug 2024 15:25:22 +0200
Message-ID: <20240815131831.809934953@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131831.265729493@linuxfoundation.org>
References: <20240815131831.265729493@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit d57431c6f511bf020e474026d9f3123d7bfbea8c ]

In order not to call copy_to_user (from fiemap_fill_next_extent)
we allocate memory in the kernel, fill it and copy it to user memory
after up_read(run_lock).

Reported-by: syzbot+36bb70085ef6edc2ebb9@syzkaller.appspotmail.com
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/frecord.c | 75 ++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 72 insertions(+), 3 deletions(-)

diff --git a/fs/ntfs3/frecord.c b/fs/ntfs3/frecord.c
index 4822cfd6351c2..ded451a84b773 100644
--- a/fs/ntfs3/frecord.c
+++ b/fs/ntfs3/frecord.c
@@ -1896,6 +1896,47 @@ enum REPARSE_SIGN ni_parse_reparse(struct ntfs_inode *ni, struct ATTRIB *attr,
 	return REPARSE_LINK;
 }
 
+/*
+ * fiemap_fill_next_extent_k - a copy of fiemap_fill_next_extent
+ * but it accepts kernel address for fi_extents_start
+ */
+static int fiemap_fill_next_extent_k(struct fiemap_extent_info *fieinfo,
+				     u64 logical, u64 phys, u64 len, u32 flags)
+{
+	struct fiemap_extent extent;
+	struct fiemap_extent __user *dest = fieinfo->fi_extents_start;
+
+	/* only count the extents */
+	if (fieinfo->fi_extents_max == 0) {
+		fieinfo->fi_extents_mapped++;
+		return (flags & FIEMAP_EXTENT_LAST) ? 1 : 0;
+	}
+
+	if (fieinfo->fi_extents_mapped >= fieinfo->fi_extents_max)
+		return 1;
+
+	if (flags & FIEMAP_EXTENT_DELALLOC)
+		flags |= FIEMAP_EXTENT_UNKNOWN;
+	if (flags & FIEMAP_EXTENT_DATA_ENCRYPTED)
+		flags |= FIEMAP_EXTENT_ENCODED;
+	if (flags & (FIEMAP_EXTENT_DATA_TAIL | FIEMAP_EXTENT_DATA_INLINE))
+		flags |= FIEMAP_EXTENT_NOT_ALIGNED;
+
+	memset(&extent, 0, sizeof(extent));
+	extent.fe_logical = logical;
+	extent.fe_physical = phys;
+	extent.fe_length = len;
+	extent.fe_flags = flags;
+
+	dest += fieinfo->fi_extents_mapped;
+	memcpy(dest, &extent, sizeof(extent));
+
+	fieinfo->fi_extents_mapped++;
+	if (fieinfo->fi_extents_mapped == fieinfo->fi_extents_max)
+		return 1;
+	return (flags & FIEMAP_EXTENT_LAST) ? 1 : 0;
+}
+
 /*
  * ni_fiemap - Helper for file_fiemap().
  *
@@ -1906,6 +1947,8 @@ int ni_fiemap(struct ntfs_inode *ni, struct fiemap_extent_info *fieinfo,
 	      __u64 vbo, __u64 len)
 {
 	int err = 0;
+	struct fiemap_extent __user *fe_u = fieinfo->fi_extents_start;
+	struct fiemap_extent *fe_k = NULL;
 	struct ntfs_sb_info *sbi = ni->mi.sbi;
 	u8 cluster_bits = sbi->cluster_bits;
 	struct runs_tree *run;
@@ -1953,6 +1996,18 @@ int ni_fiemap(struct ntfs_inode *ni, struct fiemap_extent_info *fieinfo,
 		goto out;
 	}
 
+	/*
+	 * To avoid lock problems replace pointer to user memory by pointer to kernel memory.
+	 */
+	fe_k = kmalloc_array(fieinfo->fi_extents_max,
+			     sizeof(struct fiemap_extent),
+			     GFP_NOFS | __GFP_ZERO);
+	if (!fe_k) {
+		err = -ENOMEM;
+		goto out;
+	}
+	fieinfo->fi_extents_start = fe_k;
+
 	end = vbo + len;
 	alloc_size = le64_to_cpu(attr->nres.alloc_size);
 	if (end > alloc_size)
@@ -2041,8 +2096,9 @@ int ni_fiemap(struct ntfs_inode *ni, struct fiemap_extent_info *fieinfo,
 			if (vbo + dlen >= end)
 				flags |= FIEMAP_EXTENT_LAST;
 
-			err = fiemap_fill_next_extent(fieinfo, vbo, lbo, dlen,
-						      flags);
+			err = fiemap_fill_next_extent_k(fieinfo, vbo, lbo, dlen,
+							flags);
+
 			if (err < 0)
 				break;
 			if (err == 1) {
@@ -2062,7 +2118,8 @@ int ni_fiemap(struct ntfs_inode *ni, struct fiemap_extent_info *fieinfo,
 		if (vbo + bytes >= end)
 			flags |= FIEMAP_EXTENT_LAST;
 
-		err = fiemap_fill_next_extent(fieinfo, vbo, lbo, bytes, flags);
+		err = fiemap_fill_next_extent_k(fieinfo, vbo, lbo, bytes,
+						flags);
 		if (err < 0)
 			break;
 		if (err == 1) {
@@ -2075,7 +2132,19 @@ int ni_fiemap(struct ntfs_inode *ni, struct fiemap_extent_info *fieinfo,
 
 	up_read(run_lock);
 
+	/*
+	 * Copy to user memory out of lock
+	 */
+	if (copy_to_user(fe_u, fe_k,
+			 fieinfo->fi_extents_max *
+				 sizeof(struct fiemap_extent))) {
+		err = -EFAULT;
+	}
+
 out:
+	/* Restore original pointer. */
+	fieinfo->fi_extents_start = fe_u;
+	kfree(fe_k);
 	return err;
 }
 
-- 
2.43.0



