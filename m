Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16C89381E92;
	Tue, 21 Jul 2026 17:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653516; cv=none; b=eatca2hCJX7prCWxgoTsf1/Uu+DLfEd6wqw6lk0BHB4hdBoPBV14ES8PN3WRy8zsmmi3BKzk3Hf8eWngzC2O/WcMRg8g3DVLUPxAoC97l6ZxYK+sqbWVeCPslPBlR68a2nXZr28gFlUjNJ+LrCeghnkTfP8S/++QXcafEo7bmAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653516; c=relaxed/simple;
	bh=e3gwW7OKutCclPjPsxT6UEPSBl3zMFREtz19fBxVfdY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AIa+xV7OB9lbv/PGFAIOUeZOO6ACgX/uBmd8kXFbCP4uU40AvjlBr/WCQWDDQ0EbKrqozujxF1UUdI9G8kspyRAkiBQb7bb5BThSblV4Aj8ogF9G7jKGH5V89/S7wuV8kSFZvGkbddflDNoElV3cDIYUK8R8l2IhhKnCkD5rXes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LQWDzTU4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LQWDzTU4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D31C1F000E9;
	Tue, 21 Jul 2026 17:05:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653515;
	bh=CzKIImKlIS+fq8LBMBbAknCMKwtsVmWnNh7TF4kwL1w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LQWDzTU4jUuk2aiDkmOiYXtDfCG9T7lBOQiY083hV80ULEAvrpR44bKc3CNP+vFxX
	 mwQx9vvw4rLkitbp/3oIe3+CSS+Q2x04jAXqXjdjtHL/d2l6l7A5S+Eu9WGnry67uq
	 jVW4NhgS5JjCXN6aC33GUtBWSGcBn7mE2Q8eB5iI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Cosmin Tanislav <cosmin-gabriel.tanislav.xa@renesas.com>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1356/2077] spi: rzv2h-rspi: Fix DMA transfer error handling for signal interruption
Date: Tue, 21 Jul 2026 17:17:09 +0200
Message-ID: <20260721152624.800734557@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Gu <ustc.gu@gmail.com>

[ Upstream commit 7fc2c3dcae28347a30ccd76c8817e5719005f1c3 ]

wait_event_interruptible_timeout() can return a negative error code when
interrupted by a signal. The original code treated all non-zero return
values as success, which would incorrectly synchronize DMA channels and
return 0 instead of propagating the interruption error.

Fixes: fa08b566860b ("spi: rzv2h-rspi: add support for DMA mode")
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Reviewed-by: Cosmin Tanislav <cosmin-gabriel.tanislav.xa@renesas.com>
Tested-by: Cosmin Tanislav <cosmin-gabriel.tanislav.xa@renesas.com>
Reviewed-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Link: https://patch.msgid.link/20260627-rspi-v1-1-170c93ee14da@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-rzv2h-rspi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi-rzv2h-rspi.c b/drivers/spi/spi-rzv2h-rspi.c
index 6ed3fad873b8cf..190d7eb2034afa 100644
--- a/drivers/spi/spi-rzv2h-rspi.c
+++ b/drivers/spi/spi-rzv2h-rspi.c
@@ -366,14 +366,14 @@ static int rzv2h_rspi_transfer_dma(struct rzv2h_rspi_priv *rspi,
 	rzv2h_rspi_clear_all_irqs(rspi);
 
 	ret = wait_event_interruptible_timeout(rspi->wait, rspi->dma_callbacked, HZ);
-	if (ret) {
+	if (ret > 0) {
 		dmaengine_synchronize(rspi->controller->dma_tx);
 		dmaengine_synchronize(rspi->controller->dma_rx);
 		ret = 0;
 	} else {
 		dmaengine_terminate_sync(rspi->controller->dma_tx);
 		dmaengine_terminate_sync(rspi->controller->dma_rx);
-		ret = -ETIMEDOUT;
+		ret = ret ?: -ETIMEDOUT;
 	}
 
 	enable_irq(rspi->irq_rx);
-- 
2.53.0



