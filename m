Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44B1E168A7
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:38:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEC72C433EF;
	Mon,  8 May 2023 10:38:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683542322;
	bh=fDNjLBzfkeNTON5UsQdQ7w9YAOaP1hcpfy420oy+NiI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jieO4k8HKrqV39vgDUWD0CHZPoQidm0Cx8xGQwh/9Qf6dc9nQZvLJggby8otWYOHM
	 LX5+y4ijBU7HdoHHX5pQdXb8YZpC6geE3oHUFUECrMJGF31Lz8pya3NpOwJIKRAw1I
	 wHtPCw+BPdB/+TnNA6R+961pELcF7HIUwAIwFW6Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Greear <greearb@candelatech.com>,
	Isaac Konikoff <konikofi@candelatech.com>,
	Ming Yen Hsieh <mingyen.hsieh@mediatek.com>,
	Deren Wu <deren.wu@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 399/663] wifi: mt76: fix 6GHz high channel not be scanned
Date: Mon,  8 May 2023 11:43:45 +0200
Message-Id: <20230508094441.033648372@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094428.384831245@linuxfoundation.org>
References: <20230508094428.384831245@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ming Yen Hsieh <mingyen.hsieh@mediatek.com>

[ Upstream commit 23792cedaff02351b57bddd8957fc917fa88f2e0 ]

mt76 scan command only support 64 channels currently. If the
channel count is larger than 64(for 2+5+6GHz), some channels will
not be scanned. Hence change the scan type to full channel scan
in case of the command cannot include proper list for chip.

Fixes: 399090ef9605 ("mt76: mt76_connac: move hw_scan and sched_scan routine in mt76_connac_mcu module")
Reported-by: Ben Greear <greearb@candelatech.com>
Tested-by: Isaac Konikoff <konikofi@candelatech.com>
Signed-off-by: Ming Yen Hsieh <mingyen.hsieh@mediatek.com>
Signed-off-by: Deren Wu <deren.wu@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt76_connac_mcu.c    | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
index d106cbfc387c8..b678820ba6327 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
@@ -1632,8 +1632,16 @@ int mt76_connac_mcu_hw_scan(struct mt76_phy *phy, struct ieee80211_vif *vif,
 	req->channel_min_dwell_time = cpu_to_le16(duration);
 	req->channel_dwell_time = cpu_to_le16(duration);
 
-	req->channels_num = min_t(u8, sreq->n_channels, 32);
-	req->ext_channels_num = min_t(u8, ext_channels_num, 32);
+	if (sreq->n_channels == 0 || sreq->n_channels > 64) {
+		req->channel_type = 0;
+		req->channels_num = 0;
+		req->ext_channels_num = 0;
+	} else {
+		req->channel_type = 4;
+		req->channels_num = min_t(u8, sreq->n_channels, 32);
+		req->ext_channels_num = min_t(u8, ext_channels_num, 32);
+	}
+
 	for (i = 0; i < req->channels_num + req->ext_channels_num; i++) {
 		if (i >= 32)
 			chan = &req->ext_channels[i - 32];
@@ -1653,7 +1661,6 @@ int mt76_connac_mcu_hw_scan(struct mt76_phy *phy, struct ieee80211_vif *vif,
 		}
 		chan->channel_num = scan_list[i]->hw_value;
 	}
-	req->channel_type = sreq->n_channels ? 4 : 0;
 
 	if (sreq->ie_len > 0) {
 		memcpy(req->ies, sreq->ie, sreq->ie_len);
-- 
2.39.2



