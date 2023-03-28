Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C699D8BE0
	for <patches@lists.linux.dev>; Tue, 28 Mar 2023 14:57:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C1D7C433EF;
	Tue, 28 Mar 2023 14:57:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680015477;
	bh=k6OmYOmLhqmfzJrRhMiLBTNfItdgeSv3qgSrMNFenPs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AuaLHhS3T2ZZzIgOHRV4laOcIMr8leMLPXn7FdMeDvqfFIUI8xVEKmMU2Al9HvBZO
	 i7sfrVvIog6z6r3elIJcjgOK/vMiUOpo4+HF2eHJlrc5CH6XngnqoEZySM6WkHqc8E
	 +rCms5xZR+P7w40UQQi/Q1jVwTT7ePnzX1Od8xkk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gavin Li <gavinl@nvidia.com>,
	Gavi Teitz <gavi@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 064/224] net/mlx5e: Set uplink rep as NETNS_LOCAL
Date: Tue, 28 Mar 2023 16:41:00 +0200
Message-Id: <20230328142620.016809494@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142617.205414124@linuxfoundation.org>
References: <20230328142617.205414124@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Gavin Li <gavinl@nvidia.com>

[ Upstream commit c83172b0639c8a005c0dd3b36252dc22ddd9f19c ]

Previously, NETNS_LOCAL was not set for uplink representors, inconsistent
with VF representors, and allowed the uplink representor to be moved
between net namespaces and separated from the VF representors it shares
the core device with. Such usage would break the isolation model of
namespaces, as devices in different namespaces would have access to
shared memory.

To solve this issue, set NETNS_LOCAL for uplink representors if eswitch is
in switchdev mode.

Fixes: 7a9fb35e8c3a ("net/mlx5e: Do not reload ethernet ports when changing eswitch mode")
Signed-off-by: Gavin Li <gavinl@nvidia.com>
Reviewed-by: Gavi Teitz <gavi@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 609a49c1e09e6..3b5c5064cfafc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -4081,8 +4081,12 @@ static netdev_features_t mlx5e_fix_features(struct net_device *netdev,
 		}
 	}
 
-	if (mlx5e_is_uplink_rep(priv))
+	if (mlx5e_is_uplink_rep(priv)) {
 		features = mlx5e_fix_uplink_rep_features(netdev, features);
+		features |= NETIF_F_NETNS_LOCAL;
+	} else {
+		features &= ~NETIF_F_NETNS_LOCAL;
+	}
 
 	mutex_unlock(&priv->state_lock);
 
-- 
2.39.2



