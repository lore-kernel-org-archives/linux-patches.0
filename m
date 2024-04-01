Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36C5B1C0DE7;
	Mon,  1 Apr 2024 17:01:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990889; cv=none; b=C9X5We5/yRjAZlDFRZShACgaNhdKYqxL/+J7oECaiwt5zrPKpLdMT2fd/xWwgeGSviR4YccOQdNr6t0kBmolRRa6vlZeZjwoCxyzi6ajqZql1SEeX6OWJ6CK+FNFgQxO7QI05D3cz0w+fNM1bq/8xeQxDwn3Z1CcDxyC5xX0lQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990889; c=relaxed/simple;
	bh=W99kC0BLR4IVHFFgTwgMRw5MMdx5XrjJB+P3u2U/Kj0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RT6Gvu6FNzyMysWYTuCAurqObKGtwHgp24pD/dKTElX1Cg7IlvpQqEQjLlI5H3N3rj6KqAtxLC1D+cT+XaLtDFQmdpvkTOiQh5ytvpuH7fqu33RAzt82SfA31VJ+a9ugVyJECJdtmvIWGbhcVELjq+gLwO8q6xYQ5n43HfIEyOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0gdLQjVy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0gdLQjVy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B30FEC433F1;
	Mon,  1 Apr 2024 17:01:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990889;
	bh=W99kC0BLR4IVHFFgTwgMRw5MMdx5XrjJB+P3u2U/Kj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0gdLQjVydERiGP15cp1BVqf/E8fPCylJzEP6Nn/HR/98KK0pcUXV198dBYNS18KSD
	 yEof8j4F8/+0JnL/hPsh5834fm/7RUpJITT2P++b8D9dOuWx8UyVAWBVyHT7N/tOH7
	 NuQjhdOK6fXH9oCCgA9vtkTXJeF0HYYcdoJlpjPg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 098/272] PCI: qcom: Enable BDF to SID translation properly
Date: Mon,  1 Apr 2024 17:44:48 +0200
Message-ID: <20240401152533.687772574@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

[ Upstream commit bf79e33cdd89db498e00a6131e937259de5f2705 ]

Qcom SoCs making use of ARM SMMU require BDF to SID translation table in
the driver to properly map the SID for the PCIe devices based on their BDF
identifier. This is currently achieved with the help of
qcom_pcie_config_sid_1_9_0() function for SoCs supporting the 1_9_0 config.

But With newer Qcom SoCs starting from SM8450, BDF to SID translation is
set to bypass mode by default in hardware. Due to this, the translation
table that is set in the qcom_pcie_config_sid_1_9_0() is essentially
unused and the default SID is used for all endpoints in SoCs starting from
SM8450.

This is a security concern and also warrants swapping the DeviceID in DT
while using the GIC ITS to handle MSIs from endpoints. The swapping is
currently done like below in DT when using GIC ITS:

      /*
	* MSIs for BDF (1:0.0) only works with Device ID 0x5980.
	* Hence, the IDs are swapped.
	*/
      msi-map = <0x0 &gic_its 0x5981 0x1>,
		<0x100 &gic_its 0x5980 0x1>;

Here, swapping of the DeviceIDs ensure that the endpoint with BDF (1:0.0)
gets the DeviceID 0x5980 which is associated with the default SID as per
the iommu mapping in DT. So MSIs were delivered with IDs swapped so far.
But this also means the Root Port (0:0.0) won't receive any MSIs (for PME,
AER etc...)

So let's fix these issues by clearing the BDF to SID bypass mode for all
SoCs making use of the 1_9_0 config. This allows the PCIe devices to use
the correct SID, thus avoiding the DeviceID swapping hack in DT and also
achieving the isolation between devices.

Fixes: 4c9398822106 ("PCI: qcom: Add support for configuring BDF to SID mapping for SM8250")
Link: https://lore.kernel.org/linux-pci/20240307-pci-bdf-sid-fix-v1-1-9423a7e2d63c@linaro.org
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Cc: stable@vger.kernel.org # 5.11
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-qcom.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/pci/controller/dwc/pcie-qcom.c b/drivers/pci/controller/dwc/pcie-qcom.c
index 9202d2395b507..0bad23ec53ee8 100644
--- a/drivers/pci/controller/dwc/pcie-qcom.c
+++ b/drivers/pci/controller/dwc/pcie-qcom.c
@@ -50,6 +50,7 @@
 #define PARF_SLV_ADDR_SPACE_SIZE		0x358
 #define PARF_DEVICE_TYPE			0x1000
 #define PARF_BDF_TO_SID_TABLE_N			0x2000
+#define PARF_BDF_TO_SID_CFG			0x2c00
 
 /* ELBI registers */
 #define ELBI_SYS_CTRL				0x04
@@ -102,6 +103,9 @@
 /* PARF_DEVICE_TYPE register fields */
 #define DEVICE_TYPE_RC				0x4
 
+/* PARF_BDF_TO_SID_CFG fields */
+#define BDF_TO_SID_BYPASS			BIT(0)
+
 /* ELBI_SYS_CTRL register fields */
 #define ELBI_SYS_CTRL_LT_ENABLE			BIT(0)
 
@@ -1326,11 +1330,17 @@ static int qcom_pcie_config_sid_1_9_0(struct qcom_pcie *pcie)
 	u8 qcom_pcie_crc8_table[CRC8_TABLE_SIZE];
 	int i, nr_map, size = 0;
 	u32 smmu_sid_base;
+	u32 val;
 
 	of_get_property(dev->of_node, "iommu-map", &size);
 	if (!size)
 		return 0;
 
+	/* Enable BDF to SID translation by disabling bypass mode (default) */
+	val = readl(pcie->parf + PARF_BDF_TO_SID_CFG);
+	val &= ~BDF_TO_SID_BYPASS;
+	writel(val, pcie->parf + PARF_BDF_TO_SID_CFG);
+
 	map = kzalloc(size, GFP_KERNEL);
 	if (!map)
 		return -ENOMEM;
-- 
2.43.0



