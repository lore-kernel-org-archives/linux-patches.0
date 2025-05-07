Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 015961FF5EC;
	Wed,  7 May 2025 18:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746643956; cv=none; b=AGwU5Vt8DOGHMWy3/Txdzq4LijL0x1poGPEnYLk4o9dJVyy1LgVDsODafNNhOidsIKbHWJVgGoVzGw44+P4OLy+8WWl5p9q70cczoOkfUFbGaWvHYfpjW44qOZK6F6jFdMofJnIBlPPAisTcAVIdaM5Q9TdGkaemajbavWKPFWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746643956; c=relaxed/simple;
	bh=baJlL+hEr0YhXPk0k1UsZCjN5TCrVjQdgDOD3vnODIE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fXlZyr7Mh0spyqarAnbUDdZpUzuI3wbRM1LK4KFa8hbtTIZsj3Ven0Ashx+e5bds3RKtVTxX5Zl6HYy8jmkNSEQL4GYpPWWDGjNoIBJYx8xkLiZRLcPyvj69xiCDlD38jtVfX84GXZnVzCLUfZU6ONT2jPyMNUadBZUG44XlP4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0eo9VJCl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0eo9VJCl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88D9CC4CEE2;
	Wed,  7 May 2025 18:52:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746643955;
	bh=baJlL+hEr0YhXPk0k1UsZCjN5TCrVjQdgDOD3vnODIE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0eo9VJClEP0QI3u/hk3bkY8mSYVWe8wbCKIHoDTXAVXY5o5L4IsDIzDHabK1SQg3g
	 A/ssI6RZMGeDiUHCmM2wkC8Dh0gP+HSU/y51Kr1zNm3sce42RaPY7+KKiHesE6xYUp
	 2AMfJ/aMRTAU01WPFfj1Gq5WY2KTG2hrKV2k89IA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cosmin Ratiu <cratiu@nvidia.com>,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 072/183] net/mlx5e: Fix lock order in mlx5e_tx_reporter_ptpsq_unhealthy_recover
Date: Wed,  7 May 2025 20:38:37 +0200
Message-ID: <20250507183827.610002286@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183824.682671926@linuxfoundation.org>
References: <20250507183824.682671926@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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



