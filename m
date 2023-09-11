Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82CE111710
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 15:20:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05F70C433C7;
	Mon, 11 Sep 2023 15:20:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694445634;
	bh=ear1H/lr5VQwWIiI+Y8uSirAPETYDimRL0Hexp0tDDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0csCn4AprKjNviK7Grdu3WQ6uU1JJBpvzPTYC1V6uLzTT08Kz6ABa9UIlUYto6XQP
	 6xd0iAsdkicuW1m5oIHcLhmowkHHPC5r6sZ+mqeNcemACBHKWx/i3ak7Hm0l8UNCIE
	 cjXuIK5uLB5BGNWx/yCwAwKUZhsCdfiyLJzcGmNE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Yang <xu.yang_2@nxp.com>,
	Peter Chen <peter.chen@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 417/600] usb: phy: mxs: fix getting wrong state with mxs_phy_is_otg_host()
Date: Mon, 11 Sep 2023 15:47:30 +0200
Message-ID: <20230911134645.977616954@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134633.619970489@linuxfoundation.org>
References: <20230911134633.619970489@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Xu Yang <xu.yang_2@nxp.com>

[ Upstream commit 5eda42aebb7668b4dcff025cd3ccb0d3d7c53da6 ]

The function mxs_phy_is_otg_host() will return true if OTG_ID_VALUE is
0 at USBPHY_CTRL register. However, OTG_ID_VALUE will not reflect the real
state if the ID pin is float, such as Host-only or Type-C cases. The value
of OTG_ID_VALUE is always 1 which means device mode.
This patch will fix the issue by judging the current mode based on
last_event. The controller will update last_event in time.

Fixes: 7b09e67639d6 ("usb: phy: mxs: refine mxs_phy_disconnect_line")
Signed-off-by: Xu Yang <xu.yang_2@nxp.com>
Acked-by: Peter Chen <peter.chen@kernel.org>
Link: https://lore.kernel.org/r/20230627110353.1879477-2-xu.yang_2@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/phy/phy-mxs-usb.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/usb/phy/phy-mxs-usb.c b/drivers/usb/phy/phy-mxs-usb.c
index d2836ef5d15c7..9299df53eb9df 100644
--- a/drivers/usb/phy/phy-mxs-usb.c
+++ b/drivers/usb/phy/phy-mxs-usb.c
@@ -388,14 +388,8 @@ static void __mxs_phy_disconnect_line(struct mxs_phy *mxs_phy, bool disconnect)
 
 static bool mxs_phy_is_otg_host(struct mxs_phy *mxs_phy)
 {
-	void __iomem *base = mxs_phy->phy.io_priv;
-	u32 phyctrl = readl(base + HW_USBPHY_CTRL);
-
-	if (IS_ENABLED(CONFIG_USB_OTG) &&
-			!(phyctrl & BM_USBPHY_CTRL_OTG_ID_VALUE))
-		return true;
-
-	return false;
+	return IS_ENABLED(CONFIG_USB_OTG) &&
+		mxs_phy->phy.last_event == USB_EVENT_ID;
 }
 
 static void mxs_phy_disconnect_line(struct mxs_phy *mxs_phy, bool on)
-- 
2.40.1



