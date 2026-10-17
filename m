Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78CB23B2FD9;
	Sat, 17 Oct 2026 17:23:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257815; cv=none; b=kV36hIy/70lYBnt/nDZGFSdG3+EuY0V5XaTY6tH8RsgYMdBb4bZuaSDhphKSyIQOWHADPkvPHe3vvlvpg2+hFq+fwE9Kj31W0nEvAS36ocn8IWXIgk0R4aZMvozcPOJruXyx1K8LU3TGXS5wW2B8LgtuI64ATF4612s9ArTnvTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257815; c=relaxed/simple;
	bh=V8UCTT4/EjrgfcXy4Worn+GJxtO30U3UcRmt91l1Fe8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W+uekPTG5/NOX5aO0wBSss7lo1In8pD9/l+XMKgCU5yhyGcusgsETI8FOCQ10kcAoIga2hYRSPIGFaTQgH7oZtSyVqM6fD/FZDe4i0MXsYmwbaBBTPiLCm+PiLW/GtEYFEh4cmrn9jj+KmZRzmV+P5a+AqS9o9LUzpVTwlThu54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MyRS28p7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MyRS28p7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DC8A1F000C4;
	Sat, 17 Oct 2026 17:23:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257814;
	bh=K3y1OArYcpcpIcCcIpfNnm+OqsskBaNbvOKzQdPosvg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MyRS28p7cqpz/5oFnKG/IUMu2+m2OHucZ/ynQfjzR8LJWdFo0CDKLnqPEvYLUpsv/
	 pA9oHkWbD5Sbi83/VxnB8cXDoHTGekeyxrGCmfyjH3qZwYpucR7DmcMxmNpWyCt4VR
	 Hs2vEI9dx31CnVnj41JgNiltOXEqv7WF+21K/nDI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0679/1674] net: ipv6: fix dst ref loops in rpl, seg6 and ioam6 lwtunnels
Date: Sat, 17 Oct 2026 17:49:11 +0200
Message-ID: <20261017160448.538022159@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 702509dffd7c2..e0970440b6ee1 100644
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



