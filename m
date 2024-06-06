Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D193C196C85;
	Thu,  6 Jun 2024 14:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717682906; cv=none; b=CwDQzWvPJ/rkynconkKNYHP+ZHOf6Bmb7zJlRzzZNhJ2qQsBKjW3jJ4GeayVDNj6V2GGkKHCEFs7X3JJ5uG2MNgD8aASIaMrjGQzS0TpDQClrwRVELuhoIB1Mvw2TOdzJ/DYpSPjLQv/KgKKVrT5Hyz5iEqjNvidhVLA8js7m8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717682906; c=relaxed/simple;
	bh=kVQFQqKft6+PWWeUIjK8HwzP8S78pXkHoaRm7wOohEg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hdcoMEV29OmJjqGA+xl6NkCYBxtNUul4H28JLZbQ8euqtXWzJh30Zuq5ae0m3AA3KSBWCg+OpzmGQsKoh6AIvvm5fGdDsFNHG1h+gw5RxTjJslQ38ceyY0Bus75m7IUccK/r++uOQLbluJpL7MIlCy8k2vwUlhdVm3VoiXk4CbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MSmy2tgG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MSmy2tgG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD51AC2BD10;
	Thu,  6 Jun 2024 14:08:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717682906;
	bh=kVQFQqKft6+PWWeUIjK8HwzP8S78pXkHoaRm7wOohEg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MSmy2tgGzFUOLbWpTluqijUGgwnOu73rYdTfc+OTuBg3i6LloTnWLpL/mTGIUVdBV
	 g7fBRe2x7JmE/THc2lZcnguSmZoNApAfzt18t4bY0vegOK5t57mGfaJawseMUmU43K
	 RRj+nxHf2tTsyjlb7xa8E4aoLvQu292r7UnM3kFM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 031/374] module: dont ignore sysfs_create_link() failures
Date: Thu,  6 Jun 2024 16:00:10 +0200
Message-ID: <20240606131652.868487330@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index 0738ccad08b2e..db4f910e8e36e 100644
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
index daee55c9b2d9e..ffea0728b8b2f 100644
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



