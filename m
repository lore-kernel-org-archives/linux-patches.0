Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9561351812E;
	Thu, 17 Sep 2026 16:58:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664298; cv=none; b=f7aa+CNu9zuN3WeswU0s3rK85ku2v5igjAwchKWF2O1s/D8mpXJkzQBLkXxB6ja4AHScktLiuNghSeM606B9HgpJ/1YvSNNml2ENdf/9YYSWZ7MQNAjTZWn02qYF/CY4Jtowu9zOQ3O0gnNOD/i+P6TYmDdv/9ocnI/V9vYsQcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664298; c=relaxed/simple;
	bh=fIckmrxOB4BhNGshzhlOKF28SQ0bAXKEuQ0CjT2ssCc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L18dpF/g6ZDrFBtvmSdA9d6sPbnk7zrWOmxqqTgslGUIK72Rm5Me82xu/nu9A3XCXQo3VPXoRQvGcsx+7wf3d/TB9yIsjuqa6MGwbK4QCu/t23vC4btizf21EI89vcCWXFTAZKJ72TFDOthfN23VOlNXdI1UMdvIp71y7SJUDNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tbi95r26; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tbi95r26"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC21B1F000FF;
	Thu, 17 Sep 2026 16:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664297;
	bh=XJVUxobEb83kZYTAfkiH0F5RJ1QG1BUImleHj+KTp5g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tbi95r26/+0LxpiNJxCu9H5rg783kK2KoQFe0kVbEtknDvotRTBBUnT9k6Os4ai3F
	 u3C0OGAOGANPN8UEHslbArcCrfqaBqResWYCse/aq7rd0dS8/k33N/eB+G90tNxZMY
	 MNTL61yvcCKBxaS81Sf6bk0NaxCsgZYuw06k3tEw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shay Drory <shayd@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0324/1250] net/mlx5: E-Switch, align disable sequence with switchdev-to-legacy transition
Date: Thu, 17 Sep 2026 16:01:59 +0100
Message-ID: <20260917151600.880949892@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Shay Drory <shayd@nvidia.com>

[ Upstream commit b48b6308dfaeae49fcda61b4066773cb5e8a9ce8 ]

This patch align the eswitch disable sequence with the
switchdev-to-legacy mode transition, where eswitch must be disabled
before device detachment. The consistent ordering is required for proper
SD LAG cleanup which depends on eswitch state during teardown.

Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20260531113954.395443-3-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 22bdefe5696c9..42bc553d034b5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1427,7 +1427,6 @@ static int mlx5_load(struct mlx5_core_dev *dev)
 
 static void mlx5_unload(struct mlx5_core_dev *dev)
 {
-	mlx5_eswitch_disable(dev->priv.eswitch);
 	mlx5_devlink_traps_unregister(priv_to_devlink(dev));
 	mlx5_sf_dev_table_destroy(dev);
 	mlx5_sriov_detach(dev);
@@ -1536,6 +1535,7 @@ void mlx5_uninit_one(struct mlx5_core_dev *dev)
 
 	mlx5_hwmon_dev_unregister(dev);
 	mlx5_crdump_disable(dev);
+	mlx5_eswitch_disable(dev->priv.eswitch);
 	mlx5_unregister_device(dev);
 
 	if (!test_bit(MLX5_INTERFACE_STATE_UP, &dev->intf_state)) {
@@ -1620,6 +1620,7 @@ void mlx5_unload_one_devl_locked(struct mlx5_core_dev *dev, bool suspend)
 	devl_assert_locked(priv_to_devlink(dev));
 	mutex_lock(&dev->intf_state_mutex);
 
+	mlx5_eswitch_disable(dev->priv.eswitch);
 	mlx5_detach_device(dev, suspend);
 
 	if (!test_bit(MLX5_INTERFACE_STATE_UP, &dev->intf_state)) {
-- 
2.53.0



