Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4842C1C07
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:26:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C03B5C433A4;
	Wed, 28 Dec 2022 16:26:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672244796;
	bh=QxSUR4nYeki/U9OxdIBOBvWP0VUu4Wb6oL8wXCjPKmQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t/m3FfjRE2DE7VToH6Kz0fMIXmBDAhH72UQ4aM8RMEnpDjCtFF0CYBX8KCASJMiFg
	 umsxrVLjxmMNV/IFmD/Y7frdlhuV8ZozqoiKxg1Sr5TqnaBVJwW1AKr1pokVoDlxH+
	 CI5NM4Vr1a9KKntZgo8xUJcc6ShCN1O8PHejv7+g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Chen <justinpopo6@gmail.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0775/1073] phy: usb: Use slow clock for wake enabled suspend
Date: Wed, 28 Dec 2022 15:39:23 +0100
Message-Id: <20221228144349.063603444@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Justin Chen <justinpopo6@gmail.com>

[ Upstream commit 700c44b508020a3ea29d297c677f8d4ab14b7e6a ]

The logic was incorrect when switching to slow clock. We want the slow
clock if wake_enabled is set.

Fixes: ae532b2b7aa5 ("phy: usb: Add "wake on" functionality for newer Synopsis XHCI controllers")
Signed-off-by: Justin Chen <justinpopo6@gmail.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Link: https://lore.kernel.org/r/1665005418-15807-6-git-send-email-justinpopo6@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/broadcom/phy-brcm-usb-init-synopsys.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/phy/broadcom/phy-brcm-usb-init-synopsys.c b/drivers/phy/broadcom/phy-brcm-usb-init-synopsys.c
index d2524b70ea16..b3386e458dd4 100644
--- a/drivers/phy/broadcom/phy-brcm-usb-init-synopsys.c
+++ b/drivers/phy/broadcom/phy-brcm-usb-init-synopsys.c
@@ -331,13 +331,12 @@ static void usb_uninit_common_7216(struct brcm_usb_init_params *params)
 
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
 
-- 
2.35.1



