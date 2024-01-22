Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFE921851;
	Tue, 23 Jan 2024 02:09:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975760; cv=none; b=hKYfARK1yDXlfZ60pK4eZKs2zmMUMv1KZbAdqzTLz/1Kuv32+1+/dhYT78eYP+HDtlWf//HMssktnMhRak00Yv5o7gDgqvopLuW1UCZXQEQs4MhZacSH+t5HZ/KJ6zk7OmhawooL35os9b2fWoMGiO8ZsJgLWqAwRdEqrhszzXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975760; c=relaxed/simple;
	bh=Q+1tNZrqjh59qBc/yCNR8zAd2sSZPf5N581f1u3viYo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qr+PEtBo44tA3qE2FyWIa2eL1a8iKGow7qyB4aAbDhIPSPnzoHPr1o/ql87rFAFOdSEraKzOvzubvIcliKvCWTSvoCWiVV93s1zjDMR6TTiSs0yFC7kijqvZvFOG9sVeY1Rv90Hl4hM8jcAMtVLFhuv18o9Q+6DWxDScWxE2Y7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GaDLSZPP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GaDLSZPP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75EA7C43390;
	Tue, 23 Jan 2024 02:09:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975760;
	bh=Q+1tNZrqjh59qBc/yCNR8zAd2sSZPf5N581f1u3viYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GaDLSZPP8OfA9jw4SIobujlga8QRctWK/b3HAVtD6MO9lWMjaS6scZfPcRsYAKYYX
	 PtjUKPobpXc/gZIKtHWHSpOnYF+5aEW1GnMm2RznmNoKktaf1pOUIkYAMy/FRhP6N6
	 4D/f80xbSFhPSl4IpmTwAUFzj+6mf7a1Qav1gF4w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Siddharth Vadapalli <s-vadapalli@ti.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Ravi Gunasekaran <r-gunasekaran@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 520/583] PCI: keystone: Fix race condition when initializing PHYs
Date: Mon, 22 Jan 2024 15:59:31 -0800
Message-ID: <20240122235827.986452344@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Siddharth Vadapalli <s-vadapalli@ti.com>

[ Upstream commit c12ca110c613a81cb0f0099019c839d078cd0f38 ]

The PCI driver invokes the PHY APIs using the ks_pcie_enable_phy()
function. The PHY in this case is the Serdes. It is possible that the
PCI instance is configured for two lane operation across two different
Serdes instances, using one lane of each Serdes.

In such a configuration, if the reference clock for one Serdes is
provided by the other Serdes, it results in a race condition. After the
Serdes providing the reference clock is initialized by the PCI driver by
invoking its PHY APIs, it is not guaranteed that this Serdes remains
powered on long enough for the PHY APIs based initialization of the
dependent Serdes. In such cases, the PLL of the dependent Serdes fails
to lock due to the absence of the reference clock from the former Serdes
which has been powered off by the PM Core.

Fix this by obtaining reference to the PHYs before invoking the PHY
initialization APIs and releasing reference after the initialization is
complete.

Link: https://lore.kernel.org/linux-pci/20230927041845.1222080-1-s-vadapalli@ti.com
Fixes: 49229238ab47 ("PCI: keystone: Cleanup PHY handling")
Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Acked-by: Ravi Gunasekaran <r-gunasekaran@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pci-keystone.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/pci/controller/dwc/pci-keystone.c b/drivers/pci/controller/dwc/pci-keystone.c
index 0def919f89fa..cf3836561316 100644
--- a/drivers/pci/controller/dwc/pci-keystone.c
+++ b/drivers/pci/controller/dwc/pci-keystone.c
@@ -1218,7 +1218,16 @@ static int ks_pcie_probe(struct platform_device *pdev)
 		goto err_link;
 	}
 
+	/* Obtain references to the PHYs */
+	for (i = 0; i < num_lanes; i++)
+		phy_pm_runtime_get_sync(ks_pcie->phy[i]);
+
 	ret = ks_pcie_enable_phy(ks_pcie);
+
+	/* Release references to the PHYs */
+	for (i = 0; i < num_lanes; i++)
+		phy_pm_runtime_put_sync(ks_pcie->phy[i]);
+
 	if (ret) {
 		dev_err(dev, "failed to enable phy\n");
 		goto err_link;
-- 
2.43.0



