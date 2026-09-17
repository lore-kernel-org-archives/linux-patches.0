Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 725554E73AC;
	Thu, 17 Sep 2026 15:38:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659520; cv=none; b=uEc6i8brvDFxCZZGVECqD0ArX/gbSkKG9bkfeb6fGoaj8FIQuWa74+qjSGCohJ5WlbKphYb39Jcej8+ydeGXTCzEcLW7EPh4gG2eFXMU2wWTAjWHGkqYeB1OLr9RDf4tIACOxWtbvqCdU5ZbJ7r6aiuDsTB/tPTdSSGA/qn5OXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659520; c=relaxed/simple;
	bh=7MGJ4AjcNjWrreogT3x45pfN4eL9k0EkS17wbX5IM/k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ND61QZa7N6juY/Dp/+R6+e3NrUbhw7hK64erUn2myD73OM0//Z9y/aT2nXY58DPxOMGiptQK6E/qEhejLyb0AgmZcKnHqKcippbxGySozguabpya3epSLDhEUq1bLJhsav4nQTB2EYZvc/Wd469gZI99bu0EW8nL+EOin9D9quw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t0z45u2G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t0z45u2G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BA241F00898;
	Thu, 17 Sep 2026 15:38:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659510;
	bh=6zM+ro8W5Ak5uFYLEmze09xyGBE3hlBX6ggn56H3kPs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t0z45u2G69Gtsdv7MDwQGvyu/x+9HxPcQLEwZLraD+hVl0EtYdf67hxPoeYV0c9FT
	 +apTLy0nGSE+xqATIrJWqzI6wy/BRReWYZLsfNM24Mo2ijkjOLD3qIeIi0C9j3K+in
	 xmp+xntoyz7YvuwGhKiPhGe77JjmCl9bD8Hs0Ba8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Nikhil P. Rao" <nikhil.rao@amd.com>,
	Brett Creeley <brett.creeley@amd.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 280/733] ionic: use netif_txq_maybe_stop() in ionic_tx()
Date: Thu, 17 Sep 2026 16:09:48 +0100
Message-ID: <20260917151358.348808779@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

From: Nikhil P. Rao <nikhil.rao@amd.com>

[ Upstream commit c91b4d6e5cc30ceea3f23ebe29aec012709a065f ]

Commit 061b9bedbef1 ("ionic: Rework Tx start/stop flow") replaced
ionic_maybe_stop_tx() with netif_txq_maybe_stop() to get the memory
barriers around the stop/start bits right, but did not cover the stop
in ionic_tx() added by commit 138506ab249b ("ionic: Check stop no
restart"). Convert the remaining site.

netif_txq_maybe_stop() requires the ring indexes to be updated before
it is invoked, so the post has to come first. But ring_dbell comes
from __netdev_tx_sent_queue(), which runs after that and reads the
stop bit, so it is not known in time to pass to ionic_txq_post(). Post
without the doorbell and ring it separately.

The stop condition is unchanged. The re-check only clears the stop bit
when space has become available, so the doorbell starvation fixed by
commit 138506ab249b ("ionic: Check stop no restart") cannot recur.

Fixes: 138506ab249b ("ionic: Check stop no restart")
Signed-off-by: Nikhil P. Rao <nikhil.rao@amd.com>
Reviewed-by: Brett Creeley <brett.creeley@amd.com>
Link: https://patch.msgid.link/20260901055627.1373129-1-nikhil.rao@amd.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/pensando/ionic/ionic_txrx.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
index e436e3231e864..2543a8ff85476 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
@@ -1672,15 +1672,22 @@ static int ionic_tx(struct net_device *netdev, struct ionic_queue *q,
 	stats->pkts++;
 	stats->bytes += skb->len;
 
+	ionic_txq_post(q, false);
+
 	if (likely(!ionic_txq_hwstamp_enabled(q))) {
 		struct netdev_queue *ndq = q_to_ndq(netdev, q);
 
-		if (unlikely(!ionic_q_has_space(q, MAX_SKB_FRAGS + 1)))
-			netif_tx_stop_queue(ndq);
+		netif_txq_maybe_stop(ndq, ionic_q_space_avail(q),
+				     MAX_SKB_FRAGS + 1, MAX_SKB_FRAGS + 1);
 		ring_dbell = __netdev_tx_sent_queue(ndq, skb->len,
 						    netdev_xmit_more());
 	}
-	ionic_txq_post(q, ring_dbell);
+
+	if (ring_dbell) {
+		ionic_dbell_ring(q->lif->kern_dbpage, q->hw_type,
+				 q->dbval | q->head_idx);
+		q->dbell_jiffies = jiffies;
+	}
 
 	return 0;
 }
-- 
2.53.0



