Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82B9E359701;
	Fri,  9 Jan 2026 12:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961885; cv=none; b=ktyPLLItUlHVqt5K18nX8hecN5jpr6aeLefD7SzO9o1yqQfqfVS0+EpP+70iI2Xp5oU/rRimWVMWvqWsCWWv48MzaiVQJ5hNupiX0HcG8rycWKGtz08eQq9Oyv1OGwDtQxM2Trh/+uu9eweDPj9m8/3aIADASfGJDuZ1//j0o+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961885; c=relaxed/simple;
	bh=n199HlC7jjOqGM3rwVqU6HjuzbV6TRaHMLaRpfwZTas=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OtlDkeI+RQXemK6uN/+8LXB1F7hmq610NfnbVt1Gzt0VdKnw/VP9tX6fXVr4oroVVBzdqgdHsTbTJRfIuW13LchHL4QpknRGpESG3k3F6xH5XUa6fl7XoXJPO/me1K2qnyGeAx33eBnWgG7pjUMWUZFiZH/PqHBsqJ+AOw1CVRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PRYux1cr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PRYux1cr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB7F2C4CEF1;
	Fri,  9 Jan 2026 12:31:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961885;
	bh=n199HlC7jjOqGM3rwVqU6HjuzbV6TRaHMLaRpfwZTas=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PRYux1crIAx6kj/XnDQ26cEeA3/H7+Yw6XPZz2L7SSuBEYn1m+t5HJmqvDpNz29/r
	 pQBxkBrDAqV3NhW1BdKSJznpGQCV0hfXgM3b7CEypiplHpL8IPpn0Qg/K0+rDsNB+h
	 ENH37ws+rgHOwsLH6pEzH6FEKDFAkb2l2e2EmnQw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jisheng Zhang <jszhang@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 138/634] usb: dwc2: fix hang during suspend if set as peripheral
Date: Fri,  9 Jan 2026 12:36:56 +0100
Message-ID: <20260109112122.648230842@linuxfoundation.org>
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
index 8e80b20361e3a..4464c7b1f0cf1 100644
--- a/drivers/usb/dwc2/platform.c
+++ b/drivers/usb/dwc2/platform.c
@@ -618,9 +618,13 @@ static int dwc2_driver_probe(struct platform_device *dev)
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
 
@@ -671,6 +675,9 @@ static int __maybe_unused dwc2_resume(struct device *dev)
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



