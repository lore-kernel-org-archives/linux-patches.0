Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 455691170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 13:55:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4F6DC433C7;
	Mon, 11 Sep 2023 13:55:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694440506;
	bh=JqL5N+Cq3gxhLx0eYtaKxpvLpm5//cvRVyKcgfFYTQk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KnHOotjzToSM6WQvDf+Bph/A0FVtEEhC3SPOhIua4JF9FT+dV9SSfBQPTnaGxtbN/
	 NhQGeIZc33U48NotrzeaQ4HTkUdZ+a7fpnLh5vlQ8yIotzouBfdX0q19/d035Xhanc
	 yssmHAjjYHgwebIUPGh/tlkqN93MoNFqdD4wRQyw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	StanleyYP Wang <StanleyYP.Wang@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 086/739] wifi: mt76: mt7996: use correct phy for background radar event
Date: Mon, 11 Sep 2023 15:38:05 +0200
Message-ID: <20230911134653.510371462@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: StanleyYP Wang <StanleyYP.Wang@mediatek.com>

[ Upstream commit 9ffe0d5690ed916e09baad2cc9ee7ec65b110038 ]

If driver directly uses the band_idx reported from the radar event to
access mt76_phy array, it will get the wrong phy for background radar.
Fix this by adjusting the statement.

Fixes: 98686cd21624 ("wifi: mt76: mt7996: add driver for MediaTek Wi-Fi 7 (802.11be) devices")
Signed-off-by: StanleyYP Wang <StanleyYP.Wang@mediatek.com>
Signed-off-by: Shayne Chen <shayne.chen@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
index cd54e81d73044..62a02b03d83ba 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
@@ -339,7 +339,11 @@ mt7996_mcu_rx_radar_detected(struct mt7996_dev *dev, struct sk_buff *skb)
 	if (r->band_idx >= ARRAY_SIZE(dev->mt76.phys))
 		return;
 
-	mphy = dev->mt76.phys[r->band_idx];
+	if (dev->rdd2_phy && r->band_idx == MT_RX_SEL2)
+		mphy = dev->rdd2_phy->mt76;
+	else
+		mphy = dev->mt76.phys[r->band_idx];
+
 	if (!mphy)
 		return;
 
-- 
2.40.1



