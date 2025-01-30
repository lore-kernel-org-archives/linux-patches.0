Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11A891DDC22;
	Thu, 30 Jan 2025 14:25:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738247148; cv=none; b=hZrI9GPXxOuEPKqeae7L1m97HmZjbB8ZT/0gq30ce3RsqvRBEhwaa+PiLWG1mKR/4RCJ5QlMp29zYZVaVc+dxnMVD+9EjwpIcnkx076hlqThm6ga7c+o12ho3Ih5A9bE2JG2y2mzRTM+9nne7SI8rJ7MlZwJ70eE6yyQQo2j3v4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738247148; c=relaxed/simple;
	bh=hCggc3UQhTgY7kcUhr8LcZn03K4EkJQUjV+19eMciYE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K74HEbxGv3XKg9AqyurEk08s4ARzRYXmcl/Uxze2MN+SRNPzxsxz2QkJD4ah0sdJ5vmYXJ+4NFvZKiuvmYYtWpuR4SFYWyw97dycxfuetUJvgFMWzdRwZG/h2SARano9q34vs5CHd2WnAK6hO54z82MUGnHe+tJ2k2I9bXLoCSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XY2Wx4/M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XY2Wx4/M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E1EEC4CED2;
	Thu, 30 Jan 2025 14:25:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738247148;
	bh=hCggc3UQhTgY7kcUhr8LcZn03K4EkJQUjV+19eMciYE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XY2Wx4/Mke5hbJMlx1VzkHx+D/bvNQmX9ZWf7qPKcr6eOY4ZekYg3r2eKQSz29V4W
	 LRknEG2Uw3Gp+1B+2Xmz6pLXYfWZWbHb7jDUt3BszbG3XR9YuiIa3C3tyom6zU/P8F
	 GMgN8mgxO0VOXPOpXjmMmroEZBXHUArH1tNyMQnQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Chen <justinpopo6@gmail.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.10 069/133] phy: usb: Use slow clock for wake enabled suspend
Date: Thu, 30 Jan 2025 15:00:58 +0100
Message-ID: <20250130140145.296671794@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140142.491490528@linuxfoundation.org>
References: <20250130140142.491490528@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Justin Chen <justinpopo6@gmail.com>

commit 700c44b508020a3ea29d297c677f8d4ab14b7e6a upstream.

The logic was incorrect when switching to slow clock. We want the slow
clock if wake_enabled is set.

Fixes: ae532b2b7aa5 ("phy: usb: Add "wake on" functionality for newer Synopsis XHCI controllers")
Signed-off-by: Justin Chen <justinpopo6@gmail.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Link: https://lore.kernel.org/r/1665005418-15807-6-git-send-email-justinpopo6@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/phy/broadcom/phy-brcm-usb-init-synopsys.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/drivers/phy/broadcom/phy-brcm-usb-init-synopsys.c
+++ b/drivers/phy/broadcom/phy-brcm-usb-init-synopsys.c
@@ -337,13 +337,12 @@ static void usb_uninit_common_7216(struc
 
 	pr_debug("%s\n", __func__);
 
-	if (!params->wake_enabled) {
-		USB_CTRL_SET(ctrl, USB_PM, USB_PWRDN);
-
+	if (params->wake_enabled) {
 		/* Switch to using slower clock during suspend to save power */
 		USB_CTRL_SET(ctrl, USB_PM, XHC_S2_CLK_SWITCH_EN);
-	} else {
 		usb_wake_enable_7216(params, true);
+	} else {
+		USB_CTRL_SET(ctrl, USB_PM, USB_PWRDN);
 	}
 }
 


