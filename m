Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74F93296BDF;
	Tue, 26 Aug 2025 14:44:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756219497; cv=none; b=RcxlkqU0Bfe7KzX2NDGHs017FBy7ktXfT+4Pj5V5ENXw1yHqESZATX5sQmHVv4Xu2K3sdhmqoKbM12gxYqu3MsquukmZ7hfpVMQ6pL9c0yXq/OruoyYJayQekcv2zBlCdHcPZbTBobvuXDyubZXl3067+Cnhwz6yVnCMTXtGCrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756219497; c=relaxed/simple;
	bh=YHiytu09ntTOIrYFSegI8pzis7I53/RKQ2ty3h4QnqM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mvOwMbRFsv91tqa+GqdCm/li4C0HXXnWeoC+Fve9g0ATj89IljqcNl5g2uavH9ZL8el2bV0EBy7EM7mXjTOKmfM8tnBU+NFYsiYDF3amYHBZGVYDRf9VFvx69C2X7clYEwpYYzSsAYFrVREn8NRN0OQ1uCqjpNFPMpulgUX4uKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SLQx7RlT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SLQx7RlT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 044E6C4CEF1;
	Tue, 26 Aug 2025 14:44:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756219497;
	bh=YHiytu09ntTOIrYFSegI8pzis7I53/RKQ2ty3h4QnqM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SLQx7RlTGPcaOp/cmXKro5KRsKZj5XILcp6ZgUsGSRtEzXClISrMLQE/jgjaz/LEF
	 OaQu6Wv48aIEpXJYrPN6Yao0dSRBwrcdmqU2clZ4A7+tBtmaIYNrGAXfLOTW9Sb78f
	 wMV/pFxVpjmi92xiPvM7W5X0UNXAtO8Hqe1fjXCI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	wenxu <wenxu@ucloud.cn>,
	Jakub Kicinski <kuba@kernel.org>,
	Shubham Kulkarni <skulkarni@mvista.com>
Subject: [PATCH 5.4 387/403] net/sched: act_mirred: refactor the handle of xmit
Date: Tue, 26 Aug 2025 13:11:53 +0200
Message-ID: <20250826110917.710119672@linuxfoundation.org>
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

From: wenxu <wenxu@ucloud.cn>

[ Upstream commit fa6d639930ee5cd3f932cc314f3407f07a06582d ]

This one is prepare for the next patch.

Signed-off-by: wenxu <wenxu@ucloud.cn>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ skulkarni: Adjusted patch for file 'sch_generic.h' wrt the mainline commit ]
Stable-dep-of: ca22da2fbd69 ("act_mirred: use the backlog for nested calls to mirred ingress")
Signed-off-by: Shubham Kulkarni <skulkarni@mvista.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/sch_generic.h |    5 -----
 net/sched/act_mirred.c    |   21 +++++++++++++++------
 2 files changed, 15 insertions(+), 11 deletions(-)

--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -1320,11 +1320,6 @@ void mini_qdisc_pair_swap(struct mini_Qd
 void mini_qdisc_pair_init(struct mini_Qdisc_pair *miniqp, struct Qdisc *qdisc,
 			  struct mini_Qdisc __rcu **p_miniq);
 
-static inline int skb_tc_reinsert(struct sk_buff *skb, struct tcf_result *res)
-{
-	return res->ingress ? netif_receive_skb(skb) : dev_queue_xmit(skb);
-}
-
 /* Make sure qdisc is no longer in SCHED state. */
 static inline void qdisc_synchronize(const struct Qdisc *q)
 {
--- a/net/sched/act_mirred.c
+++ b/net/sched/act_mirred.c
@@ -206,6 +206,18 @@ release_idr:
 	return err;
 }
 
+static int tcf_mirred_forward(bool want_ingress, struct sk_buff *skb)
+{
+	int err;
+
+	if (!want_ingress)
+		err = dev_queue_xmit(skb);
+	else
+		err = netif_receive_skb(skb);
+
+	return err;
+}
+
 static int tcf_mirred_act(struct sk_buff *skb, const struct tc_action *a,
 			  struct tcf_result *res)
 {
@@ -295,18 +307,15 @@ static int tcf_mirred_act(struct sk_buff
 		/* let's the caller reinsert the packet, if possible */
 		if (use_reinsert) {
 			res->ingress = want_ingress;
-			if (skb_tc_reinsert(skb, res))
+			err = tcf_mirred_forward(res->ingress, skb);
+			if (err)
 				tcf_action_inc_overlimit_qstats(&m->common);
 			__this_cpu_dec(mirred_rec_level);
 			return TC_ACT_CONSUMED;
 		}
 	}
 
-	if (!want_ingress)
-		err = dev_queue_xmit(skb2);
-	else
-		err = netif_receive_skb(skb2);
-
+	err = tcf_mirred_forward(want_ingress, skb2);
 	if (err) {
 out:
 		tcf_action_inc_overlimit_qstats(&m->common);


