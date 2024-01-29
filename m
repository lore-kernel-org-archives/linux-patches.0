Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AC01157054;
	Mon, 29 Jan 2024 17:13:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548416; cv=none; b=aH1UJyEFHFDqGKWJfShKKHDL7SB8cGqwVafvH6h8EoSgdqAGtMD5iVFOAdZd7GU9+MI7eA3K+8BpGPqb3T/8irEn3takNkD+5ClQLHuxEx3/QpHpgtt1pb8D0TTmxASfOhrrR/cij/JTW1gJcHcgPnBtNav+8Lutt/tL1IO2Tlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548416; c=relaxed/simple;
	bh=ZwQ3OwJWBgjaz9uNExxxQOFI7UCzfVtaKntrVmCJxCI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pFvCt8Hl0LpjtjInOljU/R6CEhbBnz+b0wouh7oqmEP7VusyV5gzh267Tuygg/WcuBvpKPh6r/frtHy+byH467Q32DCAAL6ciK3RA3kAJFWw10fYahaMLrfYBwcEPgl4ou6ON6J28bh7LYKXQOpCLp5/8f+KfCOtQaBhd9kcG1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G698iqvD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G698iqvD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEE9FC43399;
	Mon, 29 Jan 2024 17:13:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548415;
	bh=ZwQ3OwJWBgjaz9uNExxxQOFI7UCzfVtaKntrVmCJxCI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G698iqvDyYE8OJ72VjsS9QdLU1Q0bDATpBlRStPZkNm1tu8SwyDlDHYQEk1F9XcNi
	 ZHRtPOYxUbT0D4Exap7U8JHofljceOVA2a8tTwPeRfkDuWeie9nyFvhSBbpUmHWE/+
	 dPYL2Dy2LqDGcmrPYEYwqYLyEui0tuZYwdF6V4bY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 013/331] dmaengine: fsl-edma: fix eDMAv4 channel allocation issue
Date: Mon, 29 Jan 2024 09:01:17 -0800
Message-ID: <20240129170015.350475008@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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

[ Upstream commit dc51b4442dd94ab12c146c1897bbdb40e16d5636 ]

The eDMAv4 channel mux has a limitation where certain requests must use
even channels, while others must use odd numbers.

Add two flags (ARGS_EVEN_CH and ARGS_ODD_CH) to reflect this limitation.
The device tree source (dts) files need to be updated accordingly.

This issue was identified by the following commit:
commit a725990557e7 ("arm64: dts: imx93: Fix the dmas entries order")

Reverting channel orders triggered this problem.

Fixes: 72f5801a4e2b ("dmaengine: fsl-edma: integrate v3 support")
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Link: https://lore.kernel.org/r/20231114154824.3617255-2-Frank.Li@nxp.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/fsl-edma-main.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/dma/fsl-edma-main.c b/drivers/dma/fsl-edma-main.c
index 00cb70aca34a..30df55da4dbb 100644
--- a/drivers/dma/fsl-edma-main.c
+++ b/drivers/dma/fsl-edma-main.c
@@ -26,6 +26,8 @@
 #define ARGS_RX                         BIT(0)
 #define ARGS_REMOTE                     BIT(1)
 #define ARGS_MULTI_FIFO                 BIT(2)
+#define ARGS_EVEN_CH                    BIT(3)
+#define ARGS_ODD_CH                     BIT(4)
 
 static void fsl_edma_synchronize(struct dma_chan *chan)
 {
@@ -159,6 +161,12 @@ static struct dma_chan *fsl_edma3_xlate(struct of_phandle_args *dma_spec,
 		fsl_chan->is_remote = dma_spec->args[2] & ARGS_REMOTE;
 		fsl_chan->is_multi_fifo = dma_spec->args[2] & ARGS_MULTI_FIFO;
 
+		if ((dma_spec->args[2] & ARGS_EVEN_CH) && (i & 0x1))
+			continue;
+
+		if ((dma_spec->args[2] & ARGS_ODD_CH) && !(i & 0x1))
+			continue;
+
 		if (!b_chmux && i == dma_spec->args[0]) {
 			chan = dma_get_slave_channel(chan);
 			chan->device->privatecnt++;
-- 
2.43.0



