Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09FBF78B7C;
	Wed, 21 Feb 2024 13:42:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708522955; cv=none; b=hPlmN0P5523a5qHelC8Jp8eTs7ntvNVNGFzP5ct+4GRt6JPOEEuWmgCtaOFtvKG9IT0Fkm1oqLFMQymv6USf+m1qLpebmaxUcCmwRA6jOYUn15OgfzN70V1Qtggx+7NHGi7vq9ffcMFdkFmQE+yPtW+/1nMoUZG9v8DhLnW1Sso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708522955; c=relaxed/simple;
	bh=/v/dm77vYOI1zCD8HZtSOOyYmmpfiiF/UlbQfSZGNyw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LnQxl6aYr9eEPk29sa2hj5FfqjJg5BNQKDqrt1LWKuEWHf12HMx/roUiYu8BXseguIURcjf1TDdGHlKZCI2dDfVx0rBjauINUENiVTZ8Xx0U+19INVghGa59znrfJTzoE2mz+ohvTRuxUfWXJmIbcltVvqvtZ7bFIPRrCGmHPyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DirKMdn+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DirKMdn+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 822BAC433F1;
	Wed, 21 Feb 2024 13:42:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708522954;
	bh=/v/dm77vYOI1zCD8HZtSOOyYmmpfiiF/UlbQfSZGNyw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DirKMdn+AGnHVLBiptnftUSveLJog0gzu0FQ9gg/Lt3ccwtIJNsHcN2hgAZS2XYtC
	 nQryzr9V/BN9i2CvJ67pdc9TrM3XdPorPFaWFF+oD7wUK2Lm1+BJgZY2eZMGneU/jz
	 Ytww8YU4fdOClzvDyP48B6deCNEdnmKFuEyHn46U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 273/476] ip6_tunnel: use dev_sw_netstats_rx_add()
Date: Wed, 21 Feb 2024 14:05:24 +0100
Message-ID: <20240221130018.065485382@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit afd2051b18404640a116fd3bb2460da214ccbda4 ]

We have a convenient helper, let's use it.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 8d975c15c0cd ("ip6_tunnel: make sure to pull inner header in __ip6_tnl_rcv()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/ip6_tunnel.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
index a41ba4b161c4..35bd93347b8b 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -798,7 +798,6 @@ static int __ip6_tnl_rcv(struct ip6_tnl *tunnel, struct sk_buff *skb,
 						struct sk_buff *skb),
 			 bool log_ecn_err)
 {
-	struct pcpu_sw_netstats *tstats;
 	const struct ipv6hdr *ipv6h = ipv6_hdr(skb);
 	int err;
 
@@ -858,11 +857,7 @@ static int __ip6_tnl_rcv(struct ip6_tnl *tunnel, struct sk_buff *skb,
 		}
 	}
 
-	tstats = this_cpu_ptr(tunnel->dev->tstats);
-	u64_stats_update_begin(&tstats->syncp);
-	tstats->rx_packets++;
-	tstats->rx_bytes += skb->len;
-	u64_stats_update_end(&tstats->syncp);
+	dev_sw_netstats_rx_add(tunnel->dev, skb->len);
 
 	skb_scrub_packet(skb, !net_eq(tunnel->net, dev_net(tunnel->dev)));
 
-- 
2.43.0



