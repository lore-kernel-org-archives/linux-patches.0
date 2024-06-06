Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B2DB19753E;
	Thu,  6 Jun 2024 14:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717682978; cv=none; b=PkfWPnEhMGKuOrd240AuA1ufK6DgP3ChD/I/JFnwb/nuIoFjuq1RwYzCOEtXFyA9jHnJilOtAAh1HDls41dvRcYEajOslv0mz/EAZ0UJ5Qr9PUJdLSmmvKBYASKif4DQA0ZUImX90I5dDL7DrTVl3FwtnyHTX6UaLj8TxsiYX/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717682978; c=relaxed/simple;
	bh=f8aPqcGHKzh+zX3CS5lX5SaJPDEzvbsZBdlKe97aRsk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o6w832Ms1Akc6MFBD+LLzC+w6bJkzr2aTDUs2PhvoTmEPkDtIWI7LsicsSPLxudTL/xnm7259LJHvNCtduqrrnBo06UAoLMA1c6BRdjF+PKHG1sqvxWoO63wVIDtYLQ+dYpI+wr7xOjo6/VUjlUdODSdfRLRoEOQUiimb+jBaU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LrfIFgev; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LrfIFgev"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AF97C2BD10;
	Thu,  6 Jun 2024 14:09:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717682978;
	bh=f8aPqcGHKzh+zX3CS5lX5SaJPDEzvbsZBdlKe97aRsk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LrfIFgevwQNIgYEQ16TVUssCBHr+vQYjlzqE76Xft7/P771HzYhliIFCbEntGsaDj
	 IzBYNLG7LBFKZHThS9VjbBwEFOIrjZh5i5lVC5164inhkwS926E1b3AZlqL3iDNLeX
	 J/29I7aNp1I0iu3xt+0xTfRk/GBSuA7tU+Dnfs9Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jai Luthra <j-luthra@ti.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 157/374] media: ti: j721e-csi2rx: Fix races while restarting DMA
Date: Thu,  6 Jun 2024 16:02:16 +0200
Message-ID: <20240606131657.174201785@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jai Luthra <j-luthra@ti.com>

[ Upstream commit ad79c9ecea5baa7b4f19677e4b1c881ed89b0c3b ]

After the frame is submitted to DMA, it may happen that the submitted
list is not updated soon enough, and the DMA callback is triggered
before that.

This can lead to kernel crashes, so move everything in a single
lock/unlock section to prevent such races.

Fixes: b4a3d877dc92 ("media: ti: Add CSI2RX support for J721E")
Signed-off-by: Jai Luthra <j-luthra@ti.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/ti/j721e-csi2rx/j721e-csi2rx.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/ti/j721e-csi2rx/j721e-csi2rx.c b/drivers/media/platform/ti/j721e-csi2rx/j721e-csi2rx.c
index 6da83d0cffaae..22442fce76078 100644
--- a/drivers/media/platform/ti/j721e-csi2rx/j721e-csi2rx.c
+++ b/drivers/media/platform/ti/j721e-csi2rx/j721e-csi2rx.c
@@ -786,15 +786,14 @@ static void ti_csi2rx_buffer_queue(struct vb2_buffer *vb)
 			dev_warn(csi->dev,
 				 "Failed to drain DMA. Next frame might be bogus\n");
 
+		spin_lock_irqsave(&dma->lock, flags);
 		ret = ti_csi2rx_start_dma(csi, buf);
 		if (ret) {
-			dev_err(csi->dev, "Failed to start DMA: %d\n", ret);
-			spin_lock_irqsave(&dma->lock, flags);
 			vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
 			dma->state = TI_CSI2RX_DMA_IDLE;
 			spin_unlock_irqrestore(&dma->lock, flags);
+			dev_err(csi->dev, "Failed to start DMA: %d\n", ret);
 		} else {
-			spin_lock_irqsave(&dma->lock, flags);
 			list_add_tail(&buf->list, &dma->submitted);
 			spin_unlock_irqrestore(&dma->lock, flags);
 		}
-- 
2.43.0



