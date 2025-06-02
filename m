Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 128CE226D1E;
	Mon,  2 Jun 2025 14:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748876146; cv=none; b=JsEJQc4rIowj1bY3OLzRM/4uVaY6xkLxD0rHiCRuVPfAbC3qlg/WhyfGMLontGNF624VSgOLY3OKUCsUr4d/lGKzeDp752uA2iOJEyDz1+mvzmQjafFU8WILpI5eBV487h/+ZhI09Ecf9DNXFBvtNj7fs93XZDcyccydA0Vi/0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748876146; c=relaxed/simple;
	bh=1Z2M4LcKPNs3n7jSMWeQ9+wBKw5Xvezp0x7hKU8rIM4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=s94mlgYGXubRc7r3vy0OG2T5mVqjBgiCOF8CaSGy+8XTwsMVjtlxpJ045VE3aJ0W87eT2AV34SH1LuX1AkvwiKJsqJR0apeI/n5/ezH32JvoiMOszqkRSJrojtr/ti+jqi6l8aYAYpyYp6MzrvlWRXuKP42NB5Ps8hGbgBWhpAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MoPhOBlF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MoPhOBlF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12A12C4CEEB;
	Mon,  2 Jun 2025 14:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748876145;
	bh=1Z2M4LcKPNs3n7jSMWeQ9+wBKw5Xvezp0x7hKU8rIM4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MoPhOBlFCiVToDZqOufZnG5+lfTAIpKqKhqpdSuNNie/ODuKXDL4NZwT9tDzgVfsB
	 cXkx8lUcL8UfJFet5NcwZJStr9g2mv4sk3H9ofrW66ljtZSPRfMt7F3sZU/sMp2xce
	 bNEaIBInHfbwf8laGMECUCCsLT6+qMk4blGgoBAY=
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
Subject: [PATCH 5.15 055/207] mmc: sdhci: Disable SD card clock before changing parameters
Date: Mon,  2 Jun 2025 15:47:07 +0200
Message-ID: <20250602134300.907972382@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134258.769974467@linuxfoundation.org>
References: <20250602134258.769974467@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index c0900b2f7b5c8..97eeb0c61baec 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -2009,10 +2009,15 @@ void sdhci_set_clock(struct sdhci_host *host, unsigned int clock)
 
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



