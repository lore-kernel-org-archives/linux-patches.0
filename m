Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B2ED8F5B
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:25:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1CCBC433C8;
	Sun, 16 Jul 2023 20:25:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689539114;
	bh=ylC9+P9HFpZwtOoIbN96sdhpaT7qaKkT+xJlBYChV8U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n/fcBxLUAOVXW+mONeaCmuJTIeFnCpvSWM5dKoXZpOb9h5S+MWnZAldDqvm4W09F4
	 coDu1pK4f3mnCLIK3pVHyE6flktoaHrGwzsFUEcMccAYx7ptjq6IopL0+DXLhy64j7
	 ZTiElw2QOZ+2UMgDFY0jetv6ndYYygSOIOAKoaBw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Simon Horman <simon.horman@corigine.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 663/800] net/sched: act_ipt: add sanity checks on skb before calling target
Date: Sun, 16 Jul 2023 21:48:36 +0200
Message-ID: <20230716195004.512098547@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

[ Upstream commit b2dc32dcba08bf55cec600caa76f4afd2e3614df ]

Netfilter targets make assumptions on the skb state, for example
iphdr is supposed to be in the linear area.

This is normally done by IP stack, but in act_ipt case no
such checks are made.

Some targets can even assume that skb_dst will be valid.
Make a minimum effort to check for this:

- Don't call the targets eval function for non-ipv4 skbs.
- Don't call the targets eval function for POSTROUTING
  emulation when the skb has no dst set.

v3: use skb_protocol helper (Davide Caratti)

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Florian Westphal <fw@strlen.de>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/act_ipt.c | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/net/sched/act_ipt.c b/net/sched/act_ipt.c
index ea7f151e7dd29..a6b522b512dc3 100644
--- a/net/sched/act_ipt.c
+++ b/net/sched/act_ipt.c
@@ -230,6 +230,26 @@ static int tcf_xt_init(struct net *net, struct nlattr *nla,
 			      a, &act_xt_ops, tp, flags);
 }
 
+static bool tcf_ipt_act_check(struct sk_buff *skb)
+{
+	const struct iphdr *iph;
+	unsigned int nhoff, len;
+
+	if (!pskb_may_pull(skb, sizeof(struct iphdr)))
+		return false;
+
+	nhoff = skb_network_offset(skb);
+	iph = ip_hdr(skb);
+	if (iph->ihl < 5 || iph->version != 4)
+		return false;
+
+	len = skb_ip_totlen(skb);
+	if (skb->len < nhoff + len || len < (iph->ihl * 4u))
+		return false;
+
+	return pskb_may_pull(skb, iph->ihl * 4u);
+}
+
 TC_INDIRECT_SCOPE int tcf_ipt_act(struct sk_buff *skb,
 				  const struct tc_action *a,
 				  struct tcf_result *res)
@@ -244,9 +264,22 @@ TC_INDIRECT_SCOPE int tcf_ipt_act(struct sk_buff *skb,
 		.pf	= NFPROTO_IPV4,
 	};
 
+	if (skb_protocol(skb, false) != htons(ETH_P_IP))
+		return TC_ACT_UNSPEC;
+
 	if (skb_unclone(skb, GFP_ATOMIC))
 		return TC_ACT_UNSPEC;
 
+	if (!tcf_ipt_act_check(skb))
+		return TC_ACT_UNSPEC;
+
+	if (state.hook == NF_INET_POST_ROUTING) {
+		if (!skb_dst(skb))
+			return TC_ACT_UNSPEC;
+
+		state.out = skb->dev;
+	}
+
 	spin_lock(&ipt->tcf_lock);
 
 	tcf_lastuse_update(&ipt->tcf_tm);
-- 
2.39.2



