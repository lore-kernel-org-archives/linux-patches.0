Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B726D384;
	Thu, 13 Jun 2024 12:42:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282545; cv=none; b=u3/SJH9dGjUPd2zW7sCjVFMz+RlUdFDZhnOGYIsVgAJ7dH6hmb+dFloBE7OF6XVuOd1e7DEndR0/4QFgF0SWNhHeK5JwMAv0JRqo43rL+Lii04Tr71RDqfsD09Bh9dYR3GwY2FuEEt7gxjZwAXbjsMeEAn99tAPI9Ub+1cDdOQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282545; c=relaxed/simple;
	bh=0SMy/mWNEkNCAIZZ691x+uHGi4S9XCyFgb/x0N/WfDY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mbPRWr35blhKycC/YrA/hDJDZqsUTndJHQXNdpZWvhR1m8rnMPYtCtYWlQgGsRRn2g9+68bmDRcnAt5/9C2300ItF7K85fZ6YUAoecWMGMdvD41vwHaI/xv4c+hsjjJwYuO+YiG+yyNZgdqdCsshfJ+yq45S24hC7vkVExDmPXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dK46Khdi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dK46Khdi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBDF7C2BBFC;
	Thu, 13 Jun 2024 12:42:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282545;
	bh=0SMy/mWNEkNCAIZZ691x+uHGi4S9XCyFgb/x0N/WfDY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dK46KhdiFav37uE5qiUfYiOSv2CMppAIz6KL2KzLXVwXYFqGhCeMJ9CPToqnVeOf1
	 BVTuZwO3CwoaJC9JT8nPelkqOl3yI2uVgHpmg/EmNjyWuSe4LfOMI+HF0yNxjaDbfo
	 3TXo91Mdp/uO/hTLwz/PFKv2ULjUGamrefdSLKbk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carolina Jubran <cjubran@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 312/402] net/mlx5e: Use rx_missed_errors instead of rx_dropped for reporting buffer exhaustion
Date: Thu, 13 Jun 2024 13:34:29 +0200
Message-ID: <20240613113314.312711499@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 923be5fb7d216..79d687c663d54 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3185,7 +3185,7 @@ mlx5e_get_stats(struct net_device *dev, struct rtnl_link_stats64 *stats)
 		mlx5e_fold_sw_stats64(priv, stats);
 	}
 
-	stats->rx_dropped = priv->stats.qcnt.rx_out_of_buffer;
+	stats->rx_missed_errors = priv->stats.qcnt.rx_out_of_buffer;
 
 	stats->rx_length_errors =
 		PPORT_802_3_GET(pstats, a_in_range_length_errors) +
-- 
2.43.0



