Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0549412FB31;
	Wed, 19 Jun 2024 13:05:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802359; cv=none; b=Wl/pox5M0B8N5i2JnR3Gi2A2+715OGt39zQt5L3pkfbZKpL9gfq5tU5Wdmd2xiP1xFZHJyYpAtJx8CfCw+/H5lE5t3lh3wttPWzaYBaOHR3XMGpafKUeIbKzl/S4mx3xGG8k5thG9Ffm+QkDe2uFy3ofyo9nM89EYmo+IHQC5wc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802359; c=relaxed/simple;
	bh=YRWQPErqdQheVKxlpUjqNAINrzxlPq+Fk3NzlZJIlgE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G8A3dgQV8hYh5LeFRansUwEzKlLuOxo8GQyCiy300zDd5Y5UcpADg4VBkBdIqZBo8NnwsT2WJm+SfGwl4PtNUZK34/8jgViWwpZq3fKETS9/5sxF5ZB+DdJ8gn9t1KV/jnssyPPv73IVVFj1ocBLh6CwnQtuZ8h3Ez721yQpB9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LBEyO3nA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LBEyO3nA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34C89C2BBFC;
	Wed, 19 Jun 2024 13:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802358;
	bh=YRWQPErqdQheVKxlpUjqNAINrzxlPq+Fk3NzlZJIlgE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LBEyO3nACIA78Q+ci4aDidULLlzkgG2pjWIu8IdSPHTLe1NyEaW453f+O6uPkm7Vd
	 ZKogtMrBEu+OOWNNOZkfDltBiLKjkQY+4tcQFqzBOwF6nhlXl3HpT42hYEk6QcEaGv
	 ygqu9L/h6hcDr7i2o5DEJJwm6VUwnuOdR8IUKXKw=
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
Subject: [PATCH 6.6 152/267] net/mlx5e: Fix features validation check for tunneled UDP (non-VXLAN) packets
Date: Wed, 19 Jun 2024 14:55:03 +0200
Message-ID: <20240619125612.179766888@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
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
index 455907b1167a0..e87a776ea2bfd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -4704,7 +4704,7 @@ static netdev_features_t mlx5e_tunnel_features_check(struct mlx5e_priv *priv,
 
 		/* Verify if UDP port is being offloaded by HW */
 		if (mlx5_vxlan_lookup_port(priv->mdev->vxlan, port))
-			return features;
+			return vxlan_features_check(skb, features);
 
 #if IS_ENABLED(CONFIG_GENEVE)
 		/* Support Geneve offload for default UDP port */
@@ -4730,7 +4730,6 @@ netdev_features_t mlx5e_features_check(struct sk_buff *skb,
 	struct mlx5e_priv *priv = netdev_priv(netdev);
 
 	features = vlan_features_check(skb, features);
-	features = vxlan_features_check(skb, features);
 
 	/* Validate if the tunneled packet is being offloaded by HW */
 	if (skb->encapsulation &&
-- 
2.43.0



