Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72B218F57
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:57:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5FEBC433C8;
	Sun, 16 Jul 2023 20:57:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689541047;
	bh=nAGxizrJ1pgVm6a4R4Y70MTLSdUnbCFnc1q7DrFlZZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qQMH+VGEBBDNdRGitLwFSsCUSySrDOazx8vlYeGjA8wrVB/0PyflUhKRbaqKVNuJq
	 03J7VNyVz9f6w0CLU/gvAZTOsjz5w5FxhIPdIbCCecUtHe9SzyhVhsEiDCcogzlliv
	 UDxHaVRMUnVb3q/WfN6DUYhRJeb1NMEFFhT0Hh3I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Evan Quan <evan.quan@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Wolfram Sang <wsa@kernel.org>
Subject: [PATCH 6.1 553/591] usb: typec: ucsi: Mark dGPUs as DEVICE scope
Date: Sun, 16 Jul 2023 21:51:32 +0200
Message-ID: <20230716194938.162844890@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mario Limonciello <mario.limonciello@amd.com>

commit a7fbfd44c0204f0629288edfd0d77829edb4a2f8 upstream.

power_supply_is_system_supplied() checks whether any power
supplies are present that aren't batteries to decide whether
the system is running on DC or AC.  Downstream drivers use
this to make performance decisions.

Navi dGPUs include an UCSI function that has been exported
since commit 17631e8ca2d3 ("i2c: designware: Add driver
support for AMD NAVI GPU").

This UCSI function registers a power supply since commit
992a60ed0d5e ("usb: typec: ucsi: register with power_supply class")
but this is not a system power supply.

As the power supply for a dGPU is only for powering devices connected
to dGPU, create a device property to indicate that the UCSI endpoint
is only for the scope of `POWER_SUPPLY_SCOPE_DEVICE`.

Link: https://lore.kernel.org/lkml/20230516182541.5836-2-mario.limonciello@amd.com/
Reviewed-by: Evan Quan <evan.quan@amd.com>
Tested-by: Evan Quan <evan.quan@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Acked-by: Andi Shyti <andi.shyti@kernel.org>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-designware-pcidrv.c |   13 ++++++++++++-
 drivers/i2c/busses/i2c-nvidia-gpu.c        |    3 +++
 drivers/usb/typec/ucsi/psy.c               |   14 ++++++++++++++
 3 files changed, 29 insertions(+), 1 deletion(-)

--- a/drivers/i2c/busses/i2c-designware-pcidrv.c
+++ b/drivers/i2c/busses/i2c-designware-pcidrv.c
@@ -20,6 +20,7 @@
 #include <linux/module.h>
 #include <linux/pci.h>
 #include <linux/pm_runtime.h>
+#include <linux/power_supply.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
 
@@ -234,6 +235,16 @@ static const struct dev_pm_ops i2c_dw_pm
 	SET_RUNTIME_PM_OPS(i2c_dw_pci_runtime_suspend, i2c_dw_pci_runtime_resume, NULL)
 };
 
+static const struct property_entry dgpu_properties[] = {
+	/* USB-C doesn't power the system */
+	PROPERTY_ENTRY_U8("scope", POWER_SUPPLY_SCOPE_DEVICE),
+	{}
+};
+
+static const struct software_node dgpu_node = {
+	.properties = dgpu_properties,
+};
+
 static int i2c_dw_pci_probe(struct pci_dev *pdev,
 			    const struct pci_device_id *id)
 {
@@ -325,7 +336,7 @@ static int i2c_dw_pci_probe(struct pci_d
 	}
 
 	if ((dev->flags & MODEL_MASK) == MODEL_AMD_NAVI_GPU) {
-		dev->slave = i2c_new_ccgx_ucsi(&dev->adapter, dev->irq, NULL);
+		dev->slave = i2c_new_ccgx_ucsi(&dev->adapter, dev->irq, &dgpu_node);
 		if (IS_ERR(dev->slave))
 			return dev_err_probe(dev->dev, PTR_ERR(dev->slave),
 					     "register UCSI failed\n");
--- a/drivers/i2c/busses/i2c-nvidia-gpu.c
+++ b/drivers/i2c/busses/i2c-nvidia-gpu.c
@@ -14,6 +14,7 @@
 #include <linux/platform_device.h>
 #include <linux/pm.h>
 #include <linux/pm_runtime.h>
+#include <linux/power_supply.h>
 
 #include <asm/unaligned.h>
 
@@ -261,6 +262,8 @@ MODULE_DEVICE_TABLE(pci, gpu_i2c_ids);
 static const struct property_entry ccgx_props[] = {
 	/* Use FW built for NVIDIA GPU only */
 	PROPERTY_ENTRY_STRING("firmware-name", "nvidia,gpu"),
+	/* USB-C doesn't power the system */
+	PROPERTY_ENTRY_U8("scope", POWER_SUPPLY_SCOPE_DEVICE),
 	{ }
 };
 
--- a/drivers/usb/typec/ucsi/psy.c
+++ b/drivers/usb/typec/ucsi/psy.c
@@ -27,8 +27,20 @@ static enum power_supply_property ucsi_p
 	POWER_SUPPLY_PROP_VOLTAGE_NOW,
 	POWER_SUPPLY_PROP_CURRENT_MAX,
 	POWER_SUPPLY_PROP_CURRENT_NOW,
+	POWER_SUPPLY_PROP_SCOPE,
 };
 
+static int ucsi_psy_get_scope(struct ucsi_connector *con,
+			      union power_supply_propval *val)
+{
+	u8 scope = POWER_SUPPLY_SCOPE_UNKNOWN;
+	struct device *dev = con->ucsi->dev;
+
+	device_property_read_u8(dev, "scope", &scope);
+	val->intval = scope;
+	return 0;
+}
+
 static int ucsi_psy_get_online(struct ucsi_connector *con,
 			       union power_supply_propval *val)
 {
@@ -194,6 +206,8 @@ static int ucsi_psy_get_prop(struct powe
 		return ucsi_psy_get_current_max(con, val);
 	case POWER_SUPPLY_PROP_CURRENT_NOW:
 		return ucsi_psy_get_current_now(con, val);
+	case POWER_SUPPLY_PROP_SCOPE:
+		return ucsi_psy_get_scope(con, val);
 	default:
 		return -EINVAL;
 	}


