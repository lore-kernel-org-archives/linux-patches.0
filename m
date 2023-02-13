Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 382DC8F58
	for <patches@lists.linux.dev>; Mon, 13 Feb 2023 15:05:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1F3CC433D2;
	Mon, 13 Feb 2023 15:05:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676300713;
	bh=kPVyfKwqRC6ArhZ4ktUHXKeLjFTs52NPAy/UBRn5ZQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Np6ry+C22GWm2Uike+r6OZzG0pdRcJK4+iKjVMFhUj7gWmH1A9o5ayfpWWQngBtEr
	 l0COp36oF3jw5C+DgDsZREOcebUsgtFP1iWWREBwr5RDQ8MOwYiesvqYQshXRQzjOU
	 cMufI9ZLXoMQJgOEWX7hpA9iYNLjrAW55PeEkghI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shay Drory <shayd@nvidia.com>,
	Moshe Shemesh <moshe@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 119/139] net/mlx5: fw_tracer, Clear load bit when freeing string DBs buffers
Date: Mon, 13 Feb 2023 15:51:04 +0100
Message-Id: <20230213144752.198541865@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144745.696901179@linuxfoundation.org>
References: <20230213144745.696901179@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Shay Drory <shayd@nvidia.com>

[ Upstream commit db561fed6b8fa3878e74d5df6512a4a38152b63e ]

Whenever the driver is reading the string DBs into buffers, the driver
is setting the load bit, but the driver never clears this bit.
As a result, in case load bit is on and the driver query the device for
new string DBs, the driver won't read again the string DBs.
Fix it by clearing the load bit when query the device for new string
DBs.

Fixes: 2d69356752ff ("net/mlx5: Add support for fw live patch event")
Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
index f800e1ca5ba62..76232abfc7863 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
@@ -64,6 +64,7 @@ static int mlx5_query_mtrc_caps(struct mlx5_fw_tracer *tracer)
 			MLX5_GET(mtrc_cap, out, num_string_trace);
 	tracer->str_db.num_string_db = MLX5_GET(mtrc_cap, out, num_string_db);
 	tracer->owner = !!MLX5_GET(mtrc_cap, out, trace_owner);
+	tracer->str_db.loaded = false;
 
 	for (i = 0; i < tracer->str_db.num_string_db; i++) {
 		mtrc_cap_sp = MLX5_ADDR_OF(mtrc_cap, out, string_db_param[i]);
-- 
2.39.0



