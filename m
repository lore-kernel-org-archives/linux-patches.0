Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2719B3DB8F
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 20:01:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="le+5agNx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9C53C433C8;
	Wed, 15 Nov 2023 20:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700078508;
	bh=3zJkjybA5L748mZUTvOHgWUPzQakRHuq9fnFgrxvlEs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=le+5agNx6t6hlnpUlHcQvczhIZmdJClj0fbT8iuUwS+ZqMjlskpaiFSdWpubc5Vsd
	 GAWi3+xJ8sa5Q7DJ4DX+kmCxelxzTYMsmWtI1k1+fVYxbtgke/0zvVJyDALzQU17cR
	 /N2dDNdGh8s+zj6TosH/aLu+9SQ6qtse5BRPQBBE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Huhardeaux <tech@tootai.net>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 365/379] netfilter: nat: fix ipv6 nat redirect with mapped and scoped addresses
Date: Wed, 15 Nov 2023 14:27:20 -0500
Message-ID: <20231115192706.753168393@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115192645.143643130@linuxfoundation.org>
References: <20231115192645.143643130@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 80abbe8a8263106fe45a4f293b92b5c74cc9cc8a ]

The ipv6 redirect target was derived from the ipv4 one, i.e. its
identical to a 'dnat' with the first (primary) address assigned to the
network interface.  The code has been moved around to make it usable
from nf_tables too, but its still the same as it was back when this
was added in 2012.

IPv6, however, has different types of addresses, if the 'wrong' address
comes first the redirection does not work.

In Daniels case, the addresses are:
  inet6 ::ffff:192 ...
  inet6 2a01: ...

... so the function attempts to redirect to the mapped address.

Add more checks before the address is deemed correct:
1. If the packets' daddr is scoped, search for a scoped address too
2. skip tentative addresses
3. skip mapped addresses

Use the first address that appears to match our needs.

Reported-by: Daniel Huhardeaux <tech@tootai.net>
Closes: https://lore.kernel.org/netfilter/71be06b8-6aa0-4cf9-9e0b-e2839b01b22f@tootai.net/
Fixes: 115e23ac78f8 ("netfilter: ip6tables: add REDIRECT target")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_nat_redirect.c | 27 ++++++++++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_nat_redirect.c b/net/netfilter/nf_nat_redirect.c
index 6616ba5d0b049..5b37487d9d11f 100644
--- a/net/netfilter/nf_nat_redirect.c
+++ b/net/netfilter/nf_nat_redirect.c
@@ -80,6 +80,26 @@ EXPORT_SYMBOL_GPL(nf_nat_redirect_ipv4);
 
 static const struct in6_addr loopback_addr = IN6ADDR_LOOPBACK_INIT;
 
+static bool nf_nat_redirect_ipv6_usable(const struct inet6_ifaddr *ifa, unsigned int scope)
+{
+	unsigned int ifa_addr_type = ipv6_addr_type(&ifa->addr);
+
+	if (ifa_addr_type & IPV6_ADDR_MAPPED)
+		return false;
+
+	if ((ifa->flags & IFA_F_TENTATIVE) && (!(ifa->flags & IFA_F_OPTIMISTIC)))
+		return false;
+
+	if (scope) {
+		unsigned int ifa_scope = ifa_addr_type & IPV6_ADDR_SCOPE_MASK;
+
+		if (!(scope & ifa_scope))
+			return false;
+	}
+
+	return true;
+}
+
 unsigned int
 nf_nat_redirect_ipv6(struct sk_buff *skb, const struct nf_nat_range2 *range,
 		     unsigned int hooknum)
@@ -89,14 +109,19 @@ nf_nat_redirect_ipv6(struct sk_buff *skb, const struct nf_nat_range2 *range,
 	if (hooknum == NF_INET_LOCAL_OUT) {
 		newdst.in6 = loopback_addr;
 	} else {
+		unsigned int scope = ipv6_addr_scope(&ipv6_hdr(skb)->daddr);
 		struct inet6_dev *idev;
-		struct inet6_ifaddr *ifa;
 		bool addr = false;
 
 		idev = __in6_dev_get(skb->dev);
 		if (idev != NULL) {
+			const struct inet6_ifaddr *ifa;
+
 			read_lock_bh(&idev->lock);
 			list_for_each_entry(ifa, &idev->addr_list, if_list) {
+				if (!nf_nat_redirect_ipv6_usable(ifa, scope))
+					continue;
+
 				newdst.in6 = ifa->addr;
 				addr = true;
 				break;
-- 
2.42.0



