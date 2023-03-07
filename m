Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B527BA32
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:18:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B493DC4339B;
	Tue,  7 Mar 2023 17:18:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678209510;
	bh=50qVl4IelpB/83UIieJwXxhTZNny5Gbz1zMt1gE2dms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fB2w0HZxfS5KedrR0NrNjciMJExKouynAc/TLDJhJL56qkLgjtESZhqm6xKZZzlZt
	 ij3DKhj7JkH9KrMPUZI6/U/uOMruOPsjA/s6nZws+gtXUVTsWgZEwCDu8H0fzi7B6q
	 hUBLmIo2oNbG6NfTT4WlZABZAiyVG+gY0vu5K7yQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shayne Chen <shayne.chen@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0242/1001] wifi: mt76: mt7996: fix chainmask calculation in mt7996_set_antenna()
Date: Tue,  7 Mar 2023 17:50:14 +0100
Message-Id: <20230307170032.311753095@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Shayne Chen <shayne.chen@mediatek.com>

[ Upstream commit eb1fdb9f5a2280de6820624cd02e0863babab683 ]

Fix per-band chainmask when restoring from the dev chainmask.

Fixes: 98686cd21624 ("wifi: mt76: mt7996: add driver for MediaTek Wi-Fi 7 (802.11be) devices")
Signed-off-by: Shayne Chen <shayne.chen@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/main.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
index 4421cd54311b1..c423b052e4f4c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -880,7 +880,10 @@ mt7996_set_antenna(struct ieee80211_hw *hw, u32 tx_ant, u32 rx_ant)
 	phy->mt76->antenna_mask = tx_ant;
 
 	/* restore to the origin chainmask which might have auxiliary path */
-	if (hweight8(tx_ant) == max_nss)
+	if (hweight8(tx_ant) == max_nss && band_idx < MT_BAND2)
+		phy->mt76->chainmask = ((dev->chainmask >> shift) &
+					(BIT(dev->chainshift[band_idx + 1] - shift) - 1)) << shift;
+	else if (hweight8(tx_ant) == max_nss)
 		phy->mt76->chainmask = (dev->chainmask >> shift) << shift;
 	else
 		phy->mt76->chainmask = tx_ant << shift;
-- 
2.39.2



