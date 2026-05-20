Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A9B62C15AB;
	Wed, 20 May 2026 16:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294883; cv=none; b=brZmg+Jr9LxkF60PVL4Yu7RY7Jo3L2eh764JFCfqlD0rnQD+/bKzTbssqvkhOfpD8fwOLQdffjQlwXwl4bS9oQdX5bQtU8c7M0meOMfysdgftoj2doxgxI1dEseaOsu8/wzCKlEYvfOvTXsdKBAMGPwgcLMZ4vTDxD444i3gH9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294883; c=relaxed/simple;
	bh=IW/EaWB8UcXSaTeqs2CZBHqp8QJjiK4A72EXUmEQvis=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TfAu131hn5iBL91ogwnztw5HYvWcVVEkVQ8U9GnukVW1hZDqmmimgg/MzuJbcNQ5qI8c3wmmAnbtfoRGO9wpnQuJJptF4o8k9DN5PyHgq9pawZ2Uj6C27s/doPNGSGxdsjN/ZVNLURVMexZLLUDPCPb0ZcUPv9X44Ueo6u9EeWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l9SDl664; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l9SDl664"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 852641F000E9;
	Wed, 20 May 2026 16:34:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294882;
	bh=nAaN/GcRWHWjkcajqNMEqAZ8ufCTCwcP/+E7OmKczu0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l9SDl664K5ydM6UKAaIUSejiBk34JI3/dJwqxiCRYt/x8vgZ2GnHwMv2vFOji2gAk
	 wkNHkjAyTuW3/Zm0SPM8jQ2FIy9Od7VkuCcszYsQWZisQvfNBE4RhKBlBlliGAnFaZ
	 VXkoRSOqOES7oBp2xxPAv68YZ+BQa08Fvzl9g6fw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gal Pressman <gal@nvidia.com>,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0206/1146] net/mlx5e: Fix features not applied during netdev registration
Date: Wed, 20 May 2026 18:07:36 +0200
Message-ID: <20260520162152.929465163@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gal Pressman <gal@nvidia.com>

[ Upstream commit 9994ad4df82d64e57135c0f0906897685f5a9e87 ]

mlx5e_fix_features() returns early when the netdevice is not present.
This is correct during profile transitions where priv is cleared, but it
also incorrectly blocks feature fixups during register_netdev(), when
the device is also not yet present.

It is not trivial to distinguish between both cases as we cannot use
priv to carry state, and in both cases reg_state == NETREG_REGISTERED.

Force a netdev features update after register_netdev() completes, where
the device is present and fix_features() can actually work.

This is not a pretty solution, as it results in an additional features
update call (register_netdevice() already calls
__netdev_update_features() internally), but it is the simplest,
cleanest, and most robust way I found to fix this issue after multiple
attempts.

This fixes an issue on systems where CQE compression is enabled by
default, RXHASH remains enabled after registration despite the two
features being mutually exclusive.

Fixes: ab4b01bfdaa6 ("net/mlx5e: Verify dev is present for fix features ndo")
Signed-off-by: Gal Pressman <gal@nvidia.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20260409202852.158059-2-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index b6c12460b54a9..0b8b44bbcb9ef 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -6756,6 +6756,14 @@ static int _mlx5e_probe(struct auxiliary_device *adev)
 		goto err_resume;
 	}
 
+	/* mlx5e_fix_features() returns early when the device is not present
+	 * to avoid dereferencing cleared priv during profile changes.
+	 * This also causes it to be a no-op during register_netdev(), where
+	 * the device is not yet present.
+	 * Trigger an additional features update that will actually work.
+	 */
+	mlx5e_update_features(netdev);
+
 	mlx5e_dcbnl_init_app(priv);
 	mlx5_core_uplink_netdev_set(mdev, netdev);
 	mlx5e_params_print_info(mdev, &priv->channels.params);
-- 
2.53.0



