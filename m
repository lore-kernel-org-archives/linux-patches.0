Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5B46471253;
	Tue, 21 Jul 2026 18:00:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656847; cv=none; b=STMPCXljWr6AaSXgyeGPa5QhTOLifNSJm/zxKJtZclCaW09NK6Q4XPnuS8JTDQ8xGOg6AZI0n3bh13KxpZjbedGt7W2mb+HGxiTYN0593trWvBjhYBp+EgYSXgEjNTFtiDB+jcoB1n6XGRLwlMHiFWWW407JW6dAO/4UvRFvh0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656847; c=relaxed/simple;
	bh=TF3Q/Boea0oV5nC3m7/c4zoOVWXNvoY24l/0GNFucCg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gjyML9A2eOc54fVBaseaOGY5jNOuS2BKh5n02kUaypaN+WMCOly+amn+JNcNMGgUnVgu86aXsvLValPEHDyU3DIsyvQ06F4Ak3cf2pginWvnpFLBv4xdlNWPy2iv1yTWxMwKuewaetgO8dwbMclAbVuUZufMCwLVVbMjQGQc5As=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cDea/Bm1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cDea/Bm1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E94CD1F00A3A;
	Tue, 21 Jul 2026 18:00:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656846;
	bh=79qosMnJUKqu6kyDoYUZzbDYWddFndzC6d+D6Pgjiow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cDea/Bm1H5XO/+nGB1WpAM3Mh5/EEKeW6ElcUqniZ98CjQVvVFhj129gE1OcoQNB5
	 B0O4fXqjvyfXp3vniBBJ1xmWNcVOUJfKd/6HYk1IxcvoF9phA8kGXI/zBi//bqOaUl
	 LGJYW5p8OqOE6FIJyruTfSwJGF9ABEUm6w8qSxso=
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
Subject: [PATCH 6.18 0514/1611] net/mlx5: Check max_macs devlink param value against max capability
Date: Tue, 21 Jul 2026 17:10:30 +0200
Message-ID: <20260721152526.908139933@linuxfoundation.org>
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
index 6e10a6de8ebcca..22bdefe5696c97 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -580,7 +580,6 @@ static int handle_hca_cap(struct mlx5_core_dev *dev, void *set_ctx)
 {
 	struct mlx5_profile *prof = &dev->profile;
 	void *set_hca_cap;
-	int max_uc_list;
 	int err;
 
 	err = mlx5_core_get_caps(dev, MLX5_CAP_GENERAL);
@@ -663,10 +662,13 @@ static int handle_hca_cap(struct mlx5_core_dev *dev, void *set_ctx)
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
 
 	/* enable absolute native port num */
 	if (MLX5_CAP_GEN_MAX(dev, abs_native_port_num))
-- 
2.53.0



