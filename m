Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85E422A1BF;
	Tue, 26 Aug 2025 14:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218620; cv=none; b=jBnDgw15QswGx7aZS5Po8bg61BB8BjTnYxYSWPygbp3mU+Weddh2WkVauaivlSdN+6P3iJixNcEQm3NgsLLRi6w50DmGmu2wRrCLXdT2oJDJrc9vyzU17dtiMh0HQiGmfMl2N01Pze0ryL29f2+BQOvl2C0ArX8/73N2oa2ivJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218620; c=relaxed/simple;
	bh=usYs1/DGh60cPwPczKl53Hg/u05vM71rYrkWJAWlPBA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TYGiMz/rHvxJ1Nkuv0tSwpysCD9eYRhXP7qn0u3lIubit4bBkogJAIjC0+cUEl758ifWebR9K0SQiiPUSDeTQg2mEvhNFIbMT6qZimH7fCDju19nu8ZJUoZaSJjvT0/MrIwwtrhcYRfMKZq6Yyi0uEZdsYL4p3dm2+HFNd7fG9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fvHmneYT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fvHmneYT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16DE4C4CEF1;
	Tue, 26 Aug 2025 14:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218620;
	bh=usYs1/DGh60cPwPczKl53Hg/u05vM71rYrkWJAWlPBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fvHmneYTh8iZWF8/Fm6FbHOfqgUav/HYtQAiY+SR1E6SCmuiXLBZsCeuAHrxRjrJi
	 cD3eDsr3/MaV3j9HNRK61dNzfSjNWjzY0wzfXaFMXkx6FwDCn7UxI1/Vs1lHCsKjkY
	 I4t1X58f4H+7kTGSbj5eDOU1LTHXX9+EWESnRj4A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Yang <xu.yang_2@nxp.com>,
	Peter Chen <peter.chen@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 069/403] usb: phy: mxs: disconnect line when USB charger is attached
Date: Tue, 26 Aug 2025 13:06:35 +0200
Message-ID: <20250826110908.084020709@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xu Yang <xu.yang_2@nxp.com>

[ Upstream commit 87ed257acb0934e08644568df6495988631afd4c ]

For mxs PHY, if there is a vbus but the bus is not enumerated, we need
to force the dp/dm as SE0 from the controller side. If not, there is
possible USB wakeup due to unstable dp/dm, since there is possible no
pull on dp/dm, such as there is a USB charger on the port.

Signed-off-by: Xu Yang <xu.yang_2@nxp.com>
Acked-by: Peter Chen <peter.chen@kernel.org>
Link: https://lore.kernel.org/r/20230627110353.1879477-3-xu.yang_2@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/phy/phy-mxs-usb.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/phy/phy-mxs-usb.c b/drivers/usb/phy/phy-mxs-usb.c
index 6dfecbd47d7a..7c81ccaaf2e9 100644
--- a/drivers/usb/phy/phy-mxs-usb.c
+++ b/drivers/usb/phy/phy-mxs-usb.c
@@ -394,6 +394,7 @@ static bool mxs_phy_is_otg_host(struct mxs_phy *mxs_phy)
 static void mxs_phy_disconnect_line(struct mxs_phy *mxs_phy, bool on)
 {
 	bool vbus_is_on = false;
+	enum usb_phy_events last_event = mxs_phy->phy.last_event;
 
 	/* If the SoCs don't need to disconnect line without vbus, quit */
 	if (!(mxs_phy->data->flags & MXS_PHY_DISCONNECT_LINE_WITHOUT_VBUS))
@@ -405,7 +406,8 @@ static void mxs_phy_disconnect_line(struct mxs_phy *mxs_phy, bool on)
 
 	vbus_is_on = mxs_phy_get_vbus_status(mxs_phy);
 
-	if (on && !vbus_is_on && !mxs_phy_is_otg_host(mxs_phy))
+	if (on && ((!vbus_is_on && !mxs_phy_is_otg_host(mxs_phy))
+		|| (last_event == USB_EVENT_VBUS)))
 		__mxs_phy_disconnect_line(mxs_phy, true);
 	else
 		__mxs_phy_disconnect_line(mxs_phy, false);
-- 
2.39.5



