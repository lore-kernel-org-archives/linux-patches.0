Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D5C727FD53;
	Tue, 27 May 2025 17:24:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366698; cv=none; b=sdeav+NWwmv1/fPBOMkWNZV8IJcAr98/bWpuW7KdThaZzqT6F6OCxCTySugtZZAi9caTIP6uymcBLg7Sxr7+ripIDQau4IQyNyhWDRPebDZM6D79F5rBkNb9W7nwdmSZHHyLNQ7HTNpx2RZZ7Yqqs/+qWByOdF1tthhTLP4wKfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366698; c=relaxed/simple;
	bh=bSC0R+slH45Ev9KfEK6L4mTs3wFFpyTmFKqeQ0rJ/WA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zl+c6HdWvgk4gRlRjekQlujsODyleZSfghU1efzIh+MTlO7WS4usD2XWsEQz+gPbcMXV56q9Ok3zAKTKUyDpqHSC/CzOs6GIJKS6fCmZOJ2Ujzo11C+LpafxsVu6sof/F6MME74C/wUI4Bg5TGsSgii1KJpTFmiM0Qqcqw1WW24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oACiUgjl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oACiUgjl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0580C4CEEB;
	Tue, 27 May 2025 17:24:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366698;
	bh=bSC0R+slH45Ev9KfEK6L4mTs3wFFpyTmFKqeQ0rJ/WA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oACiUgjleAWU2VPdwulQw/XzL9hAAlW6xBLF6LIl20LvooikWgvZavT3SO+xDyBt1
	 aSlAY1/OxJhqg0AZjY260VX8ORqaTZyFEoks0GRseHHmpPtjESm3ShdQo2fuAFfPo1
	 OExsu0827F+vmmPlkYWSeYlj+FcHBKfpsYf6ZhbY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quan Zhou <quan.zhou@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 122/783] wifi: mt76: mt7925: Simplify HIF suspend handling to avoid suspend fail
Date: Tue, 27 May 2025 18:18:39 +0200
Message-ID: <20250527162518.113399351@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Quan Zhou <quan.zhou@mediatek.com>

[ Upstream commit bf39813599b0375a3eebbbc6837f728554b3883a ]

System suspend failures may occur due to inappropriate
handling of traffic not idle event by the WiFi driver.
The WiFi firmware's traffic not idle indication does
not need to be tied to suspend. Fix the flow to ensuring
the system can suspend properly.

Signed-off-by: Quan Zhou <quan.zhou@mediatek.com>
Link: https://patch.msgid.link/34208c7280325f57a651363d339399eb1744d3b7.1740400998.git.quan.zhou@mediatek.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7925/mcu.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
index 775ccd667dd3f..87b3a88038e3c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
@@ -348,14 +348,10 @@ mt7925_mcu_handle_hif_ctrl_basic(struct mt792x_dev *dev, struct tlv *tlv)
 	basic = (struct mt7925_mcu_hif_ctrl_basic_tlv *)tlv;
 
 	if (basic->hifsuspend) {
-		if (basic->hif_tx_traffic_status == HIF_TRAFFIC_IDLE &&
-		    basic->hif_rx_traffic_status == HIF_TRAFFIC_IDLE)
-			/* success */
-			dev->hif_idle = true;
-		else
-			/* busy */
-			/* invalid */
-			dev->hif_idle = false;
+		dev->hif_idle = true;
+		if (!(basic->hif_tx_traffic_status == HIF_TRAFFIC_IDLE &&
+		      basic->hif_rx_traffic_status == HIF_TRAFFIC_IDLE))
+			dev_info(dev->mt76.dev, "Hif traffic not idle.\n");
 	} else {
 		dev->hif_resumed = true;
 	}
-- 
2.39.5



