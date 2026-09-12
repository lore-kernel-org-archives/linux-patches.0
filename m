Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 139AB19E7F7;
	Sat, 12 Sep 2026 08:18:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201137; cv=none; b=nOWk3iKFdNfLxy2j0bH/rynLftsCs8ZOmGfCxquiNB2lfHcJ3OMOVZAJASnDSMpnIaGcILTGWCdUYX2SI/rfFh8oSP+mLftfevWbEjgSHDkuLEAXUkQRclcAKkWCPEKsPgUkbPkkLYzcHXH1olAeQFcdZMH2x8gMQfYROy1TbvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201137; c=relaxed/simple;
	bh=ncBpSUFfccxaL3UQE8KXi7gsK9X2WZ4dbpUX14M9ytI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gl9W6KlYm0NcuHpI9G9XoiBb8oVk9D8Mm5IiiZHo1tIR8IHncZPayHbY2mEY/ahaVNaWfhH7UVaFM95P4NYlr0DvbYseqmjjNZzaVR1/XZ6QktzufEBGAWDp+9zm0U7ZNnPVqPs1g2IJDKakh+9UNr63U5yNCqTdpZ+FT4Pp8sk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0N6kJm3h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0N6kJm3h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6A1F1F000FF;
	Sat, 12 Sep 2026 08:18:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201135;
	bh=b21pYmAYIhVBbdh6kN8VG7NR1gt0K52ewstSXySN8nM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0N6kJm3hLBgxsunMeQQ9/IGo90/MHxt3tP/tNMVzxa5JP8XpCrXXxUobY/SP6gPj9
	 czFHJEwIFyo04tMLeNo8CQfe2UvJEEem+jZQt2Jpg2ovFbOSAavWY1hmnfLrBo4ps+
	 5XwBCb1nFsHZ2qUJnSw/Ue18Wf5Jb7RGsU2qdn0E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0934/1815] wifi: mt76: mt7915: unlink TWT flow if the MCU rejects the agreement
Date: Sat, 12 Sep 2026 08:44:44 +0200
Message-ID: <20260912065710.879651432@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 1913c7613909e..31d231a033e75 100644
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



