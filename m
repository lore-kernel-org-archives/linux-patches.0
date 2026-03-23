Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87FDE27E1A1;
	Mon, 23 Mar 2026 15:21:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774279303; cv=none; b=OgAeexM2bzJfSZ3MPFQNBoEEIM4Z2nI15TjeCRZaY91lvAhfKLTqrZYOaW9PF3IjULhX1J4ghw0geR04W8ZU5E/cYb3zbu90QQVRQQrtaAyGBuvlB/5QfSKSpT4LMtN8BAi3FKv6rz2MB90D6ahw6J6fcRBXAAL8/1CbGRilLdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774279303; c=relaxed/simple;
	bh=oXlKOJ9JxYDviLkAD3YymJBAV23mOaksRim9czH+OwE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XWoAcmFFhEdhJKiwTINRnOPPKskbAHamkIsuskb0z1qMwimOgSjeQXLZSMQesP2JxyLB+7tVmk2hgdepfN0nnKvTYYleRWHgp4g/0v9twN09X07ZDHKCLxw1vzXZPSauObIH3/OXia5L32ZfJUBnDBaXK+ii6iBjuzFbBIhCH8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nuv0dvJx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nuv0dvJx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11BF2C4CEF7;
	Mon, 23 Mar 2026 15:21:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774279303;
	bh=oXlKOJ9JxYDviLkAD3YymJBAV23mOaksRim9czH+OwE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nuv0dvJxSkCEXlL7pL7YQxfEEEXLHmrSt+3UL3HqJyiQGhHtSr2GRT9WVzZksXqS7
	 ASoaPWfJ6goDgcxP+po99STvE6bzdG0QMgT9YJ7vsdny2YvV8IahIV3hqWFq+CcItT
	 r3OUgiK7PKlr75GnW64DUkAqZkD3zpemX6/bSwUw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianbo Liu <jianbol@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 540/567] net/mlx5e: Fix race condition during IPSec ESN update
Date: Mon, 23 Mar 2026 14:47:40 +0100
Message-ID: <20260323134547.366984708@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jianbo Liu <jianbol@nvidia.com>

[ Upstream commit beb6e2e5976a128b0cccf10d158124422210c5ef ]

In IPSec full offload mode, the device reports an ESN (Extended
Sequence Number) wrap event to the driver. The driver validates this
event by querying the IPSec ASO and checking that the esn_event_arm
field is 0x0, which indicates an event has occurred. After handling
the event, the driver must re-arm the context by setting esn_event_arm
back to 0x1.

A race condition exists in this handling path. After validating the
event, the driver calls mlx5_accel_esp_modify_xfrm() to update the
kernel's xfrm state. This function temporarily releases and
re-acquires the xfrm state lock.

So, need to acknowledge the event first by setting esn_event_arm to
0x1. This prevents the driver from reprocessing the same ESN update if
the hardware sends events for other reason. Since the next ESN update
only occurs after nearly 2^31 packets are received, there's no risk of
missing an update, as it will happen long after this handling has
finished.

Processing the event twice causes the ESN high-order bits (esn_msb) to
be incremented incorrectly. The driver then programs the hardware with
this invalid ESN state, which leads to anti-replay failures and a
complete halt of IPSec traffic.

Fix this by re-arming the ESN event immediately after it is validated,
before calling mlx5_accel_esp_modify_xfrm(). This ensures that any
spurious, duplicate events are correctly ignored, closing the race
window.

Fixes: fef06678931f ("net/mlx5e: Fix ESN update kernel panic")
Signed-off-by: Jianbo Liu <jianbol@nvidia.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20260316094603.6999-4-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../mlx5/core/en_accel/ipsec_offload.c        | 33 ++++++++-----------
 1 file changed, 14 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
index eab368dea0e27..fd03aa4f47b5a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
@@ -309,10 +309,11 @@ static void mlx5e_ipsec_aso_update(struct mlx5e_ipsec_sa_entry *sa_entry,
 	mlx5e_ipsec_aso_query(sa_entry, data);
 }
 
-static void mlx5e_ipsec_update_esn_state(struct mlx5e_ipsec_sa_entry *sa_entry,
-					 u32 mode_param)
+static void
+mlx5e_ipsec_update_esn_state(struct mlx5e_ipsec_sa_entry *sa_entry,
+			     u32 mode_param,
+			     struct mlx5_accel_esp_xfrm_attrs *attrs)
 {
-	struct mlx5_accel_esp_xfrm_attrs attrs = {};
 	struct mlx5_wqe_aso_ctrl_seg data = {};
 
 	if (mode_param < MLX5E_IPSEC_ESN_SCOPE_MID) {
@@ -322,18 +323,7 @@ static void mlx5e_ipsec_update_esn_state(struct mlx5e_ipsec_sa_entry *sa_entry,
 		sa_entry->esn_state.overlap = 1;
 	}
 
-	mlx5e_ipsec_build_accel_xfrm_attrs(sa_entry, &attrs);
-
-	/* It is safe to execute the modify below unlocked since the only flows
-	 * that could affect this HW object, are create, destroy and this work.
-	 *
-	 * Creation flow can't co-exist with this modify work, the destruction
-	 * flow would cancel this work, and this work is a single entity that
-	 * can't conflict with it self.
-	 */
-	spin_unlock_bh(&sa_entry->x->lock);
-	mlx5_accel_esp_modify_xfrm(sa_entry, &attrs);
-	spin_lock_bh(&sa_entry->x->lock);
+	mlx5e_ipsec_build_accel_xfrm_attrs(sa_entry, attrs);
 
 	data.data_offset_condition_operand =
 		MLX5_IPSEC_ASO_REMOVE_FLOW_PKT_CNT_OFFSET;
@@ -450,7 +440,9 @@ static void mlx5e_ipsec_handle_event(struct work_struct *_work)
 	struct mlx5e_ipsec_work *work =
 		container_of(_work, struct mlx5e_ipsec_work, work);
 	struct mlx5e_ipsec_sa_entry *sa_entry = work->data;
+	struct mlx5_accel_esp_xfrm_attrs tmp = {};
 	struct mlx5_accel_esp_xfrm_attrs *attrs;
+	bool need_modify = false;
 	int ret;
 
 	attrs = &sa_entry->attrs;
@@ -460,19 +452,22 @@ static void mlx5e_ipsec_handle_event(struct work_struct *_work)
 	if (ret)
 		goto unlock;
 
+	if (attrs->lft.soft_packet_limit != XFRM_INF)
+		mlx5e_ipsec_handle_limits(sa_entry);
+
 	if (attrs->replay_esn.trigger &&
 	    !MLX5_GET(ipsec_aso, sa_entry->ctx, esn_event_arm)) {
 		u32 mode_param = MLX5_GET(ipsec_aso, sa_entry->ctx,
 					  mode_parameter);
 
-		mlx5e_ipsec_update_esn_state(sa_entry, mode_param);
+		mlx5e_ipsec_update_esn_state(sa_entry, mode_param, &tmp);
+		need_modify = true;
 	}
 
-	if (attrs->lft.soft_packet_limit != XFRM_INF)
-		mlx5e_ipsec_handle_limits(sa_entry);
-
 unlock:
 	spin_unlock_bh(&sa_entry->x->lock);
+	if (need_modify)
+		mlx5_accel_esp_modify_xfrm(sa_entry, &tmp);
 	kfree(work);
 }
 
-- 
2.51.0



