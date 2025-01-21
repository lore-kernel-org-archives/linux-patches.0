Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0B521F63E2;
	Tue, 21 Jan 2025 17:58:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482326; cv=none; b=GGd/8u1IUary1E1178HfkSsQYGdNQ3n4SbPRsJgMN3eNflFGd0le5Ol/q+8ZGPhttGjgPz17KXX7VBXistESv0DqQ1DuKx6u2GSfyAPpZjXQJlXi9Ma+hbi6h8AIC3354QnLY2LlZHoyOjZ3I53nKvttW2BIIHJ0wylXG26Iy1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482326; c=relaxed/simple;
	bh=NiUQtnSlTzSjuoN9hyG2hkAw4fu55r8mgzWsvt7n16k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sn8iKCvuuH9dXbYzyorkqdYd/4bsQ0u5ibVRJ3e1J55IHgtpQDykENsu3LWYgrVoU81wSm3CalpOkcNFfPdx4wKuI8IB7kstVdWcqWBttEZJhFimVsHLthORQW5aqm+5j7XVYLlZSPoa201xG/D0YeHg/dN9G6brXcO4+zQmjg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eqdYBPGe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eqdYBPGe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48A47C4CEDF;
	Tue, 21 Jan 2025 17:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482326;
	bh=NiUQtnSlTzSjuoN9hyG2hkAw4fu55r8mgzWsvt7n16k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eqdYBPGeSha27b2PQUuYMrHRSv4MnD1FkQrYtJNina0MkOHf4/F66xnn+DTeZSNb+
	 ujWqD1A0AninRdKyCGjIOTwWA/Pz86fEsBtT1jHK8POiWbB8sT9jKBOBqupdKwS4vq
	 4j5GdcmLLCAIxkKFaaX4mIsA4syMc/kEmCSBY4Qc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 031/122] net/mlx5e: Always start IPsec sequence number from 1
Date: Tue, 21 Jan 2025 18:51:19 +0100
Message-ID: <20250121174534.191063369@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174532.991109301@linuxfoundation.org>
References: <20250121174532.991109301@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit 7f95b0247764acd739d949ff247db4b76138e55a ]

According to RFC4303, section "3.3.3. Sequence Number Generation",
the first packet sent using a given SA will contain a sequence
number of 1.

This is applicable to both ESN and non-ESN mode, which was not covered
in commit mentioned in Fixes line.

Fixes: 3d42c8cc67a8 ("net/mlx5e: Ensure that IPsec sequence packet number starts from 1")
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c  |  6 ++++++
 .../mellanox/mlx5/core/en_accel/ipsec_offload.c       | 11 ++++++++---
 2 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index 21857474ad83f..1baf8933a07cb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -724,6 +724,12 @@ static int mlx5e_xfrm_add_state(struct xfrm_state *x,
 	/* check esn */
 	if (x->props.flags & XFRM_STATE_ESN)
 		mlx5e_ipsec_update_esn_state(sa_entry);
+	else
+		/* According to RFC4303, section "3.3.3. Sequence Number Generation",
+		 * the first packet sent using a given SA will contain a sequence
+		 * number of 1.
+		 */
+		sa_entry->esn_state.esn = 1;
 
 	mlx5e_ipsec_build_accel_xfrm_attrs(sa_entry, &sa_entry->attrs);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
index 53cfa39188cb0..820debf3fbbf2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
@@ -91,8 +91,9 @@ u32 mlx5_ipsec_device_caps(struct mlx5_core_dev *mdev)
 EXPORT_SYMBOL_GPL(mlx5_ipsec_device_caps);
 
 static void mlx5e_ipsec_packet_setup(void *obj, u32 pdn,
-				     struct mlx5_accel_esp_xfrm_attrs *attrs)
+				     struct mlx5e_ipsec_sa_entry *sa_entry)
 {
+	struct mlx5_accel_esp_xfrm_attrs *attrs = &sa_entry->attrs;
 	void *aso_ctx;
 
 	aso_ctx = MLX5_ADDR_OF(ipsec_obj, obj, ipsec_aso);
@@ -120,8 +121,12 @@ static void mlx5e_ipsec_packet_setup(void *obj, u32 pdn,
 	 * active.
 	 */
 	MLX5_SET(ipsec_obj, obj, aso_return_reg, MLX5_IPSEC_ASO_REG_C_4_5);
-	if (attrs->dir == XFRM_DEV_OFFLOAD_OUT)
+	if (attrs->dir == XFRM_DEV_OFFLOAD_OUT) {
 		MLX5_SET(ipsec_aso, aso_ctx, mode, MLX5_IPSEC_ASO_INC_SN);
+		if (!attrs->replay_esn.trigger)
+			MLX5_SET(ipsec_aso, aso_ctx, mode_parameter,
+				 sa_entry->esn_state.esn);
+	}
 
 	if (attrs->lft.hard_packet_limit != XFRM_INF) {
 		MLX5_SET(ipsec_aso, aso_ctx, remove_flow_pkt_cnt,
@@ -175,7 +180,7 @@ static int mlx5_create_ipsec_obj(struct mlx5e_ipsec_sa_entry *sa_entry)
 
 	res = &mdev->mlx5e_res.hw_objs;
 	if (attrs->type == XFRM_DEV_OFFLOAD_PACKET)
-		mlx5e_ipsec_packet_setup(obj, res->pdn, attrs);
+		mlx5e_ipsec_packet_setup(obj, res->pdn, sa_entry);
 
 	err = mlx5_cmd_exec(mdev, in, sizeof(in), out, sizeof(out));
 	if (!err)
-- 
2.39.5



