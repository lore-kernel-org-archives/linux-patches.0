Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D50B3F5BFC;
	Wed, 30 Sep 2026 18:08:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791702; cv=none; b=YlPX7LjBPlbQow0nRvQCtRjXbrkfL3s/Rh3I1f5vChTRtsQRS1OAdnreSzB3a/c3ug1xUstMdesyyAQXuTlGh9T44h7oqMQWF1bk5gllXMICgOXySVFSQ5/AzaSK3jegLyTQ5InuYg8tzLJlQuT460zR6k3cBw16Jtuts2rErSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791702; c=relaxed/simple;
	bh=17aHfX7hXGkPCbvpS0ZgeBEXX2T6TxCLqqHjuDxibac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PceEXNI+b5KI2+ze98UDD+jrBRye+bFZnwZqH4vSDyonx5wOz6vWGdfQU8lX4mgWrZ4FiGkgzVt4s+CWvOfCJVfobtvs4TrR/+aUEYVaWUWsOkLZnZn2NrzSM0vwyZ6xTAUa5IWNG1UN0TU/jIWkbbsb+6Tz3UrxCsqMYnBhW/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vHiJFncv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vHiJFncv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 973941F00898;
	Wed, 30 Sep 2026 18:08:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791701;
	bh=YjAaJ+MwQ5/VNdeV32Wsa6b8LybOHBcgWWDMOzHI8uE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vHiJFncvZEg1FGkKCCouZfJLjHuJTZzuZ7azEXgzOeHuBYA5WaLdZwUC6QUPirN9V
	 0eAJd2jyADZW++Y1bQ5KQhKHcbdCzs4RNpXYsobxRS2PIwOrF9w5ZJcBIsfbP7IqeQ
	 o5gz5GQ4RPH/I8SoGc+R3A76kRnC1qttb8L5I244=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 368/752] Revert "scsi: core: Register sysfs attributes earlier"
Date: Wed, 30 Sep 2026 17:23:58 +0200
Message-ID: <20260930152406.243125470@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

This reverts commit 694e1b6aabe4cd359b42c44b54c409c3147b6020.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/hosts.c       | 23 +----------
 drivers/scsi/scsi_priv.h   |  4 +-
 drivers/scsi/scsi_sysfs.c  | 81 +++++++++++++++++++-------------------
 include/scsi/scsi_device.h |  7 ----
 include/scsi/scsi_host.h   | 12 ------
 5 files changed, 43 insertions(+), 84 deletions(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index b339c006cc35f..cf842c97639a7 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -387,7 +387,7 @@ static struct device_type scsi_host_type = {
 struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
 {
 	struct Scsi_Host *shost;
-	int index, i, j = 0;
+	int index;
 
 	shost = kzalloc(sizeof(struct Scsi_Host) + privsize, GFP_KERNEL);
 	if (!shost)
@@ -492,26 +492,7 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
 	shost->shost_dev.parent = &shost->shost_gendev;
 	shost->shost_dev.class = &shost_class;
 	dev_set_name(&shost->shost_dev, "host%d", shost->host_no);
-	shost->shost_dev.groups = shost->shost_dev_attr_groups;
-	shost->shost_dev_attr_groups[j++] = &scsi_shost_attr_group;
-	if (sht->shost_attrs) {
-		shost->lld_attr_group = (struct attribute_group){
-			.attrs = scsi_convert_dev_attrs(&shost->shost_gendev,
-							sht->shost_attrs)
-		};
-		if (shost->lld_attr_group.attrs)
-			shost->shost_dev_attr_groups[j++] =
-				&shost->lld_attr_group;
-	}
-	if (sht->shost_groups) {
-		for (i = 0; sht->shost_groups[i] &&
-			     j < ARRAY_SIZE(shost->shost_dev_attr_groups);
-		     i++, j++) {
-			shost->shost_dev_attr_groups[j] =
-				sht->shost_groups[i];
-		}
-	}
-	WARN_ON_ONCE(j >= ARRAY_SIZE(shost->shost_dev_attr_groups));
+	shost->shost_dev.groups = scsi_sysfs_shost_attr_groups;
 
 	shost->ehandler = kthread_run(scsi_error_handler, shost,
 			"scsi_eh_%d", shost->host_no);
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index 87c714b0bfba2..b531dec3d4206 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -138,15 +138,13 @@ extern int scsi_sysfs_add_sdev(struct scsi_device *);
 extern int scsi_sysfs_add_host(struct Scsi_Host *);
 extern int scsi_sysfs_register(void);
 extern void scsi_sysfs_unregister(void);
-struct attribute **scsi_convert_dev_attrs(struct device *dev,
-					  struct device_attribute **dev_attr);
 extern void scsi_sysfs_device_initialize(struct scsi_device *);
 extern int scsi_sysfs_target_initialize(struct scsi_device *);
 extern struct scsi_transport_template blank_transport_template;
 extern void __scsi_remove_device(struct scsi_device *);
 
 extern struct bus_type scsi_bus_type;
-extern const struct attribute_group scsi_shost_attr_group;
+extern const struct attribute_group *scsi_sysfs_shost_attr_groups[];
 
 /* scsi_netlink.c */
 #ifdef CONFIG_SCSI_NETLINK
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 2d7e394556c7e..7d3cbf4e6bc6e 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -424,10 +424,15 @@ static struct attribute *scsi_sysfs_shost_attrs[] = {
 	NULL
 };
 
-const struct attribute_group scsi_shost_attr_group = {
+static struct attribute_group scsi_shost_attr_group = {
 	.attrs =	scsi_sysfs_shost_attrs,
 };
 
+const struct attribute_group *scsi_sysfs_shost_attr_groups[] = {
+	&scsi_shost_attr_group,
+	NULL
+};
+
 static void scsi_device_cls_release(struct device *class_dev)
 {
 	struct scsi_device *sdev;
@@ -1353,7 +1358,7 @@ static int scsi_target_add(struct scsi_target *starget)
  **/
 int scsi_sysfs_add_sdev(struct scsi_device *sdev)
 {
-	int error;
+	int error, i;
 	struct scsi_target *starget = sdev->sdev_target;
 
 	error = scsi_target_add(starget);
@@ -1407,6 +1412,23 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
 		}
 	}
 
+	/* add additional host specific attributes */
+	if (sdev->host->hostt->sdev_attrs) {
+		for (i = 0; sdev->host->hostt->sdev_attrs[i]; i++) {
+			error = device_create_file(&sdev->sdev_gendev,
+					sdev->host->hostt->sdev_attrs[i]);
+			if (error)
+				return error;
+		}
+	}
+
+	if (sdev->host->hostt->sdev_groups) {
+		error = sysfs_create_groups(&sdev->sdev_gendev.kobj,
+				sdev->host->hostt->sdev_groups);
+		if (error)
+			return error;
+	}
+
 	scsi_autopm_put_device(sdev);
 	return error;
 }
@@ -1446,6 +1468,10 @@ void __scsi_remove_device(struct scsi_device *sdev)
 		if (res != 0)
 			return;
 
+		if (sdev->host->hostt->sdev_groups)
+			sysfs_remove_groups(&sdev->sdev_gendev.kobj,
+					sdev->host->hostt->sdev_groups);
+
 		if (IS_ENABLED(CONFIG_BLK_DEV_BSG) && sdev->bsg_dev)
 			bsg_unregister_queue(sdev->bsg_dev);
 		device_unregister(&sdev->sdev_dev);
@@ -1585,31 +1611,23 @@ EXPORT_SYMBOL(scsi_register_interface);
  **/
 int scsi_sysfs_add_host(struct Scsi_Host *shost)
 {
+	int error, i;
+
+	/* add host specific attributes */
+	if (shost->hostt->shost_attrs) {
+		for (i = 0; shost->hostt->shost_attrs[i]; i++) {
+			error = device_create_file(&shost->shost_dev,
+					shost->hostt->shost_attrs[i]);
+			if (error)
+				return error;
+		}
+	}
+
 	transport_register_device(&shost->shost_gendev);
 	transport_configure_device(&shost->shost_gendev);
 	return 0;
 }
 
-/*
- * Convert an array of struct device_attribute pointers into an array of
- * struct attribute pointers.
- */
-struct attribute **scsi_convert_dev_attrs(struct device *dev,
-					  struct device_attribute **dev_attr)
-{
-	struct attribute **attrs;
-	int i;
-
-	for (i = 0; dev_attr[i]; i++)
-		;
-	attrs = devm_kzalloc(dev, (i + 1) * sizeof(*attrs), GFP_KERNEL);
-	if (!attrs)
-		return NULL;
-	for (i = 0; dev_attr[i]; i++)
-		attrs[i] = &dev_attr[i]->attr;
-	return attrs;
-}
-
 static struct device_type scsi_dev_type = {
 	.name =		"scsi_device",
 	.release =	scsi_device_dev_release,
@@ -1618,10 +1636,8 @@ static struct device_type scsi_dev_type = {
 
 void scsi_sysfs_device_initialize(struct scsi_device *sdev)
 {
-	int i, j = 0;
 	unsigned long flags;
 	struct Scsi_Host *shost = sdev->host;
-	struct scsi_host_template *hostt = shost->hostt;
 	struct scsi_target  *starget = sdev->sdev_target;
 
 	device_initialize(&sdev->sdev_gendev);
@@ -1629,23 +1645,6 @@ void scsi_sysfs_device_initialize(struct scsi_device *sdev)
 	sdev->sdev_gendev.type = &scsi_dev_type;
 	dev_set_name(&sdev->sdev_gendev, "%d:%d:%d:%llu",
 		     sdev->host->host_no, sdev->channel, sdev->id, sdev->lun);
-	sdev->gendev_attr_groups[j++] = &scsi_sdev_attr_group;
-	if (hostt->sdev_attrs) {
-		sdev->lld_attr_group = (struct attribute_group){
-			.attrs = scsi_convert_dev_attrs(&sdev->sdev_gendev,
-							hostt->sdev_attrs)
-		};
-		if (sdev->lld_attr_group.attrs)
-			sdev->gendev_attr_groups[j++] = &sdev->lld_attr_group;
-	}
-	if (hostt->sdev_groups) {
-		for (i = 0; hostt->sdev_groups[i] &&
-			     j < ARRAY_SIZE(sdev->gendev_attr_groups);
-		     i++, j++) {
-			sdev->gendev_attr_groups[j] = hostt->sdev_groups[i];
-		}
-	}
-	WARN_ON_ONCE(j >= ARRAY_SIZE(sdev->gendev_attr_groups));
 
 	device_initialize(&sdev->sdev_dev);
 	sdev->sdev_dev.parent = get_device(&sdev->sdev_gendev);
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index d65cc2d577d8d..3b3dbc37653da 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -226,13 +226,6 @@ struct scsi_device {
 
 	struct device		sdev_gendev,
 				sdev_dev;
-	struct attribute_group	lld_attr_group;
-	/*
-	 * The array size 6 provides space for one attribute group for the
-	 * SCSI core, four attribute groups defined by SCSI LLDs and one
-	 * terminating NULL pointer.
-	 */
-	const struct attribute_group *gendev_attr_groups[6];
 
 	struct execute_work	ew; /* used to get process context on put */
 	struct work_struct	requeue_work;
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index e4188b2a6bd79..3ed93982dbf07 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -483,11 +483,6 @@ struct scsi_host_template {
 	 */
 	struct device_attribute **sdev_attrs;
 
-	/*
-	 * Pointer to the SCSI host sysfs attribute groups, NULL terminated.
-	 */
-	const struct attribute_group **shost_groups;
-
 	/*
 	 * Pointer to the SCSI device attribute groups for this host,
 	 * NULL terminated.
@@ -703,13 +698,6 @@ struct Scsi_Host {
 
 	/* ldm bits */
 	struct device		shost_gendev, shost_dev;
-	struct attribute_group	lld_attr_group;
-	/*
-	 * The array size 3 provides space for one attribute group defined by
-	 * the SCSI core, one attribute group defined by the SCSI LLD and one
-	 * terminating NULL pointer.
-	 */
-	const struct attribute_group *shost_dev_attr_groups[3];
 
 	/*
 	 * Points to the transport data (if any) which is allocated
-- 
2.53.0



