Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3693F35C19C;
	Fri,  9 Jan 2026 12:49:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962955; cv=none; b=mNfRrL5mj6vHmHdp/Sz1fB19cilGeV3sc2hWhercgBDk5dHFJZm+qxsV0x4hkHRC4O5z5ca5Bbii2FKJPJqgVhj3u2zaxrlhnDJl2FNmZOU2HKesndwTFr2XRy+OVW5w5EBSBTBa4N3fjieDMLq/Es8v1OXwYreYG8Q/Lbrq8Ic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962955; c=relaxed/simple;
	bh=6tAz5Mc+DEDB78WxSRLwWDGQuypC6nFwsUecGdfQbIo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SC35L1CP/UoU/V4gR5Unt1zXO5imQ7CwGBa8A+gEB3PByjzpmWP6Z+JTwVaiMRI5HMODXRQaZPz/EnSGfV6rsgt9mtB1xO7IygBoiza17Y4IsjF40DQ4e/Ww1c0UCIqf9kB087q3jFD16BfmLYd/uTkastgtf2X/fZIz8U2FISw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h7y+9b/I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h7y+9b/I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6C26C2BCAF;
	Fri,  9 Jan 2026 12:49:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962955;
	bh=6tAz5Mc+DEDB78WxSRLwWDGQuypC6nFwsUecGdfQbIo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h7y+9b/I66MkMnxeH4WMWXt8tZnqT8539VWismcwuKN4XuoZJAIiXpcL26Xh18pgW
	 1vvpdW0HAUfgKCG57BNxN3Qawh8YMGiASV6/rkbPQrxWwqngtM88AMfkIGoBuO2khA
	 OCBU+D9k7/u5vf7Tp3bfBw0htF7v+FX7+3m5vVFc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Zekun <zhangzekun11@huawei.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 546/634] usb: ohci-nxp: Use helper function devm_clk_get_enabled()
Date: Fri,  9 Jan 2026 12:43:44 +0100
Message-ID: <20260109112138.135841826@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Zekun <zhangzekun11@huawei.com>

[ Upstream commit c146ede472717f352b7283a525bd9a1a2b15e2cf ]

devm_clk_get() and clk_prepare_enable() can be replaced by helper
function devm_clk_get_enabled(). Let's use devm_clk_get_enabled() to
simplify code and avoid calling clk_disable_unprepare().

Signed-off-by: Zhang Zekun <zhangzekun11@huawei.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://lore.kernel.org/r/20240902123020.29267-3-zhangzekun11@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: b4c61e542faf ("usb: ohci-nxp: fix device leak on probe failure")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/ohci-nxp.c |   18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

--- a/drivers/usb/host/ohci-nxp.c
+++ b/drivers/usb/host/ohci-nxp.c
@@ -51,8 +51,6 @@ static struct hc_driver __read_mostly oh
 
 static struct i2c_client *isp1301_i2c_client;
 
-static struct clk *usb_host_clk;
-
 static void isp1301_configure_lpc32xx(void)
 {
 	/* LPC32XX only supports DAT_SE0 USB mode */
@@ -155,6 +153,7 @@ static int ohci_hcd_nxp_probe(struct pla
 	struct resource *res;
 	int ret = 0, irq;
 	struct device_node *isp1301_node;
+	struct clk *usb_host_clk;
 
 	if (pdev->dev.of_node) {
 		isp1301_node = of_parse_phandle(pdev->dev.of_node,
@@ -180,26 +179,20 @@ static int ohci_hcd_nxp_probe(struct pla
 	}
 
 	/* Enable USB host clock */
-	usb_host_clk = devm_clk_get(&pdev->dev, NULL);
+	usb_host_clk = devm_clk_get_enabled(&pdev->dev, NULL);
 	if (IS_ERR(usb_host_clk)) {
-		dev_err(&pdev->dev, "failed to acquire USB OHCI clock\n");
+		dev_err(&pdev->dev, "failed to acquire and start USB OHCI clock\n");
 		ret = PTR_ERR(usb_host_clk);
 		goto fail_disable;
 	}
 
-	ret = clk_prepare_enable(usb_host_clk);
-	if (ret < 0) {
-		dev_err(&pdev->dev, "failed to start USB OHCI clock\n");
-		goto fail_disable;
-	}
-
 	isp1301_configure();
 
 	hcd = usb_create_hcd(driver, &pdev->dev, dev_name(&pdev->dev));
 	if (!hcd) {
 		dev_err(&pdev->dev, "Failed to allocate HC buffer\n");
 		ret = -ENOMEM;
-		goto fail_hcd;
+		goto fail_disable;
 	}
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
@@ -230,8 +223,6 @@ static int ohci_hcd_nxp_probe(struct pla
 	ohci_nxp_stop_hc();
 fail_resource:
 	usb_put_hcd(hcd);
-fail_hcd:
-	clk_disable_unprepare(usb_host_clk);
 fail_disable:
 	isp1301_i2c_client = NULL;
 	return ret;
@@ -244,7 +235,6 @@ static int ohci_hcd_nxp_remove(struct pl
 	usb_remove_hcd(hcd);
 	ohci_nxp_stop_hc();
 	usb_put_hcd(hcd);
-	clk_disable_unprepare(usb_host_clk);
 	isp1301_i2c_client = NULL;
 
 	return 0;


