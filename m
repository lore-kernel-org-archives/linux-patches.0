Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C22ED3F54CE;
	Tue, 17 Mar 2026 17:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773767262; cv=none; b=bCUEU+dFCQ0J+I2k0SGpRdSY697d65w9DChpxWTxFRmpdZeVVYgYINsZkDVfVFSzUpzaJRdui5DjPPoZmHO8eUNvORoizDOGzPbCWPjTiutWr+i82iy6mRedfzWzMSVqI7/EGasqF2DdMJoSTsqmm3NCoad5qJVTPQ30301n1k4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773767262; c=relaxed/simple;
	bh=UtGECo4WoArlV4ZaaYM6d+Nun27+AtL9qddXEvL9fPA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JRjILuEgMk27stfjpvNpEyMWcwpHRagtDe7w9XEVreZS1f16WqYXQoU8wGX36AKM+GDws6jg8w/Xwc8qV0nUDhpOf/UuE45Vfih3L3RVlDmOTWNCN9qc7sqkREsy7XFOO9YRYyvvDVoyEvNg/v9W8xW2asy6MKYerSPqFznJ/vA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FIieQ/6n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FIieQ/6n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C1F1C19424;
	Tue, 17 Mar 2026 17:07:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773767262;
	bh=UtGECo4WoArlV4ZaaYM6d+Nun27+AtL9qddXEvL9fPA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FIieQ/6nPM2qpWD0TobeMQqPIH2P3kCCOF1A4SRxHBJyppRgXA54TrJDWAGHZg+Oo
	 +REWw2oI4+cqm7c6lXCQX3ousk4oe3VSem7J1KeOIrxWT9WzEGGoA6QDtc//1+LrWd
	 LltLFWgauoHiOzxFpIN5ejxEk+qRvG03F0teKWCE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 050/333] spi: amlogic: spifc-a4: Fix DMA mapping error handling
Date: Tue, 17 Mar 2026 17:31:19 +0100
Message-ID: <20260317163001.221620827@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Gu <ustc.gu@gmail.com>

[ Upstream commit b20b437666e1cb26a7c499d1664e8f2a0ac67000 ]

Fix three bugs in aml_sfc_dma_buffer_setup() error paths:
1. Unnecessary goto: When the first DMA mapping (sfc->daddr) fails,
   nothing needs cleanup. Use direct return instead of goto.
2. Double-unmap bug: When info DMA mapping failed, the code would
   unmap sfc->daddr inline, then fall through to out_map_data which
   would unmap it again, causing a double-unmap.
3. Wrong unmap size: The out_map_info label used datalen instead of
   infolen when unmapping sfc->iaddr, which could lead to incorrect
   DMA sync behavior.

Fixes: 4670db6f32e9 ("spi: amlogic: add driver for Amlogic SPI Flash Controller")
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Link: https://patch.msgid.link/20260306-spifc-a4-v1-1-f22c9965f64a@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-amlogic-spifc-a4.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/spi/spi-amlogic-spifc-a4.c b/drivers/spi/spi-amlogic-spifc-a4.c
index 35a7c4965e113..f324aa39a8976 100644
--- a/drivers/spi/spi-amlogic-spifc-a4.c
+++ b/drivers/spi/spi-amlogic-spifc-a4.c
@@ -411,7 +411,7 @@ static int aml_sfc_dma_buffer_setup(struct aml_sfc *sfc, void *databuf,
 	ret = dma_mapping_error(sfc->dev, sfc->daddr);
 	if (ret) {
 		dev_err(sfc->dev, "DMA mapping error\n");
-		goto out_map_data;
+		return ret;
 	}
 
 	cmd = CMD_DATA_ADDRL(sfc->daddr);
@@ -429,7 +429,6 @@ static int aml_sfc_dma_buffer_setup(struct aml_sfc *sfc, void *databuf,
 		ret = dma_mapping_error(sfc->dev, sfc->iaddr);
 		if (ret) {
 			dev_err(sfc->dev, "DMA mapping error\n");
-			dma_unmap_single(sfc->dev, sfc->daddr, datalen, dir);
 			goto out_map_data;
 		}
 
@@ -448,7 +447,7 @@ static int aml_sfc_dma_buffer_setup(struct aml_sfc *sfc, void *databuf,
 	return 0;
 
 out_map_info:
-	dma_unmap_single(sfc->dev, sfc->iaddr, datalen, dir);
+	dma_unmap_single(sfc->dev, sfc->iaddr, infolen, dir);
 out_map_data:
 	dma_unmap_single(sfc->dev, sfc->daddr, datalen, dir);
 
-- 
2.51.0



