Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC06B6F2FE;
	Thu, 12 Dec 2024 15:33:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017592; cv=none; b=OnfNo6Y4EDPaPk3QbNqk8kR/mhn2QjTDvHUO/iuUrRjGwJ8sRQkBWYUckB56Dgi7cyvH9PaLq7QjwyGgRh4zMeIdYg0/Mz8skJ1mJxhCO4qwyGeIot6zhuOL6V59oS8lw/vry3JMcClD9jCs+s4tBI6nply/YpyiWDzguqeAX2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017592; c=relaxed/simple;
	bh=8/vNLIZjylAJgh2jQ2er396JIXDIOKRVbNEPIGb9wGg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E+/WQfs8DYtH9y1RVvdiPDasRa9Df622MWbpPBcsPWseoavbKcY84/MEGD/RaGf79TMsGoIWqa1M1/i7EYfFexAMrFWukQLnf37u1sJoKr/BMgUb3liNjkWLj6Yu5vDyUM0FHfuH94JlKhDmJ4JV8X0teNBZOQoH+oY3EuJwhcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aIY9ZOqA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aIY9ZOqA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14282C4CECE;
	Thu, 12 Dec 2024 15:33:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017592;
	bh=8/vNLIZjylAJgh2jQ2er396JIXDIOKRVbNEPIGb9wGg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aIY9ZOqAIjuops/gWOVSIImARy8SEfJWtFYOtyJCcI+oektR384fbtXSVsZARVwkw
	 HNR7EHzb7yR31N7CuN7OJas2W0qLv/V2OvHB/62PvnTG7i9QTuS1XW3kCMNNJd/EHP
	 LqZg3Y+2+wRIlWXaPsFkcNS1Cg96090akQjiZv9g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Lutomirski <luto@amacapital.net>,
	Vadim Fedorenko <vadfed@meta.com>,
	Willem de Bruijn <willemb@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 029/356] net-timestamp: make sk_tskey more predictable in error path
Date: Thu, 12 Dec 2024 15:55:48 +0100
Message-ID: <20241212144245.777963403@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
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
index 2458461e24874..765bd3f2a8408 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -972,8 +972,8 @@ static int __ip_append_data(struct sock *sk,
 	unsigned int maxfraglen, fragheaderlen, maxnonfragsize;
 	int csummode = CHECKSUM_NONE;
 	struct rtable *rt = (struct rtable *)cork->dst;
+	bool paged, hold_tskey, extra_uref = false;
 	unsigned int wmem_alloc_delta = 0;
-	bool paged, extra_uref = false;
 	u32 tskey = 0;
 
 	skb = skb_peek_tail(queue);
@@ -982,10 +982,6 @@ static int __ip_append_data(struct sock *sk,
 	mtu = cork->gso_size ? IP_MAX_MTU : cork->fragsize;
 	paged = !!cork->gso_size;
 
-	if (cork->tx_flags & SKBTX_ANY_TSTAMP &&
-	    READ_ONCE(sk->sk_tsflags) & SOF_TIMESTAMPING_OPT_ID)
-		tskey = atomic_inc_return(&sk->sk_tskey) - 1;
-
 	hh_len = LL_RESERVED_SPACE(rt->dst.dev);
 
 	fragheaderlen = sizeof(struct iphdr) + (opt ? opt->optlen : 0);
@@ -1052,6 +1048,11 @@ static int __ip_append_data(struct sock *sk,
 
 	cork->length += length;
 
+	hold_tskey = cork->tx_flags & SKBTX_ANY_TSTAMP &&
+		     READ_ONCE(sk->sk_tsflags) & SOF_TIMESTAMPING_OPT_ID;
+	if (hold_tskey)
+		tskey = atomic_inc_return(&sk->sk_tskey) - 1;
+
 	/* So, what's going on in the loop below?
 	 *
 	 * We use calculated fragment length to generate chained skb,
@@ -1274,6 +1275,8 @@ static int __ip_append_data(struct sock *sk,
 	cork->length -= length;
 	IP_INC_STATS(sock_net(sk), IPSTATS_MIB_OUTDISCARDS);
 	refcount_add(wmem_alloc_delta, &sk->sk_wmem_alloc);
+	if (hold_tskey)
+		atomic_dec(&sk->sk_tskey);
 	return err;
 }
 
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 5d8d86c159dc3..65e2f19814358 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1501,11 +1501,11 @@ static int __ip6_append_data(struct sock *sk,
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
@@ -1517,10 +1517,6 @@ static int __ip6_append_data(struct sock *sk,
 	mtu = cork->gso_size ? IP6_MAX_MTU : cork->fragsize;
 	orig_mtu = mtu;
 
-	if (cork->tx_flags & SKBTX_ANY_TSTAMP &&
-	    READ_ONCE(sk->sk_tsflags) & SOF_TIMESTAMPING_OPT_ID)
-		tskey = atomic_inc_return(&sk->sk_tskey) - 1;
-
 	hh_len = LL_RESERVED_SPACE(rt->dst.dev);
 
 	fragheaderlen = sizeof(struct ipv6hdr) + rt->rt6i_nfheader_len +
@@ -1617,6 +1613,11 @@ static int __ip6_append_data(struct sock *sk,
 			flags &= ~MSG_SPLICE_PAGES;
 	}
 
+	hold_tskey = cork->tx_flags & SKBTX_ANY_TSTAMP &&
+		     READ_ONCE(sk->sk_tsflags) & SOF_TIMESTAMPING_OPT_ID;
+	if (hold_tskey)
+		tskey = atomic_inc_return(&sk->sk_tskey) - 1;
+
 	/*
 	 * Let's try using as much space as possible.
 	 * Use MTU if total length of the message fits into the MTU.
@@ -1873,6 +1874,8 @@ static int __ip6_append_data(struct sock *sk,
 	cork->length -= length;
 	IP6_INC_STATS(sock_net(sk), rt->rt6i_idev, IPSTATS_MIB_OUTDISCARDS);
 	refcount_add(wmem_alloc_delta, &sk->sk_wmem_alloc);
+	if (hold_tskey)
+		atomic_dec(&sk->sk_tskey);
 	return err;
 }
 
-- 
2.43.0



