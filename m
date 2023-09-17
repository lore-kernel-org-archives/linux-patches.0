Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCFAF6FB5
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:33:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F903C433C8;
	Sun, 17 Sep 2023 20:33:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694982789;
	bh=ZU/1zerD36y2HdHS7a42WqT4UIddPy2QBXS1Ty47eW8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZlgQW5yn4RQsxC8ZyKd6rebUgRII0Gw0slcNAo9nIT1HT5fpzP7V1RsOINx2MV4IQ
	 mGjFqvofi74fknkLnTU3NIT6kBOTygGHn73Vg0iTmfOmXz4cZGQAJh3g2yhkqWMCbL
	 Duc/8SfwOsXz496PAjY4OQavh1dpsv9peYMANKn0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.15 354/511] mmc: renesas_sdhi: register irqs before registering controller
Date: Sun, 17 Sep 2023 21:13:01 +0200
Message-ID: <20230917191122.351589373@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191113.831992765@linuxfoundation.org>
References: <20230917191113.831992765@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -975,6 +975,8 @@ int renesas_sdhi_probe(struct platform_d
 		host->sdcard_irq_setbit_mask = TMIO_STAT_ALWAYS_SET_27;
 		host->sdcard_irq_mask_all = TMIO_MASK_ALL_RCAR2;
 		host->reset = renesas_sdhi_reset;
+	} else {
+		host->sdcard_irq_mask_all = TMIO_MASK_ALL;
 	}
 
 	/* Orginally registers were 16 bit apart, could be 32 or 64 nowadays */
@@ -1071,9 +1073,7 @@ int renesas_sdhi_probe(struct platform_d
 		host->ops.hs400_complete = renesas_sdhi_hs400_complete;
 	}
 
-	ret = tmio_mmc_host_probe(host);
-	if (ret < 0)
-		goto edisclk;
+	sd_ctrl_write32_as_16_and_16(host, CTL_IRQ_MASK, host->sdcard_irq_mask_all);
 
 	num_irqs = platform_irq_count(pdev);
 	if (num_irqs < 0) {
@@ -1100,6 +1100,10 @@ int renesas_sdhi_probe(struct platform_d
 			goto eirq;
 	}
 
+	ret = tmio_mmc_host_probe(host);
+	if (ret < 0)
+		goto edisclk;
+
 	dev_info(&pdev->dev, "%s base at %pa, max clock rate %u MHz\n",
 		 mmc_hostname(host->mmc), &res->start, host->mmc->f_max / 1000000);
 


