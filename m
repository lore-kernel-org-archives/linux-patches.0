Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F180C1A3159;
	Tue, 27 May 2025 17:38:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367530; cv=none; b=AWSpbJ73BanJiNhuknoNXPFjlnboJ4SeRNp08YBlLARE2wHZCGnUIFoWj+VtyQ8wzoKH+J/wCNqof4yXvZTrJnUt5lbCRecNzV4FTmHFv3U14+k7VwBZ2X1fw8NYMcUxNfcYuAZJxCDdej7BemrHFY7FFW2tGvGDwLKQ/xVLf2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367530; c=relaxed/simple;
	bh=kBCIjNbt8g0xhMXPXO13hevZ3Au3nMogRNLBIXLoktg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gX0Te5oFzLuxkmQF7M/2ZAzVSCq0Ez5B2AMji6GijV81SNsECv+VVmTi0WpLaUBlMXl/sODTD2xHu9mNbVt9ajHp0fYI79YEQV1SCc1hY0zfscKgKrLpAn2kaxgiFLnlWu/w6H8b/QzeRj3R8TFwsMtTc8tBJjYQ8jR1NVp6IUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PVZ8WeMj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PVZ8WeMj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FDECC4CEE9;
	Tue, 27 May 2025 17:38:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367529;
	bh=kBCIjNbt8g0xhMXPXO13hevZ3Au3nMogRNLBIXLoktg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PVZ8WeMjtXKULHqQwXWApTwjA5iBkWSqZrwa730Hezd/2yys0mw9ve9knSTKD0nyE
	 zzxgi0+3r+LN0szhG78pHNhtkcn24QZDE6h/mb4gwtRyHVp4inBb1tFcLEy7dt4PTW
	 g5y0e6gS8pBlq8JdC/cQhYzpBnq9M8W1LzbXP00Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodolfo Giometti <giometti@enneenne.com>,
	Subramanian Mohan <subramanian.mohan@intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 387/783] pps: generators: replace copy of pps-gen info struct with const pointer
Date: Tue, 27 May 2025 18:23:04 +0200
Message-ID: <20250527162528.854518707@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Subramanian Mohan <subramanian.mohan@intel.com>

[ Upstream commit ac9c5170a18162d45c6edd1f0fa2d2b2504bc2cb ]

Some PPS generator drivers may need to retrieve a pointer to their
internal data while executing the PPS generator enable() method.

During the driver registration the pps_gen_device pointer is returned
from the framework, and for that reason, there is difficulty in
getting generator driver data back in the enable function. We won't be
able to use container_of macro as it results in static assert, and we
might end up in using static pointer.

To solve the issue and to get back the generator driver data back, we
should not copy the struct pps_gen_source_info within the struct
pps_gen_device during the registration stage, but simply save the
pointer of the driver one. In this manner, driver may get a pointer
to their internal data as shown below:

struct pps_gen_foo_data_s {
        ...
	struct pps_gen_source_info gen_info;
	struct pps_gen_device *pps_gen;
	...
};

static int __init pps_gen_foo_init(void)
{
        struct pps_gen_foo_data_s *foo;
	...
        foo->pps_gen = pps_gen_register_source(&foo->gen_info);
	...
}

Then, in the enable() method, we can retrieve the pointer to the main
struct by using the code below:

static int pps_gen_foo_enable(struct pps_gen_device *pps_gen, bool enable)
{
        struct pps_gen_foo_data_s *foo = container_of(pps_gen->info,
						struct pps_gen_foo_data_s, gen_info);
        ...
}

Signed-off-by: Rodolfo Giometti <giometti@enneenne.com>
Tested-by: Subramanian Mohan <subramanian.mohan@intel.com>
Suggested-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Subramanian Mohan <subramanian.mohan@intel.com>
Link: https://lore.kernel.org/r/20250219040618.70962-2-subramanian.mohan@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/driver-api/pps.rst       |  3 +--
 drivers/pps/generators/pps_gen-dummy.c |  2 +-
 drivers/pps/generators/pps_gen.c       | 14 +++++++-------
 drivers/pps/generators/sysfs.c         |  6 +++---
 include/linux/pps_gen_kernel.h         |  4 ++--
 5 files changed, 14 insertions(+), 15 deletions(-)

diff --git a/Documentation/driver-api/pps.rst b/Documentation/driver-api/pps.rst
index 71ad04c82d6cf..04f1b88778fc5 100644
--- a/Documentation/driver-api/pps.rst
+++ b/Documentation/driver-api/pps.rst
@@ -206,8 +206,7 @@ To do so the class pps-gen has been added. PPS generators can be
 registered in the kernel by defining a struct pps_gen_source_info as
 follows::
 
-    static struct pps_gen_source_info pps_gen_dummy_info = {
-            .name                   = "dummy",
+    static const struct pps_gen_source_info pps_gen_dummy_info = {
             .use_system_clock       = true,
             .get_time               = pps_gen_dummy_get_time,
             .enable                 = pps_gen_dummy_enable,
diff --git a/drivers/pps/generators/pps_gen-dummy.c b/drivers/pps/generators/pps_gen-dummy.c
index b284c200cbe50..55de4aecf35ed 100644
--- a/drivers/pps/generators/pps_gen-dummy.c
+++ b/drivers/pps/generators/pps_gen-dummy.c
@@ -61,7 +61,7 @@ static int pps_gen_dummy_enable(struct pps_gen_device *pps_gen, bool enable)
  * The PPS info struct
  */
 
-static struct pps_gen_source_info pps_gen_dummy_info = {
+static const struct pps_gen_source_info pps_gen_dummy_info = {
 	.use_system_clock	= true,
 	.get_time		= pps_gen_dummy_get_time,
 	.enable			= pps_gen_dummy_enable,
diff --git a/drivers/pps/generators/pps_gen.c b/drivers/pps/generators/pps_gen.c
index ca592f1736f46..5b8bb454913cd 100644
--- a/drivers/pps/generators/pps_gen.c
+++ b/drivers/pps/generators/pps_gen.c
@@ -66,7 +66,7 @@ static long pps_gen_cdev_ioctl(struct file *file,
 		if (ret)
 			return -EFAULT;
 
-		ret = pps_gen->info.enable(pps_gen, status);
+		ret = pps_gen->info->enable(pps_gen, status);
 		if (ret)
 			return ret;
 		pps_gen->enabled = status;
@@ -76,7 +76,7 @@ static long pps_gen_cdev_ioctl(struct file *file,
 	case PPS_GEN_USESYSTEMCLOCK:
 		dev_dbg(pps_gen->dev, "PPS_GEN_USESYSTEMCLOCK\n");
 
-		ret = put_user(pps_gen->info.use_system_clock, uiuarg);
+		ret = put_user(pps_gen->info->use_system_clock, uiuarg);
 		if (ret)
 			return -EFAULT;
 
@@ -175,7 +175,7 @@ static int pps_gen_register_cdev(struct pps_gen_device *pps_gen)
 	devt = MKDEV(MAJOR(pps_gen_devt), pps_gen->id);
 
 	cdev_init(&pps_gen->cdev, &pps_gen_cdev_fops);
-	pps_gen->cdev.owner = pps_gen->info.owner;
+	pps_gen->cdev.owner = pps_gen->info->owner;
 
 	err = cdev_add(&pps_gen->cdev, devt, 1);
 	if (err) {
@@ -183,8 +183,8 @@ static int pps_gen_register_cdev(struct pps_gen_device *pps_gen)
 				MAJOR(pps_gen_devt), pps_gen->id);
 		goto free_ida;
 	}
-	pps_gen->dev = device_create(pps_gen_class, pps_gen->info.parent, devt,
-					pps_gen, "pps-gen%d", pps_gen->id);
+	pps_gen->dev = device_create(pps_gen_class, pps_gen->info->parent, devt,
+				     pps_gen, "pps-gen%d", pps_gen->id);
 	if (IS_ERR(pps_gen->dev)) {
 		err = PTR_ERR(pps_gen->dev);
 		goto del_cdev;
@@ -225,7 +225,7 @@ static void pps_gen_unregister_cdev(struct pps_gen_device *pps_gen)
  * Return: the PPS generator device in case of success, and ERR_PTR(errno)
  *	 otherwise.
  */
-struct pps_gen_device *pps_gen_register_source(struct pps_gen_source_info *info)
+struct pps_gen_device *pps_gen_register_source(const struct pps_gen_source_info *info)
 {
 	struct pps_gen_device *pps_gen;
 	int err;
@@ -235,7 +235,7 @@ struct pps_gen_device *pps_gen_register_source(struct pps_gen_source_info *info)
 		err = -ENOMEM;
 		goto pps_gen_register_source_exit;
 	}
-	pps_gen->info = *info;
+	pps_gen->info = info;
 	pps_gen->enabled = false;
 
 	init_waitqueue_head(&pps_gen->queue);
diff --git a/drivers/pps/generators/sysfs.c b/drivers/pps/generators/sysfs.c
index faf8b1c6d2026..6d6bc0006feae 100644
--- a/drivers/pps/generators/sysfs.c
+++ b/drivers/pps/generators/sysfs.c
@@ -19,7 +19,7 @@ static ssize_t system_show(struct device *dev, struct device_attribute *attr,
 {
 	struct pps_gen_device *pps_gen = dev_get_drvdata(dev);
 
-	return sysfs_emit(buf, "%d\n", pps_gen->info.use_system_clock);
+	return sysfs_emit(buf, "%d\n", pps_gen->info->use_system_clock);
 }
 static DEVICE_ATTR_RO(system);
 
@@ -30,7 +30,7 @@ static ssize_t time_show(struct device *dev, struct device_attribute *attr,
 	struct timespec64 time;
 	int ret;
 
-	ret = pps_gen->info.get_time(pps_gen, &time);
+	ret = pps_gen->info->get_time(pps_gen, &time);
 	if (ret)
 		return ret;
 
@@ -49,7 +49,7 @@ static ssize_t enable_store(struct device *dev, struct device_attribute *attr,
 	if (ret)
 		return ret;
 
-	ret = pps_gen->info.enable(pps_gen, status);
+	ret = pps_gen->info->enable(pps_gen, status);
 	if (ret)
 		return ret;
 	pps_gen->enabled = status;
diff --git a/include/linux/pps_gen_kernel.h b/include/linux/pps_gen_kernel.h
index 022ea0ac44402..6214c8aa2e020 100644
--- a/include/linux/pps_gen_kernel.h
+++ b/include/linux/pps_gen_kernel.h
@@ -43,7 +43,7 @@ struct pps_gen_source_info {
 
 /* The main struct */
 struct pps_gen_device {
-	struct pps_gen_source_info info;	/* PSS generator info */
+	const struct pps_gen_source_info *info;	/* PSS generator info */
 	bool enabled;				/* PSS generator status */
 
 	unsigned int event;
@@ -70,7 +70,7 @@ extern const struct attribute_group *pps_gen_groups[];
  */
 
 extern struct pps_gen_device *pps_gen_register_source(
-				struct pps_gen_source_info *info);
+				const struct pps_gen_source_info *info);
 extern void pps_gen_unregister_source(struct pps_gen_device *pps_gen);
 extern void pps_gen_event(struct pps_gen_device *pps_gen,
 				unsigned int event, void *data);
-- 
2.39.5



