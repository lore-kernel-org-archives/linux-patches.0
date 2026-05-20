Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47CA6349AFF;
	Wed, 20 May 2026 17:47:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299231; cv=none; b=mStbDLPoIcI2VAtKmYB5y023FhXgjxOmAnVjhH2FlZ9RBmBAZYmmu2ozhVXo7sef2pPnHnpBYTY+jqBe8leMJ38Cd59//vT45xX4BSXnpqs7i09FBsW92lvXA7J0cVVzG6WOcfml8ME0jQJDHIuk6Q0O2pdeTYeQO9swTk+dIyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299231; c=relaxed/simple;
	bh=pV7go090PH0k+cUC4UfXSDFNVcUG8TfI5VonCB5w1/g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AxEYLRGXOjEyIiCRWvDEszW1Aye+iQoAGpbaKbi8vKVTtX8oAT9FUbOOALPGJci5/pcWJaQIhsbWaWeaRsAt6p6oM/N0fa8xywpXiSsL03dg0G8tIBDy9/qeMRDtDSCml+qtHAAOSsbcoNJ13g+eC2DWzQNAtBPxF1gWzLoaxGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LelmQjZ+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LelmQjZ+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B60451F000E9;
	Wed, 20 May 2026 17:47:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299230;
	bh=mdViNADGup4CqCToRn4WCYed2ozDx2+Wek/Ki7rj4ac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LelmQjZ+0gEBLKq9W2eQIrbFFZS9Qbm0w9H/snwNn5c4SRhFwW58kfMRqovIZYJWr
	 YfwVZJjJvVJ/1PJ3Hr2bHWkkUYmFXCvA6y2eHkRjKrdSCfBsYglEUsUTmSsAr+wmom
	 fG4rBNhYlxm1LPdO5uR0/CEc99Usb//AlftOaPq0=
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
Subject: [PATCH 6.18 661/957] netfilter: nfnetlink_osf: fix divide-by-zero in OSF_WSS_MODULO
Date: Wed, 20 May 2026 18:19:04 +0200
Message-ID: <20260520162148.867023812@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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
index 9fc9544d4bc53..2305c7d9761eb 100644
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



