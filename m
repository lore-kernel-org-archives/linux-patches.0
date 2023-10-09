Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 721EA328A4
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:37:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SaG37E4Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 920B3C433C9;
	Mon,  9 Oct 2023 13:37:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696858678;
	bh=iaaR9IBRS9kG31JpHzuC3LY1zGpMdYEpom/9jUajREc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SaG37E4YCTxVrk5KyPWPgs5f5nyv5IixojnmbxlOvaKyQeV9wihUGpyUIVXexRzSn
	 lCj9Fxl8yDim2jWaeaEjKi76ZQTUBHrTuXXSqh8tGwx+SNxfF08uPfVtkIrIX+AJJM
	 YuZgZcE1+BVKajpp2/oEM6KhSPP6CAk2pyRjgeik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund+renesas@ragnatech.se>,
	Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 066/226] mmc: renesas_sdhi: probe into TMIO after SCC parameters have been setup
Date: Mon,  9 Oct 2023 15:00:27 +0200
Message-ID: <20231009130128.509573506@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130126.697995596@linuxfoundation.org>
References: <20231009130126.697995596@linuxfoundation.org>
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

From: Wolfram Sang <wsa+renesas@sang-engineering.com>

[ Upstream commit b161d87dfd3d9f3fb064a089a9e521d0e5d3e38f ]

Setting up the SCC parameters does not need a probed TMIO device. But in
the near future, probing the TMIO device needs the SCC parameters setup.
So, fix the ordering.

Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Reviewed-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Tested-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Link: https://lore.kernel.org/r/20201110142058.36393-3-wsa+renesas@sang-engineering.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Stable-dep-of: 74f45de394d9 ("mmc: renesas_sdhi: register irqs before registering controller")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/renesas_sdhi_core.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/mmc/host/renesas_sdhi_core.c b/drivers/mmc/host/renesas_sdhi_core.c
index a49b8fe2a0982..2cf7360d6cade 100644
--- a/drivers/mmc/host/renesas_sdhi_core.c
+++ b/drivers/mmc/host/renesas_sdhi_core.c
@@ -1070,10 +1070,6 @@ int renesas_sdhi_probe(struct platform_device *pdev,
 			quirks->hs400_calib_table + 1);
 	}
 
-	ret = tmio_mmc_host_probe(host);
-	if (ret < 0)
-		goto edisclk;
-
 	/* Enable tuning iff we have an SCC and a supported mode */
 	if (of_data && of_data->scc_offset &&
 	    (host->mmc->caps & MMC_CAP_UHS_SDR104 ||
@@ -1105,6 +1101,10 @@ int renesas_sdhi_probe(struct platform_device *pdev,
 		host->ops.hs400_complete = renesas_sdhi_hs400_complete;
 	}
 
+	ret = tmio_mmc_host_probe(host);
+	if (ret < 0)
+		goto edisclk;
+
 	num_irqs = platform_irq_count(pdev);
 	if (num_irqs < 0) {
 		ret = num_irqs;
-- 
2.40.1



