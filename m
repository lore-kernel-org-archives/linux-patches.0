Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECAB53B9D94;
	Thu,  2 Jul 2026 16:27:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783009681; cv=none; b=p8dmLHRbgbt0M3ebIouepVX1sHtOR2H3gXotxkQEtmI0xwiCvrodarD8Tg40BNTuKHAemMGz8qVfy8Xyk1UnGTuGLlHbFYAE52uk2xEFm1NFskMxQJQWbd6ms801GHVZAa1Q3iDcELWcInJOIQW1i72aeX49sOzxswbL0jWBayw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783009681; c=relaxed/simple;
	bh=GSQCFXdAJwVAG8dj+HnZ2QipkGO8by+ar8sHLlgZ8IU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eTq4OEEQw2y4xzfVn76fvsXe6Ev0PADROsZFhRy9t71yM2qL0BkYUDV8/Xe/gs8XSeoLNneAnUXGNZsdsXD3yRKQWyv7IZJnMNrOxlGs7leRAHi6WH3+UsfMJulsFJMhyGvHkNK9QTiDE0a2WTrHMrpaiKlWlxIygyqJ+VUqlUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ol2WD2tn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ol2WD2tn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D72C21F00A3A;
	Thu,  2 Jul 2026 16:27:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783009675;
	bh=J9S8ewYE4JnFEx2T0JtpCqSXnM8cdZ3hWb/QiYUvUog=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ol2WD2tnd0RymRffBGDPWPJaxVjDp9nspGvcfyimANektzPQYliI3B2dbKy6v4Vut
	 JJXZCpS1v7/f9O2WsMQN1/quH+rAzEXOFuof7PSp8zzn+PHATtzmAXrbbe59/YaxEr
	 oLEycR/sNpQRNSS8klhKij1T7CMtoC3avvx4WNkc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Noam Rathaus <noamr@ssd-disclosure.com>,
	Eric Dumazet <edumazet@google.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Nicolas Dichtel <nicolas.dichtel@6wind.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Salvatore Bonaccorso <carnil@debian.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 07/95] ip6_vti: set netns_immutable on the fallback device.
Date: Thu,  2 Jul 2026 18:19:10 +0200
Message-ID: <20260702155109.363970123@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155109.196223802@linuxfoundation.org>
References: <20260702155109.196223802@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit d289d5307762d1838aaece22c6b6fcad9e8865f9 ]

john1988 and Noam Rathaus reported that vti6_init_net() does not set the
netns_immutable flag on the per-netns fallback tunnel device (ip6_vti0).

Other similar tunnel drivers (like ip6_tunnel, sit, ip6_gre, and ip_tunnel)
correctly set this flag during their fallback device initialization to
prevent them from being moved to another network namespace.

Fixes: 61220ab34948 ("vti6: Enable namespace changing")
Reported-by: Noam Rathaus <noamr@ssd-disclosure.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Reviewed-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Link: https://patch.msgid.link/20260608155918.787644-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[Salvatore Bonaccorso: Backport for version without 0c493da86374 ("net:
rename netns_local to netns_immutable") in v6.15-rc1 and without
05c1280a2bcf ("netdev_features: convert NETIF_F_NETNS_LOCAL to
dev->netns_local") in v6.12-rc1 and use NETIF_F_NETNS_LOCAL device
feature.]
Signed-off-by: Salvatore Bonaccorso <carnil@debian.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/ip6_vti.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv6/ip6_vti.c b/net/ipv6/ip6_vti.c
index 077aae4b1bb332..e5f3293d190d39 100644
--- a/net/ipv6/ip6_vti.c
+++ b/net/ipv6/ip6_vti.c
@@ -1167,6 +1167,7 @@ static int __net_init vti6_init_net(struct net *net)
 		goto err_alloc_dev;
 	dev_net_set(ip6n->fb_tnl_dev, net);
 	ip6n->fb_tnl_dev->rtnl_link_ops = &vti6_link_ops;
+	ip6n->fb_tnl_dev->features |= NETIF_F_NETNS_LOCAL;
 
 	err = vti6_fb_tnl_dev_init(ip6n->fb_tnl_dev);
 	if (err < 0)
-- 
2.53.0



