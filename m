Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E642F36A015;
	Tue,  6 Jan 2026 17:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722108; cv=none; b=MzhpmB6r9KksZ6LVXarwfvbjSLMMFVjOQ5jjBRl+5c51FRFyRq+Af4jWjMlnkk5+Z5b4UPwzTDLs0U27lk2+U5bKo3spYIuLW/fUrBweLDW/MKKQERzUQak69uJFHuAKykm81tZMSw2KT+D7CmLBkfsNewdLbmJ/XlQZg1G5mq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722108; c=relaxed/simple;
	bh=pdhT76cYHzdozwqd+8/1d/RQRbRuAOuonSBCVKhSzj8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZC/yovs0IaVE+XugU5bBqO31Hg8RWdo/CxZV9fUbrLS2/86Mw8P9btEIAoRIGLvJkJVJ4R3W94f2IWUDvdvmlCSuomqCWgahDth+r+0omwj3qV4GQAtF39zQ41MzxVuuovPUbdwO4a+TKrh+0+1k67f6G2deEPbNclG5r4Z6YbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wiGXl0hm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wiGXl0hm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F4EDC116C6;
	Tue,  6 Jan 2026 17:55:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767722107;
	bh=pdhT76cYHzdozwqd+8/1d/RQRbRuAOuonSBCVKhSzj8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wiGXl0hmVj8yvEBRBxwtd4TAY7ftKIaKQowInoXJTH7dYB7zDfAkRc0eOYrJ9t/to
	 6nt/6Pk0MGizMB09LnvLEEf2Bz97Tpsk7dMcdpBd7v3ER2sfLy04UpjVf96xfZJaNM
	 KEbv0cgFZ+bCdQi6oQcJg7lMvTU2j6m/d1+6Qzug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linnaea Lavia <linnaea-von-lavia@live.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Neil Armstrong <neil.armstrong@linaro.org>
Subject: [PATCH 6.18 160/312] PCI: meson: Fix parsing the DBI register region
Date: Tue,  6 Jan 2026 18:03:54 +0100
Message-ID: <20260106170553.625490060@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>

commit eff0306b109f2d611e44f0155b0324f6cfec3ef4 upstream.

First of all, the driver was parsing the 'dbi' register region as 'elbi'.
This was due to DT mistakenly passing 'dbi' as 'elbi'. Since the DT is
now fixed to supply 'dbi' region, this driver can rely on the DWC core
driver to parse and map it.

However, to support the old DTs, if the 'elbi' region is found in DT, parse
and map the region as both 'dw_pcie::elbi_base' as 'dw_pcie::dbi_base'.
This will allow the driver to work with both broken and fixed DTs.

Also, skip parsing the 'elbi' region in DWC core if 'pci->elbi_base' was
already populated.

Fixes: 9c0ef6d34fdb ("PCI: amlogic: Add the Amlogic Meson PCIe controller driver")
Fixes: c96992a24bec ("PCI: dwc: Add support for ELBI resource mapping")
Reported-by: Linnaea Lavia <linnaea-von-lavia@live.com>
Closes: https://lore.kernel.org/linux-pci/DM4PR05MB102707B8CDF84D776C39F22F2C7F0A@DM4PR05MB10270.namprd05.prod.outlook.com/
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Tested-by: Neil Armstrong <neil.armstrong@linaro.org> # on Bananapi-M2S
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Cc: stable@vger.kernel.org # 6.2
Link: https://patch.msgid.link/20251101-pci-meson-fix-v1-3-c50dcc56ed6a@oss.qualcomm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/dwc/pci-meson.c       |   18 +++++++++++++++---
 drivers/pci/controller/dwc/pcie-designware.c |   12 +++++++-----
 2 files changed, 22 insertions(+), 8 deletions(-)

--- a/drivers/pci/controller/dwc/pci-meson.c
+++ b/drivers/pci/controller/dwc/pci-meson.c
@@ -108,10 +108,22 @@ static int meson_pcie_get_mems(struct pl
 			       struct meson_pcie *mp)
 {
 	struct dw_pcie *pci = &mp->pci;
+	struct resource *res;
 
-	pci->dbi_base = devm_platform_ioremap_resource_byname(pdev, "elbi");
-	if (IS_ERR(pci->dbi_base))
-		return PTR_ERR(pci->dbi_base);
+	/*
+	 * For the broken DTs that supply 'dbi' as 'elbi', parse the 'elbi'
+	 * region and assign it to both 'pci->elbi_base' and 'pci->dbi_space' so
+	 * that the DWC core can skip parsing both regions.
+	 */
+	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "elbi");
+	if (res) {
+		pci->elbi_base = devm_pci_remap_cfg_resource(pci->dev, res);
+		if (IS_ERR(pci->elbi_base))
+			return PTR_ERR(pci->elbi_base);
+
+		pci->dbi_base = pci->elbi_base;
+		pci->dbi_phys_addr = res->start;
+	}
 
 	mp->cfg_base = devm_platform_ioremap_resource_byname(pdev, "cfg");
 	if (IS_ERR(mp->cfg_base))
--- a/drivers/pci/controller/dwc/pcie-designware.c
+++ b/drivers/pci/controller/dwc/pcie-designware.c
@@ -168,11 +168,13 @@ int dw_pcie_get_resources(struct dw_pcie
 	}
 
 	/* ELBI is an optional resource */
-	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "elbi");
-	if (res) {
-		pci->elbi_base = devm_ioremap_resource(pci->dev, res);
-		if (IS_ERR(pci->elbi_base))
-			return PTR_ERR(pci->elbi_base);
+	if (!pci->elbi_base) {
+		res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "elbi");
+		if (res) {
+			pci->elbi_base = devm_ioremap_resource(pci->dev, res);
+			if (IS_ERR(pci->elbi_base))
+				return PTR_ERR(pci->elbi_base);
+		}
 	}
 
 	/* LLDD is supposed to manually switch the clocks and resets state */


