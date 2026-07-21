Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEA093C09F3;
	Tue, 21 Jul 2026 21:33:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669627; cv=none; b=RrmFoTKFVZTo3civyvxKg731+WmkCn//lOMmTEZWgWfc5DaN7Q4OtMh5x70yp1UzavL79xD5d1JJo/MvnrpFGjMF27oarv4EB/olT5rj8KpIGO5Q8v0t1V0lgoOMCT/Ra/Hpl7o45IZylYVXBDRDf0hqjv8SBDL0g8DS3y5Sf20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669627; c=relaxed/simple;
	bh=Neo1fzbaShZKv7cDc2KhlI8hbwcYR+y5CUAwxr8b+xk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ICUuUAHI5S6Nh1VccjSaRCtEuerGtoGpUHb/4AVajYkzm8Yfwn5MkZxrZ6n5bpBWBz4nYbYfUuX2AgHqnZhg46DqVAGFo+aRzRsARELExGirsKN4M7IJXPU+1I5T1F6ma1XDqJq6fhKFJOktSFf8yi69I/0s8p6L1YczLk3dFAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wj8y5GEl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wj8y5GEl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B07C31F000E9;
	Tue, 21 Jul 2026 21:33:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669624;
	bh=W4kGGAeNyUTazW5EXobZdCNPqr0rtOjCM1U9MG/jz+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wj8y5GElwoMQJOcY8VyFbECGToUg67ZJXJetcIatgTgtCOL6hGRTo7g0k1j0Px6nL
	 cibIdyu0WUz5cpVG4m4/iORqDaJygqG+cLPNNZ1lIELZmYT+gAJbMEqhxu7ELM+SXI
	 513mzsFHP7i60pkFj4wlcq4bWEuMwnXJENmKpdEo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0626/1067] netfilter: nft_synproxy: stop bypassing the priv->info snapshot
Date: Tue, 21 Jul 2026 17:20:27 +0200
Message-ID: <20260721152438.601882760@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

From: Runyu Xiao <runyu.xiao@seu.edu.cn>

[ Upstream commit 11d4bc4e26fb66040a5b5d95e9abf37deac2b1fc ]

nft_synproxy_eval_v4() and nft_synproxy_eval_v6() already take a
whole-object READ_ONCE() snapshot of the shared priv->info state before
building the SYNACK reply, but nft_synproxy_tcp_options() still masks
opts->options with priv->info.options from the live shared object.

When a named synproxy object is updated concurrently with SYN traffic,
the eval path can then mix mss and timestamp handling from the local
snapshot with an options mask taken from a newer configuration, so one
SYNACK no longer reflects a coherent synproxy configuration.

Use info->options so nft_synproxy_tcp_options() stays on the same local
snapshot that the eval path already copied from priv->info.

Fixes: ee394f96ad75 ("netfilter: nft_synproxy: add synproxy stateful object support")
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_synproxy.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nft_synproxy.c b/net/netfilter/nft_synproxy.c
index 0cc638553aef2b..fe4031afdf9b70 100644
--- a/net/netfilter/nft_synproxy.c
+++ b/net/netfilter/nft_synproxy.c
@@ -23,14 +23,13 @@ static const struct nla_policy nft_synproxy_policy[NFTA_SYNPROXY_MAX + 1] = {
 static void nft_synproxy_tcp_options(struct synproxy_options *opts,
 				     const struct tcphdr *tcp,
 				     struct synproxy_net *snet,
-				     struct nf_synproxy_info *info,
-				     const struct nft_synproxy *priv)
+				     struct nf_synproxy_info *info)
 {
 	this_cpu_inc(snet->stats->syn_received);
 	if (tcp->ece && tcp->cwr)
 		opts->options |= NF_SYNPROXY_OPT_ECN;
 
-	opts->options &= priv->info.options;
+	opts->options &= info->options;
 	opts->mss_encode = opts->mss_option;
 	opts->mss_option = info->mss;
 	if (opts->options & NF_SYNPROXY_OPT_TIMESTAMP)
@@ -55,7 +54,7 @@ static void nft_synproxy_eval_v4(const struct nft_synproxy *priv,
 
 	if (tcp->syn) {
 		/* Initial SYN from client */
-		nft_synproxy_tcp_options(opts, tcp, snet, &info, priv);
+		nft_synproxy_tcp_options(opts, tcp, snet, &info);
 		synproxy_send_client_synack(net, skb, tcp, opts);
 		consume_skb(skb);
 		regs->verdict.code = NF_STOLEN;
@@ -86,7 +85,7 @@ static void nft_synproxy_eval_v6(const struct nft_synproxy *priv,
 
 	if (tcp->syn) {
 		/* Initial SYN from client */
-		nft_synproxy_tcp_options(opts, tcp, snet, &info, priv);
+		nft_synproxy_tcp_options(opts, tcp, snet, &info);
 		synproxy_send_client_synack_ipv6(net, skb, tcp, opts);
 		consume_skb(skb);
 		regs->verdict.code = NF_STOLEN;
-- 
2.53.0



