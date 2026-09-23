Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62E6E521219;
	Wed, 23 Sep 2026 14:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173442; cv=none; b=qQdCQH926avxW6usSNWJ4T1t+l5xdD05oorxQhOTOnTtIJtcMOG1qgOdhUScZhfSpl7E6MEm75XKBV0L7w+rH+Cdi0hUQUJih2GjrGQgVIS2bTe6yrAPksPfMSaA4ELlhlsMWRn6lLBi0gw9ieSOu0mH1sqMhFMRnweV6eRrCgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173442; c=relaxed/simple;
	bh=jsdToiUQAfgqBEruSVVx9sUgmhZiHJ2BzpE7nC0U68w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bAhKvSgHSMXHeY+/nMuKgX/9tFarLULpv51+FSfo5wK+DS/M9utY+Pa7rvTvX4DrWmMtrmwaCu/lTXWJGB9G7hAvkN95OLtBqx7KfpyG40pn7XSFrfwdyxr7BjxpM3uJ+B4qzY+JSTl9Ku6rZFShiy1B5WozpYXx7Keo0VuI/MA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kqoF1Ewn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kqoF1Ewn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B75371F000FF;
	Wed, 23 Sep 2026 14:24:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173441;
	bh=83OP6BYo8ZC7D0H0qelLEzpyW5GnAixGuxDT8iCyhl4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kqoF1Ewn0C/oJMBZ2O1WfxQ4utsUxyrIyKfv5vh2ZfBfxq6nHnv1zv3UtsMFKzEbr
	 CkjoEg+GF5j14R3r8aN9GcOi6RAlnOyr0jGqiy0WqlD3JwPalfFCGD3tShPqWvOCPf
	 D1pXO+HGJUjzAIP8y3TzRF25XYCyXTnjm++GXlBM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leonardo Costa <leoreis.costa@gmail.com>,
	Franz Schnyder <fra.schnyder@gmail.com>,
	Richard Zhu <hongxing.zhu@nxp.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 7.2 247/438] PCI: imx6: Move clock enable after core reset assertion
Date: Wed, 23 Sep 2026 16:04:28 +0200
Message-ID: <20260923140651.172630144@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Zhu <hongxing.zhu@nxp.com>

commit c9dc7d730319ad64b51570c5387f1fee7b07b510 upstream.

Commit 610fa91d9863 ("PCI: imx6: Assert PERST# before enabling regulators")
inadvertently moved clock enablement before core reset assertion, breaking
PCI device initialization on i.MX6Q Apalis platforms with
ASM1061/ASM1062 SATA controllers connected:

  imx6q-pcie 1ffc000.pcie: host bridge /soc/pcie@1ffc000 ranges:
  imx6q-pcie 1ffc000.pcie:       IO 0x0001f80000..0x0001f8ffff -> 0x0000000000
  imx6q-pcie 1ffc000.pcie:      MEM 0x0001000000..0x0001efffff -> 0x0001000000
  imx6q-pcie 1ffc000.pcie: config reg[1] 0x01f00000 == cpu 0x01f00000
  imx6q-pcie 1ffc000.pcie: iATU: unroll F, 4 ob, 4 ib, align 64K, limit 4G
  imx6q-pcie 1ffc000.pcie: Link: Only Gen1 is enabled
  imx6q-pcie 1ffc000.pcie: Link failed to come up. LTSSM: POLL_CONFIG
  imx6q-pcie 1ffc000.pcie: probe with driver imx6q-pcie failed with error -110

NOTE: It is not 100% clear if the issue is specific to the ASM1061/ASM1062
device or on the specific power-up sequence (reset vs cold-power-on).

To fix this regression, restore the original sequence where clocks are
enabled after asserting core reset and configuring the controller type.

Fixes: 610fa91d9863 ("PCI: imx6: Assert PERST# before enabling regulators")
Reported-by: Leonardo Costa <leoreis.costa@gmail.com>
Closes: https://lore.kernel.org/all/bl7i3obu2clzsgeoct2a4mtfhv6typcjdqmgneropf3hpgwve6@n2m5uhlduw57/T/#u
Reported-by: Franz Schnyder <fra.schnyder@gmail.com>
Closes: https://lore.kernel.org/all/t65y5d54axtksbfs7r4olcefqhwm6m4dz3njgnrnf7fcotj74i@o7avoznlafbj/
Signed-off-by: Richard Zhu <hongxing.zhu@nxp.com>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
[bhelgaas: move to pci/for-linus for v7.3]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: stable@vger.kernel.org # 7.2+
Link: https://patch.msgid.link/20260813095003.356062-1-hongxing.zhu@oss.nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/dwc/pci-imx6.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/pci/controller/dwc/pci-imx6.c
+++ b/drivers/pci/controller/dwc/pci-imx6.c
@@ -1388,12 +1388,6 @@ static int imx_pcie_host_init(struct dw_
 		goto err_pwrctrl_destroy;
 	}
 
-	ret = imx_pcie_clk_enable(imx_pcie);
-	if (ret) {
-		dev_err(dev, "unable to enable pcie clocks: %d\n", ret);
-		goto err_pwrctrl_power_off;
-	}
-
 	if (pp->bridge && imx_check_flag(imx_pcie, IMX_PCIE_FLAG_HAS_LUT)) {
 		pp->bridge->enable_device = imx_pcie_enable_device;
 		pp->bridge->disable_device = imx_pcie_disable_device;
@@ -1409,6 +1403,12 @@ static int imx_pcie_host_init(struct dw_
 
 	imx_pcie_configure_type(imx_pcie);
 
+	ret = imx_pcie_clk_enable(imx_pcie);
+	if (ret) {
+		dev_err(dev, "unable to enable pcie clocks: %d\n", ret);
+		goto err_pwrctrl_power_off;
+	}
+
 	if (imx_pcie->phy) {
 		ret = phy_init(imx_pcie->phy);
 		if (ret) {


