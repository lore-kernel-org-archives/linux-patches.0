Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A0701BA874;
	Thu,  6 Jun 2024 14:17:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683478; cv=none; b=TtHM+an+FBBkD6yLFtT+wVrxFs3VT2wY/R66Own1mveDAYZO+If1biOKLI15b/zp/BpVk1kxepUrtNkgF/0bfIwJv/mPQCIjXd2Hudsl5b1c9HEEP3jc0ajIg/D9oV4XyV63goZ9p5xlZBcyomD2y7y/IhnrWlcleTsxxxPBHYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683478; c=relaxed/simple;
	bh=y5QpPNJp+P9ftLCnVSVdRXBATFt/D8Wq4+FK6iurgNI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lzRX/R63/KZ1jH+PWV5/GMGmkndaK/k3NhM7Eazco9DeQZIPZRgC9yXsmLAeRX+tqcy9EkxlMzN5f4vNhyIeDxwvmO9oxOpvAvIlxKKILhJ4fZ5lW423vWbtfiB+fLESjmufYzmqlLLd3xS48Nqok8iMiwOQAZ9YE/M2OGGOkXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RKChoL1J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RKChoL1J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 619EDC2BD10;
	Thu,  6 Jun 2024 14:17:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683478;
	bh=y5QpPNJp+P9ftLCnVSVdRXBATFt/D8Wq4+FK6iurgNI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RKChoL1JFnjOPYV1kPxVTvWciYnoW1gO34uXHE9lKfm7ExGhZJgUlFknvbCgv89N2
	 655QRH2T+ZP43VybmkNrHiprGsSKsj6gWmrp+zeA0qdjOi/1ObRPLYdvY6Gn3dl2Ih
	 PCS0hxlEmXgFL5lzpvXTC8plPE+KbE8id5/6fnpA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 421/744] module: dont ignore sysfs_create_link() failures
Date: Thu,  6 Jun 2024 16:01:33 +0200
Message-ID: <20240606131745.978705388@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 85d2b0aa170351380be39fe4ff7973df1427fe76 ]

The sysfs_create_link() return code is marked as __must_check, but the
module_add_driver() function tries hard to not care, by assigning the
return code to a variable. When building with 'make W=1', gcc still
warns because this variable is only assigned but not used:

drivers/base/module.c: In function 'module_add_driver':
drivers/base/module.c:36:6: warning: variable 'no_warn' set but not used [-Wunused-but-set-variable]

Rework the code to properly unwind and return the error code to the
caller. My reading of the original code was that it tries to
not fail when the links already exist, so keep ignoring -EEXIST
errors.

Fixes: e17e0f51aeea ("Driver core: show drivers in /sys/module/")
See-also: 4a7fb6363f2d ("add __must_check to device management code")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
Link: https://lore.kernel.org/r/20240408080616.3911573-1-arnd@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/base.h   |  9 ++++++---
 drivers/base/bus.c    |  9 ++++++++-
 drivers/base/module.c | 42 +++++++++++++++++++++++++++++++-----------
 3 files changed, 45 insertions(+), 15 deletions(-)

diff --git a/drivers/base/base.h b/drivers/base/base.h
index eb4c0ace92420..a8e3d8165232f 100644
--- a/drivers/base/base.h
+++ b/drivers/base/base.h
@@ -192,11 +192,14 @@ extern struct kset *devices_kset;
 void devices_kset_move_last(struct device *dev);
 
 #if defined(CONFIG_MODULES) && defined(CONFIG_SYSFS)
-void module_add_driver(struct module *mod, struct device_driver *drv);
+int module_add_driver(struct module *mod, struct device_driver *drv);
 void module_remove_driver(struct device_driver *drv);
 #else
-static inline void module_add_driver(struct module *mod,
-				     struct device_driver *drv) { }
+static inline int module_add_driver(struct module *mod,
+				    struct device_driver *drv)
+{
+	return 0;
+}
 static inline void module_remove_driver(struct device_driver *drv) { }
 #endif
 
diff --git a/drivers/base/bus.c b/drivers/base/bus.c
index 84a21084d67d1..d7c4330786cae 100644
--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -674,7 +674,12 @@ int bus_add_driver(struct device_driver *drv)
 		if (error)
 			goto out_del_list;
 	}
-	module_add_driver(drv->owner, drv);
+	error = module_add_driver(drv->owner, drv);
+	if (error) {
+		printk(KERN_ERR "%s: failed to create module links for %s\n",
+			__func__, drv->name);
+		goto out_detach;
+	}
 
 	error = driver_create_file(drv, &driver_attr_uevent);
 	if (error) {
@@ -699,6 +704,8 @@ int bus_add_driver(struct device_driver *drv)
 
 	return 0;
 
+out_detach:
+	driver_detach(drv);
 out_del_list:
 	klist_del(&priv->knode_bus);
 out_unregister:
diff --git a/drivers/base/module.c b/drivers/base/module.c
index 46ad4d636731d..a1b55da07127d 100644
--- a/drivers/base/module.c
+++ b/drivers/base/module.c
@@ -30,14 +30,14 @@ static void module_create_drivers_dir(struct module_kobject *mk)
 	mutex_unlock(&drivers_dir_mutex);
 }
 
-void module_add_driver(struct module *mod, struct device_driver *drv)
+int module_add_driver(struct module *mod, struct device_driver *drv)
 {
 	char *driver_name;
-	int no_warn;
 	struct module_kobject *mk = NULL;
+	int ret;
 
 	if (!drv)
-		return;
+		return 0;
 
 	if (mod)
 		mk = &mod->mkobj;
@@ -56,17 +56,37 @@ void module_add_driver(struct module *mod, struct device_driver *drv)
 	}
 
 	if (!mk)
-		return;
+		return 0;
+
+	ret = sysfs_create_link(&drv->p->kobj, &mk->kobj, "module");
+	if (ret)
+		return ret;
 
-	/* Don't check return codes; these calls are idempotent */
-	no_warn = sysfs_create_link(&drv->p->kobj, &mk->kobj, "module");
 	driver_name = make_driver_name(drv);
-	if (driver_name) {
-		module_create_drivers_dir(mk);
-		no_warn = sysfs_create_link(mk->drivers_dir, &drv->p->kobj,
-					    driver_name);
-		kfree(driver_name);
+	if (!driver_name) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	module_create_drivers_dir(mk);
+	if (!mk->drivers_dir) {
+		ret = -EINVAL;
+		goto out;
 	}
+
+	ret = sysfs_create_link(mk->drivers_dir, &drv->p->kobj, driver_name);
+	if (ret)
+		goto out;
+
+	kfree(driver_name);
+
+	return 0;
+out:
+	sysfs_remove_link(&drv->p->kobj, "module");
+	sysfs_remove_link(mk->drivers_dir, driver_name);
+	kfree(driver_name);
+
+	return ret;
 }
 
 void module_remove_driver(struct device_driver *drv)
-- 
2.43.0



