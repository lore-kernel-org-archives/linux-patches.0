Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210826;
	b=nrJHWcDrddmiQtnVuSriUV3meEv2ZUgJ6fGPb72AjcB2I+BbZLw4vVc+1gWGAEKzR0nT
	 FYKJgEhHC5RfTdKAKMC8PrD0VGXFU9uqaSb8f9jchgxL+/oPgDO1JQ1OnJSDIvUzWyzad
	 xTvBrwk+IdOIE+fQoM3gmmzEWrQgw59NEd3kOXsl0M2Ww1/Ido3BWkfIYdfiHB3Wt8BO8
	 EE+LGixgVulvjWnfmiR6P08DgnFN9prvrUOB4kDXfejPKLxvHVNAIjCrlSiPaGwf2Z4jH
	 vyegtmRM/IPE9lkTCDqmIPMVZfmm3NLMliPn/vHt0lc3XNiNXkBtLdiezKxgYSoHoBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210826;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=G5aV7EO/qaqM6TpsYjVcVvKTOu9RGLwanF2EMes3Ans=;
	b=MmxcuxORQFnS/P8G3mtGJXU2qwHbSs8dQBLHnTnPHsLJC8EKI2wdmlujNCqHOlXctgbH
	 YRcyRyjpElvgahG0naCVuITAwdaMVTuxv6xXmHNFTtjl4pDzmzwKTjexCjN3uEwaoF+hd
	 GYXf4882wJ1W0Plw4u5I6S1ZqUR3DTe6yEPSEyaFP+68kPZ2kK5TuyoJGPmUvlAC+g9y5
	 Y6InDouGNyz6auerMqN4zmbKFwJ40pAlJOP4QMtMAQHCAM+H1ZUnPfvicv4HrPVqJbNby
	 STjVAoP2e8TqJcmJbFCODiwIr9GSiAYunY5g2TMABrfK038g/W2uS4mY5xQJPz4vqLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uyDmnhKu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3E36606A31C;
	Wed, 28 Oct 2026 18:07:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uyDmnhKu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1073C1F01825;
	Wed, 28 Oct 2026 18:07:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210825;
	bh=G5aV7EO/qaqM6TpsYjVcVvKTOu9RGLwanF2EMes3Ans=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uyDmnhKus17zVJfKTNS19YbDUz/AtK1XBtHdICcbW2IDs0CC+af75Nwdh68CWWIUe
	 FsoPt7Ghf6AaNLOAi+V6HhBJIpA/WmBevdw6i34BCPb0vE2Nrl2uNYmFVVDjAdNMyJ
	 cJzKM7w2vxaCUkIVLz3gS+hR7FpQWRs2b7U0CJBc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomas Winkler <tomas.winkler@intel.com>,
	Alexander Usyskin <alexander.usyskin@intel.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 161/571] mtd: use refcount to prevent corruption
Date: Wed, 28 Oct 2026 17:55:08 +0100
Message-ID: <20261028170011.838480443@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 69cc4a66ea151..2891150478133 100644
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
 
@@ -623,7 +646,7 @@ int add_mtd_device(struct mtd_info *mtd)
 	}
 
 	mtd->index = i;
-	mtd->usecount = 0;
+	kref_init(&mtd->refcnt);
 
 	/* default value if not set by driver */
 	if (mtd->bitflip_threshold == 0)
@@ -724,7 +747,6 @@ int del_mtd_device(struct mtd_info *mtd)
 {
 	int ret;
 	struct mtd_notifier *not;
-	struct device_node *mtd_of_node;
 
 	mutex_lock(&mtd_table_mutex);
 
@@ -738,28 +760,8 @@ int del_mtd_device(struct mtd_info *mtd)
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
@@ -1158,19 +1160,21 @@ int __get_mtd_device(struct mtd_info *mtd)
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
 
@@ -1229,18 +1233,20 @@ void __put_mtd_device(struct mtd_info *mtd)
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
index 44384726aa443..63d8a5fff35e7 100644
--- a/drivers/mtd/mtdpart.c
+++ b/drivers/mtd/mtdpart.c
@@ -31,6 +31,12 @@ static inline void free_partition(struct mtd_info *mtd)
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
@@ -309,13 +315,11 @@ static int __mtd_del_partition(struct mtd_info *mtd)
 
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
 
@@ -334,6 +338,7 @@ static int __del_mtd_partitions(struct mtd_info *mtd)
 			__del_mtd_partitions(child);
 
 		pr_info("Deleting %s MTD partition\n", child->name);
+		list_del_init(&child->part.node);
 		ret = del_mtd_device(child);
 		if (ret < 0) {
 			pr_err("Error when deleting partition \"%s\" (%d)\n",
@@ -341,9 +346,6 @@ static int __del_mtd_partitions(struct mtd_info *mtd)
 			err = ret;
 			continue;
 		}
-
-		list_del(&child->part.node);
-		free_partition(child);
 	}
 
 	return err;
diff --git a/include/linux/mtd/mtd.h b/include/linux/mtd/mtd.h
index 8a2c60235ebb8..c5a644f5cd4e2 100644
--- a/include/linux/mtd/mtd.h
+++ b/include/linux/mtd/mtd.h
@@ -377,7 +377,7 @@ struct mtd_info {
 
 	struct module *owner;
 	struct device dev;
-	int usecount;
+	struct kref refcnt;
 	struct mtd_debug_info dbg;
 	struct nvmem_device *nvmem;
 	struct nvmem_device *otp_user_nvmem;
-- 
2.53.0



