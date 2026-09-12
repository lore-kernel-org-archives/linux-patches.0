Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED2E5373BF2;
	Sat, 12 Sep 2026 12:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789216820; cv=none; b=on8uRlTG+nc4ybkz6Qo714XtB8DaRUxWqB/6LMSkp6UrT1Wy3idJPW4jN20doHGQlJTIPUEFgC+gmum+6YL+6fAm7K9UZdUzw0z941BTZj1f4XAnAUZt5sFoVtlQ7G/ka2UbFpOUYh8F0pc0lK0ViXKtbsvOpLGN/rMF/iRodkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789216820; c=relaxed/simple;
	bh=TowEHWrf5dhhLzDyGoIvfjVgXp4feA56DZr1kRsSU6g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CMtISE+3gQPJiScrHau/TMqp5JlnierR90rif1FOOvdZjwmwx3tfdIY/we4uhA6o9Z16tAU1dVoNngmfVyW3nHTbSNfx0RHuBYFEfQLwj8JxdB7NyrW93lbMXh9P7ObLOwYvhyHUi57K5+NhQbOBd4pJ4AJFf2msLaB9ayZbUUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0zUBWcsn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0zUBWcsn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E24A1F000FF;
	Sat, 12 Sep 2026 12:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789216818;
	bh=6KMzpZEFzWlcpr+8YusfWMSENQfpznhX57GlZKSDGY0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0zUBWcsnk6XXn1keeWkO89g9AtBagx5DPn5N2RyvmUQ3vtNgk2XNEPVlPhAQPnVoh
	 t3lzgLqx24imrgF3x1wrIuxUS0ajvb8LlYq3SDNPZH/3ECWgbl3J/lza+6KYUwkb0j
	 T58lPNwLiWLHCBcyyrdkMBzOZkm0aS5eC0LvS9NE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0814/1376] wifi: mt76: fix stranded frames in mt76_txq_schedule_pending
Date: Sat, 12 Sep 2026 08:54:00 +0200
Message-ID: <20260912065625.684739895@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 422dd2db28ae27c35a586acd9ad482f30000c090 ]

A wcid is added to phy->tx_list whenever either tx_pending or
tx_offchannel becomes non-empty, but the requeue check after a partial
schedule required BOTH queues to be non-empty. When
mt76_txq_schedule_pending_wcid() returns -1 (queue stopped or
MT76_RESET) it leaves frames in tx_pending while tx_offchannel is empty,
so the wcid is dropped from every scheduling list and its frames stall
until the next mt76_tx() for that wcid or wcid cleanup. This strands
EAPOL/mgmt/nullfunc frames under momentary queue-full or across
scan/channel-switch, causing association and 4-way-handshake timeouts.

Requeue when either queue still holds frames, matching the enqueue
condition.

Fixes: 0b3be9d1d34e ("wifi: mt76: add separate tx scheduling queue for off-channel tx")
Link: https://patch.msgid.link/20260722082610.2699628-14-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/tx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/tx.c b/drivers/net/wireless/mediatek/mt76/tx.c
index 1184357d933d2..1a5acb2bcfb3e 100644
--- a/drivers/net/wireless/mediatek/mt76/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/tx.c
@@ -664,8 +664,8 @@ static void mt76_txq_schedule_pending(struct mt76_phy *phy)
 			ret = mt76_txq_schedule_pending_wcid(phy, wcid, &wcid->tx_pending);
 		spin_lock(&phy->tx_lock);
 
-		if (!skb_queue_empty(&wcid->tx_pending) &&
-		    !skb_queue_empty(&wcid->tx_offchannel) &&
+		if ((!skb_queue_empty(&wcid->tx_pending) ||
+		     !skb_queue_empty(&wcid->tx_offchannel)) &&
 		    list_empty(&wcid->tx_list))
 			list_add_tail(&wcid->tx_list, &phy->tx_list);
 	}
-- 
2.53.0



