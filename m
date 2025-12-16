Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 558F8340DBF;
	Tue, 16 Dec 2025 11:32:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884770; cv=none; b=D9D/ewJTCYO+/YNboZsfVLzUQviTyCdDJYY43+oHw9Sk5MTVpolmJnp6EBK1Hh+lAWnQYsUy06j6mtjkyy0a06MY4KS5yHuFOJTlwEMjGs4dMt+jv21uzL7N4ECzkoSu0YaaznKMr6jUenegviPvtxkb2nN1bhrgPnSJ0AmxpMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884770; c=relaxed/simple;
	bh=f7f61XocqucmsTA8yf1c8eY9dPaWjYr2vnwQDy72Bok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Un9XQePsJNgosa9XQpIuIOtL1R2nByYr2fV6F3if8ipipb6X6+XVe0V/PA3Zum7zqMeLK/2YEIo2l9TjS31z+Rguk+6CMDD7D3TfjFR0Pmh7dTC2J3R5F5J9XQAg/fbA30gbOfkmyEtLeh8cjiI4Z9duQXNpAgR24J0LQmEarMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m63kk/PO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m63kk/PO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 896D0C4CEF1;
	Tue, 16 Dec 2025 11:32:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884770;
	bh=f7f61XocqucmsTA8yf1c8eY9dPaWjYr2vnwQDy72Bok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m63kk/PO03QEzesVytTqgT8FGrPimlLZOpe85vx4eCuhyAtH6zJ1uKxoCkhcp9cOo
	 L6tNVPRz+XkKHo/36nT16z35dOzJDh6XxW+KF7b4OsivWBW+0uF0x4T/rLcKpifWfq
	 LV/Yrpugs9xVK8xlFuoqqOYpk2TAefD3zIS8GMYk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 294/354] f2fs: add a sysfs entry to reclaim POSIX_FADV_NOREUSE pages
Date: Tue, 16 Dec 2025 12:14:21 +0100
Message-ID: <20251216111331.563473845@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jaegeuk Kim <jaegeuk@kernel.org>

[ Upstream commit a907f3a68ee26ba493a08a958809208d17f3347e ]

1. fadvise(fd1, POSIX_FADV_NOREUSE, {0,3});
2. fadvise(fd2, POSIX_FADV_NOREUSE, {1,2});
3. fadvise(fd3, POSIX_FADV_NOREUSE, {3,1});
4. echo 1024 > /sys/fs/f2fs/tuning/reclaim_caches_kb

This gives a way to reclaim file-backed pages by iterating all f2fs mounts until
reclaiming 1MB page cache ranges, registered by #1, #2, and #3.

5. cat /sys/fs/f2fs/tuning/reclaim_caches_kb
-> gives total number of registered file ranges.

Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Stable-dep-of: e462fc48ceb8 ("f2fs: maintain one time GC mode is enabled during whole zoned GC cycle")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/ABI/testing/sysfs-fs-f2fs |  7 ++
 fs/f2fs/f2fs.h                          |  2 +
 fs/f2fs/shrinker.c                      | 90 +++++++++++++++++++++++++
 fs/f2fs/sysfs.c                         | 63 +++++++++++++++++
 4 files changed, 162 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-fs-f2fs b/Documentation/ABI/testing/sysfs-fs-f2fs
index 3e1630c70d8ae..81deae2af84d2 100644
--- a/Documentation/ABI/testing/sysfs-fs-f2fs
+++ b/Documentation/ABI/testing/sysfs-fs-f2fs
@@ -828,3 +828,10 @@ Date:		November 2024
 Contact:	"Chao Yu" <chao@kernel.org>
 Description:	It controls max read extent count for per-inode, the value of threshold
 		is 10240 by default.
+
+What:		/sys/fs/f2fs/tuning/reclaim_caches_kb
+Date:		February 2025
+Contact:	"Jaegeuk Kim" <jaegeuk@kernel.org>
+Description:	It reclaims the given KBs of file-backed pages registered by
+		ioctl(F2FS_IOC_DONATE_RANGE).
+		For example, writing N tries to drop N KBs spaces in LRU.
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 7ced2e2c65746..f2f3e02b6fd4c 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -4271,6 +4271,8 @@ unsigned long f2fs_shrink_count(struct shrinker *shrink,
 			struct shrink_control *sc);
 unsigned long f2fs_shrink_scan(struct shrinker *shrink,
 			struct shrink_control *sc);
+unsigned int f2fs_donate_files(void);
+void f2fs_reclaim_caches(unsigned int reclaim_caches_kb);
 void f2fs_join_shrinker(struct f2fs_sb_info *sbi);
 void f2fs_leave_shrinker(struct f2fs_sb_info *sbi);
 
diff --git a/fs/f2fs/shrinker.c b/fs/f2fs/shrinker.c
index 83d6fb97dcae0..45efff635d8e4 100644
--- a/fs/f2fs/shrinker.c
+++ b/fs/f2fs/shrinker.c
@@ -130,6 +130,96 @@ unsigned long f2fs_shrink_scan(struct shrinker *shrink,
 	return freed;
 }
 
+unsigned int f2fs_donate_files(void)
+{
+	struct f2fs_sb_info *sbi;
+	struct list_head *p;
+	unsigned int donate_files = 0;
+
+	spin_lock(&f2fs_list_lock);
+	p = f2fs_list.next;
+	while (p != &f2fs_list) {
+		sbi = list_entry(p, struct f2fs_sb_info, s_list);
+
+		/* stop f2fs_put_super */
+		if (!mutex_trylock(&sbi->umount_mutex)) {
+			p = p->next;
+			continue;
+		}
+		spin_unlock(&f2fs_list_lock);
+
+		donate_files += sbi->donate_files;
+
+		spin_lock(&f2fs_list_lock);
+		p = p->next;
+		mutex_unlock(&sbi->umount_mutex);
+	}
+	spin_unlock(&f2fs_list_lock);
+
+	return donate_files;
+}
+
+static unsigned int do_reclaim_caches(struct f2fs_sb_info *sbi,
+				unsigned int reclaim_caches_kb)
+{
+	struct inode *inode;
+	struct f2fs_inode_info *fi;
+	unsigned int nfiles = sbi->donate_files;
+	pgoff_t npages = reclaim_caches_kb >> (PAGE_SHIFT - 10);
+
+	while (npages && nfiles--) {
+		pgoff_t len;
+
+		spin_lock(&sbi->inode_lock[DONATE_INODE]);
+		if (list_empty(&sbi->inode_list[DONATE_INODE])) {
+			spin_unlock(&sbi->inode_lock[DONATE_INODE]);
+			break;
+		}
+		fi = list_first_entry(&sbi->inode_list[DONATE_INODE],
+					struct f2fs_inode_info, gdonate_list);
+		list_move_tail(&fi->gdonate_list, &sbi->inode_list[DONATE_INODE]);
+		inode = igrab(&fi->vfs_inode);
+		spin_unlock(&sbi->inode_lock[DONATE_INODE]);
+
+		if (!inode)
+			continue;
+
+		len = fi->donate_end - fi->donate_start + 1;
+		npages = npages < len ? 0 : npages - len;
+		invalidate_inode_pages2_range(inode->i_mapping,
+					fi->donate_start, fi->donate_end);
+		iput(inode);
+		cond_resched();
+	}
+	return npages << (PAGE_SHIFT - 10);
+}
+
+void f2fs_reclaim_caches(unsigned int reclaim_caches_kb)
+{
+	struct f2fs_sb_info *sbi;
+	struct list_head *p;
+
+	spin_lock(&f2fs_list_lock);
+	p = f2fs_list.next;
+	while (p != &f2fs_list && reclaim_caches_kb) {
+		sbi = list_entry(p, struct f2fs_sb_info, s_list);
+
+		/* stop f2fs_put_super */
+		if (!mutex_trylock(&sbi->umount_mutex)) {
+			p = p->next;
+			continue;
+		}
+		spin_unlock(&f2fs_list_lock);
+
+		reclaim_caches_kb = do_reclaim_caches(sbi, reclaim_caches_kb);
+
+		spin_lock(&f2fs_list_lock);
+		p = p->next;
+		mutex_unlock(&sbi->umount_mutex);
+	}
+	spin_unlock(&f2fs_list_lock);
+}
+
 void f2fs_join_shrinker(struct f2fs_sb_info *sbi)
 {
 	spin_lock(&f2fs_list_lock);
diff --git a/fs/f2fs/sysfs.c b/fs/f2fs/sysfs.c
index b3c04ecc3a271..5c4fd0f3acab7 100644
--- a/fs/f2fs/sysfs.c
+++ b/fs/f2fs/sysfs.c
@@ -939,6 +939,39 @@ static struct f2fs_base_attr f2fs_base_attr_##_name = {		\
 	.show	= f2fs_feature_show,				\
 }
 
+static ssize_t f2fs_tune_show(struct f2fs_base_attr *a, char *buf)
+{
+	unsigned int res = 0;
+
+	if (!strcmp(a->attr.name, "reclaim_caches_kb"))
+		res = f2fs_donate_files();
+
+	return sysfs_emit(buf, "%u\n", res);
+}
+
+static ssize_t f2fs_tune_store(struct f2fs_base_attr *a,
+			const char *buf, size_t count)
+{
+	unsigned long t;
+	int ret;
+
+	ret = kstrtoul(skip_spaces(buf), 0, &t);
+	if (ret)
+		return ret;
+
+	if (!strcmp(a->attr.name, "reclaim_caches_kb"))
+		f2fs_reclaim_caches(t);
+
+	return count;
+}
+
+#define F2FS_TUNE_RW_ATTR(_name)				\
+static struct f2fs_base_attr f2fs_base_attr_##_name = {		\
+	.attr = {.name = __stringify(_name), .mode = 0644 },	\
+	.show	= f2fs_tune_show,				\
+	.store	= f2fs_tune_store,				\
+}
+
 static ssize_t f2fs_sb_feature_show(struct f2fs_attr *a,
 		struct f2fs_sb_info *sbi, char *buf)
 {
@@ -1389,6 +1422,14 @@ static struct attribute *f2fs_sb_feat_attrs[] = {
 };
 ATTRIBUTE_GROUPS(f2fs_sb_feat);
 
+F2FS_TUNE_RW_ATTR(reclaim_caches_kb);
+
+static struct attribute *f2fs_tune_attrs[] = {
+	BASE_ATTR_LIST(reclaim_caches_kb),
+	NULL,
+};
+ATTRIBUTE_GROUPS(f2fs_tune);
+
 static const struct sysfs_ops f2fs_attr_ops = {
 	.show	= f2fs_attr_show,
 	.store	= f2fs_attr_store,
@@ -1422,6 +1463,20 @@ static struct kobject f2fs_feat = {
 	.kset	= &f2fs_kset,
 };
 
+static const struct sysfs_ops f2fs_tune_attr_ops = {
+	.show	= f2fs_base_attr_show,
+	.store	= f2fs_base_attr_store,
+};
+
+static const struct kobj_type f2fs_tune_ktype = {
+	.default_groups = f2fs_tune_groups,
+	.sysfs_ops	= &f2fs_tune_attr_ops,
+};
+
+static struct kobject f2fs_tune = {
+	.kset	= &f2fs_kset,
+};
+
 static ssize_t f2fs_stat_attr_show(struct kobject *kobj,
 				struct attribute *attr, char *buf)
 {
@@ -1660,6 +1715,11 @@ int __init f2fs_init_sysfs(void)
 	if (ret)
 		goto put_kobject;
 
+	ret = kobject_init_and_add(&f2fs_tune, &f2fs_tune_ktype,
+				   NULL, "tuning");
+	if (ret)
+		goto put_kobject;
+
 	f2fs_proc_root = proc_mkdir("fs/f2fs", NULL);
 	if (!f2fs_proc_root) {
 		ret = -ENOMEM;
@@ -1667,7 +1727,9 @@ int __init f2fs_init_sysfs(void)
 	}
 
 	return 0;
+
 put_kobject:
+	kobject_put(&f2fs_tune);
 	kobject_put(&f2fs_feat);
 	kset_unregister(&f2fs_kset);
 	return ret;
@@ -1675,6 +1737,7 @@ int __init f2fs_init_sysfs(void)
 
 void f2fs_exit_sysfs(void)
 {
+	kobject_put(&f2fs_tune);
 	kobject_put(&f2fs_feat);
 	kset_unregister(&f2fs_kset);
 	remove_proc_entry("fs/f2fs", NULL);
-- 
2.51.0



