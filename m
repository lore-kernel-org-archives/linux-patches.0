Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0688279C1
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:48:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A23DC433B5;
	Wed, 30 Nov 2022 18:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669834093;
	bh=3kmCxi2YoCk9wj4QlSqGV5e4a8PuKAJzfCYVhTx1c4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0BwSHTGb3XqBWexqRJHAToeIEMQaxF59i07zZn1H9XdGO9T3QAtQPzLO6YV+VpRWp
	 GLzv3/rGTfozUQnfov9vVAYyAbkRwW2jULN2rBRFbeyj2GwC+D0zT5EKt+bWv03xwK
	 2wNUNyS3ep1sv6tCsUYtAIvlfteygFaG0+J8YoX4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gerhard Engleder <gerhard@engleder-embedded.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 127/289] tsnep: Fix rotten packets
Date: Wed, 30 Nov 2022 19:21:52 +0100
Message-Id: <20221130180547.019472958@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Gerhard Engleder <gerhard@engleder-embedded.com>

[ Upstream commit 2dc4ac91f845b690ddf2ad39172c3698b2769fa2 ]

If PTP synchronisation is done every second, then sporadic the interval
is higher than one second:

ptp4l[696.582]: master offset        -17 s2 freq   -1891 path delay 573
ptp4l[697.582]: master offset        -22 s2 freq   -1901 path delay 573
ptp4l[699.368]: master offset         -1 s2 freq   -1887 path delay 573
      ^^^^^^^ Should be 698.582!

This problem is caused by rotten packets, which are received after
polling but before interrupts are enabled again. This can be fixed by
checking for pending work and rescheduling if necessary after interrupts
has been enabled again.

Fixes: 403f69bbdbad ("tsnep: Add TSN endpoint Ethernet MAC driver")
Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
Link: https://lore.kernel.org/r/20221119211825.81805-1-gerhard@engleder-embedded.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/engleder/tsnep_main.c | 57 +++++++++++++++++++++-
 1 file changed, 56 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/engleder/tsnep_main.c b/drivers/net/ethernet/engleder/tsnep_main.c
index a5f7152a1716..6a2617cc5490 100644
--- a/drivers/net/ethernet/engleder/tsnep_main.c
+++ b/drivers/net/ethernet/engleder/tsnep_main.c
@@ -504,6 +504,27 @@ static bool tsnep_tx_poll(struct tsnep_tx *tx, int napi_budget)
 	return (budget != 0);
 }
 
+static bool tsnep_tx_pending(struct tsnep_tx *tx)
+{
+	unsigned long flags;
+	struct tsnep_tx_entry *entry;
+	bool pending = false;
+
+	spin_lock_irqsave(&tx->lock, flags);
+
+	if (tx->read != tx->write) {
+		entry = &tx->entry[tx->read];
+		if ((__le32_to_cpu(entry->desc_wb->properties) &
+		     TSNEP_TX_DESC_OWNER_MASK) ==
+		    (entry->properties & TSNEP_TX_DESC_OWNER_MASK))
+			pending = true;
+	}
+
+	spin_unlock_irqrestore(&tx->lock, flags);
+
+	return pending;
+}
+
 static int tsnep_tx_open(struct tsnep_adapter *adapter, void __iomem *addr,
 			 struct tsnep_tx *tx)
 {
@@ -751,6 +772,19 @@ static int tsnep_rx_poll(struct tsnep_rx *rx, struct napi_struct *napi,
 	return done;
 }
 
+static bool tsnep_rx_pending(struct tsnep_rx *rx)
+{
+	struct tsnep_rx_entry *entry;
+
+	entry = &rx->entry[rx->read];
+	if ((__le32_to_cpu(entry->desc_wb->properties) &
+	     TSNEP_DESC_OWNER_COUNTER_MASK) ==
+	    (entry->properties & TSNEP_DESC_OWNER_COUNTER_MASK))
+		return true;
+
+	return false;
+}
+
 static int tsnep_rx_open(struct tsnep_adapter *adapter, void __iomem *addr,
 			 struct tsnep_rx *rx)
 {
@@ -795,6 +829,17 @@ static void tsnep_rx_close(struct tsnep_rx *rx)
 	tsnep_rx_ring_cleanup(rx);
 }
 
+static bool tsnep_pending(struct tsnep_queue *queue)
+{
+	if (queue->tx && tsnep_tx_pending(queue->tx))
+		return true;
+
+	if (queue->rx && tsnep_rx_pending(queue->rx))
+		return true;
+
+	return false;
+}
+
 static int tsnep_poll(struct napi_struct *napi, int budget)
 {
 	struct tsnep_queue *queue = container_of(napi, struct tsnep_queue,
@@ -815,9 +860,19 @@ static int tsnep_poll(struct napi_struct *napi, int budget)
 	if (!complete)
 		return budget;
 
-	if (likely(napi_complete_done(napi, done)))
+	if (likely(napi_complete_done(napi, done))) {
 		tsnep_enable_irq(queue->adapter, queue->irq_mask);
 
+		/* reschedule if work is already pending, prevent rotten packets
+		 * which are transmitted or received after polling but before
+		 * interrupt enable
+		 */
+		if (tsnep_pending(queue)) {
+			tsnep_disable_irq(queue->adapter, queue->irq_mask);
+			napi_schedule(napi);
+		}
+	}
+
 	return min(done, budget - 1);
 }
 
-- 
2.35.1



