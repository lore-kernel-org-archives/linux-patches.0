Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8700D2638B8;
	Tue,  8 Apr 2025 12:45:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116321; cv=none; b=GiYlSjPlnYmjeO7ODKMgnoioFUmx2DkXcAoMlRDt8+h4hcO/6WncSI1lsnNHGwMNBuaktoEJSjS/Ej0Fj2VdcvomWc7qCEhAIroCDRAiTF2B0o2VCHW+igU6QmV3VgQm9pMAx9nAfw8b6ErqBVyPs4Iuyxy6r5nAQWlr57yzah4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116321; c=relaxed/simple;
	bh=0qO3gNytZKxhmtPuBTL2qKw+Nb+EUwCBvDal65rccEs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rPUvdKdwDPRO3VMWyImjqWft2sEGkRIaC0IOQmzFhanJaaH46UShBZ49l0otOit7bKVbycmsKVjnjnVtFezQHzWVm60ehiFTnA89ZG/zNWoQdBe0nwXUVWvFZw/piH18LS5E+YBIF0GFgdkatkUwUheh3cjgMYbJVJAaYfOgmIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yp99aV2s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yp99aV2s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19FFBC4CEE5;
	Tue,  8 Apr 2025 12:45:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116321;
	bh=0qO3gNytZKxhmtPuBTL2qKw+Nb+EUwCBvDal65rccEs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yp99aV2s1NbL798YvpC9HfUOuaO6Zan9Ds8nCy+xQzXthwc9kfEGaZ+QrL75pHOt9
	 KIHWyzlziCvgq8rGPNkjUjzy3NBPAJuSQS9R2wU9+crY6ieokJRUOqJ2rUWANKoHfN
	 ss8RYDhg+iRnH4JVv1NwE279Y8/wzo4Mf1josjEo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 090/423] PCI: histb: Fix an error handling path in histb_pcie_probe()
Date: Tue,  8 Apr 2025 12:46:56 +0200
Message-ID: <20250408104847.836649960@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit b36fb50701619efca5f5450b355d42575cf532ed ]

If an error occurs after a successful phy_init() call, then phy_exit()
should be called.

Add the missing call, as already done in the remove function.

Fixes: bbd11bddb398 ("PCI: hisi: Add HiSilicon STB SoC PCIe controller driver")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
[kwilczynski: remove unnecessary hipcie->phy NULL check from
histb_pcie_probe() and squash a patch that removes similar NULL
check for hipcie-phy from histb_pcie_remove() from
https://lore.kernel.org/linux-pci/c369b5d25e17a44984ae5a889ccc28a59a0737f7.1742058005.git.christophe.jaillet@wanadoo.fr]
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Link: https://lore.kernel.org/r/8301fc15cdea5d2dac21f57613e8e6922fb1ad95.1740854531.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-histb.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/pci/controller/dwc/pcie-histb.c b/drivers/pci/controller/dwc/pcie-histb.c
index 7a11c618b9d9c..5538e5bf99fb6 100644
--- a/drivers/pci/controller/dwc/pcie-histb.c
+++ b/drivers/pci/controller/dwc/pcie-histb.c
@@ -409,16 +409,21 @@ static int histb_pcie_probe(struct platform_device *pdev)
 	ret = histb_pcie_host_enable(pp);
 	if (ret) {
 		dev_err(dev, "failed to enable host\n");
-		return ret;
+		goto err_exit_phy;
 	}
 
 	ret = dw_pcie_host_init(pp);
 	if (ret) {
 		dev_err(dev, "failed to initialize host\n");
-		return ret;
+		goto err_exit_phy;
 	}
 
 	return 0;
+
+err_exit_phy:
+	phy_exit(hipcie->phy);
+
+	return ret;
 }
 
 static void histb_pcie_remove(struct platform_device *pdev)
@@ -427,8 +432,7 @@ static void histb_pcie_remove(struct platform_device *pdev)
 
 	histb_pcie_host_disable(hipcie);
 
-	if (hipcie->phy)
-		phy_exit(hipcie->phy);
+	phy_exit(hipcie->phy);
 }
 
 static const struct of_device_id histb_pcie_of_match[] = {
-- 
2.39.5



