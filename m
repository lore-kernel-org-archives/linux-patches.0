Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 151213B994F;
	Tue, 21 Jul 2026 21:36:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669795; cv=none; b=rvG0oUdziMn1HeG75eTd+J1zEtomtVMSllJAkovChjGZLD6xtdUkP+iXp1aP/bSCmoBq9R5E4ex5p3GQL5ULlBzTBRwdXgYG8sw5E7OnTk94Su414M9MWUmb0q3t06w3v/W3ZGolGhl2/zq5kmd2tbWa4RZ4ANn4ZguV/6n/g5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669795; c=relaxed/simple;
	bh=2m2Wu5nr7e40n6tELFBSl4MbMSh/IEjKGC86od6vcQk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uJJpvrqoX+HjMxoNf6hu3hCj9Rj7GHNVCRqD9kWmu0p2vP4XaDLruQOyhIM16Yi08SsVwacLWobZbsrIGDbajK+cZZbSvm7gUA+l1AF5VrayCr6sIqcmciF8ZRcskH21IpYWAqdXCeTOXmfw1W5wJxGY4TdWHEjdPQt9gB3V+Rs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lgsdbxzv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lgsdbxzv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 344CA1F000E9;
	Tue, 21 Jul 2026 21:36:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669793;
	bh=L3cRCWN3TIoSyZ7GFBDl4DBs3OZfl1sagwQUUAEdn/w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lgsdbxzvkpqaIPTwCef+s1U0ElQmwgZiNnl15PBeJvreAiTLPRCDZvJn07WGSr1Eo
	 HjasCrMQ2SJJ6ZC3rlqAGkSpMzQCMDzQTaSeEtlDvw/G8466zxFqbKCSvuLJoeXBaM
	 vcMUqpzQxE6tNhe73ObD/hUqiK9KCN1UPwzHDUcs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Feng Liu <feliu@nvidia.com>,
	Eran Ben Elisha <eranbe@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0688/1067] net/mlx5e: Fix HV VHCA stats agent registration race
Date: Tue, 21 Jul 2026 17:21:29 +0200
Message-ID: <20260721152439.987682654@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Feng Liu <feliu@nvidia.com>

[ Upstream commit 89b25b5f46f488ea3b29b3444864c76944c9075b ]

mlx5e_hv_vhca_stats_create() registers the stats agent through
mlx5_hv_vhca_agent_create(). The helper publishes the agent in
hv_vhca->agents[type] under agents_lock and immediately schedules an
asynchronous control invalidation on the HV VHCA workqueue before
returning to mlx5e.

The asynchronous invalidation invokes the control agent's invalidate
callback, which reads the hypervisor control block and forwards the
command to mlx5e_hv_vhca_stats_control(). That callback may either:

  - call cancel_delayed_work_sync(&priv->stats_agent.work), or
  - call queue_delayed_work(priv->wq, &sagent->work, sagent->delay).

However, the delayed_work and priv->stats_agent.agent are only
initialized after mlx5_hv_vhca_agent_create() returns to mlx5e:

    agent = mlx5_hv_vhca_agent_create(...);   /* publish + invalidate */
    ...
    priv->stats_agent.agent = agent;          /* too late */
    INIT_DELAYED_WORK(&priv->stats_agent.work, ...); /* too late */

If the asynchronous control path runs before the two assignments
above, it can:

  - Operate on an uninitialized delayed_work whose timer.function is
    NULL. queue_delayed_work() calls add_timer() unconditionally, so
    when the timer expires the timer softirq invokes a NULL function
    pointer.
  - Re-initialize the timer later through INIT_DELAYED_WORK() while
    the timer is already enqueued in the timer wheel, corrupting the
    hlist (entry.pprev cleared while the previous bucket node still
    points at this entry).
  - When the worker eventually runs, mlx5e_hv_vhca_stats_work() reads
    sagent->agent (NULL) and dereferences it inside
    mlx5_hv_vhca_agent_write().

Fix this by:

  - Initializing priv->stats_agent.work before invoking
    mlx5_hv_vhca_agent_create(), so the work is always in a valid
    state when the control callback observes it.
  - Adding a struct mlx5_hv_vhca_agent **ctx_update out-parameter
    to mlx5_hv_vhca_agent_create(). The helper writes the agent
    pointer to *ctx_update before publishing into hv_vhca->agents[]
    and triggering the agents_update flow, so any callback
    subsequently invoked from that flow already sees a valid
    priv->stats_agent.agent. This avoids having the control
    callback participate in agent initialization.

While at it, access priv->stats_agent.agent with
READ_ONCE()/WRITE_ONCE() for the cross-CPU access with the worker, and
clear priv->stats_agent.buf on the agent_create() failure path.

Fixes: cef35af34d6d ("net/mlx5e: Add mlx5e HV VHCA stats agent")
Signed-off-by: Feng Liu <feliu@nvidia.com>
Reviewed-by: Eran Ben Elisha <eranbe@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20260630115151.729219-3-tariqt@nvidia.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../mellanox/mlx5/core/en/hv_vhca_stats.c     | 21 +++++++++++--------
 .../ethernet/mellanox/mlx5/core/lib/hv_vhca.c |  8 +++++--
 .../ethernet/mellanox/mlx5/core/lib/hv_vhca.h |  6 ++++--
 3 files changed, 22 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/hv_vhca_stats.c b/drivers/net/ethernet/mellanox/mlx5/core/en/hv_vhca_stats.c
index 41a662d47be6f4..1856d211339f2a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/hv_vhca_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/hv_vhca_stats.c
@@ -73,7 +73,7 @@ static void mlx5e_hv_vhca_stats_work(struct work_struct *work)
 	sagent = container_of(dwork, struct mlx5e_hv_vhca_stats_agent, work);
 	priv = container_of(sagent, struct mlx5e_priv, stats_agent);
 	buf_len = mlx5e_hv_vhca_stats_buf_size(priv);
-	agent = sagent->agent;
+	agent = READ_ONCE(sagent->agent);
 	buf = sagent->buf;
 
 	memset(buf, 0, buf_len);
@@ -135,11 +135,14 @@ void mlx5e_hv_vhca_stats_create(struct mlx5e_priv *priv)
 	if (!priv->stats_agent.buf)
 		return;
 
+	INIT_DELAYED_WORK(&priv->stats_agent.work, mlx5e_hv_vhca_stats_work);
+
 	agent = mlx5_hv_vhca_agent_create(priv->mdev->hv_vhca,
 					  MLX5_HV_VHCA_AGENT_STATS,
 					  mlx5e_hv_vhca_stats_control, NULL,
 					  mlx5e_hv_vhca_stats_cleanup,
-					  priv);
+					  priv,
+					  &priv->stats_agent.agent);
 
 	if (IS_ERR_OR_NULL(agent)) {
 		if (IS_ERR(agent))
@@ -148,20 +151,20 @@ void mlx5e_hv_vhca_stats_create(struct mlx5e_priv *priv)
 				    PTR_ERR(agent));
 
 		kvfree(priv->stats_agent.buf);
-		return;
+		priv->stats_agent.buf = NULL;
 	}
-
-	priv->stats_agent.agent = agent;
-	INIT_DELAYED_WORK(&priv->stats_agent.work, mlx5e_hv_vhca_stats_work);
 }
 
 void mlx5e_hv_vhca_stats_destroy(struct mlx5e_priv *priv)
 {
-	if (IS_ERR_OR_NULL(priv->stats_agent.agent))
+	struct mlx5_hv_vhca_agent *agent;
+
+	agent = READ_ONCE(priv->stats_agent.agent);
+	if (IS_ERR_OR_NULL(agent))
 		return;
 
-	mlx5_hv_vhca_agent_destroy(priv->stats_agent.agent);
-	priv->stats_agent.agent = NULL;
+	mlx5_hv_vhca_agent_destroy(agent);
+	WRITE_ONCE(priv->stats_agent.agent, NULL);
 	kvfree(priv->stats_agent.buf);
 	priv->stats_agent.buf = NULL;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/hv_vhca.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/hv_vhca.c
index 4047629a876b1a..27b43b31db17d0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/hv_vhca.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/hv_vhca.c
@@ -190,7 +190,7 @@ mlx5_hv_vhca_control_agent_create(struct mlx5_hv_vhca *hv_vhca)
 	return mlx5_hv_vhca_agent_create(hv_vhca, MLX5_HV_VHCA_AGENT_CONTROL,
 					 NULL,
 					 mlx5_hv_vhca_control_agent_invalidate,
-					 NULL, NULL);
+					 NULL, NULL, NULL);
 }
 
 static void mlx5_hv_vhca_control_agent_destroy(struct mlx5_hv_vhca_agent *agent)
@@ -256,7 +256,8 @@ mlx5_hv_vhca_agent_create(struct mlx5_hv_vhca *hv_vhca,
 			  void (*invalidate)(struct mlx5_hv_vhca_agent*,
 					     u64 block_mask),
 			  void (*cleaup)(struct mlx5_hv_vhca_agent *agent),
-			  void *priv)
+			  void *priv,
+			  struct mlx5_hv_vhca_agent **ctx_update)
 {
 	struct mlx5_hv_vhca_agent *agent;
 
@@ -284,6 +285,9 @@ mlx5_hv_vhca_agent_create(struct mlx5_hv_vhca *hv_vhca,
 	agent->invalidate = invalidate;
 	agent->cleanup   = cleaup;
 
+	if (ctx_update)
+		WRITE_ONCE(*ctx_update, agent);
+
 	mutex_lock(&hv_vhca->agents_lock);
 	hv_vhca->agents[type] = agent;
 	mutex_unlock(&hv_vhca->agents_lock);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/hv_vhca.h b/drivers/net/ethernet/mellanox/mlx5/core/lib/hv_vhca.h
index f240ffe5116c5b..8b3974cf0ee49a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/hv_vhca.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/hv_vhca.h
@@ -43,7 +43,8 @@ mlx5_hv_vhca_agent_create(struct mlx5_hv_vhca *hv_vhca,
 			  void (*invalidate)(struct mlx5_hv_vhca_agent*,
 					     u64 block_mask),
 			  void (*cleanup)(struct mlx5_hv_vhca_agent *agent),
-			  void *context);
+			  void *context,
+			  struct mlx5_hv_vhca_agent **ctx_update);
 
 void mlx5_hv_vhca_agent_destroy(struct mlx5_hv_vhca_agent *agent);
 int mlx5_hv_vhca_agent_write(struct mlx5_hv_vhca_agent *agent,
@@ -84,7 +85,8 @@ mlx5_hv_vhca_agent_create(struct mlx5_hv_vhca *hv_vhca,
 			  void (*invalidate)(struct mlx5_hv_vhca_agent*,
 					     u64 block_mask),
 			  void (*cleanup)(struct mlx5_hv_vhca_agent *agent),
-			  void *context)
+			  void *context,
+			  struct mlx5_hv_vhca_agent **ctx_update)
 {
 	return NULL;
 }
-- 
2.53.0



