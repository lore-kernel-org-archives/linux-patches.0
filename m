Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABD594968E2;
	Mon, 31 Aug 2026 14:07:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788185252; cv=none; b=F/q0MCoFi6zyW2YOSTmqEiV3LH1NCCjHcEzyPn4ZNSwv893zdPAlCNLEChCEw6z8FWXLAuJXr1BJ2CZKOtHN3HSaXXepItam7Gh0fiyIwq9Z8PzSS0X0ZV+rb73eO8BFhf/FvnvmCux2wrJYp+yfh6gWMSvPxQUGJBSViBVr5y4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788185252; c=relaxed/simple;
	bh=Vq+Znowe8aKHjRKeS+5k8wTRykIQ5CffKYecv+K4aJw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LvJRAuOyfLJoMvqysAbbI06aVo9qokI+tMtx2mTAnKslr9Qy72QYX3WoyVPJT3c6ZJJv7rTKqBI4CEY/mTz3jol1Zgb1BGggsEzpzOON77pfM81gtIL0ryZeGdZNPxkSHg2FN84VeRi706yJHinIbhGZUULFubp/haGXBl3N+BM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CDGyc1/A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CDGyc1/A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1273B1F000E9;
	Mon, 31 Aug 2026 14:07:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788185251;
	bh=W23wGoiLDACLi4HWE8hKE76/FErp0Bqe2J587HsXuxM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CDGyc1/AAyISo4gvv6j6mI+2tDIv0iHQVwLVZfACHbOgId85WAJC+vmLy0ezJcbZc
	 atSHgsPR4skwEskNYV90l0yLOL1Ti/BFFAu6w8K0s93mh9PEMcNrivQicxEoHcENGM
	 t0dI9omboPzMyZ8oA3tXlcFSf7fzSrQuWgMhBYqI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julian Anastasov <ja@ssi.bg>,
	Florian Westphal <fw@strlen.de>,
	Denis Arefev <arefev@swemel.ru>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 04/43] ipvs: reload ip header after head reallocation
Date: Mon, 31 Aug 2026 15:35:12 +0200
Message-ID: <20260831133358.748300346@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133358.571886287@linuxfoundation.org>
References: <20260831133358.571886287@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 9e199f00eea73..40a1d31b4054f 100644
--- a/net/netfilter/ipvs/ip_vs_xmit.c
+++ b/net/netfilter/ipvs/ip_vs_xmit.c
@@ -718,15 +718,13 @@ int
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



