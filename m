Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ABDA45A294;
	Tue, 21 Jul 2026 21:05:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667905; cv=none; b=oRGGVQY4YudKLqdZUIfuBycP4F3Pl4JIrtbp/uDer/gy/sZayRNMl28MPlKmPJCcc67LiVjCI/DdnzZnEBgjlcfRiQXxnUGyH5EG+GHLdcDguRxB3O5tSnWhjuMBV1qEYGOKgJ14FlBaGTJMgSw2+nc3UBTyOMT+sSVYD7xZ2n0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667905; c=relaxed/simple;
	bh=kDlx2ZfQrmAZ7Hq3PWmz0wi7Dejy2KgKXUUEuTcY71k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HVumeFbrxjcLMWGeXphVMeM0LsNpLKs+/HBkncYRaCubxrGRYtAnZQfvxTomHhV0eDtp1/np7aMuzTMa4sHUOXics4d3M0xucOU0J3JJ+BF2a/fgIpl7Tsudi/8NuP/h4JWVDTNEyKqR6n6V3J6IpYC/4tRc8MJy26mDvqtA2TA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aM3k4Ykz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aM3k4Ykz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 074881F00A3A;
	Tue, 21 Jul 2026 21:05:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667901;
	bh=HsyRY5JWJhTDNfVkFqdnC3qCCx7K0M4sG3C6ZzOiAEs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aM3k4YkzDwMjaazbl0OQ2NtBlcd/00SUA0Lnyyt3jH1a55vJPQQ9fnaP3NJQE6ULt
	 csnJM9xxRkizVICnxlQm3bZGQG0MFq3r/WDgNzk6vZMxgIK8wFnDAzKs/X5VMwxDRC
	 xh0phC555jF8SsDRPzoIhLkjKKIJSSaTeRtBjDgs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Paul Moore <paul@paul-moore.com>,
	Ricardo Robaina <rrobaina@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1234/1266] audit: add audit_log_nf_skb helper function
Date: Tue, 21 Jul 2026 17:27:51 +0200
Message-ID: <20260721152509.424063274@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

From: Ricardo Robaina <rrobaina@redhat.com>

[ Upstream commit f19590b07cb620be1fcd5474c49515e21a05d406 ]

Netfilter code (net/netfilter/nft_log.c and net/netfilter/xt_AUDIT.c)
have to be kept in sync. Both source files had duplicated versions of
audit_ip4() and audit_ip6() functions, which can result in lack of
consistency and/or duplicated work.

This patch adds a helper function in audit.c that can be called by
netfilter code commonly, aiming to improve maintainability and
consistency.

Suggested-by: Florian Westphal <fw@strlen.de>
Suggested-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Ricardo Robaina <rrobaina@redhat.com>
Acked-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Stable-dep-of: 65dfde57d1e2 ("audit: fix potential integer overflow in audit_log_n_hex()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/audit.h    |    8 +++++
 kernel/audit.c           |   64 +++++++++++++++++++++++++++++++++++++++++++++++
 net/netfilter/nft_log.c  |   58 ------------------------------------------
 net/netfilter/xt_AUDIT.c |   58 ------------------------------------------
 4 files changed, 74 insertions(+), 114 deletions(-)

--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -180,6 +180,8 @@ extern void		    audit_log_lost(const ch
 
 extern int audit_log_task_context(struct audit_buffer *ab);
 extern void audit_log_task_info(struct audit_buffer *ab);
+extern int audit_log_nf_skb(struct audit_buffer *ab,
+			    const struct sk_buff *skb, u8 nfproto);
 
 extern int		    audit_update_lsm_rules(void);
 
@@ -245,6 +247,12 @@ static inline int audit_log_task_context
 static inline void audit_log_task_info(struct audit_buffer *ab)
 { }
 
+static inline int audit_log_nf_skb(struct audit_buffer *ab,
+				   const struct sk_buff *skb, u8 nfproto)
+{
+	return 0;
+}
+
 static inline kuid_t audit_get_loginuid(struct task_struct *tsk)
 {
 	return INVALID_UID;
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -57,6 +57,8 @@
 #include <linux/freezer.h>
 #include <linux/pid_namespace.h>
 #include <net/netns/generic.h>
+#include <net/ip.h>
+#include <net/ipv6.h>
 
 #include "audit.h"
 
@@ -2304,6 +2306,68 @@ void audit_log_path_denied(int type, con
 	audit_log_end(ab);
 }
 
+int audit_log_nf_skb(struct audit_buffer *ab,
+		     const struct sk_buff *skb, u8 nfproto)
+{
+	/* find the IP protocol in the case of NFPROTO_BRIDGE */
+	if (nfproto == NFPROTO_BRIDGE) {
+		switch (eth_hdr(skb)->h_proto) {
+		case htons(ETH_P_IP):
+			nfproto = NFPROTO_IPV4;
+			break;
+		case htons(ETH_P_IPV6):
+			nfproto = NFPROTO_IPV6;
+			break;
+		default:
+			goto unknown_proto;
+		}
+	}
+
+	switch (nfproto) {
+	case NFPROTO_IPV4: {
+		struct iphdr iph;
+		const struct iphdr *ih;
+
+		ih = skb_header_pointer(skb, skb_network_offset(skb),
+					sizeof(iph), &iph);
+		if (!ih)
+			return -ENOMEM;
+
+		audit_log_format(ab, " saddr=%pI4 daddr=%pI4 proto=%hhu",
+				 &ih->saddr, &ih->daddr, ih->protocol);
+		break;
+	}
+	case NFPROTO_IPV6: {
+		struct ipv6hdr iph;
+		const struct ipv6hdr *ih;
+		u8 nexthdr;
+		__be16 frag_off;
+
+		ih = skb_header_pointer(skb, skb_network_offset(skb),
+					sizeof(iph), &iph);
+		if (!ih)
+			return -ENOMEM;
+
+		nexthdr = ih->nexthdr;
+		ipv6_skip_exthdr(skb, skb_network_offset(skb) + sizeof(iph),
+				 &nexthdr, &frag_off);
+
+		audit_log_format(ab, " saddr=%pI6c daddr=%pI6c proto=%hhu",
+				 &ih->saddr, &ih->daddr, nexthdr);
+		break;
+	}
+	default:
+		goto unknown_proto;
+	}
+
+	return 0;
+
+unknown_proto:
+	audit_log_format(ab, " saddr=? daddr=? proto=?");
+	return -EPFNOSUPPORT;
+}
+EXPORT_SYMBOL(audit_log_nf_skb);
+
 /* global counter which is incremented every time something logs in */
 static atomic_t session_id = ATOMIC_INIT(0);
 
--- a/net/netfilter/nft_log.c
+++ b/net/netfilter/nft_log.c
@@ -26,46 +26,10 @@ struct nft_log {
 	char			*prefix;
 };
 
-static bool audit_ip4(struct audit_buffer *ab, struct sk_buff *skb)
-{
-	struct iphdr _iph;
-	const struct iphdr *ih;
-
-	ih = skb_header_pointer(skb, skb_network_offset(skb), sizeof(_iph), &_iph);
-	if (!ih)
-		return false;
-
-	audit_log_format(ab, " saddr=%pI4 daddr=%pI4 proto=%hhu",
-			 &ih->saddr, &ih->daddr, ih->protocol);
-
-	return true;
-}
-
-static bool audit_ip6(struct audit_buffer *ab, struct sk_buff *skb)
-{
-	struct ipv6hdr _ip6h;
-	const struct ipv6hdr *ih;
-	u8 nexthdr;
-	__be16 frag_off;
-
-	ih = skb_header_pointer(skb, skb_network_offset(skb), sizeof(_ip6h), &_ip6h);
-	if (!ih)
-		return false;
-
-	nexthdr = ih->nexthdr;
-	ipv6_skip_exthdr(skb, skb_network_offset(skb) + sizeof(_ip6h), &nexthdr, &frag_off);
-
-	audit_log_format(ab, " saddr=%pI6c daddr=%pI6c proto=%hhu",
-			 &ih->saddr, &ih->daddr, nexthdr);
-
-	return true;
-}
-
 static void nft_log_eval_audit(const struct nft_pktinfo *pkt)
 {
 	struct sk_buff *skb = pkt->skb;
 	struct audit_buffer *ab;
-	int fam = -1;
 
 	if (!audit_enabled)
 		return;
@@ -76,27 +40,7 @@ static void nft_log_eval_audit(const str
 
 	audit_log_format(ab, "mark=%#x", skb->mark);
 
-	switch (nft_pf(pkt)) {
-	case NFPROTO_BRIDGE:
-		switch (eth_hdr(skb)->h_proto) {
-		case htons(ETH_P_IP):
-			fam = audit_ip4(ab, skb) ? NFPROTO_IPV4 : -1;
-			break;
-		case htons(ETH_P_IPV6):
-			fam = audit_ip6(ab, skb) ? NFPROTO_IPV6 : -1;
-			break;
-		}
-		break;
-	case NFPROTO_IPV4:
-		fam = audit_ip4(ab, skb) ? NFPROTO_IPV4 : -1;
-		break;
-	case NFPROTO_IPV6:
-		fam = audit_ip6(ab, skb) ? NFPROTO_IPV6 : -1;
-		break;
-	}
-
-	if (fam == -1)
-		audit_log_format(ab, " saddr=? daddr=? proto=-1");
+	audit_log_nf_skb(ab, skb, nft_pf(pkt));
 
 	audit_log_end(ab);
 }
--- a/net/netfilter/xt_AUDIT.c
+++ b/net/netfilter/xt_AUDIT.c
@@ -28,46 +28,10 @@ MODULE_ALIAS("ip6t_AUDIT");
 MODULE_ALIAS("ebt_AUDIT");
 MODULE_ALIAS("arpt_AUDIT");
 
-static bool audit_ip4(struct audit_buffer *ab, struct sk_buff *skb)
-{
-	struct iphdr _iph;
-	const struct iphdr *ih;
-
-	ih = skb_header_pointer(skb, skb_network_offset(skb), sizeof(_iph), &_iph);
-	if (!ih)
-		return false;
-
-	audit_log_format(ab, " saddr=%pI4 daddr=%pI4 proto=%hhu",
-			 &ih->saddr, &ih->daddr, ih->protocol);
-
-	return true;
-}
-
-static bool audit_ip6(struct audit_buffer *ab, struct sk_buff *skb)
-{
-	struct ipv6hdr _ip6h;
-	const struct ipv6hdr *ih;
-	u8 nexthdr;
-	__be16 frag_off;
-
-	ih = skb_header_pointer(skb, skb_network_offset(skb), sizeof(_ip6h), &_ip6h);
-	if (!ih)
-		return false;
-
-	nexthdr = ih->nexthdr;
-	ipv6_skip_exthdr(skb, skb_network_offset(skb) + sizeof(_ip6h), &nexthdr, &frag_off);
-
-	audit_log_format(ab, " saddr=%pI6c daddr=%pI6c proto=%hhu",
-			 &ih->saddr, &ih->daddr, nexthdr);
-
-	return true;
-}
-
 static unsigned int
 audit_tg(struct sk_buff *skb, const struct xt_action_param *par)
 {
 	struct audit_buffer *ab;
-	int fam = -1;
 
 	if (audit_enabled == AUDIT_OFF)
 		goto errout;
@@ -77,27 +41,7 @@ audit_tg(struct sk_buff *skb, const stru
 
 	audit_log_format(ab, "mark=%#x", skb->mark);
 
-	switch (xt_family(par)) {
-	case NFPROTO_BRIDGE:
-		switch (eth_hdr(skb)->h_proto) {
-		case htons(ETH_P_IP):
-			fam = audit_ip4(ab, skb) ? NFPROTO_IPV4 : -1;
-			break;
-		case htons(ETH_P_IPV6):
-			fam = audit_ip6(ab, skb) ? NFPROTO_IPV6 : -1;
-			break;
-		}
-		break;
-	case NFPROTO_IPV4:
-		fam = audit_ip4(ab, skb) ? NFPROTO_IPV4 : -1;
-		break;
-	case NFPROTO_IPV6:
-		fam = audit_ip6(ab, skb) ? NFPROTO_IPV6 : -1;
-		break;
-	}
-
-	if (fam == -1)
-		audit_log_format(ab, " saddr=? daddr=? proto=-1");
+	audit_log_nf_skb(ab, skb, xt_family(par));
 
 	audit_log_end(ab);
 


