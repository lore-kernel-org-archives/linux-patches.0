Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33BDD305E2D;
	Tue,  2 Sep 2025 13:40:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820434; cv=none; b=mRzv3NijboLbi3TanaX0HRB40d0r9Ya3Zdn2ZMd0L7xJOAV3x6ev1HR8jERxNXeKVuvSR4cbzEloKn42obD1bndMPMwWSDu0mWnrnel8+LiEJa/QD91n6DlNrMo8qjHmo8/iBhE4RHKtjXg1ouRGcbyak0McUOddfVrXMXTOklM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820434; c=relaxed/simple;
	bh=hdeIHqy8gV7C6UZz4vG4KZh86d4ju6fFB5Vfq5IagCA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IquNYEvf8xYacI0Kzr5cH9/1x+vIG3AIzLa53haWeVE00fG2Fq0h3GoGoKGOTUz7ejX2hie9kcWAxTO14fRs6nKbxErleXoWsWP1dC2wjZenItz5F9ndLxBlmFmpTYExXD6D3FFsGDKtJ+vMycixnXGmRaJupTyzikMIUysCH1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1G9+PwI7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1G9+PwI7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D0C0C4CEED;
	Tue,  2 Sep 2025 13:40:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756820432;
	bh=hdeIHqy8gV7C6UZz4vG4KZh86d4ju6fFB5Vfq5IagCA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1G9+PwI7N4+9tMP6EPVLKpvT/EnFK1vy7suCqZzQudQ00XbNG2Y2B5D4n7FtqvHzC
	 t/llthC+zcFHbPusXun494dwVrMGIM34xp6IICf6aquM6Q/ifKNumyhmYd/jJvShHu
	 RQhv1Fc6F50roA7of4TuGr7IrVPJx0U8uWje/Uiw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Lazar <alazar@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 27/50] net/mlx5e: Update and set Xon/Xoff upon port speed set
Date: Tue,  2 Sep 2025 15:21:18 +0200
Message-ID: <20250902131931.601240575@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131930.509077918@linuxfoundation.org>
References: <20250902131930.509077918@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Alexei Lazar <alazar@nvidia.com>

[ Upstream commit d24341740fe48add8a227a753e68b6eedf4b385a ]

Xon/Xoff sizes are derived from calculations that include
the port speed.
These settings need to be updated and applied whenever the
port speed is changed.
The port speed is typically set after the physical link goes down
and is negotiated as part of the link-up process between the two
connected interfaces.
Xon/Xoff parameters being updated at the point where the new
negotiated speed is established.

Fixes: 0696d60853d5 ("net/mlx5e: Receive buffer configuration")
Signed-off-by: Alexei Lazar <alazar@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Link: https://patch.msgid.link/20250825143435.598584-11-mbloch@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 7612070b66160..ae3a7b96f7978 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -107,6 +107,8 @@ void mlx5e_update_carrier(struct mlx5e_priv *priv)
 	if (up) {
 		netdev_info(priv->netdev, "Link up\n");
 		netif_carrier_on(priv->netdev);
+		mlx5e_port_manual_buffer_config(priv, 0, priv->netdev->mtu,
+						NULL, NULL, NULL);
 	} else {
 		netdev_info(priv->netdev, "Link down\n");
 		netif_carrier_off(priv->netdev);
-- 
2.50.1



