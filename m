Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B91A21991AA;
	Wed, 20 Nov 2024 12:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107597; cv=none; b=acLpvqR379npyhn6lRl3LefTXz3HYjUTuaPsHQZ+WPpMihTjZqwKl4MQb4H7hbcWYi/dO3TqxzNv47yHGXdvPQF6h/EuYPitpvl6KKLTlEY5H8KTnetfTEBWLRfm5TuS/U2vl1GKwy4g7Z6n13bZs1QF63hTjmytErCou3F7Ed8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107597; c=relaxed/simple;
	bh=45yIjXWBLztkJVDPjoS+CYxZBX/oFSA+atdZAkZwE2E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iEPuNv4ku0d7aC+jASLQPw99qcmUmJR63jcipJDTlLuvkq4D+ALR1nr5n2yafr+oRaEpIVXMb7C/CKhi/TPXBDKJR6Eu4NimyhmdLaOA5Mkau/7JfskuU69IGaSM+fM2TDy4b0HgQZzgte5xfJlxoTkkPh6kXhRkx+l5/yLNPgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hld6EWyo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hld6EWyo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E993C4CECD;
	Wed, 20 Nov 2024 12:59:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107597;
	bh=45yIjXWBLztkJVDPjoS+CYxZBX/oFSA+atdZAkZwE2E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hld6EWyosAl51Vsp4ZE/kbKWXLDi0B7UC+J7vc5PzupP9FKP4yFL+3zL+lXL723+e
	 oi/0GTR/LBcDUsanEunmQCZLdhl/WJ4r8WM6Uhq05uKyZRZJSnQZN9m73W+2JA7PES
	 0n4MUSEPxLFT5LGvGOcrL71nsp6rhvFJRZrMi/pA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	William Tu <witu@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 09/82] net/mlx5e: clear xdp features on non-uplink representors
Date: Wed, 20 Nov 2024 13:56:19 +0100
Message-ID: <20241120125629.826354673@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125629.623666563@linuxfoundation.org>
References: <20241120125629.623666563@linuxfoundation.org>
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
index a65c407aa60bd..6e431f587c233 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -4067,7 +4067,8 @@ void mlx5e_set_xdp_feature(struct net_device *netdev)
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



