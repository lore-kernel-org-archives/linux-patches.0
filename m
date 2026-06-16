Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3C5E35CB87;
	Tue, 16 Jun 2026 17:15:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781630147; cv=none; b=pfuNI/tQWy4jIv/4eNUCObJqHn9Cd/dlk2ejv870mt8d95GZiLj5ffthgoPFIEJfyh3hxK8EAKyzy44ubxCMOgW0A4spkAR1ac6dez9NaGBTsu8MFAl5bXMiXdFh/Zw5hWidiRvaZxTkDUW96+WMaORVdc1Io8yHaQDMqOQgNZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781630147; c=relaxed/simple;
	bh=k5pvRq4waWK6u5Y4rL9ndd6XmNe3cDyvvUnvtH39CRo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i6QoyVqfJAj+NYuVKSriaEPNG4NHfXXyZlTGcqAm0JpySSQxxcpkFxPnhXCJ3FnMv3dmcEHIrzg4Mg+wwroxaQYaLcJhqTd8M4dV0BHptl6RYbPx5l24vMgh4jSrhfqPl/6lQDBR76++yHBqsoDr/NJX3sb1L9Em6rxB2wAnxjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BY8lFSWW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BY8lFSWW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF2111F000E9;
	Tue, 16 Jun 2026 17:15:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781630146;
	bh=K/d7gg1919HD0azZ9eonI/0hYq3RN0vwAOiLDeFkuRM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BY8lFSWWsydZ9TeqNJgMCRR4HWa8mKHDyPBl9FJt0N7nPQIX1aivRBMb45yaCqrAO
	 lMm3655pfFeT8UTygcXJBjiJivs5YaZtb6EkjGplCh+Ud9Hg1KT7IurgtZjSaDsLNg
	 cgNL8MPiEPhQUI7UQFwfT3TMIr559RRxEU+dpQKI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
	Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 420/452] usb: dwc3: xilinx: fix error handling in zynqmp init error paths
Date: Tue, 16 Jun 2026 20:30:47 +0530
Message-ID: <20260616145138.819049052@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>

[ Upstream commit c1a0ecbf32c4b397353204e2ec94c5bb9f3300ed ]

Fix error handling and resource cleanup i.e remove invalid
phy_exit() after failed phy_init(), route failures through
proper cleanup paths and return 0 explicitly on success.

Fixes: 84770f028fab ("usb: dwc3: Add driver for Xilinx platforms")
Cc: stable@vger.kernel.org
Acked-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
Link: https://patch.msgid.link/20260519115529.2980421-1-radhey.shyam.pandey@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/dwc3-xilinx.c |   26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

--- a/drivers/usb/dwc3/dwc3-xilinx.c
+++ b/drivers/usb/dwc3/dwc3-xilinx.c
@@ -170,15 +170,13 @@ static int dwc3_xlnx_init_zynqmp(struct
 	}
 
 	ret = phy_init(priv_data->usb3_phy);
-	if (ret < 0) {
-		phy_exit(priv_data->usb3_phy);
+	if (ret < 0)
 		goto err;
-	}
 
 	ret = reset_control_deassert(apbrst);
 	if (ret < 0) {
 		dev_err(dev, "Failed to release APB reset\n");
-		goto err;
+		goto err_phy_exit;
 	}
 
 	/* Set PIPE Power Present signal in FPD Power Present Register*/
@@ -190,27 +188,25 @@ static int dwc3_xlnx_init_zynqmp(struct
 	ret = reset_control_deassert(crst);
 	if (ret < 0) {
 		dev_err(dev, "Failed to release core reset\n");
-		goto err;
+		goto err_phy_exit;
 	}
 
 	ret = reset_control_deassert(hibrst);
 	if (ret < 0) {
 		dev_err(dev, "Failed to release hibernation reset\n");
-		goto err;
+		goto err_phy_exit;
 	}
 
 	ret = phy_power_on(priv_data->usb3_phy);
-	if (ret < 0) {
-		phy_exit(priv_data->usb3_phy);
-		goto err;
-	}
+	if (ret < 0)
+		goto err_phy_exit;
 
 skip_usb3_phy:
 	/* ulpi reset via gpio-modepin or gpio-framework driver */
 	reset_gpio = devm_gpiod_get_optional(dev, "reset", GPIOD_OUT_HIGH);
 	if (IS_ERR(reset_gpio)) {
-		return dev_err_probe(dev, PTR_ERR(reset_gpio),
-				     "Failed to request reset GPIO\n");
+		ret = PTR_ERR(reset_gpio);
+		goto err_phy_power_off;
 	}
 
 	if (reset_gpio) {
@@ -230,6 +226,12 @@ skip_usb3_phy:
 		writel(reg, priv_data->regs + XLNX_USB_TRAFFIC_ROUTE_CONFIG);
 	}
 
+	return 0;
+
+err_phy_power_off:
+	phy_power_off(priv_data->usb3_phy);
+err_phy_exit:
+	phy_exit(priv_data->usb3_phy);
 err:
 	return ret;
 }


