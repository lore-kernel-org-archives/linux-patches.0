Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D08315C82
	for <patches@lists.linux.dev>; Mon,  5 Dec 2022 19:17:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DF0EC433D6;
	Mon,  5 Dec 2022 19:17:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670267848;
	bh=A0mTjZgAIAuVDaSpeCslUl3AzQPNMVnJjEua1GXLDmA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DNkGg9NOOWqrXj1uE99qCtEVL1rtaRc3xK/V7E3fqtWrZEA64Y4R1WcUMY0ZOnH/g
	 loVwA720mG6HGTscRqb0FnS4j2Go4VHkUv3XtULnSCmhtzz7gYoNuiOi6uwtkyN9wt
	 xEcTSw4YqUZ4hRITO5eGjhHOmojIQYv/9HQJpJ4o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	YueHaibing <yuehaibing@huawei.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 45/77] net/mlx5: Fix uninitialized variable bug in outlen_write()
Date: Mon,  5 Dec 2022 20:09:36 +0100
Message-Id: <20221205190802.477347792@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190800.868551051@linuxfoundation.org>
References: <20221205190800.868551051@linuxfoundation.org>
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

[ Upstream commit 3f5769a074c13d8f08455e40586600419e02a880 ]

If sscanf() return 0, outlen is uninitialized and used in kzalloc(),
this is unexpected. We should return -EINVAL if the string is invalid.

Fixes: e126ba97dba9 ("mlx5: Add driver for Mellanox Connect-IB adapters")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
index 6ae9a1987371..ad8be0a81546 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -1309,8 +1309,8 @@ static ssize_t outlen_write(struct file *filp, const char __user *buf,
 		return -EFAULT;
 
 	err = sscanf(outlen_str, "%d", &outlen);
-	if (err < 0)
-		return err;
+	if (err != 1)
+		return -EINVAL;
 
 	ptr = kzalloc(outlen, GFP_KERNEL);
 	if (!ptr)
-- 
2.35.1



