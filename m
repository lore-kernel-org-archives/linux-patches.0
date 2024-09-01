Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 093A71C68C;
	Sun,  1 Sep 2024 16:34:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208459; cv=none; b=GFLBQsQXWnaQ4bGzHIcwhHB4akMAm09uEwkBRlv0S+3/LrSBFZNXk1CiGb0gZKZPQBHmU69z3JdVQJR9QDzep27Gc0FsUw4QC7I+xyNRZ+piMfsW+qOiqqhDVaXKFLhnlaEUcfjQVt27LEFd2iELVJhAKjuFYK6jTCPHbUcDcko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208459; c=relaxed/simple;
	bh=c6GDlp8iwfzbWlpfA+AN0c2ojYQThv1klTpwrqB2inw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MhSBYkRIgO628LD3R2R/E0NsVMvRiQ1R4OmrtSN8ll11rX+ME/xOYYO/lO+pwzBV12JBh+IUZbLTCAJFXTCzUMa7tplAmjF6c8tG8fj2kbpYGEowyPdOe8i7Y9FYK4JlQTplkelFUP9fA0yGsHbpsbYRPenJIplOzYlahlb99Qo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h+oLdYBw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h+oLdYBw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32EF8C4CEC3;
	Sun,  1 Sep 2024 16:34:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208458;
	bh=c6GDlp8iwfzbWlpfA+AN0c2ojYQThv1klTpwrqB2inw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h+oLdYBwoRWbek2+Vxw8/1ozMUmwIiiaKjwYTuJ00uFPy5RuwTIHzdMYCI3r6wsQ1
	 61zi3ZkD4lb2LyPkOjsB0Inc7kx4FgTMaYvq0yOBi1dxdwBx8l8b/LgV+ec2SQWTA7
	 0EyTWk9PVzDY9Vziaaoc3aE9A2P9al0NCR2nazBs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 087/149] dmaengine: ti: omap-dma: Initialize sglen after allocation
Date: Sun,  1 Sep 2024 18:16:38 +0200
Message-ID: <20240901160820.738915246@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160817.461957599@linuxfoundation.org>
References: <20240901160817.461957599@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <kees@kernel.org>

[ Upstream commit 5e5c793c7fc47219998465361d94510fdf55d83f ]

With the new __counted_by annocation, the "sglen" struct member must
be set before accessing the "sg" array. This initialization was done in
other places where a new struct omap_desc is allocated, but these cases
were missed. Set "sglen" after allocation.

Fixes: b85178611c11 ("dmaengine: ti: omap-dma: Annotate struct omap_desc with __counted_by")
Signed-off-by: Kees Cook <kees@kernel.org>
Reviewed-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Link: https://lore.kernel.org/r/20240716215702.work.802-kees@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/ti/omap-dma.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/ti/omap-dma.c b/drivers/dma/ti/omap-dma.c
index b9e0e22383b72..984fbec2c4bae 100644
--- a/drivers/dma/ti/omap-dma.c
+++ b/drivers/dma/ti/omap-dma.c
@@ -1186,10 +1186,10 @@ static struct dma_async_tx_descriptor *omap_dma_prep_dma_cyclic(
 	d->dev_addr = dev_addr;
 	d->fi = burst;
 	d->es = es;
+	d->sglen = 1;
 	d->sg[0].addr = buf_addr;
 	d->sg[0].en = period_len / es_bytes[es];
 	d->sg[0].fn = buf_len / period_len;
-	d->sglen = 1;
 
 	d->ccr = c->ccr;
 	if (dir == DMA_DEV_TO_MEM)
@@ -1258,10 +1258,10 @@ static struct dma_async_tx_descriptor *omap_dma_prep_dma_memcpy(
 	d->dev_addr = src;
 	d->fi = 0;
 	d->es = data_type;
+	d->sglen = 1;
 	d->sg[0].en = len / BIT(data_type);
 	d->sg[0].fn = 1;
 	d->sg[0].addr = dest;
-	d->sglen = 1;
 	d->ccr = c->ccr;
 	d->ccr |= CCR_DST_AMODE_POSTINC | CCR_SRC_AMODE_POSTINC;
 
@@ -1309,6 +1309,7 @@ static struct dma_async_tx_descriptor *omap_dma_prep_dma_interleaved(
 	if (data_type > CSDP_DATA_TYPE_32)
 		data_type = CSDP_DATA_TYPE_32;
 
+	d->sglen = 1;
 	sg = &d->sg[0];
 	d->dir = DMA_MEM_TO_MEM;
 	d->dev_addr = xt->src_start;
@@ -1316,7 +1317,6 @@ static struct dma_async_tx_descriptor *omap_dma_prep_dma_interleaved(
 	sg->en = xt->sgl[0].size / BIT(data_type);
 	sg->fn = xt->numf;
 	sg->addr = xt->dst_start;
-	d->sglen = 1;
 	d->ccr = c->ccr;
 
 	src_icg = dmaengine_get_src_icg(xt, &xt->sgl[0]);
-- 
2.43.0



