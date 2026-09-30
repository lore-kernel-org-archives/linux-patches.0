Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CDFF3DB625;
	Wed, 30 Sep 2026 19:19:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795979; cv=none; b=UOKqoryFaq975sZUXO2TYpihN3d0WNe0Dz1hTGWLeBIgty1/x8Mh9+PijcRR2awckzCnHkLlCQyE2S8t8+toxC1ofJVHtqoSo5uat6pDd0rrwwFgCik1DZGBouV+WdaP41S/6R4/GSTklQQKIo08qnYgW8QZ2R5SgLkWjJqyDMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795979; c=relaxed/simple;
	bh=slr6M8DhI2sRiDoLeywReBYQ+OaUUIxM43PwQVPTAZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XQGPc5Wt3AoLxR2Xn7MUA/rLDcVGU6njWIjZ6fbb5mA7uVAhunpVbYMSY8ALwMZwrDzpaLft6ghOUGVt4s6jKo8GTTdTjvyYTbC9qddWTYPoYqABY4APgonYslZn2N9sp2f0ae87iPihswEfH9RpPD0rhcYFbJoHGVlRvbyj0Ys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UwuxO24t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UwuxO24t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04FC91F000FF;
	Wed, 30 Sep 2026 19:19:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795978;
	bh=dDwB5WW/spMK+AhVgWoeLYtDK79b9dJAMooSFHEvmp8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UwuxO24tCh5A3sAHpVOR0R7RnLo+h44UuLSPi2z6TL7ePN5Hw7vb0+UoQxmuQsxNi
	 ysW6wulZYxPzGKG/EGx798RfudYfHE8AxqLjF0YmSSk293h/jUvnrc9zNfLEcG0azl
	 EvZvDlui8hWCBGXRwN0/cloiJqbqO3t49mlBJ8kE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0749/1193] dma-coherent: Warn if OF reserved memory is beyond current coherent DMA mask
Date: Wed, 30 Sep 2026 17:23:53 +0200
Message-ID: <20260930152450.891918792@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index ff5683a57f771..b3a6d904c0b92 100644
--- a/kernel/dma/coherent.c
+++ b/kernel/dma/coherent.c
@@ -335,16 +335,22 @@ static struct reserved_mem *dma_reserved_default_memory __initdata;
 
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



