Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A28332E92BA;
	Thu, 28 May 2026 20:49:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780001399; cv=none; b=pEkiOr3fmLUNJ2wjFTxwIO0zUXVgKkHcuMYHLt3ffTU44u8bsp/gbvDlNwHc4KWzw2yDEgsDnuFhXezcLFQ93GP50oky5ej18hUcdwlQD4GU5bi+crQ7pGjXRa1s4z+hXH2iZZD0+A9eC/xUsaXJ1yXGNOq/7V8HjE9+6E1k4uA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780001399; c=relaxed/simple;
	bh=LqclcAgRTk4uMSxqVTpjnclwARmNgK8bBERTnbxi03c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bZMBf75zM9M+cGgjLDE7yF0wpp+cBGHLFRRWmYueSnHnihEYvwTrLJE/1WpBgC3RQguctr3zGbbR1qw+BNG62rkytXB1hI6AisYrVxiPznFZbUqWxAkR9LQCC2EhYPiWnVR9hJ1MFfG3KUurhusqLXrF8rFaHv9HSKOnrCfWUys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=or+RzqDh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="or+RzqDh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C9CB1F000E9;
	Thu, 28 May 2026 20:49:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780001398;
	bh=5AeMfFxSg/m//21FJyZhwRvrKMx5R3BLj2xlYQK6jaE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=or+RzqDhw3hedYHoYBGslcOZ40UaEd0ON0m0Wr/zxDeDfq4wfVdsKXwrCjPvYKVed
	 K20R3iPgNxOKMN71uJ1LpEuCrIm71di33RPhpTiWaYz2Mih4X2AK3Rk22w758EJTNf
	 NKBKTqd0A+bYYHm8hhm+qWT+DqtizwT/cSa+iZzY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tristan Madani <tristan@talencesecurity.com>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 106/186] netfilter: x_tables: unregister the templates first
Date: Thu, 28 May 2026 21:49:46 +0200
Message-ID: <20260528194931.799287653@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194928.941004471@linuxfoundation.org>
References: <20260528194928.941004471@linuxfoundation.org>
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

From: Florian Westphal <fw@strlen.de>

[ Upstream commit d338693d778579b676a61346849bebd892427158 ]

When the module is going away we need to zap the template
first.  Else there is a small race window where userspace
could instantiate a new table after the pernet exit function
has removed the current table.

Fixes: fdacd57c79b7 ("netfilter: x_tables: never register tables by default")
Reported-by: Tristan Madani <tristan@talencesecurity.com>
Reviewed-by: Tristan Madani <tristan@talencesecurity.com>
Closes: https://lore.kernel.org/netfilter-devel/20260429175613.1459342-1-tristmd@gmail.com/
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/netfilter/arptable_filter.c   | 2 +-
 net/ipv4/netfilter/iptable_filter.c    | 2 +-
 net/ipv4/netfilter/iptable_mangle.c    | 2 +-
 net/ipv4/netfilter/iptable_raw.c       | 2 +-
 net/ipv4/netfilter/iptable_security.c  | 2 +-
 net/ipv6/netfilter/ip6table_filter.c   | 2 +-
 net/ipv6/netfilter/ip6table_mangle.c   | 2 +-
 net/ipv6/netfilter/ip6table_raw.c      | 2 +-
 net/ipv6/netfilter/ip6table_security.c | 2 +-
 9 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/net/ipv4/netfilter/arptable_filter.c b/net/ipv4/netfilter/arptable_filter.c
index 78cd5ee24448f..359d00d74095b 100644
--- a/net/ipv4/netfilter/arptable_filter.c
+++ b/net/ipv4/netfilter/arptable_filter.c
@@ -82,8 +82,8 @@ static int __init arptable_filter_init(void)
 
 static void __exit arptable_filter_fini(void)
 {
-	unregister_pernet_subsys(&arptable_filter_net_ops);
 	xt_unregister_template(&packet_filter);
+	unregister_pernet_subsys(&arptable_filter_net_ops);
 	kfree(arpfilter_ops);
 }
 
diff --git a/net/ipv4/netfilter/iptable_filter.c b/net/ipv4/netfilter/iptable_filter.c
index b9062f4552ace..c03c1a4ea7cab 100644
--- a/net/ipv4/netfilter/iptable_filter.c
+++ b/net/ipv4/netfilter/iptable_filter.c
@@ -101,8 +101,8 @@ static int __init iptable_filter_init(void)
 
 static void __exit iptable_filter_fini(void)
 {
-	unregister_pernet_subsys(&iptable_filter_net_ops);
 	xt_unregister_template(&packet_filter);
+	unregister_pernet_subsys(&iptable_filter_net_ops);
 	kfree(filter_ops);
 }
 
diff --git a/net/ipv4/netfilter/iptable_mangle.c b/net/ipv4/netfilter/iptable_mangle.c
index 3abb430af9e6f..6a51e61b35562 100644
--- a/net/ipv4/netfilter/iptable_mangle.c
+++ b/net/ipv4/netfilter/iptable_mangle.c
@@ -134,8 +134,8 @@ static int __init iptable_mangle_init(void)
 
 static void __exit iptable_mangle_fini(void)
 {
-	unregister_pernet_subsys(&iptable_mangle_net_ops);
 	xt_unregister_template(&packet_mangler);
+	unregister_pernet_subsys(&iptable_mangle_net_ops);
 	kfree(mangle_ops);
 }
 
diff --git a/net/ipv4/netfilter/iptable_raw.c b/net/ipv4/netfilter/iptable_raw.c
index ca5e5b21587cd..33330e13ea18d 100644
--- a/net/ipv4/netfilter/iptable_raw.c
+++ b/net/ipv4/netfilter/iptable_raw.c
@@ -100,9 +100,9 @@ static int __init iptable_raw_init(void)
 
 static void __exit iptable_raw_fini(void)
 {
+	xt_unregister_template(&packet_raw);
 	unregister_pernet_subsys(&iptable_raw_net_ops);
 	kfree(rawtable_ops);
-	xt_unregister_template(&packet_raw);
 }
 
 module_init(iptable_raw_init);
diff --git a/net/ipv4/netfilter/iptable_security.c b/net/ipv4/netfilter/iptable_security.c
index d885443cb2679..2b89adc1e5751 100644
--- a/net/ipv4/netfilter/iptable_security.c
+++ b/net/ipv4/netfilter/iptable_security.c
@@ -89,9 +89,9 @@ static int __init iptable_security_init(void)
 
 static void __exit iptable_security_fini(void)
 {
+	xt_unregister_template(&security_table);
 	unregister_pernet_subsys(&iptable_security_net_ops);
 	kfree(sectbl_ops);
-	xt_unregister_template(&security_table);
 }
 
 module_init(iptable_security_init);
diff --git a/net/ipv6/netfilter/ip6table_filter.c b/net/ipv6/netfilter/ip6table_filter.c
index df785ebda0ca4..16a38d56b2e54 100644
--- a/net/ipv6/netfilter/ip6table_filter.c
+++ b/net/ipv6/netfilter/ip6table_filter.c
@@ -100,8 +100,8 @@ static int __init ip6table_filter_init(void)
 
 static void __exit ip6table_filter_fini(void)
 {
-	unregister_pernet_subsys(&ip6table_filter_net_ops);
 	xt_unregister_template(&packet_filter);
+	unregister_pernet_subsys(&ip6table_filter_net_ops);
 	kfree(filter_ops);
 }
 
diff --git a/net/ipv6/netfilter/ip6table_mangle.c b/net/ipv6/netfilter/ip6table_mangle.c
index a88b2ce4a3cb8..39f0716667131 100644
--- a/net/ipv6/netfilter/ip6table_mangle.c
+++ b/net/ipv6/netfilter/ip6table_mangle.c
@@ -127,8 +127,8 @@ static int __init ip6table_mangle_init(void)
 
 static void __exit ip6table_mangle_fini(void)
 {
-	unregister_pernet_subsys(&ip6table_mangle_net_ops);
 	xt_unregister_template(&packet_mangler);
+	unregister_pernet_subsys(&ip6table_mangle_net_ops);
 	kfree(mangle_ops);
 }
 
diff --git a/net/ipv6/netfilter/ip6table_raw.c b/net/ipv6/netfilter/ip6table_raw.c
index 08861d5d1f4db..01def8aa7a2e8 100644
--- a/net/ipv6/netfilter/ip6table_raw.c
+++ b/net/ipv6/netfilter/ip6table_raw.c
@@ -98,8 +98,8 @@ static int __init ip6table_raw_init(void)
 
 static void __exit ip6table_raw_fini(void)
 {
-	unregister_pernet_subsys(&ip6table_raw_net_ops);
 	xt_unregister_template(&packet_raw);
+	unregister_pernet_subsys(&ip6table_raw_net_ops);
 	kfree(rawtable_ops);
 }
 
diff --git a/net/ipv6/netfilter/ip6table_security.c b/net/ipv6/netfilter/ip6table_security.c
index 4df14a9bae782..66018b169b010 100644
--- a/net/ipv6/netfilter/ip6table_security.c
+++ b/net/ipv6/netfilter/ip6table_security.c
@@ -88,8 +88,8 @@ static int __init ip6table_security_init(void)
 
 static void __exit ip6table_security_fini(void)
 {
-	unregister_pernet_subsys(&ip6table_security_net_ops);
 	xt_unregister_template(&security_table);
+	unregister_pernet_subsys(&ip6table_security_net_ops);
 	kfree(sectbl_ops);
 }
 
-- 
2.53.0



