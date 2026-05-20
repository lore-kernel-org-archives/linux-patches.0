Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B52CA370AE5;
	Wed, 20 May 2026 16:32:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294759; cv=none; b=ivRvorOaaPnSLAunFi6628lYtRj6H7mF9jKBlCySlKcPZCdWtjR0sXi7YSBPO8sMOB8yRZxLYlJU7ATePmvJ6q032SGb592yI4SCTmlNKwyShi239i7fTiKNSYPPw44VRHzpDBnRaZfUiTt6VKpQqD3VZARXcNH3qFC2hqURorE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294759; c=relaxed/simple;
	bh=oWxAluYsJ4Epx24/rCbfGReykPwuEueetfOTPTlTx4M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QR10CWODqe3rEFALkvlpzi9coN90Va4D8iqoH6BL/RqfwGuegLZhnmd8ocV/5ZGLz7+2MpFU1uZs5ik+iWILmb7WHHPsdRb+X64/tWF45RdEdI1WuElqaLHwkdXO4gC+Lw/sKr0Fi6xMNPCC293BNJfg1D4yt3S4YQMLj0VWu88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sSL1gkLU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sSL1gkLU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D9BF1F000E9;
	Wed, 20 May 2026 16:32:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294758;
	bh=3ELsytsDZzfz2+nF1tFpRXGOmmbV9ItHOInQWxfurm4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sSL1gkLUi3cXeTyIJQyj7eHMS3QucoRqaCcN/MqDySB9+X4gIMQuN9PMJVj/EqEou
	 wTTeJJJ/rsL6TBJvcG3IDBVm7Z/MNVpPEn8JiGUtpQfaEsNiurUghIdF1eDPZWpUAd
	 dKtLUUdldRuwKbRGE4nU+xOPhQXLZty53WL3FjCI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Joe Damato <joe@dama.to>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0160/1146] net: dropreason: add SKB_DROP_REASON_RECURSION_LIMIT
Date: Wed, 20 May 2026 18:06:50 +0200
Message-ID: <20260520162151.917244420@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
Stable-dep-of: 7fb4c1967011 ("net: pull headers in qdisc_pkt_len_segs_init()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/dropreason-core.h | 3 +++
 include/net/ip6_tunnel.h      | 2 +-
 net/ipv4/ip_tunnel_core.c     | 2 +-
 3 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/include/net/dropreason-core.h b/include/net/dropreason-core.h
index a7b7abd66e215..8e498e8431cbb 100644
--- a/include/net/dropreason-core.h
+++ b/include/net/dropreason-core.h
@@ -130,6 +130,7 @@
 	FN(DUALPI2_STEP_DROP)		\
 	FN(PSP_INPUT)			\
 	FN(PSP_OUTPUT)			\
+	FN(RECURSION_LIMIT)		\
 	FNe(MAX)
 
 /**
@@ -622,6 +623,8 @@ enum skb_drop_reason {
 	SKB_DROP_REASON_PSP_INPUT,
 	/** @SKB_DROP_REASON_PSP_OUTPUT: PSP output checks failed */
 	SKB_DROP_REASON_PSP_OUTPUT,
+	/** @SKB_DROP_REASON_RECURSION_LIMIT: Dead loop on virtual device. */
+	SKB_DROP_REASON_RECURSION_LIMIT,
 	/**
 	 * @SKB_DROP_REASON_MAX: the maximum of core drop reasons, which
 	 * shouldn't be used as a real 'reason' - only for tracing code gen
diff --git a/include/net/ip6_tunnel.h b/include/net/ip6_tunnel.h
index 359b595f1df93..b99805ee2fd14 100644
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
index 5683c328990f4..f430d6f0463e7 100644
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



