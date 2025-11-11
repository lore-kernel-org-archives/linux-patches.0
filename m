Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B2BA25EF81;
	Tue, 11 Nov 2025 01:14:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823698; cv=none; b=IByunJm1zzVEuMw1JBc4NSKSEOIwvafbHdkHOGsfrJNEr4NaORCedfwxdi2L9+MmDFnF97OaXoujXld0B5tKZraHqev/X2RUbiZ7UMDFuMyUATd8gb7DcUy4fkLCFUH2fLM01sf+j7orLa1uWvHFdNW66O8GBMo01WEn2zxc3EY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823698; c=relaxed/simple;
	bh=GwyZPaKoq65U0CbmaJVre070wRYXG/op09jwTW2GGKI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=flVtrRuxJWz+kgR+n8lFT1+E7JxZZPQd5U27atqRWXmuQ1dftK5EshRoRs7Z/XdtOXHRVNqUzjfadCWraq9v+rY1R9bAZW1pY9UTBqoBdlINZW0OABsFHQNQ3ctpGSPzRfdlBrR9/guJSzlEc5y/mZYyNLXFxoy1Gh0jvpLPvtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AFpE89xc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AFpE89xc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D62C1C19422;
	Tue, 11 Nov 2025 01:14:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823698;
	bh=GwyZPaKoq65U0CbmaJVre070wRYXG/op09jwTW2GGKI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AFpE89xcws4cfmnAj7RNMR2KRxMetltzuglVGyEyBM4SM89B24hvHQUNjgXlt4S+U
	 Mx72UcvTy1ZrYYFbkZHF9jORBez3K8e2ooaaumWGRgyYRp2I4Lp8y0n+q38DKJbonh
	 b1fV5CVU9yl93y3RyP9J/6OcpozP2WnC0iRN57Mw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oscar Maes <oscmaes92@gmail.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 352/849] net: ipv4: allow directed broadcast routes to use dst hint
Date: Tue, 11 Nov 2025 09:38:42 +0900
Message-ID: <20251111004544.930482568@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oscar Maes <oscmaes92@gmail.com>

[ Upstream commit 1b8c5fa0cb35efd08f07f700e6d78a541ebabe26 ]

Currently, ip_extract_route_hint uses RTN_BROADCAST to decide
whether to use the route dst hint mechanism.

This check is too strict, as it prevents directed broadcast
routes from using the hint, resulting in poor performance
during bursts of directed broadcast traffic.

Fix this in ip_extract_route_hint and modify ip_route_use_hint
to preserve the intended behaviour.

Signed-off-by: Oscar Maes <oscmaes92@gmail.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://patch.msgid.link/20250819174642.5148-2-oscmaes92@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/ip_input.c | 11 +++++++----
 net/ipv4/route.c    |  2 +-
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/net/ipv4/ip_input.c b/net/ipv4/ip_input.c
index fc323994b1fa0..a09aca2c8567d 100644
--- a/net/ipv4/ip_input.c
+++ b/net/ipv4/ip_input.c
@@ -587,9 +587,13 @@ static void ip_sublist_rcv_finish(struct list_head *head)
 }
 
 static struct sk_buff *ip_extract_route_hint(const struct net *net,
-					     struct sk_buff *skb, int rt_type)
+					     struct sk_buff *skb)
 {
-	if (fib4_has_custom_rules(net) || rt_type == RTN_BROADCAST ||
+	const struct iphdr *iph = ip_hdr(skb);
+
+	if (fib4_has_custom_rules(net) ||
+	    ipv4_is_lbcast(iph->daddr) ||
+	    ipv4_is_zeronet(iph->daddr) ||
 	    IPCB(skb)->flags & IPSKB_MULTIPATH)
 		return NULL;
 
@@ -618,8 +622,7 @@ static void ip_list_rcv_finish(struct net *net, struct list_head *head)
 
 		dst = skb_dst(skb);
 		if (curr_dst != dst) {
-			hint = ip_extract_route_hint(net, skb,
-						     dst_rtable(dst)->rt_type);
+			hint = ip_extract_route_hint(net, skb);
 
 			/* dispatch old sublist */
 			if (!list_empty(&sublist))
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 5582ccd673eeb..86a20d12472f4 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -2210,7 +2210,7 @@ ip_route_use_hint(struct sk_buff *skb, __be32 daddr, __be32 saddr,
 		goto martian_source;
 	}
 
-	if (rt->rt_type != RTN_LOCAL)
+	if (!(rt->rt_flags & RTCF_LOCAL))
 		goto skip_validate_source;
 
 	reason = fib_validate_source_reason(skb, saddr, daddr, dscp, 0, dev,
-- 
2.51.0



