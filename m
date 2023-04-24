Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7064E2108
	for <patches@lists.linux.dev>; Mon, 24 Apr 2023 13:33:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0D90C433EF;
	Mon, 24 Apr 2023 13:32:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1682343180;
	bh=MyUoH/X7oQvxECshEf1qBDO57rFW1uTCmTA5sPUwDDo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X2FDmPHkSkP1K31GIivWxwHhJ5EjtUyIsgHA2zxadZkH6l0rVwHJzbNio6wW5vVZW
	 dHW58wDrz7s1P6GwsBaulLLFWcFNyvrFV/cWY6Ek7pZcpuAhrlBgrh7Jp9OKh9PWC6
	 Y6oWUjIjqEmPWBaoedgDLYKPMRtPU5sNu98kTOrc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Zhandarovich <n.zhandarovich@fintech.ru>,
	Shengjiu Wang <shengjiu.wang@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Natalia Petrova <n.petrova@fintech.ru>
Subject: [PATCH 6.2 108/110] ASoC: fsl_asrc_dma: fix potential null-ptr-deref
Date: Mon, 24 Apr 2023 15:18:10 +0200
Message-Id: <20230424131140.667975037@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131136.142490414@linuxfoundation.org>
References: <20230424131136.142490414@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Nikita Zhandarovich <n.zhandarovich@fintech.ru>

commit 86a24e99c97234f87d9f70b528a691150e145197 upstream.

dma_request_slave_channel() may return NULL which will lead to
NULL pointer dereference error in 'tmp_chan->private'.

Correct this behaviour by, first, switching from deprecated function
dma_request_slave_channel() to dma_request_chan(). Secondly, enable
sanity check for the resuling value of dma_request_chan().
Also, fix description that follows the enacted changes and that
concerns the use of dma_request_slave_channel().

Fixes: 706e2c881158 ("ASoC: fsl_asrc_dma: Reuse the dma channel if available in Back-End")
Co-developed-by: Natalia Petrova <n.petrova@fintech.ru>
Signed-off-by: Nikita Zhandarovich <n.zhandarovich@fintech.ru>
Acked-by: Shengjiu Wang <shengjiu.wang@gmail.com>
Link: https://lore.kernel.org/r/20230417133242.53339-1-n.zhandarovich@fintech.ru
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/fsl/fsl_asrc_dma.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/sound/soc/fsl/fsl_asrc_dma.c
+++ b/sound/soc/fsl/fsl_asrc_dma.c
@@ -209,14 +209,19 @@ static int fsl_asrc_dma_hw_params(struct
 		be_chan = soc_component_to_pcm(component_be)->chan[substream->stream];
 		tmp_chan = be_chan;
 	}
-	if (!tmp_chan)
-		tmp_chan = dma_request_slave_channel(dev_be, tx ? "tx" : "rx");
+	if (!tmp_chan) {
+		tmp_chan = dma_request_chan(dev_be, tx ? "tx" : "rx");
+		if (IS_ERR(tmp_chan)) {
+			dev_err(dev, "failed to request DMA channel for Back-End\n");
+			return -EINVAL;
+		}
+	}
 
 	/*
 	 * An EDMA DEV_TO_DEV channel is fixed and bound with DMA event of each
 	 * peripheral, unlike SDMA channel that is allocated dynamically. So no
 	 * need to configure dma_request and dma_request2, but get dma_chan of
-	 * Back-End device directly via dma_request_slave_channel.
+	 * Back-End device directly via dma_request_chan.
 	 */
 	if (!asrc->use_edma) {
 		/* Get DMA request of Back-End */


