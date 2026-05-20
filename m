Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 358BD3F166E;
	Wed, 20 May 2026 17:08:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296926; cv=none; b=hYtTnEqmAmBMRllNX8fxdvPTe7IMr0bamkrBKbs9pVr405XEWNAezKiYkf/fBKXuhQBo89Q+FBO91BhbPVkiIkvaapuDgsYOotN6xaJE7GX/ADIZcM42TPX1Tni56gXggT2UQHmC70rwMmNmL0icgXd0aCr7Wwyn4HG1JbdLFRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296926; c=relaxed/simple;
	bh=Nu7S6odUZptSA6rOOyO2hTgr4liN/I8mz5gJMTyOvEI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=glBVNU32MY2bfXJ8JcUAg42ReBl/m86qjxefI/dQf6Em3hFXGAluOe5ifLfK6DM+eUZ1q2e0g0+9n5uRXF8FvjpjyfTS1ySRlsz6ZRx0g+g+4JewaqD2WsBvC+WwwkgrtGEm9ErGbgGhw32EVXaKlOs+tmBmQWheya2xwfBY1oU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NqxQ2Ddi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NqxQ2Ddi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AF0C1F000E9;
	Wed, 20 May 2026 17:08:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296925;
	bh=OpBGHl+xQ9VvulrZNyvVVS02Ev5Zthmrxr346b3J4KA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NqxQ2DdiSTQrF0AK/fPzRqgMKdZ7/WRIr9li0jyHkJawzYEVLPpuDYWc7WNl0N4q2
	 7GcQcWM9RGyXQ3ksgETyMTxytLeJ3Sityx3sd4d+pYCkE4mDK3zMoIWqshomQp+TTx
	 8G3o2CDjAwX/Tf2ZWKCtp5QR2JvfjQXiE29ikMDU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Su Yue <glass.su@suse.com>,
	Yu Kuai <yukuai@fnnas.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0957/1146] md: factor bitmap creation away from sysfs handling
Date: Wed, 20 May 2026 18:20:07 +0200
Message-ID: <20260520162209.891876310@linuxfoundation.org>
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
index 99a5ba1485565..3b58d94c1c7aa 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -688,7 +688,25 @@ static void active_io_release(struct percpu_ref *ref)
 
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
@@ -712,18 +730,6 @@ static bool mddev_set_bitmap_ops(struct mddev *mddev)
 
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
@@ -731,15 +737,6 @@ static bool mddev_set_bitmap_ops(struct mddev *mddev)
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
@@ -6540,7 +6537,7 @@ static enum md_submodule_id md_bitmap_get_id_from_sb(struct mddev *mddev)
 	return id;
 }
 
-static int md_bitmap_create(struct mddev *mddev)
+static int md_bitmap_create_nosysfs(struct mddev *mddev)
 {
 	enum md_submodule_id orig_id = mddev->bitmap_id;
 	enum md_submodule_id sb_id;
@@ -6549,7 +6546,7 @@ static int md_bitmap_create(struct mddev *mddev)
 	if (mddev->bitmap_id == ID_BITMAP_NONE)
 		return -EINVAL;
 
-	if (!mddev_set_bitmap_ops(mddev))
+	if (!mddev_set_bitmap_ops_nosysfs(mddev))
 		return -ENOENT;
 
 	err = mddev->bitmap_ops->create(mddev);
@@ -6561,7 +6558,7 @@ static int md_bitmap_create(struct mddev *mddev)
 	 * doesn't match, and mdadm is not the latest version to set
 	 * bitmap_type, set bitmap_ops based on the disk version.
 	 */
-	mddev_clear_bitmap_ops(mddev);
+	mddev->bitmap_ops = NULL;
 
 	sb_id = md_bitmap_get_id_from_sb(mddev);
 	if (sb_id == ID_BITMAP_NONE || sb_id == orig_id)
@@ -6571,27 +6568,50 @@ static int md_bitmap_create(struct mddev *mddev)
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



