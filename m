Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BD1D404BF6;
	Tue, 21 Jul 2026 21:46:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670419; cv=none; b=Ds1uq9ul/A1rGFs/FgLQV1/plH4NyM5v3nhNkeeCbVM5Ve0u6AjPuxbK7mjwZFkRHaDEUvzVkGmO4sOjvL1dOE/KEdxD38gvUGkosJp+Ryx1quG+MWCM810LnHNQQJS1Czh6o8cji5yrE37MNnPnjWLm++dW6hjQ/JCLhaK++x8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670419; c=relaxed/simple;
	bh=tGYip14lTJEJKJ06E9chas6caZoW9gFG1byUstbr/os=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V0/fKcAt4fWcThe6oU8Qv9vC0gTh2UnOi41NSXiSnu0l2jT47m3GfVf6n/bUGw6z8Nd/M+TR+7EfzFRmjHt6hUgTNKSlk3okrCrgRHo6/IqQ15DojopU+v2eJ0YL9Z+lESP2mRvLmNEZ0io4s2odQT328uC69Hv28G51LuotKUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gzoQnrvE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gzoQnrvE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C3E51F000E9;
	Tue, 21 Jul 2026 21:46:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670417;
	bh=iHk1E4Lxx9FK0PHVXJ0CUIjjniICR3JZ9Cw41cq7qdI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gzoQnrvEwa83T0vDdjYOfLjqtIHDqLM05/t1VQUAl4x1YxE0cK4fRwrdrcELNEZpe
	 KeKhOXOjX4z9muz2FZn2lyDRfmkRonXyHB/bnAmmHks8Bd68GtMAvi4dKiTPQX1XiD
	 dMHNAsKuCLogR7S66drcZ21cJ9NCG2Oe6Gu1qzYQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.1 0888/1067] net/sched: sch_teql: move rcu_read_lock()/spin_lock() from _bh variants
Date: Tue, 21 Jul 2026 17:24:49 +0200
Message-ID: <20260721152444.398045526@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


