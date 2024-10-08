Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E90271D618C;
	Tue,  8 Oct 2024 12:18:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728389908; cv=none; b=rLj74oXwlO8EDzZ0U/UdmlzIQvoGYe/VtsuY/cfi8dfaPF6eOvqW9JuBtjaw2+pmg/pk5zXcfR9c/bAkrS/xRTpZlfDHQLB+Od1CIxiBq6M/vGU0lG5jdOSUfjof5zPy56Ws45ZfgDsJtOCO5KRKMiIcOmpkq1AUlx9l1WYUafo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728389908; c=relaxed/simple;
	bh=fjpH2pav6SCIekS6x1+6gVGVjkGT/oFs0OD8mniYs4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qe6I+k0N/+hXztTGWo52RMfnEVaI+T1vJeYKv7TlGr9Kgrliel3cR6vlvob2EV5mmGD78D12W+jT059SGMN0qrylLK7dkZirpxO2F0gjN4QPj3KNC6QehLGexyNgloXxrYwfLurCdtwQ3Mr6+aiSPDmdDtrVSOiXWP1IHTvR6xY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XgE6Z11Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XgE6Z11Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58431C4CEC7;
	Tue,  8 Oct 2024 12:18:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728389907;
	bh=fjpH2pav6SCIekS6x1+6gVGVjkGT/oFs0OD8mniYs4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XgE6Z11Z2/ulQBGKcf5SU+T7Gu6lDvZpwJeLFyurenaKW/iT7fUkJbb46iC9mD5OJ
	 D/FH7qMMJkTUIIMbYfly8vcRc/qSfRWoePyYzbX3LgAyouhFpF175bJBcAIpmRk0aW
	 VzlZnY6DLCLHO8nzodE5FOfek/vcPD2fGfRQ/al8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Lin <benjamin-jw.lin@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 133/482] wifi: mt76: mt7915: add dummy HW offload of IEEE 802.11 fragmentation
Date: Tue,  8 Oct 2024 14:03:16 +0200
Message-ID: <20241008115653.538467290@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index eea41b29f0967..3b2dcb410e0f0 100644
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



