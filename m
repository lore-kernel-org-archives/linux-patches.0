Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86E7915530C;
	Thu, 15 Jan 2026 17:19:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497575; cv=none; b=H+dd4OkghXnNalcYr5IdXt8dqa8jhA1fS6eQ8JM3+M00Foa9itx5rK439MMPTz1yox1A5u9FXCmv+gqrLoykzsRHx/X+OxJg9OcDUh9Hgb+vl/3pZ5m6vvdi7/yEdHkpUobZzZkykVqY+u1ayzAF2YeCtADNPobvXwWBYc0csAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497575; c=relaxed/simple;
	bh=hoX/VjTrNYtasnvMXNyEHSGESS9FvKqLLMFh/O4HYfs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mry6O46ZVcYpM3CvC1Rc+GQ2TbBg89Xtr0dUXKW62SA6gM2Pr0mUQ15+mTLMw8TyyAsEWVOzzamxxCACavKbpLWJqKEZKE4r93QEFhn3Mb/EDAXm34h8Z58ft5FMvYzhUkIozbUfYHZMc5jGlA4vvNbXjTkXZmIXUNPehzLJ8GU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=muWFRar4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="muWFRar4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA237C116D0;
	Thu, 15 Jan 2026 17:19:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497575;
	bh=hoX/VjTrNYtasnvMXNyEHSGESS9FvKqLLMFh/O4HYfs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=muWFRar4IVbTPvQTZ81ifMXKqzCceowp6d0BPWaECNT6GDeDUVny+RrrF1mrKqES0
	 zGhUaXmBw+QzSfDZDBWsdlBq7yRlb2DGlgQ5Qy3rEfwg/LYE1VKyNW/BwSyfXw60OW
	 brDhezlA6Xd6o0F8za0Me86Ss1z4kPX5nM19j2g8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jisheng Zhang <jszhang@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 128/554] usb: dwc2: fix hang during suspend if set as peripheral
Date: Thu, 15 Jan 2026 17:43:14 +0100
Message-ID: <20260115164250.879366765@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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
index ae2d73c5aa811..c9fa8c3ff425a 100644
--- a/drivers/usb/dwc2/platform.c
+++ b/drivers/usb/dwc2/platform.c
@@ -669,9 +669,13 @@ static int dwc2_driver_probe(struct platform_device *dev)
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
 
@@ -722,6 +726,9 @@ static int __maybe_unused dwc2_resume(struct device *dev)
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



