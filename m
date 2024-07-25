Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53D1019A29C;
	Thu, 25 Jul 2024 14:40:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721918445; cv=none; b=pnT30Slp4VsX+y+CzYpSW3Ta77nTN5ExNnyr5itO0jZcckFNItWzMxI2T12+h2vf42v5mO5AhqLJpZYziJyOKJ8Kxu0K/6e/K7c5AIc0ccp2lPzd13QmE1L05WyD3qlsnBtPKC9k6Ih5BBxu73aZz3TVOtxWnvoU0whgc8oQg6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721918445; c=relaxed/simple;
	bh=ueuv5fCSIT6F09ofOwlxSZ0Y16U2VBd8Cpcjke/XqYE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MCxdeTS9PMSIo5DxSaMWtChcskNPkbIeU41fxLPNFYB77+wFGn4o146xHPEGVZM/DuB/CL9EquQgRKeqY8oom3Yf65noEK04J35b6hryasPWY275h9bcAQ+7d1B8n4NMkdLzyedM2ZYdYxFIGMl8tINUbt2Dmv6h2YqlvI0m540=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oVVHYdYz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oVVHYdYz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ED88C116B1;
	Thu, 25 Jul 2024 14:40:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721918444;
	bh=ueuv5fCSIT6F09ofOwlxSZ0Y16U2VBd8Cpcjke/XqYE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oVVHYdYz81mXyFmwUGBRuYuBWM2yICXbXuSGe/F0tfTPjftuYgWENZxmyrBanUisj
	 kSekRtt0DhC/j7Ckt9cy6zWwBJamCh+II3W1HNAWz0xOFf+qNKjZYM2U6V5UKgmoJw
	 8CQRJqPzeHbvtP4QWvTsg81WogooZxV/16GsUI1g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yunshui Jiang <jiangyunshui@kylinos.cn>,
	Stefan Schmidt <stefan@datenfreihafen.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 21/33] net: mac802154: Fix racy device stats updates by DEV_STATS_INC() and DEV_STATS_ADD()
Date: Thu, 25 Jul 2024 16:36:44 +0200
Message-ID: <20240725142729.316208523@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142728.511303502@linuxfoundation.org>
References: <20240725142728.511303502@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yunshui Jiang <jiangyunshui@kylinos.cn>

[ Upstream commit b8ec0dc3845f6c9089573cb5c2c4b05f7fc10728 ]

mac802154 devices update their dev->stats fields locklessly. Therefore
these counters should be updated atomically. Adopt SMP safe DEV_STATS_INC()
and DEV_STATS_ADD() to achieve this.

Signed-off-by: Yunshui Jiang <jiangyunshui@kylinos.cn>
Message-ID: <20240531080739.2608969-1-jiangyunshui@kylinos.cn>
Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac802154/tx.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/mac802154/tx.c b/net/mac802154/tx.c
index 2f873a0dc5836..0f192174a5693 100644
--- a/net/mac802154/tx.c
+++ b/net/mac802154/tx.c
@@ -42,8 +42,8 @@ void ieee802154_xmit_worker(struct work_struct *work)
 	if (res)
 		goto err_tx;
 
-	dev->stats.tx_packets++;
-	dev->stats.tx_bytes += skb->len;
+	DEV_STATS_INC(dev, tx_packets);
+	DEV_STATS_ADD(dev, tx_bytes, skb->len);
 
 	ieee802154_xmit_complete(&local->hw, skb, false);
 
@@ -94,8 +94,8 @@ ieee802154_tx(struct ieee802154_local *local, struct sk_buff *skb)
 			goto err_tx;
 		}
 
-		dev->stats.tx_packets++;
-		dev->stats.tx_bytes += len;
+		DEV_STATS_INC(dev, tx_packets);
+		DEV_STATS_ADD(dev, tx_bytes, len);
 	} else {
 		local->tx_skb = skb;
 		queue_work(local->workqueue, &local->tx_work);
-- 
2.43.0



