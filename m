Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46AFA4EDCBB;
	Thu, 17 Sep 2026 17:56:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667764; cv=none; b=paohRpG5NKNMMo+s+vg3HwfiaRhtlXV7r1bpq2/Q0ODa7z7nXZkx+eGPjyWPkPMelIzBOoKMXlZNm/X4sWJ9E8VyWk29onwCyLuOe1cROFdFI+Aap9IL746O7/RjXkVU9VtZ/OVkVxmRsj7OrWJWh7V1aZRPzaaWwGwq58MsYS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667764; c=relaxed/simple;
	bh=Nq2naSNCmVQ/i6r33D/gecYM0Yr/2xCoMY3MvCSjoOI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xp3rUDL/7ozym8czqEHL/u/90q/kBD6ZUHlqWiEIvMHussEQlPo2cpFaED2kAPDoMGfTEnV1L11lYWwzHr7mYQXyC28KDUVWrdzBpHU0+EEVovvkxwnofZkS4FUPXmza/plExd7krJ9/1Of2ghsrFmTUh2mu/Nzorbm0KmYw8Cw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RUK6xT6z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RUK6xT6z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98AD91F000FF;
	Thu, 17 Sep 2026 17:56:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667763;
	bh=b8zBi7l4Y3caHEGMyAzWOVLka/iiFq51g00cYWP/bl4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RUK6xT6zKrngL6UxJfXFFu4F4eml8JZqNMn65YvZJAQykTJZivaFwNYhgufWlgNvY
	 2Vp49nJiVz4shp4HRd0dLH/DQXJhhE7vUv6aDn8DVk9f1eSMHgXNg7RwWA6AvRAwfD
	 E+f4FH8pzRHcmOE//R3EAtArbXm3rX0SHTwSdBmI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	liyouhong <liyouhong@kylinos.cn>,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0200/1102] ata: ahci: fail probe if BAR too small for claimed ports
Date: Thu, 17 Sep 2026 16:02:23 +0100
Message-ID: <20260917151544.594643651@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index e12d89765502e..85b7bd605d7d8 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -1910,6 +1910,24 @@ static ssize_t remapped_nvme_show(struct device *dev,
 
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
@@ -2012,6 +2030,10 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	hpriv->mmio = pcim_iomap_table(pdev)[ahci_pci_bar];
 
+	rc = ahci_validate_bar_size(pdev, ahci_pci_bar, hpriv);
+	if (rc)
+		return rc;
+
 	/* detect remapped nvme devices */
 	ahci_remap_check(pdev, ahci_pci_bar, hpriv);
 
-- 
2.53.0



