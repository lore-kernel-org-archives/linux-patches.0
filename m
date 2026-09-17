Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BEBB4EF14B;
	Thu, 17 Sep 2026 16:52:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789663923; cv=none; b=Sgaybd8E6S5Ew1lWwk1yipApBn41X1s/+NjnlauiQzM3AgTZWR6Sc9FnL0pn3doYwSAaG+B4iFJpQsinIOUBx5fiJDoTGM2pUvMpwN+D9QmICw9Vau1HY8zD2PADOmQfBJue8W9RCshgj5E1+3Nq26OygXY/8ekqsIaVX7X0HFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789663923; c=relaxed/simple;
	bh=Y6bX69o9Xf1IzAHkOxqYJy6NVNqNe5BmYXyYry97wEM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s4g2E7P4T9W1YE5terK6nqK2+vs2ZyWkVWuYwJbsUh/wDYi+GbPPYxvhwVwivWr7UCSqS8QPQb/wZpOBKXtbMoeijyA+i4I4I6RTEjOPQlyzyVZbSHM1n1Ly8VEerbB/WcPvBRNhUuh3rWuOQ7S/2EOsPvfQRfocOz5rtXA+IgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kBbrUKns; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kBbrUKns"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FF8E1F00899;
	Thu, 17 Sep 2026 16:52:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789663921;
	bh=cmHGmkjIVVnk7pkYYPNw+hEWEo5cWtthhrNXkzwVuuE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kBbrUKnsDmfQromhTnmGTqhz/HpL+ybr9iG+4a2jnCvlMOZ77ck9iiJHNPWHKG7UA
	 TVgqSR4cq3FzC6ZRpw1Nh+LITjsfh7LXmjVKbEHxkkwxbg8+Ya5FXSVf5g01LV9rW4
	 HWakdOWkC9Sc24/w3DR7YB/UFRR8iLpzPtYUXNkE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Moshe Shemesh <moshe@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0172/1250] net/mlx5: Switch vport HCA cap helpers to kvzalloc
Date: Thu, 17 Sep 2026 15:59:27 +0100
Message-ID: <20260917151556.757374556@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Moshe Shemesh <moshe@nvidia.com>

[ Upstream commit 62af408fd772ba0194c007170f9e930ea71e01ea ]

mlx5_vport_set_other_func_cap() and mlx5_vport_get_vhca_id() allocate
command buffers that embed the HCA capability union, exceeding 4KiB.
Use kvzalloc/kvfree so the allocation can fall back to vmalloc when
contiguous memory is scarce.

Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20260518071356.345723-5-tariqt@nvidia.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/vport.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/vport.c b/drivers/net/ethernet/mellanox/mlx5/core/vport.c
index 6b90f6c4f2eb6..5d895287df54b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/vport.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/vport.c
@@ -1381,7 +1381,7 @@ int mlx5_vport_get_vhca_id(struct mlx5_core_dev *dev, u16 vport, u16 *vhca_id)
 	if (mlx5_esw_vport_vhca_id(dev->priv.eswitch, vport, vhca_id))
 		return 0;
 
-	query_ctx = kzalloc(query_out_sz, GFP_KERNEL);
+	query_ctx = kvzalloc(query_out_sz, GFP_KERNEL);
 	if (!query_ctx)
 		return -ENOMEM;
 
@@ -1393,7 +1393,7 @@ int mlx5_vport_get_vhca_id(struct mlx5_core_dev *dev, u16 vport, u16 *vhca_id)
 	*vhca_id = MLX5_GET(cmd_hca_cap, hca_caps, vhca_id);
 
 out_free:
-	kfree(query_ctx);
+	kvfree(query_ctx);
 	return err;
 }
 EXPORT_SYMBOL_GPL(mlx5_vport_get_vhca_id);
@@ -1408,7 +1408,7 @@ int mlx5_vport_set_other_func_cap(struct mlx5_core_dev *dev, const void *hca_cap
 	void *set_ctx;
 	int ret;
 
-	set_ctx = kzalloc(set_sz, GFP_KERNEL);
+	set_ctx = kvzalloc(set_sz, GFP_KERNEL);
 	if (!set_ctx)
 		return -ENOMEM;
 
@@ -1437,6 +1437,6 @@ int mlx5_vport_set_other_func_cap(struct mlx5_core_dev *dev, const void *hca_cap
 	MLX5_SET(set_hca_cap_in, set_ctx, function_id, function_id);
 	ret = mlx5_cmd_exec_in(dev, set_hca_cap, set_ctx);
 
-	kfree(set_ctx);
+	kvfree(set_ctx);
 	return ret;
 }
-- 
2.53.0



