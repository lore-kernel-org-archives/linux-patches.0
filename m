Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02C681DFE09;
	Wed, 19 Feb 2025 08:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954645; cv=none; b=HmcgfGEgPYJtasLc6cV773MggLcV9H8X+YnVV9BjX6tqCBRTeNjdZaK6JTvIrsR0E2K7uQbwyI6Za0BCeEWMLim+QccyyRw50pAcMpr2EZGwkIjyQ9oX1K66z6tGp92zHdJz0HkaF6yOMz+Y9n5Xsv9poUxFG5t778TvfWOxC+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954645; c=relaxed/simple;
	bh=X1KpzJwbahOtBvDAk3LpmjUQH/e/jUDdUa6YyIAgtas=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qc0vHmTUrer/Ydu0bxla3s6FaLxNHhmdPWXBxYzn1ywr7m5zQqx70QlOfuVwi75yk+yPg0hnrriQZSA7QbMWJND8CC/wwK3q1NZ8HzaP8qAZweJPZfMNGiKAdTBEHiJ0U5rCYHzLU7Ybv3U2XLZLw1IvVujdcDPvdMe+78dOWlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1lu7uTdq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1lu7uTdq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AB9FC4CEE6;
	Wed, 19 Feb 2025 08:44:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954644;
	bh=X1KpzJwbahOtBvDAk3LpmjUQH/e/jUDdUa6YyIAgtas=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1lu7uTdqGnQoneDD8QJhwwbPGSjZaZ//DlQf4XFEFT+NBjjxEs4rUi9MeG38Sjnsw
	 FrEz0VxAyOhW2tsKx3f+iUhiD3K4ZIxqSy0hH62pkS7s53GRJze2JUTPHvEClJonlX
	 QRQf6EloGyQ1cwa07YYJ0eQFVlrcNCD/KkbsHJTo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Iurman <justin.iurman@uliege.be>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.13 268/274] net: ipv6: fix dst refleaks in rpl, seg6 and ioam6 lwtunnels
Date: Wed, 19 Feb 2025 09:28:42 +0100
Message-ID: <20250219082620.076943278@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

commit c71a192976ded2f2f416d03c4f595cdd4478b825 upstream.

dst_cache_get() gives us a reference, we need to release it.

Discovered by the ioam6.sh test, kmemleak was recently fixed
to catch per-cpu memory leaks.

Fixes: 985ec6f5e623 ("net: ipv6: rpl_iptunnel: mitigate 2-realloc issue")
Fixes: 40475b63761a ("net: ipv6: seg6_iptunnel: mitigate 2-realloc issue")
Fixes: dce525185bc9 ("net: ipv6: ioam6_iptunnel: mitigate 2-realloc issue")
Reviewed-by: Justin Iurman <justin.iurman@uliege.be>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250130031519.2716843-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/ioam6_iptunnel.c |    5 +++--
 net/ipv6/rpl_iptunnel.c   |    6 ++++--
 net/ipv6/seg6_iptunnel.c  |    6 ++++--
 3 files changed, 11 insertions(+), 6 deletions(-)

--- a/net/ipv6/ioam6_iptunnel.c
+++ b/net/ipv6/ioam6_iptunnel.c
@@ -336,7 +336,7 @@ static int ioam6_do_encap(struct net *ne
 
 static int ioam6_output(struct net *net, struct sock *sk, struct sk_buff *skb)
 {
-	struct dst_entry *dst = skb_dst(skb), *cache_dst;
+	struct dst_entry *dst = skb_dst(skb), *cache_dst = NULL;
 	struct in6_addr orig_daddr;
 	struct ioam6_lwt *ilwt;
 	int err = -EINVAL;
@@ -407,7 +407,6 @@ do_encap:
 		cache_dst = ip6_route_output(net, NULL, &fl6);
 		if (cache_dst->error) {
 			err = cache_dst->error;
-			dst_release(cache_dst);
 			goto drop;
 		}
 
@@ -429,8 +428,10 @@ do_encap:
 		return dst_output(net, sk, skb);
 	}
 out:
+	dst_release(cache_dst);
 	return dst->lwtstate->orig_output(net, sk, skb);
 drop:
+	dst_release(cache_dst);
 	kfree_skb(skb);
 	return err;
 }
--- a/net/ipv6/rpl_iptunnel.c
+++ b/net/ipv6/rpl_iptunnel.c
@@ -232,7 +232,6 @@ static int rpl_output(struct net *net, s
 		dst = ip6_route_output(net, NULL, &fl6);
 		if (dst->error) {
 			err = dst->error;
-			dst_release(dst);
 			goto drop;
 		}
 
@@ -254,6 +253,7 @@ static int rpl_output(struct net *net, s
 	return dst_output(net, sk, skb);
 
 drop:
+	dst_release(dst);
 	kfree_skb(skb);
 	return err;
 }
@@ -272,8 +272,10 @@ static int rpl_input(struct sk_buff *skb
 	local_bh_enable();
 
 	err = rpl_do_srh(skb, rlwt, dst);
-	if (unlikely(err))
+	if (unlikely(err)) {
+		dst_release(dst);
 		goto drop;
+	}
 
 	if (!dst) {
 		ip6_route_input(skb);
--- a/net/ipv6/seg6_iptunnel.c
+++ b/net/ipv6/seg6_iptunnel.c
@@ -482,8 +482,10 @@ static int seg6_input_core(struct net *n
 	local_bh_enable();
 
 	err = seg6_do_srh(skb, dst);
-	if (unlikely(err))
+	if (unlikely(err)) {
+		dst_release(dst);
 		goto drop;
+	}
 
 	if (!dst) {
 		ip6_route_input(skb);
@@ -571,7 +573,6 @@ static int seg6_output_core(struct net *
 		dst = ip6_route_output(net, NULL, &fl6);
 		if (dst->error) {
 			err = dst->error;
-			dst_release(dst);
 			goto drop;
 		}
 
@@ -596,6 +597,7 @@ static int seg6_output_core(struct net *
 
 	return dst_output(net, sk, skb);
 drop:
+	dst_release(dst);
 	kfree_skb(skb);
 	return err;
 }


