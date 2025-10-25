Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F84A22A813;
	Sat, 25 Oct 2025 16:26:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409595; cv=none; b=IQlXYzr8vuNoscs9QIUEEhTNf9AOHTE1UfiCY7ms9BwawwXfS5Zoss/r3ZJeLTuXkQjAJHFyAb81BpZCcpyHdYks632QUkfdgPlWUjCqSNbPtDoK+CzHjRmaYU5mgSeHTRmKqDAlt3C/skwQbnAFiJSWc2clsIHoJ/Zw/xm7b4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409595; c=relaxed/simple;
	bh=WMgKJKUFglfTw6umt4dbRhXzGNq4wSkMscRE4m0ySS8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cIpnFAY2zeMidQz+R+BfbUoBu24jsNo/XJI8BaEeRzeXIkCootovlDeQWux9gam9Z++hdPS4iupxVp3tfoIr/jjhkBK4iTnvZRsUp5MhffeDwc36f3NyKxP2ybG/yFcK5f2kXp7o+yvW8hHlSE5HDUtlumwD9R+482oO5wl8QrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qrKCAqke; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qrKCAqke"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 720EBC4CEFB;
	Sat, 25 Oct 2025 16:26:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409595;
	bh=WMgKJKUFglfTw6umt4dbRhXzGNq4wSkMscRE4m0ySS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qrKCAqkeRmGwZtiv9YyTt0ZEQLs9cUuycZyL+sU1q++E1E9+wuSFwNqhcIxof4uk5
	 C9KcW2noKNFmFX0B+B3GD+4zmphpM77NTvPP2Wn0OR653gzFVh8asr8u+ngMz3sObz
	 a7ueaSs3tlt5DmdsPkN0WvAB3x7Lgkf0T3VW+s/HnTRH/BVHbzvyaAIwV+BIykh9Q6
	 92oAqvB/PekqPt4dTCLf7sCq1ZYVpkXy8X7tOw81fkP/XW9bi02CbESqUMcc8SMuDN
	 4K+DaGbtzuOiBdNONtrotR3HBSUbA6FUkauMUv010b/PXx8HqwZyy4ShoSJqRydFDz
	 w/o2IMEr8YzyA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Dragos Tatulea <dtatulea@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	hawk@kernel.org,
	ilias.apalodimas@linaro.org,
	netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.17-5.4] page_pool: Clamp pool size to max 16K pages
Date: Sat, 25 Oct 2025 12:00:13 -0400
Message-ID: <20251025160905.3857885-382-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dragos Tatulea <dtatulea@nvidia.com>

[ Upstream commit a1b501a8c6a87c9265fd03bd004035199e2e8128 ]

page_pool_init() returns E2BIG when the page_pool size goes above 32K
pages. As some drivers are configuring the page_pool size according to
the MTU and ring size, there are cases where this limit is exceeded and
the queue creation fails.

The page_pool size doesn't have to cover a full queue, especially for
larger ring size. So clamp the size instead of returning an error. Do
this in the core to avoid having each driver do the clamping.

The current limit was deemed to high [1] so it was reduced to 16K to avoid
page waste.

[1] https://lore.kernel.org/all/1758532715-820422-3-git-send-email-tariqt@nvidia.com/

Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20250926131605.2276734-2-dtatulea@nvidia.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES
- The change at `net/core/page_pool.c:213` and
  `net/core/page_pool.c:214` stops rejecting large pools and instead
  clamps the ptr_ring allocation to 16k entries, which keeps queue setup
  from failing with `-E2BIG` while still bounding the cached page
  budget. Without this patch, any driver that computes a `pool_size`
  above 32768 immediately aborts queue creation; for example,
  `mlx5e_alloc_rq()` sets `pp_params.pool_size = pool_size` in
  `drivers/net/ethernet/mellanox/mlx5/core/en_main.c:906` and again at
  `drivers/net/ethernet/mellanox/mlx5/core/en_main.c:1011`, and on error
  it propagates the failure (`goto err_free_by_rq_type`) so the RX queue
  never comes up. `stmmac_init_rx_buffers()` follows the same pattern in
  `drivers/net/ethernet/stmicro/stmmac/stmmac_main.c:2051`–`drivers/net/
  ethernet/stmicro/stmmac/stmmac_main.c:2066`, meaning larger rings or
  MTU-derived pools currently make the interface unusable.
- The lower cap is safe: when the ptr_ring fills, the existing slow-path
  already frees excess pages (`page_pool_recycle_in_ring()` at
  `net/core/page_pool.c:746` together with the fallback in
  `page_pool_put_unrefed_netmem()` at `net/core/page_pool.c:873`), so a
  smaller cache only increases occasional allocations but does not
  change correctness. No ABI or driver interfaces are touched, and every
  driver benefits automatically without per-driver clamps.
- This is a minimal, localized fix that prevents hard user-visible
  failures (device queues refusing to start) on systems with large RX
  rings or jumbo MTUs, making it an excellent candidate for stable
  backports.

 net/core/page_pool.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index e224d2145eed9..1a5edec485f14 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -211,11 +211,7 @@ static int page_pool_init(struct page_pool *pool,
 		return -EINVAL;
 
 	if (pool->p.pool_size)
-		ring_qsize = pool->p.pool_size;
-
-	/* Sanity limit mem that can be pinned down */
-	if (ring_qsize > 32768)
-		return -E2BIG;
+		ring_qsize = min(pool->p.pool_size, 16384);
 
 	/* DMA direction is either DMA_FROM_DEVICE or DMA_BIDIRECTIONAL.
 	 * DMA_BIDIRECTIONAL is for allowing page used for DMA sending,
-- 
2.51.0

