Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C10525484E;
	Tue, 29 Apr 2025 18:11:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950309; cv=none; b=RmK8SKn91BxpDGqrusFs/zSf+bZV0c5IMHlwlMFvv3xdGy8z59ebc1WKRzB+bhZ4s+WFM7k0UVRJZCEUOpA8xpNBnnSgw3D40bvtem2zBfJ2YemBbXb6xkWOoAJaCmtmu3DYEAde93hSFE0GamSbawatMHP1dC2ExJx/3To/c3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950309; c=relaxed/simple;
	bh=xInd3rLPaUHth0LV5gCtkgjFWQaoLKlXefZqS2wVA0w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sUMJzhDpWgCwq6t4bRrNzWGE1joZs1bm446RP0bgV8LZi3V0U6zW89KL0u0cWQBoPNPrjS9PydOkM6cQzJBHjDe+m6fXN3dqNTSAki9FMcEUsyfnjAEO06hFKaNL8wbT4lNwwkWI9721cDyGWuk1eU1pGzHM6qzcNkhyA7HJ5J0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CI6z1/Z3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CI6z1/Z3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B41FC4CEE3;
	Tue, 29 Apr 2025 18:11:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950308;
	bh=xInd3rLPaUHth0LV5gCtkgjFWQaoLKlXefZqS2wVA0w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CI6z1/Z3WFyOZC97+HmVtiO9R0FU/cHhQuM4M1i6a08v7E404sg+7gyOSZTOvRcFG
	 EK2V3edrtuqafa1ZE6FRZb83pfi7JRdfmgfWLdugydZlzgBxtp3Z3mn/IP56Q6ADAZ
	 hOzNNACLib/t70vD/MnDnPZLE0vd+aUbmcz/9KGc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Starovoitov <alexei.starovoitov@gmail.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Justin Iurman <justin.iurman@uliege.be>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 054/204] net: lwtunnel: disable BHs when required
Date: Tue, 29 Apr 2025 18:42:22 +0200
Message-ID: <20250429161101.616994902@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161059.396852607@linuxfoundation.org>
References: <20250429161059.396852607@linuxfoundation.org>
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

[ Upstream commit c03a49f3093a4903c8a93c8b5c9a297b5343b169 ]

In lwtunnel_{output|xmit}(), dev_xmit_recursion() may be called in
preemptible scope for PREEMPT kernels. This patch disables BHs before
calling dev_xmit_recursion(). BHs are re-enabled only at the end, since
we must ensure the same CPU is used for both dev_xmit_recursion_inc()
and dev_xmit_recursion_dec() (and any other recursion levels in some
cases) in order to maintain valid per-cpu counters.

Reported-by: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Closes: https://lore.kernel.org/netdev/CAADnVQJFWn3dBFJtY+ci6oN1pDFL=TzCmNbRgey7MdYxt_AP2g@mail.gmail.com/
Reported-by: Eduard Zingerman <eddyz87@gmail.com>
Closes: https://lore.kernel.org/netdev/m2h62qwf34.fsf@gmail.com/
Fixes: 986ffb3a57c5 ("net: lwtunnel: fix recursion loops")
Signed-off-by: Justin Iurman <justin.iurman@uliege.be>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250416160716.8823-1-justin.iurman@uliege.be
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/lwtunnel.c | 26 ++++++++++++++++++++------
 1 file changed, 20 insertions(+), 6 deletions(-)

diff --git a/net/core/lwtunnel.c b/net/core/lwtunnel.c
index 4417a18b3e951..f63586c9ce021 100644
--- a/net/core/lwtunnel.c
+++ b/net/core/lwtunnel.c
@@ -332,6 +332,8 @@ int lwtunnel_output(struct net *net, struct sock *sk, struct sk_buff *skb)
 	struct dst_entry *dst;
 	int ret;
 
+	local_bh_disable();
+
 	if (dev_xmit_recursion()) {
 		net_crit_ratelimited("%s(): recursion limit reached on datapath\n",
 				     __func__);
@@ -347,8 +349,10 @@ int lwtunnel_output(struct net *net, struct sock *sk, struct sk_buff *skb)
 	lwtstate = dst->lwtstate;
 
 	if (lwtstate->type == LWTUNNEL_ENCAP_NONE ||
-	    lwtstate->type > LWTUNNEL_ENCAP_MAX)
-		return 0;
+	    lwtstate->type > LWTUNNEL_ENCAP_MAX) {
+		ret = 0;
+		goto out;
+	}
 
 	ret = -EOPNOTSUPP;
 	rcu_read_lock();
@@ -363,11 +367,13 @@ int lwtunnel_output(struct net *net, struct sock *sk, struct sk_buff *skb)
 	if (ret == -EOPNOTSUPP)
 		goto drop;
 
-	return ret;
+	goto out;
 
 drop:
 	kfree_skb(skb);
 
+out:
+	local_bh_enable();
 	return ret;
 }
 EXPORT_SYMBOL_GPL(lwtunnel_output);
@@ -379,6 +385,8 @@ int lwtunnel_xmit(struct sk_buff *skb)
 	struct dst_entry *dst;
 	int ret;
 
+	local_bh_disable();
+
 	if (dev_xmit_recursion()) {
 		net_crit_ratelimited("%s(): recursion limit reached on datapath\n",
 				     __func__);
@@ -395,8 +403,10 @@ int lwtunnel_xmit(struct sk_buff *skb)
 	lwtstate = dst->lwtstate;
 
 	if (lwtstate->type == LWTUNNEL_ENCAP_NONE ||
-	    lwtstate->type > LWTUNNEL_ENCAP_MAX)
-		return 0;
+	    lwtstate->type > LWTUNNEL_ENCAP_MAX) {
+		ret = 0;
+		goto out;
+	}
 
 	ret = -EOPNOTSUPP;
 	rcu_read_lock();
@@ -411,11 +421,13 @@ int lwtunnel_xmit(struct sk_buff *skb)
 	if (ret == -EOPNOTSUPP)
 		goto drop;
 
-	return ret;
+	goto out;
 
 drop:
 	kfree_skb(skb);
 
+out:
+	local_bh_enable();
 	return ret;
 }
 EXPORT_SYMBOL_GPL(lwtunnel_xmit);
@@ -427,6 +439,8 @@ int lwtunnel_input(struct sk_buff *skb)
 	struct dst_entry *dst;
 	int ret;
 
+	DEBUG_NET_WARN_ON_ONCE(!in_softirq());
+
 	if (dev_xmit_recursion()) {
 		net_crit_ratelimited("%s(): recursion limit reached on datapath\n",
 				     __func__);
-- 
2.39.5



