Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6E08F4F1;
	Sat, 12 Sep 2026 16:29:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789230557; cv=none; b=PaJ4jaSfVENIkepuxxb5tY5ibggBFlhzI8zSttA8bIr4vq032NPaacaieVrrRTFJsHW5A3SCZBZIEg1mPOIDv6GeydcT7vYwn1Fmy3/wHpTdAKuAz9HW5/wzPrMtT95RZ3zMOyNa/ENyNsjeq2LXQjRuVfC5CjqpuJYbVct6nCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789230557; c=relaxed/simple;
	bh=ganYfWtQGEcLBQp6Hpg/e3Z0x/3poP3rA0A/Ye0dx3U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FjlPEMWllR4psH8iswPGAasXLeKaj+fPUVFMGQywVOGVAdOztuYQZ2ro8Hb9noPzSqmPBsFMP+biq9qigr63CXaGHnZjZ97E3cwH/3rZWGy7+LqrNYZbnWURiWwmSEad4cDbb1IlKOJW4UjRso+3PuNPiPf63m/5ICcYMWR2Rvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1IAIHQtT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1IAIHQtT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 483A41F000FF;
	Sat, 12 Sep 2026 16:29:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789230556;
	bh=J8srSptl1ERc6ahlRSIicSiB1LMGYw4I6lPOkZEG/i8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1IAIHQtTLTJjn/DR5OwU86vPNNCPnoi51fs22savq+WJQwB421MSB9Fg8W3i8An2h
	 yPkbUP983zmdxUYbNm+THt3/CVL7NT89F4aLBh5s0kY5g09b/NFjlt1jfSDY/rCNF/
	 r5vzwPCCRqU9pQ2fY66C8pApGDoO2FAzDAMrVzoA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0817/1191] wifi: mt76: mt7915: unlink TWT flow if the MCU rejects the agreement
Date: Sat, 12 Sep 2026 08:59:05 +0200
Message-ID: <20260912065606.620096620@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 36c4bfb7776b1..f4f8953254970 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
@@ -2125,8 +2125,10 @@ void mt7915_mac_add_twt_setup(struct ieee80211_hw *hw,
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



