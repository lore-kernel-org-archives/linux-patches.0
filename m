Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBA2486334;
	Sat, 30 May 2026 18:46:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780166762; cv=none; b=Dmwxyn12vvNF1bcWQvJ5pMjUvCROcTHt5JoUg89I9uqNylZD7170hEgG74TqUspFf6+LNQ5tv57LJqBCjYLyFQX5tOXu4MNBAxGSLU94BDHc7onK23yUm4GIhpJh1GZdifUYy4bS7kWhWPesn89ucqqrW3UkiusZGujx1Xwhu/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780166762; c=relaxed/simple;
	bh=NJok882ATDhLILX0xtltPPbgroHfDSZZzurjRj5kmyU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g1kVcnQ2uEvw26YYMeyTAM2mJYagGoODwpozwO7FfNmwOYDCbJbEHZpRoj84sMpdLigEBaUAowyj3maMT6WcAh81TdHp/FHxJfdjURzCSFQF7MCjMGWWeeiBmadWw6ZkuD6gw1LKZkFoMXHEZK0HOh6xSN/zMIp/kR7CEDJ7sZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RJdJeKmR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RJdJeKmR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 404A21F00893;
	Sat, 30 May 2026 18:46:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780166760;
	bh=IuXXcgq9P+4XVkKQGjHIUiLajs5pSr9SuXiPQ1kqRhY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RJdJeKmRTeDxcc7Bz/j6tl7lHsovjd/VQEK+gwTOSlp6nD8rnbZPTHP57lWCdwL1u
	 zEhR4gwbrKc6q71fDR5ZJl3oSxgSADYzq/5nomBQoewPInx/GOw+Ug29X1tLDInA1n
	 d+vRDfamjOsmxAHuvfDsN2xKQOnXF31rhgxQuTXo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Kito Xu (veritas501)" <hxzene@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 436/589] netfilter: xtables: restrict several matches to inet family
Date: Sat, 30 May 2026 18:05:17 +0200
Message-ID: <20260530160236.173735545@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit b6fe26f86a1649f84e057f3f15605b08eda15497 ]

This is a partial revert of:

  commit ab4f21e6fb1c ("netfilter: xtables: use NFPROTO_UNSPEC in more extensions")

to allow ipv4 and ipv6 only.

- xt_mac
- xt_owner
- xt_physdev

These extensions are not used by ebtables in userspace.

Moreover, xt_realm is only for ipv4, since dst->tclassid is ipv4
specific.

Fixes: ab4f21e6fb1c ("netfilter: xtables: use NFPROTO_UNSPEC in more extensions")
Reported-by: "Kito Xu (veritas501)" <hxzene@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/xt_mac.c     | 34 +++++++++++++++++++++++-----------
 net/netfilter/xt_owner.c   | 37 +++++++++++++++++++++++++------------
 net/netfilter/xt_physdev.c | 29 +++++++++++++++++++----------
 net/netfilter/xt_realm.c   |  2 +-
 4 files changed, 68 insertions(+), 34 deletions(-)

diff --git a/net/netfilter/xt_mac.c b/net/netfilter/xt_mac.c
index 81649da57ba5d..bd2354760895d 100644
--- a/net/netfilter/xt_mac.c
+++ b/net/netfilter/xt_mac.c
@@ -38,25 +38,37 @@ static bool mac_mt(const struct sk_buff *skb, struct xt_action_param *par)
 	return ret;
 }
 
-static struct xt_match mac_mt_reg __read_mostly = {
-	.name      = "mac",
-	.revision  = 0,
-	.family    = NFPROTO_UNSPEC,
-	.match     = mac_mt,
-	.matchsize = sizeof(struct xt_mac_info),
-	.hooks     = (1 << NF_INET_PRE_ROUTING) | (1 << NF_INET_LOCAL_IN) |
-	             (1 << NF_INET_FORWARD),
-	.me        = THIS_MODULE,
+static struct xt_match mac_mt_reg[] __read_mostly = {
+	{
+		.name		= "mac",
+		.family		= NFPROTO_IPV4,
+		.match		= mac_mt,
+		.matchsize	= sizeof(struct xt_mac_info),
+		.hooks		= (1 << NF_INET_PRE_ROUTING) |
+				  (1 << NF_INET_LOCAL_IN) |
+				  (1 << NF_INET_FORWARD),
+		.me		= THIS_MODULE,
+	},
+	{
+		.name		= "mac",
+		.family		= NFPROTO_IPV6,
+		.match		= mac_mt,
+		.matchsize	= sizeof(struct xt_mac_info),
+		.hooks		= (1 << NF_INET_PRE_ROUTING) |
+				  (1 << NF_INET_LOCAL_IN) |
+				  (1 << NF_INET_FORWARD),
+		.me		= THIS_MODULE,
+	},
 };
 
 static int __init mac_mt_init(void)
 {
-	return xt_register_match(&mac_mt_reg);
+	return xt_register_matches(mac_mt_reg, ARRAY_SIZE(mac_mt_reg));
 }
 
 static void __exit mac_mt_exit(void)
 {
-	xt_unregister_match(&mac_mt_reg);
+	xt_unregister_matches(mac_mt_reg, ARRAY_SIZE(mac_mt_reg));
 }
 
 module_init(mac_mt_init);
diff --git a/net/netfilter/xt_owner.c b/net/netfilter/xt_owner.c
index 50332888c8d23..7be2fe22b067e 100644
--- a/net/netfilter/xt_owner.c
+++ b/net/netfilter/xt_owner.c
@@ -127,26 +127,39 @@ owner_mt(const struct sk_buff *skb, struct xt_action_param *par)
 	return true;
 }
 
-static struct xt_match owner_mt_reg __read_mostly = {
-	.name       = "owner",
-	.revision   = 1,
-	.family     = NFPROTO_UNSPEC,
-	.checkentry = owner_check,
-	.match      = owner_mt,
-	.matchsize  = sizeof(struct xt_owner_match_info),
-	.hooks      = (1 << NF_INET_LOCAL_OUT) |
-	              (1 << NF_INET_POST_ROUTING),
-	.me         = THIS_MODULE,
+static struct xt_match owner_mt_reg[] __read_mostly = {
+	{
+		.name       = "owner",
+		.revision   = 1,
+		.family     = NFPROTO_IPV4,
+		.checkentry = owner_check,
+		.match      = owner_mt,
+		.matchsize  = sizeof(struct xt_owner_match_info),
+		.hooks      = (1 << NF_INET_LOCAL_OUT) |
+			      (1 << NF_INET_POST_ROUTING),
+		.me         = THIS_MODULE,
+	},
+	{
+		.name       = "owner",
+		.revision   = 1,
+		.family     = NFPROTO_IPV6,
+		.checkentry = owner_check,
+		.match      = owner_mt,
+		.matchsize  = sizeof(struct xt_owner_match_info),
+		.hooks      = (1 << NF_INET_LOCAL_OUT) |
+			      (1 << NF_INET_POST_ROUTING),
+		.me         = THIS_MODULE,
+	}
 };
 
 static int __init owner_mt_init(void)
 {
-	return xt_register_match(&owner_mt_reg);
+	return xt_register_matches(owner_mt_reg, ARRAY_SIZE(owner_mt_reg));
 }
 
 static void __exit owner_mt_exit(void)
 {
-	xt_unregister_match(&owner_mt_reg);
+	xt_unregister_matches(owner_mt_reg, ARRAY_SIZE(owner_mt_reg));
 }
 
 module_init(owner_mt_init);
diff --git a/net/netfilter/xt_physdev.c b/net/netfilter/xt_physdev.c
index ec6ed6fda96c5..6a596878d611f 100644
--- a/net/netfilter/xt_physdev.c
+++ b/net/netfilter/xt_physdev.c
@@ -115,24 +115,33 @@ static int physdev_mt_check(const struct xt_mtchk_param *par)
 	return 0;
 }
 
-static struct xt_match physdev_mt_reg __read_mostly = {
-	.name       = "physdev",
-	.revision   = 0,
-	.family     = NFPROTO_UNSPEC,
-	.checkentry = physdev_mt_check,
-	.match      = physdev_mt,
-	.matchsize  = sizeof(struct xt_physdev_info),
-	.me         = THIS_MODULE,
+static struct xt_match physdev_mt_reg[] __read_mostly = {
+	{
+		.name		= "physdev",
+		.family		= NFPROTO_IPV4,
+		.checkentry	= physdev_mt_check,
+		.match		= physdev_mt,
+		.matchsize	= sizeof(struct xt_physdev_info),
+		.me		= THIS_MODULE,
+	},
+	{
+		.name		= "physdev",
+		.family		= NFPROTO_IPV6,
+		.checkentry	= physdev_mt_check,
+		.match		= physdev_mt,
+		.matchsize	= sizeof(struct xt_physdev_info),
+		.me		= THIS_MODULE,
+	},
 };
 
 static int __init physdev_mt_init(void)
 {
-	return xt_register_match(&physdev_mt_reg);
+	return xt_register_matches(physdev_mt_reg, ARRAY_SIZE(physdev_mt_reg));
 }
 
 static void __exit physdev_mt_exit(void)
 {
-	xt_unregister_match(&physdev_mt_reg);
+	xt_unregister_matches(physdev_mt_reg, ARRAY_SIZE(physdev_mt_reg));
 }
 
 module_init(physdev_mt_init);
diff --git a/net/netfilter/xt_realm.c b/net/netfilter/xt_realm.c
index 6df485f4403d0..61b2f1e58d150 100644
--- a/net/netfilter/xt_realm.c
+++ b/net/netfilter/xt_realm.c
@@ -33,7 +33,7 @@ static struct xt_match realm_mt_reg __read_mostly = {
 	.matchsize	= sizeof(struct xt_realm_info),
 	.hooks		= (1 << NF_INET_POST_ROUTING) | (1 << NF_INET_FORWARD) |
 			  (1 << NF_INET_LOCAL_OUT) | (1 << NF_INET_LOCAL_IN),
-	.family		= NFPROTO_UNSPEC,
+	.family		= NFPROTO_IPV4,
 	.me		= THIS_MODULE
 };
 
-- 
2.53.0



