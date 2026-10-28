Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212604;
	b=JTFIJZUSUvHmDugKjyW214N1RIuUstM/r2cxWgjiI5I5sMMLVjoOhKX0dkiOrfa/G9eJ
	 RCpI5qzHgE2tX5rRjXWEeQ7uiqy52CjbD7zGYQ0PU2haCW6z2FDLAaNXBT+JDEPgTvas3
	 ml6Fh1/xOXGrrdJxVQ9xscjczCzDCMyh9nha5HVFLBtOvfmdqZFe9xkfWQCx8p2FxxfPH
	 ffmgj4VktZptv4Jg/uQ/WLc5na6seCVQWe3BQC4oQRBnMpgblsQu3D0zrpp/Glc1iHUfg
	 T5ssOJCg8gPlvkqWh45+4yxMRlDZhIekhN2thZuqUYxherBEsp0xWgG/zqFmtJhCa6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212604;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Pa7kSOHiyvA/VYJZLuxqICwHYef1wbl6YzUJyekkKrA=;
	b=xk6j+NaaGoy0btaoBs+RDRwuFRifwDzfGOvN9+FKnZMI/KVoYgGoNGmjp76WdspfTr2m
	 TW90LeAwKL+ADZeWgxMpA0lueK8t2NH6Dv9hzrvBKT0rS9HCJ4KBTSfyjDybbwfCxTBHI
	 TY3H7qGoCCkIoYCifuDdgqtmphm/Af0GeiJTza8yxUsZP0HKU17n0u4+1wnv6H6fg7ez2
	 3xHCtTU1J17B79WzQEUQ6AFLuXY3bngzcB7A/ZsA53sX8rxD5Uc5EtgQgp7MMpLqmWKmB
	 pceC0MKe7oCcPKxnORVV+iGJ/Ksxpg0wyzUyl3/jpln+oQv3C4ZYdUjAwZJshGUBaTw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GeLGL6Wi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAFFC606A31A;
	Wed, 28 Oct 2026 18:36:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GeLGL6Wi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 240021F01828;
	Wed, 28 Oct 2026 18:36:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212603;
	bh=Pa7kSOHiyvA/VYJZLuxqICwHYef1wbl6YzUJyekkKrA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GeLGL6Wi5Hmr4TseDyRjwOW9LgkocJr/zaoLub5sZZ9XTA08ARGl7HqRGB2W3bStc
	 Hmm1pGfYs4D2KKXJ3rigg9mAMK/uw1VWLtWd4RHal8Z+eoqbGQDNWq90ev8l60vSiq
	 US7LJiZy9m169w0vwh4MI76f5mM9fpAVboJDOU2w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomas Winkler <tomas.winkler@intel.com>,
	Alexander Usyskin <alexander.usyskin@intel.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0213/1887] mtd: use refcount to prevent corruption
Date: Wed, 28 Oct 2026 17:38:29 +0100
Message-ID: <20261028170504.080498675@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomas Winkler <tomas.winkler@intel.com>

[ Upstream commit 19bfa9ebebb5ec0695def57eb1d80de7e9cab369 ]

When underlying device is removed mtd core will crash
in case user space is holding open handle.
Need to use proper refcounting so device is release
only when has no users.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20230620131905.648089-2-alexander.usyskin@intel.com
Stable-dep-of: 12b31d1acd20 ("mtd: core: call _get_device() with the master MTD")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/mtdcore.c   | 72 ++++++++++++++++++++++-------------------
 drivers/mtd/mtdcore.h   |  1 +
 drivers/mtd/mtdpart.c   | 14 ++++----
 include/linux/mtd/mtd.h |  2 +-
 4 files changed, 49 insertions(+), 40 deletions(-)

diff --git a/drivers/mtd/mtdcore.c b/drivers/mtd/mtdcore.c
index ad527bdbd4632..565b948c99dda 100644
--- a/drivers/mtd/mtdcore.c
+++ b/drivers/mtd/mtdcore.c
@@ -92,10 +92,33 @@ static void mtd_release(struct device *dev)
 	struct mtd_info *mtd = dev_get_drvdata(dev);
 	dev_t index = MTD_DEVT(mtd->index);
 
+	if (mtd_is_partition(mtd))
+		release_mtd_partition(mtd);
+
 	/* remove /dev/mtdXro node */
 	device_destroy(&mtd_class, index + 1);
 }
 
+static void mtd_device_release(struct kref *kref)
+{
+	struct mtd_info *mtd = container_of(kref, struct mtd_info, refcnt);
+
+	debugfs_remove_recursive(mtd->dbg.dfs_dir);
+
+	/* Try to remove the NVMEM provider */
+	nvmem_unregister(mtd->nvmem);
+
+	device_unregister(&mtd->dev);
+
+	/* Clear dev so mtd can be safely re-registered later if desired */
+	memset(&mtd->dev, 0, sizeof(mtd->dev));
+
+	idr_remove(&mtd_idr, mtd->index);
+	of_node_put(mtd_get_of_node(mtd));
+
+	module_put(THIS_MODULE);
+}
+
 #define MTD_DEVICE_ATTR_RO(name) \
 static DEVICE_ATTR(name, 0444, mtd_##name##_show, NULL)
 
@@ -674,7 +697,7 @@ int add_mtd_device(struct mtd_info *mtd)
 	}
 
 	mtd->index = i;
-	mtd->usecount = 0;
+	kref_init(&mtd->refcnt);
 
 	/* default value if not set by driver */
 	if (mtd->bitflip_threshold == 0)
@@ -776,7 +799,6 @@ int del_mtd_device(struct mtd_info *mtd)
 {
 	int ret;
 	struct mtd_notifier *not;
-	struct device_node *mtd_of_node;
 
 	mutex_lock(&mtd_table_mutex);
 
@@ -790,28 +812,8 @@ int del_mtd_device(struct mtd_info *mtd)
 	list_for_each_entry(not, &mtd_notifiers, list)
 		not->remove(mtd);
 
-	if (mtd->usecount) {
-		printk(KERN_NOTICE "Removing MTD device #%d (%s) with use count %d\n",
-		       mtd->index, mtd->name, mtd->usecount);
-		ret = -EBUSY;
-	} else {
-		mtd_of_node = mtd_get_of_node(mtd);
-		debugfs_remove_recursive(mtd->dbg.dfs_dir);
-
-		/* Try to remove the NVMEM provider */
-		nvmem_unregister(mtd->nvmem);
-
-		device_unregister(&mtd->dev);
-
-		/* Clear dev so mtd can be safely re-registered later if desired */
-		memset(&mtd->dev, 0, sizeof(mtd->dev));
-
-		idr_remove(&mtd_idr, mtd->index);
-		of_node_put(mtd_of_node);
-
-		module_put(THIS_MODULE);
-		ret = 0;
-	}
+	kref_put(&mtd->refcnt, mtd_device_release);
+	ret = 0;
 
 out_error:
 	mutex_unlock(&mtd_table_mutex);
@@ -1210,19 +1212,21 @@ int __get_mtd_device(struct mtd_info *mtd)
 	if (!try_module_get(master->owner))
 		return -ENODEV;
 
+	kref_get(&mtd->refcnt);
+
 	if (master->_get_device) {
 		err = master->_get_device(mtd);
 
 		if (err) {
+			kref_put(&mtd->refcnt, mtd_device_release);
 			module_put(master->owner);
 			return err;
 		}
 	}
 
-	master->usecount++;
-
 	while (mtd->parent) {
-		mtd->usecount++;
+		if (IS_ENABLED(CONFIG_MTD_PARTITIONED_MASTER) || mtd->parent != master)
+			kref_get(&mtd->parent->refcnt);
 		mtd = mtd->parent;
 	}
 
@@ -1309,18 +1313,20 @@ void __put_mtd_device(struct mtd_info *mtd)
 {
 	struct mtd_info *master = mtd_get_master(mtd);
 
-	while (mtd->parent) {
-		--mtd->usecount;
-		BUG_ON(mtd->usecount < 0);
-		mtd = mtd->parent;
-	}
+	while (mtd != master) {
+		struct mtd_info *parent = mtd->parent;
 
-	master->usecount--;
+		kref_put(&mtd->refcnt, mtd_device_release);
+		mtd = parent;
+	}
 
 	if (master->_put_device)
 		master->_put_device(master);
 
 	module_put(master->owner);
+
+	if (IS_ENABLED(CONFIG_MTD_PARTITIONED_MASTER))
+		kref_put(&master->refcnt, mtd_device_release);
 }
 EXPORT_SYMBOL_GPL(__put_mtd_device);
 
diff --git a/drivers/mtd/mtdcore.h b/drivers/mtd/mtdcore.h
index b5eefeabf310d..b014861a06a6f 100644
--- a/drivers/mtd/mtdcore.h
+++ b/drivers/mtd/mtdcore.h
@@ -12,6 +12,7 @@ int __must_check add_mtd_device(struct mtd_info *mtd);
 int del_mtd_device(struct mtd_info *mtd);
 int add_mtd_partitions(struct mtd_info *, const struct mtd_partition *, int);
 int del_mtd_partitions(struct mtd_info *);
+void release_mtd_partition(struct mtd_info *mtd);
 
 struct mtd_partitions;
 
diff --git a/drivers/mtd/mtdpart.c b/drivers/mtd/mtdpart.c
index f4419fdf36a0b..f9cb2d9720404 100644
--- a/drivers/mtd/mtdpart.c
+++ b/drivers/mtd/mtdpart.c
@@ -32,6 +32,12 @@ static inline void free_partition(struct mtd_info *mtd)
 	kfree(mtd);
 }
 
+void release_mtd_partition(struct mtd_info *mtd)
+{
+	WARN_ON(!list_empty(&mtd->part.node));
+	free_partition(mtd);
+}
+
 static struct mtd_info *allocate_partition(struct mtd_info *parent,
 					   const struct mtd_partition *part,
 					   int partno, uint64_t cur_offset)
@@ -310,13 +316,11 @@ static int __mtd_del_partition(struct mtd_info *mtd)
 
 	sysfs_remove_files(&mtd->dev.kobj, mtd_partition_attrs);
 
+	list_del_init(&mtd->part.node);
 	err = del_mtd_device(mtd);
 	if (err)
 		return err;
 
-	list_del(&mtd->part.node);
-	free_partition(mtd);
-
 	return 0;
 }
 
@@ -335,6 +339,7 @@ static int __del_mtd_partitions(struct mtd_info *mtd)
 			__del_mtd_partitions(child);
 
 		pr_info("Deleting %s MTD partition\n", child->name);
+		list_del_init(&child->part.node);
 		ret = del_mtd_device(child);
 		if (ret < 0) {
 			pr_err("Error when deleting partition \"%s\" (%d)\n",
@@ -342,9 +347,6 @@ static int __del_mtd_partitions(struct mtd_info *mtd)
 			err = ret;
 			continue;
 		}
-
-		list_del(&child->part.node);
-		free_partition(child);
 	}
 
 	return err;
diff --git a/include/linux/mtd/mtd.h b/include/linux/mtd/mtd.h
index 7c58c44662b87..914a9f974baaa 100644
--- a/include/linux/mtd/mtd.h
+++ b/include/linux/mtd/mtd.h
@@ -379,7 +379,7 @@ struct mtd_info {
 
 	struct module *owner;
 	struct device dev;
-	int usecount;
+	struct kref refcnt;
 	struct mtd_debug_info dbg;
 	struct nvmem_device *nvmem;
 	struct nvmem_device *otp_user_nvmem;
-- 
2.53.0



