Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C665636CE19;
	Wed, 20 May 2026 18:04:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300249; cv=none; b=FpWrC4FZZ81RnoVpyMHhQnZGgJf1nC50Q7qjPNHDEzsLB8N2BAQxaQlPWXlUZbHfvEC6obSmIi+DcCXrlPKAyamNCP+WKkbx8ygUB4GwttkGYjLpOyxVOMptbHhH1oS5Ju0NnkwRRjR+/PqEjYD7E8lUoABOXGIpUDoEeubdcwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300249; c=relaxed/simple;
	bh=d/Mii53w2cimZbuB/IXNtDgIJ0YxubHq4Lyauvd9X7o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z4q7r+nuhBBxKlyq2nqEWKR2diDNyhmTTQXhwV9GIwBt4rCmkga5jmDpsFnuDXIaCZwSl7VNycKFJhbMucEKWc3vMX85/6Lt2VrovwMjIAMRH5nLlg+/x5cWqMRYZAxl1h4YYISU/JaYu+Y3DC+EIRYf5cECif+6QWKR5jMKj5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1h9T5ggS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1h9T5ggS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFB321F000E9;
	Wed, 20 May 2026 18:04:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300248;
	bh=QcpHFVSm6PwfpD+N+203y2FOSuaj/gKZO0ak2ge/+wM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1h9T5ggSzQNyk+L3nb9Tqd6p2nyxvGOvqjZ/9I9x+xiHOzhirkMTq6G9FFeNsQaP+
	 sAvm6t0XF3fAsZANOwjE11nanWMbc7BKM58KjrwQqGo6+uoydgnme3Xuh2nZpwqBnJ
	 pqT0shp5bNaPPOvQsUrC1QL8wYeic2ma25/BAPOE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gal Pressman <gal@nvidia.com>,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 103/666] net/mlx5e: Fix features not applied during netdev registration
Date: Wed, 20 May 2026 18:15:14 +0200
Message-ID: <20260520162113.453993755@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 5736ed61e6eba..dbfb900980de7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -6466,6 +6466,14 @@ static int _mlx5e_probe(struct auxiliary_device *adev)
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



