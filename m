Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0298749D5B9;
	Thu, 17 Sep 2026 18:58:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671520; cv=none; b=hFxzJRt+se7BQPXLC/O4vPiHuen85J5H6EQxtxXJIbV6IGXgv25nGa8+tv43nv00/h3X414mnFvYMD7DVov3SuvuzDhOllC8fkeAugPvqC0sFK8a8eze4EO2dE4JPjvHC/KQ36WEUfoBbYAogtC4dFcw+pX/iJFRdKlAJZM1Nhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671520; c=relaxed/simple;
	bh=R5JGPOpzlz6fl5jF2OInj+eVqbizpOEpBJiYeO8ECBM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fNwhKSW4VPoxgBycUQSV3Qhi7II28XVxYyCwjMkfqNdj/+7FJFt4V6IpbUxSCbAsrP/9E/wqBy8NAT7gbzEfYmjFiqKk98FH+WZuFVuFSfiLnhq2h98sS/GN85jPLBAVUdpZvqb3QDWNf8IV8HPpTeOUYVDj4X0AK7/WWmU+S8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AzUpmSB9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AzUpmSB9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 505221F000FF;
	Thu, 17 Sep 2026 18:58:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671518;
	bh=lmpNk70PD7uJ2mC3ePajlQPNr0c8JqqIuRf9AJzoFWQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AzUpmSB9uVkzWz0H65j+TapyKHaf5hcRkbuemCYAnb4s3qlWcesmHtzPZUUmuap7u
	 8+VE4DZqFU/PoPc3tIk0g4DWy8aGok/gsHygjDEI+u0shsP2b+mhfsjBucn5krJO0V
	 I2b/dTq6OM2OrkD090kDKKTDwp0yjOB9Fn43vEvA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0966/1102] inet: add dst4_mtu() and dst6_mtu() helpers
Date: Thu, 17 Sep 2026 16:15:09 +0100
Message-ID: <20260917151604.927261559@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 8776c4ef3ab22b95f55713f00a7a576e6402507d ]

With CONFIG_MITIGATION_RETPOLINE=y dst_mtu() is a bit fat,
because it is generic.

Indeed, clang does not always inline it.

Add dst4_mtu() and dst6_mtu() helpers for callers that
expect either ipv4_mtu() or ip6_mtu() to be called.

These helpers are always inlined.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20260130210303.3888261-6-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 870a9e42ecc6 ("tcp: clamp route advmss to TCP_MIN_MSS")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/dst.h       |    6 ++++++
 include/net/ip6_route.h |    6 ++++++
 2 files changed, 12 insertions(+)

--- a/include/net/dst.h
+++ b/include/net/dst.h
@@ -219,6 +219,12 @@ static inline u32 dst_mtu(const struct d
 	return INDIRECT_CALL_INET(dst->ops->mtu, ip6_mtu, ipv4_mtu, dst);
 }
 
+/* Variant of dst_mtu() for IPv4 users. */
+static inline u32 dst4_mtu(const struct dst_entry *dst)
+{
+	return INDIRECT_CALL_1(dst->ops->mtu, ipv4_mtu, dst);
+}
+
 /* RTT metrics are stored in milliseconds for user ABI, but used as jiffies */
 static inline unsigned long dst_metric_rtt(const struct dst_entry *dst, int metric)
 {
--- a/include/net/ip6_route.h
+++ b/include/net/ip6_route.h
@@ -266,6 +266,12 @@ static inline bool ipv6_anycast_destinat
 int ip6_fragment(struct net *net, struct sock *sk, struct sk_buff *skb,
 		 int (*output)(struct net *, struct sock *, struct sk_buff *));
 
+/* Variant of dst_mtu() for IPv6 users */
+static inline u32 dst6_mtu(const struct dst_entry *dst)
+{
+	return INDIRECT_CALL_1(dst->ops->mtu, ip6_mtu, dst);
+}
+
 static inline unsigned int ip6_skb_dst_mtu(const struct sk_buff *skb)
 {
 	const struct ipv6_pinfo *np = skb->sk && !dev_recursion_level() ?


