Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DDB24CCDC0;
	Wed, 23 Sep 2026 14:12:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790172777; cv=none; b=lfDtN9eg2l+n/fOP3qQiWiqSW4dAGJRyOltJROX1XD/e4tVv9UcZEFI1vfSddUei1XY+YPZkG+usEhTKn6d7gfuDai4vRiKkmTj7/iJ0j1roE2cgBhTVTAlzW/NJTOjZSS5NkliBj3W2AMOQMrZb/s5B87W9gozoVewTKxIbXA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790172777; c=relaxed/simple;
	bh=O8rC4sau9ndiK7zQjvfZLzRQubbY1BSX+no8PbGtmY0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hr+X+6v3T04eQayjLecwDwmBaCWikjKjhyC5/fppjOYDfjuq9Mfg2QiHlQN0tdWrNdLW6WoiPv+8pbCXxGmIAiQpus3vW/+rsxEd/rGMrI5T6UcL/d4clGtwDhpTFgK0t2pBHDGQU1LAk8oEOrgsoYQXODKHBfD9BytUaUmBkak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n9p2ScHc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n9p2ScHc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6771E1F000FF;
	Wed, 23 Sep 2026 14:12:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790172775;
	bh=Dq97EH6puMOSzM2kt8t9n8/BVfVJMtGjxdAhbh3hqwU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n9p2ScHcdJ5ft3myfVyFODNvinYvqYzMGSBIVycMvuknfAVE0Ause9Bt3c1fWnqpC
	 rXr+qAYpyAR8gGJLMaREbM94K3HUMy+5upltWy4m23E9x3Y4AWBauIcdefy3jRzWJH
	 AeLGRtl76CoUNniYmlgUzKuQwcNtk+ciQEkejxe8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Donggeun Yoo <donggeunyoo.kernel@gmail.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 059/438] dma-coherent: report a failed reserved memory assignment
Date: Wed, 23 Sep 2026 16:01:20 +0200
Message-ID: <20260923140646.316198998@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Donggeun Yoo <donggeunyoo.kernel@gmail.com>

[ Upstream commit 504981db4f69bdd28054fb98c96a3a67f7248dde ]

rmem_dma_device_init() drops the return value of
dma_assign_coherent_memory() and always reports success. That call fails
with -EBUSY when the device already has a coherent pool, and the file
allows only "*one* such region of memory" per device.

of_reserved_mem_device_init_by_idx() reads the zero as success. It logs
"assigned reserved memory node" for a region that was not assigned and
records the pairing, so of_reserved_mem_device_release() later runs
rmem_dma_device_release() for it. That clears dev->dma_mem without
looking at which region it was called for, dropping the pool the device
did get and leaving it on ordinary memory.

dma_declare_coherent_memory() checks the same call and releases the
memory on failure, and rmem_swiotlb_device_init() propagates its own
errors. Return the error here as well, so a device tree that assigns two
pools to one device fails the probe instead of half working.

Fixes: 7bfa5ab6fa1b ("drivers: dma-coherent: add initialization from device tree")
Signed-off-by: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
Link: https://lore.kernel.org/r/20260905074727.108029-1-donggeunyoo.kernel@gmail.com
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/dma/coherent.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/kernel/dma/coherent.c b/kernel/dma/coherent.c
index bcdc0f76d2e80..b6fe902c6a6db 100644
--- a/kernel/dma/coherent.c
+++ b/kernel/dma/coherent.c
@@ -351,8 +351,7 @@ static int rmem_dma_device_init(struct reserved_mem *rmem, struct device *dev)
 	    min_not_zero(dev->coherent_dma_mask, dev->bus_dma_limit))
 		dev_warn(dev, "reserved memory is beyond device's set DMA address range\n");
 
-	dma_assign_coherent_memory(dev, mem);
-	return 0;
+	return dma_assign_coherent_memory(dev, mem);
 }
 
 static void rmem_dma_device_release(struct reserved_mem *rmem,
-- 
2.53.0



