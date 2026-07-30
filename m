Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AB9F3C3F4C;
	Thu, 30 Jul 2026 14:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423533; cv=none; b=RPaXVxgRIbs7BhvdJG7gY0xpl1l5EMzdcynBDb2LsAQYJdZSHd6mn4F5riaY+JHmAznsu73vFqd0IJmDZBsAeFhI9+o77q4FCKKCDhXvxWt4GUJz4UVddPtDGe3+XACCry1HAcs6+B+q4HrcxHfPOM8zpSnYkCZPnMF/tiOnDhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423533; c=relaxed/simple;
	bh=L/1zyrG/cUNn1YTlbm91qXR5CED1Jmw/UQo7eqH/x6k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M3PYnJQMJuQEZ5WO8BwNoZ+QdK07h0R7EFNNsbB5JOj+F+nm8vQux0KOPqe//wO7I0et9KdSdgkZOFTZ4YDa8GVJNNFO9r6pedILUXYIxKQ2Oi7eh0bZvLBb5uUWgU1F6FiZemGOuhRAbhGO9QrNs2NuBcYHACWomjxovMsxFHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dpmPOmDf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dpmPOmDf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8782F1F000E9;
	Thu, 30 Jul 2026 14:58:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423532;
	bh=EOZEqXokXTJUjAk6dfAuNPFoRh5QMqRzQBD7bLNSAaA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dpmPOmDfp288vkt81Xc0Co+W2yoY+bbKF8btsuN07FAKtVkn+gKRTnPzy/0yFSRtf
	 vecTQl/Zu3lN22m58mvbG6+4Jf+CBeuwitHFR9chVk+x9+RssVuuFZBilzKplW2bGn
	 LGZqfoZfOoH+Q+WXCSyx9LoMs1XjwfAtW8IWXegc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Joe Damato <joe@dama.to>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 033/675] net: dropreason: add SKB_DROP_REASON_RECURSION_LIMIT
Date: Thu, 30 Jul 2026 16:06:03 +0200
Message-ID: <20260730141445.824793239@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit d15d3de94a4766fb43d7fe7a72ed0479fb268131 ]

ip[6]tunnel_xmit() can drop packets if a too deep recursion level
is detected.

Add SKB_DROP_REASON_RECURSION_LIMIT drop reason.

We will use this reason later in __dev_queue_xmit().

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Joe Damato <joe@dama.to>
Link: https://patch.msgid.link/20260312201824.203093-2-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 6860b467f569 ("xfrm: propagate -EINPROGRESS from validate_xmit_xfrm()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/dropreason-core.h | 3 +++
 include/net/ip6_tunnel.h      | 2 +-
 net/ipv4/ip_tunnel_core.c     | 2 +-
 3 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/include/net/dropreason-core.h b/include/net/dropreason-core.h
index 58d91ccc56e0b5..de74e537b4ede4 100644
--- a/include/net/dropreason-core.h
+++ b/include/net/dropreason-core.h
@@ -129,6 +129,7 @@
 	FN(DUALPI2_STEP_DROP)		\
 	FN(PSP_INPUT)			\
 	FN(PSP_OUTPUT)			\
+	FN(RECURSION_LIMIT)		\
 	FNe(MAX)
 
 /**
@@ -616,6 +617,8 @@ enum skb_drop_reason {
 	SKB_DROP_REASON_PSP_INPUT,
 	/** @SKB_DROP_REASON_PSP_OUTPUT: PSP output checks failed */
 	SKB_DROP_REASON_PSP_OUTPUT,
+	/** @SKB_DROP_REASON_RECURSION_LIMIT: Dead loop on virtual device. */
+	SKB_DROP_REASON_RECURSION_LIMIT,
 	/**
 	 * @SKB_DROP_REASON_MAX: the maximum of core drop reasons, which
 	 * shouldn't be used as a real 'reason' - only for tracing code gen
diff --git a/include/net/ip6_tunnel.h b/include/net/ip6_tunnel.h
index 359b595f1df936..b99805ee2fd14b 100644
--- a/include/net/ip6_tunnel.h
+++ b/include/net/ip6_tunnel.h
@@ -162,7 +162,7 @@ static inline void ip6tunnel_xmit(struct sock *sk, struct sk_buff *skb,
 					     dev->name);
 			DEV_STATS_INC(dev, tx_errors);
 		}
-		kfree_skb(skb);
+		kfree_skb_reason(skb, SKB_DROP_REASON_RECURSION_LIMIT);
 		return;
 	}
 
diff --git a/net/ipv4/ip_tunnel_core.c b/net/ipv4/ip_tunnel_core.c
index 4b5fd4b13722ca..fc993c78cbcc5e 100644
--- a/net/ipv4/ip_tunnel_core.c
+++ b/net/ipv4/ip_tunnel_core.c
@@ -65,7 +65,7 @@ void iptunnel_xmit(struct sock *sk, struct rtable *rt, struct sk_buff *skb,
 			DEV_STATS_INC(dev, tx_errors);
 		}
 		ip_rt_put(rt);
-		kfree_skb(skb);
+		kfree_skb_reason(skb, SKB_DROP_REASON_RECURSION_LIMIT);
 		return;
 	}
 
-- 
2.53.0



