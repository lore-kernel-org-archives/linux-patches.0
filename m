Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25A1C3FB05D;
	Wed, 20 May 2026 17:25:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297942; cv=none; b=lT/e6+Lf1WOXcNdVDcFlTJGUDuBiL/kKxaiKXVKp+6gNNRuyCjruC0JeNNmdZKaPWBfnM+P4mYobhKFl8gijC8LHLWznh1jkXnq5Ex3DkNV/oAYCxxo8CpR5qSAl7cOKBNyV1u4Y12tDgKOADMarzWu62JNnvbnOlZYl9eHpLTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297942; c=relaxed/simple;
	bh=EFW9YTvtEs80j8eJFAyQQc8QQMRjCE09joqT6VAeD/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FSDINYIOW5kt9rZv448E6oJcyBjzi8TRMloLYTD4L3FyUpmKk3Sw//Fo2IQLAhLJqyu7GccdIgZFAIXhK0lUhvalQo+KpI6A9Kj0HFdu5pwqkvE1z8Ql6F/2W29c3QqRFkcnD90Bc46FxieoqZPnQMnme/9C98Pbo3Y7k4s68XQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wK/Mn97A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wK/Mn97A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F7D21F000E9;
	Wed, 20 May 2026 17:25:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297941;
	bh=9sboOangNf4onDnHDFg6EDOPYxbTbmsL+Jiqu5YGn4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wK/Mn97ASO1HGWsoIxX5oCfe2hIYY61W5pxUmAnP6elg7NbNJVjYS2N5YSaTwsnY/
	 1LkVIT41U1rYo2BMhgrXWmLUvvm/SNv0vUxl4xmEHYtEDQlhpZc8cQlTLTXEgTw8nt
	 kGcEcyxTmpERjgBgDwTW3tMWXITldwNZ3v9rs+DM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gal Pressman <gal@nvidia.com>,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 171/957] net/mlx5e: Fix features not applied during netdev registration
Date: Wed, 20 May 2026 18:10:54 +0200
Message-ID: <20260520162138.261850066@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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
index cb993ad2d9ad9..a696fb88dbef9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -6740,6 +6740,14 @@ static int _mlx5e_probe(struct auxiliary_device *adev)
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



