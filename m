Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1970615AE3
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 10:44:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D452C433C7;
	Wed,  9 Aug 2023 10:44:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691577886;
	bh=O3nz5S7DWsITBqqJOKnfk+GNIX3CcPYfIoCTNQJvR08=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QUL+Y0/gSs3Ef5H5htafJ/pdAmVVSWu7au6W7eOweOZ16tZFdnZJsx0+TxIxKy0Hs
	 YVtyRzeS9snKCn0RU4zVdg7V/qDpGs+UYoBErYcHfXp1it5i7k7/flWuGQIzd65cZl
	 0NDNdfgPs9eyzIuCqewZuxl0fVhWBBDuGSxjDxqo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhengchao Shao <shaozhengchao@huawei.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 029/165] net/mlx5: DR, fix memory leak in mlx5dr_cmd_create_reformat_ctx
Date: Wed,  9 Aug 2023 12:39:20 +0200
Message-ID: <20230809103643.767277043@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103642.720851262@linuxfoundation.org>
References: <20230809103642.720851262@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zhengchao Shao <shaozhengchao@huawei.com>

[ Upstream commit 5dd77585dd9d0e03dd1bceb95f0269a7eaf6b936 ]

when mlx5_cmd_exec failed in mlx5dr_cmd_create_reformat_ctx, the memory
pointed by 'in' is not released, which will cause memory leak. Move memory
release after mlx5_cmd_exec.

Fixes: 1d9186476e12 ("net/mlx5: DR, Add direct rule command utilities")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c
index 1aa525e509f10..293d2edd03d59 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c
@@ -562,11 +562,12 @@ int mlx5dr_cmd_create_reformat_ctx(struct mlx5_core_dev *mdev,
 
 	err = mlx5_cmd_exec(mdev, in, inlen, out, sizeof(out));
 	if (err)
-		return err;
+		goto err_free_in;
 
 	*reformat_id = MLX5_GET(alloc_packet_reformat_context_out, out, packet_reformat_id);
-	kvfree(in);
 
+err_free_in:
+	kvfree(in);
 	return err;
 }
 
-- 
2.40.1



