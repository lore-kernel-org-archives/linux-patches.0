Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F15F03E49C8;
	Tue, 21 Jul 2026 17:10:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653831; cv=none; b=gVJ1SEHTzINY+5OVbz8Ikh8j5mhzri0alsGgLi8spLwVDIh2ebW1NNpxlYEjNSRaeo8smlf+j6VM5Wok5phNzmfDNK7Ap5OXk/GHnFpl+JFKKBAIWLmiuc62VfpNmFvPHGOtnOfb5dqS6VE7KEuNvlSqTAMLYbv3AfYKU06UiSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653831; c=relaxed/simple;
	bh=iF9LUp0J3joizkGpKen3pSPJKEUkfrZi1ozMQuRqmg4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ODGxWpfEotXWyLn/XHegs69LArH/jIU+cQ3YeAloCDE/nidHa1dxpfi6oa/n2bOi8zTfrmU1sRJr/RrBEeS+wZrEmRzAG8ZqXzzG2qLWTcBZDKwmg9x+rpWXMZyCrJuSiv/M4engYplLSgnDyht0Ej67fSqEHSyIOQuRzZ1d/hk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wBmXqBD7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wBmXqBD7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62B851F000E9;
	Tue, 21 Jul 2026 17:10:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653829;
	bh=p+8zp+bgQ4LUow3cJeiySEiomcl6gltibEZg4MA2vME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wBmXqBD71wyT9W0wg0Xi2EsOc1EqF1uJSKHd909u9COVlYEpxyT+54QsjhBwtTsi1
	 1rRLLe20EbGGmyUmnD5vJF03ragRWmYm7ecNrO0Ev5/0ObhtJ3Muv0w5yfeC6RPsb1
	 b8ndRoigaQMUMm0/lgvCOOJc/TSZ5jC/gRN3zYc0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Bloch <mbloch@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1432/2077] net/mlx5: E-Switch, add representor lifecycle lock
Date: Tue, 21 Jul 2026 17:18:25 +0200
Message-ID: <20260721152626.583067301@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Bloch <mbloch@nvidia.com>

[ Upstream commit 9b8468f001e46c4ffcbbeb2050aabf80e1ed7960 ]

Add a per-E-Switch mutex for serializing representor lifecycle work and
provide small helpers for taking and dropping it. Initialize and destroy
the mutex with the E-Switch offloads state.

Add the lock and helper API first. Follow-up patches will take the lock in
the individual representor lifecycle components. This keeps the functional
changes split by component and leaves this patch without intended behavior
change, making the series easier to review and bisectable.

Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20260503202726.266415-4-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 0f0e4ae6975c ("net/mlx5: LAG, Fix off-by-one in single-FDB error rollback")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h    |  6 ++++++
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c   | 12 ++++++++++++
 2 files changed, 18 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index e9cf7c592ce9e1..0b107c2ddbfa62 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -316,6 +316,7 @@ struct mlx5_esw_offload {
 	DECLARE_HASHTABLE(termtbl_tbl, 8);
 	struct mutex termtbl_mutex; /* protects termtbl hash */
 	struct xarray vhca_map;
+	struct mutex reps_lock; /* protects representor load/unload/register */
 	const struct mlx5_eswitch_rep_ops *rep_ops[NUM_REP_TYPES];
 	u8 inline_mode;
 	atomic64_t num_flows;
@@ -949,6 +950,8 @@ mlx5_esw_lag_demux_fg_create(struct mlx5_eswitch *esw,
 struct mlx5_flow_handle *
 mlx5_esw_lag_demux_rule_create(struct mlx5_eswitch *esw, u16 vport_num,
 			       struct mlx5_flow_table *lag_ft);
+void mlx5_esw_reps_block(struct mlx5_eswitch *esw);
+void mlx5_esw_reps_unblock(struct mlx5_eswitch *esw);
 #else  /* CONFIG_MLX5_ESWITCH */
 /* eswitch API stubs */
 static inline int  mlx5_eswitch_init(struct mlx5_core_dev *dev) { return 0; }
@@ -1026,6 +1029,9 @@ mlx5_esw_host_functions_enabled(const struct mlx5_core_dev *dev)
 	return true;
 }
 
+static inline void mlx5_esw_reps_block(struct mlx5_eswitch *esw) {}
+static inline void mlx5_esw_reps_unblock(struct mlx5_eswitch *esw) {}
+
 static inline bool
 mlx5_esw_vport_vhca_id(struct mlx5_eswitch *esw, u16 vportn, u16 *vhca_id)
 {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index a078d06f456739..41d65f2bf87dd8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -2410,6 +2410,16 @@ static int esw_create_restore_table(struct mlx5_eswitch *esw)
 	return err;
 }
 
+void mlx5_esw_reps_block(struct mlx5_eswitch *esw)
+{
+	mutex_lock(&esw->offloads.reps_lock);
+}
+
+void mlx5_esw_reps_unblock(struct mlx5_eswitch *esw)
+{
+	mutex_unlock(&esw->offloads.reps_lock);
+}
+
 static void esw_mode_change(struct mlx5_eswitch *esw, u16 mode)
 {
 	mlx5_devcom_comp_lock(esw->dev->priv.hca_devcom_comp);
@@ -2642,6 +2652,7 @@ static void esw_offloads_cleanup_reps(struct mlx5_eswitch *esw)
 	mlx5_esw_for_each_rep(esw, i, rep)
 		mlx5_esw_offloads_rep_cleanup(esw, rep);
 	xa_destroy(&esw->offloads.vport_reps);
+	mutex_destroy(&esw->offloads.reps_lock);
 }
 
 static int esw_offloads_init_reps(struct mlx5_eswitch *esw)
@@ -2651,6 +2662,7 @@ static int esw_offloads_init_reps(struct mlx5_eswitch *esw)
 	int err;
 
 	xa_init(&esw->offloads.vport_reps);
+	mutex_init(&esw->offloads.reps_lock);
 
 	mlx5_esw_for_each_vport(esw, i, vport) {
 		err = mlx5_esw_offloads_rep_add(esw, vport);
-- 
2.53.0



