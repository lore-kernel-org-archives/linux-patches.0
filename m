Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A030C2DCF4C;
	Thu, 19 Feb 2026 02:04:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771466681; cv=none; b=AM4N0/DNyBPR5lVFRQfKp/dlbM+RK1o9NCoxQ3i48RzB15/W0AHQpGFRk38+vfAHlsFQ68ME+5Vk8zwOWbcj+hCtEsfUp364lQHgw3wa9wOC0eb9gnFxvye9MF0LjzGpiG3tOoSsuISQ7QuUW53hsIMf2FeUK/fXCVxMtt3JnXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771466681; c=relaxed/simple;
	bh=bPo6irn4L27PBL7wCzQUZj+yQ5CRpD1GRlWw8+EcY34=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Vy6IOhoqCh1IIjScs9ZYfj8dNe/6PPOS+8qiScvqpIJqOBC6o+g7MnPaJxtb+PvGW+6b3D9ZDqBelodMOvYPs3POSBgaC2X3QjT7Q9bAjDKwtHvWRyev3XWAiw/msg9aNcFPudaP9kEMvq7HuoR7C/JL1H10MhCInTP66hariqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Bf++E7Cc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Bf++E7Cc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2062C19424;
	Thu, 19 Feb 2026 02:04:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771466681;
	bh=bPo6irn4L27PBL7wCzQUZj+yQ5CRpD1GRlWw8+EcY34=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bf++E7Cc+YLFg1mvAdbaucQknsX+PrmwB6HQBQxcHU17GE2TbrDNPul7Se/ynFCUI
	 5+enGAptO48jYxNBi+C1KdXocByoo0OxYE61B1/ndcldR3kqNdkpancRvyQBW0uBQC
	 EHEJZIgEtZ+tGfrq8jn6t0hXlh+jfhk/xpvKwiRPCNJfUFG48z0u4qSU1tQATtlhhG
	 4vNvTxzRMmGYQ5Tv6vNrLbiCSCPLcoj2HtnH8ead7ZQiYW6ci+/BMhhfCIaNv7M22o
	 7kGM5sK9w4z5dzJTXI/nkSiZRuZk28ihvcNYGP3nvdq7kz0nAv9L+b4eEciWO2QFcf
	 ZdiDACQyxG+Qw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Chaitanya Kulkarni <kch@nvidia.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19] block: fix partial IOVA mapping cleanup in blk_rq_dma_map_iova
Date: Wed, 18 Feb 2026 21:03:50 -0500
Message-ID: <20260219020422.1539798-14-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260219020422.1539798-1-sashal@kernel.org>
References: <20260219020422.1539798-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chaitanya Kulkarni <kch@nvidia.com>

[ Upstream commit 81e7223b1a2d63b655ee72577c8579f968d037e3 ]

When dma_iova_link() fails partway through mapping a request's bvec
list, the function breaks out of the loop without cleaning up
already mapped segments. Similarly, if dma_iova_sync() fails after
linking all segments, no cleanup is performed.

This leaves partial IOVA mappings in place. The completion path
attempts to unmap the full expected size via dma_iova_destroy() or
nvme_unmap_data(), but only a partial size was actually mapped,
leading to incorrect unmap operations.

Add an out_unlink error path that calls dma_iova_destroy() to clean
up partial mappings before returning failure. The dma_iova_destroy()
function handles both partial unlink and IOVA space freeing. It
correctly handles the mapped_len == 0 case (first dma_iova_link()
failure) by only freeing the IOVA allocation without attempting to
unmap.

Signed-off-by: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The function is called from `blk_dma_map_iter_start()` which is the main
DMA mapping entry point for block requests using IOMMU-based (IOVA)
mapping. This is used by NVMe drivers and potentially other high-
performance storage drivers.

## 3. Summary of Analysis

### What the bug is:
In `blk_rq_dma_map_iova()`, when `dma_iova_link()` fails partway through
mapping multiple segments, or when `dma_iova_sync()` fails after all
segments are linked:

1. **dma_iova_link() failure**: The code breaks out of the loop but
   doesn't clean up already-linked segments. The IOVA allocation and
   partial mappings are leaked. Additionally, when the `dma_iova_link()`
   fails, the code falls through to `dma_iova_sync()` which then
   operates on partially mapped data — this is also incorrect behavior.

2. **dma_iova_sync() failure**: The code returns `false` with
   `iter->status` set, but doesn't call `dma_iova_destroy()` to clean up
   the linked IOVA mappings.

In both cases, the completion path will attempt to unmap using the full
expected size via `dma_iova_destroy()` or `nvme_unmap_data()`, but only
a partial size was actually mapped, leading to **incorrect unmap
operations** — which could corrupt IOMMU mappings, cause IOMMU faults,
or lead to data corruption.

### Why it matters:
- This is a bug in the **block I/O DMA path** — the very core of how
  storage I/O works with IOMMU
- It can trigger on any system using IOMMU with NVMe storage when memory
  pressure or IOMMU resource exhaustion causes `dma_iova_link()` to fail
- Consequences of incorrect IOMMU unmap: potential data corruption,
  IOMMU page faults, kernel crashes
- NVMe is extremely widely deployed; any system with IOMMU enabled could
  be affected

### Stable criteria assessment:
- **Obviously correct**: Yes — adds proper error cleanup with
  `dma_iova_destroy()` which is designed for exactly this purpose
- **Fixes a real bug**: Yes — partial IOVA mapping cleanup is missing,
  leading to incorrect unmap operations
- **Small and contained**: Yes — the diff is minimal (~15 lines changed
  in a single function in a single file)
- **No new features**: Correct — purely error path fix
- **Reviewed**: Yes — reviewed by Christoph Hellwig (original author of
  the code), committed by Jens Axboe (block layer maintainer)
- **Tested in mainline**: Yes — it's in mainline already

### Risk assessment:
- **Very low risk**: The change only affects error paths, adding proper
  cleanup where none existed
- **Well-understood cleanup function**: `dma_iova_destroy()` is
  specifically designed for this cleanup and handles both partial and
  zero-length cases
- **Backport note**: The patch won't apply cleanly to 6.17.y and 6.18.y
  because the `attrs` variable was added in v6.19. A minor adaptation
  would be needed (remove `attrs` and pass `0` to `dma_iova_destroy()`).
  For 6.19.y, it should apply cleanly.

## Verification

- **git log** showed `blk-mq-dma.c` was created by commit
  `b0a4158554b90` and the buggy function `blk_rq_dma_map_iova` was
  introduced by `858299dc61603` ("block: add scatterlist-less DMA
  mapping helpers"), first in v6.17
- **git tag --contains** confirmed the buggy code entered mainline in
  v6.17
- **git show stable/linux-6.18.y:block/blk-mq-dma.c** and **git show
  stable/linux-6.17.y:block/blk-mq-dma.c** both confirmed the buggy code
  is present in stable trees (with `break` instead of `goto out_unlink`,
  and no cleanup on `dma_iova_sync` failure)
- **git show stable/linux-6.12.y:block/blk-mq-dma.c** confirmed the file
  does NOT exist in 6.12.y (only affects 6.17+)
- **Read of drivers/iommu/dma-iommu.c** confirmed `dma_iova_destroy()`
  properly handles mapped_len == 0 by calling `dma_iova_free()` only,
  and mapped_len > 0 by unlinking and freeing
- **git log stable/linux-6.18.y** and **stable/linux-6.19.y** confirmed
  the fix has not yet been applied to stable trees
- **git log 37f0c7a8df7ad** confirmed the `attrs` variable was
  introduced in v6.19, meaning 6.17.y and 6.18.y will need a trivial
  adaptation for clean backport
- The reviewer (Christoph Hellwig) is verified as the original author of
  the buggy code via the Signed-off-by on `858299dc61603`

**YES**

 block/blk-mq-dma.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/block/blk-mq-dma.c b/block/blk-mq-dma.c
index fb018fffffdcc..feead1934301a 100644
--- a/block/blk-mq-dma.c
+++ b/block/blk-mq-dma.c
@@ -126,17 +126,20 @@ static bool blk_rq_dma_map_iova(struct request *req, struct device *dma_dev,
 		error = dma_iova_link(dma_dev, state, vec->paddr, mapped,
 				vec->len, dir, attrs);
 		if (error)
-			break;
+			goto out_unlink;
 		mapped += vec->len;
 	} while (blk_map_iter_next(req, &iter->iter, vec));
 
 	error = dma_iova_sync(dma_dev, state, 0, mapped);
-	if (error) {
-		iter->status = errno_to_blk_status(error);
-		return false;
-	}
+	if (error)
+		goto out_unlink;
 
 	return true;
+
+out_unlink:
+	dma_iova_destroy(dma_dev, state, mapped, dir, attrs);
+	iter->status = errno_to_blk_status(error);
+	return false;
 }
 
 static inline void blk_rq_map_iter_init(struct request *rq,
-- 
2.51.0

