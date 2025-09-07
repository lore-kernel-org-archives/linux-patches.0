Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9E5F1B424F;
	Sun,  7 Sep 2025 20:14:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276091; cv=none; b=pRZnMDHE50beqFmhXDseJkhOUch3CzWZjeY/eRv7mT2rH1PLRyHoFVZt41xUtpTL4PKHNFO5WlsN/rl9lKl33ERO53v7zjg5J5hdv0NFh2oAR/rX+dW+JSb2x13ztV4OZZfmK8P2/vH9QodSi3IWHAZpmOiv0cgIeDv+8w93bJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276091; c=relaxed/simple;
	bh=twNSZMT2s/dfk3nct/z3qZxQp8UIXNrS3a/HzG/7GRQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qGGFGqon19gSlygXdAVMLXEtome49MpZvAW1I2Ka2PoDpMFJu6juEvipPqGQbvHvWf7GlU2IofOv7WYryQm9X9ucomaHk49+sBPy0VbjhM0o4vBp1NATUKVaJ7zoPCWItm+H3U9VK6+fRTYnrL0iBnfwzB9gj/gBejt6SP2JsTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Juy5j9Ny; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Juy5j9Ny"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F7B6C4CEF0;
	Sun,  7 Sep 2025 20:14:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276091;
	bh=twNSZMT2s/dfk3nct/z3qZxQp8UIXNrS3a/HzG/7GRQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Juy5j9Nyc0CT4xxve9ow0U2+VrsJ93iABX86QeQVLsMrLjiKoByIyUceeJkevCIbr
	 U0jkLUZQSpwSho8pQvFzfxq2mrMqtppdbBhHw2r0SJ2Nn8GtHUyFNR94RdfZ/fo2p8
	 NyE9exh1TWLs7Bv4tlFcr7pFBPrYYF74rpxzXJsM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Larisa Grigore <larisa.grigore@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	James Clark <james.clark@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 59/64] spi: spi-fsl-lpspi: Reset FIFO and disable module on transfer abort
Date: Sun,  7 Sep 2025 21:58:41 +0200
Message-ID: <20250907195605.046483498@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195603.394640159@linuxfoundation.org>
References: <20250907195603.394640159@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Larisa Grigore <larisa.grigore@nxp.com>

[ Upstream commit e811b088a3641861fc9d2b2b840efc61a0f1907d ]

In DMA mode fsl_lpspi_reset() is always called at the end, even when the
transfer is aborted. In PIO mode aborts skip the reset leaving the FIFO
filled and the module enabled.

Fix it by always calling fsl_lpspi_reset().

Fixes: a15dc3d657fa ("spi: lpspi: Fix CLK pin becomes low before one transfer")
Signed-off-by: Larisa Grigore <larisa.grigore@nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: James Clark <james.clark@linaro.org>
Link: https://patch.msgid.link/20250828-james-nxp-lpspi-v2-3-6262b9aa9be4@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-fsl-lpspi.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/spi/spi-fsl-lpspi.c b/drivers/spi/spi-fsl-lpspi.c
index ab096368a1fd5..319cd96bd201b 100644
--- a/drivers/spi/spi-fsl-lpspi.c
+++ b/drivers/spi/spi-fsl-lpspi.c
@@ -705,12 +705,10 @@ static int fsl_lpspi_pio_transfer(struct spi_controller *controller,
 	fsl_lpspi_write_tx_fifo(fsl_lpspi);
 
 	ret = fsl_lpspi_wait_for_completion(controller);
-	if (ret)
-		return ret;
 
 	fsl_lpspi_reset(fsl_lpspi);
 
-	return 0;
+	return ret;
 }
 
 static int fsl_lpspi_transfer_one(struct spi_controller *controller,
-- 
2.51.0



