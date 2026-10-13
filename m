Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C76F83C1D47;
	Tue, 13 Oct 2026 12:16:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893793; cv=none; b=fId1DhZQzkh88MqO9yuJV1gtkaNJ4+Bkg8ePHcKCS4qb2TAoWSnPWdIWn3yIP3jizloDU3bRuSeK0dsWTv38haN9w22KpPmp49jpopHoP94NCcy09uFd83MppKrVbg3YQjKSt3eLqFRzSrVv5+c+RBB+PPXrNwpuAwK7AJNJwQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893793; c=relaxed/simple;
	bh=C006cHIhM1Nf7z1ZJuMsErFQP3IBJhijI9hzroq8F24=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uaPxMDmm9jhbIpR2oqU5pChL1Dh0dmLU0LVKgaLo8GenyflZfW0FmFhjalD9aIc7z7tzBx4aRU1gEhkXzHOJ0FOL/Uuy6OWCgXExxVXjbWYVIL/OH100wDBWWTFIXURnn/25m+bHLQAowqn4bKFrky+zx8SwcUSzOOtdiiL89DA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1z+BCmeJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1z+BCmeJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D284E1F000FF;
	Tue, 13 Oct 2026 12:16:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893792;
	bh=pvDLCzy0AtnmCCOiTQATWYGmyyeC/pg3bRxG34CfTjI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1z+BCmeJ+AGWJYO3Hfgz8tA4Y+MDjc90XfFZmAI7KFrmH1Jzplo4ukqaTFVmYkqMT
	 nd08BCmfbog7bhe5hIU4e1Zqs0Vx7trtlkAmNLW+tab9MUBwXmLie4utvGT5C1s+/P
	 fhSM0Z0SrUBfTog9oi6839BRVHROrTtAkpY1eTWs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 300/621] netfilter: nft_fwd_netdev: use recursion counter in neigh egress path
Date: Tue, 13 Oct 2026 13:34:55 +0200
Message-ID: <20261013112927.973176742@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

From: Weiming Shi <bestswngs@gmail.com>

[ Upstream commit 1d47b55b36d2ec73fe6901212c8b28a593c3b27c ]

nft_fwd_neigh can be used in egress chains (NF_NETDEV_EGRESS). When the
forwarding rule targets the same device or two devices forward to each
other, neigh_xmit() triggers dev_queue_xmit() which re-enters
nf_hook_egress(), causing infinite recursion and stack overflow.

Move the nf_get_nf_dup_skb_recursion() accessor and NF_RECURSION_LIMIT
to the shared header nf_dup_netdev.h as a static inline, so that
nft_fwd_netdev can use the recursion counter directly without exported
function call overhead. Guard neigh_xmit() with the same recursion
limit already used in nf_do_netdev_egress().

[ Updated to cache the nf_get_nf_dup_skb_recursion pointer. --pablo ]

Fixes: f87b9464d152 ("netfilter: nft_fwd_netdev: Support egress hook")
Reported-by: Xiang Mei <xmei5@asu.edu>
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Stable-dep-of: 2354e975932d ("netfilter: nf_dup_netdev: add nf_dev_xmit_recursion*() helpers and use them")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netfilter/nf_dup_netdev.h | 13 +++++++++++++
 net/netfilter/nf_dup_netdev.c         | 16 ----------------
 net/netfilter/nft_fwd_netdev.c        |  8 ++++++++
 3 files changed, 21 insertions(+), 16 deletions(-)

diff --git a/include/net/netfilter/nf_dup_netdev.h b/include/net/netfilter/nf_dup_netdev.h
index b175d271aec95..609bcf422a9b3 100644
--- a/include/net/netfilter/nf_dup_netdev.h
+++ b/include/net/netfilter/nf_dup_netdev.h
@@ -3,10 +3,23 @@
 #define _NF_DUP_NETDEV_H_
 
 #include <net/netfilter/nf_tables.h>
+#include <linux/netdevice.h>
+#include <linux/sched.h>
 
 void nf_dup_netdev_egress(const struct nft_pktinfo *pkt, int oif);
 void nf_fwd_netdev_egress(const struct nft_pktinfo *pkt, int oif);
 
+#define NF_RECURSION_LIMIT	2
+
+static inline u8 *nf_get_nf_dup_skb_recursion(void)
+{
+#ifndef CONFIG_PREEMPT_RT
+	return this_cpu_ptr(&softnet_data.xmit.nf_dup_skb_recursion);
+#else
+	return &current->net_xmit.nf_dup_skb_recursion;
+#endif
+}
+
 struct nft_offload_ctx;
 struct nft_flow_rule;
 
diff --git a/net/netfilter/nf_dup_netdev.c b/net/netfilter/nf_dup_netdev.c
index fab8b9011098f..a958a1b0c5bee 100644
--- a/net/netfilter/nf_dup_netdev.c
+++ b/net/netfilter/nf_dup_netdev.c
@@ -13,22 +13,6 @@
 #include <net/netfilter/nf_tables_offload.h>
 #include <net/netfilter/nf_dup_netdev.h>
 
-#define NF_RECURSION_LIMIT	2
-
-#ifndef CONFIG_PREEMPT_RT
-static u8 *nf_get_nf_dup_skb_recursion(void)
-{
-	return this_cpu_ptr(&softnet_data.xmit.nf_dup_skb_recursion);
-}
-#else
-
-static u8 *nf_get_nf_dup_skb_recursion(void)
-{
-	return &current->net_xmit.nf_dup_skb_recursion;
-}
-
-#endif
-
 static void nf_do_netdev_egress(struct sk_buff *skb, struct net_device *dev,
 				enum nf_dev_hooks hook)
 {
diff --git a/net/netfilter/nft_fwd_netdev.c b/net/netfilter/nft_fwd_netdev.c
index 8468bed3e87d2..14c1ac9f20b6a 100644
--- a/net/netfilter/nft_fwd_netdev.c
+++ b/net/netfilter/nft_fwd_netdev.c
@@ -95,6 +95,7 @@ static void nft_fwd_neigh_eval(const struct nft_expr *expr,
 			      struct nft_regs *regs,
 			      const struct nft_pktinfo *pkt)
 {
+	u8 *nf_dup_skb_recursion = nf_get_nf_dup_skb_recursion();
 	struct nft_fwd_neigh *priv = nft_expr_priv(expr);
 	void *addr = &regs->data[priv->sreg_addr];
 	int oif = regs->data[priv->sreg_dev];
@@ -152,6 +153,11 @@ static void nft_fwd_neigh_eval(const struct nft_expr *expr,
 		goto out;
 	}
 
+	if (*nf_dup_skb_recursion > NF_RECURSION_LIMIT) {
+		verdict = NF_DROP;
+		goto out;
+	}
+
 	dev = dev_get_by_index_rcu(nft_net(pkt), oif);
 	if (dev == NULL) {
 		verdict = NF_DROP;
@@ -169,7 +175,9 @@ static void nft_fwd_neigh_eval(const struct nft_expr *expr,
 
 	skb->dev = dev;
 	skb_clear_tstamp(skb);
+	(*nf_dup_skb_recursion)++;
 	neigh_xmit(neigh_table, dev, addr, skb);
+	(*nf_dup_skb_recursion)--;
 out:
 	regs->verdict.code = verdict;
 }
-- 
2.53.0



