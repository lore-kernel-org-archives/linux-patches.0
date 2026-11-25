Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624528;
	b=PzOIVKun27H3KMWslye/dIpuH8LxrrLPXbYSR56gk89KK3kjt5TmFPjL+dITTX9cZodw
	 Y1/dSJD426oFC9s+WOWDFufHOJ6fScsF2mzrM3ChEBeQs9Tn2EICnXuDgP5E9KZQsEIMh
	 1U1ZEUhulGtrRYeNSn4VTcClqLoFaHqc3rzkVFcSUcRcMbAD6/CIP/Ljlf+pI16Z2aMK/
	 optC+pHF3AIe+BiLeMNIy8MMBLrm6AGEBGvDFGuiRM7dE7UQZLg0NF0tF4FEIjTtTMj75
	 s/grZhNktsQUetcOAWS2DNd+qCm01g5iduHwqFbymtORgAWX8lCnOnQkOfdp2LxiXpg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624528;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/1qP+sJvydd6z2xSFZVNASCcai2I/Z42S4fARMXqKoo=;
	b=HwHKNI2BOxOqkbNKXmhmtbYbHrn5h0wyKOSOBK+htc/I6WoDCfrfj2V0YkPvXeEtveU4
	 VgLmMpSGWZZHnItRdltjUFQj0W1gtD58VOBYciAP1rFjwBeoU5rgqhEmJf0RpqklRx5Vh
	 CC5VuYqUKmZSayTEic8VWq4BcW1M7gfabioYlwXkzWGAmO4ggq2KO4LlHRwvpd+QR1bht
	 IRos4Gt9ZcEfeC4UKr8nQSM+HShDFK+n7Giw+hR08BtyOYRH6RMwuLq/EliZXbGwacrqQ
	 2zCrjb2d3CSp8fSpBqXgPsU9lKZPfSfxnJr1rGcy/GDcgBpOXzfzD2WvQeCFvkzneXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LBdb8Dtk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 564A4606A339;
	Wed, 25 Nov 2026 16:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LBdb8Dtk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A762E1F000C4;
	Wed, 25 Nov 2026 16:35:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624528;
	bh=/1qP+sJvydd6z2xSFZVNASCcai2I/Z42S4fARMXqKoo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LBdb8Dtk6aoV0Qt75Qq6kC5R3E1O0lmWOuvEgTmtryS51PsUf1hxl0ZGHTr4n5hyr
	 0vRCR7rnQlNBQj92qNPnhTJAj5o3MgrbqDCJK5n+I8JRr+p7PbIujXPKhbi5/vtUri
	 lvvR9PXkzJcumHrN1gy54Q89fyZAy+dU1081uyjQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frederic Konrad <fkonrad@amd.com>,
	Srikanth Boyapally <srikanth.boyapally@amd.com>,
	Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 220/816] spi: cadence-quadspi: Fix race between DMA completion and transfer start
Date: Wed, 25 Nov 2026 15:29:28 +0100
Message-ID: <20261125143854.298314448@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 0e387dee17323..90f3a9604ab30 100644
--- a/drivers/spi/spi-cadence-quadspi.c
+++ b/drivers/spi/spi-cadence-quadspi.c
@@ -932,11 +932,11 @@ static int cqspi_versal_indirect_read_dma(struct cqspi_flash_pdata *f_pdata,
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



