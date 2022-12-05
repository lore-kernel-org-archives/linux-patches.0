Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C28BD15C83
	for <patches@lists.linux.dev>; Mon,  5 Dec 2022 19:30:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 425B3C433D6;
	Mon,  5 Dec 2022 19:30:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670268644;
	bh=rQWusIHDkKz2sJaXe2wEgKSE/0CKqG0l5WsPyk7drnw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dShPkAhjqooehKY+WbXHCNwXzXpA2qV2pn3AGiHpD3zj+6WsOlszjVMt9CuXZqAvB
	 AElSQyE8ol1uYikgXRvyhwqALI9VsD0tyWUT+cwvXq305KrUXy/ZBFpmIhsYpt0pH7
	 flKLW6CZH4d0rv/KoHNKff5yGnQjgoIEA6KDFVUQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	YueHaibing <yuehaibing@huawei.com>,
	Roi Dayan <roid@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 53/92] net/mlx5: DR, Fix uninitialized var warning
Date: Mon,  5 Dec 2022 20:10:06 +0100
Message-Id: <20221205190805.261040479@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190803.464934752@linuxfoundation.org>
References: <20221205190803.464934752@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit 52f7cf70eb8fac6111786c59ae9dfc5cf2bee710 ]

Smatch warns this:

drivers/net/ethernet/mellanox/mlx5/core/steering/dr_table.c:81
 mlx5dr_table_set_miss_action() error: uninitialized symbol 'ret'.

Initializing ret with -EOPNOTSUPP and fix missing action case.

Fixes: 7838e1725394 ("net/mlx5: DR, Expose steering table functionality")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_table.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_table.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_table.c
index b599b6beb5b9..6a4b997c258a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_table.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_table.c
@@ -9,7 +9,7 @@ int mlx5dr_table_set_miss_action(struct mlx5dr_table *tbl,
 	struct mlx5dr_matcher *last_matcher = NULL;
 	struct mlx5dr_htbl_connect_info info;
 	struct mlx5dr_ste_htbl *last_htbl;
-	int ret;
+	int ret = -EOPNOTSUPP;
 
 	if (action && action->action_type != DR_ACTION_TYP_FT)
 		return -EOPNOTSUPP;
@@ -68,6 +68,9 @@ int mlx5dr_table_set_miss_action(struct mlx5dr_table *tbl,
 		}
 	}
 
+	if (ret)
+		goto out;
+
 	/* Release old action */
 	if (tbl->miss_action)
 		refcount_dec(&tbl->miss_action->refcount);
-- 
2.35.1



