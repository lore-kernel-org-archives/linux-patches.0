Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BE05129EF9;
	Mon, 18 Dec 2023 13:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gL9wreqv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90CD0C433C7;
	Mon, 18 Dec 2023 13:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702907985;
	bh=s/FQ1TMAtN3WVVY8dY1QRQJG3wuyyAX5CriaSueXfsI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gL9wreqvgHdArwFVm18Z4xqsgS3fEtzm+6wR1+KL6NEdEC2kpqhlzH7YL6wbL2/tN
	 d9kKgP/jS4hRhapGePIitlFFiUn2va3CNIbKTayB5P0gHYOVYnwG5JPgcCU3NuPM+J
	 8GU3zURI8C0zvvJKfAZqoqJOFsTMmn/PPjYBUt28=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianbo Liu <jianbol@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 012/166] net/mlx5e: Check the number of elements before walk TC rhashtable
Date: Mon, 18 Dec 2023 14:49:38 +0100
Message-ID: <20231218135105.512953151@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231218135104.927894164@linuxfoundation.org>
References: <20231218135104.927894164@linuxfoundation.org>
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

From: Jianbo Liu <jianbol@nvidia.com>

[ Upstream commit 4e25b661f484df54b6751b65f9ea2434a3b67539 ]

After IPSec TX tables are destroyed, the flow rules in TC rhashtable,
which have the destination to IPSec, are restored to the original
one, the uplink.

However, when the device is in switchdev mode and unload driver with
IPSec rules configured, TC rhashtable cleanup is done before IPSec
cleanup, which means tc_ht->tbl is already freed when walking TC
rhashtable, in order to restore the destination. So add the checking
before walking to avoid unexpected behavior.

Fixes: d1569537a837 ("net/mlx5e: Modify and restore TC rules for IPSec TX rules")
Signed-off-by: Jianbo Liu <jianbol@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/esw/ipsec_fs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/ipsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/ipsec_fs.c
index 13b5916b64e22..d5d33c3b3aa2a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/ipsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/ipsec_fs.c
@@ -152,7 +152,7 @@ void mlx5_esw_ipsec_restore_dest_uplink(struct mlx5_core_dev *mdev)
 
 	xa_for_each(&esw->offloads.vport_reps, i, rep) {
 		rpriv = rep->rep_data[REP_ETH].priv;
-		if (!rpriv || !rpriv->netdev)
+		if (!rpriv || !rpriv->netdev || !atomic_read(&rpriv->tc_ht.nelems))
 			continue;
 
 		rhashtable_walk_enter(&rpriv->tc_ht, &iter);
-- 
2.43.0



