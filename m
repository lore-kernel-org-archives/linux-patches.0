Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6446537647E;
	Wed, 30 Sep 2026 19:26:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796407; cv=none; b=PIncsNL057ARom+eTq81hJ3vOmzKTQldjB+nowQbmMbeOam9/fVHkKNrco4EGOSJplErtiqU43K5KhEWPr/j6CA3q5HtbiBGEZLfBbB+bNx2+Hrs8XI7FQZ21IsNI9NufYEpuMyYaq5yZy4TDnFTzxKdZd9W6/Jmm9p2RT4pIv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796407; c=relaxed/simple;
	bh=86hjL9TxCjtuad+HuWcZ49HMEDRSdB1z8jzR0IVCpF4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VIsMGwqGKPGg8vpkfMsWkt1xXA1qCGWM5gx8zkQ1qop2njvFJdsyZSE1gsl7OCHvsL5ldW+zOJGT9ubqhk8BIhtePAljHvJ8q0cHaEFhQ55Rg2fL8qtrBttu45sdgQ4GLBvHDLmZuZubHE+ELjuMKYpKJF/1/DPkCJIBQR6cFX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wOvqiCzK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wOvqiCzK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6356D1F000FF;
	Wed, 30 Sep 2026 19:26:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796405;
	bh=FUsJhs0po7BuIGHQd1ZWjFPQ6RkWzCa+L6HdBhwK7a0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wOvqiCzKLbowa7+9tQOjJg/giCcHjqoEk7+KNQNGZ9f4uPOsGPrggp1sdweU2qItV
	 Cx6F05Yd9Hk2GCn4ZgLrnBPd4f8Ml79VAMThiFOVgsC2DvuQr7/k8habnOS7Xygmi3
	 mx7Cuj58NXBdp1T3n692jG6V5/spqQa5Xzn7SO2U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Lugnberg <christian.lugnberg@soundtrack.io>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.6 0857/1193] dmaengine: sun6i: fix undefined behaviour in sun6i_dma_tx_status
Date: Wed, 30 Sep 2026 17:25:41 +0200
Message-ID: <20260930152453.274867124@linuxfoundation.org>
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

From: Christian Lugnberg <christian.lugnberg@soundtrack.io>

commit 9096bdc8d930147f7c39a493a859acbd3a8485d8 upstream.

sun6i_dma_tx_status() calls vchan_find_desc() to look up the virtual
descriptor for a given cookie, before checking whether the pointer
vd is NULL:

    vd = vchan_find_desc(&vchan->vc, cookie);
    txd = to_sun6i_desc(&vd->tx);   /* vd may be NULL here */

    if (vd) {
        for (lli = txd->v_lli; ...)

vchan_find_desc() returns NULL when the descriptor has already been
completed or is in-flight on a physical channel and no longer present
in the virtual channel's descriptor list. When vd is NULL,
to_sun6i_desc() is called unconditionally on &vd->tx before the NULL
check, which is undefined behaviour. Move the call inside the if (vd)
guard to ensure it is only reached with a valid pointer.

    vd = vchan_find_desc(&vchan->vc, cookie);
    if (vd) {
        struct sun6i_desc *txd = to_sun6i_desc(&vd->tx);
        for (lli = txd->v_lli; ...)

Fixes: 555859308723 ("dmaengine: sun6i: Add driver for the Allwinner A31 DMA controller")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-sonnet-4-6
Signed-off-by: Christian Lugnberg <christian.lugnberg@soundtrack.io>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260817135723.12807-3-christian.lugnberg@soundtrack.io
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/sun6i-dma.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/dma/sun6i-dma.c
+++ b/drivers/dma/sun6i-dma.c
@@ -970,7 +970,6 @@ static enum dma_status sun6i_dma_tx_stat
 	struct sun6i_pchan *pchan = vchan->phy;
 	struct sun6i_dma_lli *lli;
 	struct virt_dma_desc *vd;
-	struct sun6i_desc *txd;
 	enum dma_status ret;
 	unsigned long flags;
 	size_t bytes = 0;
@@ -982,9 +981,9 @@ static enum dma_status sun6i_dma_tx_stat
 	spin_lock_irqsave(&vchan->vc.lock, flags);
 
 	vd = vchan_find_desc(&vchan->vc, cookie);
-	txd = to_sun6i_desc(&vd->tx);
 
 	if (vd) {
+		struct sun6i_desc *txd = to_sun6i_desc(&vd->tx);
 		for (lli = txd->v_lli; lli != NULL; lli = lli->v_lli_next)
 			bytes += lli->len;
 	} else if (!pchan || !pchan->desc) {


