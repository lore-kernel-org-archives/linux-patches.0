Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B50AB17744
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:30:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37083C433CA;
	Wed,  9 Aug 2023 11:30:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691580633;
	bh=yeCj+cu0WTpcJuybK+JcehKxFnsCFcdMLJJYTrY8kVw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e6A6n1ZwEo6GO7kfnq+4nAkm2/mB4ffb1Ui5h4k+2Obx5huOFmy9B9su1MbOTv2ht
	 dKZkJ9dDRTeiUbisjtqvgI5ANG1Uz+PTPtzLJDtJTgvV7V6SjW+NW7u4z/5QKvh1tx
	 z1ESCgU2ZtSVfcdc6s5o+K/DrBi+MbuM7xPfhwVQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhengchao Shao <shaozhengchao@huawei.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 095/154] net/mlx5: DR, fix memory leak in mlx5dr_cmd_create_reformat_ctx
Date: Wed,  9 Aug 2023 12:42:06 +0200
Message-ID: <20230809103640.123863475@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103636.887175326@linuxfoundation.org>
References: <20230809103636.887175326@linuxfoundation.org>
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
index 64f6f529f6eb1..45b90c7698787 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c
@@ -423,11 +423,12 @@ int mlx5dr_cmd_create_reformat_ctx(struct mlx5_core_dev *mdev,
 
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



