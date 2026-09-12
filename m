Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6C5D2594BD;
	Sat, 12 Sep 2026 10:38:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209490; cv=none; b=Cznhis2KfHcj5+hIsOHYddO1GttPgSPsU/dYC9PV4mbiFtG66a3vYKo6DcoZvBWrQWzP016OlGBaBC/cHY1BaPUVIYDUXu4WhlhApD/LXrYnfn08sk7L9edJvtbcwf8wqQyIr9dDr/OOA0V/CzQ63TLao+cZky7Mi7pJ8YX/oM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209490; c=relaxed/simple;
	bh=6VAvO/bnwc5wM7vYg9mimXHnFVqEYICEruCmbZkkgy8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FUa/Sds52916VpIonpNqKMs2XZaiYI3Zg2oRe43VBG3sS+0UnMKA3Y17mhTra9ZXKGjFLTyd7a/w6dMtjsnOCy16Hf1LYwchrbIPljF0oleL2muf8arBDfw2hkQFSaLE4R6lzYr3fT3H3hFfnPxY4gqMdjN75aTW/8KX9IufJS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GosAVomo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GosAVomo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5DD01F000FF;
	Sat, 12 Sep 2026 10:38:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209488;
	bh=4Q6s0TBe19QrhylF0cKQF3o/BUzOD2iSLAtgieb4NEA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GosAVomoml2oKtDOMDBIoy6cz1l2fU5XVmm+0FSnhph3UxdTY8cKzj1KX/Op5k0d3
	 NbLBYi4KZ/RAqVBANvfcT8xd/ogFZdKydm2/ybwt+sF8iFkCW4FP8uQCvoEpeyyrr5
	 a368Z+Tzui+eS5Ecbs1LWZd/OgfYz6mDkg0V9PZs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0788/1518] wifi: mt76: mt7915: unlink TWT flow if the MCU rejects the agreement
Date: Sat, 12 Sep 2026 08:49:17 +0200
Message-ID: <20260912065641.260715497@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 16a04441eab0dcd4d7126a6f66b370adbf28f96d ]

The flow is added to dev->twt_list before sending the agreement to the
firmware, but the error path leaves it linked while flowid_mask is
never set. The flow slot can then be reused and memset while still on
the list, corrupting twt_list, and station removal leaves a dangling
entry behind that mt7915_mac_twt_sched_list_add() later walks.

Fixes: 3782b69d03e7 ("mt76: mt7915: introduce mt7915_mac_add_twt_setup routine")
Link: https://patch.msgid.link/20260724124813.3961474-17-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/mac.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
index 50af0d9f240b6..d79af9321ec79 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
@@ -2345,8 +2345,10 @@ void mt7915_mac_add_twt_setup(struct ieee80211_hw *hw,
 	}
 	flow->tsf = le64_to_cpu(twt_agrt->twt);
 
-	if (mt7915_mcu_twt_agrt_update(dev, msta->vif, flow, MCU_TWT_AGRT_ADD))
+	if (mt7915_mcu_twt_agrt_update(dev, msta->vif, flow, MCU_TWT_AGRT_ADD)) {
+		list_del(&flow->list);
 		goto unlock;
+	}
 
 	setup_cmd = TWT_SETUP_CMD_ACCEPT;
 	dev->twt.table_mask |= BIT(table_id);
-- 
2.53.0



