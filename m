Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A0E430F80
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:41:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85F9EC433CD;
	Wed, 20 Sep 2023 12:41:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695213692;
	bh=lXnYU39OPapoTiKwcR3wfdmnpT1f0fgoi6hvK/S1CvM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2p6HZJuwavSk8A8kua4ouyspHymT2pQ2O85ElG+wWTNwCZEjm8yfmPtcYzlpaRzcJ
	 UrWuU9Te9+t74mLo+0WVwmVFehkojULy9kPSNGIE6si6sW+fHHldQenTezVX2F/RqW
	 7w0MKdExe5FDD7MKmoElxeuayZfKrF56hUxKVrIs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jim Reinhart <jimr@tekvox.com>,
	James Autry <jautry@tekvox.com>,
	Matthew Maron <matthewm@tekvox.com>,
	Giulio Benetti <giulio.benetti@benettiengineering.com>,
	Haibo Chen <haibo.chen@nxp.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 323/367] mmc: sdhci-esdhc-imx: improve ESDHC_FLAG_ERR010450
Date: Wed, 20 Sep 2023 13:31:40 +0200
Message-ID: <20230920112906.902056310@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112858.471730572@linuxfoundation.org>
References: <20230920112858.471730572@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Giulio Benetti <giulio.benetti@benettiengineering.com>

[ Upstream commit 5ae4b0d8875caa44946e579420c7fd5740d58653 ]

Errata ERR010450 only shows up if voltage is 1.8V, but if the device is
supplied by 3v3 the errata can be ignored. So let's check for if quirk
SDHCI_QUIRK2_NO_1_8_V is defined or not before limiting the frequency.

Cc: Jim Reinhart <jimr@tekvox.com>
Cc: James Autry <jautry@tekvox.com>
Cc: Matthew Maron <matthewm@tekvox.com>
Signed-off-by: Giulio Benetti <giulio.benetti@benettiengineering.com>
Acked-by: Haibo Chen <haibo.chen@nxp.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Link: https://lore.kernel.org/r/20230811214853.8623-1-giulio.benetti@benettiengineering.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/sdhci-esdhc-imx.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/mmc/host/sdhci-esdhc-imx.c b/drivers/mmc/host/sdhci-esdhc-imx.c
index b3f761eca8299..762288c6d30ce 100644
--- a/drivers/mmc/host/sdhci-esdhc-imx.c
+++ b/drivers/mmc/host/sdhci-esdhc-imx.c
@@ -153,8 +153,8 @@
 #define ESDHC_FLAG_HS400		BIT(9)
 /*
  * The IP has errata ERR010450
- * uSDHC: Due to the I/O timing limit, for SDR mode, SD card clock can't
- * exceed 150MHz, for DDR mode, SD card clock can't exceed 45MHz.
+ * uSDHC: At 1.8V due to the I/O timing limit, for SDR mode, SD card
+ * clock can't exceed 150MHz, for DDR mode, SD card clock can't exceed 45MHz.
  */
 #define ESDHC_FLAG_ERR010450		BIT(10)
 /* The IP supports HS400ES mode */
@@ -777,7 +777,8 @@ static inline void esdhc_pltfm_set_clock(struct sdhci_host *host,
 		| ESDHC_CLOCK_MASK);
 	sdhci_writel(host, temp, ESDHC_SYSTEM_CONTROL);
 
-	if (imx_data->socdata->flags & ESDHC_FLAG_ERR010450) {
+	if ((imx_data->socdata->flags & ESDHC_FLAG_ERR010450) &&
+	    (!(host->quirks2 & SDHCI_QUIRK2_NO_1_8_V))) {
 		unsigned int max_clock;
 
 		max_clock = imx_data->is_ddr ? 45000000 : 150000000;
-- 
2.40.1



