Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1BF823644F;
	Mon,  2 Jun 2025 15:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748876820; cv=none; b=PXfO0Rk0E2T7Lyq+/6OP9TVsJG+AIlBto4DlIzZ8cTjY+TiBBTc1IVYiuvFijV4C25BD4+F1LiPAf5a6u/Mt2oq4PNXPMJae0Ybi28QCJRsPN6O/XD9DomqURAdi8aurALlYelmg8zySg4290tChJnMnI2gFZqslGOiu5hTU/Jc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748876820; c=relaxed/simple;
	bh=FDRIDzVey/VLJkmjTbE0k+ml66An/35uKHrO3Uxw/+E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SVIKuRNJ4B1qCx97YgoAM12CCdMt65o3jdh98Qa2fVf5vLBzb42aERV0FsfS6JHqrXCEw0UMI+uxGG+BQP72wpxtxtYuCq0XnQ7E6I7MkS6dbgVAn+OJT8DKqbB2AvoTN5qNC0MQcPzkDev69Szyc6mhF6Xye1hSwYL4DD+E0/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZECRPrqS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZECRPrqS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9E4AC4CEF0;
	Mon,  2 Jun 2025 15:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748876820;
	bh=FDRIDzVey/VLJkmjTbE0k+ml66An/35uKHrO3Uxw/+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZECRPrqSnEcDdAVERM4Ex/1BJL6hQyRWsrqD1rWmSQCHvHy89ZS6wT+9oDmHCV5cM
	 Ieslyu/r3RyN2WXq5BywJw5tmu9pFt+PqQgstXj/Jo9ea17lFfNJlLztoYYKDPcFfW
	 x7AYpwPtYfXocwSA6huRCwn5bB00NdguW1cnHfx0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Roeschley <kyle.roeschley@ni.com>,
	Brad Mouring <brad.mouring@ni.com>,
	Erick Shepherd <erick.shepherd@ni.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 085/325] mmc: sdhci: Disable SD card clock before changing parameters
Date: Mon,  2 Jun 2025 15:46:01 +0200
Message-ID: <20250602134323.235743760@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Erick Shepherd <erick.shepherd@ni.com>

[ Upstream commit fb3bbc46c94f261b6156ee863c1b06c84cf157dc ]

Per the SD Host Controller Simplified Specification v4.20 §3.2.3, change
the SD card clock parameters only after first disabling the external card
clock. Doing this fixes a spurious clock pulse on Baytrail and Apollo Lake
SD controllers which otherwise breaks voltage switching with a specific
Swissbit SD card.

Signed-off-by: Kyle Roeschley <kyle.roeschley@ni.com>
Signed-off-by: Brad Mouring <brad.mouring@ni.com>
Signed-off-by: Erick Shepherd <erick.shepherd@ni.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Link: https://lore.kernel.org/r/20250211214645.469279-1-erick.shepherd@ni.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/sdhci.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index 536d21028a116..6822a3249286c 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -2049,10 +2049,15 @@ void sdhci_set_clock(struct sdhci_host *host, unsigned int clock)
 
 	host->mmc->actual_clock = 0;
 
-	sdhci_writew(host, 0, SDHCI_CLOCK_CONTROL);
+	clk = sdhci_readw(host, SDHCI_CLOCK_CONTROL);
+	if (clk & SDHCI_CLOCK_CARD_EN)
+		sdhci_writew(host, clk & ~SDHCI_CLOCK_CARD_EN,
+			SDHCI_CLOCK_CONTROL);
 
-	if (clock == 0)
+	if (clock == 0) {
+		sdhci_writew(host, 0, SDHCI_CLOCK_CONTROL);
 		return;
+	}
 
 	clk = sdhci_calc_clk(host, clock, &host->mmc->actual_clock);
 	sdhci_enable_clk(host, clk);
-- 
2.39.5



