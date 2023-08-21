Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6648B1171A
	for <patches@lists.linux.dev>; Mon, 21 Aug 2023 20:07:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBA0EC433C8;
	Mon, 21 Aug 2023 20:07:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692648430;
	bh=XbzX8xN4+p8IfBw6hwn1GFfuWCGkABF8yHFSCMfHPCc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Avs0HlUpWqHfd8Ck1QSu79inVXxn6S2EKsBZk/8bLaAyIg0dYdnP6CednItv4LRoI
	 t1X+J5DUiZ22sLYthtrSSMF15+3FFFmMdu/eS095dZHcW/DqjhhRBCXGz81+VEvvPD
	 aWb/M9m46iSn0DQobWXICcS4wBxX11PY0kEKAzSQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>,
	Edward Cree <ecree.xilinx@gmail.com>,
	Simon Horman <simon.horman@corigine.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 173/234] sfc: add fallback action-set-lists for TC offload
Date: Mon, 21 Aug 2023 21:42:16 +0200
Message-ID: <20230821194136.483562509@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230821194128.754601642@linuxfoundation.org>
References: <20230821194128.754601642@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Edward Cree <ecree.xilinx@gmail.com>

[ Upstream commit e16ca7fb9ffb0d51ddf01e450a1043ea65b5be3f ]

When offloading a TC encap action, the action information for the
 hardware might not be "ready": if there's currently no neighbour entry
 available for the destination address, we can't construct the Ethernet
 header to prepend to the packet.  In this case, we still offload the
 flow rule, but with its action-set-list ID pointing at a "fallback"
 action which simply delivers the packet to its default destination (as
 though no flow rule had matched), thus allowing software TC to handle
 it.  Later, when we receive a neighbouring update that allows us to
 construct the encap header, the rule will become "ready" and we will
 update its action-set-list ID in hardware to point at the actual
 offloaded actions.
This patch sets up these fallback ASLs, but does not yet use them.

Reviewed-by: Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>
Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: fa165e194997 ("sfc: don't unregister flow_indr if it was never registered")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/sfc/tc.c | 68 +++++++++++++++++++++++++++++++++++
 drivers/net/ethernet/sfc/tc.h |  9 +++++
 2 files changed, 77 insertions(+)

diff --git a/drivers/net/ethernet/sfc/tc.c b/drivers/net/ethernet/sfc/tc.c
index d7827ab3761f9..54c5719031f9e 100644
--- a/drivers/net/ethernet/sfc/tc.c
+++ b/drivers/net/ethernet/sfc/tc.c
@@ -1310,6 +1310,58 @@ void efx_tc_deconfigure_default_rule(struct efx_nic *efx,
 	rule->fw_id = MC_CMD_MAE_ACTION_RULE_INSERT_OUT_ACTION_RULE_ID_NULL;
 }
 
+static int efx_tc_configure_fallback_acts(struct efx_nic *efx, u32 eg_port,
+					  struct efx_tc_action_set_list *acts)
+{
+	struct efx_tc_action_set *act;
+	int rc;
+
+	act = kzalloc(sizeof(*act), GFP_KERNEL);
+	if (!act)
+		return -ENOMEM;
+	act->deliver = 1;
+	act->dest_mport = eg_port;
+	rc = efx_mae_alloc_action_set(efx, act);
+	if (rc)
+		goto fail1;
+	EFX_WARN_ON_PARANOID(!list_empty(&acts->list));
+	list_add_tail(&act->list, &acts->list);
+	rc = efx_mae_alloc_action_set_list(efx, acts);
+	if (rc)
+		goto fail2;
+	return 0;
+fail2:
+	list_del(&act->list);
+	efx_mae_free_action_set(efx, act->fw_id);
+fail1:
+	kfree(act);
+	return rc;
+}
+
+static int efx_tc_configure_fallback_acts_pf(struct efx_nic *efx)
+{
+	struct efx_tc_action_set_list *acts = &efx->tc->facts.pf;
+	u32 eg_port;
+
+	efx_mae_mport_uplink(efx, &eg_port);
+	return efx_tc_configure_fallback_acts(efx, eg_port, acts);
+}
+
+static int efx_tc_configure_fallback_acts_reps(struct efx_nic *efx)
+{
+	struct efx_tc_action_set_list *acts = &efx->tc->facts.reps;
+	u32 eg_port;
+
+	efx_mae_mport_mport(efx, efx->tc->reps_mport_id, &eg_port);
+	return efx_tc_configure_fallback_acts(efx, eg_port, acts);
+}
+
+static void efx_tc_deconfigure_fallback_acts(struct efx_nic *efx,
+					     struct efx_tc_action_set_list *acts)
+{
+	efx_tc_free_action_set_list(efx, acts, true);
+}
+
 static int efx_tc_configure_rep_mport(struct efx_nic *efx)
 {
 	u32 rep_mport_label;
@@ -1400,6 +1452,12 @@ int efx_init_tc(struct efx_nic *efx)
 	if (rc)
 		return rc;
 	rc = efx_tc_configure_rep_mport(efx);
+	if (rc)
+		return rc;
+	rc = efx_tc_configure_fallback_acts_pf(efx);
+	if (rc)
+		return rc;
+	rc = efx_tc_configure_fallback_acts_reps(efx);
 	if (rc)
 		return rc;
 	efx->tc->up = true;
@@ -1419,6 +1477,8 @@ void efx_fini_tc(struct efx_nic *efx)
 	efx_tc_deconfigure_rep_mport(efx);
 	efx_tc_deconfigure_default_rule(efx, &efx->tc->dflt.pf);
 	efx_tc_deconfigure_default_rule(efx, &efx->tc->dflt.wire);
+	efx_tc_deconfigure_fallback_acts(efx, &efx->tc->facts.pf);
+	efx_tc_deconfigure_fallback_acts(efx, &efx->tc->facts.reps);
 	efx->tc->up = false;
 }
 
@@ -1483,6 +1543,10 @@ int efx_init_struct_tc(struct efx_nic *efx)
 	efx->tc->dflt.pf.fw_id = MC_CMD_MAE_ACTION_RULE_INSERT_OUT_ACTION_RULE_ID_NULL;
 	INIT_LIST_HEAD(&efx->tc->dflt.wire.acts.list);
 	efx->tc->dflt.wire.fw_id = MC_CMD_MAE_ACTION_RULE_INSERT_OUT_ACTION_RULE_ID_NULL;
+	INIT_LIST_HEAD(&efx->tc->facts.pf.list);
+	efx->tc->facts.pf.fw_id = MC_CMD_MAE_ACTION_SET_ALLOC_OUT_ACTION_SET_ID_NULL;
+	INIT_LIST_HEAD(&efx->tc->facts.reps.list);
+	efx->tc->facts.reps.fw_id = MC_CMD_MAE_ACTION_SET_ALLOC_OUT_ACTION_SET_ID_NULL;
 	efx->extra_channel_type[EFX_EXTRA_CHANNEL_TC] = &efx_tc_channel_type;
 	return 0;
 fail_match_action_ht:
@@ -1508,6 +1572,10 @@ void efx_fini_struct_tc(struct efx_nic *efx)
 			     MC_CMD_MAE_ACTION_RULE_INSERT_OUT_ACTION_RULE_ID_NULL);
 	EFX_WARN_ON_PARANOID(efx->tc->dflt.wire.fw_id !=
 			     MC_CMD_MAE_ACTION_RULE_INSERT_OUT_ACTION_RULE_ID_NULL);
+	EFX_WARN_ON_PARANOID(efx->tc->facts.pf.fw_id !=
+			     MC_CMD_MAE_ACTION_SET_LIST_ALLOC_OUT_ACTION_SET_LIST_ID_NULL);
+	EFX_WARN_ON_PARANOID(efx->tc->facts.reps.fw_id !=
+			     MC_CMD_MAE_ACTION_SET_LIST_ALLOC_OUT_ACTION_SET_LIST_ID_NULL);
 	rhashtable_free_and_destroy(&efx->tc->match_action_ht, efx_tc_flow_free,
 				    efx);
 	rhashtable_free_and_destroy(&efx->tc->encap_match_ht,
diff --git a/drivers/net/ethernet/sfc/tc.h b/drivers/net/ethernet/sfc/tc.h
index 04cced6a2d39f..2b6782e9c7226 100644
--- a/drivers/net/ethernet/sfc/tc.h
+++ b/drivers/net/ethernet/sfc/tc.h
@@ -133,6 +133,11 @@ enum efx_tc_rule_prios {
  *	%EFX_TC_PRIO_DFLT.  Named by *ingress* port
  * @dflt.pf: rule for traffic ingressing from PF (egresses to wire)
  * @dflt.wire: rule for traffic ingressing from wire (egresses to PF)
+ * @facts: Fallback action-set-lists for unready rules.  Named by *egress* port
+ * @facts.pf: action-set-list for unready rules on PF netdev, hence applying to
+ *	traffic from wire, and egressing to PF
+ * @facts.reps: action-set-list for unready rules on representors, hence
+ *	applying to traffic from representees, and egressing to the reps mport
  * @up: have TC datastructures been set up?
  */
 struct efx_tc_state {
@@ -153,6 +158,10 @@ struct efx_tc_state {
 		struct efx_tc_flow_rule pf;
 		struct efx_tc_flow_rule wire;
 	} dflt;
+	struct {
+		struct efx_tc_action_set_list pf;
+		struct efx_tc_action_set_list reps;
+	} facts;
 	bool up;
 };
 
-- 
2.40.1



