Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 037BC3A8753;
	Sat, 17 Oct 2026 17:17:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257442; cv=none; b=p5xetKOGMONpd+gY+bwxQAq19mPeNfJih2PrCkwQ4ETJcScQUaJ8gLuY33AoBQy0xSi2MH7RHE59dGAvN5S+BiFU8mxcbCOBlqgBDfBl3jhpUoGMdoeoXQ0PAlkwmZJWKOChUm/XzF3nyOZpseC5Um3K9QOuqm5jM++ctuwPlkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257442; c=relaxed/simple;
	bh=HV4aZHtEqGOo8/HrYWlWpbO4qFT0N9iE2uXPsR6ivBM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M5HpJuwJ6FVEB4+YF7QiC/6loClqCytaKzAFN1G2Arb3sg7Y3FC3te3ETGXBfl6fhCt2h+qTVLQavpVdgw8oH8WCdH/ZE+Y+F6hnxsqScCocCDdumAU6cpPjJS37vmVB9DYbN1aA+EyWbNIT4MwAF0Wu57xGgVSBUFkY1DeDG6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nOY6zbZY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nOY6zbZY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 523661F000C5;
	Sat, 17 Oct 2026 17:17:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257440;
	bh=HILhJVclVo8R6IUQ5h0WWC3ospfxSocBSHkfFj212OA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nOY6zbZYGketmHC4stb2fnV4qnqCPiqZ2DMTLH8/yE4wGGktC+/utp0dITTEegy+3
	 Y4Eid/o3Xxqz4MjhLi7KfzA2PUE0M24WlYdVb7zHzoKE6pmy4lCsAyG+HxwRwBKvJd
	 no4qr1wIPmbqhhfV6BbxQiMZSXD5g5C6wkTEKnJQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Papa <pcristian292@gmail.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0559/1674] wifi: mt76: mt7603: initialize global station WCID
Date: Sat, 17 Oct 2026 17:47:11 +0200
Message-ID: <20261017160445.444319188@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cristian Papa <pcristian292@gmail.com>

commit 456de496b53ae73e6e3020fec815dbdc88aa7c07 upstream.

mt7603 uses a driver-private global station WCID for frames that have
neither a station nor a vif, including frames injected through a monitor
interface. Unlike the core global WCID initialized by
mt76_register_device(), this WCID is published without ever being passed
to mt76_wcid_init().

Since commit 0335c034e726 ("wifi: mt76: fix race condition related to
checking tx queue fill status"), mt76_tx() queues every such frame on the
WCID's tx_pending or tx_offchannel queue and links its tx_list. The first
injected frame therefore reaches __skb_queue_tail() with an uninitialized
sk_buff_head and dereferences a NULL prev pointer.

Initialize the WCID before publishing it.

The fix was tested on an MT7603 PCIe device. Three wildcard probe requests
were injected through a monitor interface. The hardware queue head and tail
advanced from 0 to 3 and a second radio captured the third request over the
air. No oops or reset occurred. After restoring AP mode, a 150 MB transfer
also completed without a reset.

Fixes: 0335c034e726 ("wifi: mt76: fix race condition related to checking tx queue fill status")
Cc: stable@vger.kernel.org
Signed-off-by: Cristian Papa <pcristian292@gmail.com>
Link: https://patch.msgid.link/20260904010702.16306-1-pcristian292@gmail.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
[ mt76_wcid_init() takes no band index in this tree; drop the argument. ]
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Cristian Papa <pcristian292@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7603/init.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/init.c b/drivers/net/wireless/mediatek/mt76/mt7603/init.c
index 0762de3ce5ac4..02d7b36ea786b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/init.c
@@ -222,6 +222,7 @@ mt7603_mac_init(struct mt7603_dev *dev)
 
 	eth_broadcast_addr(bc_addr);
 	mt7603_wtbl_init(dev, MT7603_WTBL_RESERVED, -1, bc_addr);
+	mt76_wcid_init(&dev->global_sta.wcid);
 	dev->global_sta.wcid.idx = MT7603_WTBL_RESERVED;
 	rcu_assign_pointer(dev->mt76.wcid[MT7603_WTBL_RESERVED],
 			   &dev->global_sta.wcid);
-- 
2.53.0



