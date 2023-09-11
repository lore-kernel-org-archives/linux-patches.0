Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D672711706
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:59:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 505FAC433C7;
	Mon, 11 Sep 2023 14:59:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694444380;
	bh=9otKf8loXp0++gGrAqx+i0+S8Y39VZ+WCmbArwWX1w0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T7lQ2Ag6KGGvWc6TnJIlaIMQ7MbuG0H2X+QjMWraEfeBaw55hupK73OIgVJEpEuyb
	 4Xyyx2lWlvVoXHkGdiobvRuJAe8NXH0vzGq9lIqEH6K/gvsv4yfR1rdv+O+4BK1TvV
	 6zV1A+lpLexiIpb1d6kUgnofJL3OJsSeu2BKM804=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.4 702/737] mmc: renesas_sdhi: register irqs before registering controller
Date: Mon, 11 Sep 2023 15:49:21 +0200
Message-ID: <20230911134710.131413933@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>
References: <20230911134650.286315610@linuxfoundation.org>
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

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wolfram Sang <wsa+renesas@sang-engineering.com>

commit 74f45de394d979cc7770271f92fafa53e1ed3119 upstream.

IRQs should be ready to serve when we call mmc_add_host() via
tmio_mmc_host_probe(). To achieve that, ensure that all irqs are masked
before registering the handlers.

Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Tested-by: Biju Das <biju.das.jz@bp.renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20230712140011.18602-1-wsa+renesas@sang-engineering.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/renesas_sdhi_core.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/drivers/mmc/host/renesas_sdhi_core.c
+++ b/drivers/mmc/host/renesas_sdhi_core.c
@@ -1006,6 +1006,8 @@ int renesas_sdhi_probe(struct platform_d
 		host->sdcard_irq_setbit_mask = TMIO_STAT_ALWAYS_SET_27;
 		host->sdcard_irq_mask_all = TMIO_MASK_ALL_RCAR2;
 		host->reset = renesas_sdhi_reset;
+	} else {
+		host->sdcard_irq_mask_all = TMIO_MASK_ALL;
 	}
 
 	/* Orginally registers were 16 bit apart, could be 32 or 64 nowadays */
@@ -1100,9 +1102,7 @@ int renesas_sdhi_probe(struct platform_d
 		host->ops.hs400_complete = renesas_sdhi_hs400_complete;
 	}
 
-	ret = tmio_mmc_host_probe(host);
-	if (ret < 0)
-		goto edisclk;
+	sd_ctrl_write32_as_16_and_16(host, CTL_IRQ_MASK, host->sdcard_irq_mask_all);
 
 	num_irqs = platform_irq_count(pdev);
 	if (num_irqs < 0) {
@@ -1129,6 +1129,10 @@ int renesas_sdhi_probe(struct platform_d
 			goto eirq;
 	}
 
+	ret = tmio_mmc_host_probe(host);
+	if (ret < 0)
+		goto edisclk;
+
 	dev_info(&pdev->dev, "%s base at %pa, max clock rate %u MHz\n",
 		 mmc_hostname(host->mmc), &res->start, host->mmc->f_max / 1000000);
 


