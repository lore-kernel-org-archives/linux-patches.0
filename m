Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEC38322C77;
	Tue,  2 Sep 2025 13:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820768; cv=none; b=kJG60l3BV3SyAzBmCNlYUP12D7Hw/9ZIgeBeagCoSsEP003uyp4GHQXwbYrNc8A5eTZohWzKcB3M4NzzOSGDGnaxjh24wz7HB7c+8ydgyMNfS/dLINB9fZfePUFlCWOpg0nredm2bWR2v2HawG3Q0EAGZPIQA8U01ggmAgRBqWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820768; c=relaxed/simple;
	bh=BJMn2+G1BUgkXRV1+dH9s+FCe2euN2bTYiW/lIDTuMU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZV0q9unQysni1df6PM43/NRuLznEYbMGoWoUR5jtw9IkaGzNVQldMn8b8+gY063FEd5EEukUGRG0WU4jY6uSyKpUdnEII3uPxioso140NZ2YeMPZeJCoWEadVPlecDhnaGel2+ncJY0Y8BpYt55WXP2XMFt99PaoHFsxDwNH2o4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fdSIPy2K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fdSIPy2K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DFE8C4CEED;
	Tue,  2 Sep 2025 13:46:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756820768;
	bh=BJMn2+G1BUgkXRV1+dH9s+FCe2euN2bTYiW/lIDTuMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fdSIPy2KACGuQx3B6YHrCj+PmtQpd1AiguP6DdOaXqKuRyWhDJE9WNrgg4J1nYGGa
	 kaeYN/maVz6AK81FT20movr0v9WrCvPnbt5rQURK/D0PjYTXclzpWLNg6N8c9A3Rvp
	 JE4MyKGbrhU/OKkDl3NbvosHHQ0QAFkSSq4Dv0/0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Lazar <alazar@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 12/23] net/mlx5e: Update and set Xon/Xoff upon port speed set
Date: Tue,  2 Sep 2025 15:21:58 +0200
Message-ID: <20250902131925.214379670@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131924.720400762@linuxfoundation.org>
References: <20250902131924.720400762@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 41bd16cc9d0f6..b8d0b68befcb9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -141,6 +141,8 @@ void mlx5e_update_carrier(struct mlx5e_priv *priv)
 	if (port_state == VPORT_STATE_UP) {
 		netdev_info(priv->netdev, "Link up\n");
 		netif_carrier_on(priv->netdev);
+		mlx5e_port_manual_buffer_config(priv, 0, priv->netdev->mtu,
+						NULL, NULL, NULL);
 	} else {
 		netdev_info(priv->netdev, "Link down\n");
 		netif_carrier_off(priv->netdev);
-- 
2.50.1



