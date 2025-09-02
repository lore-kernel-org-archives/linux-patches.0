Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B58E0305076;
	Tue,  2 Sep 2025 13:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819614; cv=none; b=DfbBybVke4/IeFv05tjt91tEfVBMn8/Emebp8hvBQhQvK2Gu+MPt+B4YmH+UWXmNNIAU/11t2qtsudHm2oajoBKtikgGExWdm0RWIPrqWNQV0bRfADuigBI4GGZvJhwKSysnidlrqbWtdgDRCmwJaHlRMLxfPv/SLGl47S0DTQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819614; c=relaxed/simple;
	bh=6MBV4k7W1lXefx9AJuGt0RobgWH+SVm1W+G+LQFI4dg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lbho2Fs824HCBcMrNjyvfHxXqneTvSbiddXq3PnTCEGspC1cgzv0X8K/BKMGsgYJuN9A39V+T2FXw8jfZFMmbeBJKgpGLKy878EuoFilDRhHGmMhIVlXapEj0zIhvuKQ6P5FswRQ5vmbDWmprrcY3gumSPESUYrJLocruzTkd2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JgB2M0KM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JgB2M0KM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D922C4CEF5;
	Tue,  2 Sep 2025 13:26:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756819614;
	bh=6MBV4k7W1lXefx9AJuGt0RobgWH+SVm1W+G+LQFI4dg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JgB2M0KMi2WPtMATOFm/hMMF3hJh1kW7VDa1+Zf2EuuStrAosOMmCgo6avKdnPSG+
	 +Dz/rYRU8UCXdt6lxEhxa4R/k5eYyzhIe9Gg7mkl4mdYW0wBeQzsOfkwKpik1p87lW
	 N7pKmllkk4lGLquxOSA0MFYZGph+e3YM6z53zmoo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Lazar <alazar@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 087/142] net/mlx5e: Update and set Xon/Xoff upon port speed set
Date: Tue,  2 Sep 2025 15:19:49 +0200
Message-ID: <20250902131951.597970880@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131948.154194162@linuxfoundation.org>
References: <20250902131948.154194162@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index f0142d32b648f..e39c51cfc8e6c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -136,6 +136,8 @@ void mlx5e_update_carrier(struct mlx5e_priv *priv)
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



