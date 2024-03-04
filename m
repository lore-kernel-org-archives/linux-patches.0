Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C48CF200D4;
	Mon,  4 Mar 2024 21:45:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588753; cv=none; b=sppl+NNo+7iJ3JZyvVO3t9Fdoc2WURp5j72trvFzqH29+toj2w7+U3wpHwNEtuVa3RNui9TqILU/9XzJUKBrNlJspif2wTjvRAbfgGCGsnDhCN09gp+JA05dqCtP/IM0Ufj6SAoJDfV67eZTVWJ65+18Fr3QDsNsF+k/PNmWOdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588753; c=relaxed/simple;
	bh=KALLbGVlLN76fxVFpPADNaelh1QllP8cMlD3n2MfZ5I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bofppTFQorxkdeTPEsbFl77APd5UzCYnl2pGHEcehRcguKSwrxh6wB1zzPGnOH0J6iY0ei5IX/DQr6VaTyszfyilxS9LVnAcJA+nF/2qB66SM2MSyEPTNIux4Jt4U/O4rTBIlHGtsIv54i3+jYRZnoexn542m8H1Su9oPUQBl5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vutK6d3Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vutK6d3Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F4E9C433C7;
	Mon,  4 Mar 2024 21:45:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588753;
	bh=KALLbGVlLN76fxVFpPADNaelh1QllP8cMlD3n2MfZ5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vutK6d3ZUl95Lwi1og5cqsV4Rgki1HJc7IKIKFgBhIupIHNBt+WPykrl4M4LagtLO
	 goc3lv8Wkn1DU7tO+r6ZiLGkPXYxhLkbRIvdIaZQfRhdMcxor1HqMMbiZxkcVsQr89
	 LP8Dbwo9Ql/RXoX5uOX7RHiEpCtZ9OIIJqxFTqUE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Ma <peng.ma@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.1 084/215] dmaengine: fsl-qdma: fix SoC may hang on 16 byte unaligned read
Date: Mon,  4 Mar 2024 21:22:27 +0000
Message-ID: <20240304211559.658675092@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211556.993132804@linuxfoundation.org>
References: <20240304211556.993132804@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


