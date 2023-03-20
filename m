Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B51EE1C03
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 15:15:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C9A3C433D2;
	Mon, 20 Mar 2023 15:15:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1679325339;
	bh=n4c3IfGi4HlAcaIysP/FRM5/hLEnZcPytcIfxY6iuck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a7a5BZGjYNvX3J3vDHsoN6j0Q4Wq8kjJP6/h+/hdDXIfm2hFvka4kcGlPHXDBG6ZB
	 6ltsOn/TC1jWN8UIFpoK7nuB0IavJelmetE8VR/ctBWYTbwU5o01HFrccXQeY2uwzI
	 vfLEPxj4n5yji9lF2eiiqHPyQUpf6XKlnMrkOnR8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Jurgens <danielj@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 070/198] net/mlx5: Disable eswitch before waiting for VF pages
Date: Mon, 20 Mar 2023 15:53:28 +0100
Message-Id: <20230320145510.478502630@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145507.420176832@linuxfoundation.org>
References: <20230320145507.420176832@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Daniel Jurgens <danielj@nvidia.com>

[ Upstream commit 7ba930fc25def6fd736abcdfa224272948a65cf7 ]

The offending commit changed the ordering of moving to legacy mode and
waiting for the VF pages. Moving to legacy mode is important in
bluefield, because it sends the host driver into error state, and frees
its pages. Without this transition we end up waiting 2 minutes for
pages that aren't coming before carrying on with the unload process.

Fixes: f019679ea5f2 ("net/mlx5: E-switch, Remove dependency between sriov and eswitch mode")
Signed-off-by: Daniel Jurgens <danielj@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index f07175549a87d..51c3e86f71a94 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1339,8 +1339,8 @@ static int mlx5_load(struct mlx5_core_dev *dev)
 static void mlx5_unload(struct mlx5_core_dev *dev)
 {
 	mlx5_sf_dev_table_destroy(dev);
-	mlx5_sriov_detach(dev);
 	mlx5_eswitch_disable(dev->priv.eswitch);
+	mlx5_sriov_detach(dev);
 	mlx5_lag_remove_mdev(dev);
 	mlx5_ec_cleanup(dev);
 	mlx5_sf_hw_table_destroy(dev);
-- 
2.39.2



