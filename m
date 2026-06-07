Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39E3231E844;
	Sun,  7 Jun 2026 10:21:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827699; cv=none; b=WLd12SuAO97OwHJP66bSPesXuFNddRu6cckKcyhqkBc9Cet1hJ6djXG7KtMaUkZCRpwXMAMR203hwRECDij5eOwWY1WdcVCR7e5eA6k4UgBI3lpl1zqAYlVgYHXF9/6n9AsxwNjoEZt1C79G3BYE4GyUfuDTah71u7mTvaQVL+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827699; c=relaxed/simple;
	bh=hXkxGg5XV7RM0OVMUraLiVMyMs8pZSYnlONNOUtV9I8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mC8TKKsV4u0qOC5TfWA3N8n7zNGhYVrr/g6Hejki0bI+CY2LPWKvbg5nscwIWUrJc3vtYGG4wrLCEr+UMjAaMl22vIxTh4N9F0YFAf5MV/LbXD5R1q9DW/1JKl597r/iMq85T5MtoExe2hCwQewZ9dXmDyo9dZXHazNCnahUNMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BGtcqcMK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BGtcqcMK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B8F51F00893;
	Sun,  7 Jun 2026 10:21:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827696;
	bh=QHg0EUCueGwOa/jdHKy6Kl8kbGLOaDSw2s7uZvR/1b4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BGtcqcMKkGWu3bMz1Hw1eiLLNMNjdevi/Rs1FEkszlgkRCKzEKJsE59YCLMFC1EfY
	 Yn5NDVIpmy7txt5slX44anRQUqPilFms8h1M68JIbsK3qZre4GHTbjTbd1OZyXwlh6
	 nHUPEZRbN9TwpRf8u5oImJmmxXvvRq/KWxR3Ndoc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Victor Nogueira <victor@mojatatu.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 079/307] net/sched: act_mirred: Fix return code in early mirred redirect error paths
Date: Sun,  7 Jun 2026 11:57:56 +0200
Message-ID: <20260607095730.675997756@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
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

From: Victor Nogueira <victor@mojatatu.com>

[ Upstream commit e80ad525fc7e8c933ad78478c5dda286cfd55c60 ]

Since retval is set as TC_ACT_STOLEN in the mirred redirect case, returning
retval in cases where redirect failed will make the callers not register
the skb as being dropped.

Fix this by returning TC_ACT_SHOT instead in such scenarios.

Fixes: 16085e48cb48 ("net/sched: act_mirred: Create function tcf_mirred_to_dev and improve readability")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260413082027.2244884-1-hxzene%40gmail.com
Signed-off-by: Victor Nogueira <victor@mojatatu.com>
Link: https://patch.msgid.link/20260525122556.973584-8-jhs@mojatatu.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/act_mirred.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/net/sched/act_mirred.c b/net/sched/act_mirred.c
index ae9b307ad66e0d..41b731176dfe77 100644
--- a/net/sched/act_mirred.c
+++ b/net/sched/act_mirred.c
@@ -363,7 +363,8 @@ static int tcf_blockcast_redir(struct sk_buff *skb, struct tcf_mirred *m,
 					 dev_is_mac_header_xmit(dev_prev),
 					 m_eaction, retval);
 
-	return retval;
+	/* If the packet wasn't redirected, we have to register as a drop */
+	return TC_ACT_SHOT;
 }
 
 static int tcf_blockcast_mirror(struct sk_buff *skb, struct tcf_mirred *m,
@@ -403,7 +404,7 @@ static int tcf_blockcast(struct sk_buff *skb, struct tcf_mirred *m,
 	block = tcf_block_lookup(dev_net(skb->dev), blockid);
 	if (!block || xa_empty(&block->ports)) {
 		tcf_action_inc_overlimit_qstats(&m->common);
-		return retval;
+		return is_redirect ? TC_ACT_SHOT : retval;
 	}
 
 	if (is_redirect)
@@ -421,8 +422,8 @@ TC_INDIRECT_SCOPE int tcf_mirred_act(struct sk_buff *skb,
 {
 	struct tcf_mirred *m = to_mirred(a);
 	int retval = READ_ONCE(m->tcf_action);
+	bool m_mac_header_xmit, is_redirect;
 	struct netdev_xmit *xmit;
-	bool m_mac_header_xmit;
 	struct net_device *dev;
 	bool want_ingress;
 	int i, m_eaction;
@@ -447,11 +448,13 @@ TC_INDIRECT_SCOPE int tcf_mirred_act(struct sk_buff *skb,
 	if (blockid)
 		return tcf_blockcast(skb, m, blockid, res, retval);
 
+	is_redirect = tcf_mirred_is_act_redirect(m_eaction);
+
 	dev = rcu_dereference_bh(m->tcfm_dev);
 	if (unlikely(!dev)) {
 		pr_notice_once("tc mirred: target device is gone\n");
 		tcf_action_inc_overlimit_qstats(&m->common);
-		return retval;
+		goto err_out;
 	}
 
 	m_eaction = READ_ONCE(m->tcfm_eaction);
@@ -463,7 +466,7 @@ TC_INDIRECT_SCOPE int tcf_mirred_act(struct sk_buff *skb,
 			pr_notice_once("tc mirred: loop on device %s\n",
 				       netdev_name(dev));
 			tcf_action_inc_overlimit_qstats(&m->common);
-			return retval;
+			goto err_out;
 		}
 		xmit->sched_mirred_dev[xmit->sched_mirred_nest++] = dev;
 	}
@@ -476,6 +479,11 @@ TC_INDIRECT_SCOPE int tcf_mirred_act(struct sk_buff *skb,
 		xmit->sched_mirred_nest--;
 
 	return retval;
+
+err_out:
+	if (is_redirect)
+		retval = TC_ACT_SHOT;
+	return retval;
 }
 
 static void tcf_stats_update(struct tc_action *a, u64 bytes, u64 packets,
-- 
2.53.0



