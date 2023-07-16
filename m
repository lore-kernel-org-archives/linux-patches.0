Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9728933F1
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:35:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A2E8C433C9;
	Sun, 16 Jul 2023 20:35:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689539728;
	bh=cgfTOxyRrI59hsuhKGSL6VtWXAC6MVGSDOYDNLnAu2A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=utVHKKl8+xyMQ6JQw0UihXvA0tJmnZ6rQkt08xRIL6UZWp/5hlY6v942kvduQ+KU0
	 n9oe6KamEd7ich/axIkNJ4yH2PHhQMwaj40g3RgzRrWevEN3vPKL6QsEdZm2j9MgUw
	 Gx0gvjADMaaxKY8id0b8U/4OL0Cv6Okseiu+FyU4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Douglas Anderson <dianders@chromium.org>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 103/591] mmc: mediatek: Avoid ugly error message when SDIO wakeup IRQ isnt used
Date: Sun, 16 Jul 2023 21:44:02 +0200
Message-ID: <20230716194926.540170201@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Douglas Anderson <dianders@chromium.org>

[ Upstream commit a3332b7aad346b14770797e03ddd02ebdb14db41 ]

When I boot a kukui-kodama board, I see an ugly warning in my kernel
log:
  mtk-msdc 11240000.mmc: error -ENXIO: IRQ sdio_wakeup not found

It's pretty normal not to have an "sdio_wakeup" IRQ defined. In fact,
no device trees in mainline seem to have it. Let's use the
platform_get_irq_byname_optional() to avoid the error message.

Fixes: 527f36f5efa4 ("mmc: mediatek: add support for SDIO eint wakup IRQ")
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Matthias Brugger <matthias.bgg@gmail.com>
Link: https://lore.kernel.org/r/20230510064434.1.I935404c5396e6bf952e99bb7ffb744c6f7fd430b@changeid
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/mtk-sd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mmc/host/mtk-sd.c b/drivers/mmc/host/mtk-sd.c
index 425efb3fba048..1a0d4dc24717c 100644
--- a/drivers/mmc/host/mtk-sd.c
+++ b/drivers/mmc/host/mtk-sd.c
@@ -2685,7 +2685,7 @@ static int msdc_drv_probe(struct platform_device *pdev)
 
 	/* Support for SDIO eint irq ? */
 	if ((mmc->pm_caps & MMC_PM_WAKE_SDIO_IRQ) && (mmc->pm_caps & MMC_PM_KEEP_POWER)) {
-		host->eint_irq = platform_get_irq_byname(pdev, "sdio_wakeup");
+		host->eint_irq = platform_get_irq_byname_optional(pdev, "sdio_wakeup");
 		if (host->eint_irq > 0) {
 			host->pins_eint = pinctrl_lookup_state(host->pinctrl, "state_eint");
 			if (IS_ERR(host->pins_eint)) {
-- 
2.39.2



