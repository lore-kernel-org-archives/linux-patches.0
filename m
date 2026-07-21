Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E281A400E17;
	Tue, 21 Jul 2026 18:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658181; cv=none; b=HcaPXduiCcin2dvFjBwdW1waktKdQc9gmVsJ1X4/+ktBDkjc53/W6JHpZlg2Ncr4evwyIHxf9YKR8J45Hh88hgxwR7JnU1F7y+mMXdlwAIHzE/pAkvxCvMkLigChAeXsJA2A9lfoW12A8YD2va0DHJwpxP2IcmaSsW25cuwem4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658181; c=relaxed/simple;
	bh=sVf5bTXL6ACc3IrIMTfqZolzwVQ12iKZ3Wlwx6Psh3A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=suCIKYW2LzctT32koyOPGqQfsDbundS8ritoIJCXkJDaY4CkXFWQS9qgyDVdZjda3+03zjILXG4JATY+PrYLkfBqNkvhU9f5L3J3kF5Hd9Gw+t499ng0u3jUtxf6FKYrVO2adQSlHCKk/yxzrm+DDu36CldqLGEIIEaq6BnqNaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i0zfbOHz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i0zfbOHz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BD591F00A3A;
	Tue, 21 Jul 2026 18:22:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658179;
	bh=B4nj+aOMxPt2T1g37GO+23AmCnGNMPONCIZR5h2Ue2o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i0zfbOHzIVZpQHs99GdH+3KlSzLvbhqwluur7BhQW8SdoMDqleo38+O7xzCpOjyhv
	 b/R2cgH1rfevyavZV6UlAOqTR37qx9ETfcpxZv1djunQzqu0LKS5+o8SgKuA5JMeYa
	 O4+4z6O0e92WdNudqh30xCVpqNx1pFyfOix3r5KA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Feng Liu <feliu@nvidia.com>,
	Eran Ben Elisha <eranbe@nvidia.com>,
	Cosmin Ratiu <cratiu@nvidia.com>,
	Nimrod Oren <noren@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1046/1611] net/mlx5e: Fix publication race for priv->channel_stats[]
Date: Tue, 21 Jul 2026 17:19:22 +0200
Message-ID: <20260721152538.933464953@linuxfoundation.org>
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

From: Feng Liu <feliu@nvidia.com>

[ Upstream commit 5a799714e8ca0bce9ea40694f49914cf1adbbaa9 ]

mlx5e_channel_stats_alloc() publishes a new entry to
priv->channel_stats[] and then increments priv->stats_nch as a
publication token, but neither store carries any memory barrier:

	priv->channel_stats[ix] = kvzalloc_node(...);
	if (!priv->channel_stats[ix])
		return -ENOMEM;
	priv->stats_nch++;

Concurrent readers compute the loop bound from priv->stats_nch and
then dereference priv->channel_stats[i] using plain accesses, e.g.

	for (i = 0; i < priv->stats_nch; i++) {
		struct mlx5e_channel_stats *cs = priv->channel_stats[i];
		... cs->rq.packets ...
	}

On weakly-ordered architectures (ARM, PowerPC, RISC-V) the writes to
channel_stats[ix] and stats_nch may become visible to other CPUs out
of program order. A reader can observe stats_nch == N while still
seeing channel_stats[N-1] == NULL, leading to a NULL pointer
dereference in the channel_stats loop.

This has been observed in production on BlueField-3 DPUs (arm64),
where ovs-vswitchd queries netdev statistics over netlink during NIC
bringup, racing mlx5e_open_channel() -> mlx5e_channel_stats_alloc()
on another CPU:

  Unable to handle kernel NULL pointer dereference at virtual address 0x840
  Hardware name: BlueField-3 DPU
  pc : mlx5e_fold_sw_stats64+0x30/0x180 [mlx5_core]
  Call trace:
   mlx5e_fold_sw_stats64+0x30/0x180 [mlx5_core]
   dev_get_stats+0x50/0xc0
   ovs_vport_get_stats+0x38/0xac [openvswitch]
   ovs_vport_cmd_fill_info+0x194/0x290 [openvswitch]
   ovs_vport_cmd_get+0xbc/0x10c [openvswitch]
   genl_family_rcv_msg_doit+0xd0/0x160
   genl_rcv_msg+0xec/0x1f0
   netlink_rcv_skb+0x64/0x130
   genl_rcv+0x40/0x60
   netlink_unicast+0x2fc/0x370
   netlink_sendmsg+0x1dc/0x454
   ...
   __arm64_sys_sendmsg+0x2c/0x40

Add mlx5e_stats_nch_write() and mlx5e_stats_nch_read() helpers in en.h
that wrap the smp_store_release()/smp_load_acquire() pair on stats_nch.
The release/acquire pair establishes the contract:

  stats_nch == N  =>  channel_stats[0..N-1] are visible and non-NULL.

Publish the stats_nch increment via mlx5e_stats_nch_write() in the
writer (mlx5e_channel_stats_alloc()), and read stats_nch via
mlx5e_stats_nch_read() in all readers: mlx5e RX/TX queue stats,
mlx5e_get_base_stats(), ethtool channels stats, IPoIB stats, the
sw_stats fold and the HV VHCA stats agent.

Fixes: fa691d0c9c08 ("net/mlx5e: Allocate per-channel stats dynamically at first usage")
Signed-off-by: Feng Liu <feliu@nvidia.com>
Reviewed-by: Eran Ben Elisha <eranbe@nvidia.com>
Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
Reviewed-by: Nimrod Oren <noren@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20260630115151.729219-4-tariqt@nvidia.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h       | 12 ++++++++++++
 .../ethernet/mellanox/mlx5/core/en/hv_vhca_stats.c | 10 ++++++----
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  | 14 ++++++++------
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.c |  9 +++++----
 .../net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c  |  3 ++-
 5 files changed, 33 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 5bced924a24fb5..3d8276a0692fc1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -963,6 +963,18 @@ struct mlx5e_priv {
 	struct ethtool_fec_hist_range *fec_ranges;
 };
 
+static inline u16 mlx5e_stats_nch_read(const struct mlx5e_priv *priv)
+{
+	/* Pairs with smp_store_release in mlx5e_stats_nch_write(). */
+	return smp_load_acquire(&priv->stats_nch);
+}
+
+static inline void mlx5e_stats_nch_write(struct mlx5e_priv *priv, u16 n)
+{
+	/* Pairs with smp_load_acquire in mlx5e_stats_nch_read(). */
+	smp_store_release(&priv->stats_nch, n);
+}
+
 struct mlx5e_dev {
 	struct net_device *netdev;
 	struct devlink_port dl_port;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/hv_vhca_stats.c b/drivers/net/ethernet/mellanox/mlx5/core/en/hv_vhca_stats.c
index cdaf77650164b9..631f802105d5bf 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/hv_vhca_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/hv_vhca_stats.c
@@ -33,9 +33,10 @@ mlx5e_hv_vhca_fill_ring_stats(struct mlx5e_priv *priv, int ch,
 static void mlx5e_hv_vhca_fill_stats(struct mlx5e_priv *priv, void *data,
 				     int buf_len)
 {
+	u16 nch = mlx5e_stats_nch_read(priv);
 	int ch, i = 0;
 
-	for (ch = 0; ch < priv->stats_nch; ch++) {
+	for (ch = 0; ch < nch; ch++) {
 		void *buf = data + i;
 
 		if (WARN_ON_ONCE(buf +
@@ -50,8 +51,9 @@ static void mlx5e_hv_vhca_fill_stats(struct mlx5e_priv *priv, void *data,
 
 static int mlx5e_hv_vhca_stats_buf_size(struct mlx5e_priv *priv)
 {
-	return (sizeof(struct mlx5e_hv_vhca_per_ring_stats) *
-		priv->stats_nch);
+	u16 nch = mlx5e_stats_nch_read(priv);
+
+	return sizeof(struct mlx5e_hv_vhca_per_ring_stats) * nch;
 }
 
 static int mlx5e_hv_vhca_stats_buf_max_size(struct mlx5e_priv *priv)
@@ -106,7 +108,7 @@ static void mlx5e_hv_vhca_stats_control(struct mlx5_hv_vhca_agent *agent,
 	sagent = &priv->stats_agent;
 
 	block->version = MLX5_HV_VHCA_STATS_VERSION;
-	block->rings   = priv->stats_nch;
+	block->rings   = mlx5e_stats_nch_read(priv);
 
 	if (!block->command) {
 		cancel_delayed_work_sync(&priv->stats_agent.work);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index a696fb88dbef9f..f660ef37b0a631 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -2718,7 +2718,7 @@ static int mlx5e_channel_stats_alloc(struct mlx5e_priv *priv, int ix, int cpu)
 						GFP_KERNEL, cpu_to_node(cpu));
 	if (!priv->channel_stats[ix])
 		return -ENOMEM;
-	priv->stats_nch++;
+	mlx5e_stats_nch_write(priv, priv->stats_nch + 1);
 
 	return 0;
 }
@@ -3951,9 +3951,10 @@ static int mlx5e_setup_tc(struct net_device *dev, enum tc_setup_type type,
 
 void mlx5e_fold_sw_stats64(struct mlx5e_priv *priv, struct rtnl_link_stats64 *s)
 {
+	u16 nch = mlx5e_stats_nch_read(priv);
 	int i;
 
-	for (i = 0; i < priv->stats_nch; i++) {
+	for (i = 0; i < nch; i++) {
 		struct mlx5e_channel_stats *channel_stats = priv->channel_stats[i];
 		struct mlx5e_rq_stats *xskrq_stats = &channel_stats->xskrq;
 		struct mlx5e_rq_stats *rq_stats = &channel_stats->rq;
@@ -5411,7 +5412,7 @@ static void mlx5e_get_queue_stats_rx(struct net_device *dev, int i,
 	struct mlx5e_rq_stats *xskrq_stats;
 	struct mlx5e_rq_stats *rq_stats;
 
-	if (mlx5e_is_uplink_rep(priv) || !priv->stats_nch)
+	if (mlx5e_is_uplink_rep(priv) || !mlx5e_stats_nch_read(priv))
 		return;
 
 	channel_stats = priv->channel_stats[i];
@@ -5430,7 +5431,7 @@ static void mlx5e_get_queue_stats_tx(struct net_device *dev, int i,
 	struct mlx5e_priv *priv = netdev_priv(dev);
 	struct mlx5e_sq_stats *sq_stats;
 
-	if (!priv->stats_nch)
+	if (!mlx5e_stats_nch_read(priv))
 		return;
 
 	/* no special case needed for ptp htb etc since txq2sq_stats is kept up
@@ -5447,6 +5448,7 @@ static void mlx5e_get_base_stats(struct net_device *dev,
 				 struct netdev_queue_stats_tx *tx)
 {
 	struct mlx5e_priv *priv = netdev_priv(dev);
+	u16 nch = mlx5e_stats_nch_read(priv);
 	struct mlx5e_ptp *ptp_channel;
 	int i, tc;
 
@@ -5455,7 +5457,7 @@ static void mlx5e_get_base_stats(struct net_device *dev,
 		rx->bytes = 0;
 		rx->alloc_fail = 0;
 
-		for (i = priv->channels.params.num_channels; i < priv->stats_nch; i++) {
+		for (i = priv->channels.params.num_channels; i < nch; i++) {
 			struct netdev_queue_stats_rx rx_i = {0};
 
 			mlx5e_get_queue_stats_rx(dev, i, &rx_i);
@@ -5480,7 +5482,7 @@ static void mlx5e_get_base_stats(struct net_device *dev,
 	tx->packets = 0;
 	tx->bytes = 0;
 
-	for (i = 0; i < priv->stats_nch; i++) {
+	for (i = 0; i < nch; i++) {
 		struct mlx5e_channel_stats *channel_stats = priv->channel_stats[i];
 
 		/* handle two cases:
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
index a8af84fc976383..5ae501f4483383 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
@@ -516,6 +516,7 @@ static void mlx5e_stats_update_stats_rq_page_pool(struct mlx5e_channel *c)
 static MLX5E_DECLARE_STATS_GRP_OP_UPDATE_STATS(sw)
 {
 	struct mlx5e_sw_stats *s = &priv->stats.sw;
+	u16 nch = mlx5e_stats_nch_read(priv);
 	int i;
 
 	memset(s, 0, sizeof(*s));
@@ -523,7 +524,7 @@ static MLX5E_DECLARE_STATS_GRP_OP_UPDATE_STATS(sw)
 	for (i = 0; i < priv->channels.num; i++) /* for active channels only */
 		mlx5e_stats_update_stats_rq_page_pool(priv->channels.c[i]);
 
-	for (i = 0; i < priv->stats_nch; i++) {
+	for (i = 0; i < nch; i++) {
 		struct mlx5e_channel_stats *channel_stats =
 			priv->channel_stats[i];
 
@@ -2585,7 +2586,7 @@ static MLX5E_DECLARE_STATS_GRP_OP_UPDATE_STATS(ptp) { return; }
 
 static MLX5E_DECLARE_STATS_GRP_OP_NUM_STATS(channels)
 {
-	int max_nch = priv->stats_nch;
+	int max_nch = mlx5e_stats_nch_read(priv);
 
 	return (NUM_RQ_STATS * max_nch) +
 	       (NUM_CH_STATS * max_nch) +
@@ -2598,8 +2599,8 @@ static MLX5E_DECLARE_STATS_GRP_OP_NUM_STATS(channels)
 
 static MLX5E_DECLARE_STATS_GRP_OP_FILL_STRS(channels)
 {
+	int max_nch = mlx5e_stats_nch_read(priv);
 	bool is_xsk = priv->xsk.ever_used;
-	int max_nch = priv->stats_nch;
 	int i, j, tc;
 
 	for (i = 0; i < max_nch; i++)
@@ -2631,8 +2632,8 @@ static MLX5E_DECLARE_STATS_GRP_OP_FILL_STRS(channels)
 
 static MLX5E_DECLARE_STATS_GRP_OP_FILL_STATS(channels)
 {
+	int max_nch = mlx5e_stats_nch_read(priv);
 	bool is_xsk = priv->xsk.ever_used;
-	int max_nch = priv->stats_nch;
 	int i, j, tc;
 
 	for (i = 0; i < max_nch; i++)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
index 79ae3a51a4b3e2..58fd7a893b6b65 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
@@ -117,10 +117,11 @@ void mlx5i_cleanup(struct mlx5e_priv *priv)
 
 static void mlx5i_grp_sw_update_stats(struct mlx5e_priv *priv)
 {
+	u16 nch = mlx5e_stats_nch_read(priv);
 	struct rtnl_link_stats64 s = {};
 	int i, j;
 
-	for (i = 0; i < priv->stats_nch; i++) {
+	for (i = 0; i < nch; i++) {
 		struct mlx5e_channel_stats *channel_stats;
 		struct mlx5e_rq_stats *rq_stats;
 
-- 
2.53.0



