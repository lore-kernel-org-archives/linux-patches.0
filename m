Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 330F94EA38C;
	Wed, 30 Sep 2026 15:36:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782575; cv=none; b=SRNVv89sGX9hJQGeHaugfaMB4GCp+4kH0DSFLLFdSMK3DNpwpbDW9t2sIrrWBWg2G8ziY+hWs0VmFHn/IpeAZUhQsovjMSWz/Qs7wjqo3nsQezYek/VclQbcatDrUDNWlcNZGk+7nt0yEYMfhOzbDevXtEs4P68qXxFIoniAoZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782575; c=relaxed/simple;
	bh=kOPevWrzVHvvWMeN+hhmikqTZO4fSXdaJ26TXS6n1io=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PMT5UoZten038hK2KTKdUshNTUw25QKAgb2VXR6i/IyxunW0WTuKFWJQdRhwRiVEjUaRIpxF6v7s72WjaJklz9+JuzEjGQI/0lemAuO2sStWCKt71mBqztOXuvqT+Rgx682f4tYrkxB1OikWkXxp69i5gugco+2xd8mlWw8UD1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q3DBUSgY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q3DBUSgY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE1C71F000FF;
	Wed, 30 Sep 2026 15:36:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790782564;
	bh=qlUozxIvOMNoPlrJk+0w9fpv+/5IlwPsZZY8jlFXRys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q3DBUSgYoMW5w4j7Pgcc78ayi+lSMT3DjcSUfvNHAcjNvY2FL8LXjLUauf8xcRD/J
	 cn1wxwCfv2tDTeqWHqskhVayCK3hSceXvv/fm4MAm5QOMygV+ntG3wHSarQQbH/X3n
	 78NQlMZOPRKF/oh3oUFZAcxRugTRa57HmPQmAUjA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	liyouhong <liyouhong@kylinos.cn>,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 091/595] ata: ahci: fail probe if BAR too small for claimed ports
Date: Wed, 30 Sep 2026 17:19:44 +0200
Message-ID: <20260930152349.695178752@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: liyouhong <liyouhong@kylinos.cn>

[ Upstream commit c4086c6e1af757e1ff26fa2d2926b3ec0195de79 ]

When an AHCI controller is disabled in BIOS, its HOST_CAP register may
contain a bogus value, e.g. 0xFFFFFFFF.

Since CAP.NP (Number of Ports) is a zeroes based 5-bit register field,
a value of 0x1f means 32 ports. If CAP.NP claims more ports than can
physically fit within the mapped BAR region, accessing port registers
beyond the BAR boundary causes a kernel panic.

Add validation in ahci_init_one() to check that the BAR size is
sufficient for the number of ports claimed in CAP.NP. The check
calculates the required MMIO size as:

  required_size = 0x100 (global registers) + max_ports * 0x80

If required_size exceeds the actual BAR size, the probe fails with
-ENODEV, preventing the panic and providing a clear error message.

Reported-by: liyouhong <liyouhong@kylinos.cn>
Closes: https://lore.kernel.org/all/20260422080322.1006592-1-dayou5941@163.com/
Suggested-by: Damien Le Moal <dlemoal@kernel.org>
Suggested-by: Niklas Cassel <cassel@kernel.org>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: liyouhong <liyouhong@kylinos.cn>
[cassel: commit log]
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/ahci.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 48d22150528be..77c2b8b997cd1 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -1768,6 +1768,24 @@ static ssize_t remapped_nvme_show(struct device *dev,
 
 static DEVICE_ATTR_RO(remapped_nvme);
 
+static int ahci_validate_bar_size(struct pci_dev *pdev, int bar,
+				  struct ahci_host_priv *hpriv)
+{
+	u32 cap = readl(hpriv->mmio + HOST_CAP);
+	unsigned int max_ports = ahci_nr_ports(cap);
+	u32 last_port_end = 0x100 + (max_ports * 0x80);
+	resource_size_t bar_size = pci_resource_len(pdev, bar);
+
+	if (last_port_end > bar_size) {
+		dev_warn(&pdev->dev,
+			 "BAR%d too small for %u ports (last port ends at %#x, BAR %pa)\n",
+			 bar, max_ports, last_port_end, &bar_size);
+		return -ENODEV;
+	}
+
+	return 0;
+}
+
 static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	unsigned int board_id = ent->driver_data;
@@ -1872,6 +1890,10 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	hpriv->mmio = pcim_iomap_table(pdev)[ahci_pci_bar];
 
+	rc = ahci_validate_bar_size(pdev, ahci_pci_bar, hpriv);
+	if (rc)
+		return rc;
+
 	/* detect remapped nvme devices */
 	ahci_remap_check(pdev, ahci_pci_bar, hpriv);
 
-- 
2.53.0



