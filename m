Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A65B013D896;
	Tue, 23 Jul 2024 18:42:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721760166; cv=none; b=fzBY1sVJtzmGS4wHzYmpvGZhRc7+juIB/AZD0LhCHT9Aj8W6tInAjoeGnjTjqMfV5Vw1aZ0EsE2r1YIcj5BzI1V/ENSx4/CBCw4FfgbuHQSg1U6K43qCD1/rDYQt+owVbrvDrmYNwQT4dwXTZSpJnAudQIV2YJFQDPXws9a3EmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721760166; c=relaxed/simple;
	bh=qiyiX0ZDkpRXYeqFWEBZ2ONXiC4SFh8JC7nPktW893g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K3bst1sUaLihVCdDS8vx1E3oa+DDw1A8AvE7+a2jSe8GTAYfea5+Nd/YEjAZkELK48t25mmXEUwMqjj0cYumpfsZA0cINUHOjQBbBHmGKqM8YcXWE3mb1r5L0IZI7mvsR7+LAzGFBG7fOaK75A3Xqnf3di3d9CivrMdD132PhNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=efR8rzYr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="efR8rzYr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ABFCC4AF09;
	Tue, 23 Jul 2024 18:42:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721760166;
	bh=qiyiX0ZDkpRXYeqFWEBZ2ONXiC4SFh8JC7nPktW893g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=efR8rzYrtc9CLrLzRWFvZAgCc8MLv09UUJKZYcHq8odaC4Rqxocgs7EbnihFoYdqI
	 bo2NEY4z6EGqC1DdQ3PtNt9+EDY/ejt330mjmm0VfDXyiRyphULV03wPYIMm0mQJae
	 ogJgc4VFpbL2xCCoYr+r1UXqfzYjZKmKV6Z3VBbc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yunshui Jiang <jiangyunshui@kylinos.cn>,
	Stefan Schmidt <stefan@datenfreihafen.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 124/163] net: mac802154: Fix racy device stats updates by DEV_STATS_INC() and DEV_STATS_ADD()
Date: Tue, 23 Jul 2024 20:24:13 +0200
Message-ID: <20240723180148.263022651@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180143.461739294@linuxfoundation.org>
References: <20240723180143.461739294@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index 2a6f1ed763c9b..6fbed5bb5c3e0 100644
--- a/net/mac802154/tx.c
+++ b/net/mac802154/tx.c
@@ -34,8 +34,8 @@ void ieee802154_xmit_sync_worker(struct work_struct *work)
 	if (res)
 		goto err_tx;
 
-	dev->stats.tx_packets++;
-	dev->stats.tx_bytes += skb->len;
+	DEV_STATS_INC(dev, tx_packets);
+	DEV_STATS_ADD(dev, tx_bytes, skb->len);
 
 	ieee802154_xmit_complete(&local->hw, skb, false);
 
@@ -90,8 +90,8 @@ ieee802154_tx(struct ieee802154_local *local, struct sk_buff *skb)
 		if (ret)
 			goto err_wake_netif_queue;
 
-		dev->stats.tx_packets++;
-		dev->stats.tx_bytes += len;
+		DEV_STATS_INC(dev, tx_packets);
+		DEV_STATS_ADD(dev, tx_bytes, len);
 	} else {
 		local->tx_skb = skb;
 		queue_work(local->workqueue, &local->sync_tx_work);
-- 
2.43.0



