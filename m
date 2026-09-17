Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E40A64EB855;
	Thu, 17 Sep 2026 17:21:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665716; cv=none; b=thM1BRygeSG1R04/TqY8JD43IRER8zWqPsp3j0QAwI997v71HUbgclmHJEpnj30gD0kaBMnUyhBslE3WvhBaoshmguAEB3uuW6OGl/eUYCrMhHgXRzIXvpGUA+tCqYfcV1mWCZlxiPij+Bl0/Z/bVaYu6msoZoOPEtFLfwRLoCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665716; c=relaxed/simple;
	bh=CEPqBhGL7HKgEsG38N2HFX7CFpebEZhw4zE/GVCz71c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rtka0fY1Ep/CPdBkInwQ1x8aX63cZyUm5rxgKWOFs2kA6sEgfAgtGKTrk9qzCQBM9Szgq1797LSGjPbl2MyWUFrqOJHrZizQS6M8xJp+jr0ORCn4x8TI5LniLevTxnck+T2jM2gk8qS4JZXhNbW5O68XRV0IPJ7MVAhcXlLPaKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MTfiLqqw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MTfiLqqw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E7C71F000FF;
	Thu, 17 Sep 2026 17:21:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665714;
	bh=bCWeQzZzOhddxQ0sQa9yATcYTed0sktTwGq8ejj6bSo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MTfiLqqw1iINknEawLJJ2czq2abPMQDO+wC4la5TilOA6f6Po6aucqj1f8bWWH+Fy
	 VvAO1xWucPXvp9YVvBzdr1nPHG624M71y3OhN3oUS9QAom70xtztZFbEyCvxFqxnRX
	 gJAxKnaG4ho9WqKo313YlvjVN45TxoRYfgSNic0I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Nikhil P. Rao" <nikhil.rao@amd.com>,
	Brett Creeley <brett.creeley@amd.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0796/1250] ionic: use netif_txq_maybe_stop() in ionic_tx()
Date: Thu, 17 Sep 2026 16:09:51 +0100
Message-ID: <20260917151613.475218718@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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
index 61d48c172587d..c8ecb0ee231ef 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
@@ -1668,15 +1668,22 @@ static int ionic_tx(struct net_device *netdev, struct ionic_queue *q,
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



