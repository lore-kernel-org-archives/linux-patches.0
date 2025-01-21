Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD0BD1F890F;
	Tue, 21 Jan 2025 18:11:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737483072; cv=none; b=d5L69Y6I2R7Yphtgmy5kKdat7URPJ25PWdWAggbqK3R4bQOVSN+n+bG7Ckxfx3bYS65SmOwSlTGf5WC9ar1R6RnqOD2yih/voC4kLnyh7QGGvLYF63za0aL0AubzmwZoL6urOKjmvIaGbRSaexrSONu12nT5Q5KxzOxnmG+LsSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737483072; c=relaxed/simple;
	bh=qBo1T62zOja2KvKG+Df3KguH6Howrt9LRJc+GJ9J8F4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aeGYXW9pReF2TzzeOq+xKRqtR5nJD4CLwLjkHa8Nkx3oWr3O8bLiOM4/JcMxwQzsnmlSXElOf4ZtX6wW6MxhOxuRVN+2ClpOhAPDpTuvZzv0o0QqMWghF3YkCrtVsxQcI6Kom3gFwulcxSMT6rYoWPm5M4Ese73dPpfVWpwM2BA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XnqqUsiJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XnqqUsiJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5607C4CEE0;
	Tue, 21 Jan 2025 18:11:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737483072;
	bh=qBo1T62zOja2KvKG+Df3KguH6Howrt9LRJc+GJ9J8F4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XnqqUsiJ05NWoUdftTN0leiwFlD71VPCdu19pC5L6DQHG8Dim9bLLsyQ+8+2QNmYh
	 jMC2zlqGrDOkvnIecPsPaFO2wF6AxwVO6q+zvL8yIDzamYgNGSXekpBA+f1CBjgg3j
	 AE9GrbpOaMUHU6WfqXQjc6KJUQ1LOmxgDWAYsMoY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Chen <justinpopo6@gmail.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.15 077/127] phy: usb: Use slow clock for wake enabled suspend
Date: Tue, 21 Jan 2025 18:52:29 +0100
Message-ID: <20250121174532.629110369@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174529.674452028@linuxfoundation.org>
References: <20250121174529.674452028@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 


