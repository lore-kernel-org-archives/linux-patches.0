Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BA3C267F68;
	Tue,  8 Apr 2025 11:52:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113167; cv=none; b=geazSCSHsjJSD4Zc58wMFpOAsAAAJIINMzHuYI/8TESxkbG+EwA5x1EPqxRx3jy5H0Y9kPSr5HfXaAXdowzK2pRq5KzNW2W59awgiloXurbKTHuxP6PAuO/mjC4cxUacc3Pc/t8UxueEcbIvSVag0/jv2FZZf9wVu2q+zrNsD9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113167; c=relaxed/simple;
	bh=/ihRBV87h8X8px/c++8OeRtarBM7J+XcvfQnl2IhnFA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VnqsrL+6X2fPUT6T9gg7Wa8CWm6ux/GjbXRZw8r6lb+Lmmlg5JDnT4Zpe4HaDIuBoUXUq587kHrN20uFuOT/1jMTX05K1ov7pR083DnC0ymYbuaeeh/TTDRNCIfBwnSMvXJn0IHdH7OVItL8ieS3wwfisO2X9kpFHukoEjdaK+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t+lo9P5H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t+lo9P5H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96524C4CEE5;
	Tue,  8 Apr 2025 11:52:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113167;
	bh=/ihRBV87h8X8px/c++8OeRtarBM7J+XcvfQnl2IhnFA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t+lo9P5HAJgVLfcjZz3xKggqzQpJVp0GwYoCDFzTfHPtys8AFVzgkZu4XVAeFRLdW
	 YJ8tNTWcdARvvPaUOpF/C5QY+IVEM9d+RBsMil4p/wZ4stn6h48ZgxaMR1aUjqMX5/
	 t0Z+JxQjtk76MIYFuNzazD6mU7EdmkepiN6G3Nxs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 057/268] PCI: histb: Fix an error handling path in histb_pcie_probe()
Date: Tue,  8 Apr 2025 12:47:48 +0200
Message-ID: <20250408104830.039543701@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104828.499967190@linuxfoundation.org>
References: <20250408104828.499967190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index fd484cc7c481d..335b26635ee99 100644
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



