Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F39663F1AD9;
	Wed, 20 May 2026 17:51:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299499; cv=none; b=QZPMINvtzhR6mTzWxK6YJRPwpUSr123YWR0mby9swfd/jCHU6ISc/YKFTuwhZd4ljIGoGpoiZuLds4BG/NYSWmLBkeCzWXI4fIqF0/5C73US+PfIWYoV129Auplp7rgv0NQy0Dz34IMDsWzXWSFnnAAqCBEjU+il1t844j1yJoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299499; c=relaxed/simple;
	bh=TIRj1GifDqPGPNtWQT3DbuWrZ+zzbaB2LqYVv8cgrGs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jMxtZvi4BWt/ncMQ9dAS81VkrnkxupvYvj0/At7euefpOCqyf8ov96UDDDPuLPZIx5N49j81T4iJFdjf8ge+BLas62JK0OH1NtDv2/PUkAK9YTHDx5NWWw5w4xiymAxpGnkHDClr5Ewt2m7gobBBT/827s12RrtGiA06ip9CK54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pTtRrNZ8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pTtRrNZ8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65CF61F000E9;
	Wed, 20 May 2026 17:51:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299497;
	bh=ygzInL6wOqXBZFQQl5oXWSEs65cTNxnHAOb0QMQJ6fs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pTtRrNZ8qw97fKuIgMmDbgTQjIDdRY2q6S1oe7llu2pn5QL8W+crSLJZcboEUY8zv
	 p808PVOHF2TR/xcmZM+ZCHu7RVe3mBzPAgpAhIBp7kzLgfhgz8mMJLHta1yxblJ+Di
	 An1+sJODMzFldFSCTh1bbxqA2UfIY5WiwedPLPdo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Su Yue <glass.su@suse.com>,
	Yu Kuai <yukuai@fnnas.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 793/957] md: factor bitmap creation away from sysfs handling
Date: Wed, 20 May 2026 18:21:16 +0200
Message-ID: <20260520162151.761963310@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yu Kuai <yukuai@fnnas.com>

[ Upstream commit 8776d342cf8fa0b98ca5e6fb2d956966fb5ca364 ]

Factor bitmap creation and destruction into helpers that do not touch
bitmap sysfs registration.

This prepares the bitmap sysfs rework so callers such as the sysfs
bitmap location path can create or destroy a bitmap backend without
coupling that to sysfs group lifetime management.

Reviewed-by: Su Yue <glass.su@suse.com>
Link: https://lore.kernel.org/r/20260425024615.1696892-2-yukuai@fnnas.com
Signed-off-by: Yu Kuai <yukuai@fnnas.com>
Stable-dep-of: f2926a533d03 ("md/md-bitmap: add a none backend for bitmap grow")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md.c | 78 +++++++++++++++++++++++++++++++------------------
 1 file changed, 49 insertions(+), 29 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 4520c485c0c06..3061370e959b3 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -686,7 +686,25 @@ static void active_io_release(struct percpu_ref *ref)
 
 static void no_op(struct percpu_ref *r) {}
 
-static bool mddev_set_bitmap_ops(struct mddev *mddev)
+static void md_bitmap_sysfs_add(struct mddev *mddev)
+{
+	if (sysfs_create_group(&mddev->kobj, mddev->bitmap_ops->group))
+		pr_warn("md: cannot register extra bitmap attributes for %s\n",
+			mdname(mddev));
+	else
+		/*
+		 * Inform user with KOBJ_CHANGE about new bitmap
+		 * attributes.
+		 */
+		kobject_uevent(&mddev->kobj, KOBJ_CHANGE);
+}
+
+static void md_bitmap_sysfs_del(struct mddev *mddev)
+{
+	sysfs_remove_group(&mddev->kobj, mddev->bitmap_ops->group);
+}
+
+static bool mddev_set_bitmap_ops_nosysfs(struct mddev *mddev)
 {
 	struct bitmap_operations *old = mddev->bitmap_ops;
 	struct md_submodule_head *head;
@@ -710,18 +728,6 @@ static bool mddev_set_bitmap_ops(struct mddev *mddev)
 
 	mddev->bitmap_ops = (void *)head;
 	xa_unlock(&md_submodule);
-
-	if (!mddev_is_dm(mddev) && mddev->bitmap_ops->group) {
-		if (sysfs_create_group(&mddev->kobj, mddev->bitmap_ops->group))
-			pr_warn("md: cannot register extra bitmap attributes for %s\n",
-				mdname(mddev));
-		else
-			/*
-			 * Inform user with KOBJ_CHANGE about new bitmap
-			 * attributes.
-			 */
-			kobject_uevent(&mddev->kobj, KOBJ_CHANGE);
-	}
 	return true;
 
 err:
@@ -729,15 +735,6 @@ static bool mddev_set_bitmap_ops(struct mddev *mddev)
 	return false;
 }
 
-static void mddev_clear_bitmap_ops(struct mddev *mddev)
-{
-	if (!mddev_is_dm(mddev) && mddev->bitmap_ops &&
-	    mddev->bitmap_ops->group)
-		sysfs_remove_group(&mddev->kobj, mddev->bitmap_ops->group);
-
-	mddev->bitmap_ops = NULL;
-}
-
 int mddev_init(struct mddev *mddev)
 {
 	int err = 0;
@@ -6404,7 +6401,7 @@ static enum md_submodule_id md_bitmap_get_id_from_sb(struct mddev *mddev)
 	return id;
 }
 
-static int md_bitmap_create(struct mddev *mddev)
+static int md_bitmap_create_nosysfs(struct mddev *mddev)
 {
 	enum md_submodule_id orig_id = mddev->bitmap_id;
 	enum md_submodule_id sb_id;
@@ -6413,7 +6410,7 @@ static int md_bitmap_create(struct mddev *mddev)
 	if (mddev->bitmap_id == ID_BITMAP_NONE)
 		return -EINVAL;
 
-	if (!mddev_set_bitmap_ops(mddev))
+	if (!mddev_set_bitmap_ops_nosysfs(mddev))
 		return -ENOENT;
 
 	err = mddev->bitmap_ops->create(mddev);
@@ -6425,7 +6422,7 @@ static int md_bitmap_create(struct mddev *mddev)
 	 * doesn't match, and mdadm is not the latest version to set
 	 * bitmap_type, set bitmap_ops based on the disk version.
 	 */
-	mddev_clear_bitmap_ops(mddev);
+	mddev->bitmap_ops = NULL;
 
 	sb_id = md_bitmap_get_id_from_sb(mddev);
 	if (sb_id == ID_BITMAP_NONE || sb_id == orig_id)
@@ -6435,27 +6432,50 @@ static int md_bitmap_create(struct mddev *mddev)
 		mdname(mddev), orig_id, sb_id);
 
 	mddev->bitmap_id = sb_id;
-	if (!mddev_set_bitmap_ops(mddev)) {
+	if (!mddev_set_bitmap_ops_nosysfs(mddev)) {
 		mddev->bitmap_id = orig_id;
 		return -ENOENT;
 	}
 
 	err = mddev->bitmap_ops->create(mddev);
 	if (err) {
-		mddev_clear_bitmap_ops(mddev);
+		mddev->bitmap_ops = NULL;
 		mddev->bitmap_id = orig_id;
 	}
 
 	return err;
 }
 
-static void md_bitmap_destroy(struct mddev *mddev)
+static int md_bitmap_create(struct mddev *mddev)
+{
+	int err;
+
+	err = md_bitmap_create_nosysfs(mddev);
+	if (err)
+		return err;
+
+	if (!mddev_is_dm(mddev) && mddev->bitmap_ops->group)
+		md_bitmap_sysfs_add(mddev);
+
+	return 0;
+}
+
+static void md_bitmap_destroy_nosysfs(struct mddev *mddev)
 {
 	if (!md_bitmap_registered(mddev))
 		return;
 
 	mddev->bitmap_ops->destroy(mddev);
-	mddev_clear_bitmap_ops(mddev);
+	mddev->bitmap_ops = NULL;
+}
+
+static void md_bitmap_destroy(struct mddev *mddev)
+{
+	if (!mddev_is_dm(mddev) && mddev->bitmap_ops &&
+	    mddev->bitmap_ops->group)
+		md_bitmap_sysfs_del(mddev);
+
+	md_bitmap_destroy_nosysfs(mddev);
 }
 
 int md_run(struct mddev *mddev)
-- 
2.53.0



