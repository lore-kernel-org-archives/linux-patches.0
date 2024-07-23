Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ECFC158D7C;
	Tue, 23 Jul 2024 18:35:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759736; cv=none; b=dUtODwKcb7m6OMw6nPjZc4HLKhVHDC4bdN4wCVJwvVpRzflzwomdoELKSnl/SaADDvmF3QK2dnLPgS/aTw59ZkKG5KJh654hK620PmEyqFcevYFSZ4e4FNXBfsvrOvsFh0hrmV6n4o0yPxoJr5q2ZbnmE5zDlKNZYJPcZrjZNo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759736; c=relaxed/simple;
	bh=4onan6z6o6r40FKnRLOLHf9xsoR4T8WaUX048dWsGIE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hbcPCRw5O2BEbmcZsBYFHC/KEBfglTdaDJnRmZqBtBXxA12RNFyZeCw9B58S2tgYQChx2y2Nt9e6U1p/oiVg849p0l67jq5zQCk8HAQdP4cbolSKXPLn6JfRg/dNxFYIWk0sx++pucdgFL/mQhzWgMLDR2o5gWit7WvJdnvNJRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AhPKr6/C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AhPKr6/C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A99FC4AF09;
	Tue, 23 Jul 2024 18:35:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759736;
	bh=4onan6z6o6r40FKnRLOLHf9xsoR4T8WaUX048dWsGIE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AhPKr6/CshrMB5Jasv/iFJUW3T3KuhKirwFIHCYYtDk5Ov0aswBIC/AG+YNcTNygv
	 DvIQcURcM5QU0N+yX79HoQtGfJMIqbmh26T1rAw+bXUF9yeGp2PSPlE4PLbH4rC8j1
	 5CMNs+MiXjmoqSB6BS3kqcmYor/SqFK5HHi+yAeM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yunshui Jiang <jiangyunshui@kylinos.cn>,
	Stefan Schmidt <stefan@datenfreihafen.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 093/129] net: mac802154: Fix racy device stats updates by DEV_STATS_INC() and DEV_STATS_ADD()
Date: Tue, 23 Jul 2024 20:24:01 +0200
Message-ID: <20240723180408.380836688@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180404.759900207@linuxfoundation.org>
References: <20240723180404.759900207@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



