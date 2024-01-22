Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CBB013E204;
	Tue, 23 Jan 2024 01:06:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971993; cv=none; b=pqhwFPqOph2IMiEBFn2GRFatnLmfK/lsGsF4xcCK7RnwmNgOXgYIicPdNJi84qVD6twuMADObZjeQVSVaVs/bSAMF7fomWVv0CuxmdL83QAEv5DPlT7g2B8P+GLa3NGPY5rPTpVRi7uMyy1en/9mdUknKc06lEPwFiq/Vogq/os=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971993; c=relaxed/simple;
	bh=4Q5Yva7uCy5oQmqLMuKx8EpGvPOHjUBp3TH7RiAEVpc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dfp3F6v3H4Onoo8Z0EKZXD794aPtPDcdKajIuwC0J4o7yLLaxLZu+2KEuaeKm/i/en/wJLP9jmSVhbxQLiGSzy9p5oSFeNww7Me6rM2AKEeZaS/qg1otCvpwJbOsQofVvmFLP/XlyWy9NPVuEMtHTLf56ke9Nm2DEdsNeK6E2K8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r4bCprsB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r4bCprsB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B156C433F1;
	Tue, 23 Jan 2024 01:06:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971993;
	bh=4Q5Yva7uCy5oQmqLMuKx8EpGvPOHjUBp3TH7RiAEVpc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r4bCprsBFcRZIN0wBP6FZ/X/qGo9wsycbEcExfBqmpFmv8vrQe/GFIpyB4omSWV02
	 tUGQ4ozPDAD0wESm6vkqngfp4IV951hFjlGYQOUY0v+hr/vF30S3tr5lLciSra28h7
	 t0N2nVE/kOIcS8S7+DTWwB1+Qa2X9tkmrp0NoyyI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Siddharth Vadapalli <s-vadapalli@ti.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Ravi Gunasekaran <r-gunasekaran@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 374/417] PCI: keystone: Fix race condition when initializing PHYs
Date: Mon, 22 Jan 2024 15:59:02 -0800
Message-ID: <20240122235804.757795054@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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
index d2634dafb68e..7ecad72cff7e 100644
--- a/drivers/pci/controller/dwc/pci-keystone.c
+++ b/drivers/pci/controller/dwc/pci-keystone.c
@@ -1219,7 +1219,16 @@ static int ks_pcie_probe(struct platform_device *pdev)
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



