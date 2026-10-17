Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FEB5355F49;
	Sat, 17 Oct 2026 16:12:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253553; cv=none; b=kbXCgaumtrGSoszqy6Qh08tZxSiVnD7TiG24Ui8vIuAs/hxoflaZX+L4UOdLRbsJaOJbgV1+fGLrQ1B+ielDArlua44bYpaV+d2h0IC3kw00LDW2NJDCc0mPlh+BdYM+VpgLRQzClzEJB46IQXgU8kX9rE9IIv9jmijksPnlb58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253553; c=relaxed/simple;
	bh=fGKZfw2ckvI0J1Lr/+na5ra/Xzv4+ZNc+wgiC9OyAPg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O/a9XeV3vOUZvyTC8XOoCi3fLN9HsvkumKozcPlu0WMYZ5hax89oK2c4fTcNAovAg3tKT/BQmCYYfVkp8wMq+LbgzUm1B76HagSnlSP4X2U9Kl6wffl+BsgYauwvs8rR4SiH5fDRltvSEuLcV5vrVVdqJiOyRJKIG0V2FwKHnqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XlG7Mohq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XlG7Mohq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 645971F000C4;
	Sat, 17 Oct 2026 16:12:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253551;
	bh=lx1MZPxjnBuf9pcM+OaoquY1XI9KsM4PuCYcv9qMlXM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XlG7MohqBtYUXXdDJPhyxu7Pd5Fo7cAAUmbWIJiHISfntzPJqr6CVJPGQKZgkgCGk
	 1wNEIXDWENEaCmujMtKutd9nMspXW7FJV8bKrExbsDga6+jWL9C4vr533qZP1BNtEu
	 FoZvnQWQxOXzek3KXks6Qo3bCnPxG+23zT41eLYs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vlad Dogaru <vdogaru@nvidia.com>,
	Yevgeny Kliteynik <kliteyn@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 114/869] net/mlx5: HWS, handle returned error value in pool alloc
Date: Sat, 17 Oct 2026 17:49:15 +0200
Message-ID: <20261017160039.962806606@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vlad Dogaru <vdogaru@nvidia.com>

[ Upstream commit a105db854cf2e495caaa17f00ac0321b503def9b ]

Handle all negative return values as errors, not just -1.
The code previously treated -ENOMEM (and potentially other negative
values) as valid segment numbers, leading to incorrect behavior.
This fix ensures that any negative return value is treated as an error.

Signed-off-by: Vlad Dogaru <vdogaru@nvidia.com>
Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20250102181415.1477316-13-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 2c0a959bebdc ("net/mlx5: HWS, Fix memory leak in hws_pool_buddy_init error path")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/mellanox/mlx5/core/steering/hws/mlx5hws_pool.c   | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/mlx5hws_pool.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/mlx5hws_pool.c
index a8a63e3278be3..048b97de07625 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/mlx5hws_pool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/mlx5hws_pool.c
@@ -183,7 +183,7 @@ static int hws_pool_buddy_get_mem_chunk(struct mlx5hws_pool *pool,
 	*seg = -1;
 
 	/* Find the next free place from the buddy array */
-	while (*seg == -1) {
+	while (*seg < 0) {
 		for (i = 0; i < MLX5HWS_POOL_RESOURCE_ARR_SZ; i++) {
 			buddy = hws_pool_buddy_get_next_buddy(pool, i,
 							      order,
@@ -194,7 +194,7 @@ static int hws_pool_buddy_get_mem_chunk(struct mlx5hws_pool *pool,
 			}
 
 			*seg = mlx5hws_buddy_alloc_mem(buddy, order);
-			if (*seg != -1)
+			if (*seg >= 0)
 				goto found;
 
 			if (pool->flags & MLX5HWS_POOL_FLAGS_ONE_RESOURCE) {
-- 
2.53.0



