Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 503B63C1965;
	Thu, 15 Jan 2026 17:36:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498583; cv=none; b=mm58jn9Fl/p2QJjvyGHzFqywKHY26KC32mrl0fCAXlKEdj12xZGiCEvQ0ZNpnCegOqDiOUU6dbPOCmgGfVQYR+a1Txm9LJtCYPyP87ohjRMij7dEygkFbni8EQc0nwLerI1H50UEg1Mn32JhlEmukVFfYf94eW4M7Du9fh1+VY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498583; c=relaxed/simple;
	bh=WCAgr9bdICRMkQjxucmrGC7id0MboqA0RoVUMd4aePU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L6dpexgekPVsEeLpNxG8end/NMOU/2YJXD9UQ4rZFFZp4xxCL3PCZAlvx0SGC9W5f3H0XT3TcBdeLmECV+hDBsFqW8kehujzKvggNZ5vkViNnoF5HAm+bu+8YjBbPYl1sYMUi5SLxwkx9UcOr24YyWcEDr5uqCeYUjUrzPgyPzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KIpAlT6i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KIpAlT6i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D026FC116D0;
	Thu, 15 Jan 2026 17:36:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498583;
	bh=WCAgr9bdICRMkQjxucmrGC7id0MboqA0RoVUMd4aePU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KIpAlT6i/nQhJQKlQCD8FKRY+CFJ7i9q2WJuKjWgpevB0OUZkpUurwULzyV9SNqGh
	 fSWYNHb1yCDx5uEJBdMKmhHGeDcKM0B/yS/QgPt/na0fg9Uj21p0/Cdx4nx2VBS1SO
	 hbgiooXwYgNclnZZie1QmeG4naCvMTX+vsDFFEBg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Shtylyov <s.shtylyov@omp.ru>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Chen Yu <xnguchen@sina.cn>
Subject: [PATCH 5.15 482/554] mmc: core: use sysfs_emit() instead of sprintf()
Date: Thu, 15 Jan 2026 17:49:08 +0100
Message-ID: <20260115164303.757368105@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

From: Sergey Shtylyov <s.shtylyov@omp.ru>

[ Upstream commit f5d8a5fe77ce933f53eb8f2e22bb7a1a2019ea11 ]

sprintf() (still used in the MMC core for the sysfs output) is vulnerable
to the buffer overflow.  Use the new-fangled sysfs_emit() instead.

Found by Linux Verification Center (linuxtesting.org) with the SVACE static
analysis tool.

Signed-off-by: Sergey Shtylyov <s.shtylyov@omp.ru>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/717729b2-d65b-c72e-9fac-471d28d00b5a@omp.ru
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Chen Yu <xnguchen@sina.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/core/bus.c      |    9 +++++----
 drivers/mmc/core/bus.h      |    3 ++-
 drivers/mmc/core/mmc.c      |   16 ++++++++--------
 drivers/mmc/core/sd.c       |   27 +++++++++++++--------------
 drivers/mmc/core/sdio.c     |    5 +++--
 drivers/mmc/core/sdio_bus.c |    7 ++++---
 6 files changed, 35 insertions(+), 32 deletions(-)

--- a/drivers/mmc/core/bus.c
+++ b/drivers/mmc/core/bus.c
@@ -15,6 +15,7 @@
 #include <linux/stat.h>
 #include <linux/of.h>
 #include <linux/pm_runtime.h>
+#include <linux/sysfs.h>
 
 #include <linux/mmc/card.h>
 #include <linux/mmc/host.h>
@@ -34,13 +35,13 @@ static ssize_t type_show(struct device *
 
 	switch (card->type) {
 	case MMC_TYPE_MMC:
-		return sprintf(buf, "MMC\n");
+		return sysfs_emit(buf, "MMC\n");
 	case MMC_TYPE_SD:
-		return sprintf(buf, "SD\n");
+		return sysfs_emit(buf, "SD\n");
 	case MMC_TYPE_SDIO:
-		return sprintf(buf, "SDIO\n");
+		return sysfs_emit(buf, "SDIO\n");
 	case MMC_TYPE_SD_COMBO:
-		return sprintf(buf, "SDcombo\n");
+		return sysfs_emit(buf, "SDcombo\n");
 	default:
 		return -EFAULT;
 	}
--- a/drivers/mmc/core/bus.h
+++ b/drivers/mmc/core/bus.h
@@ -9,6 +9,7 @@
 #define _MMC_CORE_BUS_H
 
 #include <linux/device.h>
+#include <linux/sysfs.h>
 
 struct mmc_host;
 struct mmc_card;
@@ -17,7 +18,7 @@ struct mmc_card;
 static ssize_t mmc_##name##_show (struct device *dev, struct device_attribute *attr, char *buf)	\
 {										\
 	struct mmc_card *card = mmc_dev_to_card(dev);				\
-	return sprintf(buf, fmt, args);						\
+	return sysfs_emit(buf, fmt, args);					\
 }										\
 static DEVICE_ATTR(name, S_IRUGO, mmc_##name##_show, NULL)
 
--- a/drivers/mmc/core/mmc.c
+++ b/drivers/mmc/core/mmc.c
@@ -12,6 +12,7 @@
 #include <linux/slab.h>
 #include <linux/stat.h>
 #include <linux/pm_runtime.h>
+#include <linux/sysfs.h>
 
 #include <linux/mmc/host.h>
 #include <linux/mmc/card.h>
@@ -812,12 +813,11 @@ static ssize_t mmc_fwrev_show(struct dev
 {
 	struct mmc_card *card = mmc_dev_to_card(dev);
 
-	if (card->ext_csd.rev < 7) {
-		return sprintf(buf, "0x%x\n", card->cid.fwrev);
-	} else {
-		return sprintf(buf, "0x%*phN\n", MMC_FIRMWARE_LEN,
-			       card->ext_csd.fwrev);
-	}
+	if (card->ext_csd.rev < 7)
+		return sysfs_emit(buf, "0x%x\n", card->cid.fwrev);
+	else
+		return sysfs_emit(buf, "0x%*phN\n", MMC_FIRMWARE_LEN,
+				  card->ext_csd.fwrev);
 }
 
 static DEVICE_ATTR(fwrev, S_IRUGO, mmc_fwrev_show, NULL);
@@ -830,10 +830,10 @@ static ssize_t mmc_dsr_show(struct devic
 	struct mmc_host *host = card->host;
 
 	if (card->csd.dsr_imp && host->dsr_req)
-		return sprintf(buf, "0x%x\n", host->dsr);
+		return sysfs_emit(buf, "0x%x\n", host->dsr);
 	else
 		/* return default DSR value */
-		return sprintf(buf, "0x%x\n", 0x404);
+		return sysfs_emit(buf, "0x%x\n", 0x404);
 }
 
 static DEVICE_ATTR(dsr, S_IRUGO, mmc_dsr_show, NULL);
--- a/drivers/mmc/core/sd.c
+++ b/drivers/mmc/core/sd.c
@@ -12,6 +12,7 @@
 #include <linux/slab.h>
 #include <linux/stat.h>
 #include <linux/pm_runtime.h>
+#include <linux/sysfs.h>
 
 #include <linux/mmc/host.h>
 #include <linux/mmc/card.h>
@@ -707,18 +708,16 @@ MMC_DEV_ATTR(ocr, "0x%08x\n", card->ocr)
 MMC_DEV_ATTR(rca, "0x%04x\n", card->rca);
 
 
-static ssize_t mmc_dsr_show(struct device *dev,
-                           struct device_attribute *attr,
-                           char *buf)
-{
-       struct mmc_card *card = mmc_dev_to_card(dev);
-       struct mmc_host *host = card->host;
-
-       if (card->csd.dsr_imp && host->dsr_req)
-               return sprintf(buf, "0x%x\n", host->dsr);
-       else
-               /* return default DSR value */
-               return sprintf(buf, "0x%x\n", 0x404);
+static ssize_t mmc_dsr_show(struct device *dev, struct device_attribute *attr,
+			    char *buf)
+{
+	struct mmc_card *card = mmc_dev_to_card(dev);
+	struct mmc_host *host = card->host;
+
+	if (card->csd.dsr_imp && host->dsr_req)
+		return sysfs_emit(buf, "0x%x\n", host->dsr);
+	/* return default DSR value */
+	return sysfs_emit(buf, "0x%x\n", 0x404);
 }
 
 static DEVICE_ATTR(dsr, S_IRUGO, mmc_dsr_show, NULL);
@@ -734,9 +733,9 @@ static ssize_t info##num##_show(struct d
 												\
 	if (num > card->num_info)								\
 		return -ENODATA;								\
-	if (!card->info[num-1][0])								\
+	if (!card->info[num - 1][0])								\
 		return 0;									\
-	return sprintf(buf, "%s\n", card->info[num-1]);						\
+	return sysfs_emit(buf, "%s\n", card->info[num - 1]);					\
 }												\
 static DEVICE_ATTR_RO(info##num)
 
--- a/drivers/mmc/core/sdio.c
+++ b/drivers/mmc/core/sdio.c
@@ -7,6 +7,7 @@
 
 #include <linux/err.h>
 #include <linux/pm_runtime.h>
+#include <linux/sysfs.h>
 
 #include <linux/mmc/host.h>
 #include <linux/mmc/card.h>
@@ -40,9 +41,9 @@ static ssize_t info##num##_show(struct d
 												\
 	if (num > card->num_info)								\
 		return -ENODATA;								\
-	if (!card->info[num-1][0])								\
+	if (!card->info[num - 1][0])								\
 		return 0;									\
-	return sprintf(buf, "%s\n", card->info[num-1]);						\
+	return sysfs_emit(buf, "%s\n", card->info[num - 1]);					\
 }												\
 static DEVICE_ATTR_RO(info##num)
 
--- a/drivers/mmc/core/sdio_bus.c
+++ b/drivers/mmc/core/sdio_bus.c
@@ -14,6 +14,7 @@
 #include <linux/pm_runtime.h>
 #include <linux/pm_domain.h>
 #include <linux/acpi.h>
+#include <linux/sysfs.h>
 
 #include <linux/mmc/card.h>
 #include <linux/mmc/host.h>
@@ -35,7 +36,7 @@ field##_show(struct device *dev, struct
 	struct sdio_func *func;						\
 									\
 	func = dev_to_sdio_func (dev);					\
-	return sprintf(buf, format_string, args);			\
+	return sysfs_emit(buf, format_string, args);			\
 }									\
 static DEVICE_ATTR_RO(field)
 
@@ -52,9 +53,9 @@ static ssize_t info##num##_show(struct d
 												\
 	if (num > func->num_info)								\
 		return -ENODATA;								\
-	if (!func->info[num-1][0])								\
+	if (!func->info[num - 1][0])								\
 		return 0;									\
-	return sprintf(buf, "%s\n", func->info[num-1]);						\
+	return sysfs_emit(buf, "%s\n", func->info[num - 1]);					\
 }												\
 static DEVICE_ATTR_RO(info##num)
 


