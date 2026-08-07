Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E42EB1A681E;
	Fri,  7 Aug 2026 15:16:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115811; cv=none; b=i++X+B/yV27lz59Nv0dAfpm/GVY6A6zH8FIGt7BUT9JPf3x4BZsySsgm0FGCAMFqxlk2sBBPwPp85U8VAdMQ1FUtmy3TiWGjhwPizFVewIOW6yhdJ1YPb+xm7V4VH8SWvnMEy6WP3z8IHTUZkmRJ5L1e3E9GWWxv1M/QCG/TsWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115811; c=relaxed/simple;
	bh=GHvzZ1OtQjFVhmAAxk9b/TTPepcp7xQ1eHtng0om/8I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WRI0uOR6sG2UyE05cEcGZhfurGRJP7xEYtI4CXzUW/GlSjhERODkrb0hb4v4of2xYrYQHq3fjmdlf9x+afyRu+hJUQsmbuaeAYQ3wFf2fdmuoSeXLHNXLdO4KtWQ1AuQM7LWGYHUQY3tVEfrQazjnZUY3M51g0y1ZCarvAb2RhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D5CIb8hu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D5CIb8hu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51FBC1F000E9;
	Fri,  7 Aug 2026 15:16:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115809;
	bh=ok9i4RGiy5w0xWE38kasi6A8pJLH/EZsEboh4V0PE4A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D5CIb8hujyqz52/r5jvKW5cgG88HF3aYNg7c5Mm2mknCU+MuJaWBkEhs98js5h0Iw
	 jTAHGqkb7trRgnZlXMVYhmiHlm+M39QA4sRmF8P/xjjfL85afqjBdc1dWPeKoLCwN8
	 JvBLiL7EHab9cakfGp8ZVpSCZ6EpEtPIcRh0xXzI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongling Zeng <zenghongling@kylinos.cn>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Frank Li <Frank.li@oss.nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 011/261] dmaengine: sun6i-dma: Fix reclaim descriptors while terminating DMA
Date: Fri,  7 Aug 2026 16:36:08 +0200
Message-ID: <20260807143415.608907641@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143415.358597922@linuxfoundation.org>
References: <20260807143415.358597922@linuxfoundation.org>
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

From: Hongling Zeng <zenghongling@kylinos.cn>

[ Upstream commit ab1150115e68a46b687eb38c1ab92782018c9f2c ]

When terminating DMA transfers, active descriptors are not properly
reclaimed. Only cyclic descriptors were handled, leaving non-cyclic
descriptors and their LLI chains to be permanently leaked.

Fix by using vchan_terminate_vdesc() which handles both cyclic and
non-cyclic descriptors by adding them to desc_terminated queue for
proper cleanup.

Add pchan->desc != pchan->done check to prevent double-adding completed
descriptors, which would corrupt the list.

Fixes: 555859308723 ("dmaengine: sun6i: Add driver for the Allwinner A31 DMA controller")
Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>
Acked-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Suggested-by: Frank Li <Frank.li@oss.nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260701045733.33654-1-zenghongling@kylinos.cn
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/sun6i-dma.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/dma/sun6i-dma.c b/drivers/dma/sun6i-dma.c
index 6a384bd469528..f1d5af20363e9 100644
--- a/drivers/dma/sun6i-dma.c
+++ b/drivers/dma/sun6i-dma.c
@@ -934,16 +934,13 @@ static int sun6i_dma_terminate_all(struct dma_chan *chan)
 
 	spin_lock_irqsave(&vchan->vc.lock, flags);
 
-	if (vchan->cyclic) {
-		vchan->cyclic = false;
-		if (pchan && pchan->desc) {
-			struct virt_dma_desc *vd = &pchan->desc->vd;
-			struct virt_dma_chan *vc = &vchan->vc;
+	if (pchan && pchan->desc && pchan->desc != pchan->done) {
+		struct virt_dma_desc *vd = &pchan->desc->vd;
 
-			list_add_tail(&vd->node, &vc->desc_completed);
-		}
+		vchan_terminate_vdesc(vd);
 	}
 
+	vchan->cyclic = false;
 	vchan_get_all_descriptors(&vchan->vc, &head);
 
 	if (pchan) {
-- 
2.53.0



