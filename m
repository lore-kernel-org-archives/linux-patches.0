Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 919B917084B;
	Wed,  3 Jul 2024 11:01:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004515; cv=none; b=rcxhYBWm/oyoH/b5FR33ay/uUCp0zu90lJzSFcyfamzw4oBB6q4FphUUUNtr+Qb4SOr5JNRaoo+tbbP5DYfqTTPfxkXdQDs3N/rFFMdD5W3d9mYzTNpJH+Xx5BtbfOhaDi9LfH1wgD9R/uXKwbPZ5Jydn1qdRa3T93qrPpyqAno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004515; c=relaxed/simple;
	bh=W+sTicut/MwiOWXCLWVy7z8c/rMo5bWSj2JE2xI9Z/0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UAZOQTESp28ERS1ojdGj8cb7xrkScKpboRKkmX47EayqXDlOXVx5mSmVL8VjDKJKrN/TCHuS6lbvBG3WwSEPnHhC0WXf9QtThPCeJ56Mu2pdszBf02GhqoabwloiAyQqtKWHyFsrBTtvNUA98XWT190GKiCQoQudiwFuPE+dNyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m+YBLK9H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m+YBLK9H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1847EC2BD10;
	Wed,  3 Jul 2024 11:01:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004515;
	bh=W+sTicut/MwiOWXCLWVy7z8c/rMo5bWSj2JE2xI9Z/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m+YBLK9H8Hs6iIz1dvaRqC919fiUjp+Ydbh1gC5Ioji0QHIs0Gw1OATfqTbo+4006
	 8LEJMugHxGLhHnwPwWc1y3MZBzxWnoGbx6EYHDyFjmqG+oC2NR1ezkIHqKqKvkXWMX
	 ZgvP5dORGLoZIlLkSxrxSgLKmtkern2YxeLdpoOw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gal Pressman <gal@nvidia.com>,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Wojciech Drewek <wojciech.drewek@intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 068/290] net/mlx5e: Fix features validation check for tunneled UDP (non-VXLAN) packets
Date: Wed,  3 Jul 2024 12:37:29 +0200
Message-ID: <20240703102906.767443378@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gal Pressman <gal@nvidia.com>

[ Upstream commit 791b4089e326271424b78f2fae778b20e53d071b ]

Move the vxlan_features_check() call to after we verified the packet is
a tunneled VXLAN packet.

Without this, tunneled UDP non-VXLAN packets (for ex. GENENVE) might
wrongly not get offloaded.
In some cases, it worked by chance as GENEVE header is the same size as
VXLAN, but it is obviously incorrect.

Fixes: e3cfc7e6b7bd ("net/mlx5e: TX, Add geneve tunnel stateless offload support")
Signed-off-by: Gal Pressman <gal@nvidia.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Wojciech Drewek <wojciech.drewek@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index f1834853872da..aeb8bb3c549a1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -4393,7 +4393,7 @@ static netdev_features_t mlx5e_tunnel_features_check(struct mlx5e_priv *priv,
 
 		/* Verify if UDP port is being offloaded by HW */
 		if (mlx5_vxlan_lookup_port(priv->mdev->vxlan, port))
-			return features;
+			return vxlan_features_check(skb, features);
 
 #if IS_ENABLED(CONFIG_GENEVE)
 		/* Support Geneve offload for default UDP port */
@@ -4414,7 +4414,6 @@ netdev_features_t mlx5e_features_check(struct sk_buff *skb,
 	struct mlx5e_priv *priv = netdev_priv(netdev);
 
 	features = vlan_features_check(skb, features);
-	features = vxlan_features_check(skb, features);
 
 #ifdef CONFIG_MLX5_EN_IPSEC
 	if (mlx5e_ipsec_feature_check(skb, netdev, features))
-- 
2.43.0



