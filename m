Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4F2E524A3;
	Tue, 23 Jan 2024 00:34:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970071; cv=none; b=LoiLbE9Fo75CbXdA+PMLLIqTFuxHTk0/U/cBQMEuWXE1jjWZX9SdDRxHMTvUq4o8Yn+z4vY3uyw2K47hmT3Y4wO71UeljffW28G+DNhXnEEYk/wbzF6jRq2s9DcsFYPl8PiDrP54Q5ON6NEYw7qeUep2TJkBUIgYcTTSK4f0Z9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970071; c=relaxed/simple;
	bh=qCJmQjeOhxh7fuOVfUb9OCjYQCXTnBj8CoC0OjdBPkw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Wnh7TSSYjnsLfS3nQmE6JsBF7cThaZF8tmheaF2cLIKGaKwqAPTF7E9y2Q9JP9foOeyQr3kqwo352rtokBN5pJYqK9CIKclgtKbb/eThHDg/yzoAHq4fyda09PIezpRB2YkJJrCO2/lydSm7mdOZg09lbVBuSOQxmYDcYKsluOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UlvHiZTW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UlvHiZTW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4346CC433F1;
	Tue, 23 Jan 2024 00:34:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970071;
	bh=qCJmQjeOhxh7fuOVfUb9OCjYQCXTnBj8CoC0OjdBPkw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UlvHiZTWAzPA8ZPoyC54NrTJejVU9QR6KRhaodIRAIK5AWX99+fkehEUgWMc0th+W
	 iMZCSlZdW9YzyQhTkH+tDciZz2waF9w4fJ+ZMWRuIwqGxEzVxZkcakDBDEvDODiX0w
	 qR7QqeNMjHQaDz/64WD2BROh4zUogjnkd/+O6Qj0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianjun Wang <jianjun.wang@mediatek.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 578/641] PCI: mediatek-gen3: Fix translation window size calculation
Date: Mon, 22 Jan 2024 15:58:02 -0800
Message-ID: <20240122235836.264674849@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jianjun Wang <jianjun.wang@mediatek.com>

[ Upstream commit 9ccc1318cf4bd90601f221268e42c3374703d681 ]

When using the fls() helper, the translation table should be a power of
two; otherwise, the resulting value will not be correct.

For example, given fls(0x3e00000) - 1 = 25, the PCIe translation window
size will be set to 0x2000000 instead of the expected size 0x3e00000.

Fix the translation window by splitting the MMIO space into multiple tables
if its size is not a power of two.

[kwilczynski: commit log]
Link: https://lore.kernel.org/linux-pci/20231023081423.18559-1-jianjun.wang@mediatek.com
Fixes: d3bf75b579b9 ("PCI: mediatek-gen3: Add MediaTek Gen3 driver for MT8192")
Signed-off-by: Jianjun Wang <jianjun.wang@mediatek.com>
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pcie-mediatek-gen3.c | 85 ++++++++++++---------
 1 file changed, 50 insertions(+), 35 deletions(-)

diff --git a/drivers/pci/controller/pcie-mediatek-gen3.c b/drivers/pci/controller/pcie-mediatek-gen3.c
index e0e27645fdf4..975b3024fb08 100644
--- a/drivers/pci/controller/pcie-mediatek-gen3.c
+++ b/drivers/pci/controller/pcie-mediatek-gen3.c
@@ -245,35 +245,60 @@ static int mtk_pcie_set_trans_table(struct mtk_gen3_pcie *pcie,
 				    resource_size_t cpu_addr,
 				    resource_size_t pci_addr,
 				    resource_size_t size,
-				    unsigned long type, int num)
+				    unsigned long type, int *num)
 {
+	resource_size_t remaining = size;
+	resource_size_t table_size;
+	resource_size_t addr_align;
+	const char *range_type;
 	void __iomem *table;
 	u32 val;
 
-	if (num >= PCIE_MAX_TRANS_TABLES) {
-		dev_err(pcie->dev, "not enough translate table for addr: %#llx, limited to [%d]\n",
-			(unsigned long long)cpu_addr, PCIE_MAX_TRANS_TABLES);
-		return -ENODEV;
-	}
+	while (remaining && (*num < PCIE_MAX_TRANS_TABLES)) {
+		/* Table size needs to be a power of 2 */
+		table_size = BIT(fls(remaining) - 1);
+
+		if (cpu_addr > 0) {
+			addr_align = BIT(ffs(cpu_addr) - 1);
+			table_size = min(table_size, addr_align);
+		}
+
+		/* Minimum size of translate table is 4KiB */
+		if (table_size < 0x1000) {
+			dev_err(pcie->dev, "illegal table size %#llx\n",
+				(unsigned long long)table_size);
+			return -EINVAL;
+		}
 
-	table = pcie->base + PCIE_TRANS_TABLE_BASE_REG +
-		num * PCIE_ATR_TLB_SET_OFFSET;
+		table = pcie->base + PCIE_TRANS_TABLE_BASE_REG + *num * PCIE_ATR_TLB_SET_OFFSET;
+		writel_relaxed(lower_32_bits(cpu_addr) | PCIE_ATR_SIZE(fls(table_size) - 1), table);
+		writel_relaxed(upper_32_bits(cpu_addr), table + PCIE_ATR_SRC_ADDR_MSB_OFFSET);
+		writel_relaxed(lower_32_bits(pci_addr), table + PCIE_ATR_TRSL_ADDR_LSB_OFFSET);
+		writel_relaxed(upper_32_bits(pci_addr), table + PCIE_ATR_TRSL_ADDR_MSB_OFFSET);
 
-	writel_relaxed(lower_32_bits(cpu_addr) | PCIE_ATR_SIZE(fls(size) - 1),
-		       table);
-	writel_relaxed(upper_32_bits(cpu_addr),
-		       table + PCIE_ATR_SRC_ADDR_MSB_OFFSET);
-	writel_relaxed(lower_32_bits(pci_addr),
-		       table + PCIE_ATR_TRSL_ADDR_LSB_OFFSET);
-	writel_relaxed(upper_32_bits(pci_addr),
-		       table + PCIE_ATR_TRSL_ADDR_MSB_OFFSET);
+		if (type == IORESOURCE_IO) {
+			val = PCIE_ATR_TYPE_IO | PCIE_ATR_TLP_TYPE_IO;
+			range_type = "IO";
+		} else {
+			val = PCIE_ATR_TYPE_MEM | PCIE_ATR_TLP_TYPE_MEM;
+			range_type = "MEM";
+		}
 
-	if (type == IORESOURCE_IO)
-		val = PCIE_ATR_TYPE_IO | PCIE_ATR_TLP_TYPE_IO;
-	else
-		val = PCIE_ATR_TYPE_MEM | PCIE_ATR_TLP_TYPE_MEM;
+		writel_relaxed(val, table + PCIE_ATR_TRSL_PARAM_OFFSET);
 
-	writel_relaxed(val, table + PCIE_ATR_TRSL_PARAM_OFFSET);
+		dev_dbg(pcie->dev, "set %s trans window[%d]: cpu_addr = %#llx, pci_addr = %#llx, size = %#llx\n",
+			range_type, *num, (unsigned long long)cpu_addr,
+			(unsigned long long)pci_addr, (unsigned long long)table_size);
+
+		cpu_addr += table_size;
+		pci_addr += table_size;
+		remaining -= table_size;
+		(*num)++;
+	}
+
+	if (remaining)
+		dev_warn(pcie->dev, "not enough translate table for addr: %#llx, limited to [%d]\n",
+			 (unsigned long long)cpu_addr, PCIE_MAX_TRANS_TABLES);
 
 	return 0;
 }
@@ -380,30 +405,20 @@ static int mtk_pcie_startup_port(struct mtk_gen3_pcie *pcie)
 		resource_size_t cpu_addr;
 		resource_size_t pci_addr;
 		resource_size_t size;
-		const char *range_type;
 
-		if (type == IORESOURCE_IO) {
+		if (type == IORESOURCE_IO)
 			cpu_addr = pci_pio_to_address(res->start);
-			range_type = "IO";
-		} else if (type == IORESOURCE_MEM) {
+		else if (type == IORESOURCE_MEM)
 			cpu_addr = res->start;
-			range_type = "MEM";
-		} else {
+		else
 			continue;
-		}
 
 		pci_addr = res->start - entry->offset;
 		size = resource_size(res);
 		err = mtk_pcie_set_trans_table(pcie, cpu_addr, pci_addr, size,
-					       type, table_index);
+					       type, &table_index);
 		if (err)
 			return err;
-
-		dev_dbg(pcie->dev, "set %s trans window[%d]: cpu_addr = %#llx, pci_addr = %#llx, size = %#llx\n",
-			range_type, table_index, (unsigned long long)cpu_addr,
-			(unsigned long long)pci_addr, (unsigned long long)size);
-
-		table_index++;
 	}
 
 	return 0;
-- 
2.43.0



