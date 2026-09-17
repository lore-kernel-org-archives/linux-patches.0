Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F5D04ABBBC;
	Thu, 17 Sep 2026 17:13:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665193; cv=none; b=Q7z2SpVr7xDann+OyR9FBBd75AkXRh0+x7wdBJ5+n8sU7qjq/tyHj8qiQNx32e22Wvj5jwBfCaAYU+ND5NEm/qpCER2/PCgrwWUs0e+c4z/P37xzy8iouD0GqK5dh9D0XhM5RR5aWojXyEHQB50H7kY/FBXhHuY7jBf40HT3VYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665193; c=relaxed/simple;
	bh=DKNCSMBtzbmUDbeoEy6vPZm5IlCEL+MnAUBQg3JKaiU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X1M84w6mGiGS5JWTqHTWlUXQLBNTC4WkDxMIM7DVGtfnUHelZGRmXo8aA383L30DsHGSgt6I3CE6RsSsWZ0zbCWopOgN4S9w+tY4Fb786fL4UHSI0KEMxk9rVBgt6Wa1Rizzydisp336R+PBi/xi+OhuXwMyOCnQlChZ6AhGZrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pCEtf6dy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pCEtf6dy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77DE31F000FF;
	Thu, 17 Sep 2026 17:13:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665192;
	bh=+26BveIwvjMk7h+ONSAaiD18Ysvzhkkq859Gqhm/BLw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pCEtf6dyh1BwWGPmq1fXN95tfHLXLwlwHobqtfV1tA6SgjRG/G5jvJPrDZxqN2EGS
	 CY//P6DgvZU2AmV/rDKLJppHFNv7hHa7JnIL4LY/fILncT4HWyNB0mdyAj6CpGzGt/
	 oAgv1UaspezRzIFU1rIZa0tORDoWeeQqL4Bi5Cjw=
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
Subject: [PATCH 6.18 0623/1250] net/sched: act_api: fix skb sizing and action leak on reoffload delete
Date: Thu, 17 Sep 2026 16:06:58 +0100
Message-ID: <20260917151608.764897801@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 9291e622f7251..ee0c86fcc9511 100644
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



