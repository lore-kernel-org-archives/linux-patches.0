Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDA9613473B;
	Tue, 23 Jan 2024 01:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971919; cv=none; b=DTW5SdfOx4dUWnyD1/mvwrLw6FirAle4o8E7YyBsPQt1ajctsba7xavFuL7T0ZGwUI0JRwh+fWQpG9UTGLxt7SBMeMR0FBc+OKHJmYz6FWElLni5JtIny0Z4bx3zdBs4jmwSVbSW4+4iXhucLJoaaMap0b5C8jokIz3rhYxqApo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971919; c=relaxed/simple;
	bh=gOTRJQXL+mxmJL2T9EEuove4J3VePHT8csgeKXfA/Bc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LTOPsFlZBMI+FkKuiRB6WgpVPaS3Ormo64apy9eskU4iiP6r3q7J3HmRGGwshbFW+zwJOtMQG4Rsa8/n9kmSwLKhoYs78RZUOZgXLPdnI8w/OtORt7V/8MTUOilfMb5zGtEZgut0dov8y4AFyN/PDHcrLGzh7vq6aBpamqNfM7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sA4+rNpW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sA4+rNpW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76FCFC43390;
	Tue, 23 Jan 2024 01:05:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971919;
	bh=gOTRJQXL+mxmJL2T9EEuove4J3VePHT8csgeKXfA/Bc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sA4+rNpW+BeGf62OZ2kBz0vXfvK39YpUoHBdmFllQ0/1+pWe9mKAFPWcPjuicobVd
	 tfkFXVgqaMruIiscUbt5Xm7F7ZxQsiIcNTPiuaizGu4TeLyVxxkecvhJTYQeHSSOWA
	 2e1w9Kgb/oO9PAwK+kZy/3WLs3R1MiTpXbZ2Jfb0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Siddharth Vadapalli <s-vadapalli@ti.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Ravi Gunasekaran <r-gunasekaran@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 264/286] PCI: keystone: Fix race condition when initializing PHYs
Date: Mon, 22 Jan 2024 15:59:30 -0800
Message-ID: <20240122235742.207398599@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index afaea201a5af..d3c3ca3ef4ba 100644
--- a/drivers/pci/controller/dwc/pci-keystone.c
+++ b/drivers/pci/controller/dwc/pci-keystone.c
@@ -1261,7 +1261,16 @@ static int ks_pcie_probe(struct platform_device *pdev)
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



