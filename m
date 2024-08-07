Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ECBA78C67;
	Wed,  7 Aug 2024 15:10:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043410; cv=none; b=sJn8Dt3FQgoAUFXPdYGIPGG09aVfEjrlNBAMzypXlm/OUyqouJV0Ly8xSVSwNb8M9f9Rlx16nupte4a/i/uEODxyOavIppLiOr3usAGjcSzTthRViz9mhY5NqDoBy4LWFLD9V9gUjrh+Z1Y4LF05p8UDkn5klhpinO9PXnCovQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043410; c=relaxed/simple;
	bh=0DuonC+rV4jztOgSAN46PyJumSBCWpUnNjik1B4kglY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MwFfg8lyAmxnQhTJ28ieywH17s+OWlb4y8x1XO8qUtjf8/bekWr4CRdwU89wP7o7WUGezitc4f6BHUGH8w3Ponu0dF/wdmHlCR8pe20rn0IsaGXMbmCT+Od5nCMxhZvUu007qrpDOzKAUepxgli+lUnfaSpAnftaVCieQQJ/5bo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=THorCcLD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="THorCcLD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 025BDC32781;
	Wed,  7 Aug 2024 15:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043410;
	bh=0DuonC+rV4jztOgSAN46PyJumSBCWpUnNjik1B4kglY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=THorCcLD3TkYqydrU6vlN3Veaj//ca+MTgGVY5WkIpzlvToTGb0ZSh8gg890E18Xc
	 lVjdAJ9hhX56blxVFOXPlFmsAuw5sMjp12VwRu+ylSAmuSEBTEfhdovEXhi1VLy927
	 zSSAjTiDnFE2QphDp2lkm05s+z/plAk+j7WCkFmM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 079/121] netfilter: iptables: Fix potential null-ptr-deref in ip6table_nat_table_init().
Date: Wed,  7 Aug 2024 17:00:11 +0200
Message-ID: <20240807150022.000226236@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150019.412911622@linuxfoundation.org>
References: <20240807150019.412911622@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



