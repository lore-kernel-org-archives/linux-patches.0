Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F83F472F8F;
	Tue, 21 Jul 2026 17:56:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656605; cv=none; b=Yb1W3Gq+CUxy86XjRTS9xq2iJptbQauJ48AEExoFI38IbdeGdmPE6tPGqNZqaiT7xWihGFxSWJ/Q5YukwBrwUDFHL9gWYwBxmmSnlfOfUghpwbUK42cKETvrR0Loj6cuXO+hhRrAN1G6nUHoczN8OhMKctnwNrg8C85TYW5kqok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656605; c=relaxed/simple;
	bh=leModd4AQTz+tA9cCv/x1uMrjNtlrEVFNkWKvUR3Rns=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ocuOUYnUt3gZqZKlTtqZmoQDE1nPU6VqDTrRluSmuU95NDYzHEyEfO98d6wnZv2rwoRQjzNJnsbpXpPW0qycOAJiMEzzCRwbND7A8HZofd9VD2HPx17LvAjBLM6hrhbtTrgOiF7YPB/EUr4v93TuuP7TrQzYrJywfBBr+gsqb1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QI4FPhpZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QI4FPhpZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0FEE1F000E9;
	Tue, 21 Jul 2026 17:56:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656604;
	bh=33/4Juk7cYRDPUnfmex/BYqrXiU4RgsPBcOOPLQvC8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QI4FPhpZ7e0iNTFB1XML0hh6mMXdqqzDsUFfoQoyP6kpwnA6Ct/c9DxAuq+Go58fF
	 R2ARBOTn3/DME/df9JTCWNoKa7X4evxLi4YnP1JVZ0OBkaKebjuWSmPbk65JEzh7NV
	 WonydOtdP/KB1IBVcMyJRBDDgWMnNGgCBfqwEXpg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Louis Scalbert <louis.scalbert@6wind.com>,
	Jay Vosburgh <jv@jvosburgh.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0449/1611] bonding: 3ad: fix carrier when no usable slaves
Date: Tue, 21 Jul 2026 17:09:25 +0200
Message-ID: <20260721152525.401635535@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Louis Scalbert <louis.scalbert@6wind.com>

[ Upstream commit 0bd695db23c6262e9cb980017a6273925172ec5b ]

Apply the "lacp_strict" configuration from the previous commit.

"lacp_strict" mode "on" asserts that the bonding master carrier is up
only when at least 'min_links' slaves are in the Collecting_Distributing
state.

Fixes: 655f8919d549 ("bonding: add min links parameter to 802.3ad")
Signed-off-by: Louis Scalbert <louis.scalbert@6wind.com>
Acked-by: Jay Vosburgh <jv@jvosburgh.net>
Link: https://patch.msgid.link/20260603150331.1919611-5-louis.scalbert@6wind.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_3ad.c     | 26 +++++++++++++++++++++++---
 drivers/net/bonding/bond_options.c |  1 +
 2 files changed, 24 insertions(+), 3 deletions(-)

diff --git a/drivers/net/bonding/bond_3ad.c b/drivers/net/bonding/bond_3ad.c
index f1ef99f7515b07..bc8efdea5c2901 100644
--- a/drivers/net/bonding/bond_3ad.c
+++ b/drivers/net/bonding/bond_3ad.c
@@ -733,6 +733,21 @@ static void __set_agg_ports_ready(struct aggregator *aggregator, int val)
 	}
 }
 
+static int __agg_usable_ports(struct aggregator *agg)
+{
+	struct port *port;
+	int valid = 0;
+
+	for (port = agg->lag_ports; port;
+	     port = port->next_port_in_aggregator) {
+		if (port->actor_oper_port_state & LACP_STATE_COLLECTING &&
+		    port->actor_oper_port_state & LACP_STATE_DISTRIBUTING)
+			valid++;
+	}
+
+	return valid;
+}
+
 static int __agg_active_ports(struct aggregator *agg)
 {
 	struct port *port;
@@ -1164,10 +1179,10 @@ static void ad_mux_machine(struct port *port, bool *update_slave_arr)
 		switch (port->sm_mux_state) {
 		case AD_MUX_DETACHED:
 			port->actor_oper_port_state &= ~LACP_STATE_SYNCHRONIZATION;
-			ad_disable_collecting_distributing(port,
-							   update_slave_arr);
 			port->actor_oper_port_state &= ~LACP_STATE_COLLECTING;
 			port->actor_oper_port_state &= ~LACP_STATE_DISTRIBUTING;
+			ad_disable_collecting_distributing(port,
+							   update_slave_arr);
 			port->ntt = true;
 			break;
 		case AD_MUX_WAITING:
@@ -2090,6 +2105,7 @@ static void ad_disable_distributing(struct port *port, bool *update_slave_arr)
 			  port->actor_port_number,
 			  aggregator->aggregator_identifier);
 		__disable_distributing_port(port);
+		bond_3ad_set_carrier(port->slave->bond);
 		/* Slave array needs an update */
 		*update_slave_arr = true;
 	}
@@ -2113,6 +2129,7 @@ static void ad_enable_collecting_distributing(struct port *port,
 			  port->actor_port_number,
 			  aggregator->aggregator_identifier);
 		__enable_port(port);
+		bond_3ad_set_carrier(port->slave->bond);
 		/* Slave array needs update */
 		*update_slave_arr = true;
 		/* Should notify peers if possible */
@@ -2136,6 +2153,7 @@ static void ad_disable_collecting_distributing(struct port *port,
 			  port->actor_port_number,
 			  aggregator->aggregator_identifier);
 		__disable_port(port);
+		bond_3ad_set_carrier(port->slave->bond);
 		/* Slave array needs an update */
 		*update_slave_arr = true;
 	}
@@ -2815,7 +2833,9 @@ int bond_3ad_set_carrier(struct bonding *bond)
 	active = __get_active_agg(&(SLAVE_AD_INFO(first_slave)->aggregator));
 	if (active) {
 		/* are enough slaves available to consider link up? */
-		if (__agg_active_ports(active) < bond->params.min_links) {
+		if ((bond->params.lacp_strict ? __agg_usable_ports(active)
+					: __agg_active_ports(active)) <
+		    bond->params.min_links) {
 			if (netif_carrier_ok(bond->dev)) {
 				netif_carrier_off(bond->dev);
 				goto out;
diff --git a/drivers/net/bonding/bond_options.c b/drivers/net/bonding/bond_options.c
index 08dc024c6f2f3f..1b2cb2c80d916c 100644
--- a/drivers/net/bonding/bond_options.c
+++ b/drivers/net/bonding/bond_options.c
@@ -1705,6 +1705,7 @@ static int bond_option_lacp_strict_set(struct bonding *bond,
 	netdev_dbg(bond->dev, "Setting LACP fallback to %s (%llu)\n",
 		   newval->string, newval->value);
 	bond->params.lacp_strict = newval->value;
+	bond_3ad_set_carrier(bond);
 
 	return 0;
 }
-- 
2.53.0



