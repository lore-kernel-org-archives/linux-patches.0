Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88D324FD293;
	Wed, 30 Sep 2026 15:52:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783533; cv=none; b=twRAlv425OR8So/voVe/yBIa2QuakUk9QEaSz3ax1vjF/pAv6QtHVFkzkuu5+5/gVv4JgMwb6sYBHvFgjkkLYvRjKVgPIiQmVzwJylE1xoUnvz+ST12W4F4WsCHUm9GJdx4sEp/NwEFPiHWhKCMFt6to4KXXkDccvDZIfuT4gKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783533; c=relaxed/simple;
	bh=A4/8ZQGPmoJIn6kw+8dkvWeACM0D2KJXNZwx5fLo/yY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fHiVu1vDU7ljYPyTYCW1xhLLeuN1DTbn8OY9g6srsYrmsbSTSQlrmCltq94rGgDCQNHxhcY78X7rKZfQSVKCv+ikZx9hZaqssQdvNOJdQGyzsl7iTI9gNYxnASZHwQ+HH9NIwEkzYDzUPLf2++eVnxnMD77e2WffomG5Pc15N7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EEOU4gns; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EEOU4gns"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ED151F000FF;
	Wed, 30 Sep 2026 15:52:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783529;
	bh=OyGUC2bcTQiUtqNvd1U4HAUODAcGzS8Qh/hgNL4hFhs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EEOU4gnsrndlIjw8yRQXIQoiwjftWAPIb0yiNEwt/wtypLhVMRnmAJFSuyoegANzu
	 d6gx4uz46LENmvgzn3Wcr/jcypefu/x7KAorLN5tJa2KVu6hikHpKrDOj2HLqJFeK6
	 21M5PbmWu0rcto7+49jNGrlfLxONNL0268xWrYww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Lugnberg <christian.lugnberg@soundtrack.io>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.10 430/595] dmaengine: sun6i: fix undefined behaviour in sun6i_dma_tx_status
Date: Wed, 30 Sep 2026 17:25:23 +0200
Message-ID: <20260930152356.929766817@linuxfoundation.org>
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


