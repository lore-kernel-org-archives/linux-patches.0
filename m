Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 469B079C9
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:31:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFCA5C433EF;
	Thu, 12 Jan 2023 14:31:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673533861;
	bh=HvS1E68sRO6vEsoCle7ot2ncaAQB9rkDwBYN3kGRY4A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oZzGdmH75zx1pv5CJDg2g3RUYcNf7bWl3Iq9808ZdBMKRmaW+bfWJJmdCI5pKk5nN
	 bdTSHr5rgEyLU/dkS8q8mumPcqYJCTI2Gen6hIOJnBxMl2rXha0gZuVXD0vgsbn3RZ
	 lNxoYhY2YVY+prAybilN0FOlpKFa1UcZi/fiMTF8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wenchao Chen <wenchao.chen@unisoc.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.10 616/783] mmc: sdhci-sprd: Disable CLK_AUTO when the clock is less than 400K
Date: Thu, 12 Jan 2023 14:55:32 +0100
Message-Id: <20230112135552.817813358@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Wenchao Chen <wenchao.chen@unisoc.com>

commit ff874dbc4f868af128b412a9bd92637103cf11d7 upstream.

When the clock is less than 400K, some SD cards fail to initialize
because CLK_AUTO is enabled.

Fixes: fb8bd90f83c4 ("mmc: sdhci-sprd: Add Spreadtrum's initial host controller")
Signed-off-by: Wenchao Chen <wenchao.chen@unisoc.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20221207051909.32126-1-wenchao.chen@unisoc.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci-sprd.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

--- a/drivers/mmc/host/sdhci-sprd.c
+++ b/drivers/mmc/host/sdhci-sprd.c
@@ -224,13 +224,15 @@ static inline void _sdhci_sprd_set_clock
 	div = ((div & 0x300) >> 2) | ((div & 0xFF) << 8);
 	sdhci_enable_clk(host, div);
 
-	/* enable auto gate sdhc_enable_auto_gate */
-	val = sdhci_readl(host, SDHCI_SPRD_REG_32_BUSY_POSI);
-	mask = SDHCI_SPRD_BIT_OUTR_CLK_AUTO_EN |
-	       SDHCI_SPRD_BIT_INNR_CLK_AUTO_EN;
-	if (mask != (val & mask)) {
-		val |= mask;
-		sdhci_writel(host, val, SDHCI_SPRD_REG_32_BUSY_POSI);
+	/* Enable CLK_AUTO when the clock is greater than 400K. */
+	if (clk > 400000) {
+		val = sdhci_readl(host, SDHCI_SPRD_REG_32_BUSY_POSI);
+		mask = SDHCI_SPRD_BIT_OUTR_CLK_AUTO_EN |
+			SDHCI_SPRD_BIT_INNR_CLK_AUTO_EN;
+		if (mask != (val & mask)) {
+			val |= mask;
+			sdhci_writel(host, val, SDHCI_SPRD_REG_32_BUSY_POSI);
+		}
 	}
 }
 


