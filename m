Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621577;
	b=u5nLGqgdlRmpB2qxbRESZzUl5ATsNSyqQopCNjRMyuJr/g29U9ARTQ7TxpV3lVr+l9nf
	 YCu9HYV4FcZuVPfyRE7cHvVPtMWIpMON7aI0utN4NE70ow6i+qVQbGvvbwvOUyif/v32o
	 4UaGj0+9b5p3NK5aES1xLQpSZCcOI/P8YMSfMgJET+wTcIva8C+V/Hrj3dLCPJVsGkQCo
	 cbm3W/daYzMzIvtTl2LcZTDbSsKJWz9ari4C2Pi2fjhAmSCxEDJhCujKZIGnLUyHSjXrv
	 BsoQJlvHVdoBFXnLwiY2nsjctj7H0RBPrV7gkW0Qat/+JVLY2OsWGFpaaJ8+ENGvFMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621577;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=633EsKN5pfsLgolH+w+BMDlJnoWR+dqDZWJl1Ib5z4c=;
	b=Pw6IDl8dTz71oNEflyGGjTFHSFlfAHIfijy4tqQeiA3sA0zwpdIOLxk6496wT2qSOEv7
	 0EuIhyuNr1Z+VmmnxZfkoS8HbVyTliLWNtqq7Loj9JN/hQEjWY4IBKLl6VWeXfC5g+Z9e
	 Ag2AWJITowc7ew2qfGLfydsbbvw1AGowkRb2E/VhiPa2MIhSO+3V2pjnu6hk88X7cOSy3
	 FzMQelbQDoa0aU//Ok8ZX6IdTrkXUxy/iVlzU3OGb7IVgJhejFkGR7YMGkKV8zQ58aIu7
	 VNyvm11eJ+Z9Fb7tOtoBfg+KKTMCWv5DTocHfcHpeEv2u6LoaAEGxRRkSkcMln7pBIA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jWTXbM7v;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72E03606A326;
	Wed, 25 Nov 2026 15:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jWTXbM7v
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEBE01F000D4;
	Wed, 25 Nov 2026 15:46:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621577;
	bh=633EsKN5pfsLgolH+w+BMDlJnoWR+dqDZWJl1Ib5z4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jWTXbM7vti6BTdQ0SlExjFA3z+ndQ6g6kDGFu9B2T5GQfmHo+DIIyUyef+SsDn/X7
	 3azfaDto0p/zccWfCetPEG+tCNj3paE5yQzUjTp77OnqlIoLdUPlvRI/Kqhk8NsgK6
	 4VLGIfSoMLdpuHROGO9bg5rP1uGy1LfNjajfY+XM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frederic Konrad <fkonrad@amd.com>,
	Srikanth Boyapally <srikanth.boyapally@amd.com>,
	Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 271/990] spi: cadence-quadspi: Fix race between DMA completion and transfer start
Date: Wed, 25 Nov 2026 15:27:18 +0100
Message-ID: <20261125143828.439679465@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frederic Konrad <fkonrad@amd.com>

[ Upstream commit 059518f775baecc9803fc97787bd0b17558f8047 ]

In cqspi_versal_indirect_read_dma(), the DMA transfer is started by
writing CQSPI_REG_INDIRECTRD_START_MASK to the indirect read control
register. Under certain timing conditions, the DMA completion interrupt
may be triggered and complete the transfer before the completion
structure is reinitialized.

This creates a race where the completion event is lost, causing
wait_for_completion_timeout() to time out even though the transfer has
already completed, resulting in errors such as:

  spi-nor spi0.0: CS0: operation failed with -110

Fix this by reinitializing the completion structure before starting the
DMA transfer, ensuring that any completion event generated after the
transfer begins is correctly observed.

Fixes: 1a6f854f7daa ("spi: cadence-quadspi: Add Xilinx Versal external DMA support")
Signed-off-by: Frederic Konrad <fkonrad@amd.com>
Signed-off-by: Srikanth Boyapally <srikanth.boyapally@amd.com>
Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
Link: https://patch.msgid.link/20261104071958.2405117-1-radhey.shyam.pandey@amd.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-cadence-quadspi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi-cadence-quadspi.c b/drivers/spi/spi-cadence-quadspi.c
index 441426bc232ef..f74abed42eab9 100644
--- a/drivers/spi/spi-cadence-quadspi.c
+++ b/drivers/spi/spi-cadence-quadspi.c
@@ -957,11 +957,11 @@ static int cqspi_versal_indirect_read_dma(struct cqspi_flash_pdata *f_pdata,
 	writel(CQSPI_REG_VERSAL_DMA_DST_CTRL_VAL,
 	       reg_base + CQSPI_REG_VERSAL_DMA_DST_CTRL);
 
+	reinit_completion(&cqspi->transfer_complete);
+
 	writel(CQSPI_REG_INDIRECTRD_START_MASK,
 	       reg_base + CQSPI_REG_INDIRECTRD);
 
-	reinit_completion(&cqspi->transfer_complete);
-
 	if (!wait_for_completion_timeout(&cqspi->transfer_complete,
 					 msecs_to_jiffies(max_t(size_t, bytes_to_dma, 500)))) {
 		ret = -ETIMEDOUT;
-- 
2.53.0



