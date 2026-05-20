Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EF343EEAC4;
	Wed, 20 May 2026 17:01:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296476; cv=none; b=HVCi/37C5RKSvpXuMn4ncfSwMh3e3j0KZuOOIYMaGvC89L71IT43D7MEIDHYNercFvUqkKeQNDMWQ9OGSnQuf//fgoRWROCF5UxERCZ7kcsoTsy2Nw9Q8VDIiwUB95/+h/sPeX54i2e3XmIooMYoWtYQeforc0kWIXJVpkWC/rw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296476; c=relaxed/simple;
	bh=zqu5Y6zpkjGk3iHA/zzJcV/2vgBRKYXkFiYQR8yH5VQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cscBrqP3oRlMEwi4dJ/xvgleudv0Fg/d5dI5XgCVeMtV6Nfk40cQSlCFRO8zPfxPd5B+85Tya7bw9ZvfcNYKAHLtQ9/uzIAcRsz1yxJ5AOqm+W6gfRRXXLScwtp8lhqY/WRH9xl+xamX3NN+i2Q+k92yIqD1OBghnWkGCg/niVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lDVfnKji; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lDVfnKji"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD8381F000E9;
	Wed, 20 May 2026 17:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296474;
	bh=EyeX+tj/D+Vq2YVSdWGivtWM4PNCc9mtpB/1Cuhh9Vg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lDVfnKjijqXCesMTO3Sm/x+QvDTU/N33nzeynr54vAzNm+GEhOx3XOPfKbwd7K7tj
	 Ygeo01fQTdge3cFJbg63EeIQlDo7ZDpN7kY78WrPySH/MGZkzJZZ2uGOl8hFieF3Ko
	 lTIo9BcXl0OjbsD3ueYCegOPFg6HGBisR+wsHTz4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weiming Shi <bestswngs@gmail.com>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Xiang Mei <xmei5@asu.edu>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0812/1146] netfilter: nfnetlink_osf: fix divide-by-zero in OSF_WSS_MODULO
Date: Wed, 20 May 2026 18:17:42 +0200
Message-ID: <20260520162206.602108895@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiang Mei <xmei5@asu.edu>

[ Upstream commit 2195574dc6d9017d32ac346987e12659f931d932 ]

nf_osf_match_one() computes ctx->window % f->wss.val in the
OSF_WSS_MODULO branch with no guard for f->wss.val == 0. A
CAP_NET_ADMIN user can add such a fingerprint via nfnetlink; a
subsequent matching TCP SYN divides by zero and panics the kernel.

Reject the bogus fingerprint in nfnl_osf_add_callback() above the
per-option for-loop. f->wss is per-fingerprint, not per-option, so
the check must run regardless of f->opt_num (including 0). Also
reject wss.wc >= OSF_WSS_MAX; nf_osf_match_one() already treats that
as "should not happen".

Crash:
 Oops: divide error: 0000 [#1] SMP KASAN NOPTI
 RIP: 0010:nf_osf_match_one (net/netfilter/nfnetlink_osf.c:98)
 Call Trace:
 <IRQ>
  nf_osf_match (net/netfilter/nfnetlink_osf.c:220)
  xt_osf_match_packet (net/netfilter/xt_osf.c:32)
  ipt_do_table (net/ipv4/netfilter/ip_tables.c:348)
  nf_hook_slow (net/netfilter/core.c:622)
  ip_local_deliver (net/ipv4/ip_input.c:265)
  ip_rcv (include/linux/skbuff.h:1162)
  __netif_receive_skb_one_core (net/core/dev.c:6181)
  process_backlog (net/core/dev.c:6642)
  __napi_poll (net/core/dev.c:7710)
  net_rx_action (net/core/dev.c:7945)
  handle_softirqs (kernel/softirq.c:622)

Fixes: 11eeef41d5f6 ("netfilter: passive OS fingerprint xtables match")
Reported-by: Weiming Shi <bestswngs@gmail.com>
Suggested-by: Florian Westphal <fw@strlen.de>
Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Xiang Mei <xmei5@asu.edu>
Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nfnetlink_osf.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/netfilter/nfnetlink_osf.c b/net/netfilter/nfnetlink_osf.c
index 45d9ad231a920..70172ca078585 100644
--- a/net/netfilter/nfnetlink_osf.c
+++ b/net/netfilter/nfnetlink_osf.c
@@ -320,6 +320,10 @@ static int nfnl_osf_add_callback(struct sk_buff *skb,
 	if (f->opt_num > ARRAY_SIZE(f->opt))
 		return -EINVAL;
 
+	if (f->wss.wc >= OSF_WSS_MAX ||
+	    (f->wss.wc == OSF_WSS_MODULO && f->wss.val == 0))
+		return -EINVAL;
+
 	for (i = 0; i < f->opt_num; i++) {
 		if (!f->opt[i].length || f->opt[i].length > MAX_IPOPTLEN)
 			return -EINVAL;
-- 
2.53.0



