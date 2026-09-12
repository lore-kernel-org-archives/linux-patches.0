Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3985833689D;
	Sat, 12 Sep 2026 10:31:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209091; cv=none; b=IuaCyRyvRe5aAqakXfheYtCYuOEIKoCPujZmkQnyCOkCFbehMgLiXrBKEDu+YerkZ7Fw41zuzAyleAasIxfTQjJ4XUi1qeiGvEn0bQbzvTOypGFAiZpzgd7He16Wxd+eXJowDXC4rs2f+pe9+Ukf/Frzz2ptBEAJC0hi9sfu7fI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209091; c=relaxed/simple;
	bh=QHlAza3E6iGtTT89pTntqr2T1TdkXrmH/5kZwMt8qUo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TPlaJRaA3C5iPLp1eZkL5zmpLoW06FtxZ8X+OCB24o2QxPn/XI6lMoTbTiuhEzL8S6jr0OaHQKYN1znl7SA+r4bt4CoP6a6QUR+OrRdGBR5Z04bGw5aBRpg/kP3r8oXsofFZVyo/KwJIkyfFSIT15uWXg6EfZJXNjDMuCOEW8Nw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K/YnB4Ae; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K/YnB4Ae"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B90B31F000FF;
	Sat, 12 Sep 2026 10:31:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209089;
	bh=plSzFn9TCAbLAYqNjqJ8v+5B2FCc/hpiVEybuBe8zVE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K/YnB4Ae91JpWuZxdvRco2VlfX3MjMFrqAxE3bt8V2B8u8zg8rIk+hLMuOHtc23pn
	 MHxGMTqtbXaqjBaApF9TMLhTyefzxBBh89bFzoO1qtyZmqxV1pOVh8jgBcE9+ucslK
	 l8gkmuVHTbLVHhS8ZulZMlgYTGJEuTjKZl/paAEM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0751/1518] wifi: mt76: fix stranded frames in mt76_txq_schedule_pending
Date: Sat, 12 Sep 2026 08:48:40 +0200
Message-ID: <20260912065640.419834257@linuxfoundation.org>
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
index ac6c0ca092931..26463d84b7898 100644
--- a/drivers/net/wireless/mediatek/mt76/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/tx.c
@@ -666,8 +666,8 @@ static void mt76_txq_schedule_pending(struct mt76_phy *phy)
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



