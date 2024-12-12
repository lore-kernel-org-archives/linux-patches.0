Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C2142210D8;
	Thu, 12 Dec 2024 16:24:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020679; cv=none; b=E+hWjO2BAixECTllm4K9/X6DFRgVVJS6gaUJSxPPQcYfayB7DNTsh6fY1grbe2ZUwEXIQ7osQYaz63bvUwSlxDHCCwKUBRXlpKaVgpVu8/cBh5k1wOhulDqp4ALTAbhbHnvS5dCUjiFvVKailz7MmY4pNEJ4+JYYAuIHHzBBQyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020679; c=relaxed/simple;
	bh=pAgdX5guFUKKbo0XreHrUl/v4GRbnwLLwBMg+/Tw8rg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YjZ510CrYD8VuVifbVjxgXBh7xDOtD3uOKzeX8QXNJK1RQ9QTkVHfp5lH133uoebTVDnGX5K63y0MwIYtHLVvRXxvafE7tNmKHsM/l62bk0ZLGlyOpGi0c34izjENvQZeDqedwcRuTRMOgNADRMJ5RVQWi4c4ODomT/aBf8Ibe0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b+kZ5Jzx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b+kZ5Jzx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C12C1C4CECE;
	Thu, 12 Dec 2024 16:24:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020679;
	bh=pAgdX5guFUKKbo0XreHrUl/v4GRbnwLLwBMg+/Tw8rg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b+kZ5JzxMR9kE2fBOOrBr5ln4ACKPmVyBmP/lFYINGimnvLzxmRXosLb+h2iv5hV2
	 RbdCQD2dniUITCDjowHNUrZtWUQ83DE9OVjCvNGnQas58nCnup1uoO4Ux0sAFZ1q0q
	 BoWv026OzVpLIiIu0cuLFbDmx4HByMlUnIOlV1RA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Lutomirski <luto@amacapital.net>,
	Vadim Fedorenko <vadfed@meta.com>,
	Willem de Bruijn <willemb@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 532/772] net-timestamp: make sk_tskey more predictable in error path
Date: Thu, 12 Dec 2024 15:57:57 +0100
Message-ID: <20241212144411.954878308@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

From: Vadim Fedorenko <vadfed@meta.com>

[ Upstream commit 488b6d91b07112eaaaa4454332c1480894d4e06e ]

When SOF_TIMESTAMPING_OPT_ID is used to ambiguate timestamped datagrams,
the sk_tskey can become unpredictable in case of any error happened
during sendmsg(). Move increment later in the code and make decrement of
sk_tskey in error path. This solution is still racy in case of multiple
threads doing snedmsg() over the very same socket in parallel, but still
makes error path much more predictable.

Fixes: 09c2d251b707 ("net-timestamp: add key to disambiguate concurrent datagrams")
Reported-by: Andy Lutomirski <luto@amacapital.net>
Signed-off-by: Vadim Fedorenko <vadfed@meta.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://lore.kernel.org/r/20240213110428.1681540-1-vadfed@meta.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: 3301ab7d5aeb ("net/ipv6: release expired exception dst cached in socket")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/ip_output.c  | 13 ++++++++-----
 net/ipv6/ip6_output.c | 13 ++++++++-----
 2 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index a6d460aaee794..c82107bbd9810 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -980,8 +980,8 @@ static int __ip_append_data(struct sock *sk,
 	unsigned int maxfraglen, fragheaderlen, maxnonfragsize;
 	int csummode = CHECKSUM_NONE;
 	struct rtable *rt = (struct rtable *)cork->dst;
+	bool paged, hold_tskey, extra_uref = false;
 	unsigned int wmem_alloc_delta = 0;
-	bool paged, extra_uref = false;
 	u32 tskey = 0;
 
 	skb = skb_peek_tail(queue);
@@ -990,10 +990,6 @@ static int __ip_append_data(struct sock *sk,
 	mtu = cork->gso_size ? IP_MAX_MTU : cork->fragsize;
 	paged = !!cork->gso_size;
 
-	if (cork->tx_flags & SKBTX_ANY_TSTAMP &&
-	    READ_ONCE(sk->sk_tsflags) & SOF_TIMESTAMPING_OPT_ID)
-		tskey = atomic_inc_return(&sk->sk_tskey) - 1;
-
 	hh_len = LL_RESERVED_SPACE(rt->dst.dev);
 
 	fragheaderlen = sizeof(struct iphdr) + (opt ? opt->optlen : 0);
@@ -1051,6 +1047,11 @@ static int __ip_append_data(struct sock *sk,
 
 	cork->length += length;
 
+	hold_tskey = cork->tx_flags & SKBTX_ANY_TSTAMP &&
+		     READ_ONCE(sk->sk_tsflags) & SOF_TIMESTAMPING_OPT_ID;
+	if (hold_tskey)
+		tskey = atomic_inc_return(&sk->sk_tskey) - 1;
+
 	/* So, what's going on in the loop below?
 	 *
 	 * We use calculated fragment length to generate chained skb,
@@ -1255,6 +1256,8 @@ static int __ip_append_data(struct sock *sk,
 	cork->length -= length;
 	IP_INC_STATS(sock_net(sk), IPSTATS_MIB_OUTDISCARDS);
 	refcount_add(wmem_alloc_delta, &sk->sk_wmem_alloc);
+	if (hold_tskey)
+		atomic_dec(&sk->sk_tskey);
 	return err;
 }
 
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index f2227e662d1cf..4082470803615 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1499,11 +1499,11 @@ static int __ip6_append_data(struct sock *sk,
 	bool zc = false;
 	u32 tskey = 0;
 	struct rt6_info *rt = (struct rt6_info *)cork->dst;
+	bool paged, hold_tskey, extra_uref = false;
 	struct ipv6_txoptions *opt = v6_cork->opt;
 	int csummode = CHECKSUM_NONE;
 	unsigned int maxnonfragsize, headersize;
 	unsigned int wmem_alloc_delta = 0;
-	bool paged, extra_uref = false;
 
 	skb = skb_peek_tail(queue);
 	if (!skb) {
@@ -1515,10 +1515,6 @@ static int __ip6_append_data(struct sock *sk,
 	mtu = cork->gso_size ? IP6_MAX_MTU : cork->fragsize;
 	orig_mtu = mtu;
 
-	if (cork->tx_flags & SKBTX_ANY_TSTAMP &&
-	    READ_ONCE(sk->sk_tsflags) & SOF_TIMESTAMPING_OPT_ID)
-		tskey = atomic_inc_return(&sk->sk_tskey) - 1;
-
 	hh_len = LL_RESERVED_SPACE(rt->dst.dev);
 
 	fragheaderlen = sizeof(struct ipv6hdr) + rt->rt6i_nfheader_len +
@@ -1606,6 +1602,11 @@ static int __ip6_append_data(struct sock *sk,
 		}
 	}
 
+	hold_tskey = cork->tx_flags & SKBTX_ANY_TSTAMP &&
+		     READ_ONCE(sk->sk_tsflags) & SOF_TIMESTAMPING_OPT_ID;
+	if (hold_tskey)
+		tskey = atomic_inc_return(&sk->sk_tskey) - 1;
+
 	/*
 	 * Let's try using as much space as possible.
 	 * Use MTU if total length of the message fits into the MTU.
@@ -1844,6 +1845,8 @@ static int __ip6_append_data(struct sock *sk,
 	cork->length -= length;
 	IP6_INC_STATS(sock_net(sk), rt->rt6i_idev, IPSTATS_MIB_OUTDISCARDS);
 	refcount_add(wmem_alloc_delta, &sk->sk_wmem_alloc);
+	if (hold_tskey)
+		atomic_dec(&sk->sk_tskey);
 	return err;
 }
 
-- 
2.43.0



