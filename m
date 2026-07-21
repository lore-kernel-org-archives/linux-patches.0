Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A222472537;
	Tue, 21 Jul 2026 20:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664210; cv=none; b=scwc+QqhgowdL0fKdwoLledNoRxolp5rwD8/c2KrQnbIiSzfR1TTk7CCOrrzE9MsceXnibf3yCwEADKgiPS7j7vSQkPy3XPv4dmsbNNVe7brZjBzy5h5NCYXqnNIlfZB57DAmldd2LQc6J0NhAlmU8ffbVyMAk2mowz6ZROcsZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664210; c=relaxed/simple;
	bh=/9mJnEuOdyNmd7tSnbpYeFmNLdallXRHFvXpkPOJndY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OinnaPfrh9PvG7mPdoTyJyjFbqcr9PHFuUyag/dNwQgEdfdkmUNi3XDbZ7CmfxjL3ZVc4GgrkeFg6hBjMUldyUWlSiNuSTzpWgsgkXB5m0+/+SHCk5k7M1bVQbisztgAuaDrEoiqNif0ZQ/tujiASLWxN8acrm+zK0/4xuNKcTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Thi/nSIl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Thi/nSIl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 012AF1F00A3A;
	Tue, 21 Jul 2026 20:03:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664207;
	bh=YOPWha2RfU2ot7HMJefOFDRVPstybgdeIEwtfHyyi8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Thi/nSIlwxioU2e6CLYKdIovh3LomYG91inSA3xq9FbAQCKlAfEUgG8HNjN9piXsG
	 FJ+O0rWGtuqWZ2dggX+f9OX7vEGm58BFge58wUtUlPZqt91ICrLs1vrDNW4R7ObuLX
	 /N3ohToMtyq5a/sp2p4gC/ElIOLBwf+7mdS0rjnA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.12 1060/1276] net/sched: sch_teql: move rcu_read_lock()/spin_lock() from _bh variants
Date: Tue, 21 Jul 2026 17:25:03 +0200
Message-ID: <20260721152509.708504258@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: Jamal Hadi Salim <jhs@mojatatu.com>

commit 6301f6a34ed86fe6f3b7b3211ea069f3677fc559 upstream.

This is a followup based on sashiko comments [1] on commit e5b811fe7931
("net/sched: sch_teql: Introduce slaves_lock to avoid race condition and UAF")

Use plain rcu_read_lock()/spin_lock() in teql_master_xmit() instead of the
_bh variants, since ndo_start_xmit is already invoked with BH disabled
by the core stack and the _bh primitives can warn in_hardirq() when xmit
is reached through netpoll or a softirq xmit path with hard IRQs disabled.

Moves rcu_read_lock() after restart: label + adds rcu_read_unlock() before
goto restart (fixes the unbounded RCU hold across retries)

[1] https://sashiko.dev/#/patchset/20260628111229.669751-1-jhs%40mojatatu.com

Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
Fixes: e5b811fe7931 ("net/sched: sch_teql: Introduce slaves_lock to avoid race condition and UAF")
Link: https://patch.msgid.link/20260630150922.238714-1-jhs@mojatatu.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/sch_teql.c |   27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

--- a/net/sched/sch_teql.c
+++ b/net/sched/sch_teql.c
@@ -311,14 +311,14 @@ static netdev_tx_t teql_master_xmit(stru
 	int subq = skb_get_queue_mapping(skb);
 	struct sk_buff *skb_res = NULL;
 
-	rcu_read_lock_bh();
-
-	start = rcu_dereference_bh(master->slaves);
-
 restart:
 	nores = 0;
 	busy = 0;
 
+	rcu_read_lock();
+
+	start = rcu_dereference(master->slaves);
+
 	q = start;
 	if (!q)
 		goto drop;
@@ -345,17 +345,17 @@ restart:
 				    netdev_start_xmit(skb, slave, slave_txq, false) ==
 				    NETDEV_TX_OK) {
 					__netif_tx_unlock(slave_txq);
-					spin_lock_bh(&master->slaves_lock);
+					spin_lock(&master->slaves_lock);
 					if (rcu_dereference_protected(master->slaves,
 								      lockdep_is_held(&master->slaves_lock)) == q)
 						rcu_assign_pointer(master->slaves,
 								   rcu_dereference_protected(NEXT_SLAVE(q),
 											     lockdep_is_held(&master->slaves_lock)));
-					spin_unlock_bh(&master->slaves_lock);
+					spin_unlock(&master->slaves_lock);
 					netif_wake_queue(dev);
 					master->tx_packets++;
 					master->tx_bytes += length;
-					rcu_read_unlock_bh();
+					rcu_read_unlock();
 					return NETDEV_TX_OK;
 				}
 				__netif_tx_unlock(slave_txq);
@@ -364,37 +364,38 @@ restart:
 				busy = 1;
 			break;
 		case 1:
-			spin_lock_bh(&master->slaves_lock);
+			spin_lock(&master->slaves_lock);
 			if (rcu_dereference_protected(master->slaves,
 						      lockdep_is_held(&master->slaves_lock)) == q)
 				rcu_assign_pointer(master->slaves,
 						   rcu_dereference_protected(NEXT_SLAVE(q),
 									     lockdep_is_held(&master->slaves_lock)));
-			spin_unlock_bh(&master->slaves_lock);
-			rcu_read_unlock_bh();
+			spin_unlock(&master->slaves_lock);
+			rcu_read_unlock();
 			return NETDEV_TX_OK;
 		default:
 			nores = 1;
 			break;
 		}
 		__skb_pull(skb, skb_network_offset(skb));
-	} while ((q = rcu_dereference_bh(NEXT_SLAVE(q))) != start);
+	} while ((q = rcu_dereference(NEXT_SLAVE(q))) != start);
 
 	if (nores && skb_res == NULL) {
 		skb_res = skb;
+		rcu_read_unlock();
 		goto restart;
 	}
 
 	if (busy) {
 		netif_stop_queue(dev);
-		rcu_read_unlock_bh();
+		rcu_read_unlock();
 		return NETDEV_TX_BUSY;
 	}
 	master->tx_errors++;
 
 drop:
 	master->tx_dropped++;
-	rcu_read_unlock_bh();
+	rcu_read_unlock();
 	dev_kfree_skb(skb);
 	return NETDEV_TX_OK;
 }


