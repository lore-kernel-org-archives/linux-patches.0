Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AEAE1AA793;
	Mon, 14 Oct 2024 14:37:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916656; cv=none; b=kd1KetvZgOx0Jyzh2/o8qsoYWdgsm86bG/RaYsN0LkkWuXgxtBvtVHAmjsRoEb6x1w5DL9TEmUA2VRT/qqzRArPgy1+xiQe07h30bjC71X5vf2CQdjeUNecGrQlIWVoQ5pzYRa5fb+/XOYQ+9hVQPrCTx5xMasxTrZJ6e+1wTj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916656; c=relaxed/simple;
	bh=vo7dbB0+z/XMhgwXmdR65/ipNRf3MXi3WxtS8LX/p/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EOSDsguHXgAZQUlobApvv3Ag9AOdz3XoeUntDQiandH6piq4Q0sv/TUMWVSgBz63PJwLtMpljrRLo6xxR5gpzeXXgPymr01tkr5kjAntuIGiKO7KqU94/qJX6xvFYu+3uuFXjFMXYvglT1xmCrwM1A6HbmdjcY7AYcSEZzWs8pA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b5wO/f7v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b5wO/f7v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC0BFC4CEC3;
	Mon, 14 Oct 2024 14:37:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916656;
	bh=vo7dbB0+z/XMhgwXmdR65/ipNRf3MXi3WxtS8LX/p/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b5wO/f7vs1fyR6FwcdbrLeDKqpUUKHP2Get0jl1dQ1FcD3M4vav+svWU0FJ8OG80A
	 4y5/LV1xZCE5cTSl8i2VyXfOEGHzibO7BDJ1vXhs3M+6s++W1Tl2dDkf9wqMbho3cd
	 +6Wk6SoYEoVe4OjHC97jmXeohSQAJTTZMVY4hR/k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 028/213] ata: ahci: Add mask_port_map module parameter
Date: Mon, 14 Oct 2024 16:18:54 +0200
Message-ID: <20241014141044.085469616@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141042.954319779@linuxfoundation.org>
References: <20241014141042.954319779@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Damien Le Moal <dlemoal@kernel.org>

[ Upstream commit 24cfd86433c920188ac3f02df8aba6bc4c792f4b ]

Commits 0077a504e1a4 ("ahci: asm1166: correct count of reported ports")
and 9815e3961754 ("ahci: asm1064: correct count of reported ports")
attempted to limit the ports of the ASM1166 and ASM1064 AHCI controllers
to avoid long boot times caused by the fact that these adapters report
a port map larger than the number of physical ports. The excess ports
are "virtual" to hide port multiplier devices and probing these ports
takes time. However, these commits caused a regression for users that do
use PMP devices, as the ATA devices connected to the PMP cannot be
scanned. These commits have thus been reverted by commit 6cd8adc3e18
("ahci: asm1064: asm1166: don't limit reported ports") to allow the
discovery of devices connected through a port multiplier. But this
revert re-introduced the long boot times for users that do not use a
port multiplier setup.

This patch adds the mask_port_map ahci module parameter to allow users
to manually specify port map masks for controllers. In the case of the
ASMedia 1166 and 1064 controllers, users that do not have port
multiplier devices can mask the excess virtual ports exposed by the
controller to speedup port scanning, thus reducing boot time.

The mask_port_map parameter accepts 2 different formats:
 - mask_port_map=<mask>
   This applies the same mask to all AHCI controllers
   present in the system. This format is convenient for small systems
   that have only a single AHCI controller.
 - mask_port_map=<pci_dev>=<mask>,<pci_dev>=mask,...
   This applies the specified masks only to the PCI device listed. The
   <pci_dev> field is a regular PCI device ID (domain:bus:dev.func).
   This ID can be seen following "ahci" in the kernel messages. E.g.
   for "ahci 0000:01:00.0: 2/2 ports implemented (port mask 0x3)", the
   <pci_dev> field is "0000:01:00.0".

When used, the function ahci_save_initial_config() indicates that a
port map mask was applied with the message "masking port_map ...".
E.g.: without a mask:
modprobe ahci
dmesg | grep ahci
...
ahci 0000:00:17.0: AHCI vers 0001.0301, 32 command slots, 6 Gbps, SATA mode
ahci 0000:00:17.0: (0000:00:17.0) 8/8 ports implemented (port mask 0xff)

With a mask:
modprobe ahci mask_port_map=0000:00:17.0=0x1
dmesg | grep ahci
...
ahci 0000:00:17.0: masking port_map 0xff -> 0x1
ahci 0000:00:17.0: AHCI vers 0001.0301, 32 command slots, 6 Gbps, SATA mode
ahci 0000:00:17.0: (0000:00:17.0) 1/8 ports implemented (port mask 0x1)

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/ahci.c | 85 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 85 insertions(+)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 0a6aea36cd975..6e76780fb4308 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -667,6 +667,87 @@ static int mobile_lpm_policy = -1;
 module_param(mobile_lpm_policy, int, 0644);
 MODULE_PARM_DESC(mobile_lpm_policy, "Default LPM policy for mobile chipsets");
 
+static char *ahci_mask_port_map;
+module_param_named(mask_port_map, ahci_mask_port_map, charp, 0444);
+MODULE_PARM_DESC(mask_port_map,
+		 "32-bits port map masks to ignore controllers ports. "
+		 "Valid values are: "
+		 "\"<mask>\" to apply the same mask to all AHCI controller "
+		 "devices, and \"<pci_dev>=<mask>,<pci_dev>=<mask>,...\" to "
+		 "specify different masks for the controllers specified, "
+		 "where <pci_dev> is the PCI ID of an AHCI controller in the "
+		 "form \"domain:bus:dev.func\"");
+
+static void ahci_apply_port_map_mask(struct device *dev,
+				     struct ahci_host_priv *hpriv, char *mask_s)
+{
+	unsigned int mask;
+
+	if (kstrtouint(mask_s, 0, &mask)) {
+		dev_err(dev, "Invalid port map mask\n");
+		return;
+	}
+
+	hpriv->mask_port_map = mask;
+}
+
+static void ahci_get_port_map_mask(struct device *dev,
+				   struct ahci_host_priv *hpriv)
+{
+	char *param, *end, *str, *mask_s;
+	char *name;
+
+	if (!strlen(ahci_mask_port_map))
+		return;
+
+	str = kstrdup(ahci_mask_port_map, GFP_KERNEL);
+	if (!str)
+		return;
+
+	/* Handle single mask case */
+	if (!strchr(str, '=')) {
+		ahci_apply_port_map_mask(dev, hpriv, str);
+		goto free;
+	}
+
+	/*
+	 * Mask list case: parse the parameter to apply the mask only if
+	 * the device name matches.
+	 */
+	param = str;
+	end = param + strlen(param);
+	while (param && param < end && *param) {
+		name = param;
+		param = strchr(name, '=');
+		if (!param)
+			break;
+
+		*param = '\0';
+		param++;
+		if (param >= end)
+			break;
+
+		if (strcmp(dev_name(dev), name) != 0) {
+			param = strchr(param, ',');
+			if (param)
+				param++;
+			continue;
+		}
+
+		mask_s = param;
+		param = strchr(mask_s, ',');
+		if (param) {
+			*param = '\0';
+			param++;
+		}
+
+		ahci_apply_port_map_mask(dev, hpriv, mask_s);
+	}
+
+free:
+	kfree(str);
+}
+
 static void ahci_pci_save_initial_config(struct pci_dev *pdev,
 					 struct ahci_host_priv *hpriv)
 {
@@ -689,6 +770,10 @@ static void ahci_pci_save_initial_config(struct pci_dev *pdev,
 			  "Disabling your PATA port. Use the boot option 'ahci.marvell_enable=0' to avoid this.\n");
 	}
 
+	/* Handle port map masks passed as module parameter. */
+	if (ahci_mask_port_map)
+		ahci_get_port_map_mask(&pdev->dev, hpriv);
+
 	ahci_save_initial_config(&pdev->dev, hpriv);
 }
 
-- 
2.43.0



