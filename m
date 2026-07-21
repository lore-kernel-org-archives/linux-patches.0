Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBFDC46E005;
	Tue, 21 Jul 2026 19:48:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663295; cv=none; b=MJaqa9+hsrAIsRRAQhVP+mtd6iou+PhlLyjRWd9yo7zN1EA06ZO8PbMMl+6jZdoOaiPSF9NTYnq2H8ky2NwR5wCQx8ZdqcZnRWDjYfN5mvO+ooahZvPVngegl8n+KOFHpNKLo4N12UL7XRwNZ2JGbSdZSTNc+O/rtZFkDfs9eYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663295; c=relaxed/simple;
	bh=TconcYdGEkRLrYQl0cE/qz0lt9CqnZbHe5fNzbzi7po=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t88NuOSGF2wHMgIdHR4Jo+KkQSqI92aXnvcm4VoUJlI8vl08qfRV+BGRCS0osAnyo5al3OIMEuED3Ti977sU1C+KOF07YLTAJOqLfNtQauvbvDluXgLQ51TtSlqhn2o40+qjeoZAXxTsyT8dcCXGW3bY8JUgCG+pAioGot+hzuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gmpNUhS4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gmpNUhS4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B8CE1F00A3A;
	Tue, 21 Jul 2026 19:48:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663289;
	bh=4nNefw1vWQO9qmYGvcOTp3gcpLMcnhCpzMrITJSJOu0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gmpNUhS4Q2gwNzKA8SZ3AEsFRF9m5e4pXBxDpn1yz5JhIySksql6ZYTFXWYB3BEcq
	 a0Djr6Cjg5dJPZeeX8FY3E/tf9d1amCmJYCuyWQ9oYywMLNSQ3QOjiiq5uzQGuuxP0
	 9RmRxUZVZSg8AP5gj0tV+1DDkBFvTtGCm/Xfd+u0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Feng Liu <feliu@nvidia.com>,
	Eran Ben Elisha <eranbe@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0766/1276] net/mlx5e: Fix HV VHCA stats zero-sized buffer allocation
Date: Tue, 21 Jul 2026 17:20:09 +0200
Message-ID: <20260721152503.216490333@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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
index b4f3bd7d346e43..41a662d47be6f4 100644
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



