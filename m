Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E13B8F58;
	Mon,  4 Mar 2024 21:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588387; cv=none; b=NoffVzLvIVxeHpOjSs3fhPXAsgG8VCR3Ado/t+I6eVX8gGbubRjcnhp4yf5yYnf2qWtGwXVZPkPt9TFhKM0/sTugPy3/uVzx2BeuavOEXLnVLaNHyEVgWrDF9013g/htPoXhgxf9ih2LhITrs5yT0VY1S3s+X5+CoQcRPszcoqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588387; c=relaxed/simple;
	bh=LZ28yaGOKKtWlJW9A5iccrYbaAhIThqUHrZEyMrOaPY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f+fv3Nin1VTwOvsN5cfApKtWsjPRjqKuSLDM8pSi4vZTIr/CaOPqPkfDSdDHiZ7YDPshF7eMmUCevDPKQhgLqVarxyzkZ4Kxv1VjGO/lXwohv4U6YV/E0lDCfjw0opKmHOhFQY0quEcTjWvWsSDdUm7vGDqFCsK1+GyofKI/c2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R/EmFu8A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R/EmFu8A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A59B3C433F1;
	Mon,  4 Mar 2024 21:39:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588387;
	bh=LZ28yaGOKKtWlJW9A5iccrYbaAhIThqUHrZEyMrOaPY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R/EmFu8ABNYLIdwrF7ZbgbQ6ra20lO40qTmk2I9mxKCMZ1mnNnFrCR+kwfhztYoQt
	 llHVVIvAE/tAr9ms0SlcDVUJ1ILBMtiCtxOg5cMw/vDOrpTMxbGK/FDt5IN7MnPVHz
	 j1gunDFNO7gSPmhrWHGxC2l0/Trg34NKnh2oVzU0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Ma <peng.ma@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.6 088/143] dmaengine: fsl-qdma: fix SoC may hang on 16 byte unaligned read
Date: Mon,  4 Mar 2024 21:23:28 +0000
Message-ID: <20240304211552.737894287@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211549.876981797@linuxfoundation.org>
References: <20240304211549.876981797@linuxfoundation.org>
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

From: Peng Ma <peng.ma@nxp.com>

commit 9d739bccf261dd93ec1babf82f5c5d71dd4caa3e upstream.

There is chip (ls1028a) errata:

The SoC may hang on 16 byte unaligned read transactions by QDMA.

Unaligned read transactions initiated by QDMA may stall in the NOC
(Network On-Chip), causing a deadlock condition. Stalled transactions will
trigger completion timeouts in PCIe controller.

Workaround:
Enable prefetch by setting the source descriptor prefetchable bit
( SD[PF] = 1 ).

Implement this workaround.

Cc: stable@vger.kernel.org
Fixes: b092529e0aa0 ("dmaengine: fsl-qdma: Add qDMA controller driver for Layerscape SoCs")
Signed-off-by: Peng Ma <peng.ma@nxp.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Link: https://lore.kernel.org/r/20240201215007.439503-1-Frank.Li@nxp.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/fsl-qdma.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/dma/fsl-qdma.c
+++ b/drivers/dma/fsl-qdma.c
@@ -109,6 +109,7 @@
 #define FSL_QDMA_CMD_WTHROTL_OFFSET	20
 #define FSL_QDMA_CMD_DSEN_OFFSET	19
 #define FSL_QDMA_CMD_LWC_OFFSET		16
+#define FSL_QDMA_CMD_PF			BIT(17)
 
 /* Field definition for Descriptor status */
 #define QDMA_CCDF_STATUS_RTE		BIT(5)
@@ -384,7 +385,8 @@ static void fsl_qdma_comp_fill_memcpy(st
 	qdma_csgf_set_f(csgf_dest, len);
 	/* Descriptor Buffer */
 	cmd = cpu_to_le32(FSL_QDMA_CMD_RWTTYPE <<
-			  FSL_QDMA_CMD_RWTTYPE_OFFSET);
+			  FSL_QDMA_CMD_RWTTYPE_OFFSET) |
+			  FSL_QDMA_CMD_PF;
 	sdf->data = QDMA_SDDF_CMD(cmd);
 
 	cmd = cpu_to_le32(FSL_QDMA_CMD_RWTTYPE <<


