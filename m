Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C829F15853A;
	Wed, 20 Nov 2024 12:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107490; cv=none; b=otJGyA0pqajA9bvvzopsdEQ8zr0Mo3gpUaBr+czodY2gUBPHCXBfwcHcJT1crSFIriRsk44FDD3LzNS4PjRJh12kge0BamiH7VNUi5NInAYvXlCAKNSfa+m8pr+9Suk/tQlqr8MobKFeJ+123YbrjiphvqR8fg9jLqkQTVMS0ss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107490; c=relaxed/simple;
	bh=OCzJSyOHysvjCzGE4l6T2BuPqLXw4wAhmvW1dJ79CbA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DS20+jm2424yvkzeT8++kGf+tsCyTmULYbYn9FvHXf76ecJuVQGsbkl6qjJiTs7LJKy8llaMjxIrbj0xhuRLWNgUo552QUMg0eH1Ly6Y93illdBh8SUHhj38bIqqfNRtnbwb/QtG+R31JhfosG7nS/PUWzeYnzq2HNhwCqbTM+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=phTuzSNf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="phTuzSNf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65100C4CED1;
	Wed, 20 Nov 2024 12:58:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107490;
	bh=OCzJSyOHysvjCzGE4l6T2BuPqLXw4wAhmvW1dJ79CbA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=phTuzSNfnYUQ6c3pdRLbiqIMu5Y9gLg38doeyN8rnmIEJyyTNpRq4CLlJgfpjC0oo
	 PocMlmx7U99YkP/d35gmg5LloWLat5GQfFhuuFcpje3BnhG9VSKbkXSi3A8C/7bQ7t
	 ZXsWT8x84vbI41ASBcg98e0buQm11cb8SfFABkKA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	William Tu <witu@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 011/107] net/mlx5e: clear xdp features on non-uplink representors
Date: Wed, 20 Nov 2024 13:55:46 +0100
Message-ID: <20241120125629.937776747@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125629.681745345@linuxfoundation.org>
References: <20241120125629.681745345@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: William Tu <witu@nvidia.com>

[ Upstream commit c079389878debf767dc4e52fe877b9117258dfe2 ]

Non-uplink representor port does not support XDP. The patch clears
the xdp feature by checking the net_device_ops.ndo_bpf is set or not.

Verify using the netlink tool:
$ tools/net/ynl/cli.py --spec Documentation/netlink/specs/netdev.yaml --dump dev-get

Representor netdev before the patch:
{'ifindex': 8,
  'xdp-features': {'basic',
                   'ndo-xmit',
                   'ndo-xmit-sg',
                   'redirect',
                   'rx-sg',
                   'xsk-zerocopy'},
  'xdp-rx-metadata-features': set(),
  'xdp-zc-max-segs': 1,
  'xsk-features': set()},
With the patch:
 {'ifindex': 8,
  'xdp-features': set(),
  'xdp-rx-metadata-features': set(),
  'xsk-features': set()},

Fixes: 4d5ab0ad964d ("net/mlx5e: take into account device reconfiguration for xdp_features flag")
Signed-off-by: William Tu <witu@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20241107183527.676877-6-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 3e11c1c6d4f69..99d0b977ed3d2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -4266,7 +4266,8 @@ void mlx5e_set_xdp_feature(struct net_device *netdev)
 	struct mlx5e_params *params = &priv->channels.params;
 	xdp_features_t val;
 
-	if (params->packet_merge.type != MLX5E_PACKET_MERGE_NONE) {
+	if (!netdev->netdev_ops->ndo_bpf ||
+	    params->packet_merge.type != MLX5E_PACKET_MERGE_NONE) {
 		xdp_clear_features_flag(netdev);
 		return;
 	}
-- 
2.43.0



