Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90D8D22301;
	Mon,  9 Feb 2026 14:44:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770648259; cv=none; b=EhqhQYfUaDPFd2/cDBmCBUBEMv9tTkG42KVGrWS9WMiVgsuuLRtUUeMzIzkz75LsLInmy/IPkhiIbvPDIrdT+zMc9VSDT39Wi0aPwavJgfc4h6i2mLmfUL/zllOUBq5qzGEQCNcBfU4CWN2s8PNEXUfFc86p2dDDZ5/Tex5gXrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770648259; c=relaxed/simple;
	bh=KkBYAng50BYXVz5g2R5TsHAlmWr2OdqW3Jowm8/YFC8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m+ow+PrHqoz9c4hZ3CPYsxcFJ7T4MUEqtCq6mb84x8iOm0CJlbXG4QtCyZ514uksMSkUqkQ956TpyvmJIyglV+QK1AuRGhseNjEFXfV/0KV3c3tDnhvGLvlQ5jSoimtrlgl8dzqhFtLtlz7qrScyUNCaWyrmvOTbWP42dERHrUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sR3nwsaz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sR3nwsaz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE64EC116C6;
	Mon,  9 Feb 2026 14:44:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770648259;
	bh=KkBYAng50BYXVz5g2R5TsHAlmWr2OdqW3Jowm8/YFC8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sR3nwsazx7ZGCWdHXpTTvBxBsILJrYUbwfT+uwSbDfeezlPrYUZjFqE1gVT9R32Y7
	 xzmYMkK3DX+kn1VThV3yf05jX1vnA5F6soaJY6Woqyp5QkAU5GehroCIph9lp/YzS6
	 rWdrdInXaCntYkgvnhZ4KSXOvdXP8CS4Ei1uEtYE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gal Pressman <gal@nvidia.com>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 54/69] net: dont touch dev->stats in BPF redirect paths
Date: Mon,  9 Feb 2026 15:24:22 +0100
Message-ID: <20260209142303.868433696@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142301.913348974@linuxfoundation.org>
References: <20260209142301.913348974@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit fdf3f6800be36377e045e2448087f12132b88d2f ]

Gal reports that BPF redirect increments dev->stats.tx_errors
on failure. This is not correct, most modern drivers completely
ignore dev->stats so these drops will be invisible to the user.
Core code should use the dedicated core stats which are folded
into device stats in dev_get_stats().

Note that we're switching from tx_errors to tx_dropped.
Core only has tx_dropped, hence presumably users already expect
that counter to increment for "stack" Tx issues.

Reported-by: Gal Pressman <gal@nvidia.com>
Link: https://lore.kernel.org/c5df3b60-246a-4030-9c9a-0a35cd1ca924@nvidia.com
Fixes: b4ab31414970 ("bpf: Add redirect_neigh helper as redirect drop-in")
Acked-by: Martin KaFai Lau <martin.lau@kernel.org>
Acked-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260130033827.698841-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/filter.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 305c38636b32b..e19bf63ad9a44 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -2274,12 +2274,12 @@ static int __bpf_redirect_neigh_v6(struct sk_buff *skb, struct net_device *dev,
 
 	err = bpf_out_neigh_v6(net, skb, dev, nh);
 	if (unlikely(net_xmit_eval(err)))
-		DEV_STATS_INC(dev, tx_errors);
+		dev_core_stats_tx_dropped_inc(dev);
 	else
 		ret = NET_XMIT_SUCCESS;
 	goto out_xmit;
 out_drop:
-	DEV_STATS_INC(dev, tx_errors);
+	dev_core_stats_tx_dropped_inc(dev);
 	kfree_skb(skb);
 out_xmit:
 	return ret;
@@ -2382,12 +2382,12 @@ static int __bpf_redirect_neigh_v4(struct sk_buff *skb, struct net_device *dev,
 
 	err = bpf_out_neigh_v4(net, skb, dev, nh);
 	if (unlikely(net_xmit_eval(err)))
-		DEV_STATS_INC(dev, tx_errors);
+		dev_core_stats_tx_dropped_inc(dev);
 	else
 		ret = NET_XMIT_SUCCESS;
 	goto out_xmit;
 out_drop:
-	DEV_STATS_INC(dev, tx_errors);
+	dev_core_stats_tx_dropped_inc(dev);
 	kfree_skb(skb);
 out_xmit:
 	return ret;
-- 
2.51.0



