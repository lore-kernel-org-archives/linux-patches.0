Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B73531A7EA;
	Fri,  9 Jan 2026 11:57:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959832; cv=none; b=IJI5kbeB73YyLV7SkpdCn0oO1YF9qtvUV8n0w8CDJ6UE2Jc69PMlIfCnOOBYFEphLxJ8VNkMk9hNxqgqTttfBE0YMGGhaS3UbpCG8oUNQRjgxpPe6a5Z9+w4pj2sK15eZwzdBiLaLgSSO+9XnHkmdDad4ee1gxnBXGU7Gxm1CZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959832; c=relaxed/simple;
	bh=JDK742nWLCOn+ZgLAUh2EVudwvRdPo61m58+l4Di4kU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SZyLjOiPrUGSA6u9utlAl9OGrcz2hGow6Npepves64QG+0CwIeO8LRkaR+n1DDtIhJwZ4AVDfvUIe5ccNjdrNTzrKi6qCJGBUXmAq35jD85+dvMzHntO8YPfRlEKFjDioCe7hp7MfTWOLV8Kzu6sz8VAuaiJqujuohSR0iGn6Ug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=neyguz2c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="neyguz2c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE0D0C16AAE;
	Fri,  9 Jan 2026 11:57:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959832;
	bh=JDK742nWLCOn+ZgLAUh2EVudwvRdPo61m58+l4Di4kU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=neyguz2cMaMSghF1Heu1ZIkvO448lKMSc0wB2T7R199ZGPPGp6p4sKKiuTor2S9CH
	 reZ+LX9IjZTCqUfsefJK1ndeVa4sGsnpFsrmdl9QiIP0JdnBiJIVqhOS81m70Khqcj
	 kK28XUH6cU5c38o6hZLTSm5bQhi9nxt8XQe07t10=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jisheng Zhang <jszhang@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 191/737] usb: dwc2: fix hang during shutdown if set as peripheral
Date: Fri,  9 Jan 2026 12:35:30 +0100
Message-ID: <20260109112141.180292624@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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
index 79ce88b5f07d9..fad6f68f86bd6 100644
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



