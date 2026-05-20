Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DB08372EED;
	Wed, 20 May 2026 17:09:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296956; cv=none; b=OqIOmSVkdp1J1aqaRn5CVpHXaj2yMacyOJEX9u/Vk+VXzZCfd2UzPmVFx56KfwXZXGjHZaCZ81zeQ/2f94UL/FueNi1cHndAwtAw/HkZbhrw+rzI+DfnpsOtagy8IKkjS82JlxAmIKOoDEeR7hXySV6jWz+qlDXpuvnp9WCOQm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296956; c=relaxed/simple;
	bh=0LbHfqfKhKfrt6An6C4tI2l7mRRyXJ/Yru+Z2GEdv4U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=obQmjdGYmdWm8sjB0VahSPfYc4bDWjp+2mBmOmzqG/AWF+nJjEr/Twn0ybv8d6avNBkFnYV/jg5KxUL6jjny9pLTAnlzIuXUj1QW3rDe+++kLlPPSQHkwM/IWjOVjVMyfV1+fxZgMkSEqtz9yMcl8HLT82zwCF3i66pzuGMaTHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UxX3KKZD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UxX3KKZD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C168B1F000E9;
	Wed, 20 May 2026 17:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296954;
	bh=7XuMedGLx+OcbZCmtsaaQ+0W0gXi3tGYm8ub7d6cWyc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UxX3KKZDQd1c/zDf2JQf1Lrzh2RhwnMuOhIdeas6B0obZRgpz0pUB0DhgIoLg5+Lh
	 C9tCabpNXdUIHr6UEugvRyPlTJWhZGbbQqbHaAigbvyi50bweX7GANmw5k+KLItAlv
	 /VUJlXf/aQz2JgxsEcpeM7VpcwXh0wRBkOOcRzs4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Su Yue <glass.su@suse.com>,
	Yu Kuai <yukuai@fnnas.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0958/1146] md/md-bitmap: split bitmap sysfs groups
Date: Wed, 20 May 2026 18:20:08 +0200
Message-ID: <20260520162209.913443792@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yu Kuai <yukuai@fnnas.com>

[ Upstream commit aba3d6d6cb55c6e1116d1215140559dd7ecdf9a9 ]

Split the classic bitmap sysfs files into a common bitmap group with
the location attribute and a separate internal bitmap group for the
remaining files.

At the same time, convert bitmap operations from a single sysfs group
to a sysfs group array so backends can share part of their sysfs
layout while adding backend-specific attributes separately.

Switch the bitmap sysfs helpers to use sysfs_update_groups() for the
add and update path, and remove groups in reverse order so shared named
groups are unmerged before the last group removes the directory.

Also make bitmap operation lookup depend only on the currently selected
bitmap id matching the installed backend. This prepares the lookup path
for a later registered none backend.

Reviewed-by: Su Yue <glass.su@suse.com>
Link: https://lore.kernel.org/r/20260425024615.1696892-3-yukuai@fnnas.com
Signed-off-by: Yu Kuai <yukuai@fnnas.com>
Stable-dep-of: f2926a533d03 ("md/md-bitmap: add a none backend for bitmap grow")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md-bitmap.c   | 23 +++++++++++++++++++----
 drivers/md/md-bitmap.h   |  2 +-
 drivers/md/md-llbitmap.c |  7 ++++++-
 drivers/md/md.c          | 21 ++++++++++++++-------
 4 files changed, 40 insertions(+), 13 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 83378c033c728..eba649703a1c0 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -2955,8 +2955,12 @@ static struct md_sysfs_entry max_backlog_used =
 __ATTR(max_backlog_used, S_IRUGO | S_IWUSR,
        behind_writes_used_show, behind_writes_used_reset);
 
-static struct attribute *md_bitmap_attrs[] = {
+static struct attribute *md_bitmap_common_attrs[] = {
 	&bitmap_location.attr,
+	NULL
+};
+
+static struct attribute *md_bitmap_internal_attrs[] = {
 	&bitmap_space.attr,
 	&bitmap_timeout.attr,
 	&bitmap_backlog.attr,
@@ -2967,9 +2971,20 @@ static struct attribute *md_bitmap_attrs[] = {
 	NULL
 };
 
-static struct attribute_group md_bitmap_group = {
+static struct attribute_group md_bitmap_common_group = {
+	.name = "bitmap",
+	.attrs = md_bitmap_common_attrs,
+};
+
+static struct attribute_group md_bitmap_internal_group = {
 	.name = "bitmap",
-	.attrs = md_bitmap_attrs,
+	.attrs = md_bitmap_internal_attrs,
+};
+
+static const struct attribute_group *bitmap_groups[] = {
+	&md_bitmap_common_group,
+	&md_bitmap_internal_group,
+	NULL,
 };
 
 static struct bitmap_operations bitmap_ops = {
@@ -3013,7 +3028,7 @@ static struct bitmap_operations bitmap_ops = {
 	.set_pages		= bitmap_set_pages,
 	.free			= md_bitmap_free,
 
-	.group			= &md_bitmap_group,
+	.groups			= bitmap_groups,
 };
 
 int md_bitmap_init(void)
diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index b42a28fa83a0f..214f623c7e790 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -125,7 +125,7 @@ struct bitmap_operations {
 	void (*set_pages)(void *data, unsigned long pages);
 	void (*free)(void *data);
 
-	struct attribute_group *group;
+	const struct attribute_group **groups;
 };
 
 /* the bitmap API */
diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
index cdfecaca216bf..aeb061166e732 100644
--- a/drivers/md/md-llbitmap.c
+++ b/drivers/md/md-llbitmap.c
@@ -1562,6 +1562,11 @@ static struct attribute_group md_llbitmap_group = {
 	.attrs = md_llbitmap_attrs,
 };
 
+static const struct attribute_group *md_llbitmap_groups[] = {
+	&md_llbitmap_group,
+	NULL,
+};
+
 static struct bitmap_operations llbitmap_ops = {
 	.head = {
 		.type	= MD_BITMAP,
@@ -1598,7 +1603,7 @@ static struct bitmap_operations llbitmap_ops = {
 	.dirty_bits		= llbitmap_dirty_bits,
 	.write_all		= llbitmap_write_all,
 
-	.group			= &md_llbitmap_group,
+	.groups			= md_llbitmap_groups,
 };
 
 int md_llbitmap_init(void)
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 3b58d94c1c7aa..f736aead193ba 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -690,7 +690,7 @@ static void no_op(struct percpu_ref *r) {}
 
 static void md_bitmap_sysfs_add(struct mddev *mddev)
 {
-	if (sysfs_create_group(&mddev->kobj, mddev->bitmap_ops->group))
+	if (sysfs_update_groups(&mddev->kobj, mddev->bitmap_ops->groups))
 		pr_warn("md: cannot register extra bitmap attributes for %s\n",
 			mdname(mddev));
 	else
@@ -703,16 +703,23 @@ static void md_bitmap_sysfs_add(struct mddev *mddev)
 
 static void md_bitmap_sysfs_del(struct mddev *mddev)
 {
-	sysfs_remove_group(&mddev->kobj, mddev->bitmap_ops->group);
+	int nr_groups = 0;
+
+	for (nr_groups = 0; mddev->bitmap_ops->groups[nr_groups]; nr_groups++)
+		;
+
+	while (--nr_groups >= 1)
+		sysfs_unmerge_group(&mddev->kobj,
+				    mddev->bitmap_ops->groups[nr_groups]);
+	sysfs_remove_group(&mddev->kobj, mddev->bitmap_ops->groups[0]);
 }
 
 static bool mddev_set_bitmap_ops_nosysfs(struct mddev *mddev)
 {
-	struct bitmap_operations *old = mddev->bitmap_ops;
 	struct md_submodule_head *head;
 
-	if (mddev->bitmap_id == ID_BITMAP_NONE ||
-	    (old && old->head.id == mddev->bitmap_id))
+	if (mddev->bitmap_ops &&
+	    mddev->bitmap_ops->head.id == mddev->bitmap_id)
 		return true;
 
 	xa_lock(&md_submodule);
@@ -6590,7 +6597,7 @@ static int md_bitmap_create(struct mddev *mddev)
 	if (err)
 		return err;
 
-	if (!mddev_is_dm(mddev) && mddev->bitmap_ops->group)
+	if (!mddev_is_dm(mddev) && mddev->bitmap_ops->groups)
 		md_bitmap_sysfs_add(mddev);
 
 	return 0;
@@ -6608,7 +6615,7 @@ static void md_bitmap_destroy_nosysfs(struct mddev *mddev)
 static void md_bitmap_destroy(struct mddev *mddev)
 {
 	if (!mddev_is_dm(mddev) && mddev->bitmap_ops &&
-	    mddev->bitmap_ops->group)
+	    mddev->bitmap_ops->groups)
 		md_bitmap_sysfs_del(mddev);
 
 	md_bitmap_destroy_nosysfs(mddev);
-- 
2.53.0



