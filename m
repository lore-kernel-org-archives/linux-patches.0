Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03D9D396B75;
	Thu, 15 Jan 2026 16:58:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496302; cv=none; b=H3Ctz/oV9jvo1Q/SZ8Znnr2qu87dOy2DmbnvYoDEzpI7rDaAq0zqT+s7ffj13LIZ4j1foJgh8fdP3jXeEsMfTVwDPmFZeVZz579wLzMpWGgyxPMjOkmxEqNwfw5LAZ8bbhHL+NfZW6i34aj8uIsJQRGY5j6OoZKudyd684guvXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496302; c=relaxed/simple;
	bh=XskLo+rP7FLszMaeUg1yogr3i2hCwbzqc5CJKzgqy3A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QwDBdLnGU8fGOi8zV2gBq31lwL0tSHGDeyUd9pN4p7H/eJPxvfohpO++sn1U2l3XyFgWPjpRC0DoQwcO8FVaZUu3NwrGG5sIvB7BsgflKaqyOxmja3MMcOmah1FfPSB9jYoNVOnPppshBFa/1mExCxE8cNNS4qKx+6ZGgH7IifY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mXXJGNdD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mXXJGNdD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82312C19422;
	Thu, 15 Jan 2026 16:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496301;
	bh=XskLo+rP7FLszMaeUg1yogr3i2hCwbzqc5CJKzgqy3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mXXJGNdDufeJuNOtj3av9k5CPT5laxMvHtHQL0ayGIpOWLg1n+kNVd9OYUujS5v50
	 BiVZwKu3ZGvPKJ4ExO9oU2lDUaUXufkrOwvNTi5QDXyfZ7hisCPijoInL5gyVTy2tE
	 rA4tOdqKOAI60Ts9nALf+AyfTpE7BNts2MZhp100=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cosmin Ratiu <cratiu@nvidia.com>,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 105/181] net/mlx5e: Dealloc forgotten PSP RX modify header
Date: Thu, 15 Jan 2026 17:47:22 +0100
Message-ID: <20260115164206.110116878@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
References: <20260115164202.305475649@linuxfoundation.org>
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

From: Cosmin Ratiu <cratiu@nvidia.com>

[ Upstream commit 0462a15d2d1fafd3d48cf3c7c67393e42d03908c ]

The commit which added RX steering rules for PSP forgot to free a modify
header HW object on the cleanup path, which lead to health errors when
reloading the driver and uninitializing the device:

mlx5_core 0000:08:00.0: poll_health:803:(pid 3021): Fatal error 3 detected

Fix that by saving the modify header pointer in the PSP steering struct
and deallocating it after freeing the rule which references it.

Fixes: 9536fbe10c9d ("net/mlx5e: Add PSP steering in local NIC RX")
Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Link: https://patch.msgid.link/20251225132717.358820-6-mbloch@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/en_accel/psp.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/psp.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/psp.c
index 8565cfe8d7dce..943d6fc6e7a04 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/psp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/psp.c
@@ -41,6 +41,7 @@ struct mlx5e_accel_fs_psp_prot {
 	struct mlx5_flow_table *ft;
 	struct mlx5_flow_group *miss_group;
 	struct mlx5_flow_handle *miss_rule;
+	struct mlx5_modify_hdr *rx_modify_hdr;
 	struct mlx5_flow_destination default_dest;
 	struct mlx5e_psp_rx_err rx_err;
 	u32 refcnt;
@@ -217,13 +218,19 @@ static int accel_psp_fs_rx_err_create_ft(struct mlx5e_psp_fs *fs,
 	return err;
 }
 
-static void accel_psp_fs_rx_fs_destroy(struct mlx5e_accel_fs_psp_prot *fs_prot)
+static void accel_psp_fs_rx_fs_destroy(struct mlx5e_psp_fs *fs,
+				       struct mlx5e_accel_fs_psp_prot *fs_prot)
 {
 	if (fs_prot->def_rule) {
 		mlx5_del_flow_rules(fs_prot->def_rule);
 		fs_prot->def_rule = NULL;
 	}
 
+	if (fs_prot->rx_modify_hdr) {
+		mlx5_modify_header_dealloc(fs->mdev, fs_prot->rx_modify_hdr);
+		fs_prot->rx_modify_hdr = NULL;
+	}
+
 	if (fs_prot->miss_rule) {
 		mlx5_del_flow_rules(fs_prot->miss_rule);
 		fs_prot->miss_rule = NULL;
@@ -327,6 +334,7 @@ static int accel_psp_fs_rx_create_ft(struct mlx5e_psp_fs *fs,
 		modify_hdr = NULL;
 		goto out_err;
 	}
+	fs_prot->rx_modify_hdr = modify_hdr;
 
 	flow_act.action = MLX5_FLOW_CONTEXT_ACTION_FWD_DEST |
 			  MLX5_FLOW_CONTEXT_ACTION_CRYPTO_DECRYPT |
@@ -347,7 +355,7 @@ static int accel_psp_fs_rx_create_ft(struct mlx5e_psp_fs *fs,
 	goto out;
 
 out_err:
-	accel_psp_fs_rx_fs_destroy(fs_prot);
+	accel_psp_fs_rx_fs_destroy(fs, fs_prot);
 out:
 	kvfree(flow_group_in);
 	kvfree(spec);
@@ -364,7 +372,7 @@ static int accel_psp_fs_rx_destroy(struct mlx5e_psp_fs *fs, enum accel_fs_psp_ty
 	/* The netdev unreg already happened, so all offloaded rule are already removed */
 	fs_prot = &accel_psp->fs_prot[type];
 
-	accel_psp_fs_rx_fs_destroy(fs_prot);
+	accel_psp_fs_rx_fs_destroy(fs, fs_prot);
 
 	accel_psp_fs_rx_err_destroy_ft(fs, &fs_prot->rx_err);
 
-- 
2.51.0



