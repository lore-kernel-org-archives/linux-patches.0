Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3E97442FD6;
	Mon, 17 Aug 2026 14:33:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977198; cv=none; b=K02Ue5ooqVB8zSf1AYRJNrkjtAOla2sE4Cv0laTf86ZCryS6TdaEO2xetaTV/UO2Q7SfmuIYykSEvkAQxlwtEt+a/RAZClozt0WzYiGnsAMOXsDXsUtNKIbcXHWgCFgV7qL1yi2IFFYyOARSXfZ0KiPQ9PNmVFiUACJnXdmsVcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977198; c=relaxed/simple;
	bh=IqyMkFHI454QUgyVVnWjCBs10SDA4v20AN6Jv+4Hnlk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QgSx6178cTmyu5ypRb3arZSEdyeKF/YvuPaHwsxAiAo1EM/f9mYEI1tvZZ/aSlmFPhtiDQ4RLuqc60j5MUlcvO/ULaiU5jBnEmK4w0zfGya9W5BnfMKPvR/XkzLqBLP4Mi0bmAeH4zZsJzeWLquFE//38DYA8RqWgaWQ8sk7gZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FXAozKl7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FXAozKl7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC0FD1F000E9;
	Mon, 17 Aug 2026 14:33:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977197;
	bh=/zGTym4Y74aRfn96VL7hVsNdIm2MZfaLYSwUtoVr71U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FXAozKl7IJQ1q/LGZfnTJl5gl3R3C8YdaoqLeEHUEKQKT5Y4Q/WmNrgFZH76XPvvn
	 kaNl/BQtgLubZB6bBAuRcCpXjsljo+lSEwKWIzwGFoVk7ZPUHCXt+lP9ONGEuZZoVS
	 l3ZQm/NmRoT0giPdDqYPVzgOORzdzMrY9CdXN4hM=
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
Subject: [PATCH 5.15 246/456] dmaengine: sun6i-dma: Fix reclaim descriptors while terminating DMA
Date: Mon, 17 Aug 2026 15:30:36 +0200
Message-ID: <20260817132549.705662294@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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
index 5cadd4d2b8246..fa216ef645d58 100644
--- a/drivers/dma/sun6i-dma.c
+++ b/drivers/dma/sun6i-dma.c
@@ -895,16 +895,13 @@ static int sun6i_dma_terminate_all(struct dma_chan *chan)
 
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



