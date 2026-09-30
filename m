Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BADA51AEEE;
	Wed, 30 Sep 2026 16:15:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784932; cv=none; b=nJ2UMsHMxlWmBX9544tZOMrcehiM7Rz/Uxo+I9Jfrg02et7Kn7hUIZiPp1XEuPcL71Re/My6M3hkNS9ki7AZaDIEEFH64fPrr0EsYPipjIcpOs6UPIhg22IAjUGCmuJW59pCST4faCJ8KjzyMkBI/K8F826FOFInfafXGEie9ck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784932; c=relaxed/simple;
	bh=0CRLSprwdOQn/taV+JkicWEITRh7EdQ7zSP80aPLIfU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hdnPMdpGVqpsBpioGcSZ4naHG+I3rchp4HCKVA07A0zfA9sOpFImJPKKqoF8B10nI32DFkzdYEsBv2/J+kVYcE4zVsPSlHZbMFA18MkcMA1J77EOE5w1Xs0rjtqBvaxrqr8kczZS1FORmxNN39x4PWNEfv+KWZlqYaHAnaFK/M0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JdxCkRQk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JdxCkRQk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF5101F00893;
	Wed, 30 Sep 2026 16:15:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784929;
	bh=yxkENsWikiIa14wMBw1WdTLVOPAHOTc2o6zFpLcs0uI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JdxCkRQk76gIjqs+WZ2fiD3jTYTf8ja/3gokBVynerCHIb/9IM91aiYEmCG7jDKw0
	 qHmLGvtSSvx3yk9UWz96W4iYQpS4DvWcFyviH6OiXAiSeMlxW5riaew9Kz0tdIGTR6
	 TaSXV35SHJh1OpPlexGzHyohc0MtzubPUn8FumlQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Victor Nogueira <victor@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 329/982] net/sched: act_api: size the RTM_GETACTION reply from the actions
Date: Wed, 30 Sep 2026 17:17:45 +0200
Message-ID: <20260930152423.886418625@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

From: Victor Nogueira <victor@mojatatu.com>

[ Upstream commit e9ca46ebc3262b498626c4095826b8fa034bbf21 ]

tca_action_gd() already walks every requested action and accumulates
attr_size += tcf_action_fill_size(act), then wraps the result in
tcf_action_full_attrs_size().  For RTM_DELACTION that value is handed to
tcf_del_notify_msg(), which allocates max(attr_size, NLMSG_GOODSIZE).  For
RTM_GETACTION it is silently discarded and tcf_get_notify() allocates a
fixed NLMSG_GOODSIZE skb instead.

Any action whose dump exceeds that fixed budget therefore cannot be read
back. For example, act_pedit overruns the budget with 32 actions of four
munge keys each, act_police with 32 policers once the optional
rate/peakrate/result/avrate attributes are present

Fix this by passing attr_size through and allocate the reply the way the
add and delete paths do.

Note on exposure: RTM_GETACTION is the only one of the three action
commands that is not capability checked - tc_ctl_action() requires
CAP_NET_ADMIN for RTM_NEWACTION and RTM_DELACTION only - so this turns a
fixed NLMSG_GOODSIZE reply into a user sized allocation on an
unprivileged path.  It is bounded by TCA_ACT_MAX_PRIO actions per
request, and tca_action_gd() does not reject duplicate indices, so a
single large action can be requested 32 times; an act_bpf program near
BPF_MAXINSNS is about 32KB of dump, or roughly 1MB for one request.
Creating such an action still requires CAP_NET_ADMIN, and the add and
delete paths have sized their skbs this way since the Fixes commit.
Should this ever need bounding, GFP_KERNEL_ACCOUNT would charge the
reply to the caller's memcg.

Fixes: 4e76e75d6aba ("net sched actions: calculate add/delete event message size")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260810164357.1653956-1-victor%40mojatatu.com
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Victor Nogueira <victor@mojatatu.com>
Link: https://patch.msgid.link/20260824153903.4143642-3-victor@mojatatu.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/act_api.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index b3fb160765dbe..26dd0158f14ef 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -1665,12 +1665,12 @@ static int tca_get_fill(struct sk_buff *skb, struct tc_action *actions[],
 
 static int
 tcf_get_notify(struct net *net, u32 portid, struct nlmsghdr *n,
-	       struct tc_action *actions[], int event,
+	       struct tc_action *actions[], size_t attr_size, int event,
 	       struct netlink_ext_ack *extack)
 {
 	struct sk_buff *skb;
 
-	skb = alloc_skb(NLMSG_GOODSIZE, GFP_KERNEL);
+	skb = alloc_skb(max(attr_size, NLMSG_GOODSIZE), GFP_KERNEL);
 	if (!skb)
 		return -ENOBUFS;
 	if (tca_get_fill(skb, actions, portid, n->nlmsg_seq, 0, event,
@@ -1990,7 +1990,8 @@ tca_action_gd(struct net *net, struct nlattr *nla, struct nlmsghdr *n,
 	attr_size = tcf_action_full_attrs_size(attr_size);
 
 	if (event == RTM_GETACTION)
-		ret = tcf_get_notify(net, portid, n, actions, event, extack);
+		ret = tcf_get_notify(net, portid, n, actions, attr_size, event,
+				     extack);
 	else { /* delete */
 		ret = tcf_del_notify(net, n, actions, portid, attr_size, extack);
 		if (ret)
-- 
2.53.0



