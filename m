Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED9ED15C83
	for <patches@lists.linux.dev>; Mon,  5 Dec 2022 19:27:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70718C433D6;
	Mon,  5 Dec 2022 19:27:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670268426;
	bh=t0sh537lY/tynIianXOW8nlBPLeTqnOdZGJftal9+jU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dg1PjV2TKKC1/I6ikTBlV5UTgqTccjQQp2PB5TgjJygH+y4Eq0mG7B5VRkZsfBUtX
	 Zs1MiduHmyqmVvYBrWix8uCzu5UohiJj0ex/0iYLuLdzj/BvJEZ52XJ/yodidbDjme
	 l2w3b2XG7EITFiTA2z58F2xSAktXKVb4GbDH5mfA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Falbesoner <sebastian.falbesoner@gmail.com>,
	Haibo Chen <haibo.chen@nxp.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.0 090/124] mmc: sdhci-esdhc-imx: correct CQHCI exit halt state check
Date: Mon,  5 Dec 2022 20:09:56 +0100
Message-Id: <20221205190810.972682049@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190808.422385173@linuxfoundation.org>
References: <20221205190808.422385173@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sebastian Falbesoner <sebastian.falbesoner@gmail.com>

commit a3cab1d2132474969871b5d7f915c5c0167b48b0 upstream.

With the current logic the "failed to exit halt state" error would be
shown even if any other bit than CQHCI_HALT was set in the CQHCI_CTL
register, since the right hand side is always true. Fix this by using
the correct operator (bit-wise instead of logical AND) to only check for
the halt bit flag, which was obviously intended here.

Fixes: 85236d2be844 ("mmc: sdhci-esdhc-imx: clear the HALT bit when enable CQE")
Signed-off-by: Sebastian Falbesoner <sebastian.falbesoner@gmail.com>
Acked-by: Haibo Chen <haibo.chen@nxp.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20221121105721.1903878-1-sebastian.falbesoner@gmail.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci-esdhc-imx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mmc/host/sdhci-esdhc-imx.c
+++ b/drivers/mmc/host/sdhci-esdhc-imx.c
@@ -1512,7 +1512,7 @@ static void esdhc_cqe_enable(struct mmc_
 	 * system resume back.
 	 */
 	cqhci_writel(cq_host, 0, CQHCI_CTL);
-	if (cqhci_readl(cq_host, CQHCI_CTL) && CQHCI_HALT)
+	if (cqhci_readl(cq_host, CQHCI_CTL) & CQHCI_HALT)
 		dev_err(mmc_dev(host->mmc),
 			"failed to exit halt state when enable CQE\n");
 


