Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBFE532C95D;
	Fri, 17 Oct 2025 15:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715121; cv=none; b=FJhdvkgM0CWBbtv7kJnxfbPqSfnPGVT6T3fSvoTKNUfz86whJqd6S8Kz3hKaPjRkyHZy0yzYO6k/plShIR8jBSHfc6pauNSfFYG9cXBJNVwGvMq7d0sULbjISLRT6F3uOLybskJO6Yfk6jcR0vMJkR/4Fu/wZ2P3xxeYJE0o+9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715121; c=relaxed/simple;
	bh=PORR6t8hxDRXzpyn3AYHKxEMrZE4eWHl7Stn3GRkoSo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C3BQk4d7DlrKF6XNB4kwPFj4OGPqEUqf3jh+EgyGee0OHE8VLU3FJlBpCW3WrQyZwqsdHfoSgspTPCJpYGfnm8tDla/FU3fts9WH+kTw5cFrxX9+9f3DGKESREsEE/reTMkmdDJLTKiA4BgM6JqlSX6F8cvtYTsE5gTw8vzvxqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gHQaq2fF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gHQaq2fF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 504FAC113D0;
	Fri, 17 Oct 2025 15:32:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715121;
	bh=PORR6t8hxDRXzpyn3AYHKxEMrZE4eWHl7Stn3GRkoSo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gHQaq2fFx2gs33JJRCd3pmzR9jxLiIh6LAX+hAScywQGe+r7SrpJmd11exgUFE2//
	 F1GcpW0kkuEQ4QfWfGVTMZQRrIviuZFUViAQ9gR3CXr7doqMIGEq5v4n0ieOFZWWBk
	 b75RD65WnxErsc5MltKiw5E+aZJqdaB2XPKRlXME=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carolina Jubran <cjubran@nvidia.com>,
	Jianbo Liu <jianbol@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 106/371] net/mlx5e: Prevent tunnel reformat when tunnel mode not allowed
Date: Fri, 17 Oct 2025 16:51:21 +0200
Message-ID: <20251017145205.773537044@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Carolina Jubran <cjubran@nvidia.com>

[ Upstream commit 22239eb258bc1e6ccdb2d3502fce1cc2b2a88386 ]

When configuring IPsec packet offload in tunnel mode, the driver tries
to create tunnel reformat objects unconditionally. This is incorrect,
because tunnel mode is only permitted under specific encapsulation
settings, and that decision is already made when the flow table is
created.

The offending commit attempted to block this case in the state add
path, but the check there happens too late and does not prevent the
reformat from being configured.

Fix by taking short reservations for both the eswitch mode and the
encap at the start of state setup. This preserves the block ordering
(mode --> encap) used later: the mode is blocked during RX/TX get, and
the encap is blocked during flow-table creation. This lets us fail
early if either reservation cannot be obtained, it means a mode
transition is underway or a conflicting configuration already owns
encap. If both succeed, the flow-table path later takes the ownership
and the reservations are released on exit.

Fixes: 146c196b60e4 ("net/mlx5e: Create IPsec table with tunnel support only when encap is disabled")
Signed-off-by: Carolina Jubran <cjubran@nvidia.com>
Reviewed-by: Jianbo Liu <jianbol@nvidia.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/1759652999-858513-3-git-send-email-tariqt@nvidia.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../mellanox/mlx5/core/en_accel/ipsec.c       | 38 +++++++++++++------
 .../mellanox/mlx5/core/en_accel/ipsec.h       |  2 +-
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c    | 24 +++++++-----
 3 files changed, 43 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index 00e77c71e201f..0a4fb8c922684 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -772,6 +772,7 @@ static int mlx5e_xfrm_add_state(struct net_device *dev,
 				struct netlink_ext_ack *extack)
 {
 	struct mlx5e_ipsec_sa_entry *sa_entry = NULL;
+	bool allow_tunnel_mode = false;
 	struct mlx5e_ipsec *ipsec;
 	struct mlx5e_priv *priv;
 	gfp_t gfp;
@@ -803,6 +804,20 @@ static int mlx5e_xfrm_add_state(struct net_device *dev,
 		goto err_xfrm;
 	}
 
+	if (mlx5_eswitch_block_mode(priv->mdev))
+		goto unblock_ipsec;
+
+	if (x->props.mode == XFRM_MODE_TUNNEL &&
+	    x->xso.type == XFRM_DEV_OFFLOAD_PACKET) {
+		allow_tunnel_mode = mlx5e_ipsec_fs_tunnel_allowed(sa_entry);
+		if (!allow_tunnel_mode) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Packet offload tunnel mode is disabled due to encap settings");
+			err = -EINVAL;
+			goto unblock_mode;
+		}
+	}
+
 	/* check esn */
 	if (x->props.flags & XFRM_STATE_ESN)
 		mlx5e_ipsec_update_esn_state(sa_entry);
@@ -817,7 +832,7 @@ static int mlx5e_xfrm_add_state(struct net_device *dev,
 
 	err = mlx5_ipsec_create_work(sa_entry);
 	if (err)
-		goto unblock_ipsec;
+		goto unblock_encap;
 
 	err = mlx5e_ipsec_create_dwork(sa_entry);
 	if (err)
@@ -832,14 +847,6 @@ static int mlx5e_xfrm_add_state(struct net_device *dev,
 	if (err)
 		goto err_hw_ctx;
 
-	if (x->props.mode == XFRM_MODE_TUNNEL &&
-	    x->xso.type == XFRM_DEV_OFFLOAD_PACKET &&
-	    !mlx5e_ipsec_fs_tunnel_enabled(sa_entry)) {
-		NL_SET_ERR_MSG_MOD(extack, "Packet offload tunnel mode is disabled due to encap settings");
-		err = -EINVAL;
-		goto err_add_rule;
-	}
-
 	/* We use *_bh() variant because xfrm_timer_handler(), which runs
 	 * in softirq context, can reach our state delete logic and we need
 	 * xa_erase_bh() there.
@@ -855,8 +862,7 @@ static int mlx5e_xfrm_add_state(struct net_device *dev,
 		queue_delayed_work(ipsec->wq, &sa_entry->dwork->dwork,
 				   MLX5_IPSEC_RESCHED);
 
-	if (x->xso.type == XFRM_DEV_OFFLOAD_PACKET &&
-	    x->props.mode == XFRM_MODE_TUNNEL) {
+	if (allow_tunnel_mode) {
 		xa_lock_bh(&ipsec->sadb);
 		__xa_set_mark(&ipsec->sadb, sa_entry->ipsec_obj_id,
 			      MLX5E_IPSEC_TUNNEL_SA);
@@ -865,6 +871,11 @@ static int mlx5e_xfrm_add_state(struct net_device *dev,
 
 out:
 	x->xso.offload_handle = (unsigned long)sa_entry;
+	if (allow_tunnel_mode)
+		mlx5_eswitch_unblock_encap(priv->mdev);
+
+	mlx5_eswitch_unblock_mode(priv->mdev);
+
 	return 0;
 
 err_add_rule:
@@ -877,6 +888,11 @@ static int mlx5e_xfrm_add_state(struct net_device *dev,
 	if (sa_entry->work)
 		kfree(sa_entry->work->data);
 	kfree(sa_entry->work);
+unblock_encap:
+	if (allow_tunnel_mode)
+		mlx5_eswitch_unblock_encap(priv->mdev);
+unblock_mode:
+	mlx5_eswitch_unblock_mode(priv->mdev);
 unblock_ipsec:
 	mlx5_eswitch_unblock_ipsec(priv->mdev);
 err_xfrm:
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
index 23703f28386ad..5d7c15abfcaf6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
@@ -319,7 +319,7 @@ void mlx5e_accel_ipsec_fs_del_rule(struct mlx5e_ipsec_sa_entry *sa_entry);
 int mlx5e_accel_ipsec_fs_add_pol(struct mlx5e_ipsec_pol_entry *pol_entry);
 void mlx5e_accel_ipsec_fs_del_pol(struct mlx5e_ipsec_pol_entry *pol_entry);
 void mlx5e_accel_ipsec_fs_modify(struct mlx5e_ipsec_sa_entry *sa_entry);
-bool mlx5e_ipsec_fs_tunnel_enabled(struct mlx5e_ipsec_sa_entry *sa_entry);
+bool mlx5e_ipsec_fs_tunnel_allowed(struct mlx5e_ipsec_sa_entry *sa_entry);
 
 int mlx5_ipsec_create_sa_ctx(struct mlx5e_ipsec_sa_entry *sa_entry);
 void mlx5_ipsec_free_sa_ctx(struct mlx5e_ipsec_sa_entry *sa_entry);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
index b525f3f21c51f..9e23652535638 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
@@ -2826,18 +2826,24 @@ void mlx5e_accel_ipsec_fs_modify(struct mlx5e_ipsec_sa_entry *sa_entry)
 	memcpy(sa_entry, &sa_entry_shadow, sizeof(*sa_entry));
 }
 
-bool mlx5e_ipsec_fs_tunnel_enabled(struct mlx5e_ipsec_sa_entry *sa_entry)
+bool mlx5e_ipsec_fs_tunnel_allowed(struct mlx5e_ipsec_sa_entry *sa_entry)
 {
-	struct mlx5_accel_esp_xfrm_attrs *attrs = &sa_entry->attrs;
-	struct mlx5e_ipsec_rx *rx;
-	struct mlx5e_ipsec_tx *tx;
+	struct mlx5e_ipsec *ipsec = sa_entry->ipsec;
+	struct xfrm_state *x = sa_entry->x;
+	bool from_fdb;
 
-	rx = ipsec_rx(sa_entry->ipsec, attrs->addrs.family, attrs->type);
-	tx = ipsec_tx(sa_entry->ipsec, attrs->type);
-	if (sa_entry->attrs.dir == XFRM_DEV_OFFLOAD_OUT)
-		return tx->allow_tunnel_mode;
+	if (x->xso.dir == XFRM_DEV_OFFLOAD_OUT) {
+		struct mlx5e_ipsec_tx *tx = ipsec_tx(ipsec, x->xso.type);
+
+		from_fdb = (tx == ipsec->tx_esw);
+	} else {
+		struct mlx5e_ipsec_rx *rx = ipsec_rx(ipsec, x->props.family,
+						     x->xso.type);
+
+		from_fdb = (rx == ipsec->rx_esw);
+	}
 
-	return rx->allow_tunnel_mode;
+	return mlx5_eswitch_block_encap(ipsec->mdev, from_fdb);
 }
 
 void mlx5e_ipsec_handle_mpv_event(int event, struct mlx5e_priv *slave_priv,
-- 
2.51.0



