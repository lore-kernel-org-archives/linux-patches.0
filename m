Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9957C2F260C;
	Thu, 28 May 2026 20:50:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780001410; cv=none; b=A4VJFac0I9joUxikEJQD41tusO8uysWyKvo/KpHDvEOzQlWl38/n3UNTm+oorvzF5E/wFKjANKYAn77DRr5EsF5xC8WilAmR96DDd4lmQslDkB03WcdHqc+dFUcNZ2WjZH2M/eL93vn470QJ4uI1d6rfYj6VDhSS5gViBhAcWWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780001410; c=relaxed/simple;
	bh=T4JG8L2thWyXyWScwk5xAM4wc3qZkbsTy5p0IO1j19g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q9706FeUSIuZg/986vYi16ZzdFoKFo0Gjk1q0K+EuoxDFG39CdOaMW9gVTdJUooTd0JB7zl3MWhrKrg9hR6A8/4aBsWi3VMFwKI22LZyEyjh3Sy1LE2kLkuMph/pXyiO8WzTIor5BKGYKL4+3vX2+g5Wv2XAtbyyxh1nErNwlyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yP2FlPdN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yP2FlPdN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD11B1F000E9;
	Thu, 28 May 2026 20:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780001409;
	bh=fCLAtwWCTuI0UhZdHPOcOl+KTcTAlrU30UhY7avebMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yP2FlPdNKhBB8Y4SaerLYkaJFQHm5aKrUclNitb5XKHz7jGf1YarmI8wmlCZeLTz2
	 z8UY8WyDmBizuF8avD7nn/7nE3DriOj9o80zgSe3RsI0jdOA2dTNVuLN/5H1vfoDxZ
	 EGdVlTWoTpu306GK0s1uEJ0Rmdu1TNWyVYVh0Dvw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 118/186] netfilter: x_tables: close dangling table module init race
Date: Thu, 28 May 2026 21:49:58 +0200
Message-ID: <20260528194932.128812598@linuxfoundation.org>
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
index fb85745793ba5..409e96c72164b 100644
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
index 6259bcf178bba..b8618bdf5fdc4 100644
--- a/net/ipv4/netfilter/iptable_mangle.c
+++ b/net/ipv4/netfilter/iptable_mangle.c
@@ -110,25 +110,26 @@ static struct pernet_operations iptable_mangle_net_ops = {
 
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
index c7b91b2042dc6..94ad7fad3a1f3 100644
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
index 982900920e730..f444071346859 100644
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
index 475361aa81310..dbc64e4428403 100644
--- a/net/ipv6/netfilter/ip6table_mangle.c
+++ b/net/ipv6/netfilter/ip6table_mangle.c
@@ -103,25 +103,26 @@ static struct pernet_operations ip6table_mangle_net_ops = {
 
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
index a99879f173b4a..1eadf553c746e 100644
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



