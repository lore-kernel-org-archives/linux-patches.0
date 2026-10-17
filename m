Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 360673BADA7;
	Sat, 17 Oct 2026 17:18:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257512; cv=none; b=BeCtMX7urQgD0pd4MjT7TlTA8rOqWgWVjzEMY1uvr1dsEnOVeDs3WdqR/zcgnWfSiWc/CEm//7z9KZiDAGF2e9sJijiestq70B+3g1q6I+joyYdfWS7uBvQU2AT9zBe91Tntlxb+yDR0Zott7qyqZvpkkSrW+h8QL8zBDlsJFvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257512; c=relaxed/simple;
	bh=yw7GN6GzCKlw5y7/6u+LFPb/GZT18jdncT43m+hZ4BQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J45grw2Wd2WDxHYFTIHXgjZwIUuvUx/lfAWR6oUjtUoPzO6//inJZY1D2YWc+QmupEH4ZokPNneNP0hfjQNiluRpqhlJ2m9uyV1BOLpsmBc7EBZgxrjAG3WBcqKdC5hNR4tG1mgYXcIPmq7SbPPfc3N3Lvpdp7x/LwYQpu4p2NM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fedcuO4V; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fedcuO4V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23AC11F000C4;
	Sat, 17 Oct 2026 17:18:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257509;
	bh=OWxHGNgcQVG0kZfPYMKrVtqBZiB1R8a6ketEnG+n8/w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fedcuO4VprMI9nqeU8KyI/07yMvj0W9xQhv8f/qwLAnCAHViJH1j/WiEUc1FB01Fn
	 0UYOtZiLRN+QKuQD3h20mK90YZneXsoHbok+tQzGOVJIuZK4lx9VXE3BKkv8U1IBti
	 W5SCRdQzBORGjDkMZ8QotaJYFwCa4MuZ/B1HGcRc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	co+2cf741c3005abc20@bugs.sh,
	Weiming Shi <bestswngs@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0583/1674] net: team: stop reusing skb after queue override
Date: Sat, 17 Oct 2026 17:47:35 +0200
Message-ID: <20261017160446.054707385@linuxfoundation.org>
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

From: Weiming Shi <bestswngs@gmail.com>

[ Upstream commit b7454f1940c5e6d92e753853c476a769e452f30a ]

A nonzero dev_queue_xmit() result does not return ownership of the skb.
When an override port's qdisc drops it, the queue override helper used to
try another port or the mode transmit op with the freed skb.

Return the handoff decision separately from transmit success. Select only
the first override port under RCU and stop after handing it the skb,
regardless of the lower transmit result. Keep the existing success and
drop accounting.

  BUG: KASAN: slab-use-after-free in sk_skb_reason_drop
  Write of size 4 by task poc/5040
  sk_skb_reason_drop (net/core/skbuff.c:1240)
  dev_kfree_skb_any_reason (net/core/dev.c:3470)
  ab_transmit (drivers/net/team/team_mode_activebackup.c:49)
  team_xmit (drivers/net/team/team_core.c:1849)
  __dev_direct_xmit (net/core/dev.c:4934)
  Freed by task 5040:
  __tcf_kfree_skb_list (net/sched/sch_generic.c:43)
  __dev_queue_xmit (net/core/dev.c:4831)
  team_xmit (drivers/net/team/team_core.c:1846)
  Kernel panic - not syncing: KASAN: panic_on_warn set ...

Cc: stable@vger.kernel.org
Fixes: 8ff5105a2b9d ("team: add support for queue override by setting queue_id for port")
Reported-by: <co+2cf741c3005abc20@bugs.sh>
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
Link: https://patch.msgid.link/20261001182326.572045-2-bestswngs@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/team/team_core.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/team/team_core.c b/drivers/net/team/team_core.c
index a02c82a5d1868..46e9aec8a0541 100644
--- a/drivers/net/team/team_core.c
+++ b/drivers/net/team/team_core.c
@@ -820,7 +820,8 @@ static struct list_head *__team_get_qom_list(struct team *team, u16 queue_id)
 /*
  * note: already called with rcu_read_lock
  */
-static bool team_queue_override_transmit(struct team *team, struct sk_buff *skb)
+static bool team_queue_override_transmit(struct team *team, struct sk_buff *skb,
+					 bool *tx_success)
 {
 	struct list_head *qom_list;
 	struct team_port *port;
@@ -828,11 +829,11 @@ static bool team_queue_override_transmit(struct team *team, struct sk_buff *skb)
 	if (!team->queue_override_enabled || !skb->queue_mapping)
 		return false;
 	qom_list = __team_get_qom_list(team, skb->queue_mapping);
-	list_for_each_entry_rcu(port, qom_list, qom_list) {
-		if (!team_dev_queue_xmit(team, port, skb))
-			return true;
-	}
-	return false;
+	port = list_first_or_null_rcu(qom_list, struct team_port, qom_list);
+	if (!port)
+		return false;
+	*tx_success = !team_dev_queue_xmit(team, port, skb);
+	return true;
 }
 
 static void __team_queue_override_port_del(struct team *team,
@@ -1747,8 +1748,7 @@ static netdev_tx_t team_xmit(struct sk_buff *skb, struct net_device *dev)
 	bool tx_success;
 	unsigned int len = skb->len;
 
-	tx_success = team_queue_override_transmit(team, skb);
-	if (!tx_success)
+	if (!team_queue_override_transmit(team, skb, &tx_success))
 		tx_success = READ_ONCE(team->ops.transmit)(team, skb);
 	if (tx_success) {
 		struct team_pcpu_stats *pcpu_stats;
-- 
2.53.0



