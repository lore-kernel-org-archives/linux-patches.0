Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E720F14A81
	for <patches@lists.linux.dev>; Thu, 24 Aug 2023 17:21:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5865EC433C7;
	Thu, 24 Aug 2023 17:21:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692897662;
	bh=IKNbaGGP2mw8dfvkDngwCMnUpkFNwdrwg1eeRchHifo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f+0WCy10rCoOJ3H/ttAc2F4BPFR678pA8+4cu+ou9OnKnJNVCSYkgC+IJIg5I2z5e
	 SSm0mcpaqDAR65L7mAbeCuysjZEbN98GsesnYU8NJOZJM2i4tPXKYvZmcY9zZaUXWs
	 KoyBsYYDicvsjJt1y7Y8FAsNT0AnjnuTTs9BUzqg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Yangtao Li <frank.li@vivo.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.10 118/135] mmc: f-sdh30: fix order of function calls in sdhci_f_sdh30_remove
Date: Thu, 24 Aug 2023 19:09:50 +0200
Message-ID: <20230824170622.385724745@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230824170617.074557800@linuxfoundation.org>
References: <20230824170617.074557800@linuxfoundation.org>
User-Agent: quilt/0.67
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

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
 


