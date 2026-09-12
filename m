Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08622432E60;
	Sat, 12 Sep 2026 15:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789226335; cv=none; b=idB7UYnWl3+Eipo1MPYO2K0C1GKS51M3Mc/hPoC48fg99GVmXp+VBV1kKqJ7xExNwklCXkOcldaHH/gmrM7L6IheeDuJARtjP8Ko64aegzuZuU3emhx7AndJ6scCReA5nr+leAnxLfpYz1x/erTgcLrd3fawEVlNAeQYN89xTqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789226335; c=relaxed/simple;
	bh=lt1XYwPziQi2dj7M96Ldk3IjJrF2RXtMwt5u1/upMug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o2Tva8s+GLVp9ADhjQj3dlZWpCyiC+/nNw6lXHAKwejc8QN63L+vz76Ycp4TgZkGWNZFxIcqDwTrrUgotS8g6oXC5aJ7lXSD3HhGEg+/qleOncxPv3V7zpUTPnkDHPtUK+KadS6H+7bepTBfT/NVrG8znUjbaBeNzHSeGtZvAEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2l2D3Zpz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2l2D3Zpz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 940951F00893;
	Sat, 12 Sep 2026 15:18:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789226333;
	bh=j9IGZe8jI7rh+pC/vw73vTfI7LL9PAQOkMaQM8rkYRY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2l2D3ZpzGf0Q4oB7rW+Dl9sgzD/IByv9bwqZlPzJcdzSQus+AkFfxTf9zUfSwaN9s
	 /jqkPKy7sH//EY35Bgwa9Is6dLRnCadV5AHhLCGxJCrWXPbruusy5QFGDc+U1BH8T7
	 O/iVG6p36dv7sZoT9vFPqDv0IUTkFqpbmicfdZU0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marino Dzalto <marino.dzalto@gmail.com>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1382/1424] netfilter: xt_HL: add pr_fmt and checkentry validation
Date: Sat, 12 Sep 2026 09:03:34 +0200
Message-ID: <20260912065638.206170905@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marino Dzalto <marino.dzalto@gmail.com>

[ Upstream commit 24bd5c2679caf8a228d90cafa221da4b47fd6642 ]

Add pr_fmt to prefix log messages with the module name for
easier debugging in dmesg.

Add checkentry functions for IPv4 (ttl_mt_check) and IPv6
(hl_mt6_check) to validate the match mode at rule registration
time, rejecting invalid modes with -EINVAL.

The evaluation function returns false in case the mode is
unknown, so this is a cleanup, not a bug fix.

Signed-off-by: Marino Dzalto <marino.dzalto@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Stable-dep-of: 793d9eda4821 ("netfilter: x_tables: replace pr_{info,err}() by pr_info_ratelimited()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/xt_hl.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/net/netfilter/xt_hl.c b/net/netfilter/xt_hl.c
index c1a70f8f04417..4a12a757ecbf8 100644
--- a/net/netfilter/xt_hl.c
+++ b/net/netfilter/xt_hl.c
@@ -6,6 +6,7 @@
  * Hop Limit matching module
  * (C) 2001-2002 Maciej Soltysiak <solt@dns.toxicfilms.tv>
  */
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/ip.h>
 #include <linux/ipv6.h>
@@ -22,6 +23,18 @@ MODULE_LICENSE("GPL");
 MODULE_ALIAS("ipt_ttl");
 MODULE_ALIAS("ip6t_hl");
 
+static int ttl_mt_check(const struct xt_mtchk_param *par)
+{
+	const struct ipt_ttl_info *info = par->matchinfo;
+
+	if (info->mode > IPT_TTL_GT) {
+		pr_err("Unknown TTL match mode: %d\n", info->mode);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 static bool ttl_mt(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	const struct ipt_ttl_info *info = par->matchinfo;
@@ -41,6 +54,18 @@ static bool ttl_mt(const struct sk_buff *skb, struct xt_action_param *par)
 	return false;
 }
 
+static int hl_mt6_check(const struct xt_mtchk_param *par)
+{
+	const struct ip6t_hl_info *info = par->matchinfo;
+
+	if (info->mode > IP6T_HL_GT) {
+		pr_err("Unknown Hop Limit match mode: %d\n", info->mode);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 static bool hl_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	const struct ip6t_hl_info *info = par->matchinfo;
@@ -65,6 +90,7 @@ static struct xt_match hl_mt_reg[] __read_mostly = {
 		.name       = "ttl",
 		.revision   = 0,
 		.family     = NFPROTO_IPV4,
+		.checkentry = ttl_mt_check,
 		.match      = ttl_mt,
 		.matchsize  = sizeof(struct ipt_ttl_info),
 		.me         = THIS_MODULE,
@@ -73,6 +99,7 @@ static struct xt_match hl_mt_reg[] __read_mostly = {
 		.name       = "hl",
 		.revision   = 0,
 		.family     = NFPROTO_IPV6,
+		.checkentry = hl_mt6_check,
 		.match      = hl_mt6,
 		.matchsize  = sizeof(struct ip6t_hl_info),
 		.me         = THIS_MODULE,
-- 
2.53.0



