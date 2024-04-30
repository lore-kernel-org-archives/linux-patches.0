Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FE3612D1FC;
	Tue, 30 Apr 2024 11:31:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714476689; cv=none; b=hPA/OTNMDjy9Xt+JN7sdOUE+B6iHUYekbUARe1rsoMdPaQHV1aUTs+jlbMP/TO0IOPC1uaAhqs0hPeGLN1k8BqY4pKgltJdjLNbFAFznxgjuDokCexALDoTyDb4RheF6bWO1kzw9qNWSvQ5DxXVGY6CDtYJo/lysxCsg+ltIWYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714476689; c=relaxed/simple;
	bh=mV39YyLLVI4SSz4M6j2ELaJmWjXKzLiHZwpGdCveAeI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IodEUhebIcXimNsMLVDYwnY5il6ad+wIqsd0IOH41jjVSHPaKCpH110BTTNE34I5np7MKJSE5C33yrkaIVK2NTH3vahaStv7L3fYIMVwHrGsbE43uNeqtH0WyEZIy4QKZTN0RnCTbO2uqEZFhXEY23RbaJ6YIpDSkDhj51xvrYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VsDI1Dcp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VsDI1Dcp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B46BC2BBFC;
	Tue, 30 Apr 2024 11:31:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714476688;
	bh=mV39YyLLVI4SSz4M6j2ELaJmWjXKzLiHZwpGdCveAeI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VsDI1DcpHezO+IE/dgzPXYHBhQIIqr1YcXwKzvagWhKUgwRlx8TZhL/ljxDfuMRwL
	 aQpOPuK/E1WK0ezU31R6nhsYngTV3qPvWNBhRal3CGNVZj8fsDloOolcudihG2+PR/
	 GdfYAYXtsr/kyYBNF5sIYiI2sN4iHCHxaatwyhGI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akhil R <akhilrajeev@nvidia.com>,
	Jon Hunter <jonathanh@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 093/110] dmaengine: tegra186: Fix residual calculation
Date: Tue, 30 Apr 2024 12:41:02 +0200
Message-ID: <20240430103050.317142979@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103047.561802595@linuxfoundation.org>
References: <20240430103047.561802595@linuxfoundation.org>
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

From: Akhil R <akhilrajeev@nvidia.com>

[ Upstream commit 30f0ced9971b2d8c8c24ae75786f9079489a012d ]

The existing residual calculation returns an incorrect value when
bytes_xfer == bytes_req. This scenario occurs particularly with drivers
like UART where DMA is scheduled for maximum number of bytes and is
terminated when the bytes inflow stops. At higher baud rates, it could
request the tx_status while there is no bytes left to transfer. This will
lead to incorrect residual being set. Hence return residual as '0' when
bytes transferred equals to the bytes requested.

Fixes: ee17028009d4 ("dmaengine: tegra: Add tegra gpcdma driver")
Signed-off-by: Akhil R <akhilrajeev@nvidia.com>
Reviewed-by: Jon Hunter <jonathanh@nvidia.com>
Acked-by: Thierry Reding <treding@nvidia.com>
Link: https://lore.kernel.org/r/20240315124411.17582-1-akhilrajeev@nvidia.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/tegra186-gpc-dma.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/dma/tegra186-gpc-dma.c b/drivers/dma/tegra186-gpc-dma.c
index 75af3488a3baf..e70b7c41dcab7 100644
--- a/drivers/dma/tegra186-gpc-dma.c
+++ b/drivers/dma/tegra186-gpc-dma.c
@@ -742,6 +742,9 @@ static int tegra_dma_get_residual(struct tegra_dma_channel *tdc)
 	bytes_xfer = dma_desc->bytes_xfer +
 		     sg_req[dma_desc->sg_idx].len - (wcount * 4);
 
+	if (dma_desc->bytes_req == bytes_xfer)
+		return 0;
+
 	residual = dma_desc->bytes_req - (bytes_xfer % dma_desc->bytes_req);
 
 	return residual;
-- 
2.43.0



