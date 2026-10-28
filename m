Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214094;
	b=Thn/WTJRxK83FbdX8124vR5DYvqVr1PDkzzoZvaVMYgsjBaDpC0V6MRarlsBXIrmqfbe
	 CH89ZFzV/hLinWbUaN3h6NWLLz+S2DfqZxY2kyjCyJafAfqOQCokcUKit6oRRoL/35g/4
	 NGS0E0bB30l/TAmneZ2PltvHK+ItdfzQ4lkAbMzjYICPXTKtX/0GdC9WmrGHM2bW+J+fZ
	 vjwaBOsy/MK6ox9skwX3nKHkKqILVnxc/cKB5aIF3CKfFR2LIpHVXAmAei5onpy0eyAp+
	 7Crbmlr9KfWWsW4u/c1yQQiJRB1cFAcrFbRxI07sXcVHsGDzTVYGUIFxd3zIhCDwNqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214094;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Mop4gBrYZIAdciieu/61D5VsTH7nDuKAelUe8PqrKdk=;
	b=KPyMYxxofy96QAhI48VtDnR0VxGUpFtTiVTL2zDEMaSiD6fWMt+Lz/y4UBhNnzunEaIU
	 dj6PL4+pSsSPlUowsPW/+4IXo8zqu9duilWK7rJQKG5jjHOPNpWpmH/9oo2hHNOIhIphO
	 gQGNmdvqY1QvrWV/62hMzvXROyNvTPQs/vryWStaA9ofnP/XfycMKk+nSNLgSzEtcBkmD
	 blk3VbZqJkjwgnaRbtZg4F74/ge3PFh82f5LU2+oa459SSFqSX4/IPpsiIMbTWVu03bBd
	 21J33FAvtCDXQMQ42dI4247w2PidYjz/Pb/rpPcnL7qalhAULg6hHBgcWdGAmr2AS9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PBpYL6t6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD971606A31F;
	Wed, 28 Oct 2026 19:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PBpYL6t6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F096F1F01825;
	Wed, 28 Oct 2026 19:01:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214093;
	bh=Mop4gBrYZIAdciieu/61D5VsTH7nDuKAelUe8PqrKdk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PBpYL6t6BHTUd7899s2AZ/dpgCs/18QntGt+ec7LrY04GJQc6a9tR71rBgIcohjNm
	 p86xMt7vWXYi1k4nFGMr5bSuQjawHKFjI43/78TO+zJHkWQkaCUHeE4LC66nrl+IQp
	 rJeNM0+iZ//oPf1Vlk1sGsflbGKhN2jSkOzw3AMo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0737/1887] net: ipv6: fix dst ref loops in rpl, seg6 and ioam6 lwtunnels
Date: Wed, 28 Oct 2026 17:47:13 +0100
Message-ID: <20261028170516.219464307@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 92191dd1073088753821b862b791dcc83e558e07 ]

Some lwtunnels have a dst cache for post-transformation dst.
If the packet destination did not change we may end up recording
a reference to the lwtunnel in its own cache, and the lwtunnel
state will never be freed.

Discovered by the ioam6.sh test, kmemleak was recently fixed
to catch per-cpu memory leaks. I'm not sure if rpl and seg6
can actually hit this, but in principle I don't see why not.

Fixes: 8cb3bf8bff3c ("ipv6: ioam: Add support for the ip6ip6 encapsulation")
Fixes: 6c8702c60b88 ("ipv6: sr: add support for SRH encapsulation and injection with lwtunnels")
Fixes: a7a29f9c361f ("net: ipv6: add rpl sr tunnel")
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250130031519.2716843-2-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/ioam6_iptunnel.c | 9 ++++++---
 net/ipv6/rpl_iptunnel.c   | 9 ++++++---
 2 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/net/ipv6/ioam6_iptunnel.c b/net/ipv6/ioam6_iptunnel.c
index 3a6065faaf9bf..b536eae433d79 100644
--- a/net/ipv6/ioam6_iptunnel.c
+++ b/net/ipv6/ioam6_iptunnel.c
@@ -365,9 +365,12 @@ static int ioam6_output(struct net *net, struct sock *sk, struct sk_buff *skb)
 				goto drop;
 			}
 
-			local_bh_disable();
-			dst_cache_set_ip6(&ilwt->cache, dst, &fl6.saddr);
-			local_bh_enable();
+			/* cache only if we don't create a dst reference loop */
+			if (skb_dst(skb)->lwtstate != dst->lwtstate) {
+				local_bh_disable();
+				dst_cache_set_ip6(&ilwt->cache, dst, &fl6.saddr);
+				local_bh_enable();
+			}
 		}
 
 		skb_dst_drop(skb);
diff --git a/net/ipv6/rpl_iptunnel.c b/net/ipv6/rpl_iptunnel.c
index cde14e180a85c..be38d40188ec0 100644
--- a/net/ipv6/rpl_iptunnel.c
+++ b/net/ipv6/rpl_iptunnel.c
@@ -236,9 +236,12 @@ static int rpl_output(struct net *net, struct sock *sk, struct sk_buff *skb)
 			goto drop;
 		}
 
-		local_bh_disable();
-		dst_cache_set_ip6(&rlwt->cache, dst, &fl6.saddr);
-		local_bh_enable();
+		/* cache only if we don't create a dst reference loop */
+		if (orig_dst->lwtstate != dst->lwtstate) {
+			local_bh_disable();
+			dst_cache_set_ip6(&rlwt->cache, dst, &fl6.saddr);
+			local_bh_enable();
+		}
 
 		err = skb_cow_head(skb, LL_RESERVED_SPACE(dst->dev));
 		if (unlikely(err))
-- 
2.53.0



