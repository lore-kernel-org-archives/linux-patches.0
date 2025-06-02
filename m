Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 275FA2222AA;
	Mon,  2 Jun 2025 14:16:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873817; cv=none; b=ZzfC5tKBWzRGv0dXmbEhwlVRRB8liPXgGSV4ROzAqLdxORrs/++W1UEmj0woRa4+QBO3oA1jEYM2pSCo9KpusAZNWN6KfuwGxWEIzVrzfUxaKN6vHSDmXh2KkCwjQKMWIDJs5/7l+Xq1m+cLizU4nyV0dOkflfoQavQ/GNix1PU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873817; c=relaxed/simple;
	bh=5qQwLaYwOtEaFd4MkZS3bpkHi96KiqXjRXX6LvFjk30=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nqqfceDeN8hpepG93HY729IwMek0u/hNz3jVB1PsshHjqWUZVXzwHiGQBqCV9WYXjWZoCS3D22N1kEyrAGzBugB8f4Krusvkmlp4TmjRCI4zkPcpNMC5ADXtEkp1I9Nh/NliKMRVRYkpnhZdip+K5ADTX4kSzSTx3EElHo2JB80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L2A/0dIV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L2A/0dIV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99A21C4CEEB;
	Mon,  2 Jun 2025 14:16:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873817;
	bh=5qQwLaYwOtEaFd4MkZS3bpkHi96KiqXjRXX6LvFjk30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L2A/0dIVy8jm8Ji34VyLp3t3dsBfBb66jhHhHy/TjIGnb05asasBu439vSehLur04
	 GlabzxsLdlnlrpM1RJ55cQQESJontD3OjCVzhhuL1mP/d+FpEFMvaz6x0omlXlzqGe
	 sEI9RlOKa9aJO7mbVlDKvf1+jTsgvSGT4ucaltls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Eric Dumazet <edumazet@google.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 262/444] ip: fib_rules: Fetch net from fib_rule in fib[46]_rule_configure().
Date: Mon,  2 Jun 2025 15:45:26 +0200
Message-ID: <20250602134351.566309480@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 513f475c6a534..298a9944a3d1e 100644
--- a/net/ipv4/fib_rules.c
+++ b/net/ipv4/fib_rules.c
@@ -222,9 +222,9 @@ static int fib4_rule_configure(struct fib_rule *rule, struct sk_buff *skb,
 			       struct nlattr **tb,
 			       struct netlink_ext_ack *extack)
 {
-	struct net *net = sock_net(skb->sk);
+	struct fib4_rule *rule4 = (struct fib4_rule *)rule;
+	struct net *net = rule->fr_net;
 	int err = -EINVAL;
-	struct fib4_rule *rule4 = (struct fib4_rule *) rule;
 
 	if (!inet_validate_dscp(frh->tos)) {
 		NL_SET_ERR_MSG(extack,
diff --git a/net/ipv6/fib6_rules.c b/net/ipv6/fib6_rules.c
index 6eeab21512ba9..e0f0c5f8cccda 100644
--- a/net/ipv6/fib6_rules.c
+++ b/net/ipv6/fib6_rules.c
@@ -350,9 +350,9 @@ static int fib6_rule_configure(struct fib_rule *rule, struct sk_buff *skb,
 			       struct nlattr **tb,
 			       struct netlink_ext_ack *extack)
 {
+	struct fib6_rule *rule6 = (struct fib6_rule *)rule;
+	struct net *net = rule->fr_net;
 	int err = -EINVAL;
-	struct net *net = sock_net(skb->sk);
-	struct fib6_rule *rule6 = (struct fib6_rule *) rule;
 
 	if (!inet_validate_dscp(frh->tos)) {
 		NL_SET_ERR_MSG(extack,
-- 
2.39.5



