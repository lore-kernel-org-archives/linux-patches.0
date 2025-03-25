Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D01042580F6;
	Tue, 25 Mar 2025 12:35:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742906122; cv=none; b=g+X0ZYNcHMPzJg1Xnfx+citpSovShLTJwOm5AnSzMR52jiEIBdZ5A4akZX979BBq0QSkKdKODnvIU6vEP2uNeYx6Mrk7o0Y691UzeVXrN2YrIvlvjRcO5R71gxjSPK4mgfQ//UP2of68nm/xARMIrVPjUgcHq0RupPwzxR23dkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742906122; c=relaxed/simple;
	bh=pOu35qRm0Xhxk7HqbgkvxOsQmEFzV+glkWkmOHeI7bI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mTArROIt+wP6L2riQCGOaubVl4c9ez4bO/GXCXhdvYfWJLEYYaiSHRgv9nZJUQYNgs1Oy5R6c8tnPoxotGgmHf2sDQoy6fhls9vCv0ccsfMMNLuHOjiG83Oufup6otfPg5xoFKNdQavGk1Cc/ciaMcCpCuZMsoGP71+jwpmyT3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BP7XRfRc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BP7XRfRc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85044C4CEE9;
	Tue, 25 Mar 2025 12:35:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742906122;
	bh=pOu35qRm0Xhxk7HqbgkvxOsQmEFzV+glkWkmOHeI7bI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BP7XRfRcWsID6F5TTsuQNQt0pvcBuLvwoF2Dxa+O4fgqCw1KQFSXjGiC8EJFJRYRp
	 Lv8v3sImukYoakWdVP0k9vdyM76RC6p8L4AcL/1fQBriaTi6fq1l+m2BnUDqEB0I8K
	 6ebFuuv/8FtPw6+WynY3B1j4MJDMOn9KHcRf2fkw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Iurman <justin.iurman@uliege.be>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 26/77] net: lwtunnel: fix recursion loops
Date: Tue, 25 Mar 2025 08:22:21 -0400
Message-ID: <20250325122145.038516945@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122144.259256924@linuxfoundation.org>
References: <20250325122144.259256924@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Justin Iurman <justin.iurman@uliege.be>

[ Upstream commit 986ffb3a57c5650fb8bf6d59a8f0f07046abfeb6 ]

This patch acts as a parachute, catch all solution, by detecting
recursion loops in lwtunnel users and taking care of them (e.g., a loop
between routes, a loop within the same route, etc). In general, such
loops are the consequence of pathological configurations. Each lwtunnel
user is still free to catch such loops early and do whatever they want
with them. It will be the case in a separate patch for, e.g., seg6 and
seg6_local, in order to provide drop reasons and update statistics.
Another example of a lwtunnel user taking care of loops is ioam6, which
has valid use cases that include loops (e.g., inline mode), and which is
addressed by the next patch in this series. Overall, this patch acts as
a last resort to catch loops and drop packets, since we don't want to
leak something unintentionally because of a pathological configuration
in lwtunnels.

The solution in this patch reuses dev_xmit_recursion(),
dev_xmit_recursion_inc(), and dev_xmit_recursion_dec(), which seems fine
considering the context.

Closes: https://lore.kernel.org/netdev/2bc9e2079e864a9290561894d2a602d6@akamai.com/
Closes: https://lore.kernel.org/netdev/Z7NKYMY7fJT5cYWu@shredder/
Fixes: ffce41962ef6 ("lwtunnel: support dst output redirect function")
Fixes: 2536862311d2 ("lwt: Add support to redirect dst.input")
Fixes: 14972cbd34ff ("net: lwtunnel: Handle fragmentation")
Signed-off-by: Justin Iurman <justin.iurman@uliege.be>
Link: https://patch.msgid.link/20250314120048.12569-2-justin.iurman@uliege.be
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/lwtunnel.c | 65 ++++++++++++++++++++++++++++++++++++---------
 1 file changed, 53 insertions(+), 12 deletions(-)

diff --git a/net/core/lwtunnel.c b/net/core/lwtunnel.c
index 711cd3b4347a7..4417a18b3e951 100644
--- a/net/core/lwtunnel.c
+++ b/net/core/lwtunnel.c
@@ -23,6 +23,8 @@
 #include <net/ip6_fib.h>
 #include <net/rtnh.h>
 
+#include "dev.h"
+
 DEFINE_STATIC_KEY_FALSE(nf_hooks_lwtunnel_enabled);
 EXPORT_SYMBOL_GPL(nf_hooks_lwtunnel_enabled);
 
@@ -325,13 +327,23 @@ EXPORT_SYMBOL_GPL(lwtunnel_cmp_encap);
 
 int lwtunnel_output(struct net *net, struct sock *sk, struct sk_buff *skb)
 {
-	struct dst_entry *dst = skb_dst(skb);
 	const struct lwtunnel_encap_ops *ops;
 	struct lwtunnel_state *lwtstate;
-	int ret = -EINVAL;
+	struct dst_entry *dst;
+	int ret;
+
+	if (dev_xmit_recursion()) {
+		net_crit_ratelimited("%s(): recursion limit reached on datapath\n",
+				     __func__);
+		ret = -ENETDOWN;
+		goto drop;
+	}
 
-	if (!dst)
+	dst = skb_dst(skb);
+	if (!dst) {
+		ret = -EINVAL;
 		goto drop;
+	}
 	lwtstate = dst->lwtstate;
 
 	if (lwtstate->type == LWTUNNEL_ENCAP_NONE ||
@@ -341,8 +353,11 @@ int lwtunnel_output(struct net *net, struct sock *sk, struct sk_buff *skb)
 	ret = -EOPNOTSUPP;
 	rcu_read_lock();
 	ops = rcu_dereference(lwtun_encaps[lwtstate->type]);
-	if (likely(ops && ops->output))
+	if (likely(ops && ops->output)) {
+		dev_xmit_recursion_inc();
 		ret = ops->output(net, sk, skb);
+		dev_xmit_recursion_dec();
+	}
 	rcu_read_unlock();
 
 	if (ret == -EOPNOTSUPP)
@@ -359,13 +374,23 @@ EXPORT_SYMBOL_GPL(lwtunnel_output);
 
 int lwtunnel_xmit(struct sk_buff *skb)
 {
-	struct dst_entry *dst = skb_dst(skb);
 	const struct lwtunnel_encap_ops *ops;
 	struct lwtunnel_state *lwtstate;
-	int ret = -EINVAL;
+	struct dst_entry *dst;
+	int ret;
+
+	if (dev_xmit_recursion()) {
+		net_crit_ratelimited("%s(): recursion limit reached on datapath\n",
+				     __func__);
+		ret = -ENETDOWN;
+		goto drop;
+	}
 
-	if (!dst)
+	dst = skb_dst(skb);
+	if (!dst) {
+		ret = -EINVAL;
 		goto drop;
+	}
 
 	lwtstate = dst->lwtstate;
 
@@ -376,8 +401,11 @@ int lwtunnel_xmit(struct sk_buff *skb)
 	ret = -EOPNOTSUPP;
 	rcu_read_lock();
 	ops = rcu_dereference(lwtun_encaps[lwtstate->type]);
-	if (likely(ops && ops->xmit))
+	if (likely(ops && ops->xmit)) {
+		dev_xmit_recursion_inc();
 		ret = ops->xmit(skb);
+		dev_xmit_recursion_dec();
+	}
 	rcu_read_unlock();
 
 	if (ret == -EOPNOTSUPP)
@@ -394,13 +422,23 @@ EXPORT_SYMBOL_GPL(lwtunnel_xmit);
 
 int lwtunnel_input(struct sk_buff *skb)
 {
-	struct dst_entry *dst = skb_dst(skb);
 	const struct lwtunnel_encap_ops *ops;
 	struct lwtunnel_state *lwtstate;
-	int ret = -EINVAL;
+	struct dst_entry *dst;
+	int ret;
 
-	if (!dst)
+	if (dev_xmit_recursion()) {
+		net_crit_ratelimited("%s(): recursion limit reached on datapath\n",
+				     __func__);
+		ret = -ENETDOWN;
 		goto drop;
+	}
+
+	dst = skb_dst(skb);
+	if (!dst) {
+		ret = -EINVAL;
+		goto drop;
+	}
 	lwtstate = dst->lwtstate;
 
 	if (lwtstate->type == LWTUNNEL_ENCAP_NONE ||
@@ -410,8 +448,11 @@ int lwtunnel_input(struct sk_buff *skb)
 	ret = -EOPNOTSUPP;
 	rcu_read_lock();
 	ops = rcu_dereference(lwtun_encaps[lwtstate->type]);
-	if (likely(ops && ops->input))
+	if (likely(ops && ops->input)) {
+		dev_xmit_recursion_inc();
 		ret = ops->input(skb);
+		dev_xmit_recursion_dec();
+	}
 	rcu_read_unlock();
 
 	if (ret == -EOPNOTSUPP)
-- 
2.39.5



