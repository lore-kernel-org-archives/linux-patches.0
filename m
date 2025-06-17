Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B20FC2F94A0;
	Tue, 17 Jun 2025 16:26:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177595; cv=none; b=uOIt1CUYpUVPplmDe1QfcJ/zhqVXerGCIaZZ+Gc2uYbbCRKf08BIuUtipZoBY146WY+5qX+6TOlCNOVMvbjaX44+4JWgt3G1uFcay/b/dr3WMWTFubC878MqMunqz5V6fy/FlKhdAwPcxtebIhIhbpTaD3Jusn7TCVAyX4APNrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177595; c=relaxed/simple;
	bh=+c4Dqu0uoFG5u1By4JTnEsADlXNxQVx+43ABe5pfqVk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r7uH4VBzqCIcrpUYLt+aQZFuVOpxEdNW0s8xGw0d5lc+XO+wR4C/ShDLPv29s82VCuhRTsdDdxsC93Xa9K53D2Hxjfdf6vxWjcMTI3NKyKdUnf6UoEcCR0SX/uaMrntKe7Cya1sSlcl6LwLxC+2g5p+iiP+xC1fhzXmXI0sMayk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dXlgTOP/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dXlgTOP/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6AF3C4CEE3;
	Tue, 17 Jun 2025 16:26:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177595;
	bh=+c4Dqu0uoFG5u1By4JTnEsADlXNxQVx+43ABe5pfqVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dXlgTOP/k4q2a7T/L0hxwWVjOEVIN0VXPtoVk7ypFh4f/l9RRh3GxN5qVf1dBH2/O
	 OxBCjZ7QLCh94TJ5cFOJI03/3+S//J7ej6PWFaI76iPsgyVP9fMkBdDtRyRfLQZspz
	 LZrCesbKSkC6r+kbqBYobC9ESIOZRc1AbjwZPpcc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 307/780] netfilter: xtables: support arpt_mark and ipv6 optstrip for iptables-nft only builds
Date: Tue, 17 Jun 2025 17:20:15 +0200
Message-ID: <20250617152503.963629133@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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



