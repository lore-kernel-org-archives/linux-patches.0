Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD45112D74F;
	Tue, 30 Apr 2024 10:56:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474586; cv=none; b=ptxBbR6MyWA8/jpmp2VYrUcUETCWMkjADNus/wnh8j+EMpnbpKZ0yOejzEUWDKR6EosyL7kg3hsR3j6x/GYtc6ZFv3+Y3SGf6EW9pOP27LLhadUoiTO8oIwYqp0jBk/D3UaC8ml/3yPngP8pKB5ncy6OvxK+RmdowtXzjzJO6ec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474586; c=relaxed/simple;
	bh=K/F5oMqMGPYPHqmB0XluH2p+MTt0rET2AbTKz9QIf88=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vCzCrL+qPTTAqyW2syCjlRw4X0ra5QcmIyBZc1iqfWHYdmK86S9Br3K81dtlQdCr+zOTKXS38Yrm8Qso/Lgi6pt5m7GqGo3IFFzVh1lyx2Afc2wMWwcer3olaHPjHgbXDBOaZ5fyss3cc/siMVeKkWh/OIugGJnLEh11k2ggH4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nxVM1cf4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nxVM1cf4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29C0AC4AF19;
	Tue, 30 Apr 2024 10:56:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474586;
	bh=K/F5oMqMGPYPHqmB0XluH2p+MTt0rET2AbTKz9QIf88=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nxVM1cf4n2DWFP3M3or/xPdGL+2YaM2zREuJb+FyhmyAeCXCQPoGEwmAdQRIcfT9k
	 6z8HL5AIbOmzV821zgqXlemPgkcAMVbBhm1ZTx7B/gc8gyA0v2cBVGaJ9bjJ5qHC6B
	 /f/8EgT70rq6spIEa2RJzRVA8CsSylYzhSP43sTg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akhil R <akhilrajeev@nvidia.com>,
	Jon Hunter <jonathanh@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 201/228] dmaengine: tegra186: Fix residual calculation
Date: Tue, 30 Apr 2024 12:39:39 +0200
Message-ID: <20240430103109.603167027@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103103.806426847@linuxfoundation.org>
References: <20240430103103.806426847@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index 88547a23825b1..3642508e88bb2 100644
--- a/drivers/dma/tegra186-gpc-dma.c
+++ b/drivers/dma/tegra186-gpc-dma.c
@@ -746,6 +746,9 @@ static int tegra_dma_get_residual(struct tegra_dma_channel *tdc)
 	bytes_xfer = dma_desc->bytes_xfer +
 		     sg_req[dma_desc->sg_idx].len - (wcount * 4);
 
+	if (dma_desc->bytes_req == bytes_xfer)
+		return 0;
+
 	residual = dma_desc->bytes_req - (bytes_xfer % dma_desc->bytes_req);
 
 	return residual;
-- 
2.43.0



