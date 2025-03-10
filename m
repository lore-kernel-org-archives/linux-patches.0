Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EFAE2D023;
	Mon, 10 Mar 2025 17:54:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629293; cv=none; b=CERWhIYCXcqdwdv192osaI5aH62e8rNSLUEK1qSfK+HpnAU98+oX3LeJ4jo5lXoByEam7/ayWJvWhAnG6Qxe9bzDaEHaEPXVfzKO5vcjy3W/+rObnv+Jt9trQnjDgs+ripiIZYvpYxnvtTkw46yWr3kOvdE9oyY7Zau77Xsxrek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629293; c=relaxed/simple;
	bh=UYVA+XxZ+dz/FRY6h06wuhSaG94r5MM59FnhxFVxXKg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gLImC0+fFm47mT9WtSqqx3C4pz2ZeyCh1ygLWlbicEk245XoNRb/6zSrM3t48KlbUBVlae4+NMYIpc0bMF1efeSE5TG19hsSfuelg+cd5vx8fOXzBLy/BnffG081uM9QA5mTgb23/odQAIyfViDdEICd9RIi1W9tdd7316zduCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DOhlkMJ/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DOhlkMJ/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9585C4CEE5;
	Mon, 10 Mar 2025 17:54:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629293;
	bh=UYVA+XxZ+dz/FRY6h06wuhSaG94r5MM59FnhxFVxXKg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DOhlkMJ/hItiOeuhWKQTDduoiKk2PW4suMjTM8Zc8HoKiOY75SQQPk53wN5nBJKqw
	 ufxjV0snYv4C0x7EdI2w+8yNsG4N0g51ZCXsSQhIG4k5UXKpzaeaoURhVvfzT56cgy
	 gIWReBYMt9DANB074PXkfAKP/wE06i/ZahpqGiew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lenny Szubowicz <lszubowi@redhat.com>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 243/620] tg3: Disable tg3 PCIe AER on system reboot
Date: Mon, 10 Mar 2025 18:01:29 +0100
Message-ID: <20250310170555.222867786@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lenny Szubowicz <lszubowi@redhat.com>

[ Upstream commit e0efe83ed325277bb70f9435d4d9fc70bebdcca8 ]

Disable PCIe AER on the tg3 device on system reboot on a limited
list of Dell PowerEdge systems. This prevents a fatal PCIe AER event
on the tg3 device during the ACPI _PTS (prepare to sleep) method for
S5 on those systems. The _PTS is invoked by acpi_enter_sleep_state_prep()
as part of the kernel's reboot sequence as a result of commit
38f34dba806a ("PM: ACPI: reboot: Reinstate S5 for reboot").

There was an earlier fix for this problem by commit 2ca1c94ce0b6
("tg3: Disable tg3 device on system reboot to avoid triggering AER").
But it was discovered that this earlier fix caused a reboot hang
when some Dell PowerEdge servers were booted via ipxe. To address
this reboot hang, the earlier fix was essentially reverted by commit
9fc3bc764334 ("tg3: power down device only on SYSTEM_POWER_OFF").
This re-exposed the tg3 PCIe AER on reboot problem.

This fix is not an ideal solution because the root cause of the AER
is in system firmware. Instead, it's a targeted work-around in the
tg3 driver.

Note also that the PCIe AER must be disabled on the tg3 device even
if the system is configured to use "firmware first" error handling.

V3:
   - Fix sparse warning on improper comparison of pdev->current_state
   - Adhere to netdev comment style

Fixes: 9fc3bc764334 ("tg3: power down device only on SYSTEM_POWER_OFF")
Signed-off-by: Lenny Szubowicz <lszubowi@redhat.com>
Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/tg3.c | 58 +++++++++++++++++++++++++++++
 1 file changed, 58 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index 4fb1d2749c063..7c51b9b593afc 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -55,6 +55,7 @@
 #include <linux/hwmon.h>
 #include <linux/hwmon-sysfs.h>
 #include <linux/crc32poly.h>
+#include <linux/dmi.h>
 
 #include <net/checksum.h>
 #include <net/ip.h>
@@ -18116,6 +18117,50 @@ static int tg3_resume(struct device *device)
 
 static SIMPLE_DEV_PM_OPS(tg3_pm_ops, tg3_suspend, tg3_resume);
 
+/* Systems where ACPI _PTS (Prepare To Sleep) S5 will result in a fatal
+ * PCIe AER event on the tg3 device if the tg3 device is not, or cannot
+ * be, powered down.
+ */
+static const struct dmi_system_id tg3_restart_aer_quirk_table[] = {
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "PowerEdge R440"),
+		},
+	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "PowerEdge R540"),
+		},
+	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "PowerEdge R640"),
+		},
+	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "PowerEdge R650"),
+		},
+	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "PowerEdge R740"),
+		},
+	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "PowerEdge R750"),
+		},
+	},
+	{}
+};
+
 static void tg3_shutdown(struct pci_dev *pdev)
 {
 	struct net_device *dev = pci_get_drvdata(pdev);
@@ -18132,6 +18177,19 @@ static void tg3_shutdown(struct pci_dev *pdev)
 
 	if (system_state == SYSTEM_POWER_OFF)
 		tg3_power_down(tp);
+	else if (system_state == SYSTEM_RESTART &&
+		 dmi_first_match(tg3_restart_aer_quirk_table) &&
+		 pdev->current_state != PCI_D3cold &&
+		 pdev->current_state != PCI_UNKNOWN) {
+		/* Disable PCIe AER on the tg3 to avoid a fatal
+		 * error during this system restart.
+		 */
+		pcie_capability_clear_word(pdev, PCI_EXP_DEVCTL,
+					   PCI_EXP_DEVCTL_CERE |
+					   PCI_EXP_DEVCTL_NFERE |
+					   PCI_EXP_DEVCTL_FERE |
+					   PCI_EXP_DEVCTL_URRE);
+	}
 
 	rtnl_unlock();
 
-- 
2.39.5



