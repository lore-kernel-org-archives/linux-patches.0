Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3F7942B30E;
	Thu, 16 Jul 2026 13:50:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209851; cv=none; b=mTcvHnx73xze2kJy8w8+GKtTRCidJHCBSy9/qtug0ix9u/62MiXl02Jqa8GT0nsFH5fRHCQ9ucDBozUKZ+XncG3kmTxJhTd3EETMFMnnefFKLQrcKu0WBwR3EMvQHFGj+SydCC51P9XCaEEPCcCNyNP9O9F9k0gMybc2VEe6jgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209851; c=relaxed/simple;
	bh=ArQ9rnSUSjcxyZ9hC0q3vbQCYjgtKW6jRL5a9sR+oWU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hw3NKiIf37fgqLAejgyNDa9iHb9yphwt5AR966uyI/UqSlPiq8xgwaUmDZFjCn4TbYrEbkUrsMUu40ebJDBGV2D8mOGjlHSzoUY64wIA8DDF93iHb5uAtFajNZiK7LtjH0YdXyX8NYcaEAq6Do9qPWK7945ei9dgdEPnD7ioemo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cHRF9DY7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cHRF9DY7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E35751F00A3A;
	Thu, 16 Jul 2026 13:50:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209849;
	bh=sQXyXktmRwdV28xpGceshEF/JNFts0ziqizCyo4+KEI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cHRF9DY7OUMbIUxRihEmpqEfoiWBHuUGaQ43J8L0+mMJWNihEwvSpPVR7ZW74AWrQ
	 QSb2JWtDXAqc9IzHoUr67567XT4qREwC+l4Wxfaxemfv1AOoYwHQgre1xEbDR5dUm9
	 RRzPAbVGMRqWtWuC+PdaUHv4a7T1abVA1KnwtN0o=
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
Subject: [PATCH 7.1 341/518] wifi: mt76: mt7921/mt7925: fix NULL dereference in CSA beacon
Date: Thu, 16 Jul 2026 15:30:09 +0200
Message-ID: <20260716133055.277340106@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/net/wireless/mediatek/mt76/mt7925/main.c | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/main.c b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
index 3d74fabe74085e..a326f4c95c7c86 100644
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
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/main.c b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
index 79cc30a3b29efc..9dc5ee51eb9f96 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
@@ -2403,6 +2403,9 @@ static void mt7925_channel_switch_rx_beacon(struct ieee80211_hw *hw,
 	if (ieee80211_vif_is_mld(vif))
 		return;
 
+	if (!dev->new_ctx)
+		return;
+
 	beacon_interval = vif->bss_conf.beacon_int;
 
 	if (cfg80211_chandef_identical(&chsw->chandef,
-- 
2.53.0



