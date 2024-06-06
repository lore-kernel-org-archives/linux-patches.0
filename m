Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0EE5198A20;
	Thu,  6 Jun 2024 14:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683056; cv=none; b=aCW/uDZO/3wJ+wgnbUBS3PP0zf4pWp3GaR04t0wo0IV0zFTzkvLOx0iXy2L/WmJKQtwgwPFCB34THeoX7u1EWzCTjRx4DB+nkUe+T6JdNcfBXnh0CDuHz3YLVWIOeMM0Kt65fNCiDsueRSud0zJaPVy8S0/Nw7fSCGu21XkL41Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683056; c=relaxed/simple;
	bh=PxNigt2YiXakhLNNcfs5dLJWil0McD00UI9D3S7cPcg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b8MG6eqbWnwoXKjlov+5gcs1Cx8ook5HUHKrbOYh8RJDl/aeuJHY75zFvam1wN1xIEOYSvrinzw55ZLt2E8nhzpkgu9HAUdscsjbigG9wmNBwrYZVP7chtO49hjcbiXR9If6O32c7NUa+uhefLdk1QELnYmAtBHfDHIPUxBKkZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1x8ikzEg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1x8ikzEg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62EB9C4AF08;
	Thu,  6 Jun 2024 14:10:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683056;
	bh=PxNigt2YiXakhLNNcfs5dLJWil0McD00UI9D3S7cPcg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1x8ikzEgwbsqlYQMpcsOIgoVfXKvjzWEGXbVvCbTTJdHUlKlrYzWMSvU7K/m9wYx8
	 o81/L852gabwLgV8JwPXZrU3/t3d3ooLQCtPEL/g0VWCTbGPaepn4wlRlPsVAwZxfA
	 O5CZnhh2uM3lGDgeQDflEjKA3FoJdtmB5Zr/4WiY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carolina Jubran <cjubran@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 301/374] net/mlx5e: Use rx_missed_errors instead of rx_dropped for reporting buffer exhaustion
Date: Thu,  6 Jun 2024 16:04:40 +0200
Message-ID: <20240606131701.937309350@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Carolina Jubran <cjubran@nvidia.com>

[ Upstream commit 5c74195d5dd977e97556e6fa76909b831c241230 ]

Previously, the driver incorrectly used rx_dropped to report device
buffer exhaustion.

According to the documentation, rx_dropped should not be used to count
packets dropped due to buffer exhaustion, which is the purpose of
rx_missed_errors.

Use rx_missed_errors as intended for counting packets dropped due to
buffer exhaustion.

Fixes: 269e6b3af3bf ("net/mlx5e: Report additional error statistics in get stats ndo")
Signed-off-by: Carolina Jubran <cjubran@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 64497b6eebd36..47be07af214ff 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3790,7 +3790,7 @@ mlx5e_get_stats(struct net_device *dev, struct rtnl_link_stats64 *stats)
 		mlx5e_fold_sw_stats64(priv, stats);
 	}
 
-	stats->rx_dropped = priv->stats.qcnt.rx_out_of_buffer;
+	stats->rx_missed_errors = priv->stats.qcnt.rx_out_of_buffer;
 
 	stats->rx_length_errors =
 		PPORT_802_3_GET(pstats, a_in_range_length_errors) +
-- 
2.43.0



