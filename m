Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B7F41863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:39:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00E7BC433D2;
	Wed, 28 Dec 2022 15:39:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672241969;
	bh=vN7+nw468i9Uj88enQI+sxQT378K1ipRLkWW1xecTQc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y6kjwPT6zgkRPZc/7P2V3GVqjs7sYWJRHMemGL/NxS/haxqmQ2MFzaZyuA8yXRdbi
	 FldDEUwwONsIcLyeTpBsotTWkEctW8B4i/K72GlvhAsDfJcOUuHTL990uKNyo8mHYc
	 GikuVbLmXFWx+dbtC6P0YK5eICQKdFctpChbVTMc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Cooper <alcooperx@gmail.com>,
	Justin Chen <justinpopo6@gmail.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 533/731] phy: usb: s2 WoL wakeup_count not incremented for USB->Eth devices
Date: Wed, 28 Dec 2022 15:40:40 +0100
Message-Id: <20221228144311.993056913@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Al Cooper <alcooperx@gmail.com>

[ Upstream commit f7fc5b7090372fc4dd7798c874635ca41b8ba733 ]

The PHY's "wakeup_count" is not incrementing when waking from
WoL. The wakeup count can be found in sysfs at:
/sys/bus/platform/devices/rdb/*.usb-phy/power/wakeup_count.
The problem is that the system wakup event handler was being passed
the wrong "device" by the PHY driver.

Fixes: f1c0db40a3ad ("phy: usb: Add "wake on" functionality")
Signed-off-by: Al Cooper <alcooperx@gmail.com>
Signed-off-by: Justin Chen <justinpopo6@gmail.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Link: https://lore.kernel.org/r/1665005418-15807-3-git-send-email-justinpopo6@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/broadcom/phy-brcm-usb.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/phy/broadcom/phy-brcm-usb.c b/drivers/phy/broadcom/phy-brcm-usb.c
index 2cb3779fcdf8..c0c3ab9b2a15 100644
--- a/drivers/phy/broadcom/phy-brcm-usb.c
+++ b/drivers/phy/broadcom/phy-brcm-usb.c
@@ -102,9 +102,9 @@ static int brcm_pm_notifier(struct notifier_block *notifier,
 
 static irqreturn_t brcm_usb_phy_wake_isr(int irq, void *dev_id)
 {
-	struct phy *gphy = dev_id;
+	struct device *dev = dev_id;
 
-	pm_wakeup_event(&gphy->dev, 0);
+	pm_wakeup_event(dev, 0);
 
 	return IRQ_HANDLED;
 }
@@ -451,7 +451,7 @@ static int brcm_usb_phy_dvr_init(struct platform_device *pdev,
 	if (priv->wake_irq >= 0) {
 		err = devm_request_irq(dev, priv->wake_irq,
 				       brcm_usb_phy_wake_isr, 0,
-				       dev_name(dev), gphy);
+				       dev_name(dev), dev);
 		if (err < 0)
 			return err;
 		device_set_wakeup_capable(dev, 1);
-- 
2.35.1



