Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7262C43991A;
	Mon, 31 Aug 2026 13:59:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184744; cv=none; b=swnnff9Fm2OQIXKfhTBwU12lJuM2lvUGMqpNaS7Wiq3hiW7xDTAHiZqXPllCW2pKNREwBYcKWS+RPcAEt27cze108Uk7WIWXOWOoAJyZRK1K14Zj+Fp6PxDazkmT3hGYvaS52cV80THF3qNvoqWo+6VSi2Aslg8siw6VMLkSqIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184744; c=relaxed/simple;
	bh=3ukteNYGzVgMxlyFp4WZqmVpsEWqj21F92cAFZpFDbs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oT5udb7XA0hX2BF+VtgIEUoPwrvWkRZqwFRyJWJQd/gGtyDh8HibPm5us1azUT0R2/2hWut/9LD548eviRIH4Shc5RlUx3uF0KZYpWl084Sisb8ZgQyVJYQntTsjje1xjQL9zbUW5/oJd7rl1YpXHZGD2KZHm+qGaXft2l4mZjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cr4iNrHa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cr4iNrHa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBFE31F000E9;
	Mon, 31 Aug 2026 13:59:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184742;
	bh=KB7lhYhksb27sqDqjMlLX/bFUuQg5jZ6L9RPZuFW8Qo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cr4iNrHaG2r3fSTQrPycnO+oCHm/Q2EKBEkxZSCyATGylHOqmiZpp3hi+gj+w2+PT
	 7jM4OsUBszzwq6ZPCf/9ndogua7zmBIWzVBgZr4eYVODNixiSeV/XQvHapd/itcU7X
	 3jk/soglqXvPI0estGLFegO8QUFFgizr5jPQlTqA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julian Anastasov <ja@ssi.bg>,
	Florian Westphal <fw@strlen.de>,
	Denis Arefev <arefev@swemel.ru>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 06/92] ipvs: reload ip header after head reallocation
Date: Mon, 31 Aug 2026 15:34:04 +0200
Message-ID: <20260831133359.797334965@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.482388899@linuxfoundation.org>
References: <20260831133359.482388899@linuxfoundation.org>
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

From: Florian Westphal <fw@strlen.de>

commit a2f57827bf7c695b8c72dc4511cae8e86582369d upstream.

__ip_vs_get_out_rt() calls skb_ensure_writable() which may
reallocate skb->head.

Fixes: 8d8e20e2d7bb ("ipvs: Decrement ttl")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-sonnet-4-6
Acked-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Florian Westphal <fw@strlen.de>
[Denis Arefev: adapted for 5.10/6.1: keep EnterFunction/LeaveFunction
instrumentation]
Signed-off-by: Denis Arefev <arefev@swemel.ru>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/ipvs/ip_vs_xmit.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_xmit.c b/net/netfilter/ipvs/ip_vs_xmit.c
index 63dd0a3d251f8..79d6e3b4e2c03 100644
--- a/net/netfilter/ipvs/ip_vs_xmit.c
+++ b/net/netfilter/ipvs/ip_vs_xmit.c
@@ -707,15 +707,13 @@ int
 ip_vs_bypass_xmit(struct sk_buff *skb, struct ip_vs_conn *cp,
 		  struct ip_vs_protocol *pp, struct ip_vs_iphdr *ipvsh)
 {
-	struct iphdr  *iph = ip_hdr(skb);
-
 	EnterFunction(10);
 
-	if (__ip_vs_get_out_rt(cp->ipvs, cp->af, skb, NULL, iph->daddr,
+	if (__ip_vs_get_out_rt(cp->ipvs, cp->af, skb, NULL, ip_hdr(skb)->daddr,
 			       IP_VS_RT_MODE_NON_LOCAL, NULL, ipvsh) < 0)
 		goto tx_error;
 
-	ip_send_check(iph);
+	ip_send_check(ip_hdr(skb));
 
 	/* Another hack: avoid icmp_send in ip_fragment */
 	skb->ignore_df = 1;
-- 
2.53.0



