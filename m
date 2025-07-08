Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DD681DB127;
	Tue,  8 Jul 2025 16:52:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993530; cv=none; b=HKl063jk3d682qx7W+WzTXYce9ewMO+9AU4ps/c6cOGFZyIvg4gzn/Si/gZH9VYs0CPeHPy52/m2aoOhk4w4Jc5nm6i6A6WDLuYL3p8w0lh8bB3WkIXzotrNNEZdaqzQNYRYo3bJ3p40xHcSHDIP5MLSu3roUp/wXKOpukgvapk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993530; c=relaxed/simple;
	bh=ei5b1tOuwZOFqYEh5Pt8diWNp0cFiGp6W9ImTA65VyU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UbtR6TUuxpb973q8u8he1wEG0HKxrF8fzsWpHuWQKzBmAKx2spQCrB+UDA2JoEXvR9L4u1Zkpro5GpUzrjHIMLanPpWrKGOQliUZOI0cqf/pwiDbvMWnvraWPeZNCq6jXW8Hv5Tbkud/UcvH/zJcEOGAQivOlUr/asUs7snxGhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O+mKFx8w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O+mKFx8w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAF77C4CEED;
	Tue,  8 Jul 2025 16:52:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993530;
	bh=ei5b1tOuwZOFqYEh5Pt8diWNp0cFiGp6W9ImTA65VyU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O+mKFx8wKuQlXhjtB6zAt3SQUS9d2mGzHv2h+Afzzl8OC3xcjoDZFx9yt5caz4LPW
	 +YbaotjnesHZC0DhAc69DTuHhwVc35XIrscbK4DS+5mWIJb3IZAm9i8k39djzT6aIb
	 gnL0vbLHNftaGUXDuDCUXaBhPGFTYaTbe73F6sPY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Clark <james.clark@linaro.org>,
	Frank Li <Frank.Li@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 075/178] spi: spi-fsl-dspi: Clear completion counter before initiating transfer
Date: Tue,  8 Jul 2025 18:21:52 +0200
Message-ID: <20250708162238.636279955@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162236.549307806@linuxfoundation.org>
References: <20250708162236.549307806@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: James Clark <james.clark@linaro.org>

[ Upstream commit fa60c094c19b97e103d653f528f8d9c178b6a5f5 ]

In target mode, extra interrupts can be received between the end of a
transfer and halting the module if the host continues sending more data.
If the interrupt from this occurs after the reinit_completion() then the
completion counter is left at a non-zero value. The next unrelated
transfer initiated by userspace will then complete immediately without
waiting for the interrupt or writing to the RX buffer.

Fix it by resetting the counter before the transfer so that lingering
values are cleared. This is done after clearing the FIFOs and the
status register but before the transfer is initiated, so no interrupts
should be received at this point resulting in other race conditions.

Fixes: 4f5ee75ea171 ("spi: spi-fsl-dspi: Replace interruptible wait queue with a simple completion")
Signed-off-by: James Clark <james.clark@linaro.org>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20250627-james-nxp-spi-dma-v4-1-178dba20c120@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-fsl-dspi.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-fsl-dspi.c b/drivers/spi/spi-fsl-dspi.c
index 863781ba6c160..0dcd491140950 100644
--- a/drivers/spi/spi-fsl-dspi.c
+++ b/drivers/spi/spi-fsl-dspi.c
@@ -983,11 +983,20 @@ static int dspi_transfer_one_message(struct spi_controller *ctlr,
 		if (dspi->devtype_data->trans_mode == DSPI_DMA_MODE) {
 			status = dspi_dma_xfer(dspi);
 		} else {
+			/*
+			 * Reinitialize the completion before transferring data
+			 * to avoid the case where it might remain in the done
+			 * state due to a spurious interrupt from a previous
+			 * transfer. This could falsely signal that the current
+			 * transfer has completed.
+			 */
+			if (dspi->irq)
+				reinit_completion(&dspi->xfer_done);
+
 			dspi_fifo_write(dspi);
 
 			if (dspi->irq) {
 				wait_for_completion(&dspi->xfer_done);
-				reinit_completion(&dspi->xfer_done);
 			} else {
 				do {
 					status = dspi_poll(dspi);
-- 
2.39.5



