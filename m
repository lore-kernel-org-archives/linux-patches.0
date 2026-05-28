Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75CD62139C9;
	Thu, 28 May 2026 20:40:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000801; cv=none; b=rHXyD6PoQnEAE97nBfbWX22c3S2jGbqrQ0h9336ObSpcb7zmTaREIk1YHM9DrhgaSTjozlFj/wpwwP54LWmo1Cn68fct6OIrZyHgwCb14BM380S8Ry7d6BwL3nYQFPGRSmgmOt8zo06RYTr/PkzfEZYC9We4xED4divrMxwuoio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000801; c=relaxed/simple;
	bh=QME2yA/AsDVM2vtPtyNPcNmG/BJxjw5uHfOoyw7uioY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bke3Iayz3V0/IuPV43Euy4IjFATZEnC6+BRaYd8XV6rpD3lupUhnkPOqQOJlc0OrUmQw2EQPCkEyizHv16FVOXP+mgyqgLhop5bh269R/Zw2v0QlLpQIV2ceq7wRmrrP/c1EdYPb1xiWG0HaDA81dOCIs0GVyetylE3QF9/wb8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1HVrO3jM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1HVrO3jM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D191C1F00A3A;
	Thu, 28 May 2026 20:39:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000800;
	bh=tFo6e8LinZa7dlvaosiUF5Oi7neDUAMf/jwtBmm/TZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1HVrO3jMG61ISN41DUMLbqYay6LTFIfGJUm0IpJpcJ5R3UTysN5f8LjZ+qakP/v4/
	 C+SP4wNzRwG47u3qKki4jwowDr1mTbPmQAgBQt9I4tisfNSXVD11sHFwmutoUhjDl1
	 MfCqXcsPImVR+OaheDsY6KtaNHoP2E6WHw+W/d4I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tristan Madani <tristan@talencesecurity.com>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 166/272] netfilter: x_tables: unregister the templates first
Date: Thu, 28 May 2026 21:49:00 +0200
Message-ID: <20260528194633.979486930@linuxfoundation.org>
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
index 3ab908b747951..595bfb492b1c1 100644
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
index 385d945d8ebea..db90db7057cc4 100644
--- a/net/ipv4/netfilter/iptable_mangle.c
+++ b/net/ipv4/netfilter/iptable_mangle.c
@@ -135,8 +135,8 @@ static int __init iptable_mangle_init(void)
 
 static void __exit iptable_mangle_fini(void)
 {
-	unregister_pernet_subsys(&iptable_mangle_net_ops);
 	xt_unregister_template(&packet_mangler);
+	unregister_pernet_subsys(&iptable_mangle_net_ops);
 	kfree(mangle_ops);
 }
 
diff --git a/net/ipv4/netfilter/iptable_raw.c b/net/ipv4/netfilter/iptable_raw.c
index 0e7f53964d0af..b46a790917306 100644
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
index e8992693e14a0..9dcd4501fe800 100644
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
index 8dd4cd0c47bd4..ce2cbce9e3ed3 100644
--- a/net/ipv6/netfilter/ip6table_mangle.c
+++ b/net/ipv6/netfilter/ip6table_mangle.c
@@ -128,8 +128,8 @@ static int __init ip6table_mangle_init(void)
 
 static void __exit ip6table_mangle_fini(void)
 {
-	unregister_pernet_subsys(&ip6table_mangle_net_ops);
 	xt_unregister_template(&packet_mangler);
+	unregister_pernet_subsys(&ip6table_mangle_net_ops);
 	kfree(mangle_ops);
 }
 
diff --git a/net/ipv6/netfilter/ip6table_raw.c b/net/ipv6/netfilter/ip6table_raw.c
index fc9f6754028f2..8af0f8bd036dc 100644
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



