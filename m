Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B75F323DE;
	Wed,  7 May 2025 19:01:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644518; cv=none; b=ptGR1nhLb61Lhl4ZMP9JmjIfhfxBh6amOBoo6HtQeZGUpyLSEwArHk1lscz1Pso8MZXSuonFbYt4tLQwfB9MMSkpLfeyDrfKRy59RiP5SCGcDQafoBj4rC88lcy1E6twcLEq+cveeNUn3c+F4Zn/4B/oRroPD5WVz8XJy+bPTco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644518; c=relaxed/simple;
	bh=lhG22v3GTP2A4r1IPy4Ry3KpB1v/mP74Q0uf7oiXuc0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=abOwwlHQ5i+CrAEsWAt84fTkPet2FuxdnkAc2M0d4fTD4ux17bUp21ez0P4GKVAVEtFALWPzNhGSC9AvY+gMlgtBina3ZS/msnzFxQqhRxonZTVyPhdnFT9ewSeBHBBRQ2kPaZ13M7xjbpK8smQ3P6yt8TAzCtko5LLpofnYdx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v79Dld/C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v79Dld/C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 442F0C4CEE2;
	Wed,  7 May 2025 19:01:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644518;
	bh=lhG22v3GTP2A4r1IPy4Ry3KpB1v/mP74Q0uf7oiXuc0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v79Dld/Ci98bZ3TAkFGu6cE67NUCph4XZeMUHL3PMyc+WW05QF9sGrOkRnINVmj5A
	 Dh4wvzEia/RbMsBrQTqSieXQRuSfGJf9ctRnRvn2gbjWBcHcOcrAW0usOgd+FxIdPu
	 Qxrt6ExlIuXj2bbUNTnntruaR9TPvUPXz76UyZR0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cosmin Ratiu <cratiu@nvidia.com>,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 070/164] net/mlx5e: Fix lock order in mlx5e_tx_reporter_ptpsq_unhealthy_recover
Date: Wed,  7 May 2025 20:39:15 +0200
Message-ID: <20250507183823.795821579@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183820.781599563@linuxfoundation.org>
References: <20250507183820.781599563@linuxfoundation.org>
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

From: Cosmin Ratiu <cratiu@nvidia.com>

[ Upstream commit 1c2940ec0ddf51c689ee9ab85ead85c11b77809d ]

RTNL needs to be acquired before state_lock.

Fixes: fdce06bda7e5 ("net/mlx5e: Acquire RTNL lock before RQs/SQs activation/deactivation")
Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Link: https://patch.msgid.link/20250423083611.324567-5-mbloch@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
index 09433b91be176..c8adf309ecad0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
@@ -177,6 +177,7 @@ static int mlx5e_tx_reporter_ptpsq_unhealthy_recover(void *ctx)
 
 	priv = ptpsq->txqsq.priv;
 
+	rtnl_lock();
 	mutex_lock(&priv->state_lock);
 	chs = &priv->channels;
 	netdev = priv->netdev;
@@ -184,22 +185,19 @@ static int mlx5e_tx_reporter_ptpsq_unhealthy_recover(void *ctx)
 	carrier_ok = netif_carrier_ok(netdev);
 	netif_carrier_off(netdev);
 
-	rtnl_lock();
 	mlx5e_deactivate_priv_channels(priv);
-	rtnl_unlock();
 
 	mlx5e_ptp_close(chs->ptp);
 	err = mlx5e_ptp_open(priv, &chs->params, chs->c[0]->lag_port, &chs->ptp);
 
-	rtnl_lock();
 	mlx5e_activate_priv_channels(priv);
-	rtnl_unlock();
 
 	/* return carrier back if needed */
 	if (carrier_ok)
 		netif_carrier_on(netdev);
 
 	mutex_unlock(&priv->state_lock);
+	rtnl_unlock();
 
 	return err;
 }
-- 
2.39.5



