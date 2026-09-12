Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E661A26ED46;
	Sat, 12 Sep 2026 19:20:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789240803; cv=none; b=HpIbBlFqaJXmv96sh3sVbnjfWxrhU2kQ/R4UMTbhJczqcprEyxp9C7KSyHockeFWJ2F0R4YgK1IvBGQ1J5SVunc7MOONZclO4tKiaFHTW+xOyQwb00MSXzYpL9ZgR12epnkWUtR6UGu3KHQfDH4az2T1ywQSvJ7eD9Rb7/EznU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789240803; c=relaxed/simple;
	bh=mTw1Plmsb2KbMq8juf0Fs4ykEoB6ttsmDmwDK/8ZMT0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MRs5Yvifhc5NWw3sTVXJ/UZ3yWosrv49yV+P6OdyAeDaI6NyKoJs44PDbDpR+V2Rc8OHpNKMO5kH9aA1W2U4P3N/1wzfwhtlb/9m0bebcXGBx5JOcrm8XU6aSuig5R//nPzUlKAvD/7sjxrhnqj0rBESYPCBeurLUkhfuqa2CaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gh+TwLpX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gh+TwLpX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D78BC1F000FF;
	Sat, 12 Sep 2026 19:20:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789240801;
	bh=a0tuWZh9r8Ve8g53XuiH/htG8J+xBl+jmrGPG8R2CwY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gh+TwLpXVd7RRDjty+Nhxp0ZQEGZa/Q3f6qke8EbmtDBv9XNu5/XRVBdU6pr7QzcI
	 ha4grS9SqUj6OT/tNfGqrhPOGxOoE3GgOxZ+c7ck+twe9XmsmGMlJtj6AWlCtIi3HA
	 w6KgWIzRai4xjWDF0PN+h3txxrSenFtaM8mv6gRM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marino Dzalto <marino.dzalto@gmail.com>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 911/935] netfilter: xt_HL: add pr_fmt and checkentry validation
Date: Sat, 12 Sep 2026 09:05:41 +0200
Message-ID: <20260912065547.711353781@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



