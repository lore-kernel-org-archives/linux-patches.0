Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D63C3E49F0;
	Tue, 21 Jul 2026 17:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655265; cv=none; b=jcy0Oj4A9Etnoy9MWv1K480NbJ8Dhzp9EqTHrODR4kxqmnsytooPaa+605eROTJyX0Ce3ZQBOSbM3pzjUiYFcrzqqDBYyQuc2fG3feHZI7w0t0p2WOmmzuRyeO2e0n72EK6LNssoOBNSScYzzHNtCwNymTs9Ge/ChU6nlFBetUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655265; c=relaxed/simple;
	bh=xtIw5kxgoTptrEiUZs9JIjw7QpfI+zPcgvzjqMEpSmg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eDOES3Gz7FBEq0RFOhcUgU35aoiB6CKp2+36hwAcGJBiMjGt9WblOGqyDLJM8xG/q8xIGdvHMy6ECJ9Iax2b+Wz9a2SIO4BkjDT/cz94dZWXQwP+mqKpXAjH9suUjFeKbSnV+cLeV5tWlKq4ahHcoppV2WCw4pIjW22P9sLrQEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zx9Kvc0h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zx9Kvc0h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B368E1F000E9;
	Tue, 21 Jul 2026 17:34:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655264;
	bh=0KB4uo8RD52tlDlvT6H047S7oVBXIdhydeie/pWQz1s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zx9Kvc0hpgqubIk0PIwo+7FAuHskuh0h+Gx+juH/UxwDH29Uarp3fdGwbQuckZWBC
	 /RMnJJ/mnqXmHhZx0Uy2htaQZVGCg0FyM4Dd7b0kmWy6Cf28t0TQo6zNJj1CJoHdWY
	 HmfKI6RcnkO/3WPoYlDO7my83NAUQ4sNIW5Wcl3A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julian Anastasov <ja@ssi.bg>,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH 7.1 2017/2077] ipvs: reload ip header after head reallocation
Date: Tue, 21 Jul 2026 17:28:10 +0200
Message-ID: <20260721152640.276801563@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -736,13 +736,11 @@ int
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


