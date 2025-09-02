Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE44E30C341;
	Tue,  2 Sep 2025 13:32:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819972; cv=none; b=mJEWqWU5DoRKYVP0OsOVcfZcCbIbAUTOp5+6++L3Uo5YWpz+xZfiWVBN+3VBqa5ZperUBVix9xbpDZOmYA9F6e39zrC/87IsEno2ta1mz8dKMfGosXhfUnBaagFvi8ft2F/AMD2eyQ4E6lyT5ggAy93D/VdKVVnq3T9a37+18lQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819972; c=relaxed/simple;
	bh=sAIlRXlrkj2DV3czWLqq996oFfRUxJgpzZIv5oL3KbQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eZhpUvJHQBuaWihy4AawmevXNi6mfiQpNRqUmGeKe+VN220wShPjKI0HqGLECVgW/EahXHzAg4d0naMm1j+Ci6KoIw+bKMRiPQhmbFLdceMf96Dc5Be9SUN7FioX9UST4ydTJvzu0N15b64F3icrZo9yRb7GxgtzDoS3wbLYVK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ap1P8C1W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ap1P8C1W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5810C4CEED;
	Tue,  2 Sep 2025 13:32:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756819972;
	bh=sAIlRXlrkj2DV3czWLqq996oFfRUxJgpzZIv5oL3KbQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ap1P8C1WTQT8YB00Zsk6azzh5NTFZ8cnyjlzG2AHQg56PX4TDsHKcLpZDbGfh5KLn
	 vO/IMuBnPyraRAtQ6zVCEwcx2a53pbcjt6Zo++/lRT6RIiZKczx1kTe9McoTWthvSb
	 Ny6PYKgtMNg7YTf60GhHOc5oGU417SYPjDRTN7lY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Lazar <alazar@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 52/95] net/mlx5e: Update and set Xon/Xoff upon port speed set
Date: Tue,  2 Sep 2025 15:20:28 +0200
Message-ID: <20250902131941.601992105@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131939.601201881@linuxfoundation.org>
References: <20250902131939.601201881@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index de2327ffb0f78..6176457b846bc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -135,6 +135,8 @@ void mlx5e_update_carrier(struct mlx5e_priv *priv)
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



