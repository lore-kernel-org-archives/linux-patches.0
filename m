Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A9D125393E;
	Sat, 12 Sep 2026 07:46:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199190; cv=none; b=SZLcTWMxjFa9B1GdLratc8AncguWYGpJrvj/A21jxtw15aYZlba5+alQsTTZuO2V9qTOLyHkKa+1XN4N8lPG9bhq9pwIVCigazMLSDvIs+TtgT8vB+Lx+blxYTOQI+MsOey4yEpN/OKMUYakr3X6I6FuQ1G5TwPC+HGarTnEjwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199190; c=relaxed/simple;
	bh=Hnzmzd1KsqGLWu5CMhbJJyvwLd99Hisuz78NYrYRJJg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IzpFHs+cOxG+Q96Wb2EeHSQRNgdHAyDUQfPgpd2sVUYdhd+NzWoSvV3BBErX1Ood18vDG17dcdEdPnbHFR/XlibOjUQTc6D7S0lRBlXU6VdssovpUrDcW5OXJb2ZlksG+ko9VXASIklqSGaANc/Nm5kW/V9a4u8XQVYVUOnNCxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bI7M9XKb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bI7M9XKb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDCE71F000FF;
	Sat, 12 Sep 2026 07:46:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199189;
	bh=ZM8u775jbrNbk+KTYIy5KV/F53T8aAHsOCzLNjp/O/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bI7M9XKb5f9lj2LYTJLGd2k5TvHp+1fozlovZ6BGrLI8G6AFwYcxLBpou9qvQU6GE
	 XMG/cHK1Xeg4rBv6E79c/fL2mQPVswVunuS9IAXXniJ0ut7qbNTXLvzm9O7A6ov2aW
	 euH4XuICySADl9iTsPAwAP7fFsmbNcHzFV9EmlGk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Koichiro Den <den@valinux.co.jp>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0533/1815] dmaengine: dw-edma: Clear stale requests on termination
Date: Sat, 12 Sep 2026 08:38:03 +0200
Message-ID: <20260912065701.391067946@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Koichiro Den <den@valinux.co.jp>

[ Upstream commit c0d9c6275adcca7c0ca5f4270bf88026f9864bd1 ]

terminate_all() can finish immediately when the channel is unconfigured,
paused, idle, or already stopped in hardware. A pending PAUSE request can
survive these paths and block issue_pending() even after termination.

Clear the request whenever termination leaves the channel idle. A running
channel keeps its STOP request until the interrupt handler consumes it.

Fixes: e63d79d1ffcd ("dmaengine: Add Synopsys eDMA IP core driver")
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Koichiro Den <den@valinux.co.jp>
Link: https://patch.msgid.link/20260717180639.2643243-7-den@valinux.co.jp
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/dw-edma/dw-edma-core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/dma/dw-edma/dw-edma-core.c b/drivers/dma/dw-edma/dw-edma-core.c
index 7c71e0f99676c..5fc025ab4a04a 100644
--- a/drivers/dma/dw-edma/dw-edma-core.c
+++ b/drivers/dma/dw-edma/dw-edma-core.c
@@ -364,6 +364,8 @@ static int dw_edma_device_terminate_all(struct dma_chan *dchan)
 	} else {
 		chan->request = EDMA_REQ_STOP;
 	}
+	if (chan->status == EDMA_ST_IDLE)
+		chan->request = EDMA_REQ_NONE;
 
 	return err;
 }
-- 
2.53.0



