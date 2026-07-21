Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3291846EF8D;
	Tue, 21 Jul 2026 18:49:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659795; cv=none; b=mrGesBmn5ec4DaEfFHpuyIlnDYnDh6POctY/sQy++j7gYkgYQwr2jCCn19u+oGBiWFvfngYF8vpd+KgijUMsLBh54vep2Nsr7Bmi/atuHj/QbNlxsDPQQdGKwTPicl9LicalLOODF3rf1K1V5pI5CUYe3Bq6wQRuexvU0ED+H0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659795; c=relaxed/simple;
	bh=rzgqpOsVEadwvsGNSm5cv6KBqxv4oTOQs8NJQkr/+J0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UkxpAFXG88XxB6k711NoZeJPCE40IgzOoCVZ/b73XWsk4mLlTcUnEkt6RHNLFEyDrRrV8ksnFttkS2gU4tbyjH5JTlVsY4GUScgHVYYRewXzg1e2EQLYYuelqUW/LbOYou6AmhC7DB0O8ro2Nc4gsLd9ZSN8B9t6iikvI097jdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yflgr0zF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yflgr0zF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 976EC1F000E9;
	Tue, 21 Jul 2026 18:49:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659794;
	bh=JrVnK7mo586CGSKvi/hUL0aN4uqmQ6gbe/akUS85vvs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yflgr0zFkQxZnAhg0AHhARpWfEyhn9ZtqmL63HSOsdNWoVjvaJxhy6NZlP4kzbRy1
	 45Bv6+KwTkwCI1qcovgHVS2erX2HTgfbOdzGOzG22wczabII7YecacYgu6VeAAkpND
	 7lf2B0+5gkKvWA569nHr7DwGIn0oquvzvhuVHabU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Guralnik <michaelgur@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0693/2077] RDMA/core: Add ib_frmr_pool_drop for unrecoverable handles
Date: Tue, 21 Jul 2026 17:06:06 +0200
Message-ID: <20260721152609.140387096@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Guralnik <michaelgur@nvidia.com>

[ Upstream commit ddbc251be18fb82884ee6e9af634cc9f1171a4d6 ]

A driver that has popped a handle from an FRMR pool can hit failures
that leave the handle in a state where it can't safely be returned
for reuse. The driver destroys the handle itself, but the pool has
no way to learn about it, so the in_use counter drifts upward.

Add ib_frmr_pool_drop to balance the pool's accounting in this case.
Every pop is now balanced by exactly one push or drop.

Fixes: 36680ef7bceb ("RDMA/mlx5: Switch from MR cache to FRMR pools")
Link: https://patch.msgid.link/r/20260610000145.820592-9-michaelgur@nvidia.com
Signed-off-by: Michael Guralnik <michaelgur@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/frmr_pools.c | 15 +++++++++++++++
 include/rdma/frmr_pools.h            |  1 +
 2 files changed, 16 insertions(+)

diff --git a/drivers/infiniband/core/frmr_pools.c b/drivers/infiniband/core/frmr_pools.c
index e214a8273df844..ce8ae4305b9c8f 100644
--- a/drivers/infiniband/core/frmr_pools.c
+++ b/drivers/infiniband/core/frmr_pools.c
@@ -578,3 +578,18 @@ void ib_frmr_pool_push(struct ib_device *device, struct ib_mr *mr)
 
 }
 EXPORT_SYMBOL(ib_frmr_pool_push);
+
+/*
+ * Drop a handle previously popped from the pool without returning it for
+ * reuse. The caller is responsible for destroying the underlying hardware
+ * resource.
+ */
+void ib_frmr_pool_drop(struct ib_mr *mr)
+{
+	struct ib_frmr_pool *pool = mr->frmr.pool;
+
+	spin_lock(&pool->lock);
+	pool->in_use--;
+	spin_unlock(&pool->lock);
+}
+EXPORT_SYMBOL(ib_frmr_pool_drop);
diff --git a/include/rdma/frmr_pools.h b/include/rdma/frmr_pools.h
index 5b57bafa363669..aed4d69d3841c4 100644
--- a/include/rdma/frmr_pools.h
+++ b/include/rdma/frmr_pools.h
@@ -35,5 +35,6 @@ int ib_frmr_pools_init(struct ib_device *device,
 void ib_frmr_pools_cleanup(struct ib_device *device);
 int ib_frmr_pool_pop(struct ib_device *device, struct ib_mr *mr);
 void ib_frmr_pool_push(struct ib_device *device, struct ib_mr *mr);
+void ib_frmr_pool_drop(struct ib_mr *mr);
 
 #endif /* FRMR_POOLS_H */
-- 
2.53.0



