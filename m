Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B750818E025;
	Tue, 17 Jun 2025 16:00:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176051; cv=none; b=hjfEN2AL+7YQKrDYZLusB+JRbAj8IuJ2wFw01xxqGzrxCanS4KbQnbp2TfaAXDWU9ytqFIe00g3MFWry6F5+HG7RdmQNdZzTHOm267M68XDPrbzcKRtpP1m88R9YeDoJK7dKW/g1YxAmd7ipNVLDvAV3+qXo2WgtrXAu4qKozmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176051; c=relaxed/simple;
	bh=9ndV3nnvFsYoKgqsPTQjtTrNW5PsYLrmfIs9PtNrKfo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e5zVzqSM5LlnIYi6CoZM7X3GaU0IhOrV/jxcPe3kiQTcYc9jaXlZ3YjOELGudN9caQmmvavf3bvYS0w4+sIuam7H3WGfE+H1FN38v7fP1JIJlOkllRWO0WL9CpEBoxNzYI472jYIfT4x22s3XHj+KfTOXYO5MkwPvAYD4maEZ64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WVlBADIa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WVlBADIa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24452C4CEE3;
	Tue, 17 Jun 2025 16:00:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176051;
	bh=9ndV3nnvFsYoKgqsPTQjtTrNW5PsYLrmfIs9PtNrKfo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WVlBADIa7ejAc7X7RlGqH3Nyj//9P3/1KanDX44o0krOYv9a7wZipLJQF9uQ/7NYI
	 cbWziUOshUsl5YpYQWAgGnVehV6ll5I/knFQvikQ+onKKCXUBfKzk0svESFEi3uqMW
	 HUSV5jJpewCRtcdbKg6Ci3TgRp916cV5VdRELhNo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 191/512] netfilter: xtables: support arpt_mark and ipv6 optstrip for iptables-nft only builds
Date: Tue, 17 Jun 2025 17:22:37 +0200
Message-ID: <20250617152427.376667311@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

[ Upstream commit c38eb2973c18d34a8081d173a6ad298461f4a37c ]

Its now possible to build a kernel that has no support for the classic
xtables get/setsockopt interfaces and builtin tables.

In this case, we have CONFIG_IP6_NF_MANGLE=n and
CONFIG_IP_NF_ARPTABLES=n.

For optstript, the ipv6 code is so small that we can enable it if
netfilter ipv6 support exists. For mark, check if either classic
arptables or NFT_ARP_COMPAT is set.

Fixes: a9525c7f6219 ("netfilter: xtables: allow xtables-nft only builds")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/xt_TCPOPTSTRIP.c | 4 ++--
 net/netfilter/xt_mark.c        | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/xt_TCPOPTSTRIP.c b/net/netfilter/xt_TCPOPTSTRIP.c
index 30e99464171b7..93f064306901c 100644
--- a/net/netfilter/xt_TCPOPTSTRIP.c
+++ b/net/netfilter/xt_TCPOPTSTRIP.c
@@ -91,7 +91,7 @@ tcpoptstrip_tg4(struct sk_buff *skb, const struct xt_action_param *par)
 	return tcpoptstrip_mangle_packet(skb, par, ip_hdrlen(skb));
 }
 
-#if IS_ENABLED(CONFIG_IP6_NF_MANGLE)
+#if IS_ENABLED(CONFIG_IP6_NF_IPTABLES)
 static unsigned int
 tcpoptstrip_tg6(struct sk_buff *skb, const struct xt_action_param *par)
 {
@@ -119,7 +119,7 @@ static struct xt_target tcpoptstrip_tg_reg[] __read_mostly = {
 		.targetsize = sizeof(struct xt_tcpoptstrip_target_info),
 		.me         = THIS_MODULE,
 	},
-#if IS_ENABLED(CONFIG_IP6_NF_MANGLE)
+#if IS_ENABLED(CONFIG_IP6_NF_IPTABLES)
 	{
 		.name       = "TCPOPTSTRIP",
 		.family     = NFPROTO_IPV6,
diff --git a/net/netfilter/xt_mark.c b/net/netfilter/xt_mark.c
index 65b965ca40ea7..59b9d04400cac 100644
--- a/net/netfilter/xt_mark.c
+++ b/net/netfilter/xt_mark.c
@@ -48,7 +48,7 @@ static struct xt_target mark_tg_reg[] __read_mostly = {
 		.targetsize     = sizeof(struct xt_mark_tginfo2),
 		.me             = THIS_MODULE,
 	},
-#if IS_ENABLED(CONFIG_IP_NF_ARPTABLES)
+#if IS_ENABLED(CONFIG_IP_NF_ARPTABLES) || IS_ENABLED(CONFIG_NFT_COMPAT_ARP)
 	{
 		.name           = "MARK",
 		.revision       = 2,
-- 
2.39.5



