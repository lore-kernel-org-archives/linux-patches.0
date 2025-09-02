Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEDBE30505A;
	Tue,  2 Sep 2025 13:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819587; cv=none; b=I225D6WBr6m8OQCw2z5/OWe94VhGvMdWNq/28vViSJlzsVl4Y400FMqHY8Wlf2nn6pol8kxvVPqnqo0cezSIIxo87Oanso4SylWQ05SDYBLAj0bgNi0RRGxF1FRgIS2C/MbuXR1YgzV9qwbjio2M6SJnqb9gu2p45dsVQrYwWjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819587; c=relaxed/simple;
	bh=0ushCIXqAunFs9W/bTF6VNK265qdAUNXrn/zHh68NkE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LTeI71yVMiQ0CCDuLe0B0XEeF+mM7eGS9PK5bc1AA1KImrJNmsU0qolPz4OnSgvbL17Oo4zXozclMKUPS3Uqu1cRfmRi+CdM2zH4ujoj/d7RKJKiVUucT5JV1WRW1122j4/zvqu6lr8aujnKegX5ISyptrDuG8DvFAkG5/nN9T0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BXLejzV6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BXLejzV6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E1E0C4CEED;
	Tue,  2 Sep 2025 13:26:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756819586;
	bh=0ushCIXqAunFs9W/bTF6VNK265qdAUNXrn/zHh68NkE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BXLejzV6mt4dI+aR2EfDNtnMsJfRPRYUVQrX1b8loyBeZh2VIGy4ZAiFzxCzkQVDy
	 JepFmHx3fEdrP62qYDLy/Xx2pEwggMCP8C37l1Mq/7ANXluKivTgGyn/j3bJpIQmaj
	 dudJBHvDhZMUYzecBuqGMJvG9HTHcOqMUBzHt3NQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lama Kayal <lkayal@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 079/142] net/mlx5: HWS, Fix memory leak in hws_action_get_shared_stc_nic error flow
Date: Tue,  2 Sep 2025 15:19:41 +0200
Message-ID: <20250902131951.296106878@linuxfoundation.org>
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

[ Upstream commit a630f83592cdad1253523a1b760cfe78fef6cd9c ]

When an invalid stc_type is provided, the function allocates memory for
shared_stc but jumps to unlock_and_out without freeing it, causing a
memory leak.

Fix by jumping to free_shared_stc label instead to ensure proper cleanup.

Fixes: 504e536d9010 ("net/mlx5: HWS, added actions handling")
Signed-off-by: Lama Kayal <lkayal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Link: https://patch.msgid.link/20250825143435.598584-3-mbloch@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/hws/action.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/action.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/action.c
index 447ea3f8722ce..8e4a085f4a2ec 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/action.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/action.c
@@ -117,7 +117,7 @@ static int hws_action_get_shared_stc_nic(struct mlx5hws_context *ctx,
 		mlx5hws_err(ctx, "No such stc_type: %d\n", stc_type);
 		pr_warn("HWS: Invalid stc_type: %d\n", stc_type);
 		ret = -EINVAL;
-		goto unlock_and_out;
+		goto free_shared_stc;
 	}
 
 	ret = mlx5hws_action_alloc_single_stc(ctx, &stc_attr, tbl_type,
-- 
2.50.1



