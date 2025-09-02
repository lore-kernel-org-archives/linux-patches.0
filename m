Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A48902F9C3D;
	Tue,  2 Sep 2025 13:26:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819583; cv=none; b=OFSOlkvfrChJMQxIwKywW44APj3FJvQcY7b7HR6BfvHydbvjrDnAWmDMehV96UdGPowxGpXUm+GWGfRLemQTeiHa8lnyok9oS/4l106/riv1RTD/QYPkOoFPF7sZIWE8cTNfg7kGlBON1RTpLYp6dpPBAAXHPB9CvbIfza+5G2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819583; c=relaxed/simple;
	bh=OwTCGxVwL3lKFA8BO4b6OKdjubx0OKH36G1VjoRsLtM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UqumJqW70MrPGwTfvT7ZjL9lLP4fhHd8xqIXvbbezivk21FT+IkBmm+xA2reIeSHelAoWJ13Et9FgRh3tnfrY0K2bNuA2pj2bje6C2SBAUkenEkd0HzFDLim2tMPWy1/OLcPR2Mi5+bqi88ADNyoxwNVjWzD2Gh9xd0h8nzsFDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uHzooTGH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uHzooTGH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2683C4CEED;
	Tue,  2 Sep 2025 13:26:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756819583;
	bh=OwTCGxVwL3lKFA8BO4b6OKdjubx0OKH36G1VjoRsLtM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uHzooTGHPZJdR14a6U9ykTw3GejwG41wKw/NiN7E9ZLpP4Zr5kng4MFRad3zhKJfv
	 UpVHUO4q2E6GinB/p6oMFcBvqU2YnVw+Y7HDxqVqiJZW67vnB0r6pV8CjIl4URHVXv
	 WcduP2qs2SsWpWh21DNtjBen2JdhMqW2eqmfYF2c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lama Kayal <lkayal@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 078/142] net/mlx5: HWS, Fix memory leak in hws_pool_buddy_init error path
Date: Tue,  2 Sep 2025 15:19:40 +0200
Message-ID: <20250902131951.258726459@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131948.154194162@linuxfoundation.org>
References: <20250902131948.154194162@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lama Kayal <lkayal@nvidia.com>

[ Upstream commit 2c0a959bebdc1ada13cf9a8242f177c5400299e6 ]

In the error path of hws_pool_buddy_init(), the buddy allocator cleanup
doesn't free the allocator structure itself, causing a memory leak.

Add the missing kfree() to properly release all allocated memory.

Fixes: c61afff94373 ("net/mlx5: HWS, added memory management handling")
Signed-off-by: Lama Kayal <lkayal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Link: https://patch.msgid.link/20250825143435.598584-2-mbloch@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/hws/pool.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/pool.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/pool.c
index 7e37d6e9eb836..7b5071c3df368 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/pool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/pool.c
@@ -124,6 +124,7 @@ static int hws_pool_buddy_init(struct mlx5hws_pool *pool)
 		mlx5hws_err(pool->ctx, "Failed to create resource type: %d size %zu\n",
 			    pool->type, pool->alloc_log_sz);
 		mlx5hws_buddy_cleanup(buddy);
+		kfree(buddy);
 		return -ENOMEM;
 	}
 
-- 
2.50.1



