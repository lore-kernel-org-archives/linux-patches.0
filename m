Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32C59283FC8;
	Mon, 23 Mar 2026 15:01:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278072; cv=none; b=ZtXgOM3+J+owYXzACqG9qgaK7GNbXMxQu/ipyVUlOn7BWWgfVIp6dsMX1//GjzGcs2WPEjvKmzvR0pIGyw+fKrp/lyX0ir24TSO2bNfjJSd6fmiljj+IGiO/CSf5S7KZQezI2m9tRkNtv2H/+7azx7Yf4o6WRwm+yq9xFvsuNNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278072; c=relaxed/simple;
	bh=AV29Ny7yHNe0OytpfsWkaK/RQEIjvGV6LcmOmWhXXWs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uHTukusA1VMJ2UuZSCdg7eJPQ7ZCso0pmQWRb0uysgNmQMnLMElMfRH7gIEji3DTFBu3l2KHN76TOVkgZm+YULdEZQwKhNjAUXZv8FdYVehULcqlZIQQ9+vWFNkGt7zJC55gj3rrxHs+yetClzhe0vCyU59HvfHdy4rmd9XbV+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0VZlQslZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0VZlQslZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB087C2BCB1;
	Mon, 23 Mar 2026 15:01:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278072;
	bh=AV29Ny7yHNe0OytpfsWkaK/RQEIjvGV6LcmOmWhXXWs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0VZlQslZb0iqQZBtiYKKm5dJE0c7sSZ8nCqpmA33QXHuzqHMyrz1YaA2Cvj978dHy
	 Ki4IlX6VTJr/c8rJCeywH3dtlkuzIOimghw1GySY7gejZhqQXrZ7oz/Y5bRJAHgPQJ
	 XxyZCXSPCtDlSLA3ZpLY/g/m5DkKiT5jX25HSi6g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	GangMin Kim <km.kim1503@gmail.com>,
	Victor Nogueira <victor@mojatatu.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 185/567] net/sched: Only allow act_ct to bind to clsact/ingress qdiscs and shared blocks
Date: Mon, 23 Mar 2026 14:41:45 +0100
Message-ID: <20260323134538.430196877@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Victor Nogueira <victor@mojatatu.com>

commit 11cb63b0d1a0685e0831ae3c77223e002ef18189 upstream.

As Paolo said earlier [1]:

"Since the blamed commit below, classify can return TC_ACT_CONSUMED while
the current skb being held by the defragmentation engine. As reported by
GangMin Kim, if such packet is that may cause a UaF when the defrag engine
later on tries to tuch again such packet."

act_ct was never meant to be used in the egress path, however some users
are attaching it to egress today [2]. Attempting to reach a middle
ground, we noticed that, while most qdiscs are not handling
TC_ACT_CONSUMED, clsact/ingress qdiscs are. With that in mind, we
address the issue by only allowing act_ct to bind to clsact/ingress
qdiscs and shared blocks. That way it's still possible to attach act_ct to
egress (albeit only with clsact).

[1] https://lore.kernel.org/netdev/674b8cbfc385c6f37fb29a1de08d8fe5c2b0fbee.1771321118.git.pabeni@redhat.com/
[2] https://lore.kernel.org/netdev/cc6bfb4a-4a2b-42d8-b9ce-7ef6644fb22b@ovn.org/

Reported-by: GangMin Kim <km.kim1503@gmail.com>
Fixes: 3f14b377d01d ("net/sched: act_ct: fix skb leak and crash on ooo frags")
CC: stable@vger.kernel.org
Signed-off-by: Victor Nogueira <victor@mojatatu.com>
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Link: https://patch.msgid.link/20260225134349.1287037-1-victor@mojatatu.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/act_api.h |    1 +
 net/sched/act_ct.c    |    6 ++++++
 net/sched/cls_api.c   |    7 +++++++
 3 files changed, 14 insertions(+)

--- a/include/net/act_api.h
+++ b/include/net/act_api.h
@@ -68,6 +68,7 @@ struct tc_action {
 #define TCA_ACT_FLAGS_REPLACE	(1U << (TCA_ACT_FLAGS_USER_BITS + 2))
 #define TCA_ACT_FLAGS_NO_RTNL	(1U << (TCA_ACT_FLAGS_USER_BITS + 3))
 #define TCA_ACT_FLAGS_AT_INGRESS	(1U << (TCA_ACT_FLAGS_USER_BITS + 4))
+#define TCA_ACT_FLAGS_AT_INGRESS_OR_CLSACT	(1U << (TCA_ACT_FLAGS_USER_BITS + 5))
 
 /* Update lastuse only if needed, to avoid dirtying a cache line.
  * We use a temp variable to avoid fetching jiffies twice.
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -1327,6 +1327,12 @@ static int tcf_ct_init(struct net *net,
 		return -EINVAL;
 	}
 
+	if (bind && !(flags & TCA_ACT_FLAGS_AT_INGRESS_OR_CLSACT)) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Attaching ct to a non ingress/clsact qdisc is unsupported");
+		return -EOPNOTSUPP;
+	}
+
 	err = nla_parse_nested(tb, TCA_CT_MAX, nla, ct_policy, extack);
 	if (err < 0)
 		return err;
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -2151,6 +2151,11 @@ static bool is_qdisc_ingress(__u32 class
 	return (TC_H_MIN(classid) == TC_H_MIN(TC_H_MIN_INGRESS));
 }
 
+static bool is_ingress_or_clsact(struct tcf_block *block, struct Qdisc *q)
+{
+	return tcf_block_shared(block) || (q && !!(q->flags & TCQ_F_INGRESS));
+}
+
 static int tc_new_tfilter(struct sk_buff *skb, struct nlmsghdr *n,
 			  struct netlink_ext_ack *extack)
 {
@@ -2344,6 +2349,8 @@ replay:
 		flags |= TCA_ACT_FLAGS_NO_RTNL;
 	if (is_qdisc_ingress(parent))
 		flags |= TCA_ACT_FLAGS_AT_INGRESS;
+	if (is_ingress_or_clsact(block, q))
+		flags |= TCA_ACT_FLAGS_AT_INGRESS_OR_CLSACT;
 	err = tp->ops->change(net, skb, tp, cl, t->tcm_handle, tca, &fh,
 			      flags, extack);
 	if (err == 0) {


