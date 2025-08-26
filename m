Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19E1B35E4D9;
	Tue, 26 Aug 2025 14:44:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756219443; cv=none; b=FJsEfiI9yzNz7LR6x6UJy75UivOvkX5T+4JqgWdGMLWmPnyLV7fHAqZ6jqDJreWNtrKi44Rh8di7uOtB8FPoFM2xJJcnCscDb0ywqM5VJX5U1Nh4mU08hXm0VKvOZXUJG74hTVRZdNpZShrh5JtcbLce1ttPdWFSBFDaQdDmZyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756219443; c=relaxed/simple;
	bh=VAjM2mrI9l+wifox40+hV44sjwdC+/M4JqgqbkB22Tw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=drYntzFjRKQndAMqfpPV6jNCSv7+3WPc7Z2bbnK7yNLLwBxT4OWlBFp2KzkaYSGmAwx2DHUpWzba/Qdr1F+feMMc/2wVq1vyvMB9ejEXys0cAb20+uUg9oysd0Y8C7Jt2OhKfuiLH467IGgSfGhfbcwuQeEOHZCSTyilkiY205I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o6hyYta9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o6hyYta9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BCEAC4CEF1;
	Tue, 26 Aug 2025 14:44:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756219443;
	bh=VAjM2mrI9l+wifox40+hV44sjwdC+/M4JqgqbkB22Tw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o6hyYta9Y+SfklPGH6cUBC27o/O0GL/N0Ge5dr0rh8gHo7/hEF1Rt+Un2zeW8ye2C
	 wzDcIv7iQaNqPTDCOnv2ZRUw3+oa7iCGrmZ3sUhqPbzl6R7PPlOTzfbPvQjQIb/Wpo
	 0pUevS2oklhV14Q8UYWpviUcxpqGtuZiRmKJlXkQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vlad Buslov <vladbu@mellanox.com>,
	Jiri Pirko <jiri@mellanox.com>,
	"David S. Miller" <davem@davemloft.net>,
	Shubham Kulkarni <skulkarni@mvista.com>
Subject: [PATCH 5.4 382/403] net: sched: extract common action counters update code into function
Date: Tue, 26 Aug 2025 13:11:48 +0200
Message-ID: <20250826110917.570746650@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vlad Buslov <vladbu@mellanox.com>

[ Upstream commit c8ecebd04cbb6badb46d42fe54282e7883ed63cc ]

Currently, all implementations of tc_action_ops->stats_update() callback
have almost exactly the same implementation of counters update
code (besides gact which also updates drop counter). In order to simplify
support for using both percpu-allocated and regular action counters
depending on run-time flag in following patches, extract action counters
update code into standalone function in act API.

This commit doesn't change functionality.

Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: ca22da2fbd69 ("act_mirred: use the backlog for nested calls to mirred ingress")
Signed-off-by: Shubham Kulkarni <skulkarni@mvista.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/act_api.h  |    2 ++
 net/sched/act_api.c    |   14 ++++++++++++++
 net/sched/act_ct.c     |    6 +-----
 net/sched/act_gact.c   |   10 +---------
 net/sched/act_mirred.c |    5 +----
 net/sched/act_police.c |    5 +----
 net/sched/act_vlan.c   |    5 +----
 7 files changed, 21 insertions(+), 26 deletions(-)

--- a/include/net/act_api.h
+++ b/include/net/act_api.h
@@ -186,6 +186,8 @@ int tcf_action_dump(struct sk_buff *skb,
 		    int ref);
 int tcf_action_dump_old(struct sk_buff *skb, struct tc_action *a, int, int);
 int tcf_action_dump_1(struct sk_buff *skb, struct tc_action *a, int, int);
+void tcf_action_update_stats(struct tc_action *a, u64 bytes, u32 packets,
+			     bool drop, bool hw);
 int tcf_action_copy_stats(struct sk_buff *, struct tc_action *, int);
 
 int tcf_action_check_ctrlact(int action, struct tcf_proto *tp,
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -1032,6 +1032,20 @@ err:
 	return err;
 }
 
+void tcf_action_update_stats(struct tc_action *a, u64 bytes, u32 packets,
+			     bool drop, bool hw)
+{
+	_bstats_cpu_update(this_cpu_ptr(a->cpu_bstats), bytes, packets);
+
+	if (drop)
+		this_cpu_ptr(a->cpu_qstats)->drops += packets;
+
+	if (hw)
+		_bstats_cpu_update(this_cpu_ptr(a->cpu_bstats_hw),
+				   bytes, packets);
+}
+EXPORT_SYMBOL(tcf_action_update_stats);
+
 int tcf_action_copy_stats(struct sk_buff *skb, struct tc_action *p,
 			  int compat_mode)
 {
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -917,11 +917,7 @@ static void tcf_stats_update(struct tc_a
 {
 	struct tcf_ct *c = to_ct(a);
 
-	_bstats_cpu_update(this_cpu_ptr(a->cpu_bstats), bytes, packets);
-
-	if (hw)
-		_bstats_cpu_update(this_cpu_ptr(a->cpu_bstats_hw),
-				   bytes, packets);
+	tcf_action_update_stats(a, bytes, packets, false, hw);
 	c->tcf_tm.lastuse = max_t(u64, c->tcf_tm.lastuse, lastuse);
 }
 
--- a/net/sched/act_gact.c
+++ b/net/sched/act_gact.c
@@ -175,15 +175,7 @@ static void tcf_gact_stats_update(struct
 	int action = READ_ONCE(gact->tcf_action);
 	struct tcf_t *tm = &gact->tcf_tm;
 
-	_bstats_cpu_update(this_cpu_ptr(gact->common.cpu_bstats), bytes,
-			   packets);
-	if (action == TC_ACT_SHOT)
-		this_cpu_ptr(gact->common.cpu_qstats)->drops += packets;
-
-	if (hw)
-		_bstats_cpu_update(this_cpu_ptr(gact->common.cpu_bstats_hw),
-				   bytes, packets);
-
+	tcf_action_update_stats(a, bytes, packets, action == TC_ACT_SHOT, hw);
 	tm->lastuse = max_t(u64, tm->lastuse, lastuse);
 }
 
--- a/net/sched/act_mirred.c
+++ b/net/sched/act_mirred.c
@@ -324,10 +324,7 @@ static void tcf_stats_update(struct tc_a
 	struct tcf_mirred *m = to_mirred(a);
 	struct tcf_t *tm = &m->tcf_tm;
 
-	_bstats_cpu_update(this_cpu_ptr(a->cpu_bstats), bytes, packets);
-	if (hw)
-		_bstats_cpu_update(this_cpu_ptr(a->cpu_bstats_hw),
-				   bytes, packets);
+	tcf_action_update_stats(a, bytes, packets, false, hw);
 	tm->lastuse = max_t(u64, tm->lastuse, lastuse);
 }
 
--- a/net/sched/act_police.c
+++ b/net/sched/act_police.c
@@ -306,10 +306,7 @@ static void tcf_police_stats_update(stru
 	struct tcf_police *police = to_police(a);
 	struct tcf_t *tm = &police->tcf_tm;
 
-	_bstats_cpu_update(this_cpu_ptr(a->cpu_bstats), bytes, packets);
-	if (hw)
-		_bstats_cpu_update(this_cpu_ptr(a->cpu_bstats_hw),
-				   bytes, packets);
+	tcf_action_update_stats(a, bytes, packets, false, hw);
 	tm->lastuse = max_t(u64, tm->lastuse, lastuse);
 }
 
--- a/net/sched/act_vlan.c
+++ b/net/sched/act_vlan.c
@@ -308,10 +308,7 @@ static void tcf_vlan_stats_update(struct
 	struct tcf_vlan *v = to_vlan(a);
 	struct tcf_t *tm = &v->tcf_tm;
 
-	_bstats_cpu_update(this_cpu_ptr(a->cpu_bstats), bytes, packets);
-	if (hw)
-		_bstats_cpu_update(this_cpu_ptr(a->cpu_bstats_hw),
-				   bytes, packets);
+	tcf_action_update_stats(a, bytes, packets, false, hw);
 	tm->lastuse = max_t(u64, tm->lastuse, lastuse);
 }
 


