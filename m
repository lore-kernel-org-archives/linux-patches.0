Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 810438F5B
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:25:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06C7EC433C8;
	Sun, 16 Jul 2023 20:25:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689539111;
	bh=jooB9f2UUfNrDrT9W/2rEGMLLbq+wtdriwsqDDXK9Pc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mfUrIDYNZ3YqmBFi/mCh90lHBm2IFljvzjseLbHgrhagIo7xSN7jVC0Z2lI5eeDkx
	 37MA9P09T8dvnT+ZRLg4H7v/VU8txV7mbHe91iJ58m38lBZVLF5yOXu9ciOjMOy3Md
	 eS+z9eZv8g+MzYPtR5rSXAdwU+kr7kG/g+t0SLno=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Simon Horman <simon.horman@corigine.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 662/800] net/sched: act_ipt: add sanity checks on table name and hook locations
Date: Sun, 16 Jul 2023 21:48:35 +0200
Message-ID: <20230716195004.488838108@linuxfoundation.org>
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

[ Upstream commit b4ee93380b3c891fea996af8d1d3ca0e36ad31f0 ]

Looks like "tc" hard-codes "mangle" as the only supported table
name, but on kernel side there are no checks.

This is wrong.  Not all xtables targets are safe to call from tc.
E.g. "nat" targets assume skb has a conntrack object assigned to it.
Normally those get called from netfilter nat core which consults the
nat table to obtain the address mapping.

"tc" userspace either sets PRE or POSTROUTING as hook number, but there
is no validation of this on kernel side, so update netlink policy to
reject bogus numbers.  Some targets may assume skb_dst is set for
input/forward hooks, so prevent those from being used.

act_ipt uses the hook number in two places:
1. the state hook number, this is fine as-is
2. to set par.hook_mask

The latter is a bit mask, so update the assignment to make
xt_check_target() to the right thing.

Followup patch adds required checks for the skb/packet headers before
calling the targets evaluation function.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Florian Westphal <fw@strlen.de>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/act_ipt.c | 27 ++++++++++++++++++++-------
 1 file changed, 20 insertions(+), 7 deletions(-)

diff --git a/net/sched/act_ipt.c b/net/sched/act_ipt.c
index 5d96ffebd40f0..ea7f151e7dd29 100644
--- a/net/sched/act_ipt.c
+++ b/net/sched/act_ipt.c
@@ -48,7 +48,7 @@ static int ipt_init_target(struct net *net, struct xt_entry_target *t,
 	par.entryinfo = &e;
 	par.target    = target;
 	par.targinfo  = t->data;
-	par.hook_mask = hook;
+	par.hook_mask = 1 << hook;
 	par.family    = NFPROTO_IPV4;
 
 	ret = xt_check_target(&par, t->u.target_size - sizeof(*t), 0, false);
@@ -85,7 +85,8 @@ static void tcf_ipt_release(struct tc_action *a)
 
 static const struct nla_policy ipt_policy[TCA_IPT_MAX + 1] = {
 	[TCA_IPT_TABLE]	= { .type = NLA_STRING, .len = IFNAMSIZ },
-	[TCA_IPT_HOOK]	= { .type = NLA_U32 },
+	[TCA_IPT_HOOK]	= NLA_POLICY_RANGE(NLA_U32, NF_INET_PRE_ROUTING,
+					   NF_INET_NUMHOOKS),
 	[TCA_IPT_INDEX]	= { .type = NLA_U32 },
 	[TCA_IPT_TARG]	= { .len = sizeof(struct xt_entry_target) },
 };
@@ -158,15 +159,27 @@ static int __tcf_ipt_init(struct net *net, unsigned int id, struct nlattr *nla,
 			return -EEXIST;
 		}
 	}
+
+	err = -EINVAL;
 	hook = nla_get_u32(tb[TCA_IPT_HOOK]);
+	switch (hook) {
+	case NF_INET_PRE_ROUTING:
+		break;
+	case NF_INET_POST_ROUTING:
+		break;
+	default:
+		goto err1;
+	}
+
+	if (tb[TCA_IPT_TABLE]) {
+		/* mangle only for now */
+		if (nla_strcmp(tb[TCA_IPT_TABLE], "mangle"))
+			goto err1;
+	}
 
-	err = -ENOMEM;
-	tname = kmalloc(IFNAMSIZ, GFP_KERNEL);
+	tname = kstrdup("mangle", GFP_KERNEL);
 	if (unlikely(!tname))
 		goto err1;
-	if (tb[TCA_IPT_TABLE] == NULL ||
-	    nla_strscpy(tname, tb[TCA_IPT_TABLE], IFNAMSIZ) >= IFNAMSIZ)
-		strcpy(tname, "mangle");
 
 	t = kmemdup(td, td->u.target_size, GFP_KERNEL);
 	if (unlikely(!t))
-- 
2.39.2



