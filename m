Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17ED14431
	for <patches@lists.linux.dev>; Wed, 15 Mar 2023 12:34:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A449C433EF;
	Wed, 15 Mar 2023 12:34:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678883671;
	bh=LaXCUhBH/CBTZ34v6FD8IzsiJel7CBzWL38VjDrxXQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kI0jwfoWxYBz6C5BqJ9Ee6tguAJt/qhF92kwZUwkI0hgzOyBs+dgSXy43/zPQi0Jz
	 tDXTRydGme9qZKgfjGhkthRca0A9G/qtvI4PjzpdisicB3UX+TC2VpS9ovBoShyjH/
	 cibewKmBcriC/MP+ZQL/WY4dzqo/bLKbSPokIf+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Delalande <colona@arista.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 088/143] netfilter: ctnetlink: revert to dumping mark regardless of event type
Date: Wed, 15 Mar 2023 13:12:54 +0100
Message-Id: <20230315115743.201894648@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115740.429574234@linuxfoundation.org>
References: <20230315115740.429574234@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ivan Delalande <colona@arista.com>

[ Upstream commit 9f7dd42f0db1dc6915a52d4a8a96ca18dd8cc34e ]

It seems that change was unintentional, we have userspace code that
needs the mark while listening for events like REPLY, DESTROY, etc.
Also include 0-marks in requested dumps, as they were before that fix.

Fixes: 1feeae071507 ("netfilter: ctnetlink: fix compilation warning after data race fixes in ct mark")
Signed-off-by: Ivan Delalande <colona@arista.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_netlink.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 733bb56950c14..d095d3c1ceca6 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -328,11 +328,12 @@ ctnetlink_dump_timestamp(struct sk_buff *skb, const struct nf_conn *ct)
 }
 
 #ifdef CONFIG_NF_CONNTRACK_MARK
-static int ctnetlink_dump_mark(struct sk_buff *skb, const struct nf_conn *ct)
+static int ctnetlink_dump_mark(struct sk_buff *skb, const struct nf_conn *ct,
+			       bool dump)
 {
 	u32 mark = READ_ONCE(ct->mark);
 
-	if (!mark)
+	if (!mark && !dump)
 		return 0;
 
 	if (nla_put_be32(skb, CTA_MARK, htonl(mark)))
@@ -343,7 +344,7 @@ static int ctnetlink_dump_mark(struct sk_buff *skb, const struct nf_conn *ct)
 	return -1;
 }
 #else
-#define ctnetlink_dump_mark(a, b) (0)
+#define ctnetlink_dump_mark(a, b, c) (0)
 #endif
 
 #ifdef CONFIG_NF_CONNTRACK_SECMARK
@@ -548,7 +549,7 @@ static int ctnetlink_dump_extinfo(struct sk_buff *skb,
 static int ctnetlink_dump_info(struct sk_buff *skb, struct nf_conn *ct)
 {
 	if (ctnetlink_dump_status(skb, ct) < 0 ||
-	    ctnetlink_dump_mark(skb, ct) < 0 ||
+	    ctnetlink_dump_mark(skb, ct, true) < 0 ||
 	    ctnetlink_dump_secctx(skb, ct) < 0 ||
 	    ctnetlink_dump_id(skb, ct) < 0 ||
 	    ctnetlink_dump_use(skb, ct) < 0 ||
@@ -831,8 +832,7 @@ ctnetlink_conntrack_event(unsigned int events, const struct nf_ct_event *item)
 	}
 
 #ifdef CONFIG_NF_CONNTRACK_MARK
-	if (events & (1 << IPCT_MARK) &&
-	    ctnetlink_dump_mark(skb, ct) < 0)
+	if (ctnetlink_dump_mark(skb, ct, events & (1 << IPCT_MARK)))
 		goto nla_put_failure;
 #endif
 	nlmsg_end(skb, nlh);
@@ -2735,7 +2735,7 @@ static int __ctnetlink_glue_build(struct sk_buff *skb, struct nf_conn *ct)
 		goto nla_put_failure;
 
 #ifdef CONFIG_NF_CONNTRACK_MARK
-	if (ctnetlink_dump_mark(skb, ct) < 0)
+	if (ctnetlink_dump_mark(skb, ct, true) < 0)
 		goto nla_put_failure;
 #endif
 	if (ctnetlink_dump_labels(skb, ct) < 0)
-- 
2.39.2



