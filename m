Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E6FB36405A;
	Wed, 20 May 2026 17:45:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299147; cv=none; b=iOlLJi9us2zs0ot2jMk8AhKJNsegWMti6XoQGKr1cd8WBQBH2qy5MvhMKlWI83H0PspKdM/wWXlDGsVE4rffDsOIzVS7DZRz7VymIHjBqS6OnElKpPeaPJIN3sfx8OswHC8OwhVpsxkegGUg9w8VNK2Fq7PI+m0og6L/P1Md7aI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299147; c=relaxed/simple;
	bh=xjOM/lIWGCwBLRL7InaXATkjsXfhMV9j7q766tBQCZg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ebFGUy4vSr+lAGB9/kZvysiah12Y7xcMsK/Lpy8+Hp6qvQQmg+O1q4TrQgvkbUvvh2V9CcA+5WSLI72y52VgK1cblRKjhv3mtPt2wb0Hosk4mZthYPmLyUf36vmiWN6ci8yXgSacotnA3ngBVsfZNR4pQKx1WJw7/FN/wj6nO20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gfWMGSMf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gfWMGSMf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C9F51F000E9;
	Wed, 20 May 2026 17:45:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299146;
	bh=wi7gL2glDnmnYYsDqpazFzFqZMa1cQ1MVoyFTR+RYKI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gfWMGSMfqMq9x/i8n+7oA73yz9K/CY+AdPNnt7GMj9EQ+ylL/QNIbaZKeT37mrK09
	 vgB2L07JBgxoL09UMvA/riEWQH160l6qaUZ5dtmsluSZnDs7I9KFxETnDrolqv5YqE
	 0ifc0eK47DwhSauOyawXE2b/h2bBzPraOnfrWwpg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Kito Xu (veritas501)" <hxzene@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 663/957] netfilter: xtables: restrict several matches to inet family
Date: Wed, 20 May 2026 18:19:06 +0200
Message-ID: <20260520162148.910518875@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 343e65f377d44..130842c35c6fa 100644
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



