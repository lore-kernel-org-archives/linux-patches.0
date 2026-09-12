Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFB9137AA97;
	Sat, 12 Sep 2026 08:15:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200909; cv=none; b=UXr8IoP+l4VcyZpEMAFtcNT4vd/eth/xdUb5S8aKDrOBS12ekrP/Qdev+kwa39cB7a8uApAGXFKYdmbFHjiXKOoFk+NI353DUez6dP3xzLJTDKUwcgbydr0Rq2J7H1gauXCC7VpE9NSBkTu3k2/KIbYpCX1V1wSNHk5wEy8QLWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200909; c=relaxed/simple;
	bh=SweGZwHSy0iCz6TSKn0/7btKj9xZoblGQi0yzsF3g+E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C27gO3+v7xkXhcagsdWRYTaew8igv7lYvCDkuK6VhtscL1p9uaYvBk6RbhuQxB51+j270HR7iSzmTP5QkFZ5OlvG2furdOC406WSm4rdECM7sSH8ao3Q38JYMelFgZQDtHpp0fHvN67QU1HgV5BbFJE2ywW1jevMiFmKIDYSxms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CSLun2FV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CSLun2FV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B44341F000FF;
	Sat, 12 Sep 2026 08:15:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200907;
	bh=tlbEl23QzpbhWVhL9m71HkNh0jA8x9i1eG7siEbOzn8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CSLun2FV2CxiXuxaZMdq3hJlG6Dou9cMWU5kDgkR5fi5LhoL7uh2uOo2DcLoSmU/n
	 RyJoqYJZ1SPTsYuAtqp4aok4KAcIIneSPZujf5Qkt6vTFrDPneFSHk670tcugNkaHn
	 eS8ntbUvRRCNJowGLMswxZyJyw/t1aMg22ZkpuIY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0887/1815] wifi: mt76: fix stranded frames in mt76_txq_schedule_pending
Date: Sat, 12 Sep 2026 08:43:57 +0200
Message-ID: <20260912065709.743223861@linuxfoundation.org>
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
index de8af32f15e5a..dc8407be28913 100644
--- a/drivers/net/wireless/mediatek/mt76/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/tx.c
@@ -682,8 +682,8 @@ void mt76_txq_schedule_pending(struct mt76_phy *phy)
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



