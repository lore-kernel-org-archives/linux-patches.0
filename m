Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 556D84595B;
	Mon, 14 Oct 2024 14:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916897; cv=none; b=pr2Jf+Mt/tu1epg3bGSNsbCJNITj79zWGv1OjSexXhJeY0l5P7QoM3H48CXzmW6k7ff5fU4xWD3Q1PNMkSJjli468eoVzQTCw3QZpf0aXE9FRdP7IIR96y/tEQUXj6HyctkowJigeECV6lsBDvP1HRP00dQKVERLUHpm1e+xWBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916897; c=relaxed/simple;
	bh=UD0+wLURz8LwfWmEJK2PkBK6yi9X+zZI+2vMKCncGGw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L9lOBmfGIG+qN+n91Gobh+4zRxfFPEsnia8i1s192UrXHHePRMSGgfY8yFSAar2U+Sspxz3XY/kgc4uKGVLim+pILk1oXwZyu/QnGHSSKEG/lMeV8Sq30A56OJwSjkXtPLo1UrsatC/Y+Zw/fpGvyrGYEO0SSqUDhlyJ0n4AMKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BIGR9Ht2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BIGR9Ht2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9C54C4CEC3;
	Mon, 14 Oct 2024 14:41:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916897;
	bh=UD0+wLURz8LwfWmEJK2PkBK6yi9X+zZI+2vMKCncGGw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BIGR9Ht2Mvv8qJnzNIFmUiTpFt8osIGsrT90GnEgvbycGiL9xs5mJZv1QuDRU05mr
	 yBC2kOzBtMYom/3vU09Y/YoVTvE+1zfi2F/2QaRMHt1kr4Crl1qNFUVfjPTAHBvskY
	 zT0S1Q3AbyNUzwheszLPInkgE77/K7j7rf/cSANE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Simon Horman <horms@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 095/213] netfilter: nf_reject: Fix build warning when CONFIG_BRIDGE_NETFILTER=n
Date: Mon, 14 Oct 2024 16:20:01 +0200
Message-ID: <20241014141046.675262595@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141042.954319779@linuxfoundation.org>
References: <20241014141042.954319779@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Simon Horman <horms@kernel.org>

[ Upstream commit fc56878ca1c288e49b5cbb43860a5938e3463654 ]

If CONFIG_BRIDGE_NETFILTER is not enabled, which is the case for x86_64
defconfig, then building nf_reject_ipv4.c and nf_reject_ipv6.c with W=1
using gcc-14 results in the following warnings, which are treated as
errors:

net/ipv4/netfilter/nf_reject_ipv4.c: In function 'nf_send_reset':
net/ipv4/netfilter/nf_reject_ipv4.c:243:23: error: variable 'niph' set but not used [-Werror=unused-but-set-variable]
  243 |         struct iphdr *niph;
      |                       ^~~~
cc1: all warnings being treated as errors
net/ipv6/netfilter/nf_reject_ipv6.c: In function 'nf_send_reset6':
net/ipv6/netfilter/nf_reject_ipv6.c:286:25: error: variable 'ip6h' set but not used [-Werror=unused-but-set-variable]
  286 |         struct ipv6hdr *ip6h;
      |                         ^~~~
cc1: all warnings being treated as errors

Address this by reducing the scope of these local variables to where
they are used, which is code only compiled when CONFIG_BRIDGE_NETFILTER
enabled.

Compile tested and run through netfilter selftests.

Reported-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Closes: https://lore.kernel.org/netfilter-devel/20240906145513.567781-1-andriy.shevchenko@linux.intel.com/
Signed-off-by: Simon Horman <horms@kernel.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/netfilter/nf_reject_ipv4.c | 10 ++++------
 net/ipv6/netfilter/nf_reject_ipv6.c |  5 ++---
 2 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/net/ipv4/netfilter/nf_reject_ipv4.c b/net/ipv4/netfilter/nf_reject_ipv4.c
index fc761915c5f6f..675b5bbed638e 100644
--- a/net/ipv4/netfilter/nf_reject_ipv4.c
+++ b/net/ipv4/netfilter/nf_reject_ipv4.c
@@ -239,9 +239,8 @@ static int nf_reject_fill_skb_dst(struct sk_buff *skb_in)
 void nf_send_reset(struct net *net, struct sock *sk, struct sk_buff *oldskb,
 		   int hook)
 {
-	struct sk_buff *nskb;
-	struct iphdr *niph;
 	const struct tcphdr *oth;
+	struct sk_buff *nskb;
 	struct tcphdr _oth;
 
 	oth = nf_reject_ip_tcphdr_get(oldskb, &_oth, hook);
@@ -266,14 +265,12 @@ void nf_send_reset(struct net *net, struct sock *sk, struct sk_buff *oldskb,
 	nskb->mark = IP4_REPLY_MARK(net, oldskb->mark);
 
 	skb_reserve(nskb, LL_MAX_HEADER);
-	niph = nf_reject_iphdr_put(nskb, oldskb, IPPROTO_TCP,
-				   ip4_dst_hoplimit(skb_dst(nskb)));
+	nf_reject_iphdr_put(nskb, oldskb, IPPROTO_TCP,
+			    ip4_dst_hoplimit(skb_dst(nskb)));
 	nf_reject_ip_tcphdr_put(nskb, oldskb, oth);
 	if (ip_route_me_harder(net, sk, nskb, RTN_UNSPEC))
 		goto free_nskb;
 
-	niph = ip_hdr(nskb);
-
 	/* "Never happens" */
 	if (nskb->len > dst_mtu(skb_dst(nskb)))
 		goto free_nskb;
@@ -290,6 +287,7 @@ void nf_send_reset(struct net *net, struct sock *sk, struct sk_buff *oldskb,
 	 */
 	if (nf_bridge_info_exists(oldskb)) {
 		struct ethhdr *oeth = eth_hdr(oldskb);
+		struct iphdr *niph = ip_hdr(nskb);
 		struct net_device *br_indev;
 
 		br_indev = nf_bridge_get_physindev(oldskb, net);
diff --git a/net/ipv6/netfilter/nf_reject_ipv6.c b/net/ipv6/netfilter/nf_reject_ipv6.c
index 690d1c0476913..4e0976534648c 100644
--- a/net/ipv6/netfilter/nf_reject_ipv6.c
+++ b/net/ipv6/netfilter/nf_reject_ipv6.c
@@ -273,7 +273,6 @@ void nf_send_reset6(struct net *net, struct sock *sk, struct sk_buff *oldskb,
 	const struct tcphdr *otcph;
 	unsigned int otcplen, hh_len;
 	const struct ipv6hdr *oip6h = ipv6_hdr(oldskb);
-	struct ipv6hdr *ip6h;
 	struct dst_entry *dst = NULL;
 	struct flowi6 fl6;
 
@@ -329,8 +328,7 @@ void nf_send_reset6(struct net *net, struct sock *sk, struct sk_buff *oldskb,
 	nskb->mark = fl6.flowi6_mark;
 
 	skb_reserve(nskb, hh_len + dst->header_len);
-	ip6h = nf_reject_ip6hdr_put(nskb, oldskb, IPPROTO_TCP,
-				    ip6_dst_hoplimit(dst));
+	nf_reject_ip6hdr_put(nskb, oldskb, IPPROTO_TCP, ip6_dst_hoplimit(dst));
 	nf_reject_ip6_tcphdr_put(nskb, oldskb, otcph, otcplen);
 
 	nf_ct_attach(nskb, oldskb);
@@ -345,6 +343,7 @@ void nf_send_reset6(struct net *net, struct sock *sk, struct sk_buff *oldskb,
 	 */
 	if (nf_bridge_info_exists(oldskb)) {
 		struct ethhdr *oeth = eth_hdr(oldskb);
+		struct ipv6hdr *ip6h = ipv6_hdr(nskb);
 		struct net_device *br_indev;
 
 		br_indev = nf_bridge_get_physindev(oldskb, net);
-- 
2.43.0



