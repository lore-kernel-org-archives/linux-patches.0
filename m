Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B79923396F4;
	Thu, 28 May 2026 20:41:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000902; cv=none; b=tUUjkirtCSBwRax23mboa7nInQHJ1kTUdclprrr4fCDBsOrlzIgbN5QDVs+2YV9NiIbJcIH17l7ZC4lvPLwXnQaGLeu7YOfFeCm+O1lU5QeMmfIAQxJtG9rI0EsVmZN6+B+KKZ3mlpZERwO8rm5JOfycQicPYyLvkX5aON3ujPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000902; c=relaxed/simple;
	bh=hWEhryPhEP66Oddty1L2t7QW1gU2zwkk0YgTYm4chxo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fBpgv2L4pUPe7TX1ulFr2NpxNGBXtGK9UHflsdbhhUfeMeyQMwvuyiNSd1XIIDwItP/FqSv86WnxuV7NkQrESLZNTei6IoQf9YbLkbL7wsaZQS96x5MtcdaQZGkmkkDf1iwfFL5pDyd5/FZZLBwKQu2gK+mV+BcP+7q6Z+rnf5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tr56EVvZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tr56EVvZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 225DE1F000E9;
	Thu, 28 May 2026 20:41:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000900;
	bh=KNif4xJsm8OeYqBr4Z26sC09WwIV5fcEyaZopIY1rs8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tr56EVvZTJBWLyevyz6KqnPlmTnuj/Ey4oyUIbUWTI2/juR/2tELbPspX/tjHQmpG
	 FWXw6LNrtXoYTJ9yibc37/0Lb/Jix+SB9LRrPH98i9G6uANqck/v8bp65sJiz7/bVf
	 4EOl6k7IpMkevVN2ykm9pBAhx7nS2O8x58niG/AQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 173/272] netfilter: x_tables: close dangling table module init race
Date: Thu, 28 May 2026 21:49:07 +0200
Message-ID: <20260528194634.160259574@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194629.379955525@linuxfoundation.org>
References: <20260528194629.379955525@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 16bc4b6686b2c112c10e67d6b493adc3607256d3 ]

Similar to the previous ebtables patch:
template add exposes the table to userspace, we must do this last to
rnsure the pernet ops are set up (contain the destructors).

Fixes: fdacd57c79b7 ("netfilter: x_tables: never register tables by default")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/netfilter/arptable_filter.c   | 23 ++++++++++++-----------
 net/ipv4/netfilter/iptable_filter.c    | 23 ++++++++++++-----------
 net/ipv4/netfilter/iptable_mangle.c    | 25 +++++++++++++------------
 net/ipv4/netfilter/iptable_raw.c       | 22 +++++++++++-----------
 net/ipv4/netfilter/iptable_security.c  | 23 ++++++++++++-----------
 net/ipv6/netfilter/ip6table_filter.c   | 22 +++++++++++-----------
 net/ipv6/netfilter/ip6table_mangle.c   | 23 ++++++++++++-----------
 net/ipv6/netfilter/ip6table_raw.c      | 20 ++++++++++----------
 net/ipv6/netfilter/ip6table_security.c | 23 ++++++++++++-----------
 9 files changed, 105 insertions(+), 99 deletions(-)

diff --git a/net/ipv4/netfilter/arptable_filter.c b/net/ipv4/netfilter/arptable_filter.c
index 382345567a600..370b635e3523b 100644
--- a/net/ipv4/netfilter/arptable_filter.c
+++ b/net/ipv4/netfilter/arptable_filter.c
@@ -58,25 +58,26 @@ static struct pernet_operations arptable_filter_net_ops = {
 
 static int __init arptable_filter_init(void)
 {
-	int ret = xt_register_template(&packet_filter,
-				       arptable_filter_table_init);
-
-	if (ret < 0)
-		return ret;
+	int ret;
 
 	arpfilter_ops = xt_hook_ops_alloc(&packet_filter, arpt_do_table);
-	if (IS_ERR(arpfilter_ops)) {
-		xt_unregister_template(&packet_filter);
+	if (IS_ERR(arpfilter_ops))
 		return PTR_ERR(arpfilter_ops);
-	}
 
 	ret = register_pernet_subsys(&arptable_filter_net_ops);
+	if (ret < 0)
+		goto err_free;
+
+	ret = xt_register_template(&packet_filter,
+				   arptable_filter_table_init);
 	if (ret < 0) {
-		xt_unregister_template(&packet_filter);
-		kfree(arpfilter_ops);
-		return ret;
+		unregister_pernet_subsys(&arptable_filter_net_ops);
+		goto err_free;
 	}
 
+	return 0;
+err_free:
+	kfree(arpfilter_ops);
 	return ret;
 }
 
diff --git a/net/ipv4/netfilter/iptable_filter.c b/net/ipv4/netfilter/iptable_filter.c
index 0dea754a91209..672d7da1071d3 100644
--- a/net/ipv4/netfilter/iptable_filter.c
+++ b/net/ipv4/netfilter/iptable_filter.c
@@ -77,26 +77,27 @@ static struct pernet_operations iptable_filter_net_ops = {
 
 static int __init iptable_filter_init(void)
 {
-	int ret = xt_register_template(&packet_filter,
-				       iptable_filter_table_init);
-
-	if (ret < 0)
-		return ret;
+	int ret;
 
 	filter_ops = xt_hook_ops_alloc(&packet_filter, ipt_do_table);
-	if (IS_ERR(filter_ops)) {
-		xt_unregister_template(&packet_filter);
+	if (IS_ERR(filter_ops))
 		return PTR_ERR(filter_ops);
-	}
 
 	ret = register_pernet_subsys(&iptable_filter_net_ops);
+	if (ret < 0)
+		goto err_free;
+
+	ret = xt_register_template(&packet_filter,
+				   iptable_filter_table_init);
 	if (ret < 0) {
-		xt_unregister_template(&packet_filter);
-		kfree(filter_ops);
-		return ret;
+		unregister_pernet_subsys(&iptable_filter_net_ops);
+		goto err_free;
 	}
 
 	return 0;
+err_free:
+	kfree(filter_ops);
+	return ret;
 }
 
 static void __exit iptable_filter_fini(void)
diff --git a/net/ipv4/netfilter/iptable_mangle.c b/net/ipv4/netfilter/iptable_mangle.c
index 4d3b124923080..13d25d9a4610e 100644
--- a/net/ipv4/netfilter/iptable_mangle.c
+++ b/net/ipv4/netfilter/iptable_mangle.c
@@ -111,25 +111,26 @@ static struct pernet_operations iptable_mangle_net_ops = {
 
 static int __init iptable_mangle_init(void)
 {
-	int ret = xt_register_template(&packet_mangler,
-				       iptable_mangle_table_init);
-	if (ret < 0)
-		return ret;
+	int ret;
 
 	mangle_ops = xt_hook_ops_alloc(&packet_mangler, iptable_mangle_hook);
-	if (IS_ERR(mangle_ops)) {
-		xt_unregister_template(&packet_mangler);
-		ret = PTR_ERR(mangle_ops);
-		return ret;
-	}
+	if (IS_ERR(mangle_ops))
+		return PTR_ERR(mangle_ops);
 
 	ret = register_pernet_subsys(&iptable_mangle_net_ops);
+	if (ret < 0)
+		goto err_free;
+
+	ret = xt_register_template(&packet_mangler,
+				   iptable_mangle_table_init);
 	if (ret < 0) {
-		xt_unregister_template(&packet_mangler);
-		kfree(mangle_ops);
-		return ret;
+		unregister_pernet_subsys(&iptable_mangle_net_ops);
+		goto err_free;
 	}
 
+	return 0;
+err_free:
+	kfree(mangle_ops);
 	return ret;
 }
 
diff --git a/net/ipv4/netfilter/iptable_raw.c b/net/ipv4/netfilter/iptable_raw.c
index 6f7afec7954bd..2745c22f4034d 100644
--- a/net/ipv4/netfilter/iptable_raw.c
+++ b/net/ipv4/netfilter/iptable_raw.c
@@ -77,24 +77,24 @@ static int __init iptable_raw_init(void)
 		pr_info("Enabling raw table before defrag\n");
 	}
 
-	ret = xt_register_template(table,
-				   iptable_raw_table_init);
-	if (ret < 0)
-		return ret;
-
 	rawtable_ops = xt_hook_ops_alloc(table, ipt_do_table);
-	if (IS_ERR(rawtable_ops)) {
-		xt_unregister_template(table);
+	if (IS_ERR(rawtable_ops))
 		return PTR_ERR(rawtable_ops);
-	}
 
 	ret = register_pernet_subsys(&iptable_raw_net_ops);
+	if (ret < 0)
+		goto err_free;
+
+	ret = xt_register_template(table,
+				   iptable_raw_table_init);
 	if (ret < 0) {
-		xt_unregister_template(table);
-		kfree(rawtable_ops);
-		return ret;
+		unregister_pernet_subsys(&iptable_raw_net_ops);
+		goto err_free;
 	}
 
+	return 0;
+err_free:
+	kfree(rawtable_ops);
 	return ret;
 }
 
diff --git a/net/ipv4/netfilter/iptable_security.c b/net/ipv4/netfilter/iptable_security.c
index 81175c20ccbe8..491894511c544 100644
--- a/net/ipv4/netfilter/iptable_security.c
+++ b/net/ipv4/netfilter/iptable_security.c
@@ -65,25 +65,26 @@ static struct pernet_operations iptable_security_net_ops = {
 
 static int __init iptable_security_init(void)
 {
-	int ret = xt_register_template(&security_table,
-				       iptable_security_table_init);
-
-	if (ret < 0)
-		return ret;
+	int ret;
 
 	sectbl_ops = xt_hook_ops_alloc(&security_table, ipt_do_table);
-	if (IS_ERR(sectbl_ops)) {
-		xt_unregister_template(&security_table);
+	if (IS_ERR(sectbl_ops))
 		return PTR_ERR(sectbl_ops);
-	}
 
 	ret = register_pernet_subsys(&iptable_security_net_ops);
+	if (ret < 0)
+		goto err_free;
+
+	ret = xt_register_template(&security_table,
+				   iptable_security_table_init);
 	if (ret < 0) {
-		xt_unregister_template(&security_table);
-		kfree(sectbl_ops);
-		return ret;
+		unregister_pernet_subsys(&iptable_security_net_ops);
+		goto err_free;
 	}
 
+	return 0;
+err_free:
+	kfree(sectbl_ops);
 	return ret;
 }
 
diff --git a/net/ipv6/netfilter/ip6table_filter.c b/net/ipv6/netfilter/ip6table_filter.c
index cf561919bde84..b074fc4776764 100644
--- a/net/ipv6/netfilter/ip6table_filter.c
+++ b/net/ipv6/netfilter/ip6table_filter.c
@@ -76,25 +76,25 @@ static struct pernet_operations ip6table_filter_net_ops = {
 
 static int __init ip6table_filter_init(void)
 {
-	int ret = xt_register_template(&packet_filter,
-					ip6table_filter_table_init);
-
-	if (ret < 0)
-		return ret;
+	int ret;
 
 	filter_ops = xt_hook_ops_alloc(&packet_filter, ip6t_do_table);
-	if (IS_ERR(filter_ops)) {
-		xt_unregister_template(&packet_filter);
+	if (IS_ERR(filter_ops))
 		return PTR_ERR(filter_ops);
-	}
 
 	ret = register_pernet_subsys(&ip6table_filter_net_ops);
+	if (ret < 0)
+		goto err_free;
+
+	ret = xt_register_template(&packet_filter, ip6table_filter_table_init);
 	if (ret < 0) {
-		xt_unregister_template(&packet_filter);
-		kfree(filter_ops);
-		return ret;
+		unregister_pernet_subsys(&ip6table_filter_net_ops);
+		goto err_free;
 	}
 
+	return 0;
+err_free:
+	kfree(filter_ops);
 	return ret;
 }
 
diff --git a/net/ipv6/netfilter/ip6table_mangle.c b/net/ipv6/netfilter/ip6table_mangle.c
index 1a758f2bc5379..e6ee036a9b2c5 100644
--- a/net/ipv6/netfilter/ip6table_mangle.c
+++ b/net/ipv6/netfilter/ip6table_mangle.c
@@ -104,25 +104,26 @@ static struct pernet_operations ip6table_mangle_net_ops = {
 
 static int __init ip6table_mangle_init(void)
 {
-	int ret = xt_register_template(&packet_mangler,
-				       ip6table_mangle_table_init);
-
-	if (ret < 0)
-		return ret;
+	int ret;
 
 	mangle_ops = xt_hook_ops_alloc(&packet_mangler, ip6table_mangle_hook);
-	if (IS_ERR(mangle_ops)) {
-		xt_unregister_template(&packet_mangler);
+	if (IS_ERR(mangle_ops))
 		return PTR_ERR(mangle_ops);
-	}
 
 	ret = register_pernet_subsys(&ip6table_mangle_net_ops);
+	if (ret < 0)
+		goto err_free;
+
+	ret = xt_register_template(&packet_mangler,
+				   ip6table_mangle_table_init);
 	if (ret < 0) {
-		xt_unregister_template(&packet_mangler);
-		kfree(mangle_ops);
-		return ret;
+		unregister_pernet_subsys(&ip6table_mangle_net_ops);
+		goto err_free;
 	}
 
+	return 0;
+err_free:
+	kfree(mangle_ops);
 	return ret;
 }
 
diff --git a/net/ipv6/netfilter/ip6table_raw.c b/net/ipv6/netfilter/ip6table_raw.c
index 923455921c1dd..3b161ee875bcc 100644
--- a/net/ipv6/netfilter/ip6table_raw.c
+++ b/net/ipv6/netfilter/ip6table_raw.c
@@ -75,24 +75,24 @@ static int __init ip6table_raw_init(void)
 		pr_info("Enabling raw table before defrag\n");
 	}
 
-	ret = xt_register_template(table, ip6table_raw_table_init);
-	if (ret < 0)
-		return ret;
-
 	/* Register hooks */
 	rawtable_ops = xt_hook_ops_alloc(table, ip6t_do_table);
-	if (IS_ERR(rawtable_ops)) {
-		xt_unregister_template(table);
+	if (IS_ERR(rawtable_ops))
 		return PTR_ERR(rawtable_ops);
-	}
 
 	ret = register_pernet_subsys(&ip6table_raw_net_ops);
+	if (ret < 0)
+		goto err_free;
+
+	ret = xt_register_template(table, ip6table_raw_table_init);
 	if (ret < 0) {
-		kfree(rawtable_ops);
-		xt_unregister_template(table);
-		return ret;
+		unregister_pernet_subsys(&ip6table_raw_net_ops);
+		goto err_free;
 	}
 
+	return 0;
+err_free:
+	kfree(rawtable_ops);
 	return ret;
 }
 
diff --git a/net/ipv6/netfilter/ip6table_security.c b/net/ipv6/netfilter/ip6table_security.c
index c44834d93fc79..4bd5d97b8ab65 100644
--- a/net/ipv6/netfilter/ip6table_security.c
+++ b/net/ipv6/netfilter/ip6table_security.c
@@ -64,25 +64,26 @@ static struct pernet_operations ip6table_security_net_ops = {
 
 static int __init ip6table_security_init(void)
 {
-	int ret = xt_register_template(&security_table,
-				       ip6table_security_table_init);
-
-	if (ret < 0)
-		return ret;
+	int ret;
 
 	sectbl_ops = xt_hook_ops_alloc(&security_table, ip6t_do_table);
-	if (IS_ERR(sectbl_ops)) {
-		xt_unregister_template(&security_table);
+	if (IS_ERR(sectbl_ops))
 		return PTR_ERR(sectbl_ops);
-	}
 
 	ret = register_pernet_subsys(&ip6table_security_net_ops);
+	if (ret < 0)
+		goto err_free;
+
+	ret = xt_register_template(&security_table,
+				   ip6table_security_table_init);
 	if (ret < 0) {
-		kfree(sectbl_ops);
-		xt_unregister_template(&security_table);
-		return ret;
+		unregister_pernet_subsys(&ip6table_security_net_ops);
+		goto err_free;
 	}
 
+	return 0;
+err_free:
+	kfree(sectbl_ops);
 	return ret;
 }
 
-- 
2.53.0



