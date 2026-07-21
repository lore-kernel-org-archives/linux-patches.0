Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03C8A44AB88;
	Tue, 21 Jul 2026 21:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669170; cv=none; b=PSh5fFyTAklZ2fCidYNgS6rMmaPlGHmW/bOwMvjT6p8+l0M9gKLWuRa26wPl6kQpq06WGCUYWQMZ2BWIksF3IKwmbK+ZF7CdYXxcfOzYsc/I9SFse/RuufQcCeiKTA7AWUVj3A4MIzN1vEIvT1wXNsEP3ONDY97Me/U6gSdWOZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669170; c=relaxed/simple;
	bh=V27ejXd1w3kKES29Sg94KpxlN3/Yr9WC+0Ka+XETVPc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l98DseL49rf4/ruj0EiaFq8LXJZUHFhStr/MpYtjFmu19lXkwGK8pbuDoXpEoLIhAGWqKRjdfqmNwCec/Q2KIS4W/pYPWCyGB26LacjmLgZ5A/qrlSRVWYZ+jq/lwHulpxU8wGErWlYVmo4FuPBmnd13tyCIzojOShDgTlZ5VjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y/yoW2hh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y/yoW2hh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AB491F000E9;
	Tue, 21 Jul 2026 21:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669168;
	bh=Tih+EmprBJu3O5DDBld+8AdCQ9TVdVWmxaTg/d6+AZ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y/yoW2hhZ4oEwX4byeIvvsF3V9EHacXK6i0BZEdPokfidvNGlWYAb4JBkoRxwabwI
	 Zgod4ezHXxmVIljwvurwoeUl5K7362j82pUwiI370+HAXAluqBeU6keJyoeBnjjzth
	 xHzruQsUF34e59Ag8tfKIo7L7wKsqipdrEzEkVVI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Yael Chemla <ychemla@nvidia.com>,
	Carolina Jubran <cjubran@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0452/1067] net/mlx5: Check max_macs devlink param value against max capability
Date: Tue, 21 Jul 2026 17:17:33 +0200
Message-ID: <20260721152434.728969779@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

From: Dragos Tatulea <dtatulea@nvidia.com>

[ Upstream commit d7b0413b35715d7b32cb12d4d424613eff85ed2b ]

The max_macs devlink param is checked against the FW max value only at
param register time (driver load) and inside the validate callback
(devlink param set). The stored DRIVERINIT value persists across FW
resets and devlink reloads without any further checks against the max.

If the FW link type changes from Ethernet to IB and a FW reset happens,
the MAX cap for log_max_current_uc_list will become zero, but the
previously stored max_macs value remains and is unconditionally
programmed into the HCA caps in handle_hca_cap(). FW will then return a
syndrome during SET_HCA_CAP:

 mlx5_cmd_out_err:839:(pid 3831): SET_HCA_CAP(0x109) op_mod(0x0) failed,
 status bad parameter(0x3), syndrome (0x537801), err(-22)
 set_hca_cap:907:(pid 3831): handle_hca_cap failed

This results in a failure to register the RDMA device.

This patch skips programming log_max_current_uc_list when the MAX
capability is 0 (in case of IB).

Fixes: 8680a60fc1fc ("net/mlx5: Let user configure max_macs generic param")
Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Reviewed-by: Yael Chemla <ychemla@nvidia.com>
Reviewed-by: Carolina Jubran <cjubran@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Alexander Lobakin <aleksander.lobakin@intel.com>
Link: https://patch.msgid.link/20260611135230.534513-1-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/main.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 72af9827157d8e..ef406e8d5fc4e9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -550,7 +550,6 @@ static int handle_hca_cap(struct mlx5_core_dev *dev, void *set_ctx)
 {
 	struct mlx5_profile *prof = &dev->profile;
 	void *set_hca_cap;
-	int max_uc_list;
 	int err;
 
 	err = mlx5_core_get_caps(dev, MLX5_CAP_GENERAL);
@@ -627,10 +626,13 @@ static int handle_hca_cap(struct mlx5_core_dev *dev, void *set_ctx)
 		MLX5_SET(cmd_hca_cap, set_hca_cap, roce,
 			 mlx5_is_roce_on(dev));
 
-	max_uc_list = max_uc_list_get_devlink_param(dev);
-	if (max_uc_list > 0)
-		MLX5_SET(cmd_hca_cap, set_hca_cap, log_max_current_uc_list,
-			 ilog2(max_uc_list));
+	if (MLX5_CAP_GEN_MAX(dev, log_max_current_uc_list)) {
+		int max_uc_list = max_uc_list_get_devlink_param(dev);
+
+		if (max_uc_list > 0)
+			MLX5_SET(cmd_hca_cap, set_hca_cap,
+				 log_max_current_uc_list, ilog2(max_uc_list));
+	}
 
 	return set_caps(dev, set_ctx, MLX5_SET_HCA_CAP_OP_MOD_GENERAL_DEVICE);
 }
-- 
2.53.0



