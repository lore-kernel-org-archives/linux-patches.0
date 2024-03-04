Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFA554CE0E;
	Mon,  4 Mar 2024 21:30:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709587808; cv=none; b=cNaUn0MLMLwivzSQ/7+/4fU90xAdN7gdbzfGBqtixCzltY/NggKEMKxxZjumEHWELplR9HxMfNmnFrsr9NgMDQ0Xno6kVx+NHk3W4QsflMaeXvvEk9PvsptV45Wd4JYWi4d1sULdgp3JnySaThDxVUXZgE/pz54E55vNrKV12Tg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709587808; c=relaxed/simple;
	bh=rq3sEmLH0GGZADYZ9ZLD8nCebluy3fmgHV448YO9wmw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V5mGRDh4SNh0UGsj1FF7Z8hNSMumq9ES4rSU3st8QWp5eJGPcYn4uE/o/30rarEi5O972s3KRAZ7Csp2/oJx/eFH3Qvp5sXmGylgGvxjenyDIyXugG0S0qfToDOFh6+4Yj0IDeC9/loVmovA7/NPmbvCtML8rvDjcxCM8Kq+xxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a3OtcxgL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a3OtcxgL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 430A2C433C7;
	Mon,  4 Mar 2024 21:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709587808;
	bh=rq3sEmLH0GGZADYZ9ZLD8nCebluy3fmgHV448YO9wmw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a3OtcxgLUDgbMWN/lwtR7wsXNJ3wKF676jkab8mLDCnYzE8PRCFkiwIjd5DX+V+mf
	 oWQ/td5fyCZ6hGolnp3E7zeqzrYF0kMMmd9w018nMzl/CcA0weoeKl8XTLiYwm7qWo
	 v9jPPkQgP58lm+CUERLPSuKLO3G7s+U9HVdHbNc4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joy Zou <joy.zou@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.7 098/162] dmaengine: fsl-edma: correct calculation of nbytes in multi-fifo scenario
Date: Mon,  4 Mar 2024 21:22:43 +0000
Message-ID: <20240304211554.971841163@linuxfoundation.org>
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

From: Joy Zou <joy.zou@nxp.com>

commit 9ba17defd9edd87970b701085402bc8ecc3a11d4 upstream.

The 'nbytes' should be equivalent to burst * width in audio multi-fifo
setups. Given that the FIFO width is fixed at 32 bits, adjusts the burst
size for multi-fifo configurations to match the slave maxburst in the
configuration.

Cc: stable@vger.kernel.org
Fixes: 72f5801a4e2b ("dmaengine: fsl-edma: integrate v3 support")
Signed-off-by: Joy Zou <joy.zou@nxp.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Link: https://lore.kernel.org/r/20240131163318.360315-1-Frank.Li@nxp.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/fsl-edma-common.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/dma/fsl-edma-common.c
+++ b/drivers/dma/fsl-edma-common.c
@@ -503,7 +503,7 @@ void fsl_edma_fill_tcd(struct fsl_edma_c
 	if (fsl_chan->is_multi_fifo) {
 		/* set mloff to support multiple fifo */
 		burst = cfg->direction == DMA_DEV_TO_MEM ?
-				cfg->src_addr_width : cfg->dst_addr_width;
+				cfg->src_maxburst : cfg->dst_maxburst;
 		nbytes |= EDMA_V3_TCD_NBYTES_MLOFF(-(burst * 4));
 		/* enable DMLOE/SMLOE */
 		if (cfg->direction == DMA_MEM_TO_DEV) {


