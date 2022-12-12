Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E851D28ED
	for <patches@lists.linux.dev>; Mon, 12 Dec 2022 13:15:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CE2BC433EF;
	Mon, 12 Dec 2022 13:15:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670850929;
	bh=7D/2LWjqxgxhmYLl6dy63DaJ0sKkmsf/8GKqHTnGngY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w7ITMhW/IdLlqfw/Q5GNLuu0HOgz0xpmdXUMkNcQxurkO7OHXnd9twcqqh7tsVbeU
	 t1/z2dClCD85bXWbBdJtkFN/YO27NhFMkFD9kJifUbIINOMmgYjfD7zGbKBDZoTgZu
	 X5OkGuE62wj+bp5ATqS5/BapmyEI6so/qERZRRvM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Ivan Babrou <ivan@ivan.computer>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 067/106] netfilter: ctnetlink: fix compilation warning after data race fixes in ct mark
Date: Mon, 12 Dec 2022 14:10:10 +0100
Message-Id: <20221212130927.807136577@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130924.863767275@linuxfoundation.org>
References: <20221212130924.863767275@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 1feeae071507ad65cf9f462a1bdd543a4bf89e71 ]

All warnings (new ones prefixed by >>):

   net/netfilter/nf_conntrack_netlink.c: In function '__ctnetlink_glue_build':
>> net/netfilter/nf_conntrack_netlink.c:2674:13: warning: unused variable 'mark' [-Wunused-variable]
    2674 |         u32 mark;
         |             ^~~~

Fixes: 52d1aa8b8249 ("netfilter: conntrack: Fix data-races around ct mark")
Reported-by: kernel test robot <lkp@intel.com>
Tested-by: Ivan Babrou <ivan@ivan.computer>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_netlink.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index c402283e7545..2efdc50f978b 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -317,8 +317,13 @@ ctnetlink_dump_timestamp(struct sk_buff *skb, const struct nf_conn *ct)
 }
 
 #ifdef CONFIG_NF_CONNTRACK_MARK
-static int ctnetlink_dump_mark(struct sk_buff *skb, u32 mark)
+static int ctnetlink_dump_mark(struct sk_buff *skb, const struct nf_conn *ct)
 {
+	u32 mark = READ_ONCE(ct->mark);
+
+	if (!mark)
+		return 0;
+
 	if (nla_put_be32(skb, CTA_MARK, htonl(mark)))
 		goto nla_put_failure;
 	return 0;
@@ -532,7 +537,7 @@ static int ctnetlink_dump_extinfo(struct sk_buff *skb,
 static int ctnetlink_dump_info(struct sk_buff *skb, struct nf_conn *ct)
 {
 	if (ctnetlink_dump_status(skb, ct) < 0 ||
-	    ctnetlink_dump_mark(skb, READ_ONCE(ct->mark)) < 0 ||
+	    ctnetlink_dump_mark(skb, ct) < 0 ||
 	    ctnetlink_dump_secctx(skb, ct) < 0 ||
 	    ctnetlink_dump_id(skb, ct) < 0 ||
 	    ctnetlink_dump_use(skb, ct) < 0 ||
@@ -711,7 +716,6 @@ ctnetlink_conntrack_event(unsigned int events, struct nf_ct_event *item)
 	struct sk_buff *skb;
 	unsigned int type;
 	unsigned int flags = 0, group;
-	u32 mark;
 	int err;
 
 	if (events & (1 << IPCT_DESTROY)) {
@@ -812,9 +816,8 @@ ctnetlink_conntrack_event(unsigned int events, struct nf_ct_event *item)
 	}
 
 #ifdef CONFIG_NF_CONNTRACK_MARK
-	mark = READ_ONCE(ct->mark);
-	if ((events & (1 << IPCT_MARK) || mark) &&
-	    ctnetlink_dump_mark(skb, mark) < 0)
+	if (events & (1 << IPCT_MARK) &&
+	    ctnetlink_dump_mark(skb, ct) < 0)
 		goto nla_put_failure;
 #endif
 	nlmsg_end(skb, nlh);
@@ -2671,7 +2674,6 @@ static int __ctnetlink_glue_build(struct sk_buff *skb, struct nf_conn *ct)
 {
 	const struct nf_conntrack_zone *zone;
 	struct nlattr *nest_parms;
-	u32 mark;
 
 	zone = nf_ct_zone(ct);
 
@@ -2729,8 +2731,7 @@ static int __ctnetlink_glue_build(struct sk_buff *skb, struct nf_conn *ct)
 		goto nla_put_failure;
 
 #ifdef CONFIG_NF_CONNTRACK_MARK
-	mark = READ_ONCE(ct->mark);
-	if (mark && ctnetlink_dump_mark(skb, mark) < 0)
+	if (ctnetlink_dump_mark(skb, ct) < 0)
 		goto nla_put_failure;
 #endif
 	if (ctnetlink_dump_labels(skb, ct) < 0)
-- 
2.35.1



