Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 774813B42C0;
	Wed, 30 Sep 2026 18:52:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794380; cv=none; b=n5RkN35RwHTkCs8GKuSH18F28lHEhPXSXxMGOOUYGK95ypSDeTF6WGJKToEauo0ZA8WLDMYg+ElvlQNkUPYugHCQ0GHnJg1G4Ke5B52dgjVXNEi0D/cnZpXpBZP/krAtbFC3zmi1OEItT2zYbi8dKWHNZ2lWHXpfM4QNDWejsD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794380; c=relaxed/simple;
	bh=kWmK3rq3+yTItz1HdS7sJOO59MfBd3YSbwh0YnlwcAQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=siHqACstBZCT15kBvXZwH11URj3OeW/VQXiggrsKe0eh+ey16LGl/xAC8qdLb9sU8d/0CluIa5H8Ll6Z3yiHjSEPBoHmIZklehmZdeDncJc1GjtcOGsGSUTSaADj4h+SNV5I3vjQff2Lq5ubg+gzukVt5o4jxIvH57H4gRViPPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N+P3Uq/K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N+P3Uq/K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ABAF1F000FF;
	Wed, 30 Sep 2026 18:52:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794379;
	bh=gKzPlvXeMG/jhrO/n4todmMOb5NEh9wSer+eV9AkOLQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N+P3Uq/K4RPs8LiA/9Pz+McAzzshDehZjLYKXq8GLgONeoZihrMzvqERr5rLsEOz3
	 NPDoZWgB+5+qHmtspKtMGniYm9b5AxadVLMud3qtgVNJtvM3N7MYRehOGEH7v/MGnp
	 I99MlTPce1cEtYzeLoQfgUcM3sQt87MjkJ6L9E2g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	liyouhong <liyouhong@kylinos.cn>,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0153/1193] ata: ahci: fail probe if BAR too small for claimed ports
Date: Wed, 30 Sep 2026 17:13:57 +0200
Message-ID: <20260930152437.606924431@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 2d43307eddf95..1a4468a2d02e3 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -1852,6 +1852,24 @@ static ssize_t remapped_nvme_show(struct device *dev,
 
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
@@ -1954,6 +1972,10 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	hpriv->mmio = pcim_iomap_table(pdev)[ahci_pci_bar];
 
+	rc = ahci_validate_bar_size(pdev, ahci_pci_bar, hpriv);
+	if (rc)
+		return rc;
+
 	/* detect remapped nvme devices */
 	ahci_remap_check(pdev, ahci_pci_bar, hpriv);
 
-- 
2.53.0



