Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78C5A1F582A;
	Mon, 23 Jun 2025 21:08:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750712886; cv=none; b=CanB7WCEwapuCPd2URCOONcvyBblKzEEDul2Vvpy/VH/MXWN+Vlg8A3YfuBQn7WEfG+hikjh/g+WwLYeGooXHpV7xlKB/mJmOe76ZKhSwSV/D02HdaVIGKY0rNfELozNnIvmXuETaUlU+oXVHBkHK90uZb+qXpoZmLM/SFMcbIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750712886; c=relaxed/simple;
	bh=tobbKLm9EnzWHTg1cK4xnW3rWXlS6qOwzGsP/PxK5ao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FDYwE9sS+YrZZmJEXndHAbIlhYpZZ899bfzBZPKwaZ4GhoTiJflkMcXfzudcHZDLQsITXxTpFVnyOdJjESsVjf7fvLuMaNtGboGzK8nmasjb1ezPViqC+QJ8Pp8yg/ZbpcOekz8E6GuPVlaXu0DNaeeptt5Q1t7xt2wOSQclhqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mL/H10+M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mL/H10+M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB19FC4CEED;
	Mon, 23 Jun 2025 21:08:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750712886;
	bh=tobbKLm9EnzWHTg1cK4xnW3rWXlS6qOwzGsP/PxK5ao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mL/H10+M2Wu8LP6rERyONiuZ8yclo+sOBSeROi7ilxKkQbiE07p/PyMKJDRvb48/F
	 oC8W6aMiYZSrKEZ9/ze9ou/X8JTv0tP9GbmSvybGBqf9TmRy786prXg/h3ohG3m6Xt
	 egS1PQNHcmjJGE3vFuncHdGrtv9LDuDpvj5cnmwE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.6 036/290] media: omap3isp: use sgtable-based scatterlist wrappers
Date: Mon, 23 Jun 2025 15:04:57 +0200
Message-ID: <20250623130628.081340098@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.910356556@linuxfoundation.org>
References: <20250623130626.910356556@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Marek Szyprowski <m.szyprowski@samsung.com>

commit 3de572fe2189a4a0bd80295e1f478401e739498e upstream.

Use common wrappers operating directly on the struct sg_table objects to
fix incorrect use of scatterlists sync calls. dma_sync_sg_for_*()
functions have to be called with the number of elements originally passed
to dma_map_sg_*() function, not the one returned in sgtable's nents.

Fixes: d33186d0be18 ("[media] omap3isp: ccdc: Use the DMA API for LSC")
Fixes: 0e24e90f2ca7 ("[media] omap3isp: stat: Use the DMA API")
CC: stable@vger.kernel.org
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/ti/omap3isp/ispccdc.c |    8 ++++----
 drivers/media/platform/ti/omap3isp/ispstat.c |    6 ++----
 2 files changed, 6 insertions(+), 8 deletions(-)

--- a/drivers/media/platform/ti/omap3isp/ispccdc.c
+++ b/drivers/media/platform/ti/omap3isp/ispccdc.c
@@ -446,8 +446,8 @@ static int ccdc_lsc_config(struct isp_cc
 		if (ret < 0)
 			goto done;
 
-		dma_sync_sg_for_cpu(isp->dev, req->table.sgt.sgl,
-				    req->table.sgt.nents, DMA_TO_DEVICE);
+		dma_sync_sgtable_for_cpu(isp->dev, &req->table.sgt,
+					 DMA_TO_DEVICE);
 
 		if (copy_from_user(req->table.addr, config->lsc,
 				   req->config.size)) {
@@ -455,8 +455,8 @@ static int ccdc_lsc_config(struct isp_cc
 			goto done;
 		}
 
-		dma_sync_sg_for_device(isp->dev, req->table.sgt.sgl,
-				       req->table.sgt.nents, DMA_TO_DEVICE);
+		dma_sync_sgtable_for_device(isp->dev, &req->table.sgt,
+					    DMA_TO_DEVICE);
 	}
 
 	spin_lock_irqsave(&ccdc->lsc.req_lock, flags);
--- a/drivers/media/platform/ti/omap3isp/ispstat.c
+++ b/drivers/media/platform/ti/omap3isp/ispstat.c
@@ -161,8 +161,7 @@ static void isp_stat_buf_sync_for_device
 	if (ISP_STAT_USES_DMAENGINE(stat))
 		return;
 
-	dma_sync_sg_for_device(stat->isp->dev, buf->sgt.sgl,
-			       buf->sgt.nents, DMA_FROM_DEVICE);
+	dma_sync_sgtable_for_device(stat->isp->dev, &buf->sgt, DMA_FROM_DEVICE);
 }
 
 static void isp_stat_buf_sync_for_cpu(struct ispstat *stat,
@@ -171,8 +170,7 @@ static void isp_stat_buf_sync_for_cpu(st
 	if (ISP_STAT_USES_DMAENGINE(stat))
 		return;
 
-	dma_sync_sg_for_cpu(stat->isp->dev, buf->sgt.sgl,
-			    buf->sgt.nents, DMA_FROM_DEVICE);
+	dma_sync_sgtable_for_cpu(stat->isp->dev, &buf->sgt, DMA_FROM_DEVICE);
 }
 
 static void isp_stat_buf_clear(struct ispstat *stat)


