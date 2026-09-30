Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B17AF3CF1FC;
	Wed, 30 Sep 2026 18:52:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794331; cv=none; b=TvKUvE8T/lU/lRXNxq6v3+FgHmpByGYYvcKrVZ1zslPPvWMHJc00aAIxSXsidOduMcHUQh/JCE7LH8AtIOOKbzA5i47tLnYuMKKALnjafXCYdEPslSUBE8tf7Wy4o8QFaGrgC0fgzzIwCTvSALhOH37uoK+Uzyws7gUxSqCyY6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794331; c=relaxed/simple;
	bh=pyRE6T2JXk9TGT39fTv03gNtnt2HNUpQX23NLIIuvjo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XKS/kvP7RF2dtCaougoqaJcgqz6nRNM3IO6WUyqKOZJu3QDOqBNfJAnaYgGuvUkMcLZV8uGzYJJAH60vo3PTw2d5NlUbon5NpLQfKmFo7kd05qH/rON22ggCwUoEs96QHZo65KgITUz3grbs/CLmCdtcLB+eQNW+XnM+FO5KQPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eydoq1Oq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eydoq1Oq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B4171F000FF;
	Wed, 30 Sep 2026 18:52:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794330;
	bh=Qn4pXO6fR7qB660MN3QMSBvLVF6CDS8hqV7i3eGmDeo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eydoq1OqxqOZkxirTUslM+1jjY87R57I6odCXhePwgsGGJ9ogi9Su/EthL6LytMi0
	 n/YeYzNPdNoszjFgoL4U3GEy9YAv5lPyp+tj89MqyLWbJC+Wg31AbjFi0qxSV3ektF
	 Bknw09SBYhWiTNpBnOsb1L/1qSIvWLGD+LVYTx6U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shay Drory <shayd@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0173/1193] net/mlx5: E-Switch, align disable sequence with switchdev-to-legacy transition
Date: Wed, 30 Sep 2026 17:14:17 +0200
Message-ID: <20260930152438.037914832@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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
 drivers/net/ethernet/mellanox/mlx5/core/main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 9b86632270936..4b91ca429840d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1524,6 +1524,7 @@ void mlx5_uninit_one(struct mlx5_core_dev *dev)
 
 	mlx5_hwmon_dev_unregister(dev);
 	mlx5_crdump_disable(dev);
+	mlx5_eswitch_disable(dev->priv.eswitch);
 	mlx5_unregister_device(dev);
 
 	if (!test_bit(MLX5_INTERFACE_STATE_UP, &dev->intf_state)) {
@@ -1608,6 +1609,7 @@ void mlx5_unload_one_devl_locked(struct mlx5_core_dev *dev, bool suspend)
 	devl_assert_locked(priv_to_devlink(dev));
 	mutex_lock(&dev->intf_state_mutex);
 
+	mlx5_eswitch_disable(dev->priv.eswitch);
 	mlx5_detach_device(dev, suspend);
 
 	if (!test_bit(MLX5_INTERFACE_STATE_UP, &dev->intf_state)) {
-- 
2.53.0



