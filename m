Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E112B14A0B8;
	Tue, 25 Jun 2024 09:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309272; cv=none; b=MOK7tVU+A0EV2u8q6tMb1dDRIwYnCmM5P/Qvt4nKM8iH2qWFLkb9MW6s6qISvZL6fSYfapNdtBKlNi79YAju/bso0GSXH5HqgT990RjzDqlmEUCfabOezpFWPti+0T2p0+yuejt0vS+AH916tJeAXKChrgkMfNsOaYbIXvj/ejQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309272; c=relaxed/simple;
	bh=LHjs8xrOZ9/qrNpBmtmkgU6Ua+Ec5I2P+yYjOO28oYw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i66jFyP3cvqJxFmsz9iZd7HJwFgXUw6tApxbkXbnSehu3wZU/3DdFGG71IUdtfQZjav3i1UwhKil//3/hHM5Sb7gsyL+Nw8aQfUTJBXhBEOENRALooNDpK5ZFevvmeYaulFgj0wUTI0Z0YINKpkwWUZ2Ql7wqKqOw9oJ5dV4RyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fMGy4AGx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fMGy4AGx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32CF3C32786;
	Tue, 25 Jun 2024 09:54:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309271;
	bh=LHjs8xrOZ9/qrNpBmtmkgU6Ua+Ec5I2P+yYjOO28oYw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fMGy4AGxJ4BeyjwYTvh9vWM39/+K/rXr1oDRs05ZGrc7w+ertLbBMbsg3qc7BQE0/
	 JfegCzAoIGr2kWuVpRKAFBbRVzviIiet1RgKWv8N3rq7Am/lUX16NdxXK9/bUTraXf
	 iC9t9d0gAA6rSdVfdm2glumGmrGwUQyA0W8q7omY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Moring <stefan.moring@technolution.nl>,
	Stefan Bigler <linux@bigler.io>,
	Clark Wang <xiaoning.wang@nxp.com>,
	Carlos Song <carlos.song@nxp.com>,
	Sebastian Reichel <sre@kernel.org>,
	Thorsten Scherer <T.Scherer@eckelmann.de>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Thorsten Scherer <t.scherer@eckelmann.de>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 122/192] spi: spi-imx: imx51: revert burst length calculation back to bits_per_word
Date: Tue, 25 Jun 2024 11:33:14 +0200
Message-ID: <20240625085541.851872813@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085537.150087723@linuxfoundation.org>
References: <20240625085537.150087723@linuxfoundation.org>
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

From: Marc Kleine-Budde <mkl@pengutronix.de>

[ Upstream commit df75470b317b46affbe1f5f8f006b34175be9789 ]

The patch 15a6af94a277 ("spi: Increase imx51 ecspi burst length based
on transfer length") increased the burst length calculation in
mx51_ecspi_prepare_transfer() to be based on the transfer length.

This breaks HW CS + SPI_CS_WORD support which was added in
6e95b23a5b2d ("spi: imx: Implement support for CS_WORD") and transfers
with bits-per-word != 8, 16, 32.

SPI_CS_WORD means the CS should be toggled after each word. The
implementation in the imx-spi driver relies on the fact that the HW CS
is toggled automatically by the controller after each burst length
number of bits. Setting the burst length to the number of bits of the
_whole_ message breaks this use case.

Further the patch 15a6af94a277 ("spi: Increase imx51 ecspi burst
length based on transfer length") claims to optimize the transfers.
But even without this patch, on modern spi-imx controllers with
"dynamic_burst = true" (imx51, imx6 and newer), the transfers are
already optimized, i.e. the burst length is dynamically adjusted in
spi_imx_push() to avoid the pause between the SPI bursts. This has
been confirmed by a scope measurement on an imx6d.

Subsequent Patches tried to fix these and other problems:

- 5f66db08cbd3 ("spi: imx: Take in account bits per word instead of assuming 8-bits")
- e9b220aeacf1 ("spi: spi-imx: correctly configure burst length when using dma")
- c712c05e46c8 ("spi: imx: fix the burst length at DMA mode and CPU mode")
- cf6d79a0f576 ("spi: spi-imx: fix off-by-one in mx51 CPU mode burst length")

but the HW CS + SPI_CS_WORD use case is still broken.

To fix the problems revert the burst size calculation in
mx51_ecspi_prepare_transfer() back to the original form, before
15a6af94a277 ("spi: Increase imx51 ecspi burst length based on
transfer length") was applied.

Cc: Stefan Moring <stefan.moring@technolution.nl>
Cc: Stefan Bigler <linux@bigler.io>
Cc: Clark Wang <xiaoning.wang@nxp.com>
Cc: Carlos Song <carlos.song@nxp.com>
Cc: Sebastian Reichel <sre@kernel.org>
Cc: Thorsten Scherer <T.Scherer@eckelmann.de>
Fixes: 15a6af94a277 ("spi: Increase imx51 ecspi burst length based on transfer length")
Fixes: 5f66db08cbd3 ("spi: imx: Take in account bits per word instead of assuming 8-bits")
Fixes: e9b220aeacf1 ("spi: spi-imx: correctly configure burst length when using dma")
Fixes: c712c05e46c8 ("spi: imx: fix the burst length at DMA mode and CPU mode")
Fixes: cf6d79a0f576 ("spi: spi-imx: fix off-by-one in mx51 CPU mode burst length")
Link: https://lore.kernel.org/all/20240618-oxpecker-of-ideal-mastery-db59f8-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Tested-by: Thorsten Scherer <t.scherer@eckelmann.de>
Link: https://msgid.link/r/20240618-spi-imx-fix-bustlength-v1-1-2053dd5fdf87@pengutronix.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-imx.c | 14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff --git a/drivers/spi/spi-imx.c b/drivers/spi/spi-imx.c
index 0e479c5406217..d323b37723929 100644
--- a/drivers/spi/spi-imx.c
+++ b/drivers/spi/spi-imx.c
@@ -660,18 +660,8 @@ static int mx51_ecspi_prepare_transfer(struct spi_imx_data *spi_imx,
 		ctrl |= (spi_imx->target_burst * 8 - 1)
 			<< MX51_ECSPI_CTRL_BL_OFFSET;
 	else {
-		if (spi_imx->usedma) {
-			ctrl |= (spi_imx->bits_per_word - 1)
-				<< MX51_ECSPI_CTRL_BL_OFFSET;
-		} else {
-			if (spi_imx->count >= MX51_ECSPI_CTRL_MAX_BURST)
-				ctrl |= (MX51_ECSPI_CTRL_MAX_BURST * BITS_PER_BYTE - 1)
-						<< MX51_ECSPI_CTRL_BL_OFFSET;
-			else
-				ctrl |= (spi_imx->count / DIV_ROUND_UP(spi_imx->bits_per_word,
-						BITS_PER_BYTE) * spi_imx->bits_per_word - 1)
-						<< MX51_ECSPI_CTRL_BL_OFFSET;
-		}
+		ctrl |= (spi_imx->bits_per_word - 1)
+			<< MX51_ECSPI_CTRL_BL_OFFSET;
 	}
 
 	/* set clock speed */
-- 
2.43.0



