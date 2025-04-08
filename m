Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58C6A207E14;
	Tue,  8 Apr 2025 11:24:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111472; cv=none; b=o+o873XaO6ADP0R6UQk/TyaqghoSQescc4sq5kxWegnEIHcgoJUzBUM+OE/0XThXF+pYXEAkNv3fw8nNGsiWMboF8qL2NLnQ1DDtoptHt5qSFILVnNC/rmsPR9Rt1PyMq3D7dXSIKMMhKM5y5B/i6dBh0nI5i3NgXBftOR1+5mo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111472; c=relaxed/simple;
	bh=tbKSaYRhj+pAl4H/x0+vSwVlLK6nkltcahD6lVF2Tls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fl4PintJbtXxs+dr0KtFkt/C08HX1iPvipuGY+nTklWV/fmzW77PvQm49wtjRGOx7KqcEJuD8P4VScWDc8CKSLkf5P0Jtp2OgzLyxAqR7uYeWgIPmgiYFgdpB2VMxgRKOBLqcNDrQdip/q4fMOps52U2bL3nYbOl3Q17hnvQ/i4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EoYFa/KX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EoYFa/KX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF56CC4CEE5;
	Tue,  8 Apr 2025 11:24:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111472;
	bh=tbKSaYRhj+pAl4H/x0+vSwVlLK6nkltcahD6lVF2Tls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EoYFa/KXc1qqudkTqQXGhNCYnBAreaFhmqkj0gIfv2FNmV8Uj1wwtWyDlWRYwhwLc
	 uxom4vnTCzkhm2YiTJ2K6MWFWNZ34sTxyvOQtdWZI3x5CnwK+LDGcqwUFpXKtTjIqP
	 jOAxVIfJomZgXoEToeayRwOD8dS2MNJWDjjWWBsU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ye Bin <yebin10@huawei.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 443/731] fs/ntfs3: Factor out ntfs_{create/remove}_procdir()
Date: Tue,  8 Apr 2025 12:45:40 +0200
Message-ID: <20250408104924.577478617@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ye Bin <yebin10@huawei.com>

[ Upstream commit e2d74c47a3d3d84a5fa444f380c126328b44f4db ]

Introduce ntfs_create_procdir() and ntfs_remove_procdir() to
create/remove "/proc/fs/ntfs3/.."

Signed-off-by: Ye Bin <yebin10@huawei.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Stable-dep-of: 1d1a7e252549 ("fs/ntfs3: Fix 'proc_info_root' leak when init ntfs failed")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/super.c | 59 +++++++++++++++++++++++++++++-------------------
 1 file changed, 36 insertions(+), 23 deletions(-)

diff --git a/fs/ntfs3/super.c b/fs/ntfs3/super.c
index 6a0f6b0a3ab2a..415492fc655ac 100644
--- a/fs/ntfs3/super.c
+++ b/fs/ntfs3/super.c
@@ -555,6 +555,40 @@ static const struct proc_ops ntfs3_label_fops = {
 	.proc_write = ntfs3_label_write,
 };
 
+static void ntfs_create_procdir(struct super_block *sb)
+{
+	struct proc_dir_entry *e;
+
+	if (!proc_info_root)
+		return;
+
+	e = proc_mkdir(sb->s_id, proc_info_root);
+	if (e) {
+		struct ntfs_sb_info *sbi = sb->s_fs_info;
+
+		proc_create_data("volinfo", 0444, e,
+				 &ntfs3_volinfo_fops, sb);
+		proc_create_data("label", 0644, e,
+				 &ntfs3_label_fops, sb);
+		sbi->procdir = e;
+	}
+}
+
+static void ntfs_remove_procdir(struct super_block *sb)
+{
+	struct ntfs_sb_info *sbi = sb->s_fs_info;
+
+	if (!sbi->procdir)
+		return;
+
+	remove_proc_entry("label", sbi->procdir);
+	remove_proc_entry("volinfo", sbi->procdir);
+	remove_proc_entry(sb->s_id, proc_info_root);
+	sbi->procdir = NULL;
+}
+#else
+static void ntfs_create_procdir(struct super_block *sb) {}
+static void ntfs_remove_procdir(struct super_block *sb) {}
 #endif
 
 static struct kmem_cache *ntfs_inode_cachep;
@@ -644,15 +678,7 @@ static void ntfs_put_super(struct super_block *sb)
 {
 	struct ntfs_sb_info *sbi = sb->s_fs_info;
 
-#ifdef CONFIG_PROC_FS
-	// Remove /proc/fs/ntfs3/..
-	if (sbi->procdir) {
-		remove_proc_entry("label", sbi->procdir);
-		remove_proc_entry("volinfo", sbi->procdir);
-		remove_proc_entry(sb->s_id, proc_info_root);
-		sbi->procdir = NULL;
-	}
-#endif
+	ntfs_remove_procdir(sb);
 
 	/* Mark rw ntfs as clear, if possible. */
 	ntfs_set_state(sbi, NTFS_DIRTY_CLEAR);
@@ -1590,20 +1616,7 @@ static int ntfs_fill_super(struct super_block *sb, struct fs_context *fc)
 		kfree(boot2);
 	}
 
-#ifdef CONFIG_PROC_FS
-	/* Create /proc/fs/ntfs3/.. */
-	if (proc_info_root) {
-		struct proc_dir_entry *e = proc_mkdir(sb->s_id, proc_info_root);
-		static_assert((S_IRUGO | S_IWUSR) == 0644);
-		if (e) {
-			proc_create_data("volinfo", S_IRUGO, e,
-					 &ntfs3_volinfo_fops, sb);
-			proc_create_data("label", S_IRUGO | S_IWUSR, e,
-					 &ntfs3_label_fops, sb);
-			sbi->procdir = e;
-		}
-	}
-#endif
+	ntfs_create_procdir(sb);
 
 	if (is_legacy_ntfs(sb))
 		sb->s_flags |= SB_RDONLY;
-- 
2.39.5



