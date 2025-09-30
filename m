Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 661162236EB;
	Tue, 30 Sep 2025 15:12:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245179; cv=none; b=nRGn1HPx8TaDLudzbq239vMZbYUm3w4HR7CqM6iePEEAZM1c0XWjfn1oyDb3uZet9po32wTQ+JL39Ww1OmLUVDhayyYePNzmaz6r0WxewLu516wQSxZVUcEeX1DroiPbW+/O23NY65SDUg9eJfPZIXbZAmttS1C956JHAbkIXEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245179; c=relaxed/simple;
	bh=F71B4EjoD6UCYnaMUeFEiSrZiLRlWW2W0xy/79gic78=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nNN4P2hONkvtQNEfsv4CDgWr4SrF9rhehqCTSRBp+6++wp63fcho9vNS+k3SKtbhKZRgBanWFR65cJvMxIkxj094961PhMEwZ1HJVT+5omrKCiq3lkG0cSFcPvjUL2X/lOiMIEeYVE4nGWEdUJogPBJTxD0OW3oqVcRBd8aSnGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0YTx5Gaz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0YTx5Gaz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4495C4CEF0;
	Tue, 30 Sep 2025 15:12:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245179;
	bh=F71B4EjoD6UCYnaMUeFEiSrZiLRlWW2W0xy/79gic78=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0YTx5Gaz48BgZgNeMHEsyqnSH2wpNvRBk7wyrP41eXq+fUpxpHRfy9T0wDFeszwFs
	 7/p+qYkwK7c8ZRwFPCJhgxyePk4Ghrx2BDjnmGR9avtQzHnZtDuJEGVF9mkbVJzhVc
	 KRCTUdYFh4tcfCMAENRmQro4WcQwAWRtjuKtY+oE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	JC Kuo <jckuo@nvidia.com>,
	Johan Hovold <johan@kernel.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.15 058/151] phy: tegra: xusb: fix device and OF node leak at probe
Date: Tue, 30 Sep 2025 16:46:28 +0200
Message-ID: <20250930143829.913178905@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143827.587035735@linuxfoundation.org>
References: <20250930143827.587035735@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit bca065733afd1e3a89a02f05ffe14e966cd5f78e upstream.

Make sure to drop the references taken to the PMC OF node and device by
of_parse_phandle() and of_find_device_by_node() during probe.

Note the holding a reference to the PMC device does not prevent the
PMC regmap from going away (e.g. if the PMC driver is unbound) so there
is no need to keep the reference.

Fixes: 2d1021487273 ("phy: tegra: xusb: Add wake/sleepwalk for Tegra210")
Cc: stable@vger.kernel.org	# 5.14
Cc: JC Kuo <jckuo@nvidia.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20250724131206.2211-2-johan@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/phy/tegra/xusb-tegra210.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/phy/tegra/xusb-tegra210.c
+++ b/drivers/phy/tegra/xusb-tegra210.c
@@ -3165,18 +3165,22 @@ tegra210_xusb_padctl_probe(struct device
 	}
 
 	pdev = of_find_device_by_node(np);
+	of_node_put(np);
 	if (!pdev) {
 		dev_warn(dev, "PMC device is not available\n");
 		goto out;
 	}
 
-	if (!platform_get_drvdata(pdev))
+	if (!platform_get_drvdata(pdev)) {
+		put_device(&pdev->dev);
 		return ERR_PTR(-EPROBE_DEFER);
+	}
 
 	padctl->regmap = dev_get_regmap(&pdev->dev, "usb_sleepwalk");
 	if (!padctl->regmap)
 		dev_info(dev, "failed to find PMC regmap\n");
 
+	put_device(&pdev->dev);
 out:
 	return &padctl->base;
 }


