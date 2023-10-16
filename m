Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8167B266B7
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 14:48:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZNKCQusb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DAE3C433C7;
	Mon, 16 Oct 2023 14:48:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1697467731;
	bh=drPmrXrfaXFdu8ziIbycDxRZQm7JZTpRhqmDeScoqtY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZNKCQusbBvL8ctbutWkElp1ldFYa2uqTuaVUVrzKd54knlyHJC2e9qTjL3HL2zV2B
	 OKA7gvuZ0P/a5LVaj2pl3CJAECkzVvU9YLqX6tJo3iojfrCwY+yDxrtzfjDtgDOOUl
	 8ze0jkGqdXOGtWFqZ+4X31lbQTNsO3rwPIfpGT50=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charlotte Tan <charlotte@extrahop.com>,
	Adham Faris <afaris@nvidia.com>,
	Aya Levin <ayal@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Moshe Shemesh <moshe@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Will Mortensen <will@extrahop.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 078/191] net/mlx5e: Again mutually exclude RX-FCS and RX-port-timestamp
Date: Mon, 16 Oct 2023 10:41:03 +0200
Message-ID: <20231016084017.225837513@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231016084015.400031271@linuxfoundation.org>
References: <20231016084015.400031271@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Will Mortensen <will@extrahop.com>

[ Upstream commit da6192ca72d5ad913d109d43dc896290ad05d98f ]

Commit 1e66220948df8 ("net/mlx5e: Update rx ring hw mtu upon each rx-fcs
flag change") seems to have accidentally inverted the logic added in
commit 0bc73ad46a76 ("net/mlx5e: Mutually exclude RX-FCS and
RX-port-timestamp").

The impact of this is a little unclear since it seems the FCS scattered
with RX-FCS is (usually?) correct regardless.

Fixes: 1e66220948df8 ("net/mlx5e: Update rx ring hw mtu upon each rx-fcs flag change")
Tested-by: Charlotte Tan <charlotte@extrahop.com>
Reviewed-by: Charlotte Tan <charlotte@extrahop.com>
Cc: Adham Faris <afaris@nvidia.com>
Cc: Aya Levin <ayal@nvidia.com>
Cc: Tariq Toukan <tariqt@nvidia.com>
Cc: Moshe Shemesh <moshe@nvidia.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Will Mortensen <will@extrahop.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://lore.kernel.org/r/20231006053706.514618-1-will@extrahop.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index f7b494125eee8..0cbe822ab084f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3952,13 +3952,14 @@ static int set_feature_rx_fcs(struct net_device *netdev, bool enable)
 	struct mlx5e_channels *chs = &priv->channels;
 	struct mlx5e_params new_params;
 	int err;
+	bool rx_ts_over_crc = !enable;
 
 	mutex_lock(&priv->state_lock);
 
 	new_params = chs->params;
 	new_params.scatter_fcs_en = enable;
 	err = mlx5e_safe_switch_params(priv, &new_params, mlx5e_set_rx_port_ts_wrap,
-				       &new_params.scatter_fcs_en, true);
+				       &rx_ts_over_crc, true);
 	mutex_unlock(&priv->state_lock);
 	return err;
 }
-- 
2.40.1



