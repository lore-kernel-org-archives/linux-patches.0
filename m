Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 912FB407CCF;
	Tue, 21 Jul 2026 18:42:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659362; cv=none; b=bwJsydmA4N4BUc6pw/HASOZex5AvxUPspnnbErrxfNYWUyYrhLqL+nCVVqOx/XMxZ0kpYzW7R2rDoL7xp9vOvwmW4z9RzPZFvO+jdDo8dBudybRkepkogkn5gpsv2bGAOJSN4yDDCDNZbZJ7b4OfWXhJn7FUaTiaQUxPL58FJF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659362; c=relaxed/simple;
	bh=+Uejj/TXZmDrYDW+aS1K55wj5WXuZmKswERtLQ08gS8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UzxtYUQaqikY+wW/fLpPXFOZ2Woj9r+wzF8pPQIOeBg8/NyEmf2AWDsF15wKUDnnuRZ+qRwrqTFObCUvWlT8wyCdXNAHdzXzfLakKMetY/XvDJargwptdK4ewpEQX3hmNnj8rmTFAwR5yfO8H+Aq+YNOEWNMVuZOTCCVewCwMHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xMeJoxgV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xMeJoxgV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFC441F000E9;
	Tue, 21 Jul 2026 18:42:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659359;
	bh=IhprnteCR58N8zDwFV0CcL4zZGKAG0xP3nl1/qNWmp0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xMeJoxgVyajniF7YwHD5CIO1GA+W1CTjkMN8wHWya40MdblwoWjMMNrKiGKzv7FQb
	 UobO4H3wCNeeYwaNDwtCeO/1MU3dZLJtOf4iteOKF07SBtGXBJ3P0Uh5GYe9i8DO8v
	 gZzwaQ4iSOsgVzG8twSvVV6Ou7IDto8Z+hMiKG4E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julian Anastasov <ja@ssi.bg>,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH 6.18 1492/1611] ipvs: reload ip header after head reallocation
Date: Tue, 21 Jul 2026 17:26:48 +0200
Message-ID: <20260721152549.001767470@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Florian Westphal <fw@strlen.de>

commit a2f57827bf7c695b8c72dc4511cae8e86582369d upstream.

__ip_vs_get_out_rt() calls skb_ensure_writable() which may
reallocate skb->head.

Fixes: 8d8e20e2d7bb ("ipvs: Decrement ttl")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-sonnet-4-6
Acked-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/ipvs/ip_vs_xmit.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/net/netfilter/ipvs/ip_vs_xmit.c
+++ b/net/netfilter/ipvs/ip_vs_xmit.c
@@ -733,13 +733,11 @@ int
 ip_vs_bypass_xmit(struct sk_buff *skb, struct ip_vs_conn *cp,
 		  struct ip_vs_protocol *pp, struct ip_vs_iphdr *ipvsh)
 {
-	struct iphdr  *iph = ip_hdr(skb);
-
-	if (__ip_vs_get_out_rt(cp->ipvs, cp->af, skb, NULL, iph->daddr,
+	if (__ip_vs_get_out_rt(cp->ipvs, cp->af, skb, NULL, ip_hdr(skb)->daddr,
 			       IP_VS_RT_MODE_NON_LOCAL, NULL, ipvsh) < 0)
 		goto tx_error;
 
-	ip_send_check(iph);
+	ip_send_check(ip_hdr(skb));
 
 	/* Another hack: avoid icmp_send in ip_fragment */
 	skb->ignore_df = 1;


