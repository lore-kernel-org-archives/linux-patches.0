Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E54561A706C;
	Thu, 15 Aug 2024 14:24:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731879; cv=none; b=lvhfz35tJJmNemp9nMFOGn2nhJPQfJ8IveKq63XB8Y3yCVRYpiD9kUxeYyr+9QMg2t+EdRWyi9cnxBx3i3A2GBu4DLRBYXg0bXEDVbS/fH6yR/Y0NuSlGwLOB4AsvaFUttrBweGB6DGm9eJxatKW32e5omOmdd6W9ar1xXCKTDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731879; c=relaxed/simple;
	bh=lSYyQrJf2PFwKF11fYwKuCpohlvc9eDcTScI3doaP1o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cisZTA1Zk69RTSOkjNRGy9dySF3pjO2ya4x7a9DtE7qwrt/lzDL57tFtxRtCuls2rr65rIwR24z/MR4g9NDZF+rJr/txJ1nWLcud8bUaUAEZUPnpUKqgnBHhT4NEw44+ws/pSP9B7Hin6rNISb5IergL51NWtaqWa4BIj1UW6iM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IFXjDxm9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IFXjDxm9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8FD6C32786;
	Thu, 15 Aug 2024 14:24:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731878;
	bh=lSYyQrJf2PFwKF11fYwKuCpohlvc9eDcTScI3doaP1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IFXjDxm9z6Ko+oaRBVyXVYuUCDS6b8aR+ysAZ0jGeYkp400s8ihQWnyowo898FvDE
	 QnMIKW/Bz/RgW5IX6bG3qnYyL1cxA4lDDb8fxPgRRCZ8DpRQIxtRJ/414xCDOnAMKy
	 5NmAUI7fgl4yA6fFLdcg0MCI6h+p3O6vfQ2XRkDA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+4762dd74e32532cda5ff@syzkaller.appspotmail.com,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	Ashish Sangwan <a.sangwan@samsung.com>,
	Namjae Jeon <namjae.jeon@samsung.com>,
	Dirk Behme <dirk.behme@de.bosch.com>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 5.4 237/259] driver core: Fix uevent_show() vs driver detach race
Date: Thu, 15 Aug 2024 15:26:10 +0200
Message-ID: <20240815131911.926092258@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131902.779125794@linuxfoundation.org>
References: <20240815131902.779125794@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Williams <dan.j.williams@intel.com>

commit 15fffc6a5624b13b428bb1c6e9088e32a55eb82c upstream.

uevent_show() wants to de-reference dev->driver->name. There is no clean
way for a device attribute to de-reference dev->driver unless that
attribute is defined via (struct device_driver).dev_groups. Instead, the
anti-pattern of taking the device_lock() in the attribute handler risks
deadlocks with code paths that remove device attributes while holding
the lock.

This deadlock is typically invisible to lockdep given the device_lock()
is marked lockdep_set_novalidate_class(), but some subsystems allocate a
local lockdep key for @dev->mutex to reveal reports of the form:

 ======================================================
 WARNING: possible circular locking dependency detected
 6.10.0-rc7+ #275 Tainted: G           OE    N
 ------------------------------------------------------
 modprobe/2374 is trying to acquire lock:
 ffff8c2270070de0 (kn->active#6){++++}-{0:0}, at: __kernfs_remove+0xde/0x220

 but task is already holding lock:
 ffff8c22016e88f8 (&cxl_root_key){+.+.}-{3:3}, at: device_release_driver_internal+0x39/0x210

 which lock already depends on the new lock.

 the existing dependency chain (in reverse order) is:

 -> #1 (&cxl_root_key){+.+.}-{3:3}:
        __mutex_lock+0x99/0xc30
        uevent_show+0xac/0x130
        dev_attr_show+0x18/0x40
        sysfs_kf_seq_show+0xac/0xf0
        seq_read_iter+0x110/0x450
        vfs_read+0x25b/0x340
        ksys_read+0x67/0xf0
        do_syscall_64+0x75/0x190
        entry_SYSCALL_64_after_hwframe+0x76/0x7e

 -> #0 (kn->active#6){++++}-{0:0}:
        __lock_acquire+0x121a/0x1fa0
        lock_acquire+0xd6/0x2e0
        kernfs_drain+0x1e9/0x200
        __kernfs_remove+0xde/0x220
        kernfs_remove_by_name_ns+0x5e/0xa0
        device_del+0x168/0x410
        device_unregister+0x13/0x60
        devres_release_all+0xb8/0x110
        device_unbind_cleanup+0xe/0x70
        device_release_driver_internal+0x1c7/0x210
        driver_detach+0x47/0x90
        bus_remove_driver+0x6c/0xf0
        cxl_acpi_exit+0xc/0x11 [cxl_acpi]
        __do_sys_delete_module.isra.0+0x181/0x260
        do_syscall_64+0x75/0x190
        entry_SYSCALL_64_after_hwframe+0x76/0x7e

The observation though is that driver objects are typically much longer
lived than device objects. It is reasonable to perform lockless
de-reference of a @driver pointer even if it is racing detach from a
device. Given the infrequency of driver unregistration, use
synchronize_rcu() in module_remove_driver() to close any potential
races.  It is potentially overkill to suffer synchronize_rcu() just to
handle the rare module removal racing uevent_show() event.

Thanks to Tetsuo Handa for the debug analysis of the syzbot report [1].

Fixes: c0a40097f0bc ("drivers: core: synchronize really_probe() and dev_uevent()")
Reported-by: syzbot+4762dd74e32532cda5ff@syzkaller.appspotmail.com
Reported-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Closes: http://lore.kernel.org/5aa5558f-90a4-4864-b1b1-5d6784c5607d@I-love.SAKURA.ne.jp [1]
Link: http://lore.kernel.org/669073b8ea479_5fffa294c1@dwillia2-xfh.jf.intel.com.notmuch
Cc: stable@vger.kernel.org
Cc: Ashish Sangwan <a.sangwan@samsung.com>
Cc: Namjae Jeon <namjae.jeon@samsung.com>
Cc: Dirk Behme <dirk.behme@de.bosch.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Rafael J. Wysocki <rafael@kernel.org>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Link: https://lore.kernel.org/r/172081332794.577428.9738802016494057132.stgit@dwillia2-xfh.jf.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/core.c   |   13 ++++++++-----
 drivers/base/module.c |    4 ++++
 2 files changed, 12 insertions(+), 5 deletions(-)

--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -25,6 +25,7 @@
 #include <linux/mutex.h>
 #include <linux/pm_runtime.h>
 #include <linux/netdevice.h>
+#include <linux/rcupdate.h>
 #include <linux/sched/signal.h>
 #include <linux/sysfs.h>
 
@@ -1174,6 +1175,7 @@ static int dev_uevent(struct kset *kset,
 		      struct kobj_uevent_env *env)
 {
 	struct device *dev = kobj_to_dev(kobj);
+	struct device_driver *driver;
 	int retval = 0;
 
 	/* add device node properties if present */
@@ -1202,8 +1204,12 @@ static int dev_uevent(struct kset *kset,
 	if (dev->type && dev->type->name)
 		add_uevent_var(env, "DEVTYPE=%s", dev->type->name);
 
-	if (dev->driver)
-		add_uevent_var(env, "DRIVER=%s", dev->driver->name);
+	/* Synchronize with module_remove_driver() */
+	rcu_read_lock();
+	driver = READ_ONCE(dev->driver);
+	if (driver)
+		add_uevent_var(env, "DRIVER=%s", driver->name);
+	rcu_read_unlock();
 
 	/* Add common DT information about the device */
 	of_device_uevent(dev, env);
@@ -1273,11 +1279,8 @@ static ssize_t uevent_show(struct device
 	if (!env)
 		return -ENOMEM;
 
-	/* Synchronize with really_probe() */
-	device_lock(dev);
 	/* let the kset specific function add its keys */
 	retval = kset->uevent_ops->uevent(kset, &dev->kobj, env);
-	device_unlock(dev);
 	if (retval)
 		goto out;
 
--- a/drivers/base/module.c
+++ b/drivers/base/module.c
@@ -7,6 +7,7 @@
 #include <linux/errno.h>
 #include <linux/slab.h>
 #include <linux/string.h>
+#include <linux/rcupdate.h>
 #include "base.h"
 
 static char *make_driver_name(struct device_driver *drv)
@@ -77,6 +78,9 @@ void module_remove_driver(struct device_
 	if (!drv)
 		return;
 
+	/* Synchronize with dev_uevent() */
+	synchronize_rcu();
+
 	sysfs_remove_link(&drv->p->kobj, "module");
 
 	if (drv->owner)


