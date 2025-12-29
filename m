Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C952D30FF1D;
	Mon, 29 Dec 2025 16:16:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767024999; cv=none; b=OWp5G0vhwSeA41P0hGJ7as+BrJV11978SYBkotd+7+vX9uqFa7MGiJBLy0VcRuPrL1Ahs0Ofh55IcvxIgAn3ezb8/TfK6GouOEQoyYON44cupH6PRf2fPCM/LonHz66wcvxcujcrCzVh230SPqgdMoy+Gltou9FKkniuCTK4LUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767024999; c=relaxed/simple;
	bh=01F1d/8cRXzKd5Spf0157vdVzwXdqszgjSghZXzWU8s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cp0l22YgWUDNvqO14y35qE3NYmcr0qsKAIPnME56nywor8Aagz+I3dBk7IA2mqq9zRdanBTY7SOEPtktttScXQRPKV3zG6HSP5VLycoCektibVOfRh3GomWouNplQGFPQTr8IPlx7o/PLgq+GVsVscwtr6cG4JYk5cmn6Wvh9+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EeFPTEtC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EeFPTEtC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15879C4CEF7;
	Mon, 29 Dec 2025 16:16:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767024999;
	bh=01F1d/8cRXzKd5Spf0157vdVzwXdqszgjSghZXzWU8s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EeFPTEtC9uw5qWkTc5OWUgvBvfh6PiNeM42NmdauEwMRcVTC4f6hSvEDVr58826Tw
	 jYD8MmsWWVOtIRuW0Msf2LJM2ZeueIiYyRbHVFScJGDxVKGIM7+MHZ4hT1QG9tLfFy
	 KaD/cUUJ0WcYdJW9jf6tU9lSkaDmgPLM7HCfXdoE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cosmin Ratiu <cratiu@nvidia.com>,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 057/430] net/mlx5e: Avoid unregistering PSP twice
Date: Mon, 29 Dec 2025 17:07:39 +0100
Message-ID: <20251229160726.466235719@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

[ Upstream commit 35e93736f69963337912594eb3951ab320b77521 ]

PSP is unregistered twice in:
_mlx5e_remove -> mlx5e_psp_unregister
mlx5e_nic_cleanup -> mlx5e_psp_unregister

This leads to a refcount underflow in some conditions:
------------[ cut here ]------------
refcount_t: underflow; use-after-free.
WARNING: CPU: 2 PID: 1694 at lib/refcount.c:28 refcount_warn_saturate+0xd8/0xe0
[...]
 mlx5e_psp_unregister+0x26/0x50 [mlx5_core]
 mlx5e_nic_cleanup+0x26/0x90 [mlx5_core]
 mlx5e_remove+0xe6/0x1f0 [mlx5_core]
 auxiliary_bus_remove+0x18/0x30
 device_release_driver_internal+0x194/0x1f0
 bus_remove_device+0xc6/0x130
 device_del+0x159/0x3c0
 mlx5_rescan_drivers_locked+0xbc/0x2a0 [mlx5_core]
[...]

Do not directly remove psp from the _mlx5e_remove path, the PSP cleanup
happens as part of profile cleanup.

Fixes: 89ee2d92f66c ("net/mlx5e: Support PSP offload functionality")
Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/1764602008-1334866-3-git-send-email-tariqt@nvidia.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 5e17eae81f4b3..1545f9c008f49 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -6805,7 +6805,6 @@ static void _mlx5e_remove(struct auxiliary_device *adev)
 	 * is already unregistered before changing to NIC profile.
 	 */
 	if (priv->netdev->reg_state == NETREG_REGISTERED) {
-		mlx5e_psp_unregister(priv);
 		unregister_netdev(priv->netdev);
 		_mlx5e_suspend(adev, false);
 	} else {
-- 
2.51.0



