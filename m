Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC9281E8320;
	Tue, 16 Jun 2026 15:21:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781623292; cv=none; b=Gn/DUwE2t8DiATIXtpoggLFuVyeVI3bDmVIw9QP+c3XrE4rVJA4ho4fT5HC0NKsMsKJBzlOZIhzD6OuGTjk6WUNQDkiQkddihbxQGa5m6kA8H0v6A2iPHdBMc6fea2v4Sk7bG/A9gnKr40Fnu3HLUZt5ESlwhzX6Lod+yZSZRdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781623292; c=relaxed/simple;
	bh=BWt1arjQME8qintwwtlQA0GA+3iH3i3lD+Z8nJxwkC0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UPsTj1Y2wPEmFHx4KaCZ8olfS4rBdu0SIF+w/hXUsw43qG3VIUbrOt3l45ocCQpRop+Cr93BCXNOTegVpqhAURi1T5AybF7M4Xh2D3na5yxj6vurz4lhtqtrRduzOJPCVHMhrpF0Mbxa822qK3GEsFQs1ULViGsRch7LsSmTJjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tk75WOXK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tk75WOXK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB24D1F000E9;
	Tue, 16 Jun 2026 15:21:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781623290;
	bh=0redTiFnu6SNQBimDc2l9nSrkeZrSye6LAfhE19sP/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Tk75WOXKO02jWEeYClHerqn5Y7CxmJm+pEwjMLDLBPwRHpX0zt14UZAFsHXLyHXKI
	 xS9fd6NSbPfCNagmERwUyK3tfGT3k+pcxJq9XWpP97RPWWRSnCmwvh+Adb4K+r8mtm
	 6MzZSdhWnaNDWDcCUCNG6vfQKHpp0gkilqrX93Xw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shay Drory <shayd@nvidia.com>,
	Fushuai Wang <wangfushuai@baidu.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 121/378] net/mlx5: Use effective affinity mask for IRQ selection
Date: Tue, 16 Jun 2026 20:25:52 +0530
Message-ID: <20260616145116.722840109@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fushuai Wang <wangfushuai@baidu.com>

[ Upstream commit a7767290e77ca2e926b49f8bfa29daa12262c612 ]

When a sf is created after a CPU has been taken offline, the IRQ pool may
contain IRQs with affinity masks that include the offline CPU. Since only
online CPUs should be considered for IRQ placement, cpumask_subset() check
would fail because the iter_mask contains offline CPUs that are not present
in req_mask, causing sf creation to fail.

This is an example:
  1. When mlx5 driver loads, it initializes the IRQ pools.
     For sf_ctrl_pool with ≤64 sf:
     - xa_num_irqs = {N, N} (There is only one slot)
  2. When the first SF is created:
     - The ctrl IRQ is allocated with mask=cpu_online_mask={0-191}
  2. We take CPU 20 offline
  3. Existing ctl irq still have mask={0-191}
  4. Create a new SF:
     - req_mask={0-19,21-191}
     - iter_mask={0-191}
     - {0-191} is NOT a subset of {0-19,21-191}
     - least_loaded_irq=NULL
  5. Try to allocate a new irq via irq_pool_request_irq()
  6. xa_alloc() fails because the pool is full(There is only one slot)
  7. sf creation fails with error

Use irq_get_effective_affinity_mask() instead, which returns the IRQ's
actual effective affinity that already excludes offline CPUs.

Fixes: 061f5b23588a ("net/mlx5: SF, Use all available cpu for setting cpu affinity")
Suggested-by: Shay Drory <shayd@nvidia.com>
Signed-off-by: Fushuai Wang <wangfushuai@baidu.com>
Reviewed-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20260605102112.91772-1-fushuai.wang@linux.dev
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/irq_affinity.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/irq_affinity.c b/drivers/net/ethernet/mellanox/mlx5/core/irq_affinity.c
index 994fe83da4bed8..a0bb8ee44e3550 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/irq_affinity.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/irq_affinity.c
@@ -105,9 +105,12 @@ irq_pool_find_least_loaded(struct mlx5_irq_pool *pool, const struct cpumask *req
 
 	lockdep_assert_held(&pool->lock);
 	xa_for_each_range(&pool->irqs, index, iter, start, end) {
-		struct cpumask *iter_mask = mlx5_irq_get_affinity_mask(iter);
 		int iter_refcount = mlx5_irq_read_locked(iter);
+		const struct cpumask *iter_mask;
 
+		iter_mask = irq_get_effective_affinity_mask(mlx5_irq_get_irq(iter));
+		if (!iter_mask)
+			continue;
 		if (!cpumask_subset(iter_mask, req_mask))
 			/* skip IRQs with a mask which is not subset of req_mask */
 			continue;
-- 
2.53.0



