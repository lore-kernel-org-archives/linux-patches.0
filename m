Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD62E268C78;
	Tue,  8 Apr 2025 11:19:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111197; cv=none; b=X8AlCf3bQmMUZGw7bXmByRjYMBl956ctx9ArlkOaoPLwdFzWsENVC/pXTe725IReKYP0CMMKvLaEFZK2sBy0C1+Qeu9hjumc6kYDPNmzIHF3mbko/onB+Rw6ppkQy0y/Uco+nA3aAi873ajqDHLj0j5LGwVqUKa8e7kWNQz11Ag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111197; c=relaxed/simple;
	bh=nGOxYH4V807bZ3CzqxydHfjgtNlsxIDA3qBMYVKvdIE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XlcHgibwuqwg+H7MC5yqZYvJeAD54NgzXV23XwPqgWlO5TOE45HWNds6Rd3nc/GY+QZNu/TBvQYx27K+RE1UHI6p1HqLglLekrPyMAEhWNdQPb8kxii+PTKuZRL16Cy38TxpbVYJVyYl2Nl35sEQ1YtIVNSH5ZFKhHhVGMb++Ng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iAwxegrJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iAwxegrJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD7DEC4CEEB;
	Tue,  8 Apr 2025 11:19:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111197;
	bh=nGOxYH4V807bZ3CzqxydHfjgtNlsxIDA3qBMYVKvdIE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iAwxegrJZGQudcxA3/px1XG/ZlcnwnK/LRq3qtAicJLTT8vwzjRshEySA8D0knURp
	 yFSFMZIIYIyNrnGFJgrZRqhQv4vBOtus1M83GgcNzPDghWSLjiRrwjdXfTGR81JHad
	 Li4sVyHlZ4OgUu2pJRmoUlkaPTSnt9PKyMbIzQ5o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 337/731] PCI: histb: Fix an error handling path in histb_pcie_probe()
Date: Tue,  8 Apr 2025 12:43:54 +0200
Message-ID: <20250408104922.114809570@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index 615a0e3e6d7eb..1f2f4c28a9495 100644
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



