Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 935FC78291;
	Wed,  7 Aug 2024 15:03:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043013; cv=none; b=GTEhrGnZI7gr967dQzp2zT508Su1aEeQ6U15h9goLhqZloqEQxbd2SyhTTtYkTpgUhRnCnkbBz9nq2a5XfKuU8dfv+n+/ecRO6NsBBq639oOuYlnMc98DMTNiqs6DuNZuFd7Cy5buhsXYwHHn9koFk+mj+3MNwG7UKaR0pZU7Ow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043013; c=relaxed/simple;
	bh=B3L4VzQqIcRzY902+byoKxRv95HvvH37xzx3l/B8Z7c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ChaYJV8zut3A44ciPDZMNPkcubtyBx5edFEMMMX4nryUOYP87CAzF7Ge01uL52TdMpK266pk925tT1VusC7SUHuDCsU+Y1WU2oWJVsNqgMQNY5ow5S7CS+FQykhnR7YgKzjaZaIbykP1N6rP/IX9fSS1Lu7f/HVn1xk/7vgCeHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J/DkZMS8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J/DkZMS8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEDD4C4AF0E;
	Wed,  7 Aug 2024 15:03:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043013;
	bh=B3L4VzQqIcRzY902+byoKxRv95HvvH37xzx3l/B8Z7c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J/DkZMS849L9vOt24POB2/ra2qwxYOkCpQ7xKBGgqSd8BWXM5g/SgL7oK2HGLR+5x
	 m7J8SqKz8elk1KkAzkuVG7Jm54EPSOKdzigYBlaQgCI6v4AzG1yMNXz5EYQwepeEwz
	 yt9ZhpB6+J9I/Bf0Lnt/zsUxO1jGnVXykh8VYaSw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 058/123] netfilter: iptables: Fix potential null-ptr-deref in ip6table_nat_table_init().
Date: Wed,  7 Aug 2024 16:59:37 +0200
Message-ID: <20240807150022.683383644@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150020.790615758@linuxfoundation.org>
References: <20240807150020.790615758@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index 52cf104e34788..e119d4f090cc8 100644
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



