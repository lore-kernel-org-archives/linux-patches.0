Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68B051868
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:02:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E13E9C433EF;
	Wed, 28 Dec 2022 15:02:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672239767;
	bh=h0IEwXda+EjroiBPLPlZxFoKkZG2lqNiJJ+R5Y6/wiI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wG9Kf1DMo9oD2K4EUub6iQEThxPc24xWwvExWuclk5xJI5SEA8O5xyHMBZBpdI3fm
	 oJklJoG8QtFGVCt5mkKDIztn6RAEvDZqNqyPwTFmsRXaSGyl0IGxDQUm1hNsT57JYM
	 tPqNtuEYPOYb2iDN8dEzOoSL4Bt6d1CFsH0PZeGs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xing Song <xing.song@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 268/731] mt76: stop the radar detector after leaving dfs channel
Date: Wed, 28 Dec 2022 15:36:15 +0100
Message-Id: <20221228144304.336776420@linuxfoundation.org>
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

From: Xing Song <xing.song@mediatek.com>

[ Upstream commit 4e58ef4b6d727abdb071f7799aef763f8d6f2ad8 ]

The radar detctor is used for dfs channel. So it will start after switching
to dfs channel and will stop after leaving. The TX will be blocked if radar
detctor isn't stopped in non-dfs channel.

This patch resets the dfs state to indicate the radar detector needs to be
stopped.

Signed-off-by: Xing Song <xing.song@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7615/main.c | 3 ++-
 drivers/net/wireless/mediatek/mt76/mt7915/main.c | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/main.c b/drivers/net/wireless/mediatek/mt76/mt7615/main.c
index 8f1338dae211..96667b7d722d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/main.c
@@ -290,7 +290,8 @@ static void mt7615_init_dfs_state(struct mt7615_phy *phy)
 	if (hw->conf.flags & IEEE80211_CONF_OFFCHANNEL)
 		return;
 
-	if (!(chandef->chan->flags & IEEE80211_CHAN_RADAR))
+	if (!(chandef->chan->flags & IEEE80211_CHAN_RADAR) &&
+	    !(mphy->chandef.chan->flags & IEEE80211_CHAN_RADAR))
 		return;
 
 	if (mphy->chandef.chan->center_freq == chandef->chan->center_freq &&
diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/main.c b/drivers/net/wireless/mediatek/mt76/mt7915/main.c
index 6aca470e2401..7a4f277a1622 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/main.c
@@ -302,7 +302,8 @@ static void mt7915_init_dfs_state(struct mt7915_phy *phy)
 	if (hw->conf.flags & IEEE80211_CONF_OFFCHANNEL)
 		return;
 
-	if (!(chandef->chan->flags & IEEE80211_CHAN_RADAR))
+	if (!(chandef->chan->flags & IEEE80211_CHAN_RADAR) &&
+	    !(mphy->chandef.chan->flags & IEEE80211_CHAN_RADAR))
 		return;
 
 	if (mphy->chandef.chan->center_freq == chandef->chan->center_freq &&
-- 
2.35.1



