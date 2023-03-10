Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3899A882B
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 15:12:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0DE5C433EF;
	Fri, 10 Mar 2023 15:12:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678461152;
	bh=kFhom9tstDaUfz4DZMqFmvSOos+W3hXwIi8ad4njL/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ov81LonjpbRoPnKU8AMt8XWUKOjOS2VN4ceXVTCwavsTxtYJozOMt7HJyG0J12doo
	 cfyLAoTF1uHwJDqtF3QzP4LOKotyE7+gDkL8ZSQXNg0iywt9jipjKE7QbRILXgMcSi
	 lwK3GDJ08gsy/1j4IQjRpWnsfeMmN0u/8iwACm1I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 043/136] netfilter: x_tables: fix percpu counter block leak on error path when creating new netns
Date: Fri, 10 Mar 2023 14:42:45 +0100
Message-Id: <20230310133708.378166675@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133706.811226272@linuxfoundation.org>
References: <20230310133706.811226272@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>

[ Upstream commit 0af8c09c896810879387decfba8c942994bb61f5 ]

Here is the stack where we allocate percpu counter block:

  +-< __alloc_percpu
    +-< xt_percpu_counter_alloc
      +-< find_check_entry # {arp,ip,ip6}_tables.c
        +-< translate_table

And it can be leaked on this code path:

  +-> ip6t_register_table
    +-> translate_table # allocates percpu counter block
    +-> xt_register_table # fails

there is no freeing of the counter block on xt_register_table fail.
Note: xt_percpu_counter_free should be called to free it like we do in
do_replace through cleanup_entry helper (or in __ip6t_unregister_table).

Probability of hitting this error path is low AFAICS (xt_register_table
can only return ENOMEM here, as it is not replacing anything, as we are
creating new netns, and it is hard to imagine that all previous
allocations succeeded and after that one in xt_register_table failed).
But it's worth fixing even the rare leak.

Fixes: 71ae0dff02d7 ("netfilter: xtables: use percpu rule counters")
Signed-off-by: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/netfilter/arp_tables.c | 4 ++++
 net/ipv4/netfilter/ip_tables.c  | 4 ++++
 net/ipv6/netfilter/ip6_tables.c | 4 ++++
 3 files changed, 12 insertions(+)

diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index c53f14b943560..71bf3aeed73c1 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -1524,6 +1524,10 @@ int arpt_register_table(struct net *net,
 
 	new_table = xt_register_table(net, table, &bootstrap, newinfo);
 	if (IS_ERR(new_table)) {
+		struct arpt_entry *iter;
+
+		xt_entry_foreach(iter, loc_cpu_entry, newinfo->size)
+			cleanup_entry(iter, net);
 		xt_free_table_info(newinfo);
 		return PTR_ERR(new_table);
 	}
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 91301dc3924a2..a748a1e754605 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -1740,6 +1740,10 @@ int ipt_register_table(struct net *net, const struct xt_table *table,
 
 	new_table = xt_register_table(net, table, &bootstrap, newinfo);
 	if (IS_ERR(new_table)) {
+		struct ipt_entry *iter;
+
+		xt_entry_foreach(iter, loc_cpu_entry, newinfo->size)
+			cleanup_entry(iter, net);
 		xt_free_table_info(newinfo);
 		return PTR_ERR(new_table);
 	}
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 7ba68388d2e1f..277a5ee887eb3 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -1750,6 +1750,10 @@ int ip6t_register_table(struct net *net, const struct xt_table *table,
 
 	new_table = xt_register_table(net, table, &bootstrap, newinfo);
 	if (IS_ERR(new_table)) {
+		struct ip6t_entry *iter;
+
+		xt_entry_foreach(iter, loc_cpu_entry, newinfo->size)
+			cleanup_entry(iter, net);
 		xt_free_table_info(newinfo);
 		return PTR_ERR(new_table);
 	}
-- 
2.39.2



