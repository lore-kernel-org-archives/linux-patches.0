Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B97DC8BE5
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:49:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40436C433C0;
	Mon, 19 Jun 2023 10:49:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687171743;
	bh=+K4C3K/tVYTECLkwCGA83krMjP9183O96rIN1vShGIw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=txeB3iYeUDwwKV6pokqsjqssXIN352TIFiL11Wa14rYxU6aArlWSSFhemIqz+6ERD
	 TWauy1owsE+/vF6Uz0lqQzueUDKErjJfuWrajVKgbJcoNOYHN7jc1Z/CyZq+Y4l4AG
	 cKoSDarfzu7OQxC0bao5FKlkbOxsx17glWTJzsuw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maher Sanalla <msanalla@nvidia.com>,
	Maor Gottlieb <maorg@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 116/166] RDMA/mlx5: Initiate dropless RQ for RAW Ethernet functions
Date: Mon, 19 Jun 2023 12:29:53 +0200
Message-ID: <20230619102200.473186710@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102154.568541872@linuxfoundation.org>
References: <20230619102154.568541872@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Maher Sanalla <msanalla@nvidia.com>

[ Upstream commit ee4d269eccfea6c17b18281bef482700d898e86f ]

Delay drop data is initiated for PFs that have the capability of
rq_delay_drop and are in roce profile.

However, PFs with RAW ethernet profile do not initiate delay drop data
on function load, causing kernel panic if delay drop struct members are
accessed later on in case a dropless RQ is created.

Thus, stage the delay drop initialization as part of RAW ethernet
PF loading process.

Fixes: b5ca15ad7e61 ("IB/mlx5: Add proper representors support")
Signed-off-by: Maher Sanalla <msanalla@nvidia.com>
Reviewed-by: Maor Gottlieb <maorg@nvidia.com>
Link: https://lore.kernel.org/r/2e9d386785043d48c38711826eb910315c1de141.1685960567.git.leon@kernel.org
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index eaa35e1df2a85..3178df55c4d85 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -4250,6 +4250,9 @@ const struct mlx5_ib_profile raw_eth_profile = {
 	STAGE_CREATE(MLX5_IB_STAGE_POST_IB_REG_UMR,
 		     mlx5_ib_stage_post_ib_reg_umr_init,
 		     NULL),
+	STAGE_CREATE(MLX5_IB_STAGE_DELAY_DROP,
+		     mlx5_ib_stage_delay_drop_init,
+		     mlx5_ib_stage_delay_drop_cleanup),
 	STAGE_CREATE(MLX5_IB_STAGE_RESTRACK,
 		     mlx5_ib_restrack_init,
 		     NULL),
-- 
2.39.2



