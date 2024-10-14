Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DB361798C;
	Mon, 14 Oct 2024 15:18:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919090; cv=none; b=JyLTa7PJ9jO8/jWY9wE3TJh5S2jTiMQeH0+tVYNUsW425pQNpIgZNVsC8xc1dczFHfIp5Lcmhy+tVaViNFcfFp8rHwXXw4/lEukwBIPVbx7yc0x57Ca0lwdgl1dYKiMcLcKi+UTwL2qFNJnR/E8yNYc3DBQ4Bg/GS9yjiTtGg00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919090; c=relaxed/simple;
	bh=z+AQl/tSX/GYccNR/kdJG36hfDO55A685Xl0hQkPYH4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hS75Q3hGy2HgkAAcuL0mPyUylPYry7BW823ggkEOhGwEed/Ynw3vx/NEjARAZBtXTdYte2VSaDj/txw0NgRCoRi9uK8vDYcWs2NN+qk8aKJGTqQ4nD7WtY3f0IAa8JCmUxRqVo1LYDrac8dvfSaSEXTglSq7/eC+3HGy9zjmroo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fn1FER1x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fn1FER1x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2F68C4CEC3;
	Mon, 14 Oct 2024 15:18:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919090;
	bh=z+AQl/tSX/GYccNR/kdJG36hfDO55A685Xl0hQkPYH4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fn1FER1xihF+lmvU8NL4i/G2T+5u7NyFrGrR2Bn9s/CegtKO1mUzsEOL0XMsDj+lR
	 QmcJCEIbg2DeSfN0M2IFUXArrJ+hKboee8oY6BExzUf5i/FJo/0SZb0WL5rcSSPwj3
	 DvQQMqOXgbTHajcOxGNlcAhrWT3tDw3aziNIlYCQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Christoph Hellwig <hch@lst.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Jens Axboe <axboe@kernel.dk>,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 511/798] blk-integrity: convert to struct device_attribute
Date: Mon, 14 Oct 2024 16:17:45 +0200
Message-ID: <20241014141238.056135951@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <linux@weissschuh.net>

Upstream commit 76b8c319f02715e14abdbbbdd6508e83a1059bcc.

An upcoming patch will register the integrity attributes directly with
the struct device kobject.
For this the attributes have to be implemented in terms of
struct device_attribute.

Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Link: https://lore.kernel.org/r/20230309-kobj_release-gendisk_integrity-v3-2-ceccb4493c46@weissschuh.net
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-integrity.c | 127 +++++++++++++++++++++---------------------
 1 file changed, 62 insertions(+), 65 deletions(-)

diff --git a/block/blk-integrity.c b/block/blk-integrity.c
index 7131f0d30f116..91a502b01fc72 100644
--- a/block/blk-integrity.c
+++ b/block/blk-integrity.c
@@ -212,21 +212,15 @@ bool blk_integrity_merge_bio(struct request_queue *q, struct request *req,
 	return true;
 }
 
-struct integrity_sysfs_entry {
-	struct attribute attr;
-	ssize_t (*show)(struct blk_integrity *, char *);
-	ssize_t (*store)(struct blk_integrity *, const char *, size_t);
-};
-
 static ssize_t integrity_attr_show(struct kobject *kobj, struct attribute *attr,
 				   char *page)
 {
 	struct gendisk *disk = container_of(kobj, struct gendisk, integrity_kobj);
-	struct blk_integrity *bi = &disk->queue->integrity;
-	struct integrity_sysfs_entry *entry =
-		container_of(attr, struct integrity_sysfs_entry, attr);
+	struct device *dev = disk_to_dev(disk);
+	struct device_attribute *dev_attr =
+		container_of(attr, struct device_attribute, attr);
 
-	return entry->show(bi, page);
+	return dev_attr->show(dev, dev_attr, page);
 }
 
 static ssize_t integrity_attr_store(struct kobject *kobj,
@@ -234,38 +228,53 @@ static ssize_t integrity_attr_store(struct kobject *kobj,
 				    size_t count)
 {
 	struct gendisk *disk = container_of(kobj, struct gendisk, integrity_kobj);
-	struct blk_integrity *bi = &disk->queue->integrity;
-	struct integrity_sysfs_entry *entry =
-		container_of(attr, struct integrity_sysfs_entry, attr);
-	ssize_t ret = 0;
+	struct device *dev = disk_to_dev(disk);
+	struct device_attribute *dev_attr =
+		container_of(attr, struct device_attribute, attr);
 
-	if (entry->store)
-		ret = entry->store(bi, page, count);
+	if (!dev_attr->store)
+		return 0;
+	return dev_attr->store(dev, dev_attr, page, count);
+}
 
-	return ret;
+static inline struct blk_integrity *dev_to_bi(struct device *dev)
+{
+	return &dev_to_disk(dev)->queue->integrity;
 }
 
-static ssize_t integrity_format_show(struct blk_integrity *bi, char *page)
+static ssize_t format_show(struct device *dev, struct device_attribute *attr,
+			   char *page)
 {
+	struct blk_integrity *bi = dev_to_bi(dev);
+
 	if (bi->profile && bi->profile->name)
 		return sysfs_emit(page, "%s\n", bi->profile->name);
 	return sysfs_emit(page, "none\n");
 }
 
-static ssize_t integrity_tag_size_show(struct blk_integrity *bi, char *page)
+static ssize_t tag_size_show(struct device *dev, struct device_attribute *attr,
+			     char *page)
 {
+	struct blk_integrity *bi = dev_to_bi(dev);
+
 	return sysfs_emit(page, "%u\n", bi->tag_size);
 }
 
-static ssize_t integrity_interval_show(struct blk_integrity *bi, char *page)
+static ssize_t protection_interval_bytes_show(struct device *dev,
+					      struct device_attribute *attr,
+					      char *page)
 {
+	struct blk_integrity *bi = dev_to_bi(dev);
+
 	return sysfs_emit(page, "%u\n",
 			  bi->interval_exp ? 1 << bi->interval_exp : 0);
 }
 
-static ssize_t integrity_verify_store(struct blk_integrity *bi,
-				      const char *page, size_t count)
+static ssize_t read_verify_store(struct device *dev,
+				 struct device_attribute *attr,
+				 const char *page, size_t count)
 {
+	struct blk_integrity *bi = dev_to_bi(dev);
 	char *p = (char *) page;
 	unsigned long val = simple_strtoul(p, &p, 10);
 
@@ -277,14 +286,20 @@ static ssize_t integrity_verify_store(struct blk_integrity *bi,
 	return count;
 }
 
-static ssize_t integrity_verify_show(struct blk_integrity *bi, char *page)
+static ssize_t read_verify_show(struct device *dev,
+				struct device_attribute *attr, char *page)
 {
+	struct blk_integrity *bi = dev_to_bi(dev);
+
 	return sysfs_emit(page, "%d\n", !!(bi->flags & BLK_INTEGRITY_VERIFY));
 }
 
-static ssize_t integrity_generate_store(struct blk_integrity *bi,
-					const char *page, size_t count)
+static ssize_t write_generate_store(struct device *dev,
+				    struct device_attribute *attr,
+				    const char *page, size_t count)
 {
+	struct blk_integrity *bi = dev_to_bi(dev);
+
 	char *p = (char *) page;
 	unsigned long val = simple_strtoul(p, &p, 10);
 
@@ -296,57 +311,39 @@ static ssize_t integrity_generate_store(struct blk_integrity *bi,
 	return count;
 }
 
-static ssize_t integrity_generate_show(struct blk_integrity *bi, char *page)
+static ssize_t write_generate_show(struct device *dev,
+				   struct device_attribute *attr, char *page)
 {
+	struct blk_integrity *bi = dev_to_bi(dev);
+
 	return sysfs_emit(page, "%d\n", !!(bi->flags & BLK_INTEGRITY_GENERATE));
 }
 
-static ssize_t integrity_device_show(struct blk_integrity *bi, char *page)
+static ssize_t device_is_integrity_capable_show(struct device *dev,
+						struct device_attribute *attr,
+						char *page)
 {
+	struct blk_integrity *bi = dev_to_bi(dev);
+
 	return sysfs_emit(page, "%u\n",
 			  !!(bi->flags & BLK_INTEGRITY_DEVICE_CAPABLE));
 }
 
-static struct integrity_sysfs_entry integrity_format_entry = {
-	.attr = { .name = "format", .mode = 0444 },
-	.show = integrity_format_show,
-};
-
-static struct integrity_sysfs_entry integrity_tag_size_entry = {
-	.attr = { .name = "tag_size", .mode = 0444 },
-	.show = integrity_tag_size_show,
-};
-
-static struct integrity_sysfs_entry integrity_interval_entry = {
-	.attr = { .name = "protection_interval_bytes", .mode = 0444 },
-	.show = integrity_interval_show,
-};
-
-static struct integrity_sysfs_entry integrity_verify_entry = {
-	.attr = { .name = "read_verify", .mode = 0644 },
-	.show = integrity_verify_show,
-	.store = integrity_verify_store,
-};
-
-static struct integrity_sysfs_entry integrity_generate_entry = {
-	.attr = { .name = "write_generate", .mode = 0644 },
-	.show = integrity_generate_show,
-	.store = integrity_generate_store,
-};
-
-static struct integrity_sysfs_entry integrity_device_entry = {
-	.attr = { .name = "device_is_integrity_capable", .mode = 0444 },
-	.show = integrity_device_show,
-};
+static DEVICE_ATTR_RO(format);
+static DEVICE_ATTR_RO(tag_size);
+static DEVICE_ATTR_RO(protection_interval_bytes);
+static DEVICE_ATTR_RW(read_verify);
+static DEVICE_ATTR_RW(write_generate);
+static DEVICE_ATTR_RO(device_is_integrity_capable);
 
 static struct attribute *integrity_attrs[] = {
-	&integrity_format_entry.attr,
-	&integrity_tag_size_entry.attr,
-	&integrity_interval_entry.attr,
-	&integrity_verify_entry.attr,
-	&integrity_generate_entry.attr,
-	&integrity_device_entry.attr,
-	NULL,
+	&dev_attr_format.attr,
+	&dev_attr_tag_size.attr,
+	&dev_attr_protection_interval_bytes.attr,
+	&dev_attr_read_verify.attr,
+	&dev_attr_write_generate.attr,
+	&dev_attr_device_is_integrity_capable.attr,
+	NULL
 };
 ATTRIBUTE_GROUPS(integrity);
 
-- 
2.43.0



