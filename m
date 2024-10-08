Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75AE21DE2CF;
	Tue,  8 Oct 2024 12:46:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391585; cv=none; b=FNGWDkOOligiDRb6ngYrlmxmGmjA/7YUmDXm7cp1gUTHDDiXd+/O24yDDRfg/gbfIpNnTIL4rrKq/P2IMyNauNX4BaLAvL0hxJrX+luLIO0486yh6yEIcrLjFCPLdgoIVZ3mKK5ULIYBI2c2FmXMFyZ8VquOrOxjh8TlIknrvpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391585; c=relaxed/simple;
	bh=bOIwAZsZbk19DyaUiFaJk+mnD0Z3dTrDV1Kf9hv0mj0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kaWa9YFCixTIbGLsvcytNdgx4lSotpeJq2K361Ba9dht0bgIDrSelHF5XiGo9iI4U8xacxu3VOENygB1808QwOLFtySzqzWuxQXjjFDq0ZEOAyJbgjN56vihkSR8a47+yo7Sp4gboV5DwEGRGGQHeTOzqMsi3PlhGGzBPj7B6Tw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ha8GDDcs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ha8GDDcs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6A86C4CEC7;
	Tue,  8 Oct 2024 12:46:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391585;
	bh=bOIwAZsZbk19DyaUiFaJk+mnD0Z3dTrDV1Kf9hv0mj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ha8GDDcsUhCdCYq/RjxlNF38a+MGhWVm3Hsj3IqnnGPp4Rt47hm+049HXTLvkhzjd
	 k3TKm+b9DhT62az0bvsnPF92O1CyRjTMsSDVUZMX24dvWXKA41qCuMP7+1dJbi7n92
	 nAHXQYJWlnOhd2ESnIiWYrrDfpeDpZ57iYrgm4x4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Lin <benjamin-jw.lin@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 160/558] wifi: mt76: mt7915: add dummy HW offload of IEEE 802.11 fragmentation
Date: Tue,  8 Oct 2024 14:03:10 +0200
Message-ID: <20241008115708.656660189@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Lin <benjamin-jw.lin@mediatek.com>

[ Upstream commit f2cc859149240d910fdc6405717673e0b84bfda8 ]

Currently, CONNAC2 series do not support encryption for fragmented Tx frames.
Therefore, add dummy function mt7915_set_frag_threshold() to prevent SW
IEEE 802.11 fragmentation.

Signed-off-by: Benjamin Lin <benjamin-jw.lin@mediatek.com>
Link: https://patch.msgid.link/20240827093011.18621-16-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/init.c | 1 +
 drivers/net/wireless/mediatek/mt76/mt7915/main.c | 7 +++++++
 2 files changed, 8 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/init.c b/drivers/net/wireless/mediatek/mt76/mt7915/init.c
index 7bc3b4cd35925..6bef96e3d2a3d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/init.c
@@ -400,6 +400,7 @@ mt7915_init_wiphy(struct mt7915_phy *phy)
 	ieee80211_hw_set(hw, SUPPORTS_RX_DECAP_OFFLOAD);
 	ieee80211_hw_set(hw, SUPPORTS_MULTI_BSSID);
 	ieee80211_hw_set(hw, WANT_MONITOR_VIF);
+	ieee80211_hw_set(hw, SUPPORTS_TX_FRAG);
 
 	hw->max_tx_fragments = 4;
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/main.c b/drivers/net/wireless/mediatek/mt76/mt7915/main.c
index efbb8b23e4719..e094358005799 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/main.c
@@ -1577,6 +1577,12 @@ mt7915_twt_teardown_request(struct ieee80211_hw *hw,
 	mutex_unlock(&dev->mt76.mutex);
 }
 
+static int
+mt7915_set_frag_threshold(struct ieee80211_hw *hw, u32 val)
+{
+	return 0;
+}
+
 static int
 mt7915_set_radar_background(struct ieee80211_hw *hw,
 			    struct cfg80211_chan_def *chandef)
@@ -1707,6 +1713,7 @@ const struct ieee80211_ops mt7915_ops = {
 	.sta_set_decap_offload = mt7915_sta_set_decap_offload,
 	.add_twt_setup = mt7915_mac_add_twt_setup,
 	.twt_teardown_request = mt7915_twt_teardown_request,
+	.set_frag_threshold = mt7915_set_frag_threshold,
 	CFG80211_TESTMODE_CMD(mt76_testmode_cmd)
 	CFG80211_TESTMODE_DUMP(mt76_testmode_dump)
 #ifdef CONFIG_MAC80211_DEBUGFS
-- 
2.43.0



