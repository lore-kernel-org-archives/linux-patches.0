Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2E0E443E44;
	Tue, 21 Jul 2026 22:16:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672210; cv=none; b=IXP+DMMSN6jN26R5EdKBWkf67U6HEODjHh3PnG7fYcrpdUgtVK+7HmA9FFubrygfn/Hmw9KHC9+vece6KSWWpZs45ULy7NzOnugxbCKLbRGJ5XKsGoLi0c7vIohKm/v0kl+8Z+dX5WDGCoQPT7H0YCJ/o/sUwyXH4AUbAlc4A10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672210; c=relaxed/simple;
	bh=xbfVmZ0STsNOsREDPsOizk7dVfCE7qYSajCgq85nsFw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pZD4/E2vCs2we9IvqK22xVAjYDBnQlrBNNbG71PaF2j10IHLi+ALVFrMLTrvuERPQSUAIux2eMHspBt7eciKhUEkyw8SwmFkJDQZ3Qwrllg9eHYarNy7EABVxYO8pBZyXnNB88+iEmc4EVraMewyV7VwI3i8W7SnC+XJR06lJeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QHCmvSi6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QHCmvSi6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E99B1F000E9;
	Tue, 21 Jul 2026 22:16:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672208;
	bh=o9RX8YM10DiS5pU7Cpni7+VtisFFwT9Q4+NFh1l7NJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QHCmvSi6VkrAEebTmPv1D6bhnrQDA/yEJpu/lIDocgDKtj4NQwgGow64XbtbrPcUR
	 RywVd9VVjdbiPs2NlkEiPqVi+L/7F8yqP6Ss/scNBI1TkUtJFgdAQash+N73Ra+uze
	 U0TSK0KlSIDH8ylxF264xkUydz/Mh9uhIBzDBwqw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ratheesh Kannoth <rkannoth@marvell.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 536/843] octeontx2-af: devlink configuration support
Date: Tue, 21 Jul 2026 17:22:51 +0200
Message-ID: <20260721152418.090587410@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

From: Ratheesh Kannoth <rkannoth@marvell.com>

[ Upstream commit ffd92c57469d9395ed2df1ee9d71bba39b37d950 ]

CN10KB silicon supports Exact match feature. This feature can be disabled
through devlink configuration. Devlink command fails if DMAC filter rules
are already present. Once disabled, legacy RPM based DMAC filters will be
configured.

Signed-off-by: Ratheesh Kannoth <rkannoth@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 235acadd3105 ("octeontx2-pf: check DMAC extraction support before filtering")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../marvell/octeontx2/af/rvu_devlink.c        | 71 ++++++++++++++++++-
 .../marvell/octeontx2/af/rvu_npc_hash.c       | 29 ++++++++
 .../marvell/octeontx2/af/rvu_npc_hash.h       |  3 +
 3 files changed, 101 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
index c3da400e87eba6..a4c292dae45822 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
@@ -10,6 +10,7 @@
 #include "rvu.h"
 #include "rvu_reg.h"
 #include "rvu_struct.h"
+#include "rvu_npc_hash.h"
 
 #define DRV_NAME "octeontx2-af"
 
@@ -1430,14 +1431,75 @@ static int rvu_af_dl_dwrr_mtu_get(struct devlink *devlink, u32 id,
 enum rvu_af_dl_param_id {
 	RVU_AF_DEVLINK_PARAM_ID_BASE = DEVLINK_PARAM_GENERIC_ID_MAX,
 	RVU_AF_DEVLINK_PARAM_ID_DWRR_MTU,
+	RVU_AF_DEVLINK_PARAM_ID_NPC_EXACT_FEATURE_DISABLE,
 };
 
+static int rvu_af_npc_exact_feature_get(struct devlink *devlink, u32 id,
+					struct devlink_param_gset_ctx *ctx)
+{
+	struct rvu_devlink *rvu_dl = devlink_priv(devlink);
+	struct rvu *rvu = rvu_dl->rvu;
+	bool enabled;
+
+	enabled = rvu_npc_exact_has_match_table(rvu);
+
+	snprintf(ctx->val.vstr, sizeof(ctx->val.vstr), "%s",
+		 enabled ? "enabled" : "disabled");
+
+	return 0;
+}
+
+static int rvu_af_npc_exact_feature_disable(struct devlink *devlink, u32 id,
+					    struct devlink_param_gset_ctx *ctx)
+{
+	struct rvu_devlink *rvu_dl = devlink_priv(devlink);
+	struct rvu *rvu = rvu_dl->rvu;
+
+	rvu_npc_exact_disable_feature(rvu);
+
+	return 0;
+}
+
+static int rvu_af_npc_exact_feature_validate(struct devlink *devlink, u32 id,
+					     union devlink_param_value val,
+					     struct netlink_ext_ack *extack)
+{
+	struct rvu_devlink *rvu_dl = devlink_priv(devlink);
+	struct rvu *rvu = rvu_dl->rvu;
+	u64 enable;
+
+	if (kstrtoull(val.vstr, 10, &enable)) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Only 1 value is supported");
+		return -EINVAL;
+	}
+
+	if (enable != 1) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Only disabling exact match feature is supported");
+		return -EINVAL;
+	}
+
+	if (rvu_npc_exact_can_disable_feature(rvu))
+		return 0;
+
+	NL_SET_ERR_MSG_MOD(extack,
+			   "Can't disable exact match feature; Please try before any configuration");
+	return -EFAULT;
+}
+
 static const struct devlink_param rvu_af_dl_params[] = {
 	DEVLINK_PARAM_DRIVER(RVU_AF_DEVLINK_PARAM_ID_DWRR_MTU,
 			     "dwrr_mtu", DEVLINK_PARAM_TYPE_U32,
 			     BIT(DEVLINK_PARAM_CMODE_RUNTIME),
 			     rvu_af_dl_dwrr_mtu_get, rvu_af_dl_dwrr_mtu_set,
 			     rvu_af_dl_dwrr_mtu_validate),
+	DEVLINK_PARAM_DRIVER(RVU_AF_DEVLINK_PARAM_ID_NPC_EXACT_FEATURE_DISABLE,
+			     "npc_exact_feature_disable", DEVLINK_PARAM_TYPE_STRING,
+			     BIT(DEVLINK_PARAM_CMODE_RUNTIME),
+			     rvu_af_npc_exact_feature_get,
+			     rvu_af_npc_exact_feature_disable,
+			     rvu_af_npc_exact_feature_validate),
 };
 
 /* Devlink switch mode */
@@ -1495,6 +1557,7 @@ int rvu_register_dl(struct rvu *rvu)
 {
 	struct rvu_devlink *rvu_dl;
 	struct devlink *dl;
+	size_t size;
 	int err;
 
 	dl = devlink_alloc(&rvu_devlink_ops, sizeof(struct rvu_devlink),
@@ -1523,8 +1586,12 @@ int rvu_register_dl(struct rvu *rvu)
 		goto err_dl_health;
 	}
 
-	err = devlink_params_register(dl, rvu_af_dl_params,
-				      ARRAY_SIZE(rvu_af_dl_params));
+	/* Register exact match devlink only for CN10K-B */
+	size = ARRAY_SIZE(rvu_af_dl_params);
+	if (!rvu_npc_exact_has_match_table(rvu))
+		size -= 1;
+
+	err = devlink_params_register(dl, rvu_af_dl_params, size);
 	if (err) {
 		dev_err(rvu->dev,
 			"devlink params register failed with error %d", err);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c
index 273f4b648c7390..fc18f543ca25fb 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c
@@ -1154,6 +1154,35 @@ static int __maybe_unused rvu_npc_exact_update_table_entry(struct rvu *rvu, u8 c
 	return 0;
 }
 
+/**
+ *	rvu_npc_exact_can_disable_feature - Check if feature can be disabled.
+ *      @rvu: resource virtualization unit.
+ *	Return: True if exact match feature is supported.
+ */
+bool rvu_npc_exact_can_disable_feature(struct rvu *rvu)
+{
+	struct npc_exact_table *table = rvu->hw->table;
+	bool empty;
+
+	if (!rvu->hw->cap.npc_exact_match_enabled)
+		return false;
+
+	mutex_lock(&table->lock);
+	empty = list_empty(&table->lhead_gbl);
+	mutex_unlock(&table->lock);
+
+	return empty;
+}
+
+/**
+ *	rvu_npc_exact_disable_feature - Disable feature.
+ *      @rvu: resource virtualization unit.
+ */
+void rvu_npc_exact_disable_feature(struct rvu *rvu)
+{
+	rvu->hw->cap.npc_exact_match_enabled = false;
+}
+
 /**
  *      rvu_npc_exact_init - initialize exact match table
  *      @rvu: resource virtualization unit.
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.h
index f2346aa79ce2c3..7adb5c5c508209 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.h
@@ -185,4 +185,7 @@ int rvu_npc_exact_del_table_entry_by_id(struct rvu *rvu, u32 seq_id);
 u32 rvu_npc_exact_get_max_entries(struct rvu *rvu);
 int rvu_npc_exact_init(struct rvu *rvu);
 
+bool rvu_npc_exact_can_disable_feature(struct rvu *rvu);
+void rvu_npc_exact_disable_feature(struct rvu *rvu);
+
 #endif /* RVU_NPC_HASH_H */
-- 
2.53.0



