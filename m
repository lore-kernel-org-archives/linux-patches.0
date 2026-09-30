Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7EFC37BE7A;
	Wed, 30 Sep 2026 15:49:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783381; cv=none; b=CAstLmPsW+FDz4z8vxPXj/BUXfJVubE95yZesGmp8+whKpUlQJbrDFYAIP/pLBZiq6Aw1W5BS0CQNSnigMcboh3WDCVS2YnaW0X9Swh9SwvXTvV/X/euyPdx6NOHx4Fdk+olnRLcC1b7G2W4Q2/9T/uOclS8agB63tfAhblAOj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783381; c=relaxed/simple;
	bh=ts2yYZlCQSJtMDHneU4/XiYQo8qmT1mY9CVMdjNP55E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IuiNRgUcFKYBccm7hvZ6qlGnFjUdUPAUreb6mXoGikcZc2PGJ/lAMSzyjFEo9Gf2rehOaUogCjfgPkDijQNePmirdVqhP6YvrryFSgIULyPvfV9vI7gYGb6StrE9sUCNevIFhNqHO6gqIkRLhvitzdcM8TJDBDaPJm7RDv+q2h8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=enJTELZN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="enJTELZN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACAB51F000FF;
	Wed, 30 Sep 2026 15:49:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783376;
	bh=Uhjm9NCgYZWlso2b1V81XqRhofa40r9BL3DTFc1qv+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=enJTELZNO7i/pP1mWwC3g0UTkTY2GNUJrpr7pUIFCXW/qOiordwqyEbcHf4rXQ1sL
	 GZuhCLlLhTGVeZM/Mlo3M7IF8EOl+IvAsZtbEiX1zb96Hc3knHanpAIOhEWtRu3SbP
	 NIem3ock5U/KTwc/0XOzvcxu+qmz1IRbqAcfyHro=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 377/595] dma-coherent: Warn if OF reserved memory is beyond current coherent DMA mask
Date: Wed, 30 Sep 2026 17:24:30 +0200
Message-ID: <20260930152355.785843889@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen-Yu Tsai <wenst@chromium.org>

[ Upstream commit 89461db349cc00816c01d55507d511466b3b7151 ]

When a reserved memory region described in the device tree is attached
to a device, it is expected that the device's limitations are correctly
included in that description.

However, if the device driver failed to implement DMA address masking
or addressing beyond the default 32 bits (on arm64), then bad things
could happen because the DMA address was truncated, such as playing
back audio with no actual audio coming out, or DMA overwriting random
blocks of kernel memory.

Check against the coherent DMA mask when the memory regions are attached
to the device. Give a warning when the memory region can not be covered
by the mask.

A warning instead of a hard error was chosen, because it is possible
that existing drivers could be working fine even if they forgot to
extend the coherent DMA mask.

Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Link: https://lore.kernel.org/r/20250421083930.374173-1-wenst@chromium.org
Stable-dep-of: 504981db4f69 ("dma-coherent: report a failed reserved memory assignment")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/dma/coherent.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/kernel/dma/coherent.c b/kernel/dma/coherent.c
index 4de9898e98dab..4f4d4e3ff3965 100644
--- a/kernel/dma/coherent.c
+++ b/kernel/dma/coherent.c
@@ -320,16 +320,22 @@ static struct reserved_mem *dma_reserved_default_memory __initdata;
 
 static int rmem_dma_device_init(struct reserved_mem *rmem, struct device *dev)
 {
-	if (!rmem->priv) {
-		struct dma_coherent_mem *mem;
+	struct dma_coherent_mem *mem = rmem->priv;
 
+	if (!mem) {
 		mem = dma_init_coherent_memory(rmem->base, rmem->base,
 					       rmem->size, true);
 		if (IS_ERR(mem))
 			return PTR_ERR(mem);
 		rmem->priv = mem;
 	}
-	dma_assign_coherent_memory(dev, rmem->priv);
+
+	/* Warn if the device potentially can't use the reserved memory */
+	if (mem->device_base + rmem->size - 1 >
+	    min_not_zero(dev->coherent_dma_mask, dev->bus_dma_limit))
+		dev_warn(dev, "reserved memory is beyond device's set DMA address range\n");
+
+	dma_assign_coherent_memory(dev, mem);
 	return 0;
 }
 
-- 
2.53.0



