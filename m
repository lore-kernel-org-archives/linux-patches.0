Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0039DE54A
	for <patches@lists.linux.dev>; Thu,  1 Jun 2023 13:24:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44CBBC433D2;
	Thu,  1 Jun 2023 13:24:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685625872;
	bh=kL/7YVwNXKNZSDU9ufknGWAWzer1ICGv/CRpvKg2Kts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pfCPok6FxFu+JBjmfedM5wX5bo3HzPn/2aqWy2fz4iV7BLk6CNAfdo32pOLTLuBeu
	 BBXWFPCNwemEFjenGik2PaUKU/2FxL6W1lQANaFhFx+TsREu5cd22ailXx6pTTc+nr
	 Lfut3Wv3veSHGKLMWYR3vOaAhkAi6MKNF0aQrpM8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liang Li <liali@redhat.com>,
	Hangbin Liu <liuhangbin@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 26/42] bonding: fix send_peer_notif overflow
Date: Thu,  1 Jun 2023 14:21:13 +0100
Message-Id: <20230601131937.887030491@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230601131936.699199833@linuxfoundation.org>
References: <20230601131936.699199833@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit 9949e2efb54eb3001cb2f6512ff3166dddbfb75d ]

Bonding send_peer_notif was defined as u8. Since commit 07a4ddec3ce9
("bonding: add an option to specify a delay between peer notifications").
the bond->send_peer_notif will be num_peer_notif multiplied by
peer_notif_delay, which is u8 * u32. This would cause the send_peer_notif
overflow easily. e.g.

  ip link add bond0 type bond mode 1 miimon 100 num_grat_arp 30 peer_notify_delay 1000

To fix the overflow, let's set the send_peer_notif to u32 and limit
peer_notif_delay to 300s.

Reported-by: Liang Li <liali@redhat.com>
Closes: https://bugzilla.redhat.com/show_bug.cgi?id=2090053
Fixes: 07a4ddec3ce9 ("bonding: add an option to specify a delay between peer notifications")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_netlink.c | 7 ++++++-
 drivers/net/bonding/bond_options.c | 8 +++++++-
 include/net/bonding.h              | 2 +-
 3 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/net/bonding/bond_netlink.c b/drivers/net/bonding/bond_netlink.c
index 1007bf6d385d4..7398accd46805 100644
--- a/drivers/net/bonding/bond_netlink.c
+++ b/drivers/net/bonding/bond_netlink.c
@@ -79,6 +79,11 @@ static int bond_fill_slave_info(struct sk_buff *skb,
 	return -EMSGSIZE;
 }
 
+/* Limit the max delay range to 300s */
+static struct netlink_range_validation delay_range = {
+	.max = 300000,
+};
+
 static const struct nla_policy bond_policy[IFLA_BOND_MAX + 1] = {
 	[IFLA_BOND_MODE]		= { .type = NLA_U8 },
 	[IFLA_BOND_ACTIVE_SLAVE]	= { .type = NLA_U32 },
@@ -109,7 +114,7 @@ static const struct nla_policy bond_policy[IFLA_BOND_MAX + 1] = {
 	[IFLA_BOND_AD_ACTOR_SYSTEM]	= { .type = NLA_BINARY,
 					    .len  = ETH_ALEN },
 	[IFLA_BOND_TLB_DYNAMIC_LB]	= { .type = NLA_U8 },
-	[IFLA_BOND_PEER_NOTIF_DELAY]    = { .type = NLA_U32 },
+	[IFLA_BOND_PEER_NOTIF_DELAY]    = NLA_POLICY_FULL_RANGE(NLA_U32, &delay_range),
 	[IFLA_BOND_MISSED_MAX]		= { .type = NLA_U8 },
 };
 
diff --git a/drivers/net/bonding/bond_options.c b/drivers/net/bonding/bond_options.c
index 2e8484a91a0e7..5f883a18bbabd 100644
--- a/drivers/net/bonding/bond_options.c
+++ b/drivers/net/bonding/bond_options.c
@@ -165,6 +165,12 @@ static const struct bond_opt_value bond_num_peer_notif_tbl[] = {
 	{ NULL,      -1,  0}
 };
 
+static const struct bond_opt_value bond_peer_notif_delay_tbl[] = {
+	{ "off",     0,   0},
+	{ "maxval",  300000, BOND_VALFLAG_MAX},
+	{ NULL,      -1,  0}
+};
+
 static const struct bond_opt_value bond_primary_reselect_tbl[] = {
 	{ "always",  BOND_PRI_RESELECT_ALWAYS,  BOND_VALFLAG_DEFAULT},
 	{ "better",  BOND_PRI_RESELECT_BETTER,  0},
@@ -467,7 +473,7 @@ static const struct bond_option bond_opts[BOND_OPT_LAST] = {
 		.id = BOND_OPT_PEER_NOTIF_DELAY,
 		.name = "peer_notif_delay",
 		.desc = "Delay between each peer notification on failover event, in milliseconds",
-		.values = bond_intmax_tbl,
+		.values = bond_peer_notif_delay_tbl,
 		.set = bond_option_peer_notif_delay_set
 	}
 };
diff --git a/include/net/bonding.h b/include/net/bonding.h
index 0db3c5f36868b..e4453cf4f0171 100644
--- a/include/net/bonding.h
+++ b/include/net/bonding.h
@@ -228,7 +228,7 @@ struct bonding {
 	 */
 	spinlock_t mode_lock;
 	spinlock_t stats_lock;
-	u8	 send_peer_notif;
+	u32	 send_peer_notif;
 	u8       igmp_retrans;
 #ifdef CONFIG_PROC_FS
 	struct   proc_dir_entry *proc_entry;
-- 
2.39.2



