Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AC2A3AF656;
	Sat, 12 Sep 2026 20:04:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789243506; cv=none; b=GAle6fGK4qm3CR6OWTJLQk2ZmTWqm7wkwYBgiu/tG9ZgpwaPCOK/FptySv9f+VwOMeq/+n4PrEjSQ7tWbMJSo89uASfl5SAccouu8cK5RiS23e22afpHMNsJ8ivJ5W61wBOFGDLzuqXY/f61OOmqYj3XaI5anDpVIzi/hozqmpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789243506; c=relaxed/simple;
	bh=YVxMqb4y1oMO3X/E9tJIL/uS5NMVCsBCjoHIiUmjFU8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pGb914dn9yHla/hF3i5W4Z7QlUW9SIyFotyoPNub5uJBaRn0R5rsQurug2NTCmAEdarBtkN3+uGDTBhxLRyfDUKYrBjAaEu+m1RkskiJCqWK1jBJzRywzb+MYizp/IeRFM1MYco2YYWaRtqWhxtDpl+qkZQuymNUJfEmoS8yyBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RG74Tih4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RG74Tih4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E8F31F00893;
	Sat, 12 Sep 2026 20:04:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789243498;
	bh=G662vVChKUY1wU2N32YLOi7NDB4KKBShKc/xyB0FefQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RG74Tih4tYof2q7ZaL6CqbXRj35vhC2CSAjKCMa5Gbo6bmRZvM3Tdnc7U8/1nbj9G
	 iHww/l5ebqiCp9cmbtxrbyDaBQtUzyj1AgzfARDe77GosyEROa5fresTfn5KfpngA8
	 580GT/3WNE/f+mftrt62GEv4SnXZMYpD738x4pJ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marino Dzalto <marino.dzalto@gmail.com>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 775/798] netfilter: xt_HL: add pr_fmt and checkentry validation
Date: Sat, 12 Sep 2026 09:06:43 +0200
Message-ID: <20260912065534.832008615@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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



