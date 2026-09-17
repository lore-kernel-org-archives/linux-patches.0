Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21FDC497383;
	Thu, 17 Sep 2026 15:27:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789658854; cv=none; b=GhPuclLuGG7R59N6W0XMSD5Y4uSmRBvqjmODE9y5xDbFqVZk4By7VO2ip2C0Nj1NzDDnXAcvpFFDRzCDtcGTRnknIN3pMbBeuFUF5v8zF1lAvsJqMXy7/B628Dn4e3kW2qdqWc1HcGs22kY0EGwYkZPKWOltuaHv6y9wgmOpQYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789658854; c=relaxed/simple;
	bh=y+aM/ivX3GIf/RDV3iFi7D7ivopCh8ArNL0z8Fj5HBo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OuadCS4c7GYviAYXZcCK2UxeuAFEh2BYFRVGGwANBslIPoCAzxoc+2hXHnSx/9ifNL6P9PhdygbhCt7VK/Nac4qYWfsH+N3+LEnvostbDCsmXcCrfUJ8kZUhfUcFtfAzg+biUKGIp6CyAWTZrw+pAdbliPOqj61Vpcy/keTShY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ouIi3nCo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ouIi3nCo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EE101F00898;
	Thu, 17 Sep 2026 15:27:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789658844;
	bh=9c0MLaekKpTrm/NaLbU6HanOCtmRvRffWUMVhrQgDZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ouIi3nCo2OjVdIty+6sNrRWLfUEV1oT5OA70/NU/QBr8sFZsDmUphirZClRgq2jjb
	 cFkW1BBCVyBaD81v/8dOF3242sYagqUDWMterLZHz//2NBa/nggeuSVCco0ZbqtYs0
	 prCWQoqJSB5n38eeqFdgLAcs+h76AHd6+YanHSpY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Victor Nogueira <victor@mojatatu.com>,
	Pedro Tammela <pctammela@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 058/733] net/sched: act_api: fix skb sizing and action leak on reoffload delete
Date: Thu, 17 Sep 2026 16:06:06 +0100
Message-ID: <20260917151352.256185924@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Victor Nogueira <victor@mojatatu.com>

[ Upstream commit 251367a0a3319fa565daf7468b0afd933b1f5ab1 ]

tcf_reoffload_del_notify_msg() sizes the RTM_DELACTION skb with
tcf_action_fill_size(action) alone.  Unlike every other notification path
it never wraps that in tcf_action_full_attrs_size(), so the nlmsg_put()
header, struct tcamsg and the TCA_ACT_TAB nest that tca_get_fill() emits -
24 bytes on x86_64 - are not budgeted.  As long as the single action stays
well under NLMSG_GOODSIZE the floor in alloc_skb() hides this, but once its
fill size crosses NLMSG_GOODSIZE the allocation is exactly 24 bytes short
and tca_get_fill() runs out of tailroom.  That is now easy to reach for an
offloadable act_pedit with a large tcfp_nkeys, which commit 8e2efb3f45a5
("net/sched: add get_fill_size callbacks for actions missing them") started
accounting for properly.

When that happens tcf_reoffload_del_notify() returns early, before
tcf_idr_release_unsafe(), and tcf_action_reoffload_cb() discards the return
value:

	if (tc_act_skip_sw(p->tcfa_flags) && !tc_act_in_hw(p))
		tcf_reoffload_del_notify(net, p);

The action has just lost its last hardware instance and is skip_sw, so it
is left installed while processing no packets, and with no notification to
tell userspace about it.  An -ENOBUFS from alloc_skb() gets the same
treatment.

Fix this by budgeting the message header the way the add and delete paths
do, and release the action even when the notification cannot be built -
dropping the notification is strictly better than leaking a dead action,
and there is no caller left to report the error to.

Fixes: 13926d19a11e ("flow_offload: add reoffload process to update hw_count")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260810164357.1653956-1-victor%40mojatatu.com
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Victor Nogueira <victor@mojatatu.com>
Reviewed-by: Pedro Tammela <pctammela@mojatatu.com>
Link: https://patch.msgid.link/20260824153903.4143642-4-victor@mojatatu.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/act_api.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index 20b6501fd33b2..37eced84dfa5f 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -1867,11 +1867,13 @@ static int tcf_action_delete(struct net *net, struct tc_action *actions[])
 static struct sk_buff *tcf_reoffload_del_notify_msg(struct net *net,
 						    struct tc_action *action)
 {
-	size_t attr_size = tcf_action_fill_size(action);
 	struct tc_action *actions[TCA_ACT_MAX_PRIO] = {
 		[0] = action,
 	};
 	struct sk_buff *skb;
+	size_t attr_size;
+
+	attr_size = tcf_action_full_attrs_size(tcf_action_fill_size(action));
 
 	skb = alloc_skb(max(attr_size, NLMSG_GOODSIZE), GFP_KERNEL);
 	if (!skb)
@@ -1888,15 +1890,18 @@ static struct sk_buff *tcf_reoffload_del_notify_msg(struct net *net,
 static int tcf_reoffload_del_notify(struct net *net, struct tc_action *action)
 {
 	const struct tc_action_ops *ops = action->ops;
-	struct sk_buff *skb;
+	struct sk_buff *skb = NULL;
 	int ret;
 
-	if (!rtnl_notify_needed(net, 0, RTNLGRP_TC)) {
-		skb = NULL;
-	} else {
+	if (rtnl_notify_needed(net, 0, RTNLGRP_TC)) {
 		skb = tcf_reoffload_del_notify_msg(net, action);
+		/* The action has already lost its hardware instance and is
+		 * skip_sw, so it must be released whether or not the
+		 * notification can be built.  Drop the notification rather
+		 * than leave an action behind that processes no packets.
+		 */
 		if (IS_ERR(skb))
-			return PTR_ERR(skb);
+			skb = NULL;
 	}
 
 	ret = tcf_idr_release_unsafe(action);
-- 
2.53.0



