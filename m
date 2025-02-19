Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 779701C5D56;
	Wed, 19 Feb 2025 08:30:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739953859; cv=none; b=C6xbqDjI0SU19rz2blG/heeGgi24/M/jAYRLqav8KRrdoBLnpxLoy+ktcQ7szzzsdDQ7OD8Iwelh0ACugnskQ6e7XadI75au210BlOdQw3i9KUGCX2zevetTzPBuIjg+KEJrXNTQ4Yqvs0RnUi/++1J4HWlj2GzmK4ec6fwkP/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739953859; c=relaxed/simple;
	bh=APBwybGDeqAgKwE0G0KzpUvxl/AyZKu+Vt4w8yU0BNs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WYLQ3HDw8fj2+Lom68AtPwqbPtbb2XpjA+nxdqTet5YEfWDXmIirQtJb55siZ3n0eilluboMroVfov7bJ8TEI9ALONCw1+d7QDdFhWwDYAOC7Ckp1Afw45re2xfWnReG5snPpU3rMJBzXaIlWmdPDzkPAXtMjI1kTshF+4bbKtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uMwC8P15; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uMwC8P15"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F126C4CED1;
	Wed, 19 Feb 2025 08:30:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739953859;
	bh=APBwybGDeqAgKwE0G0KzpUvxl/AyZKu+Vt4w8yU0BNs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uMwC8P15WEBPlUc9gWNfd+Mo/0Sq5IwnEnxPnFyayWGbURml/gnVo11eO4Mukgkwt
	 XzSlJfwrhFtE1Cabx+/frMivCAt3LEeXnsIUq7zIM7Ni7JyWs5bXuxqszeM8wWYAIl
	 VQecxU4iKi7WpVYdBOpj/oGzkaRANjCSg3hOOevQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 020/274] net: fib_rules: annotate data-races around rule->[io]ifindex
Date: Wed, 19 Feb 2025 09:24:34 +0100
Message-ID: <20250219082610.330366400@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit cb827db50a88aebec516151681adb6db10b688ee ]

rule->iifindex and rule->oifindex can be read without holding RTNL.

Add READ_ONCE()/WRITE_ONCE() annotations where needed.

Fixes: 32affa5578f0 ("fib: rules: no longer hold RTNL in fib_nl_dumprule()")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20250206083051.2494877-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/fib_rules.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/net/core/fib_rules.c b/net/core/fib_rules.c
index 34185d138c95a..ff1cebd71f7b4 100644
--- a/net/core/fib_rules.c
+++ b/net/core/fib_rules.c
@@ -37,8 +37,8 @@ static const struct fib_kuid_range fib_kuid_range_unset = {
 
 bool fib_rule_matchall(const struct fib_rule *rule)
 {
-	if (rule->iifindex || rule->oifindex || rule->mark || rule->tun_id ||
-	    rule->flags)
+	if (READ_ONCE(rule->iifindex) || READ_ONCE(rule->oifindex) ||
+	    rule->mark || rule->tun_id || rule->flags)
 		return false;
 	if (rule->suppress_ifgroup != -1 || rule->suppress_prefixlen != -1)
 		return false;
@@ -261,12 +261,14 @@ static int fib_rule_match(struct fib_rule *rule, struct fib_rules_ops *ops,
 			  struct flowi *fl, int flags,
 			  struct fib_lookup_arg *arg)
 {
-	int ret = 0;
+	int iifindex, oifindex, ret = 0;
 
-	if (rule->iifindex && (rule->iifindex != fl->flowi_iif))
+	iifindex = READ_ONCE(rule->iifindex);
+	if (iifindex && (iifindex != fl->flowi_iif))
 		goto out;
 
-	if (rule->oifindex && (rule->oifindex != fl->flowi_oif))
+	oifindex = READ_ONCE(rule->oifindex);
+	if (oifindex && (oifindex != fl->flowi_oif))
 		goto out;
 
 	if ((rule->mark ^ fl->flowi_mark) & rule->mark_mask)
@@ -1039,14 +1041,14 @@ static int fib_nl_fill_rule(struct sk_buff *skb, struct fib_rule *rule,
 	if (rule->iifname[0]) {
 		if (nla_put_string(skb, FRA_IIFNAME, rule->iifname))
 			goto nla_put_failure;
-		if (rule->iifindex == -1)
+		if (READ_ONCE(rule->iifindex) == -1)
 			frh->flags |= FIB_RULE_IIF_DETACHED;
 	}
 
 	if (rule->oifname[0]) {
 		if (nla_put_string(skb, FRA_OIFNAME, rule->oifname))
 			goto nla_put_failure;
-		if (rule->oifindex == -1)
+		if (READ_ONCE(rule->oifindex) == -1)
 			frh->flags |= FIB_RULE_OIF_DETACHED;
 	}
 
@@ -1218,10 +1220,10 @@ static void attach_rules(struct list_head *rules, struct net_device *dev)
 	list_for_each_entry(rule, rules, list) {
 		if (rule->iifindex == -1 &&
 		    strcmp(dev->name, rule->iifname) == 0)
-			rule->iifindex = dev->ifindex;
+			WRITE_ONCE(rule->iifindex, dev->ifindex);
 		if (rule->oifindex == -1 &&
 		    strcmp(dev->name, rule->oifname) == 0)
-			rule->oifindex = dev->ifindex;
+			WRITE_ONCE(rule->oifindex, dev->ifindex);
 	}
 }
 
@@ -1231,9 +1233,9 @@ static void detach_rules(struct list_head *rules, struct net_device *dev)
 
 	list_for_each_entry(rule, rules, list) {
 		if (rule->iifindex == dev->ifindex)
-			rule->iifindex = -1;
+			WRITE_ONCE(rule->iifindex, -1);
 		if (rule->oifindex == dev->ifindex)
-			rule->oifindex = -1;
+			WRITE_ONCE(rule->oifindex, -1);
 	}
 }
 
-- 
2.39.5



