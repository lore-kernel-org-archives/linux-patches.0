Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA471400E17;
	Tue, 21 Jul 2026 18:22:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658175; cv=none; b=hlQc71a+8RVQ102y0VETQv8Tu7IcEIrO3c7GSzC3GJ0mPuibpOEmhNBM9GgjICxk6K32Bc0My7gIyrCsMCDDtHSAZkszZ3H1MA1B2f+HFecZqPY+fAtfX7V+9GQdrZfL3PVsQCfch0CAttWYpoDp/qrbg/MXzezyYgH3MHN+LvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658175; c=relaxed/simple;
	bh=DhIoVUfnZpC5c56MkHsmEbctaj/0nOrS+LQSrSyp1G8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dzNffbaXoyaAUjsTw+l/8H7djltNsbCVAaxKXXuSbIgAC8lfCJgcPX2NHxRFQ17KEo9xRm+eE6n0MqfqNZnhTd+fpBPtXhY58CCdSTbBf29ZCLRGq0lWTc4gzvcCOH8Oi8CBRHuRZ3G+liPppJas9YWQFX1ir+uYkPXUeqcNSoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UvCewpmR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UvCewpmR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 164761F000E9;
	Tue, 21 Jul 2026 18:22:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658174;
	bh=fa1ijduKapHkbrpvz15HNxu2Q3AtDUjEP+LkWc6cpbg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UvCewpmRHPyUaPSf/wMrhx2MUy7vd2+KsTBFk/jQ/0r94F8yHYnCz9cNvlpspp/BH
	 UiKN9f9bQSOI4zMOG0iyxHZB43bNfhFye94ig3StOS7aZf4nQkjaqR/PWsDZRg47po
	 emOeI2MIEMT+3OLHqF8P0T/RS7OuCZsX/Gzbz98k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Feng Liu <feliu@nvidia.com>,
	Eran Ben Elisha <eranbe@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1044/1611] net/mlx5e: Fix HV VHCA stats zero-sized buffer allocation
Date: Tue, 21 Jul 2026 17:19:20 +0200
Message-ID: <20260721152538.884461900@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Feng Liu <feliu@nvidia.com>

[ Upstream commit 25f6b929c7e379cbea7cb8caa67b49b2d1efae17 ]

mlx5e_hv_vhca_stats_create() is called from mlx5e_nic_enable(),
before mlx5e_open(). At that point priv->stats_nch is still zero,
because it is only ever incremented in mlx5e_channel_stats_alloc(),
which is reached only from mlx5e_open_channel().

mlx5e_hv_vhca_stats_buf_size() therefore returns 0, and
kvzalloc(0, GFP_KERNEL) returns ZERO_SIZE_PTR ((void *)16) rather
than NULL. The "if (!buf)" guard does not catch this, and
mlx5e_hv_vhca_stats_create() completes "successfully" with
priv->stats_agent.buf set to ZERO_SIZE_PTR.

Once channels are opened (priv->stats_nch > 0) and the hypervisor
enables stats reporting, mlx5e_hv_vhca_stats_work() recomputes
buf_len using the new non-zero stats_nch and calls
memset(buf, 0, buf_len) on ZERO_SIZE_PTR, faulting at address 0x10.

Allocate the buffer based on priv->max_nch, which is set in
mlx5e_priv_init() and is the upper bound on stats_nch:

  - Add a separate helper mlx5e_hv_vhca_stats_buf_max_size() that
    returns sizeof(per_ring_stats) * max(max_nch, stats_nch), and
    use it for the kvzalloc() in mlx5e_hv_vhca_stats_create().
  - Keep mlx5e_hv_vhca_stats_buf_size() (which returns based on
    stats_nch) for the worker's active payload size, so the wire
    format (block->rings = stats_nch) and the amount of data filled
    by mlx5e_hv_vhca_fill_stats() are unchanged.

The max(max_nch, stats_nch) guard handles the rare case where
mlx5e_attach_netdev() recomputes max_nch downward across a
detach/resume cycle while priv->stats_nch persists (mlx5e_detach_netdev
does not call mlx5e_priv_cleanup, so stats_nch is only reset when
the netdev is destroyed). Without the guard, the worker could compute
buf_len from stats_nch and overrun the smaller buffer allocated based
on the reduced max_nch.

Allocating a non-zero buffer also makes the kvzalloc() failure path in
mlx5e_hv_vhca_stats_create() reachable for the first time: it returns
early without (re)creating the agent. Clear
priv->stats_agent.{agent,buf} in mlx5e_hv_vhca_stats_destroy() after
freeing them, so that if a later create() bails out on this path, a
subsequent teardown does not double-free the stale agent/buffer left
from a previous enable/disable cycle.

This mirrors the existing mlx5e pattern of preallocating arrays of
size max_nch (e.g. priv->channel_stats) and lazily populating
entries up to stats_nch on demand.

Fixes: fa691d0c9c08 ("net/mlx5e: Allocate per-channel stats dynamically at first usage")
Signed-off-by: Feng Liu <feliu@nvidia.com>
Reviewed-by: Eran Ben Elisha <eranbe@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20260630115151.729219-2-tariqt@nvidia.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/en/hv_vhca_stats.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/hv_vhca_stats.c b/drivers/net/ethernet/mellanox/mlx5/core/en/hv_vhca_stats.c
index 195863b2c013e2..72f3ca4dd076bb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/hv_vhca_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/hv_vhca_stats.c
@@ -54,6 +54,12 @@ static int mlx5e_hv_vhca_stats_buf_size(struct mlx5e_priv *priv)
 		priv->stats_nch);
 }
 
+static int mlx5e_hv_vhca_stats_buf_max_size(struct mlx5e_priv *priv)
+{
+	return (sizeof(struct mlx5e_hv_vhca_per_ring_stats) *
+		max(priv->max_nch, priv->stats_nch));
+}
+
 static void mlx5e_hv_vhca_stats_work(struct work_struct *work)
 {
 	struct mlx5e_hv_vhca_stats_agent *sagent;
@@ -122,7 +128,7 @@ static void mlx5e_hv_vhca_stats_cleanup(struct mlx5_hv_vhca_agent *agent)
 
 void mlx5e_hv_vhca_stats_create(struct mlx5e_priv *priv)
 {
-	int buf_len = mlx5e_hv_vhca_stats_buf_size(priv);
+	int buf_len = mlx5e_hv_vhca_stats_buf_max_size(priv);
 	struct mlx5_hv_vhca_agent *agent;
 
 	priv->stats_agent.buf = kvzalloc(buf_len, GFP_KERNEL);
@@ -155,5 +161,7 @@ void mlx5e_hv_vhca_stats_destroy(struct mlx5e_priv *priv)
 		return;
 
 	mlx5_hv_vhca_agent_destroy(priv->stats_agent.agent);
+	priv->stats_agent.agent = NULL;
 	kvfree(priv->stats_agent.buf);
+	priv->stats_agent.buf = NULL;
 }
-- 
2.53.0



