Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DB8A1E25EF;
	Wed, 17 Sep 2025 12:58:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113931; cv=none; b=LVwXC4Huk02Ru+7JlMoCj/qt22j8aXZc/vVssqFu1UTT2p5UO7Zw+QQW9hPXicIT6oJYeRq+9MUTUw9P9kpZUIHmWy/N5/i6UuPVW/xHL2slRmYbtZYFKhkoEUjeody626CVh3R+nx5/L+SrqkHjVyPCyphaJs67876OVLi7l0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113931; c=relaxed/simple;
	bh=9M8VIxavC4J0Gdx+YdjgLmzyQQp4jyzurH7x++NH92g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LQ7GeRyjts5oxhhTcJcwU4w38FUWRKNEowfcwDVXHahln/PpgM7gTSKMeEJ+XKb+N2KUsIQsgxtU3EjHVCdcq1OkQSd4ENd5yRdlckjyzkOd32STwBtjrTR0vQEG7ebWGT6B84LiU2eGDqq+lVib/rgfgvajiOoESaV38qtfpIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nCGpgvAY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nCGpgvAY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 936B2C4CEF0;
	Wed, 17 Sep 2025 12:58:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113931;
	bh=9M8VIxavC4J0Gdx+YdjgLmzyQQp4jyzurH7x++NH92g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nCGpgvAYdS1QpXLfMWzH6KKfYvSLLinS1DGahbJ2OdoWbp5hEQNISIbb3M9WT+jI5
	 Py5gvvraOKVMVPfDeIyeoMnW8XUYXcvZuJuYxn9YgDVvcp1LjZ1FQYL/g45QQSyxJL
	 zIcQxco0nqlBqipsHX/7Vi7RLN27VBM8x7y8OBFc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	JC Kuo <jckuo@nvidia.com>,
	Johan Hovold <johan@kernel.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.6 096/101] phy: tegra: xusb: fix device and OF node leak at probe
Date: Wed, 17 Sep 2025 14:35:19 +0200
Message-ID: <20250917123339.155690685@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123336.863698492@linuxfoundation.org>
References: <20250917123336.863698492@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3164,18 +3164,22 @@ tegra210_xusb_padctl_probe(struct device
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


