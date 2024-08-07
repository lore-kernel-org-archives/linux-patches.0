Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7DDD52F62;
	Wed,  7 Aug 2024 15:15:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043750; cv=none; b=J0FNQndywKQm73JIcxBaKkjYangqRolSZEuG6ksomPEmR9k7GVLXiRkkINbQ87xiFHCW3t4ODG8iMbOSZtRDDCLlwfe/PZpVV+o6avoLu1CGFvaWVdWoQ7a83Sm1RTd5vjlKXXabCy2upmIp+1ih5283j5sfRPEeX4F67uA89BY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043750; c=relaxed/simple;
	bh=846lUJ+rO/bDq47+6KdkTH0J9SQB8roi9vpy6lBdFLE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B7XeDtsr8ubO7D7rx76lU1kKcI6/BA9Jn5taIKQkD/FurPE2Kor7jXoyz0DFbonTDSjX4kLE5PPeOtb5PMVUgTqixEG9K7YI574gIcrl7Fvx2wNLoGla+VOoIwnrWFpnr/sELVgf2DSNV0ctlHUfbndxCPoyCdO/8WJL0pJiL74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IjLX3Xah; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IjLX3Xah"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58E2EC32781;
	Wed,  7 Aug 2024 15:15:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043750;
	bh=846lUJ+rO/bDq47+6KdkTH0J9SQB8roi9vpy6lBdFLE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IjLX3XahrNuz4dpItRd/otBqVoN7HR6k0qwxaoHmM5YL9AyE6Aye71CqUSP06BY0W
	 MB1ZAZlo2pQq1MeWkp21y9dqavPVF2n0v6qRtCZKfjsqI8Bd3hdMYieB2pG5CzwhbY
	 qYGm34MvRKrSW+Gcxhvhosnb/+U2nBEa50C4L5Fw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 59/86] netfilter: iptables: Fix potential null-ptr-deref in ip6table_nat_table_init().
Date: Wed,  7 Aug 2024 17:00:38 +0200
Message-ID: <20240807150041.199776081@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150039.247123516@linuxfoundation.org>
References: <20240807150039.247123516@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit c22921df777de5606f1047b1345b8d22ef1c0b34 ]

ip6table_nat_table_init() accesses net->gen->ptr[ip6table_nat_net_ops.id],
but the function is exposed to user space before the entry is allocated
via register_pernet_subsys().

Let's call register_pernet_subsys() before xt_register_template().

Fixes: fdacd57c79b7 ("netfilter: x_tables: never register tables by default")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Reviewed-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/netfilter/ip6table_nat.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/net/ipv6/netfilter/ip6table_nat.c b/net/ipv6/netfilter/ip6table_nat.c
index bf3cb3a13600c..52d597b16b658 100644
--- a/net/ipv6/netfilter/ip6table_nat.c
+++ b/net/ipv6/netfilter/ip6table_nat.c
@@ -147,23 +147,27 @@ static struct pernet_operations ip6table_nat_net_ops = {
 
 static int __init ip6table_nat_init(void)
 {
-	int ret = xt_register_template(&nf_nat_ipv6_table,
-				       ip6table_nat_table_init);
+	int ret;
 
+	/* net->gen->ptr[ip6table_nat_net_id] must be allocated
+	 * before calling ip6t_nat_register_lookups().
+	 */
+	ret = register_pernet_subsys(&ip6table_nat_net_ops);
 	if (ret < 0)
 		return ret;
 
-	ret = register_pernet_subsys(&ip6table_nat_net_ops);
+	ret = xt_register_template(&nf_nat_ipv6_table,
+				   ip6table_nat_table_init);
 	if (ret)
-		xt_unregister_template(&nf_nat_ipv6_table);
+		unregister_pernet_subsys(&ip6table_nat_net_ops);
 
 	return ret;
 }
 
 static void __exit ip6table_nat_exit(void)
 {
-	unregister_pernet_subsys(&ip6table_nat_net_ops);
 	xt_unregister_template(&nf_nat_ipv6_table);
+	unregister_pernet_subsys(&ip6table_nat_net_ops);
 }
 
 module_init(ip6table_nat_init);
-- 
2.43.0



