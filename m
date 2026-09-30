Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA97B4F405E;
	Wed, 30 Sep 2026 18:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792088; cv=none; b=W8W2s5tDYtsEw4rdEAoudVIaZ3kF66+9WdzR4WIWxhEWMF5o8zmcNj/qLQ3Bp98upeQAcNul8fxxPtxxYE1VTVS3j7YtUXZAY2fgvWzlV/1mZ/0kN1q8GUdMDz0wSL4pazImTtn5pp3f42hRmOLHl9Pz1Bsrx6Booo1ZrEiTEs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792088; c=relaxed/simple;
	bh=GwCQn6inStlurXyIEgjhgDmiCcKw7ba8tmtHvHVNtPE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kgz9y4I8QorVgoVyLDoBGS0jw+WbxxmyTuwwHHfTV8KSwQC7cTbaziZF0uRJdmFZsGonbuVoq7D09qEx40l4DsKQ/VYRoVTwGO2vTVEIf/ByDD+GICaRWZlw6incmsvJ81RyFrt+3J5zWKM+bh9ZcbpMwA4YWdriM4hBjExVQcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2P5LIIQJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2P5LIIQJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4922C1F000FF;
	Wed, 30 Sep 2026 18:14:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792086;
	bh=QOOJyPxsc5t3lEwt3n0sz/7NBePio/VjupF1AN/5pOk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2P5LIIQJKRP4yz5Zme+2YGHvhteTC+9lOiEdZjqpN7hnYpkCPyMhfld8rapDWby+J
	 9QAnPGczvHrd3bBzJtULhv62OuaXWfROVhhSrLd2yms7MNwYG5fMW8CFObMXsNnkwg
	 l8rYEOXdPOYsueHCeBfRUndcPVALCtH+6eJxOVvQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Lugnberg <christian.lugnberg@soundtrack.io>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.15 531/752] dmaengine: sun6i: fix undefined behaviour in sun6i_dma_tx_status
Date: Wed, 30 Sep 2026 17:26:41 +0200
Message-ID: <20260930152409.742893229@linuxfoundation.org>
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
@@ -931,7 +931,6 @@ static enum dma_status sun6i_dma_tx_stat
 	struct sun6i_pchan *pchan = vchan->phy;
 	struct sun6i_dma_lli *lli;
 	struct virt_dma_desc *vd;
-	struct sun6i_desc *txd;
 	enum dma_status ret;
 	unsigned long flags;
 	size_t bytes = 0;
@@ -943,9 +942,9 @@ static enum dma_status sun6i_dma_tx_stat
 	spin_lock_irqsave(&vchan->vc.lock, flags);
 
 	vd = vchan_find_desc(&vchan->vc, cookie);
-	txd = to_sun6i_desc(&vd->tx);
 
 	if (vd) {
+		struct sun6i_desc *txd = to_sun6i_desc(&vd->tx);
 		for (lli = txd->v_lli; lli != NULL; lli = lli->v_lli_next)
 			bytes += lli->len;
 	} else if (!pchan || !pchan->desc) {


