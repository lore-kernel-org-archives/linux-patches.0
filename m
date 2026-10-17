Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB5DF3A7D63;
	Sat, 17 Oct 2026 17:51:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259463; cv=none; b=XwrJS2+05BHLyL+Xs05q46MPvDUE0t9SMTJZJtU8xpRqOK9n0j/sQJP+hvtZ5F+q5I+fAwGSVKqfCAjghJG1dCoWNXed9MQglibjAwRBgs0/lahcDAhOiruIQOONah4MZMUtsQD+j+N18G6A81rDY4XO+2KdQkfyPpJNRvn0+iI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259463; c=relaxed/simple;
	bh=jwkZ91wJM/dATEBHxFWHuEAVBXiCU1raztTfCK0RsKE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SGNIjm8r6ZGXGRyVP7c7NLiIfcIttFi/bUu7tEmf/JfTh++kVuVy8/GwF1oJBf51oL4CAGozej5ayXAuOOcZZwm8/OLPBuhf1XvWN0Y+Iv25IMnZ5klRb/wIwpBhdF2RJfY877Rwwhn3bva5lQK2hvRZVXre/hldhEWStHPOIRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b+KAvWpU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b+KAvWpU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F4B31F000C5;
	Sat, 17 Oct 2026 17:51:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259461;
	bh=ewy4eiZQX3k72eeRos5mJSihqLiFAjQTT1FI9opP6Dg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b+KAvWpU1Pe13+hJuBoQgCm90ewmxe0GaoxZuJKo6gVkeMP817QayULHgvtQ6eHc8
	 KwKhUQAHqvAWLGZrDI0xNwvNS9MjYm8dPgplUYTUgGVpthE28zPojwJambd0Ds/5GT
	 u+RZG+GTE0pzBsoTNLGTPZ+7AWB7LTRRVultZVOQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1221/1674] netfilter: make nftables drops visible in net dropmonitor
Date: Sat, 17 Oct 2026 17:58:13 +0200
Message-ID: <20261017160502.484331761@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Florian Westphal <fw@strlen.de>

[ Upstream commit e0d4593140b01b8da513a0c88c26da28b4906413 ]

net_dropmonitor blames core.c:nf_hook_slow.
Add NF_DROP_REASON() helper and use it in nft_do_chain().

The helper releases the skb, so exact drop location becomes
available. Calling code will observe the NF_STOLEN verdict
instead.

Adjust nf_hook_slow so we can embed an erro value wih
NF_STOLEN verdicts, just like we do for NF_DROP.

After this, drop in nftables can be pinpointed to a drop due
to a rule or the chain policy.

Signed-off-by: Florian Westphal <fw@strlen.de>
Stable-dep-of: 992c20bc8a4a ("netfilter: synproxy: fix unaligned memory access in timestamp adjustment")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/netfilter.h      | 10 ++++++++++
 net/netfilter/core.c           |  6 +++---
 net/netfilter/nf_tables_core.c |  6 +++++-
 3 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index cef210d5ec086..278efb0ab6965 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -22,6 +22,16 @@ static inline int NF_DROP_GETERR(int verdict)
 	return -(verdict >> NF_VERDICT_QBITS);
 }
 
+static __always_inline int
+NF_DROP_REASON(struct sk_buff *skb, enum skb_drop_reason reason, u32 err)
+{
+	BUILD_BUG_ON(err > 0xffff);
+
+	kfree_skb_reason(skb, reason);
+
+	return ((err << 16) | NF_STOLEN);
+}
+
 static inline int nf_inet_addr_cmp(const union nf_inet_addr *a1,
 				   const union nf_inet_addr *a2)
 {
diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index 7bae43b00ebbe..b00fc285b3349 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -639,10 +639,10 @@ int nf_hook_slow(struct sk_buff *skb, struct nf_hook_state *state,
 			if (ret == 1)
 				continue;
 			return ret;
+		case NF_STOLEN:
+			return NF_DROP_GETERR(verdict);
 		default:
-			/* Implicit handling for NF_STOLEN, as well as any other
-			 * non conventional verdicts.
-			 */
+			WARN_ON_ONCE(1);
 			return 0;
 		}
 	}
diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
index 711c22ab701dd..4b0d2b3a7bcaf 100644
--- a/net/netfilter/nf_tables_core.c
+++ b/net/netfilter/nf_tables_core.c
@@ -308,10 +308,11 @@ nft_do_chain(struct nft_pktinfo *pkt, void *priv)
 
 	switch (regs.verdict.code & NF_VERDICT_MASK) {
 	case NF_ACCEPT:
-	case NF_DROP:
 	case NF_QUEUE:
 	case NF_STOLEN:
 		return regs.verdict.code;
+	case NF_DROP:
+		return NF_DROP_REASON(pkt->skb, SKB_DROP_REASON_NETFILTER_DROP, EPERM);
 	}
 
 	switch (regs.verdict.code) {
@@ -342,6 +343,9 @@ nft_do_chain(struct nft_pktinfo *pkt, void *priv)
 	if (static_branch_unlikely(&nft_counters_enabled))
 		nft_update_chain_stats(basechain, pkt);
 
+	if (nft_base_chain(basechain)->policy == NF_DROP)
+		return NF_DROP_REASON(pkt->skb, SKB_DROP_REASON_NETFILTER_DROP, EPERM);
+
 	return nft_base_chain(basechain)->policy;
 }
 EXPORT_SYMBOL_GPL(nft_do_chain);
-- 
2.53.0



