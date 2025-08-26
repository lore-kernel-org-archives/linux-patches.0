Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1FFD26158C;
	Tue, 26 Aug 2025 13:14:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214052; cv=none; b=Dmkz3Lx+MwlGP+R/JAGsJl0Hb6CmS1CkZK6ox3yMA8oklcZ0kKdoWquxP3XTUA0Vv9A1kpeE9aE1BYVST8rr53aiokExrsv0eKOsfQQmhfouzYJUbJY7a5GBp/8zfc1q1rIQsly0nIz6Nd98hVDxV54vkt7dMeSkCgRda7pnxcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214052; c=relaxed/simple;
	bh=T0kY2/OSQ/5xZy5+Qcl1IbXbl8QpURwmrniVbpMSU88=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NOqadamhmrTllvwgYF8+0wUbWJDo7enz6mT4hkMQUYfnspqzk5mnr4LcO2zxfiuHJyfO+Sd3W8DvcvWAUujVp02TTlUEa+DiSdH5XGD57uccjDvgje7YU59lwC1Y5tf/SXu61gsRDBrKleYQsqh9pKraKgNGU6en2P9+dTpuR5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mtLy553c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mtLy553c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67D1AC4CEF1;
	Tue, 26 Aug 2025 13:14:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214052;
	bh=T0kY2/OSQ/5xZy5+Qcl1IbXbl8QpURwmrniVbpMSU88=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mtLy553cQnojg8Bqt8q5hxnzqZXj0Z9l+zANL7kQlGRZInGlUr+0IyB38Xn+65cLi
	 D/17LqFMLMWeUKU5ccTFyg6QpEN0m17EyKzoqp3GPCy68uhoUw4nWrZxtEL1NNLEs4
	 HROWm8ezxhYadjLw2xZn7K+2s9Jr6ro+nVPopJLU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hangbin Liu <liuhangbin@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 578/587] bonding: update LACP activity flag after setting lacp_active
Date: Tue, 26 Aug 2025 13:12:07 +0200
Message-ID: <20250826111007.741589931@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit b64d035f77b1f02ab449393342264b44950a75ae ]

The port's actor_oper_port_state activity flag should be updated immediately
after changing the lacp_active option to reflect the current mode correctly.

Fixes: 3a755cd8b7c6 ("bonding: add new option lacp_active")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Link: https://patch.msgid.link/20250815062000.22220-2-liuhangbin@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_3ad.c     | 25 +++++++++++++++++++++++++
 drivers/net/bonding/bond_options.c |  1 +
 include/net/bond_3ad.h             |  1 +
 3 files changed, 27 insertions(+)

diff --git a/drivers/net/bonding/bond_3ad.c b/drivers/net/bonding/bond_3ad.c
index c99ffe6c683a..56b18ab2fa28 100644
--- a/drivers/net/bonding/bond_3ad.c
+++ b/drivers/net/bonding/bond_3ad.c
@@ -2734,6 +2734,31 @@ void bond_3ad_update_lacp_rate(struct bonding *bond)
 	spin_unlock_bh(&bond->mode_lock);
 }
 
+/**
+ * bond_3ad_update_lacp_active - change the lacp active
+ * @bond: bonding struct
+ *
+ * Update actor_oper_port_state when lacp_active is modified.
+ */
+void bond_3ad_update_lacp_active(struct bonding *bond)
+{
+	struct port *port = NULL;
+	struct list_head *iter;
+	struct slave *slave;
+	int lacp_active;
+
+	lacp_active = bond->params.lacp_active;
+	spin_lock_bh(&bond->mode_lock);
+	bond_for_each_slave(bond, slave, iter) {
+		port = &(SLAVE_AD_INFO(slave)->port);
+		if (lacp_active)
+			port->actor_oper_port_state |= LACP_STATE_LACP_ACTIVITY;
+		else
+			port->actor_oper_port_state &= ~LACP_STATE_LACP_ACTIVITY;
+	}
+	spin_unlock_bh(&bond->mode_lock);
+}
+
 size_t bond_3ad_stats_size(void)
 {
 	return nla_total_size_64bit(sizeof(u64)) + /* BOND_3AD_STAT_LACPDU_RX */
diff --git a/drivers/net/bonding/bond_options.c b/drivers/net/bonding/bond_options.c
index 6d003c0ef669..b282ed5b59a9 100644
--- a/drivers/net/bonding/bond_options.c
+++ b/drivers/net/bonding/bond_options.c
@@ -1618,6 +1618,7 @@ static int bond_option_lacp_active_set(struct bonding *bond,
 	netdev_dbg(bond->dev, "Setting LACP active to %s (%llu)\n",
 		   newval->string, newval->value);
 	bond->params.lacp_active = newval->value;
+	bond_3ad_update_lacp_active(bond);
 
 	return 0;
 }
diff --git a/include/net/bond_3ad.h b/include/net/bond_3ad.h
index c5e57c6bd873..29f2a681aa14 100644
--- a/include/net/bond_3ad.h
+++ b/include/net/bond_3ad.h
@@ -302,6 +302,7 @@ int bond_3ad_lacpdu_recv(const struct sk_buff *skb, struct bonding *bond,
 			 struct slave *slave);
 int bond_3ad_set_carrier(struct bonding *bond);
 void bond_3ad_update_lacp_rate(struct bonding *bond);
+void bond_3ad_update_lacp_active(struct bonding *bond);
 void bond_3ad_update_ad_actor_settings(struct bonding *bond);
 int bond_3ad_stats_fill(struct sk_buff *skb, struct bond_3ad_stats *stats);
 size_t bond_3ad_stats_size(void);
-- 
2.50.1



