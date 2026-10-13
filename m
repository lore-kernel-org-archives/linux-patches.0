Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E3CC4F648C;
	Tue, 13 Oct 2026 12:14:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893652; cv=none; b=t7hoqXVqIsOrT5SKG29LYi/77oQFbG4dNw7Hc4xzNHIcnawkKR5VZw+hubEFupL73gffv0LXNeqaFN3Ka996vW4rbuOStOFH8Hqz2AAEjGdDwVN/TszhyvoKA3WAGRFX90Zi8gPEmwC67mOwmNXDy/sQZW4zYzrSK+w45kpL470=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893652; c=relaxed/simple;
	bh=I8/F29sKQyDQCHlifnEY8xfXP+1FL8a1xSAxttUvSzk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ckJimpIiiUll40GK7rnfo7bT8mk/CBi5m7kXtWZkd1WDQXE+z+jmUErkeN6DvqxnwK/dSis7raImYL61Y5jzn0DnRJBSLm6jnQ0wwPxeEN06bqFTUJzrZJOfbsHMm6SrRwGhpK/7qN+dQYiW+iO3XXTm1HfECEQjrOM5uRkE59s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i5E/pyCC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i5E/pyCC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC5231F00898;
	Tue, 13 Oct 2026 12:14:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893651;
	bh=c+Tk+Z9AqXjn7PeEzBqHkAiugBa9Ly+EKeoMg1EWAxQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i5E/pyCCLID4nQrxtvN7hOm0G7PTzQHvJ0mir8z0moDv9yO65GtALD9l1fekwRY48
	 7vfxNeISzdiqzE/o08WoIGMLvm2MD5legeSCzHZcQN1gC4u8WpzcC2HV0gKU539YmE
	 5pEWvqKU1z1dfsEIRtZmCe8ohSvcGPfZ7epjJb5Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bongani Hlope <developer@hlope.org.za>,
	Arjan van de Ven <arjan@linux.intel.com>,
	linux-wireless@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 253/621] wifi: mt76: mt7921/mt7925: fix NULL dereference in CSA beacon
Date: Tue, 13 Oct 2026 13:34:08 +0200
Message-ID: <20261013112926.865253807@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

From: Arjan van de Ven <arjan@linux.intel.com>

[ Upstream commit 351dd7d2c80d23e56dcce6faa4e62bea5b0877c7 ]

This patch is based on a BUG as reported by Bongani Hlope at
https://lore.kernel.org/all/20260502125824.425d7159@bongani-mini.home.org.za/

When a channel-switch announcement (CSA) beacon is received,
cfg80211 queues a wiphy work item that eventually calls
mt7921_channel_switch_rx_beacon(). If the station disconnects
(or the channel context is otherwise torn down) between the
time the work is queued and the time it runs, the driver's
dev->new_ctx pointer can already have been cleared to NULL.
mt7921_channel_switch_rx_beacon() then dereferences new_ctx
unconditionally, triggering a NULL pointer dereference at
address 0x0:

  BUG: kernel NULL pointer dereference, address: 0000000000000000
  RIP: 0010:mt7921_channel_switch_rx_beacon+0x1f/0x100 [mt7921_common]

The same missing guard exists in mt7925_channel_switch_rx_beacon(),
which shares the same code pattern introduced by the same commit.

Add an early-return NULL check for dev->new_ctx in both
mt7921_channel_switch_rx_beacon() and
mt7925_channel_switch_rx_beacon(). When new_ctx is NULL there is
no pending channel switch to process, so returning immediately is
the correct and safe action.

Fixes: 8aa2f59260eb ("wifi: mt76: mt7921: introduce CSA support")
Reported-by: Bongani Hlope <developer@hlope.org.za>
Oops-Analysis: http://oops.fenrus.org/reports/lkml/20260502125824.425d7159@bongani-mini.home.org.za/report.html
Link: https://lore.kernel.org/all/20260502125824.425d7159@bongani-mini.home.org.za/
Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Cc: linux-wireless@vger.kernel.org
Cc: linux-mediatek@lists.infradead.org
Cc: Felix Fietkau <nbd@nbd.name>
Cc: Lorenzo Bianconi <lorenzo@kernel.org>
Cc: Ryder Lee <ryder.lee@mediatek.com>
Link: https://patch.msgid.link/20260504145107.1329197-1-arjan@linux.intel.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7921/main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/main.c b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
index ce11666a32db9..35ece0f617337 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
@@ -1508,6 +1508,9 @@ static void mt7921_channel_switch_rx_beacon(struct ieee80211_hw *hw,
 	struct mt792x_vif *mvif = (struct mt792x_vif *)vif->drv_priv;
 	u16 beacon_interval = vif->bss_conf.beacon_int;
 
+	if (!dev->new_ctx)
+		return;
+
 	if (cfg80211_chandef_identical(&chsw->chandef,
 				       &dev->new_ctx->def) &&
 				       chsw->count) {
-- 
2.53.0



