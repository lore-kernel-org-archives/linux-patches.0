Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F29A93B3C03;
	Wed, 30 Sep 2026 17:54:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790868; cv=none; b=jvKVktVw87kKNL3HZI+T9XzxcUjyo947zNoSgwep0GCIYyqF3fLZHTxy0pV/cGFQHqKnWYKm4yitekjTPGjCw7CaGUxXLigXMMDYeKpC7YY+nq15zFZD/1GN6p9jWy/lQ7HRPO/uvbVMRdzbvLf0bVkhiJqdlPC8NldczNlrfak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790868; c=relaxed/simple;
	bh=ks4cSHqmMgFUiS26Rez6TPth0GJfCz/4G0t154aPzoo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NEDvh4j/bxIZbgfymkqtrXGGgaZfe5yW+J55/N6TR8xuScI0Rvu3mpE9DiCHFN/BV9ZLwLNjWYlSPP4bIAVf+JthQ2+RN+yBMh6nueFbqCf++vR67RbeCD58dSWkQXCBLY0SOf4SaBSX6+dPM7dKtlimIOzrBDQO3Ve9GvURFvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fqdh5UBy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fqdh5UBy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57A1B1F00898;
	Wed, 30 Sep 2026 17:54:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790866;
	bh=xcUr4ZnZ+eA9RMRpPOD+GncblmuNyI6egqAkJp9NS8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fqdh5UBybXTJQq5sP0tVvAP+dxN2T/baUtSFjzZcyWKwsG9h/okuR2qyEpobQV1g9
	 LyFHxBcSpiXwRRF4E0NG68FRbx0xP3nUcfDX48TBB0VgLmDqhF/D8LatCqkm4PW6Mx
	 9aZYwayZSrjChcnySY6Mz3vPwKT/YuIXm/yVjue0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	liyouhong <liyouhong@kylinos.cn>,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 102/752] ata: ahci: fail probe if BAR too small for claimed ports
Date: Wed, 30 Sep 2026 17:19:32 +0200
Message-ID: <20260930152400.374028346@linuxfoundation.org>
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
index c3a9264ed77c2..93dbdbea3a1ac 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -1772,6 +1772,24 @@ static ssize_t remapped_nvme_show(struct device *dev,
 
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
@@ -1876,6 +1894,10 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	hpriv->mmio = pcim_iomap_table(pdev)[ahci_pci_bar];
 
+	rc = ahci_validate_bar_size(pdev, ahci_pci_bar, hpriv);
+	if (rc)
+		return rc;
+
 	/* detect remapped nvme devices */
 	ahci_remap_check(pdev, ahci_pci_bar, hpriv);
 
-- 
2.53.0



