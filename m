Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B683DFBF0;
	Tue, 26 Aug 2025 13:14:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214075; cv=none; b=SskF4/ETdZE4FSDSDXJvrptHvBEXddRBazvh2cE5d9uZinJ4RuE/8Gl6kwyE5THl9N7TWQyQM8W8eWvbNURvOXZtykko0rCvcHMZHdjED8NAX+2JGhOVFM8vQJDJoWpS73kxkWEIxoNj3SKXX6hkG23GlqL9dHgVcKZ+uBc/2Gw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214075; c=relaxed/simple;
	bh=wsbJxCzzpVrMyBXP7Lsv+vlecyssgJVbfDVxut05rsk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HWPk9606a45kVpJRGKgvjWqKpO55W42Hu6h6uPjdpGlOWSkDoi8d5xXGalr3eaXjgDym5Kpseh6hrzwrSChEuS0it8IfpW0z75eWn1gEMxd1lBZR6Q4f4BOrT7+ddpdQB80ScXnpJYiaJsLZI1trmMKipcQfRAPc5E6L5Rme7Wo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kta2bqlP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kta2bqlP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28282C4CEF1;
	Tue, 26 Aug 2025 13:14:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214075;
	bh=wsbJxCzzpVrMyBXP7Lsv+vlecyssgJVbfDVxut05rsk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kta2bqlPoHnG3x8mL33tRB6ksTAs6oX99HG3fNsT7+kQqphDDF0tXzwcD0tJHU7a5
	 Khko38EdTaWI8Px5oo2CkvlycWIq/LaHxijz3EZeZvj7l4w5HNwC9yoqQABJ1l5+fH
	 EycOuVLZ+kxniQHshX/e7ivQRYNq2L88/8CJ0hMg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hangbin Liu <liuhangbin@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 580/587] bonding: send LACPDUs periodically in passive mode after receiving partners LACPDU
Date: Tue, 26 Aug 2025 13:12:09 +0200
Message-ID: <20250826111007.793432965@linuxfoundation.org>
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

[ Upstream commit 0599640a21e98f0d6a3e9ff85c0a687c90a8103b ]

When `lacp_active` is set to `off`, the bond operates in passive mode, meaning
it only "speaks when spoken to." However, the current kernel implementation
only sends an LACPDU in response when the partner's state changes.

As a result, once LACP negotiation succeeds, the actor stops sending LACPDUs
until the partner times out and sends an "expired" LACPDU. This causes
continuous LACP state flapping.

According to IEEE 802.1AX-2014, 6.4.13 Periodic Transmission machine. The
values of Partner_Oper_Port_State.LACP_Activity and
Actor_Oper_Port_State.LACP_Activity determine whether periodic transmissions
take place. If either or both parameters are set to Active LACP, then periodic
transmissions occur; if both are set to Passive LACP, then periodic
transmissions do not occur.

To comply with this, we remove the `!bond->params.lacp_active` check in
`ad_periodic_machine()`. Instead, we initialize the actor's port's
`LACP_STATE_LACP_ACTIVITY` state based on `lacp_active` setting.

Additionally, we avoid setting the partner's state to
`LACP_STATE_LACP_ACTIVITY` in the EXPIRED state, since we should not assume
the partner is active by default.

This ensures that in passive mode, the bond starts sending periodic LACPDUs
after receiving one from the partner, and avoids flapping due to inactivity.

Fixes: 3a755cd8b7c6 ("bonding: add new option lacp_active")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Link: https://patch.msgid.link/20250815062000.22220-3-liuhangbin@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_3ad.c | 42 +++++++++++++++++++---------------
 1 file changed, 24 insertions(+), 18 deletions(-)

diff --git a/drivers/net/bonding/bond_3ad.c b/drivers/net/bonding/bond_3ad.c
index a92a841ccec9..d02a91cefec8 100644
--- a/drivers/net/bonding/bond_3ad.c
+++ b/drivers/net/bonding/bond_3ad.c
@@ -99,13 +99,13 @@ static int ad_marker_send(struct port *port, struct bond_marker *marker);
 static void ad_mux_machine(struct port *port, bool *update_slave_arr);
 static void ad_rx_machine(struct lacpdu *lacpdu, struct port *port);
 static void ad_tx_machine(struct port *port);
-static void ad_periodic_machine(struct port *port, struct bond_params *bond_params);
+static void ad_periodic_machine(struct port *port);
 static void ad_port_selection_logic(struct port *port, bool *update_slave_arr);
 static void ad_agg_selection_logic(struct aggregator *aggregator,
 				   bool *update_slave_arr);
 static void ad_clear_agg(struct aggregator *aggregator);
 static void ad_initialize_agg(struct aggregator *aggregator);
-static void ad_initialize_port(struct port *port, int lacp_fast);
+static void ad_initialize_port(struct port *port, const struct bond_params *bond_params);
 static void ad_enable_collecting(struct port *port);
 static void ad_disable_distributing(struct port *port,
 				    bool *update_slave_arr);
@@ -1300,10 +1300,16 @@ static void ad_rx_machine(struct lacpdu *lacpdu, struct port *port)
 			 * case of EXPIRED even if LINK_DOWN didn't arrive for
 			 * the port.
 			 */
-			port->partner_oper.port_state &= ~LACP_STATE_SYNCHRONIZATION;
 			port->sm_vars &= ~AD_PORT_MATCHED;
+			/* Based on IEEE 8021AX-2014, Figure 6-18 - Receive
+			 * machine state diagram, the statue should be
+			 * Partner_Oper_Port_State.Synchronization = FALSE;
+			 * Partner_Oper_Port_State.LACP_Timeout = Short Timeout;
+			 * start current_while_timer(Short Timeout);
+			 * Actor_Oper_Port_State.Expired = TRUE;
+			 */
+			port->partner_oper.port_state &= ~LACP_STATE_SYNCHRONIZATION;
 			port->partner_oper.port_state |= LACP_STATE_LACP_TIMEOUT;
-			port->partner_oper.port_state |= LACP_STATE_LACP_ACTIVITY;
 			port->sm_rx_timer_counter = __ad_timer_to_ticks(AD_CURRENT_WHILE_TIMER, (u16)(AD_SHORT_TIMEOUT));
 			port->actor_oper_port_state |= LACP_STATE_EXPIRED;
 			port->sm_vars |= AD_PORT_CHURNED;
@@ -1409,11 +1415,10 @@ static void ad_tx_machine(struct port *port)
 /**
  * ad_periodic_machine - handle a port's periodic state machine
  * @port: the port we're looking at
- * @bond_params: bond parameters we will use
  *
  * Turn ntt flag on priodically to perform periodic transmission of lacpdu's.
  */
-static void ad_periodic_machine(struct port *port, struct bond_params *bond_params)
+static void ad_periodic_machine(struct port *port)
 {
 	periodic_states_t last_state;
 
@@ -1422,8 +1427,7 @@ static void ad_periodic_machine(struct port *port, struct bond_params *bond_para
 
 	/* check if port was reinitialized */
 	if (((port->sm_vars & AD_PORT_BEGIN) || !(port->sm_vars & AD_PORT_LACP_ENABLED) || !port->is_enabled) ||
-	    (!(port->actor_oper_port_state & LACP_STATE_LACP_ACTIVITY) && !(port->partner_oper.port_state & LACP_STATE_LACP_ACTIVITY)) ||
-	    !bond_params->lacp_active) {
+	    (!(port->actor_oper_port_state & LACP_STATE_LACP_ACTIVITY) && !(port->partner_oper.port_state & LACP_STATE_LACP_ACTIVITY))) {
 		port->sm_periodic_state = AD_NO_PERIODIC;
 	}
 	/* check if state machine should change state */
@@ -1947,16 +1951,16 @@ static void ad_initialize_agg(struct aggregator *aggregator)
 /**
  * ad_initialize_port - initialize a given port's parameters
  * @port: the port we're looking at
- * @lacp_fast: boolean. whether fast periodic should be used
+ * @bond_params: bond parameters we will use
  */
-static void ad_initialize_port(struct port *port, int lacp_fast)
+static void ad_initialize_port(struct port *port, const struct bond_params *bond_params)
 {
 	static const struct port_params tmpl = {
 		.system_priority = 0xffff,
 		.key             = 1,
 		.port_number     = 1,
 		.port_priority   = 0xff,
-		.port_state      = 1,
+		.port_state      = 0,
 	};
 	static const struct lacpdu lacpdu = {
 		.subtype		= 0x01,
@@ -1974,12 +1978,14 @@ static void ad_initialize_port(struct port *port, int lacp_fast)
 		port->actor_port_priority = 0xff;
 		port->actor_port_aggregator_identifier = 0;
 		port->ntt = false;
-		port->actor_admin_port_state = LACP_STATE_AGGREGATION |
-					       LACP_STATE_LACP_ACTIVITY;
-		port->actor_oper_port_state  = LACP_STATE_AGGREGATION |
-					       LACP_STATE_LACP_ACTIVITY;
+		port->actor_admin_port_state = LACP_STATE_AGGREGATION;
+		port->actor_oper_port_state  = LACP_STATE_AGGREGATION;
+		if (bond_params->lacp_active) {
+			port->actor_admin_port_state |= LACP_STATE_LACP_ACTIVITY;
+			port->actor_oper_port_state  |= LACP_STATE_LACP_ACTIVITY;
+		}
 
-		if (lacp_fast)
+		if (bond_params->lacp_fast)
 			port->actor_oper_port_state |= LACP_STATE_LACP_TIMEOUT;
 
 		memcpy(&port->partner_admin, &tmpl, sizeof(tmpl));
@@ -2195,7 +2201,7 @@ void bond_3ad_bind_slave(struct slave *slave)
 		/* port initialization */
 		port = &(SLAVE_AD_INFO(slave)->port);
 
-		ad_initialize_port(port, bond->params.lacp_fast);
+		ad_initialize_port(port, &bond->params);
 
 		port->slave = slave;
 		port->actor_port_number = SLAVE_AD_INFO(slave)->id;
@@ -2507,7 +2513,7 @@ void bond_3ad_state_machine_handler(struct work_struct *work)
 		}
 
 		ad_rx_machine(NULL, port);
-		ad_periodic_machine(port, &bond->params);
+		ad_periodic_machine(port);
 		ad_port_selection_logic(port, &update_slave_arr);
 		ad_mux_machine(port, &update_slave_arr);
 		ad_tx_machine(port);
-- 
2.50.1



