Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE3B32D9484;
	Wed, 30 Sep 2026 18:13:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792037; cv=none; b=iBmuLDqiNVUNsEevRortmkv7zqXBcqHpLBRZO0iBa1LfHN5Djk29ZESEHR12kifJ9BveFn/WiaxYLB48C8U/BSuxbOS+Czajty35buVs5/oDUrM88rojIGOr4CMSJR8M2IkLxEZcHdoq1FmWgUanoo4Ytpqp6x5py9L9zA5kcEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792037; c=relaxed/simple;
	bh=UKSF6qpvJqpQ8/s39HRtzM6vWF1/QqsGWitP2dXoj+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I9U5J1hSR5un+N4KUnqvn3PDRwJ2ZkkJldC8sfj12u91QsCPngt5Km7zlUkrDZlIOIyMU7UcFOer9f3iO9aHj2L4BUs+jXmzJuJhvIEZj7wAPZPA7CnIotv0y/zrHiUSUoQnqEnk7XbAfByYB2bfD3FS3uhux1e388X0DcfF3cI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mX3doSEZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mX3doSEZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 451061F000FF;
	Wed, 30 Sep 2026 18:13:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792035;
	bh=KsI92E+y402bhcKqF7oDFFffF+rZ5AQvDJktzUEv2XY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mX3doSEZuHrcmL1iq3pDvTw6vHR5axyFFTGvg451h4yJ48unSTi4al2HIpV/QIfhy
	 xqIj/vb/9K70wdjCsIxCz3fUAkAAo4wDbMtcdiUKwBxE7S8YDzH2AiDlmDxtsWC+27
	 uqtTWN8C7QLNkN5HhGYnapATBvqL6sNhxkc0fu/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 468/752] dma-coherent: Warn if OF reserved memory is beyond current coherent DMA mask
Date: Wed, 30 Sep 2026 17:25:38 +0200
Message-ID: <20260930152408.400250383@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 2df824fa40ef2..3144974c3075a 100644
--- a/kernel/dma/coherent.c
+++ b/kernel/dma/coherent.c
@@ -336,16 +336,22 @@ static struct reserved_mem *dma_reserved_default_memory __initdata;
 
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



