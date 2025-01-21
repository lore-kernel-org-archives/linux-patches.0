Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B47041E9B38;
	Tue, 21 Jan 2025 17:54:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482046; cv=none; b=LVBdC/HigGF8pDgF4ZCQ42ZyJVZXVoOzJetJ9P55i47Io/By42vLf66qafvOBdtLjhaDw4vsWQUjGwD/XrTfKwoK50tXyJesus3dhtmxr5nwBfCo+bt2y8JeikuLiwGNmlqFHQQJpQRXSj6PNcCqZsRojF9vdMoSMpEmqH7SSms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482046; c=relaxed/simple;
	bh=H3zocbM/MusqMJHS5xNeliYqFJYcvnKNTaJDDYNCO5E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NjBQJ+x0Gky2C99YsI7z7kCBBG+Lm7djzWuF/nCe8AFZESvC/a3IZcjNlo+Trb0ln56Q5547GFWPAr/kQ4/TJKzjLW5aJB0wX/WDUWhOWeZp5f0/xq6SXJcs/eti4G4uDiR8AcaVkNMl7EVKQg0zdZhdXmG2amSArUohnOBAJg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ihmdsusz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ihmdsusz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9649C4CEDF;
	Tue, 21 Jan 2025 17:54:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482046;
	bh=H3zocbM/MusqMJHS5xNeliYqFJYcvnKNTaJDDYNCO5E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ihmdsusznCVvKq2u62/eNy+KXm65oIaUODZKwhShOmvSb0BCmJzSwhJ9tQzS0M02l
	 TwS4Nich6OvBvTIQNGbmZDqcJvHOnY37zr2CqahSSPmpi9S76UzQXLGQf6YqsDR/ry
	 KEYCSOM/kF7tehD3w7NbH+eBcjJpHgaQrEogGBy4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 16/72] net/mlx5e: Always start IPsec sequence number from 1
Date: Tue, 21 Jan 2025 18:51:42 +0100
Message-ID: <20250121174524.051656261@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174523.429119852@linuxfoundation.org>
References: <20250121174523.429119852@linuxfoundation.org>
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
index 9fc6dbc83d141..463c23ae0ad1e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -719,6 +719,12 @@ static int mlx5e_xfrm_add_state(struct xfrm_state *x,
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
index de83567aae791..940e350058d10 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
@@ -90,8 +90,9 @@ u32 mlx5_ipsec_device_caps(struct mlx5_core_dev *mdev)
 EXPORT_SYMBOL_GPL(mlx5_ipsec_device_caps);
 
 static void mlx5e_ipsec_packet_setup(void *obj, u32 pdn,
-				     struct mlx5_accel_esp_xfrm_attrs *attrs)
+				     struct mlx5e_ipsec_sa_entry *sa_entry)
 {
+	struct mlx5_accel_esp_xfrm_attrs *attrs = &sa_entry->attrs;
 	void *aso_ctx;
 
 	aso_ctx = MLX5_ADDR_OF(ipsec_obj, obj, ipsec_aso);
@@ -119,8 +120,12 @@ static void mlx5e_ipsec_packet_setup(void *obj, u32 pdn,
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
@@ -173,7 +178,7 @@ static int mlx5_create_ipsec_obj(struct mlx5e_ipsec_sa_entry *sa_entry)
 
 	res = &mdev->mlx5e_res.hw_objs;
 	if (attrs->type == XFRM_DEV_OFFLOAD_PACKET)
-		mlx5e_ipsec_packet_setup(obj, res->pdn, attrs);
+		mlx5e_ipsec_packet_setup(obj, res->pdn, sa_entry);
 
 	err = mlx5_cmd_exec(mdev, in, sizeof(in), out, sizeof(out));
 	if (!err)
-- 
2.39.5



