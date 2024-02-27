Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D15013AA50;
	Tue, 27 Feb 2024 13:40:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041218; cv=none; b=of8HNA75BMum67qvfdvJdhq6hzCxsZ4DS5KIEji0/ABBzfxUGToUr2c082RQD0baFnNeNa5ay2J6oByO5PxOeWXnG5I6vL1W0LQwJYcsz02Wcvgu2UTvuIQOUFzXpL3ShdRJZprnY5XiZA6f9V4j/6YZs17ygfv7Rcdw4fng/nU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041218; c=relaxed/simple;
	bh=gr7RyQkUOgyUiRmeZO5jwGc2dRzZsy2J3T0qOnrE644=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sUcmvz5n3By1hTBGo2qBqLWJivZMMFKcB+XvXRnoNE9Q8sexASC1OcSpyk6XIwkS9I5AOsT3zsUyyTh1Ul+DsvDU1CZqd6xDtzTgeEKsjBxk1mN/RbiWgG1+/tZ3pIDa58bU8L+l+n5lk5HwqSF/kD8+gquLnnrlCuGMgIE+nYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N9kJEDHU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N9kJEDHU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B89AC433F1;
	Tue, 27 Feb 2024 13:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041217;
	bh=gr7RyQkUOgyUiRmeZO5jwGc2dRzZsy2J3T0qOnrE644=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N9kJEDHUb2pwnVH2IG9lSH3ZEARvu1aSoeu5v3LJi38hxXVFI0pusrZRyv7OGIZ+H
	 Fzir4TmWbyYlfV61jVyVDdw6GgmiW7iPctINY8g3WftsheFqHK0fZqXpKp9Rl5Nrv9
	 WaPZFGiQIQFg1ruHDyikVv0mYQzFW3UNpuV1ezCI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Davide Caratti <dcaratti@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 262/334] net/sched: act_mirred: use the backlog for mirred ingress
Date: Tue, 27 Feb 2024 14:22:00 +0100
Message-ID: <20240227131639.404290354@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 52f671db18823089a02f07efc04efdb2272ddc17 ]

The test Davide added in commit ca22da2fbd69 ("act_mirred: use the backlog
for nested calls to mirred ingress") hangs our testing VMs every 10 or so
runs, with the familiar tcp_v4_rcv -> tcp_v4_rcv deadlock reported by
lockdep.

The problem as previously described by Davide (see Link) is that
if we reverse flow of traffic with the redirect (egress -> ingress)
we may reach the same socket which generated the packet. And we may
still be holding its socket lock. The common solution to such deadlocks
is to put the packet in the Rx backlog, rather than run the Rx path
inline. Do that for all egress -> ingress reversals, not just once
we started to nest mirred calls.

In the past there was a concern that the backlog indirection will
lead to loss of error reporting / less accurate stats. But the current
workaround does not seem to address the issue.

Fixes: 53592b364001 ("net/sched: act_mirred: Implement ingress actions")
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Suggested-by: Davide Caratti <dcaratti@redhat.com>
Link: https://lore.kernel.org/netdev/33dc43f587ec1388ba456b4915c75f02a8aae226.1663945716.git.dcaratti@redhat.com/
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/act_mirred.c                             | 14 +++++---------
 .../testing/selftests/net/forwarding/tc_actions.sh |  3 ---
 2 files changed, 5 insertions(+), 12 deletions(-)

diff --git a/net/sched/act_mirred.c b/net/sched/act_mirred.c
index 6f2544c1e3961..bab090bb5e80a 100644
--- a/net/sched/act_mirred.c
+++ b/net/sched/act_mirred.c
@@ -206,18 +206,14 @@ static int tcf_mirred_init(struct net *net, struct nlattr *nla,
 	return err;
 }
 
-static bool is_mirred_nested(void)
-{
-	return unlikely(__this_cpu_read(mirred_nest_level) > 1);
-}
-
-static int tcf_mirred_forward(bool want_ingress, struct sk_buff *skb)
+static int
+tcf_mirred_forward(bool at_ingress, bool want_ingress, struct sk_buff *skb)
 {
 	int err;
 
 	if (!want_ingress)
 		err = tcf_dev_queue_xmit(skb, dev_queue_xmit);
-	else if (is_mirred_nested())
+	else if (!at_ingress)
 		err = netif_rx(skb);
 	else
 		err = netif_receive_skb(skb);
@@ -293,9 +289,9 @@ static int tcf_mirred_to_dev(struct sk_buff *skb, struct tcf_mirred *m,
 
 		skb_set_redirected(skb_to_send, skb_to_send->tc_at_ingress);
 
-		err = tcf_mirred_forward(want_ingress, skb_to_send);
+		err = tcf_mirred_forward(at_ingress, want_ingress, skb_to_send);
 	} else {
-		err = tcf_mirred_forward(want_ingress, skb_to_send);
+		err = tcf_mirred_forward(at_ingress, want_ingress, skb_to_send);
 	}
 
 	if (err) {
diff --git a/tools/testing/selftests/net/forwarding/tc_actions.sh b/tools/testing/selftests/net/forwarding/tc_actions.sh
index b0f5e55d2d0b2..5896296365022 100755
--- a/tools/testing/selftests/net/forwarding/tc_actions.sh
+++ b/tools/testing/selftests/net/forwarding/tc_actions.sh
@@ -235,9 +235,6 @@ mirred_egress_to_ingress_tcp_test()
 	check_err $? "didn't mirred redirect ICMP"
 	tc_check_packets "dev $h1 ingress" 102 10
 	check_err $? "didn't drop mirred ICMP"
-	local overlimits=$(tc_rule_stats_get ${h1} 101 egress .overlimits)
-	test ${overlimits} = 10
-	check_err $? "wrong overlimits, expected 10 got ${overlimits}"
 
 	tc filter del dev $h1 egress protocol ip pref 100 handle 100 flower
 	tc filter del dev $h1 egress protocol ip pref 101 handle 101 flower
-- 
2.43.0



