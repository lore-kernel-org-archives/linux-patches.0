Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215891;
	b=dwO9oODz8AN98xyqw8RYZaO7i39N8K4U5fpY4ljoA6Css6+8qrfTwJQXXc3oCwbiicfI
	 j1LZiBxpoeW++OmQAQIeFCmC+o1/oh7XhJzjZNM1kQH8Vq/bTq4yX1KtE0sUrNqxpGnxV
	 oJEuSrF4bprZzXMmx1kO+FeRV8ClmCRTyi6ubc33Zk7+d+0OJqMbY1TE4RZSQjUurXeI4
	 pWAI5BB9ClvRniGXI5IskhGKhMF0NGBKJT2ZZJiAqt6mWtz+qpi34gemkvPVZ5XSNNXv7
	 mKkxXwMDXDgSNGsqAn+4mqk/fksAC6/SwDpMMiw1vGFcBm0GPk+8NjAJAbLW4QsUopg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215891;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=73j21H4gkguHw0UqWwsRvImjPEx0iIXT7DJQhMF9rWQ=;
	b=GfIyMpQjCH+w1LlBvBPdziOlO5vdrJyQEmip2ifsHx4ZSZOP815dru+jU7ImnyFl1rg3
	 OmdbHUH/w071cG4T6EqOjzqPl33g79GdTaQWpETDxgc1NeePxsvjVMxE3LdgiBgk8khcY
	 muzRS8s+slL0uefGJI27MHz3ooC5DDPRQ9U2OQE9ClgRzCjgUf9xXjJjWi7fSSHtRDbo5
	 jmzTP5WCWahcBZ1TrrOGd3qUSnDnBBlnuglpS7fetAvW7EOTCvw72uJMD4o0jh0MO9Rwk
	 NAeXfKT3Uz2cqLPdgvhKTv6yPYiCyghonJrsXwuvF0Yu8bv+c5sB5HUOSw8DuxzSr8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="c9x/jh4U";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2E8A606A31E;
	Wed, 28 Oct 2026 19:31:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c9x/jh4U
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F33951F01825;
	Wed, 28 Oct 2026 19:31:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215890;
	bh=73j21H4gkguHw0UqWwsRvImjPEx0iIXT7DJQhMF9rWQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c9x/jh4Ut+WBbNzL6AvJ2JujEuERh8DuciCrApCckrUYZvXCNK3ztLz3wDhFQBRl3
	 Z8Avz5nM9nsTrTuLs3zGmUc14YrEHt9bkDuBajM6WcJqynRPiALyOQabop4AB4S0wl
	 aJKwHL5X5msnvVFx79+UTOFej8IyrIVRfhfmbcUo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1324/1887] netfilter: make nftables drops visible in net dropmonitor
Date: Wed, 28 Oct 2026 17:57:00 +0100
Message-ID: <20261028170529.557915050@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index caa775ec9ac94..031718f764caf 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -21,6 +21,16 @@ static inline int NF_DROP_GETERR(int verdict)
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
index edf92074221e2..50490bae3623e 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -627,10 +627,10 @@ int nf_hook_slow(struct sk_buff *skb, struct nf_hook_state *state,
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
index e0c117229ee9d..1df0908cc886c 100644
--- a/net/netfilter/nf_tables_core.c
+++ b/net/netfilter/nf_tables_core.c
@@ -284,10 +284,11 @@ nft_do_chain(struct nft_pktinfo *pkt, void *priv)
 
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
@@ -322,6 +323,9 @@ nft_do_chain(struct nft_pktinfo *pkt, void *priv)
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



