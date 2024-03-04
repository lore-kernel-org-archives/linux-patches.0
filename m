Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EADA47B3DE;
	Mon,  4 Mar 2024 21:31:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709587866; cv=none; b=vEY0gpmpNnDCN304VaLcJkb5f+Fg72wV9MYUoTUWw0rRMH00uJRd8RbvMBgxVQx4wEQMe96sjnlHWOgMiyEJBHEfUPYRDQDoOXc++w+IcZWyYcXFBLqizR5zodQonVIV553V0AE+ZteylpeHViBumKF0vdYin0PXI5EMEd6Kro4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709587866; c=relaxed/simple;
	bh=/OqL8W465GhakLur0dVe15oCJkGyFHkBJrDzvPEdZQE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JHca4hxsNGNmIqKsOEBC+Clkey/lE0XQt+G2nnkOSnlr8zINcXxeN/yNRPkEZm9Z/71/Dpc0i4gZst1YHJ+LlXXqgmUeKpS87gQJTTm0/rE3eTnTuNLgQrArnkS2C7mLvK1QOBTrItwFvSGcMlTcw0ypDBHm2AoR9FEbPNCRKCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LQUek0KB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LQUek0KB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B582C433C7;
	Mon,  4 Mar 2024 21:31:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709587865;
	bh=/OqL8W465GhakLur0dVe15oCJkGyFHkBJrDzvPEdZQE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LQUek0KBX+xgfUuFRWuuM9fYJBSFrW2pitl079w28lxLfNq4PWvyV39FH+//V6+mn
	 tL5QMNDvDIlS21Z5W+KpQjxUuf74qHZHVj1YnuRT1T/VAZ3bTqA3/gRiFrXbRjPl82
	 AhpxYBv9akHqEjJES1loideRGWOeizrAa/zlG0Ik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Ma <peng.ma@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.7 095/162] dmaengine: fsl-qdma: fix SoC may hang on 16 byte unaligned read
Date: Mon,  4 Mar 2024 21:22:40 +0000
Message-ID: <20240304211554.885787468@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211551.833500257@linuxfoundation.org>
References: <20240304211551.833500257@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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


