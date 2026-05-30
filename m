Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43995233D9E;
	Sat, 30 May 2026 18:17:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165030; cv=none; b=ZutVsuHKW+Av8+m7ncms4TungU8hRHJ5Fuq+KgAW5Pqs7Y3YQ/nke5QJdwvWEHjAtk6RgL8zHckEkNKnfQdwUfAtEO0KuHK16tmZ3+1KUdhdJHCFx9qLwp+zTi4LxCwc24mp62eIk2XLJkzRxe+SXstTRJSa9/yXwA36+AyW0/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165030; c=relaxed/simple;
	bh=JZQ6qM3fVDnMRAZf+T2m+an5c0fVTdQkm+e4t/TaqmA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OLqwnOVKW2tql8oZnxzpdzpokyMsV5E9KoxtmRiPv2T0vgEtS8E+Iw333yTpUx6laotdvSXZwA3gFbAp/l1vCnSNoiDh218jI5PoAj86cPw60yjZ0so91bujcs4xzdW2kIUZaaKSPlak7wnfuhatweovZnD4dO9aIdwYew2ME9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S7jtZiuL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S7jtZiuL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EBF01F00893;
	Sat, 30 May 2026 18:17:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165028;
	bh=sF8fZoCxlv9F4AtBNnBUw2e6tK35olnSsMU23Rq6R8g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S7jtZiuLSCuPvGgExGsBZWXRtoJptYs9JUQXAnmiOuHQAj4V/uQ/N3IoX+E767L/T
	 w3TXY4ggnDPxxtkiZLUy6nWsaQ5fdsTc6o5DkYyAJewwi5SvheV2V2LhFnRELOSBhC
	 evS/CCGsn6h9c/5Rc2f4ovmyePr1c8KK7pI3N4S8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tristan Madani <tristan@talencesecurity.com>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 730/776] netfilter: x_tables: unregister the templates first
Date: Sat, 30 May 2026 18:07:24 +0200
Message-ID: <20260530160258.685448919@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 3de78416ec762..771eec4629352 100644
--- a/net/ipv4/netfilter/arptable_filter.c
+++ b/net/ipv4/netfilter/arptable_filter.c
@@ -90,8 +90,8 @@ static int __init arptable_filter_init(void)
 
 static void __exit arptable_filter_fini(void)
 {
-	unregister_pernet_subsys(&arptable_filter_net_ops);
 	xt_unregister_template(&packet_filter);
+	unregister_pernet_subsys(&arptable_filter_net_ops);
 	kfree(arpfilter_ops);
 }
 
diff --git a/net/ipv4/netfilter/iptable_filter.c b/net/ipv4/netfilter/iptable_filter.c
index 0eb0e2ab9bfc4..9155c5b5318d7 100644
--- a/net/ipv4/netfilter/iptable_filter.c
+++ b/net/ipv4/netfilter/iptable_filter.c
@@ -108,8 +108,8 @@ static int __init iptable_filter_init(void)
 
 static void __exit iptable_filter_fini(void)
 {
-	unregister_pernet_subsys(&iptable_filter_net_ops);
 	xt_unregister_template(&packet_filter);
+	unregister_pernet_subsys(&iptable_filter_net_ops);
 	kfree(filter_ops);
 }
 
diff --git a/net/ipv4/netfilter/iptable_mangle.c b/net/ipv4/netfilter/iptable_mangle.c
index 40417a3f930b2..f2997709c08b1 100644
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
index 8265c67657053..4749ecc9a416d 100644
--- a/net/ipv4/netfilter/iptable_raw.c
+++ b/net/ipv4/netfilter/iptable_raw.c
@@ -108,9 +108,9 @@ static int __init iptable_raw_init(void)
 
 static void __exit iptable_raw_fini(void)
 {
+	xt_unregister_template(&packet_raw);
 	unregister_pernet_subsys(&iptable_raw_net_ops);
 	kfree(rawtable_ops);
-	xt_unregister_template(&packet_raw);
 }
 
 module_init(iptable_raw_init);
diff --git a/net/ipv4/netfilter/iptable_security.c b/net/ipv4/netfilter/iptable_security.c
index f519162a2fa51..3e85be8cc9803 100644
--- a/net/ipv4/netfilter/iptable_security.c
+++ b/net/ipv4/netfilter/iptable_security.c
@@ -96,9 +96,9 @@ static int __init iptable_security_init(void)
 
 static void __exit iptable_security_fini(void)
 {
+	xt_unregister_template(&security_table);
 	unregister_pernet_subsys(&iptable_security_net_ops);
 	kfree(sectbl_ops);
-	xt_unregister_template(&security_table);
 }
 
 module_init(iptable_security_init);
diff --git a/net/ipv6/netfilter/ip6table_filter.c b/net/ipv6/netfilter/ip6table_filter.c
index 727ee80970124..477982fcc04ae 100644
--- a/net/ipv6/netfilter/ip6table_filter.c
+++ b/net/ipv6/netfilter/ip6table_filter.c
@@ -108,8 +108,8 @@ static int __init ip6table_filter_init(void)
 
 static void __exit ip6table_filter_fini(void)
 {
-	unregister_pernet_subsys(&ip6table_filter_net_ops);
 	xt_unregister_template(&packet_filter);
+	unregister_pernet_subsys(&ip6table_filter_net_ops);
 	kfree(filter_ops);
 }
 
diff --git a/net/ipv6/netfilter/ip6table_mangle.c b/net/ipv6/netfilter/ip6table_mangle.c
index 9b518ce37d6ae..bf062c01041ec 100644
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
index 4f2a04af71d32..6214c0b97f123 100644
--- a/net/ipv6/netfilter/ip6table_raw.c
+++ b/net/ipv6/netfilter/ip6table_raw.c
@@ -106,8 +106,8 @@ static int __init ip6table_raw_init(void)
 
 static void __exit ip6table_raw_fini(void)
 {
-	unregister_pernet_subsys(&ip6table_raw_net_ops);
 	xt_unregister_template(&packet_raw);
+	unregister_pernet_subsys(&ip6table_raw_net_ops);
 	kfree(rawtable_ops);
 }
 
diff --git a/net/ipv6/netfilter/ip6table_security.c b/net/ipv6/netfilter/ip6table_security.c
index 931674034d8be..36b62f848897a 100644
--- a/net/ipv6/netfilter/ip6table_security.c
+++ b/net/ipv6/netfilter/ip6table_security.c
@@ -95,8 +95,8 @@ static int __init ip6table_security_init(void)
 
 static void __exit ip6table_security_fini(void)
 {
-	unregister_pernet_subsys(&ip6table_security_net_ops);
 	xt_unregister_template(&security_table);
+	unregister_pernet_subsys(&ip6table_security_net_ops);
 	kfree(sectbl_ops);
 }
 
-- 
2.53.0



