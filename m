Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30F0822F767;
	Sat, 17 Oct 2026 16:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253439; cv=none; b=uhWxNXv/gyGRb5B+y8xTUcGPQuqZ52yIdKakoRpkeDfKvD/Zwjzj2gCNIJKldFNTgXLtpX1eRshqdvQiL6XyucHcvoi4BDUzJ2RwOI5YehITuH10ttqiCBhh2n7OrPtgz60nlk6YyQP6iDYx39n0jD9/SYjRB4Rn/GCNyEErGTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253439; c=relaxed/simple;
	bh=AS83vt4ACBWJrZan1LH5nC5NOO+sb1+r8jQ2GXlAZ54=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nQMZoBjQ6C2VaDZVU/CQTo85dRzDygIQJFTUdo1FEJaQKs/eM/qvxkBnILaqp8K0sB2DIRqeMV/pdilOJ0jfJycGk8n9AjSA4G0fC+qQx3P/+ihBuHAYKrwq11ZX/La6+pR15JoWp7Qfk1cewNpvH1RhYJKIzpvqORIu8BOjSYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jzg25SGe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jzg25SGe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FFDA1F000C4;
	Sat, 17 Oct 2026 16:10:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253438;
	bh=c/Y8FkbSOeLBHCljY+MKF0iIUQbMf46dJlYQvh6Oalg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Jzg25SGeXBF5mfsrNQxR1ZhjkeMsFNP8ebYaCR2hbqAk3OgxLv1sGEzkNDeLET/aS
	 ezUb5uM73GliDkKyOpLOUOgHWc4hoPHM4r1jHSnuOYFZtff3hejkbZd/x+UNKOYvgq
	 /B5W3YqMFg5gkZzauI7+NW6P8mXx6CDAQ7m4edDI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lama Kayal <lkayal@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 119/869] net/mlx5: HWS, Fix memory leak in hws_pool_buddy_init error path
Date: Sat, 17 Oct 2026 17:49:20 +0200
Message-ID: <20261017160040.094636084@linuxfoundation.org>
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
 .../net/ethernet/mellanox/mlx5/core/steering/hws/mlx5hws_pool.c  | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/mlx5hws_pool.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/mlx5hws_pool.c
index 2fc0e5dfbaefc..a6f542704fe46 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/mlx5hws_pool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/mlx5hws_pool.c
@@ -124,6 +124,7 @@ static int hws_pool_buddy_init(struct mlx5hws_pool *pool)
 		mlx5hws_err(pool->ctx, "Failed to create resource type: %d size %zu\n",
 			    pool->type, pool->alloc_log_sz);
 		mlx5hws_buddy_cleanup(buddy);
+		kfree(buddy);
 		return -ENOMEM;
 	}
 
-- 
2.53.0



