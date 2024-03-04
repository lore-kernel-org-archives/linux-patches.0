Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1D9E1C687;
	Mon,  4 Mar 2024 21:33:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588026; cv=none; b=Z93QGMugJFLXdJEcvWmBUA5R5fvm6hYAWQ0N1vnpS3ojBLKS4FOVo/mlLO0GwDHH3c+AA4zAGwrB8uI9MWGyiWmdjHYQz90kYwk+kMm08qtpVssvAHa6YzUE7Z7IXTKN1+G17TSVexY8zDMtIqlExyl/mkaMKRIDpTe/hdFs4ew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588026; c=relaxed/simple;
	bh=zmALsA4tu+o0c5PzW4m7y/tYKeXrsskL1UueQhzbv2A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IiLxWcCX4n6fqJ3Mq4mcPJ7BVwVoWlEc4PqPFroGfchBuFPG6duxO338slWL25NH9IOfi4nu4DS2GX7nyEsvOh8WH4OK/NksOLku/7Lqk5lrthQKRoh/RB04jngg1djS1F/4K6cjnGRt2oyL3adGiy5hYbxRDH5Z8eHide9y/IU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QsU16gsz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QsU16gsz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34CB9C433C7;
	Mon,  4 Mar 2024 21:33:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588026;
	bh=zmALsA4tu+o0c5PzW4m7y/tYKeXrsskL1UueQhzbv2A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QsU16gszDRddS8XGRKk47RXthHFM1O+WMwNVuCmPIo2mdeG5+4TV2zGXfPiN/fOvX
	 0/BEC7SVqgWvXOm/jN6T7ZJTrQC3Z+SESGVfzocNZZ9vGJB7fRWcLPRRmUpkq1bwz5
	 vPczO0ojYpG4rYVTymXsqqt7D2Pf3gpq2pUyTkGQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Ma <peng.ma@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.4 19/25] dmaengine: fsl-qdma: fix SoC may hang on 16 byte unaligned read
Date: Mon,  4 Mar 2024 21:23:55 +0000
Message-ID: <20240304211536.391500622@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211535.741936181@linuxfoundation.org>
References: <20240304211535.741936181@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
 
 /* Field definition for Descriptor offset */
 #define QDMA_CCDF_STATUS		20
@@ -372,7 +373,8 @@ static void fsl_qdma_comp_fill_memcpy(st
 	qdma_csgf_set_f(csgf_dest, len);
 	/* Descriptor Buffer */
 	cmd = cpu_to_le32(FSL_QDMA_CMD_RWTTYPE <<
-			  FSL_QDMA_CMD_RWTTYPE_OFFSET);
+			  FSL_QDMA_CMD_RWTTYPE_OFFSET) |
+			  FSL_QDMA_CMD_PF;
 	sdf->data = QDMA_SDDF_CMD(cmd);
 
 	cmd = cpu_to_le32(FSL_QDMA_CMD_RWTTYPE <<


