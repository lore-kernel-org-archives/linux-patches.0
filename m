Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4028C8F57
	for <patches@lists.linux.dev>; Mon, 13 Feb 2023 14:54:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAB03C433EF;
	Mon, 13 Feb 2023 14:54:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676300078;
	bh=R0kwmgjr7k6VaSknFET5etDqGFQfopj1WRIbD6IDDsY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FWLOXiBzKCc3NJoBKX6gtEtFiYdCIICI+Da4IB+WO/62aE3zb6ui7QFrXK7M2PmcI
	 KR7lS/qNVYFGa/OCSZJF8tKhJIsqo+Lpm/LHgmLYT0glpYx8QIRqf4NejyYjE4tFfd
	 6iumwqL1dpRCCNC4dpAFfIGAwrXkhDrMInxZsiAk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shay Drory <shayd@nvidia.com>,
	Moshe Shemesh <moshe@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 051/114] net/mlx5: fw_tracer, Clear load bit when freeing string DBs buffers
Date: Mon, 13 Feb 2023 15:48:06 +0100
Message-Id: <20230213144744.836151031@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144742.219399167@linuxfoundation.org>
References: <20230213144742.219399167@linuxfoundation.org>
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
index 21831386b26e8..d82e98a0cdfa7 100644
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



