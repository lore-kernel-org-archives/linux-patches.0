Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51B5E1C95F0;
	Thu,  6 Jun 2024 14:22:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683734; cv=none; b=B1ISMch0tPJgD04RPB2jyVCaozZ2e9tTABSmzCYnQFKKX678Au5VDvpeZYwoyceUb35solLf0o1dEJGWRb/Wr8Prv4pl2u5pPeEV7gWM9zyqmNLG7k1FXIpovZWD84GZkQpG0Rc2fmKIGM+aKgOliseQ52mC2xoxd3gidLWspAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683734; c=relaxed/simple;
	bh=XTNw5fM6j6cjCsRdzi6GETmN6mDondn0TgqN463OagM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CUxgsE9a4xECXI8HGKsWeseylgn28zaYerKqb49qP9eP/U8kmqZ0NcG6rN5djg6u4m09qyoA1tsj/Ff31/5MxVYWccSfJZ8ysDh3kBt/8QDDVCFzf1b/3jhOzlBqRjbG63By2ilpSyqZ2FJHFm7/zz8ExyctEUW8TA4dRlrYxR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B0dfTYN9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B0dfTYN9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3142CC2BD10;
	Thu,  6 Jun 2024 14:22:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683734;
	bh=XTNw5fM6j6cjCsRdzi6GETmN6mDondn0TgqN463OagM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B0dfTYN9l7D4/CwQcSK5GidWjoJaKCDoDxCnrEhOceSrGkpUNc1/PwsGDQzAiu2WP
	 y4YBmfY2K0aZMvWaTumwxuTxjp5Wb/Z2r9B4EFr/Z0D6PyjLBqS66ha7AZWhOjSrha
	 cYFLswm3AOidV9xrvP1v2F3o3Bxt/ktdKJ018fCw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rahul Rameshbabu <rrameshbabu@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 688/744] net/mlx5e: Fix IPsec tunnel mode offload feature check
Date: Thu,  6 Jun 2024 16:06:00 +0200
Message-ID: <20240606131754.552900339@linuxfoundation.org>
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

From: Rahul Rameshbabu <rrameshbabu@nvidia.com>

[ Upstream commit 9a52f6d44f4521773b4699b4ed34b8e21d5a175c ]

Remove faulty check disabling checksum offload and GSO for offload of
simple IPsec tunnel L4 traffic. Comment previously describing the deleted
code incorrectly claimed the check prevented double tunnel (or three layers
of ip headers).

Fixes: f1267798c980 ("net/mlx5: Fix checksum issue of VXLAN and IPsec crypto offload")
Signed-off-by: Rahul Rameshbabu <rrameshbabu@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../mellanox/mlx5/core/en_accel/ipsec_rxtx.h    | 17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h
index 9ee014a8ad24a..ff59c6adbb963 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h
@@ -99,18 +99,11 @@ mlx5e_ipsec_feature_check(struct sk_buff *skb, netdev_features_t features)
 		if (!x || !x->xso.offload_handle)
 			goto out_disable;
 
-		if (xo->inner_ipproto) {
-			/* Cannot support tunnel packet over IPsec tunnel mode
-			 * because we cannot offload three IP header csum
-			 */
-			if (x->props.mode == XFRM_MODE_TUNNEL)
-				goto out_disable;
-
-			/* Only support UDP or TCP L4 checksum */
-			if (xo->inner_ipproto != IPPROTO_UDP &&
-			    xo->inner_ipproto != IPPROTO_TCP)
-				goto out_disable;
-		}
+		/* Only support UDP or TCP L4 checksum */
+		if (xo->inner_ipproto &&
+		    xo->inner_ipproto != IPPROTO_UDP &&
+		    xo->inner_ipproto != IPPROTO_TCP)
+			goto out_disable;
 
 		return features;
 
-- 
2.43.0



