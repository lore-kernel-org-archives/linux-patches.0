Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA8CBA93F
	for <patches@lists.linux.dev>; Tue, 10 Jan 2023 18:15:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25B2CC433D2;
	Tue, 10 Jan 2023 18:15:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673374545;
	bh=/zGeEPn2WfYDY9JjeR/hifaPPmIvKNAVdXiuluQp/3I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YJoB60U+C6th6DuEJjlUJ9lq7WUlJrg4A9EarCHn7i/7aS9W8zRvzKYlK0dMHsEo6
	 ykGllrHoYfW3Ko+BOFR3UwLDtiZkXQLYwmMYm0GCeb+a6r9nSDDbIgZjty82crJdw3
	 NG6IEazrBLykc2Xd+3/xdyhqmXhU+4ciEAND3tZE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Pirko <jiri@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 052/159] net/mlx5: Add forgotten cleanup calls into mlx5_init_once() error path
Date: Tue, 10 Jan 2023 19:03:20 +0100
Message-Id: <20230110180019.960921361@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180018.288460217@linuxfoundation.org>
References: <20230110180018.288460217@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jiri Pirko <jiri@nvidia.com>

[ Upstream commit 2a35b2c2e6a252eda2134aae6a756861d9299531 ]

There are two cleanup calls missing in mlx5_init_once() error path.
Add them making the error path flow to be the same as
mlx5_cleanup_once().

Fixes: 52ec462eca9b ("net/mlx5: Add reserved-gids support")
Fixes: 7c39afb394c7 ("net/mlx5: PTP code migration to driver core section")
Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index e58775a7d955..6776bf5b8d55 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1051,6 +1051,8 @@ static int mlx5_init_once(struct mlx5_core_dev *dev)
 err_tables_cleanup:
 	mlx5_geneve_destroy(dev->geneve);
 	mlx5_vxlan_destroy(dev->vxlan);
+	mlx5_cleanup_clock(dev);
+	mlx5_cleanup_reserved_gids(dev);
 	mlx5_cq_debugfs_cleanup(dev);
 	mlx5_fw_reset_cleanup(dev);
 err_events_cleanup:
-- 
2.35.1



