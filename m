Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B743F385D7B;
	Sat, 17 Oct 2026 17:42:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258939; cv=none; b=T51M8LXngu2ki7rUuQQHuabPVhAzDfXBYhpgqITDrteGfsNT/7mjMtT/VqpgDX6KsfVzWnaphf4vc2W7f5lfQKiIjcuJGU8Wwm2bAQUtYSecFxhbZfdzPOR6PCDJyUKx6rWDSLwnqLbHBmEO/klUeFHTMQ/xVXMI7UKDNDv/d+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258939; c=relaxed/simple;
	bh=dNxKqg4kX3UxdXK/VHNL04ZbdLQ5RXcIip1+bZH+sqA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gn+zspqMgsONsYx6y7AIx3IA37H3gJ1bc2s2R6aXDKl2pQ8MhdDT+O+IbZh0JgkR9JToVeHHUXggQs4wwxUCh1pERR5V07434WGfQ03I4i0fQIw3t8pxPF5OFo7eICDqLAe5u97UfajeCI3ZHWWeez0z82qSTK5HuXdGuuVDTjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Weg2hZJ+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Weg2hZJ+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E91F61F000C4;
	Sat, 17 Oct 2026 17:42:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258938;
	bh=m/6fsG8ZM0Jqkg75F8B9hEt5odlDS7BEoMBHuaotEHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Weg2hZJ+wMW91gqa0lFEq/ks9Zfc0PJFrqWbE/JOqHUZxMug46Qt+yvvdg98yCy3v
	 Opg3bkepZAg8D9qQ9EtIjmSCtY4P0mpgSFluniJAcx7dQjHpNSwMAnaUXs77SVGm0U
	 AfMWt7iHNyyrDyJ2uDelQiV+VC8eTcvpDKQBspVA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yan Zhen <yanzhen@vivo.com>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1048/1674] netfilter: Use kmemdup_array instead of kmemdup for multiple allocation
Date: Sat, 17 Oct 2026 17:55:20 +0200
Message-ID: <20261017160458.032685978@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Yan Zhen <yanzhen@vivo.com>

[ Upstream commit 20eb5e7cb78c331107fbdf2f77a30fbea9338638 ]

When we are allocating an array, using kmemdup_array() to take care about
multiplication and possible overflows.

Also it makes auditing the code easier.

Signed-off-by: Yan Zhen <yanzhen@vivo.com>
Reviewed-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Stable-dep-of: b62eb8dcf2c4 ("netfilter: x_tables: allocate hook ops while under mutex")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/netfilter/ebtables.c | 2 +-
 net/ipv4/netfilter/arp_tables.c | 2 +-
 net/ipv4/netfilter/ip_tables.c  | 2 +-
 net/ipv6/netfilter/ip6_tables.c | 2 +-
 net/netfilter/nf_nat_core.c     | 2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index b1846d5c879a5..b5db2d08e0068 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -1254,7 +1254,7 @@ int ebt_register_table(struct net *net, const struct ebt_table *input_table,
 		goto free_unlock;
 	}
 
-	ops = kmemdup(template_ops, sizeof(*ops) * num_ops, GFP_KERNEL);
+	ops = kmemdup_array(template_ops, num_ops, sizeof(*ops), GFP_KERNEL);
 	if (!ops) {
 		ret = -ENOMEM;
 		if (newinfo->nentries)
diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index eeb48265208a2..8442bc26beac2 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -1556,7 +1556,7 @@ int arpt_register_table(struct net *net,
 		goto out_free;
 	}
 
-	ops = kmemdup(template_ops, sizeof(*ops) * num_ops, GFP_KERNEL);
+	ops = kmemdup_array(template_ops, num_ops, sizeof(*ops), GFP_KERNEL);
 	if (!ops) {
 		ret = -ENOMEM;
 		goto out_free;
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 74840604e8d96..96b9f133f4ae6 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -1764,7 +1764,7 @@ int ipt_register_table(struct net *net, const struct xt_table *table,
 		goto out_free;
 	}
 
-	ops = kmemdup(template_ops, sizeof(*ops) * num_ops, GFP_KERNEL);
+	ops = kmemdup_array(template_ops, num_ops, sizeof(*ops), GFP_KERNEL);
 	if (!ops) {
 		ret = -ENOMEM;
 		goto out_free;
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 3f08d4600d696..f4e01f451d576 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -1775,7 +1775,7 @@ int ip6t_register_table(struct net *net, const struct xt_table *table,
 		goto out_free;
 	}
 
-	ops = kmemdup(template_ops, sizeof(*ops) * num_ops, GFP_KERNEL);
+	ops = kmemdup_array(template_ops, num_ops, sizeof(*ops), GFP_KERNEL);
 	if (!ops) {
 		ret = -ENOMEM;
 		goto out_free;
diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index d604e21c8e0bb..649dede4ace05 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -1234,7 +1234,7 @@ int nf_nat_register_fn(struct net *net, u8 pf, const struct nf_hook_ops *ops,
 	if (!nat_proto_net->nat_hook_ops) {
 		WARN_ON(nat_proto_net->users != 0);
 
-		nat_ops = kmemdup(orig_nat_ops, sizeof(*orig_nat_ops) * ops_count, GFP_KERNEL);
+		nat_ops = kmemdup_array(orig_nat_ops, ops_count, sizeof(*orig_nat_ops), GFP_KERNEL);
 		if (!nat_ops) {
 			mutex_unlock(&nf_nat_proto_mutex);
 			return -ENOMEM;
-- 
2.53.0



