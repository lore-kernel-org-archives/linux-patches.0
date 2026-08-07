Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C30B46D0B0;
	Fri,  7 Aug 2026 15:29:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116558; cv=none; b=qEN6bcCeEhyD6daVkuRocknnm/W39/TxHWVKIOQ4ZObnwVhacvTwLOghasNnrsBtpOc6spZnEhLr0Ue9T5KUvEt1rZn7uV+J2bdHsyEvYs0rDmHas3OcfA06FHcpsEv4bzgLFUK4GBZBaNFiyHK0uRTmL0L9HCmXYVPtlkgn494=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116558; c=relaxed/simple;
	bh=tUsRACS1HenctMUUk8i2iUOztfTpcSvjXAeqR5ronq4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XWpg9Ws2KGDwp9iuc+BvmEJEJF6BYWqM0vKori2/VVNM3Xin96YmeQHrL12mvjm6NExs72PIHps/vgTlz+2om9cLURp+gv75xY0lbMhnxCUsGHq/VjkKg36i78OCngZl6Fq5AbXBsr/euQMga5B//PCuxZ2bNEhdAXoLDqmHn4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WJGccugD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WJGccugD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8579F1F000E9;
	Fri,  7 Aug 2026 15:29:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116557;
	bh=KK+jHpq45lvRjT45yb3tuF7fj6p0SP0EGZ5U4a9jXQc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WJGccugD/EHdBS0tx9EBONjL9nZCyX0cd14avb5QPsgFNqLSMV1TzQ9g52wimqJB1
	 vJ7edr3fs7skXuOB0+rv1cnu9IJ1IcJdzxbyQU6nLVehXn++x88AoWKhOOLWbXJk6K
	 LMMdvVA0taSjLb1FfmwD1me02sDjaVWKxR9gW8c0=
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
Subject: [PATCH 7.1 011/438] dmaengine: sun6i-dma: Fix reclaim descriptors while terminating DMA
Date: Fri,  7 Aug 2026 16:33:27 +0200
Message-ID: <20260807143428.252316311@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index a9a254dbf8cb9..f47a326dd7ffa 100644
--- a/drivers/dma/sun6i-dma.c
+++ b/drivers/dma/sun6i-dma.c
@@ -945,16 +945,13 @@ static int sun6i_dma_terminate_all(struct dma_chan *chan)
 
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



