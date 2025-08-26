Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B15029D26A;
	Tue, 26 Aug 2025 11:35:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208100; cv=none; b=T11evb+ZIZfOidpWQeYzFzpLxeMDRuuH5LlIoltVqzE3x+l7lJGIqoMMraCbQKSgjXFAMfKUVHLcFtfFVbrIPqNvRk2kPvGYPDqUOaVrN2Dr2iQsQ00pdKMdz5axwe9Qfw2QcMD8yvQw9GPfcQCiku9+3gr0HVUJfy4JvrLzL1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208100; c=relaxed/simple;
	bh=erKXwtYIfcHKQT9a/fwGqiE039zHplkJ3fOm5RR49/s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PrC9j3tMPUq1yfCwREiFr17CLBgzy7SGZKPWimF3LdJgdtElPwK7ci7k2O8I5L6SpxAlkywSU7xAD50FghIyd+w9Gez5V89mWVrKNNFsQt+Q0W+NeAKEDKyft8zrf+1MaWFDfJMly+GVDYsaA9mTycOTkyaUPa3u60orHHdTRs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DEvepcUR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DEvepcUR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1787C4CEF1;
	Tue, 26 Aug 2025 11:34:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208100;
	bh=erKXwtYIfcHKQT9a/fwGqiE039zHplkJ3fOm5RR49/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DEvepcURItEnwgZOKJkFKR0hH+8pfz8n4PSRqJXogD9e84ITGt9eNXIWx28k2SimQ
	 xhFliIL8643g6WTrni5MGkAFoTEKgqCc5dKj1uobaPBAa54ohWFtvtcK1SAqaL/8dQ
	 ooZYPaXbpmoeEPasF4VshJaZ7xz2ZMzRYb1AzjFI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hangbin Liu <liuhangbin@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 437/457] bonding: update LACP activity flag after setting lacp_active
Date: Tue, 26 Aug 2025 13:12:01 +0200
Message-ID: <20250826110948.087954458@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index c6807e473ab7..a51305423d28 100644
--- a/drivers/net/bonding/bond_3ad.c
+++ b/drivers/net/bonding/bond_3ad.c
@@ -2869,6 +2869,31 @@ void bond_3ad_update_lacp_rate(struct bonding *bond)
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
index 91893c29b899..28c53f1b1382 100644
--- a/drivers/net/bonding/bond_options.c
+++ b/drivers/net/bonding/bond_options.c
@@ -1637,6 +1637,7 @@ static int bond_option_lacp_active_set(struct bonding *bond,
 	netdev_dbg(bond->dev, "Setting LACP active to %s (%llu)\n",
 		   newval->string, newval->value);
 	bond->params.lacp_active = newval->value;
+	bond_3ad_update_lacp_active(bond);
 
 	return 0;
 }
diff --git a/include/net/bond_3ad.h b/include/net/bond_3ad.h
index 2053cd8e788a..dba369a2cf27 100644
--- a/include/net/bond_3ad.h
+++ b/include/net/bond_3ad.h
@@ -307,6 +307,7 @@ int bond_3ad_lacpdu_recv(const struct sk_buff *skb, struct bonding *bond,
 			 struct slave *slave);
 int bond_3ad_set_carrier(struct bonding *bond);
 void bond_3ad_update_lacp_rate(struct bonding *bond);
+void bond_3ad_update_lacp_active(struct bonding *bond);
 void bond_3ad_update_ad_actor_settings(struct bonding *bond);
 int bond_3ad_stats_fill(struct sk_buff *skb, struct bond_3ad_stats *stats);
 size_t bond_3ad_stats_size(void);
-- 
2.50.1



