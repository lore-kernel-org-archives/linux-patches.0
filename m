Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EC1133EAFF;
	Wed, 21 Jan 2026 18:25:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769019917; cv=none; b=laXPIfEDR6wWKFlrplhqsG8/N2Z2rzJOeWRoEAWPJrnmXB30iKvAqKQik16I75pC1ebDOw3k8dOnB6MwoIM/Ks/eqTFlJoQVMk8WE58PPpd7gBzAYJDD0BDAgOsIY+GjC4pPyEM38Bb1YT7gjdOyUecdVlA/ETnOjHko1aD3Xlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769019917; c=relaxed/simple;
	bh=ITkkuTIq0CnEtBuVCMz6+1ZCWlbGxr05AgYKuC1hT6g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rgv30u1//UXMV38adoJlCTXYDeeGC/uzhBL/N2+8ZQwQo2x2wWMXPXEVqUXJe17q3WPd271BNjD1OmYoTGScZJf58iA9DQnRRhCGKIIayRXfAiuswtkpXowMcgp427h6zujw1otdtMa772GDWkIYEbJZD6gjj4UMiHybAKx1HfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oFYAYXU9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oFYAYXU9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42BDAC4CEF1;
	Wed, 21 Jan 2026 18:25:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769019916;
	bh=ITkkuTIq0CnEtBuVCMz6+1ZCWlbGxr05AgYKuC1hT6g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oFYAYXU9mpxbv3p+zfdnPb/tvRklnnQCglcfHcE4FH8/sp9oS4GycVBo3sTjBQ2qc
	 eFj8Le7Yd72X4PrA/HFdi4XmtivyI0dhIza3+MvoKYTmOgeaEReUGGA55uVI4iFyZi
	 gDh2mnjagxRxWtctffqLlzvNBXxW+Qxa+Q9oE8dU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Zhen Ni <zhen.ni@easystack.cn>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 135/139] dmaengine: fsl-edma: Fix clk leak on alloc_chan_resources failure
Date: Wed, 21 Jan 2026 19:16:23 +0100
Message-ID: <20260121181416.314270099@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181411.452263583@linuxfoundation.org>
References: <20260121181411.452263583@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhen Ni <zhen.ni@easystack.cn>

[ Upstream commit b18cd8b210417f90537d914ffb96e390c85a7379 ]

When fsl_edma_alloc_chan_resources() fails after clk_prepare_enable(),
the error paths only free IRQs and destroy the TCD pool, but forget to
call clk_disable_unprepare(). This causes the channel clock to remain
enabled, leaking power and resources.

Fix it by disabling the channel clock in the error unwind path.

Fixes: d8d4355861d8 ("dmaengine: fsl-edma: add i.MX8ULP edma support")
Cc: stable@vger.kernel.org
Suggested-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Zhen Ni <zhen.ni@easystack.cn>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20251014090522.827726-1-zhen.ni@easystack.cn
Signed-off-by: Vinod Koul <vkoul@kernel.org>
[ Different error handling scheme ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/fsl-edma-common.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/dma/fsl-edma-common.c
+++ b/drivers/dma/fsl-edma-common.c
@@ -819,6 +819,7 @@ int fsl_edma_alloc_chan_resources(struct
 
 		if (ret) {
 			dma_pool_destroy(fsl_chan->tcd_pool);
+			clk_disable_unprepare(fsl_chan->clk);
 			return ret;
 		}
 	}


