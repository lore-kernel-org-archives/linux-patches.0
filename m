Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EAB911C86
	for <patches@lists.linux.dev>; Thu, 24 Aug 2023 14:56:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4A4DC433C7;
	Thu, 24 Aug 2023 14:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692889009;
	bh=ayBJRZCvt2084hc1IRrtsSpfdEvtOtwkL+oa3E/MWV0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rGx8rpUUslWCXKCLaVpzGx+UuC8siNuuZx3jdnXPm2aCGSpvKkq/uwhOvBaWHzxJJ
	 tpQQd3G4FJ32x9NmaVGDRDtTjyGSuBf0a0LqCP29jaCQFtNnOzd5AW8TKkweBj+Ta4
	 an65rw+ySkjWZe7LVaVTF6jL7KN4WmeOCRdpUDBs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Yangtao Li <frank.li@vivo.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.15 122/139] mmc: f-sdh30: fix order of function calls in sdhci_f_sdh30_remove
Date: Thu, 24 Aug 2023 16:50:45 +0200
Message-ID: <20230824145028.800092574@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230824145023.559380953@linuxfoundation.org>
References: <20230824145023.559380953@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yangtao Li <frank.li@vivo.com>

commit 58abdd80b93b09023ca03007b608685c41e3a289 upstream.

The order of function calls in sdhci_f_sdh30_remove is wrong,
let's call sdhci_pltfm_unregister first.

Cc: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Fixes: 5def5c1c15bf ("mmc: sdhci-f-sdh30: Replace with sdhci_pltfm")
Signed-off-by: Yangtao Li <frank.li@vivo.com>
Reported-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Acked-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20230727070051.17778-62-frank.li@vivo.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci_f_sdh30.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/mmc/host/sdhci_f_sdh30.c
+++ b/drivers/mmc/host/sdhci_f_sdh30.c
@@ -188,12 +188,14 @@ static int sdhci_f_sdh30_remove(struct p
 {
 	struct sdhci_host *host = platform_get_drvdata(pdev);
 	struct f_sdhost_priv *priv = sdhci_f_sdhost_priv(host);
-
-	clk_disable_unprepare(priv->clk_iface);
-	clk_disable_unprepare(priv->clk);
+	struct clk *clk_iface = priv->clk_iface;
+	struct clk *clk = priv->clk;
 
 	sdhci_pltfm_unregister(pdev);
 
+	clk_disable_unprepare(clk_iface);
+	clk_disable_unprepare(clk);
+
 	return 0;
 }
 


