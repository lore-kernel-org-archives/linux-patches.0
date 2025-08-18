Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF6C9320CAB;
	Mon, 18 Aug 2025 13:42:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524556; cv=none; b=aoEGXvSOVE1xk2lIb5MfohyHlC/9jeFYwoQM7QSb4CeolvAiXOGqVS1U1lKks9ZKSY0kVqn6xLVKKTGKCXpyu5ZkUI3rSJbSG0cYy4ZABub0aNfKbiYclJUkbufwTkHRnxIGaTJQYe/+dDvLotnpRB8nJkHVjerMUIbmLhrtqKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524556; c=relaxed/simple;
	bh=wpBy7O51U9PLXSeYmmp4ii4V7mUSQlO+FhXIRUXn620=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XC5KdSz8CkpuqhR6tzOxdyCa4pJk5fcWleLfW4rB0We+FokCko+2eyFSqFBHhVzS94sq1qxLM3SAIbZpyitt5GYtB0UC16BkJR5cOTxpcRWqRIn2ZQ4NcoUiBhayFkbxQKIDnuwK7e1h7XzGfaKbgCAP0tXjChPQ6XjEMABV6b0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ojAgsJA0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ojAgsJA0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFA51C4CEF1;
	Mon, 18 Aug 2025 13:42:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524556;
	bh=wpBy7O51U9PLXSeYmmp4ii4V7mUSQlO+FhXIRUXn620=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ojAgsJA0R+MIG9twiGLQlWwYkowHjR8EulbsRMdbl+36K4ZTvJ4ufTnDUUx9gDDQa
	 ch9xYfwre9t2vK0PTDNPU4fZEgcQ1aO6XMXe2nfdaGfjuUvvPpBdOucfYhE555ZZNG
	 WOX99M50WOn5F6PWXnfinjDKR8hU9bMhbl4Fpf24=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Borah, Chaitanya Kumar" <chaitanya.kumar.borah@intel.com>,
	kernel test robot <oliver.sang@intel.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.15 509/515] ata: libata-sata: Add link_power_management_supported sysfs attribute
Date: Mon, 18 Aug 2025 14:48:15 +0200
Message-ID: <20250818124518.032971986@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Damien Le Moal <dlemoal@kernel.org>

commit 0060beec0bfa647c4b510df188b1c4673a197839 upstream.

A port link power management (LPM) policy can be controlled using the
link_power_management_policy sysfs host attribute. However, this
attribute exists also for hosts that do not support LPM and in such
case, attempting to change the LPM policy for the host (port) will fail
with -EOPNOTSUPP.

Introduce the new sysfs link_power_management_supported host attribute
to indicate to the user if a the port and the devices connected to the
port for the host support LPM, which implies that the
link_power_management_policy attribute can be used.

Since checking that a port and its devices support LPM is common between
the new ata_scsi_lpm_supported_show() function and the existing
ata_scsi_lpm_store() function, the new helper ata_scsi_lpm_supported()
is introduced.

Fixes: 413e800cadbf ("ata: libata-sata: Disallow changing LPM state if not supported")
Reported-by: Borah, Chaitanya Kumar <chaitanya.kumar.borah@intel.com>
Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202507251014.a5becc3b-lkp@intel.com
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ata/ata_piix.c    |    1 
 drivers/ata/libahci.c     |    1 
 drivers/ata/libata-sata.c |   53 +++++++++++++++++++++++++++++++++++-----------
 include/linux/libata.h    |    1 
 4 files changed, 44 insertions(+), 12 deletions(-)

--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -1089,6 +1089,7 @@ static struct ata_port_operations ich_pa
 };
 
 static struct attribute *piix_sidpr_shost_attrs[] = {
+	&dev_attr_link_power_management_supported.attr,
 	&dev_attr_link_power_management_policy.attr,
 	NULL
 };
--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -111,6 +111,7 @@ static DEVICE_ATTR(em_buffer, S_IWUSR |
 static DEVICE_ATTR(em_message_supported, S_IRUGO, ahci_show_em_supported, NULL);
 
 static struct attribute *ahci_shost_attrs[] = {
+	&dev_attr_link_power_management_supported.attr,
 	&dev_attr_link_power_management_policy.attr,
 	&dev_attr_em_message_type.attr,
 	&dev_attr_em_message.attr,
--- a/drivers/ata/libata-sata.c
+++ b/drivers/ata/libata-sata.c
@@ -900,14 +900,52 @@ static const char *ata_lpm_policy_names[
 	[ATA_LPM_MIN_POWER]		= "min_power",
 };
 
+/*
+ * Check if a port supports link power management.
+ * Must be called with the port locked.
+ */
+static bool ata_scsi_lpm_supported(struct ata_port *ap)
+{
+	struct ata_link *link;
+	struct ata_device *dev;
+
+	if (ap->flags & ATA_FLAG_NO_LPM)
+		return false;
+
+	ata_for_each_link(link, ap, EDGE) {
+		ata_for_each_dev(dev, &ap->link, ENABLED) {
+			if (dev->quirks & ATA_QUIRK_NOLPM)
+				return false;
+		}
+	}
+
+	return true;
+}
+
+static ssize_t ata_scsi_lpm_supported_show(struct device *dev,
+				 struct device_attribute *attr, char *buf)
+{
+	struct Scsi_Host *shost = class_to_shost(dev);
+	struct ata_port *ap = ata_shost_to_port(shost);
+	unsigned long flags;
+	bool supported;
+
+	spin_lock_irqsave(ap->lock, flags);
+	supported = ata_scsi_lpm_supported(ap);
+	spin_unlock_irqrestore(ap->lock, flags);
+
+	return sysfs_emit(buf, "%d\n", supported);
+}
+DEVICE_ATTR(link_power_management_supported, S_IRUGO,
+	    ata_scsi_lpm_supported_show, NULL);
+EXPORT_SYMBOL_GPL(dev_attr_link_power_management_supported);
+
 static ssize_t ata_scsi_lpm_store(struct device *device,
 				  struct device_attribute *attr,
 				  const char *buf, size_t count)
 {
 	struct Scsi_Host *shost = class_to_shost(device);
 	struct ata_port *ap = ata_shost_to_port(shost);
-	struct ata_link *link;
-	struct ata_device *dev;
 	enum ata_lpm_policy policy;
 	unsigned long flags;
 
@@ -924,20 +962,11 @@ static ssize_t ata_scsi_lpm_store(struct
 
 	spin_lock_irqsave(ap->lock, flags);
 
-	if (ap->flags & ATA_FLAG_NO_LPM) {
+	if (!ata_scsi_lpm_supported(ap)) {
 		count = -EOPNOTSUPP;
 		goto out_unlock;
 	}
 
-	ata_for_each_link(link, ap, EDGE) {
-		ata_for_each_dev(dev, &ap->link, ENABLED) {
-			if (dev->quirks & ATA_QUIRK_NOLPM) {
-				count = -EOPNOTSUPP;
-				goto out_unlock;
-			}
-		}
-	}
-
 	ap->target_lpm_policy = policy;
 	ata_port_schedule_eh(ap);
 out_unlock:
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -545,6 +545,7 @@ typedef void (*ata_postreset_fn_t)(struc
 
 extern struct device_attribute dev_attr_unload_heads;
 #ifdef CONFIG_SATA_HOST
+extern struct device_attribute dev_attr_link_power_management_supported;
 extern struct device_attribute dev_attr_link_power_management_policy;
 extern struct device_attribute dev_attr_ncq_prio_supported;
 extern struct device_attribute dev_attr_ncq_prio_enable;


