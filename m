Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 962EA335BCD;
	Fri,  9 Jan 2026 12:35:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962152; cv=none; b=F463WbxFORrG/lPZs1D9cqjG7sH+v2j5pKyBA+iGEDA86q2maRJdCiVblyEPHg/uIJmmFIwuYARM10JNxV3f0fEbzSKmU9HXCRVnWheKaIv7T+TqBvbervbk6j2q+NkJ8dph0fWpt6bFvTizk92VaP5B/4jNd62JVnWPr6vuGow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962152; c=relaxed/simple;
	bh=8kF99doKl7yBNxxP40HB1pCrl4vGYjdLhkYUHPZ2k9g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JVE0vaJ8j6NG3/JJXkpFxSRmaPKI6BJ7szixVy83CSj3Bci0ZaWW+2e/OyQ1IUAzASeW79rhhg7fUc3OESYHdZDpxCnepYOGE5faKoqzAn7dABZVtn3t9H9G+SpGZGK1bB0raEuB9QeKs4DYaLIlvQKq+VQBjvhhGN98gLn+bnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kgwJtK24; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kgwJtK24"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCF84C4CEF1;
	Fri,  9 Jan 2026 12:35:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962152;
	bh=8kF99doKl7yBNxxP40HB1pCrl4vGYjdLhkYUHPZ2k9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kgwJtK24hIMzsMO6eHCPwMr3P+gqhqqU+3yi73kGNvlvt0fbjMAmDCArGAE5nG0tE
	 bCI93fkZ4hW2bmT0ZRUIs8juJyifRpUYCSenak5NJn+5A1R34VVOzzOfwR7R3JF9IZ
	 fca+GR4KlPFLOqjV0nnRfG7puW0elzyGXrWlOms0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Parav Pandit <parav@mellanox.com>,
	Bodong Wang <bodong@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 264/634] net/mlx5: Create a new profile for SFs
Date: Fri,  9 Jan 2026 12:39:02 +0100
Message-ID: <20260109112127.470717539@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Parav Pandit <parav@mellanox.com>

[ Upstream commit 9df839a711aee437390b16ee39cf0b5c1620be6a ]

Create a new profile for SFs in order to disable the command cache.
Each function command cache consumes ~500KB of memory, when using a
large number of SFs this savings is notable on memory constarined
systems.

Use a new profile to provide for future differences between SFs and PFs.

The mr_cache not used for non-PF functions, so it is excluded from the
new profile.

Signed-off-by: Parav Pandit <parav@mellanox.com>
Reviewed-by: Bodong Wang <bodong@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Stable-dep-of: 5846a365fc64 ("net/mlx5: Drain firmware reset in shutdown callback")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c           | 6 +++---
 drivers/net/ethernet/mellanox/mlx5/core/main.c          | 9 +++++++++
 drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h     | 1 +
 drivers/net/ethernet/mellanox/mlx5/core/sf/dev/driver.c | 2 +-
 include/linux/mlx5/driver.h                             | 1 +
 5 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
index 4c614a256ee05..ff45b7b5e1c21 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -1833,7 +1833,7 @@ static struct mlx5_cmd_msg *alloc_msg(struct mlx5_core_dev *dev, int in_size,
 	if (in_size <= 16)
 		goto cache_miss;
 
-	for (i = 0; i < MLX5_NUM_COMMAND_CACHES; i++) {
+	for (i = 0; i < dev->profile.num_cmd_caches; i++) {
 		ch = &cmd->cache[i];
 		if (in_size > ch->max_inbox_size)
 			continue;
@@ -2129,7 +2129,7 @@ static void destroy_msg_cache(struct mlx5_core_dev *dev)
 	struct mlx5_cmd_msg *n;
 	int i;
 
-	for (i = 0; i < MLX5_NUM_COMMAND_CACHES; i++) {
+	for (i = 0; i < dev->profile.num_cmd_caches; i++) {
 		ch = &dev->cmd.cache[i];
 		list_for_each_entry_safe(msg, n, &ch->head, list) {
 			list_del(&msg->list);
@@ -2159,7 +2159,7 @@ static void create_msg_cache(struct mlx5_core_dev *dev)
 	int k;
 
 	/* Initialize and fill the caches with initial entries */
-	for (k = 0; k < MLX5_NUM_COMMAND_CACHES; k++) {
+	for (k = 0; k < dev->profile.num_cmd_caches; k++) {
 		ch = &cmd->cache[k];
 		spin_lock_init(&ch->lock);
 		INIT_LIST_HEAD(&ch->head);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index a53f222e3feed..891b625a6dc71 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -103,15 +103,19 @@ enum {
 static struct mlx5_profile profile[] = {
 	[0] = {
 		.mask           = 0,
+		.num_cmd_caches = MLX5_NUM_COMMAND_CACHES,
 	},
 	[1] = {
 		.mask		= MLX5_PROF_MASK_QP_SIZE,
 		.log_max_qp	= 12,
+		.num_cmd_caches = MLX5_NUM_COMMAND_CACHES,
+
 	},
 	[2] = {
 		.mask		= MLX5_PROF_MASK_QP_SIZE |
 				  MLX5_PROF_MASK_MR_CACHE,
 		.log_max_qp	= LOG_MAX_SUPPORTED_QPS,
+		.num_cmd_caches = MLX5_NUM_COMMAND_CACHES,
 		.mr_cache[0]	= {
 			.size	= 500,
 			.limit	= 250
@@ -177,6 +181,11 @@ static struct mlx5_profile profile[] = {
 			.limit	= 4
 		},
 	},
+	[3] = {
+		.mask		= MLX5_PROF_MASK_QP_SIZE,
+		.log_max_qp	= LOG_MAX_SUPPORTED_QPS,
+		.num_cmd_caches = 0,
+	},
 };
 
 static int wait_fw_init(struct mlx5_core_dev *dev, u32 max_wait_mili,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
index 7d90f311b8560..07b5c86fc26a4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
@@ -142,6 +142,7 @@ enum mlx5_semaphore_space_address {
 };
 
 #define MLX5_DEFAULT_PROF       2
+#define MLX5_SF_PROF		3
 
 static inline int mlx5_flexible_inlen(struct mlx5_core_dev *dev, size_t fixed,
 				      size_t item_size, size_t num_items,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/driver.c b/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/driver.c
index d6850eb0ed7f4..f314ad1e8c312 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/driver.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/driver.c
@@ -28,7 +28,7 @@ static int mlx5_sf_dev_probe(struct auxiliary_device *adev, const struct auxilia
 	mdev->priv.adev_idx = adev->id;
 	sf_dev->mdev = mdev;
 
-	err = mlx5_mdev_init(mdev, MLX5_DEFAULT_PROF);
+	err = mlx5_mdev_init(mdev, MLX5_SF_PROF);
 	if (err) {
 		mlx5_core_warn(mdev, "mlx5_mdev_init on err=%d\n", err);
 		goto mdev_err;
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 9af7180eac9e3..0e8705c3a460d 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -755,6 +755,7 @@ enum {
 struct mlx5_profile {
 	u64	mask;
 	u8	log_max_qp;
+	u8	num_cmd_caches;
 	struct {
 		int	size;
 		int	limit;
-- 
2.51.0



