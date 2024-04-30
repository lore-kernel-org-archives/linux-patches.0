Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E19112D753;
	Tue, 30 Apr 2024 11:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475665; cv=none; b=cagyHe25sOTACQIEy3x/hfo2aqdqUKEbEtVwHRNq+q4Ij4RDE4thr5eIteJFRKuvLkQ/TDAvwhJycZBCVr2LWJwyEFMZTGv5XWm9z77OIt2xVD9zsHirUZv9uJY1cbtRhZAwLtDXFqaON4dPO5PI5J4S+Td6vLgAUOzNAZb++as=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475665; c=relaxed/simple;
	bh=LyA31r1DwQEHVIS4K7KEXKtD161DUcigpElOGMah3ss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FpTwOFnjACv/FcczvtEI4okdaad6ZJrbAUN1hwZI608TpesaSwZ4XUZozQ6ZXyeOcquqi4huNgNEUh/fqvfm2Sfaiw6wZfTZFb+8cQa1x13YY48AILMiRX+qJTIgusxiej69Ej+553XNJl+r6SKplQjkpCkqFAZN0Z25fFF0p3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2wg/aAyf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2wg/aAyf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2E3FC4AF19;
	Tue, 30 Apr 2024 11:14:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475665;
	bh=LyA31r1DwQEHVIS4K7KEXKtD161DUcigpElOGMah3ss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2wg/aAyfgrEYhn6JAiaCuQ5BkAz1gBbs3IedxZSxZOjjae/rkcKWqega1OcMvgD8n
	 HDu8jQjLNw4Mh049w0WNzw9t6vUKZ38UdwnyjYsCX9HXZK2/+bb/Z+sghzqzG8qeVd
	 S/L1u23/9O+IW4rRJDeDkEhNVf7Lj9q7QWfahQr4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akhil R <akhilrajeev@nvidia.com>,
	Jon Hunter <jonathanh@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 159/186] dmaengine: tegra186: Fix residual calculation
Date: Tue, 30 Apr 2024 12:40:11 +0200
Message-ID: <20240430103102.648916387@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103058.010791820@linuxfoundation.org>
References: <20240430103058.010791820@linuxfoundation.org>
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
index 33b1010011009..674cf63052838 100644
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



