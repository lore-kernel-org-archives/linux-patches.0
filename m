Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44D75222582;
	Mon,  2 Jun 2025 14:33:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874837; cv=none; b=uCRTfW5mHOOieNqKi5Wx85ppZOXCf5IDYwIJ+fQmew/le5Hxm3oWcmKgjmhsFstMk99kVgG2YE7uR3uUQW7xiYbTahBMquGqCbIT4eWM1gwlySVxG9JT6Zl5zOqcQpQTcyMwcydV1jpEkOdIDkM8HHr9tDoZLaS79/T8WF0xX9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874837; c=relaxed/simple;
	bh=0ItAvp/pFRDvhTJww2cTKE8FlATJDu9pHtDMiKJYxB4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nGZqdfz/zi7No07APuJDuutpCcl2bFeV4BCdSl+4k+MYGYmTaiCmXeY/U2BOVD/Zf/7DIrPskdbOKTwSxf+ZoIMlbg+TAQtZWGo86nd1p+5Tbh+y8su+7HykXVXhG5CDQs2W6BQohgFZ+lRaFVsV+tLQ04YRvTM65cTON8bRDQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bpal1tfn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bpal1tfn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2100C4CEEB;
	Mon,  2 Jun 2025 14:33:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874837;
	bh=0ItAvp/pFRDvhTJww2cTKE8FlATJDu9pHtDMiKJYxB4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bpal1tfn2tbt2bYdXBivK+i9GXH6FUPCktW2Yj7jxXSaJltALba+iWCvh2XLzHrRB
	 CuGHrBUwV92XpG6DzNH50WZEbN1M32lAB8LV9VvX2Zd809tQ4ilQhdB6Vg7CjyAR6I
	 mfFpJj5eSos9dzhv+Dj8aVh27Hh3bAqTMM9kymYk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Eric Dumazet <edumazet@google.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 152/204] ip: fib_rules: Fetch net from fib_rule in fib[46]_rule_configure().
Date: Mon,  2 Jun 2025 15:48:05 +0200
Message-ID: <20250602134301.622146156@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134255.449974357@linuxfoundation.org>
References: <20250602134255.449974357@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit 5a1ccffd30a08f5a2428cd5fbb3ab03e8eb6c66d ]

The following patch will not set skb->sk from VRF path.

Let's fetch net from fib_rule->fr_net instead of sock_net(skb->sk)
in fib[46]_rule_configure().

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Tested-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20250207072502.87775-5-kuniyu@amazon.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/fib_rules.c  | 4 ++--
 net/ipv6/fib6_rules.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/fib_rules.c b/net/ipv4/fib_rules.c
index e9a3cc9e98dfa..1617ea18fae3a 100644
--- a/net/ipv4/fib_rules.c
+++ b/net/ipv4/fib_rules.c
@@ -220,9 +220,9 @@ static int fib4_rule_configure(struct fib_rule *rule, struct sk_buff *skb,
 			       struct nlattr **tb,
 			       struct netlink_ext_ack *extack)
 {
-	struct net *net = sock_net(skb->sk);
+	struct fib4_rule *rule4 = (struct fib4_rule *)rule;
+	struct net *net = rule->fr_net;
 	int err = -EINVAL;
-	struct fib4_rule *rule4 = (struct fib4_rule *) rule;
 
 	if (frh->tos & ~IPTOS_TOS_MASK) {
 		NL_SET_ERR_MSG(extack, "Invalid tos");
diff --git a/net/ipv6/fib6_rules.c b/net/ipv6/fib6_rules.c
index 3cf9dc2231036..acb8610c9a9df 100644
--- a/net/ipv6/fib6_rules.c
+++ b/net/ipv6/fib6_rules.c
@@ -344,9 +344,9 @@ static int fib6_rule_configure(struct fib_rule *rule, struct sk_buff *skb,
 			       struct nlattr **tb,
 			       struct netlink_ext_ack *extack)
 {
+	struct fib6_rule *rule6 = (struct fib6_rule *)rule;
+	struct net *net = rule->fr_net;
 	int err = -EINVAL;
-	struct net *net = sock_net(skb->sk);
-	struct fib6_rule *rule6 = (struct fib6_rule *) rule;
 
 	if (rule->action == FR_ACT_TO_TBL && !rule->l3mdev) {
 		if (rule->table == RT6_TABLE_UNSPEC) {
-- 
2.39.5



