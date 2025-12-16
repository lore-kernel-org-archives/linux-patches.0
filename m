Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BBB13446AA;
	Tue, 16 Dec 2025 11:28:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884480; cv=none; b=hX9ezfBmCro+t4AnfriwgzZ3cODd/pGwLy3AjWK3jV1YTVMzvWwon8g+R4Isy7jDL9B/GI1Fdyy5+C0DYCTfZVly+vx/0jTVsB3jQVpAhb8b67msMOurGVIO27SwYQQVNF9U+lnUTSivvVfc12TKO/KQ6mszdtC8dHIDrPeqbhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884480; c=relaxed/simple;
	bh=EDOksdhdJ2ptmtsEoB8sO5pLcnbjIDy1Aq5F970EUYo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sjnebxek5NKxNqxRvpplk6KSHqgzBRT0HaN707/RS+54/yLVRQG0m0NSnM6AZk+Y5CSLMOHTWg6I/vLVjfNm7boj736ee2gxmONR8sauA45rZ3yAG6oL56XR2T9LfWoQQieXejCuV977SrHJiEQ/oEBkfFHWFg8Z/ucld3wMeMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RzDgK8sV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RzDgK8sV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ABC4C4CEF1;
	Tue, 16 Dec 2025 11:27:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884479;
	bh=EDOksdhdJ2ptmtsEoB8sO5pLcnbjIDy1Aq5F970EUYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RzDgK8sVMEqCYRi71cgggxRezs5vw2K6PWg6SalGRmgJtATnzY2Ww5fjXONgrR25c
	 e6WZs0iR0mVxFKAWmDkWMKotUFkGvkzWff6DV0c+kKk/S5dwG72S7VJsl2I+Ow0J/j
	 g1AeTiArEpANWjnr3t7THC2QCBmefF8lNA/siG4I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jisheng Zhang <jszhang@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 205/354] usb: dwc2: fix hang during suspend if set as peripheral
Date: Tue, 16 Dec 2025 12:12:52 +0100
Message-ID: <20251216111328.346693102@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jisheng Zhang <jszhang@kernel.org>

[ Upstream commit 2b94b054ac4974ad2f89f7f7461840c851933adb ]

dwc2 on most platforms needs phy controller, clock and power supply.
All of them must be enabled/activated to properly operate. If dwc2
is configured as peripheral mode, then all the above three hardware
resources are disabled at the end of the probe:

	/* Gadget code manages lowlevel hw on its own */
	if (hsotg->dr_mode == USB_DR_MODE_PERIPHERAL)
		dwc2_lowlevel_hw_disable(hsotg);

But the dwc2_suspend() tries to read the dwc2's reg to check whether
is_device_mode or not, this would result in hang during suspend if dwc2
is configured as peripheral mode.

Fix this hang by bypassing suspend/resume if lowlevel hw isn't
enabled.

Fixes: 09a75e857790 ("usb: dwc2: refactor common low-level hw code to platform.c")
Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
Link: https://patch.msgid.link/20251104002503.17158-3-jszhang@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc2/platform.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/dwc2/platform.c b/drivers/usb/dwc2/platform.c
index fad6f68f86bd6..e80982c817d7d 100644
--- a/drivers/usb/dwc2/platform.c
+++ b/drivers/usb/dwc2/platform.c
@@ -649,9 +649,13 @@ static int dwc2_driver_probe(struct platform_device *dev)
 static int __maybe_unused dwc2_suspend(struct device *dev)
 {
 	struct dwc2_hsotg *dwc2 = dev_get_drvdata(dev);
-	bool is_device_mode = dwc2_is_device_mode(dwc2);
+	bool is_device_mode;
 	int ret = 0;
 
+	if (!dwc2->ll_hw_enabled)
+		return 0;
+
+	is_device_mode = dwc2_is_device_mode(dwc2);
 	if (is_device_mode)
 		dwc2_hsotg_suspend(dwc2);
 
@@ -702,6 +706,9 @@ static int __maybe_unused dwc2_resume(struct device *dev)
 	struct dwc2_hsotg *dwc2 = dev_get_drvdata(dev);
 	int ret = 0;
 
+	if (!dwc2->ll_hw_enabled)
+		return 0;
+
 	if (dwc2->phy_off_for_suspend && dwc2->ll_hw_enabled) {
 		ret = __dwc2_lowlevel_hw_enable(dwc2);
 		if (ret)
-- 
2.51.0



