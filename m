Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D3663328E3;
	Tue, 16 Dec 2025 12:24:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887869; cv=none; b=HEsVQN5Jz08e1oiI1cOg5GEDNnPuA7cB/BnbO6FxFGC8lvkeOvUqn7WzRzOiQ3eFdZQU7orTQnJw2VZuMydmeh5TJZNAzKXQ4lUjlYsb8wZoBbgExC6JKKgYQ2w/H8Dq9Fpw+NXh8G0KRGo/8KjWheHqQW+kkOsf810OOlEmntE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887869; c=relaxed/simple;
	bh=zp5oPP1uVzVV0TfYzAPQ1aK6PjAVKnEzbeNOA9iVfZo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tLk5LbODellflzGULVuT/Z6HJWsSMTb5Hmi9PUHTlECjrrByh1dqtlCLlycFen/L7wkIIS7HWoU1CwLU1o0z5inHNE+wJjgv1VrV+QDko+b82D19U8CrVwnYGQhqnyOZoggUYouxSLDQcfNMidpwIOnZzXH1BV1gJAReAmdQNTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OBTrchXu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OBTrchXu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94AB3C4CEF1;
	Tue, 16 Dec 2025 12:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887869;
	bh=zp5oPP1uVzVV0TfYzAPQ1aK6PjAVKnEzbeNOA9iVfZo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OBTrchXunWe4XqxM8R3XbOEcQ+j3BdWlD2Xkm8fztLw7mWzr3dMzydXpOoaWtcMeo
	 mL8HxCXZVgzhosypiS0lM0fC9+YrgeUG/BX57d/3IBhwU5m5rsH5byFWTTMu45lEdR
	 g6uqMS8qUFEtnttrDIR/IYDWfij7ELplODXUXk2I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jisheng Zhang <jszhang@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 363/614] usb: dwc2: fix hang during shutdown if set as peripheral
Date: Tue, 16 Dec 2025 12:12:10 +0100
Message-ID: <20251216111414.512400319@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jisheng Zhang <jszhang@kernel.org>

[ Upstream commit b6ebcfdcac40a27953f052e4269ce75a18825ffc ]

dwc2 on most platforms needs phy controller, clock and power supply.
All of them must be enabled/activated to properly operate. If dwc2
is configured as peripheral mode, then all the above three hardware
resources are disabled at the end of the probe:

	/* Gadget code manages lowlevel hw on its own */
	if (hsotg->dr_mode == USB_DR_MODE_PERIPHERAL)
		dwc2_lowlevel_hw_disable(hsotg);

But dwc2_driver_shutdown() tries to disable the interrupts on HW IP
level. This would result in hang during shutdown if dwc2 is configured
as peripheral mode.

Fix this hang by only disable and sync irq when lowlevel hw is enabled.

Fixes: 4fdf228cdf69 ("usb: dwc2: Fix shutdown callback in platform")
Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
Link: https://patch.msgid.link/20251104002503.17158-2-jszhang@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc2/platform.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/dwc2/platform.c b/drivers/usb/dwc2/platform.c
index 3f83ecc9fc236..b07bdf16326a4 100644
--- a/drivers/usb/dwc2/platform.c
+++ b/drivers/usb/dwc2/platform.c
@@ -369,11 +369,11 @@ static void dwc2_driver_shutdown(struct platform_device *dev)
 {
 	struct dwc2_hsotg *hsotg = platform_get_drvdata(dev);
 
-	dwc2_disable_global_interrupts(hsotg);
-	synchronize_irq(hsotg->irq);
-
-	if (hsotg->ll_hw_enabled)
+	if (hsotg->ll_hw_enabled) {
+		dwc2_disable_global_interrupts(hsotg);
+		synchronize_irq(hsotg->irq);
 		dwc2_lowlevel_hw_disable(hsotg);
+	}
 }
 
 /**
-- 
2.51.0



