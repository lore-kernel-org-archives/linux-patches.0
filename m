Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 047873BFE49;
	Thu, 15 Jan 2026 17:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499150; cv=none; b=rUIJ8wDDjGrlQcEw9nkLdMAeNFzVJYSdJJaW0WPhwJJEd7mVlIVMxwBPeFHuHmU7/hwdfoBHfNt1Y5RJeaxfMDcl5jjuQWGtMlxgvMhe2nkDGQQVsFTrsdtRuUb+Rk666n9ofU5CHnavLCUepdMiOTU9fUO+pzP7uO6E0TtPyms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499150; c=relaxed/simple;
	bh=isos9XJ27cRKNnFNdoVZYhbxs8F+4/cOr5kWYnE4c1U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vBDFcgP995MI49jR4KtRLbzWFHAGN/nOQpn3JikxaEm+pz2u6urqPr28sL08gDqh4Zt6hCActa2YIt8emQNEjHHv+i7p6V0K997wWJxCRP7pu2htU3YCEsL4O16CR84+txz5J6uyvDGbO79Zr9jeXQAluijZY+kAPI5yV1P857c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F0bY1+Oc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F0bY1+Oc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AECBC2BC87;
	Thu, 15 Jan 2026 17:45:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499149;
	bh=isos9XJ27cRKNnFNdoVZYhbxs8F+4/cOr5kWYnE4c1U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F0bY1+OcStKq+oYZAuqp8DgXUVY4P6TbaNLBIefPnQuqtB3Tesaqmkahf9RTkjIv9
	 iTTtl7YHGEMEUVXF9movHWTpa1Yb8yCfpcAVhyvaa4W2uF7TPx++2cMBen36Dr7TCd
	 6dfBC9W7SgNW6GMMmjOpzBcTxpWNr+a3UPxSjH9M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jisheng Zhang <jszhang@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 092/451] usb: dwc2: fix hang during shutdown if set as peripheral
Date: Thu, 15 Jan 2026 17:44:53 +0100
Message-ID: <20260115164234.246311048@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 57ef6dcb489b8..175b4c0886284 100644
--- a/drivers/usb/dwc2/platform.c
+++ b/drivers/usb/dwc2/platform.c
@@ -341,11 +341,11 @@ static void dwc2_driver_shutdown(struct platform_device *dev)
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



