Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD4391C95EE;
	Thu,  6 Jun 2024 14:22:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683734; cv=none; b=QBYxA3TYaviFszLJyCACGzjOPRz19SaSankyr3dcpEXk5S0N39QyFKeR/f+rPiGtkPeC33N4YBneD9rogs9G7/M5bpJ+jVjg9nZEK1fDtZY0QveEmofu9ONuAi3p5sJXtETPlvfOxvnPOeApAA4M4lDT3ulEIaInGcyC4uPzs7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683734; c=relaxed/simple;
	bh=stIWUsRa8/Rgd5JkIs7kOine1wv71bMHV1lH0kU+HbI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IP4o2/kBicKm/3fYw7qbziiAJoAHBNpLAgHMe5YCPz0GUB/iQB6iyNZ/oM2Jr+J5/pwJBdeNj5iofDmJ2lKGpyvBQH2ixM4j9uPqa8sSRUB63vKFyL6iOOu3BnTawH7BTEADXLevqWLtYPCdM0MNneJ+5G3vuCZ5rOdG1ulil6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nLPtW2je; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nLPtW2je"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE03BC32782;
	Thu,  6 Jun 2024 14:22:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683734;
	bh=stIWUsRa8/Rgd5JkIs7kOine1wv71bMHV1lH0kU+HbI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nLPtW2jeBcbtrtjKRZIrNjztcOyMGbiQI0mGR+OBpqBgQhLR+ZF+Y+fZgxmXoZ1a0
	 cAAqaQ/g6jEmj/kTcrSHChyCK9W1EelQm04BN4szSQ0RmEP0yb0tdqqiZTHOHKTjkx
	 18mxHVrIlvYPTLXDVe/NfhZn51Ns5fgFDAZ+xWPU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carolina Jubran <cjubran@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 689/744] net/mlx5e: Use rx_missed_errors instead of rx_dropped for reporting buffer exhaustion
Date: Thu,  6 Jun 2024 16:06:01 +0200
Message-ID: <20240606131754.583567875@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index d49c348f89d28..455907b1167a0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3756,7 +3756,7 @@ mlx5e_get_stats(struct net_device *dev, struct rtnl_link_stats64 *stats)
 		mlx5e_fold_sw_stats64(priv, stats);
 	}
 
-	stats->rx_dropped = priv->stats.qcnt.rx_out_of_buffer;
+	stats->rx_missed_errors = priv->stats.qcnt.rx_out_of_buffer;
 
 	stats->rx_length_errors =
 		PPORT_802_3_GET(pstats, a_in_range_length_errors) +
-- 
2.43.0



