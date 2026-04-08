Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0EAF3537EF;
	Wed,  8 Apr 2026 18:27:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672824; cv=none; b=NDJG6NdEzFvj+qtyJmDocBbLKDS0lJxs0V56FNdn8Z25ayC8Fqzek1LDGSLXfzP8u782kpbeDTwfBHBnpRnrBMKvu1RxAN+/DfO4ush5sLzCQ2McmkXZG/hLsUbSfM0jfKRJS1bsP0IMuAj+xMathpGODMiIE8LHzxFzuuuVshg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672824; c=relaxed/simple;
	bh=i74bwffvYDm4lfyypdi2kBdj3+cIF4xSElw4K0cqaQE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K2aFffmv0M1QD9t67Rj+nIjkrf85QnjqiS/R+r1Zk+Vf06Jntw17uSXKqe49EGOTW579nqIrYJ0kwI1JhuPgJH8C/8h5I8SdFdagPfm8SA2EbJZ/peRlZ4RL78S2W4pK+RZ6gRIaM/TOWUsTXlbPphLo5WzI/xaSfDFtSh+r6Vo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R9a6sNx5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R9a6sNx5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 472E2C19421;
	Wed,  8 Apr 2026 18:27:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672824;
	bh=i74bwffvYDm4lfyypdi2kBdj3+cIF4xSElw4K0cqaQE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R9a6sNx5BFAhZdpoC7pT3u/Tc2iqdrUpEuh6PL4yl6LnQmI/18p2B3hwdm6VzJ6Zt
	 Bv/oYpHF4zGFcf56OxsQ9I1HhXQj2dYR6eyHNq/xxYhcPdLv1iiPWsGeoZnCnz3j6F
	 BDRy1mvsyLC7VMseycPV2Mtp64TUHz5SDb27Zmwo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joy Zou <joy.zou@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 156/160] dmaengine: fsl-edma: fix channel parameter config for fixed channel requests
Date: Wed,  8 Apr 2026 20:04:03 +0200
Message-ID: <20260408175919.026836901@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175913.177092714@linuxfoundation.org>
References: <20260408175913.177092714@linuxfoundation.org>
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

From: Joy Zou <joy.zou@nxp.com>

[ Upstream commit 2e7b5cf72e51c9cf9c8b75190189c757df31ddd9 ]

Configure only the requested channel when a fixed channel is specified
to avoid modifying other channels unintentionally.

Fix parameter configuration when a fixed DMA channel is requested on
i.MX9 AON domain and i.MX8QM/QXP/DXL platforms. When a client requests
a fixed channel (e.g., channel 6), the driver traverses channels 0-5
and may unintentionally modify their configuration if they are unused.

This leads to issues such as setting the `is_multi_fifo` flag unexpectedly,
causing memcpy tests to fail when using the dmatest tool.

Only affect edma memcpy test when the channel is fixed.

Fixes: 72f5801a4e2b ("dmaengine: fsl-edma: integrate v3 support")
Signed-off-by: Joy Zou <joy.zou@nxp.com>
Cc: stable@vger.kernel.org
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20250917-b4-edma-chanconf-v1-1-886486e02e91@nxp.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/fsl-edma-main.c |   26 +++++++++++---------------
 1 file changed, 11 insertions(+), 15 deletions(-)

--- a/drivers/dma/fsl-edma-main.c
+++ b/drivers/dma/fsl-edma-main.c
@@ -152,10 +152,8 @@ static struct dma_chan *fsl_edma3_xlate(
 		fsl_chan = to_fsl_edma_chan(chan);
 		i = fsl_chan - fsl_edma->chans;
 
-		fsl_chan->priority = dma_spec->args[1];
-		fsl_chan->is_rxchan = dma_spec->args[2] & FSL_EDMA_RX;
-		fsl_chan->is_remote = dma_spec->args[2] & FSL_EDMA_REMOTE;
-		fsl_chan->is_multi_fifo = dma_spec->args[2] & FSL_EDMA_MULTI_FIFO;
+		if (!b_chmux && i != dma_spec->args[0])
+			continue;
 
 		if ((dma_spec->args[2] & FSL_EDMA_EVEN_CH) && (i & 0x1))
 			continue;
@@ -163,17 +161,15 @@ static struct dma_chan *fsl_edma3_xlate(
 		if ((dma_spec->args[2] & FSL_EDMA_ODD_CH) && !(i & 0x1))
 			continue;
 
-		if (!b_chmux && i == dma_spec->args[0]) {
-			chan = dma_get_slave_channel(chan);
-			chan->device->privatecnt++;
-			return chan;
-		} else if (b_chmux && !fsl_chan->srcid) {
-			/* if controller support channel mux, choose a free channel */
-			chan = dma_get_slave_channel(chan);
-			chan->device->privatecnt++;
-			fsl_chan->srcid = dma_spec->args[0];
-			return chan;
-		}
+		fsl_chan->srcid = dma_spec->args[0];
+		fsl_chan->priority = dma_spec->args[1];
+		fsl_chan->is_rxchan = dma_spec->args[2] & FSL_EDMA_RX;
+		fsl_chan->is_remote = dma_spec->args[2] & FSL_EDMA_REMOTE;
+		fsl_chan->is_multi_fifo = dma_spec->args[2] & FSL_EDMA_MULTI_FIFO;
+
+		chan = dma_get_slave_channel(chan);
+		chan->device->privatecnt++;
+		return chan;
 	}
 	return NULL;
 }


