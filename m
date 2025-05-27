Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 456BD27FD73;
	Tue, 27 May 2025 16:54:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748364848; cv=none; b=p0g3yd9iZCZhse30w5mHGV3eS3Nfc9QzNyefsOiPq2UG5YxGzeuIj4X0cnOlItlKOgxpWhL0ZGlxAYPEW7ofDr29OUz41ObAQJ6QHqujWd4ZzBba0CHPQNj8lM5kAMVAoFfoka/YtQzt9cnOqDjqW1FcTmzWZbwaf50kIPfbAwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748364848; c=relaxed/simple;
	bh=WYH1wgwXq6YcREVO8LwCvwRuBbDcrbVBS/SiRq1Dtjg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tYrghmlcWPyZwNbrnglaC0TYPSWul7EZxGwaMyoYvZuoypMB6JtVnDGadsAsGMGB0m90rWpZ3oh6PamnQPYr+adqMfYtJt0xFypbPApHm0kQRL3AHARTcn/IuJSzOddVmDkNtez6jvZI4GWdUQcyb+zp57BLOftMbrd1MYeIZWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B+6vGZKy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B+6vGZKy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7CB8C4CEE9;
	Tue, 27 May 2025 16:54:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748364848;
	bh=WYH1wgwXq6YcREVO8LwCvwRuBbDcrbVBS/SiRq1Dtjg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B+6vGZKy0EuN+HCo6BAHOKYe1DsvL0dkg+tCzsKCLBsfpmulr38lwndwO0RuE5aXP
	 gmx44bqJ4wT47rQR9ry84/a4nYCM6gPpi1vW7zrKC9oxgtksIG4DGLAEo7fOgss9Fm
	 pLIcv33KCGNpkdE+Kk1sruS6EgVPuvzSAJmIyM0A=
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
Subject: [PATCH 6.12 178/626] mmc: sdhci: Disable SD card clock before changing parameters
Date: Tue, 27 May 2025 18:21:11 +0200
Message-ID: <20250527162452.244829396@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 4b91c9e966357..8ae76300d157d 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -2035,10 +2035,15 @@ void sdhci_set_clock(struct sdhci_host *host, unsigned int clock)
 
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



