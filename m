Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD8491E520A;
	Wed, 19 Feb 2025 08:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954726; cv=none; b=SD0WaPPOXTz5tu8gIWo1mtocTC0Z95mpwFGW+ZdTrNq/voLkhQDgc2V/iCZvDnnxYCEOEdyeyTO4+kDRo5NvzHjjsof7uNO+a3uirPaqIb75QQEPfGj9wwH9pShD++GFNieNVAh2GYuL0Dw3T/WD7lcGYPE+fE2m34xQAlaU448=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954726; c=relaxed/simple;
	bh=GZs81haMnQ/Kveh7Z9QAlOWh3A61jZ/tvoE02RbK78I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hPi2M/gxsk5d1z44vqep0uxfOJi57LaibS6ZP0dvGH2omKbaklS8KS5o9VSn5AUFlJR7l0JsLoPVWtLXpM6N1wxc6wOfNgwUAKoo2wof1HJ9aZjZegFVRPd21kcxx82qd8CMzVVDDfeIJiP/7qrqd3DcVZU+yq02qg5dTuGuArs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qDYsIMYf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qDYsIMYf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C26AC4CED1;
	Wed, 19 Feb 2025 08:45:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954726;
	bh=GZs81haMnQ/Kveh7Z9QAlOWh3A61jZ/tvoE02RbK78I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qDYsIMYfCKzfJv26joVxfLwdBPqoe9+d/zhrsZ+zr6THVpu4j91FjQs3adRjyU/E8
	 Z9upCSWbe0FexOFBlrGRrofV3MTt1IJ7qThIBSD2CKNIBx8lTbUyRbFprdGVppRvMK
	 3Xs82qLi2gFcdSpCJ+Krrj10nqdCPaji4MpQOoT8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 017/230] net: fib_rules: annotate data-races around rule->[io]ifindex
Date: Wed, 19 Feb 2025 09:25:34 +0100
Message-ID: <20250219082602.375855774@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082601.683263930@linuxfoundation.org>
References: <20250219082601.683263930@linuxfoundation.org>
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
index 154a2681f55cc..388ff1d6d86b7 100644
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
@@ -260,12 +260,14 @@ static int fib_rule_match(struct fib_rule *rule, struct fib_rules_ops *ops,
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
@@ -1038,14 +1040,14 @@ static int fib_nl_fill_rule(struct sk_buff *skb, struct fib_rule *rule,
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
 
@@ -1217,10 +1219,10 @@ static void attach_rules(struct list_head *rules, struct net_device *dev)
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
 
@@ -1230,9 +1232,9 @@ static void detach_rules(struct list_head *rules, struct net_device *dev)
 
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



