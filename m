Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 056E11D122;
	Mon, 18 Dec 2023 14:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eoXSw0oN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46E41C433C7;
	Mon, 18 Dec 2023 14:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702908327;
	bh=wkI7GIKwEXVQZODc9BEV4iW6LLuMj1JggMZL/zGAdVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eoXSw0oNx9vFc9ybyyJjnKWjjRTIuwG7Hj2187B9DMtRKTIvRK15Vl2v8QTFqKxGj
	 ZxdsrFfELhcOptEjI68dj5KIU0QDlA291o+eG4uvzAMbu71csryxpILdMkkwv0LKce
	 4+2wQIPJ1HyXdLkssnsGORk23nw/d8p/PIDxctJE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.6 136/166] dmaengine: fsl-edma: fix DMA channel leak in eDMAv4
Date: Mon, 18 Dec 2023 14:51:42 +0100
Message-ID: <20231218135111.182417112@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231218135104.927894164@linuxfoundation.org>
References: <20231218135104.927894164@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frank Li <Frank.Li@nxp.com>

commit 4ee632c82d2dbb9e2dcc816890ef182a151cbd99 upstream.

Allocate channel count consistently increases due to a missing source ID
(srcid) cleanup in the fsl_edma_free_chan_resources() function at imx93
eDMAv4.

Reset 'srcid' at fsl_edma_free_chan_resources().

Cc: stable@vger.kernel.org
Fixes: 72f5801a4e2b ("dmaengine: fsl-edma: integrate v3 support")
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Link: https://lore.kernel.org/r/20231127214325.2477247-1-Frank.Li@nxp.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/fsl-edma-common.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/dma/fsl-edma-common.c b/drivers/dma/fsl-edma-common.c
index 6a3abe5b1790..b53f46245c37 100644
--- a/drivers/dma/fsl-edma-common.c
+++ b/drivers/dma/fsl-edma-common.c
@@ -828,6 +828,7 @@ void fsl_edma_free_chan_resources(struct dma_chan *chan)
 	dma_pool_destroy(fsl_chan->tcd_pool);
 	fsl_chan->tcd_pool = NULL;
 	fsl_chan->is_sw = false;
+	fsl_chan->srcid = 0;
 }
 
 void fsl_edma_cleanup_vchan(struct dma_device *dmadev)
-- 
2.43.0



