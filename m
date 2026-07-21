Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF3013B2FC0;
	Tue, 21 Jul 2026 20:36:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666171; cv=none; b=TSIfNPVdTQ6LIPfDkaLwoeK/0M7NjFHAB3F0Bfi+d/Q94e4wGVy7Svu1bhKdnJW415xDBUuavGeBxYR0DTd+UVvVmAyOQFrmsE4vTdEQ7se4QL6vOdejSF9o+IQLAb1nV4XI1Pw6ZD9lQkIg5Zanqawe0l1X3GWdk1G4b/3LvjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666171; c=relaxed/simple;
	bh=IwAdiX471qKAVr03UyNwm/xMcb1/XAcGiF47FYG/QEE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b+XdhZRRUore/Hj7A6WVu6RQRhDJyyOgbOSIpCOCio2L2fSwfZeneya27o8I3D2PzeUqsZrJm24P4hVRehX/Dai+zEu4BkyyODBNzuFMt0W/GiN3vykHTw7wvpBjNnPgDspq708X2QvZli+VUqCxBEz7XJyZt+mZB/wKiRz/qEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JZKnFPeJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JZKnFPeJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F1131F00A3A;
	Tue, 21 Jul 2026 20:36:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666169;
	bh=o1FWmh69UIsmNA+bu3uNld3izzyRiWBs7m8PWHTbZMM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JZKnFPeJ0etEdiadbReBYQ+QLl5/x9DrPNmb5vOGbh0nRvaDDNV9EEvrH089boHL0
	 CEgcXWuyQ4aSsGnz8ynVDIgbOYyLS6p9v8Pi4tgwh+ECpasfK5fc31uV9l1vRv4WSW
	 R3XwxlMqPI/7rI5RR81w5JiEy4iLD7BoF8KlmEf0=
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
Subject: [PATCH 6.6 0580/1266] net/mlx5: Check max_macs devlink param value against max capability
Date: Tue, 21 Jul 2026 17:16:57 +0200
Message-ID: <20260721152454.845589646@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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
index 80f3493fc544c4..9b86632270936b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -570,7 +570,6 @@ static int handle_hca_cap(struct mlx5_core_dev *dev, void *set_ctx)
 {
 	struct mlx5_profile *prof = &dev->profile;
 	void *set_hca_cap;
-	int max_uc_list;
 	int err;
 
 	err = mlx5_core_get_caps(dev, MLX5_CAP_GENERAL);
@@ -653,10 +652,13 @@ static int handle_hca_cap(struct mlx5_core_dev *dev, void *set_ctx)
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



