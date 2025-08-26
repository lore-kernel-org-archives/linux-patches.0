Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91B393431FE;
	Tue, 26 Aug 2025 14:45:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756219515; cv=none; b=IueDZIrmxbbuev6Pa05CyJQAXadonGsztglPaLnkd27eEoUUPsccHXNvjRq8pPP+K1z0IttHAe2/SLgeSX10Bv3rnu4fKFqK7tC4zM3XFZnWajCpOCYIB3FYB+6XtiCNDQKFJU/Dj/YmIVg7MRw3MUWl0QxM3/0E57IAIgeFksc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756219515; c=relaxed/simple;
	bh=b1N+EIuYUOm4XHwRaZD8yVb+pVtojaan0BbcgMv1pLk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bQ/wEjsg0krVF/RZaYwktysyd/xwZTYQARzv10f68xX6Cio9h/2f6SwRbv51zYyztAtw3K2KkL1SIJsMYcph+dJdMsdMC1tq6flAShElHn+Aoj39TThdYtFsJ36CzSWZRjLfD0wI5Tr2SFK8vUBkq55gCoh6XQsxdj2oTdqqp5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YkAk/g0K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YkAk/g0K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 258B1C4CEF1;
	Tue, 26 Aug 2025 14:45:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756219515;
	bh=b1N+EIuYUOm4XHwRaZD8yVb+pVtojaan0BbcgMv1pLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YkAk/g0KFDqdLBbodLOMZdlE97Wkj2v4GzxBLrvDhdfGjVFedllN+pqJbHNJpP7yR
	 HwWLks4VtV0eS5GuE2rTfJteQSUfTVRRnJaH6ER3mbB9F81DZfcqHlQ3YsnQknQXi9
	 L3gIQQ0eeo/KpZoAC1AtIvNADtQUNdhj/tMtcF8E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vlad Buslov <vladbu@mellanox.com>,
	Jiri Pirko <jiri@mellanox.com>,
	"David S. Miller" <davem@davemloft.net>,
	Shubham Kulkarni <skulkarni@mvista.com>
Subject: [PATCH 5.4 384/403] net: sched: extract qstats update code into functions
Date: Tue, 26 Aug 2025 13:11:50 +0200
Message-ID: <20250826110917.627437234@linuxfoundation.org>
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

[ Upstream commit 26b537a88ca5b7399c7ab0656e06dbd9da9513c1 ]

Extract common code that increments cpu_qstats counters into standalone act
API functions. Change hardware offloaded actions that use percpu counter
allocation to use the new functions instead of accessing cpu_qstats
directly.

This commit doesn't change functionality.

Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: ca22da2fbd69 ("act_mirred: use the backlog for nested calls to mirred ingress")
Signed-off-by: Shubham Kulkarni <skulkarni@mvista.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/act_api.h  |   16 ++++++++++++++++
 net/sched/act_csum.c   |    2 +-
 net/sched/act_ct.c     |    2 +-
 net/sched/act_gact.c   |    2 +-
 net/sched/act_mirred.c |    2 +-
 net/sched/act_vlan.c   |    2 +-
 6 files changed, 21 insertions(+), 5 deletions(-)

--- a/include/net/act_api.h
+++ b/include/net/act_api.h
@@ -193,6 +193,22 @@ static inline void tcf_action_update_bst
 	bstats_cpu_update(this_cpu_ptr(a->cpu_bstats), skb);
 }
 
+static inline struct gnet_stats_queue *
+tcf_action_get_qstats(struct tc_action *a)
+{
+	return this_cpu_ptr(a->cpu_qstats);
+}
+
+static inline void tcf_action_inc_drop_qstats(struct tc_action *a)
+{
+	qstats_drop_inc(this_cpu_ptr(a->cpu_qstats));
+}
+
+static inline void tcf_action_inc_overlimit_qstats(struct tc_action *a)
+{
+	qstats_overlimit_inc(this_cpu_ptr(a->cpu_qstats));
+}
+
 void tcf_action_update_stats(struct tc_action *a, u64 bytes, u32 packets,
 			     bool drop, bool hw);
 int tcf_action_copy_stats(struct sk_buff *, struct tc_action *, int);
--- a/net/sched/act_csum.c
+++ b/net/sched/act_csum.c
@@ -621,7 +621,7 @@ out:
 	return action;
 
 drop:
-	qstats_drop_inc(this_cpu_ptr(p->common.cpu_qstats));
+	tcf_action_inc_drop_qstats(&p->common);
 	action = TC_ACT_SHOT;
 	goto out;
 }
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -486,7 +486,7 @@ out:
 	return retval;
 
 drop:
-	qstats_drop_inc(this_cpu_ptr(a->cpu_qstats));
+	tcf_action_inc_drop_qstats(&c->common);
 	return TC_ACT_SHOT;
 }
 
--- a/net/sched/act_gact.c
+++ b/net/sched/act_gact.c
@@ -161,7 +161,7 @@ static int tcf_gact_act(struct sk_buff *
 #endif
 	tcf_action_update_bstats(&gact->common, skb);
 	if (action == TC_ACT_SHOT)
-		qstats_drop_inc(this_cpu_ptr(gact->common.cpu_qstats));
+		tcf_action_inc_drop_qstats(&gact->common);
 
 	tcf_lastuse_update(&gact->tcf_tm);
 
--- a/net/sched/act_mirred.c
+++ b/net/sched/act_mirred.c
@@ -309,7 +309,7 @@ static int tcf_mirred_act(struct sk_buff
 
 	if (err) {
 out:
-		qstats_overlimit_inc(this_cpu_ptr(m->common.cpu_qstats));
+		tcf_action_inc_overlimit_qstats(&m->common);
 		if (tcf_mirred_is_act_redirect(m_eaction))
 			retval = TC_ACT_SHOT;
 	}
--- a/net/sched/act_vlan.c
+++ b/net/sched/act_vlan.c
@@ -88,7 +88,7 @@ out:
 	return action;
 
 drop:
-	qstats_drop_inc(this_cpu_ptr(v->common.cpu_qstats));
+	tcf_action_inc_drop_qstats(&v->common);
 	return TC_ACT_SHOT;
 }
 


