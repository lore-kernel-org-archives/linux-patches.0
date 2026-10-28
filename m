Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209182;
	b=kx+XEJjRwDC+HuSYol3mLvw63FaWSUWMCNuEXZAWe8JD21+NC5DV7zZPw6VHbQoLR7qw
	 /vV8k2RCq5D6Wsrw2/cnqbxXsQZKn3ASq78DQx+h0WDChL+W8lUAF9hjJ32anjW+2j9kr
	 PRReVAAOm2I6niH6u1sAzVD7xmqnoM2RTBlqfXRsgkydhkzVIWH7tyaU+npyIevMC2RAm
	 II15bJIvRtlWkdasnxE63ji1ebAgKp8kBycHpeIolP5Ihzd3r9BzwV2YyQkrVOJ9hcZ5A
	 pt0u1w8Rw6/OZ0wE3kF9++vBcmP5rmluf7zOmOQbQUvpPwAf8KYst9aVyoxBjueW3iQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209182;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=27JROvdqIQgcrz9YyeeMh5rRFQDvATVeP65zq+wuWl8=;
	b=0uStcWVf6L8CP4VyK0B9bP8PXUDUeX4RL24bpZ6UiyEg0S63MaJ3FRuNSnpvh6JM6K5C
	 ry6ym5As3KyJ3mNa65LPy7Bo295EPAo5Jl9aj3wpq2CGC2fSeyrQW7AwP45SlsIsRqMW7
	 VyviQBgORTexWjHCO2twoqXlAdPMs14FczjlsZnZiYK4fClGlwjUN48vrSJbC2wEI9/y4
	 AjsKsTzdTVBsw9E1Oim8WWoYMf+1mb4VSuNVVAYfUpz1FqFfvBvvHAu80n1ZJPxsGkBso
	 RYw++uV9YHH8QUGGSuTezg5cSCGMXRB0GOHVcGAyA1/Nk6LDoJ/klI4NS1uwk/piVVg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nSLCnbe8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14B10606A326;
	Wed, 28 Oct 2026 17:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nSLCnbe8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65B5E1F01825;
	Wed, 28 Oct 2026 17:39:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209181;
	bh=27JROvdqIQgcrz9YyeeMh5rRFQDvATVeP65zq+wuWl8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nSLCnbe8Yk0cVS7SpgeZCTPaWpUktC8rCJejALzxmg/I9d/weVWnaEwq/oSz2MZbf
	 zur4npuItPx8509CX2u//CVWd7GooPMa0Lj3sJy6YgCf+aOe7bPz2RwhODTqYKvK9Q
	 RNVyCEmKn+TNaovL8dD/A/CTIL6vT+6fd4g9xeFk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	co+2cf741c3005abc20@bugs.sh,
	Weiming Shi <bestswngs@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 382/516] net: team: stop reusing skb after queue override
Date: Wed, 28 Oct 2026 17:58:54 +0100
Message-ID: <20261028170012.530569616@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/net/team/team.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/team/team.c b/drivers/net/team/team.c
index 0ccd2edfc9d41..6d7be450e57c7 100644
--- a/drivers/net/team/team.c
+++ b/drivers/net/team/team.c
@@ -816,7 +816,8 @@ static struct list_head *__team_get_qom_list(struct team *team, u16 queue_id)
 /*
  * note: already called with rcu_read_lock
  */
-static bool team_queue_override_transmit(struct team *team, struct sk_buff *skb)
+static bool team_queue_override_transmit(struct team *team, struct sk_buff *skb,
+					 bool *tx_success)
 {
 	struct list_head *qom_list;
 	struct team_port *port;
@@ -824,11 +825,11 @@ static bool team_queue_override_transmit(struct team *team, struct sk_buff *skb)
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
@@ -1753,8 +1754,7 @@ static netdev_tx_t team_xmit(struct sk_buff *skb, struct net_device *dev)
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



