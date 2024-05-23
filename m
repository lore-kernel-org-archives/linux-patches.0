Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D350014BF92;
	Thu, 23 May 2024 13:20:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470449; cv=none; b=okRDbfvAHkDn2qJ7CguWh9dfxExyfZzYqzychs+l/xPHNOY4wRbL0VPV1PrTqSqpL57PQDLHuT/o2MNrsU/gU25R31P18aqJx+PbhfEfb/BN1zDztY+ihf8Dh36J8oBf0RujgVvnM53o8ubqCLDuhMm0NVCuAeLot5p6AKwrO6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470449; c=relaxed/simple;
	bh=3jwbbUEGD/B1Dj3txcapKsEU1xqnstzG84Brqamzx+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oR/jtnqrfChRtOpZYLff/IJKB1Zs3Ws7LHy8C+EcVgNg9tSdvJrfh18c/bqNFMkeGDGWPspA2vIsFZ2I5MyPnGaFg6OYwoHM2rln7ijw3mt6OtMyuRHDCR5EUrLwepuvsRW9sDwOnfqAurmWvNr0vaQiqZtRHayLkuutrfGoEjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RgC87MvE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RgC87MvE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59D3EC2BD10;
	Thu, 23 May 2024 13:20:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470449;
	bh=3jwbbUEGD/B1Dj3txcapKsEU1xqnstzG84Brqamzx+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RgC87MvEYYK6cVb6um8O9/bHRZnvtBkUarKKQBn8JvDIN7GQIAtKibHOkUyOZA1mo
	 +u+cGJcTFo+RCP4u/TaHdrCvyimS6TSZkPWlW/QxRgBNK2d7MzZzhyAdd5laTm2AKF
	 o+vnZImgqoqxJRxOsP34yWas9SckogAUQqrvkMig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mengqi Zhang <mengqi.zhang@mediatek.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	=?UTF-8?q?Lin=20Gui=20 ?= <Lin.Gui@mediatek.com>
Subject: [PATCH 6.1 09/45] mmc: core: Add HS400 tuning in HS400es initialization
Date: Thu, 23 May 2024 15:13:00 +0200
Message-ID: <20240523130332.848516999@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130332.496202557@linuxfoundation.org>
References: <20240523130332.496202557@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mengqi Zhang <mengqi.zhang@mediatek.com>

commit 77e01b49e35f24ebd1659096d5fc5c3b75975545 upstream.

During the initialization to HS400es stage, add a HS400 tuning flow as an
optional process. For Mediatek IP, the HS400es mode requires a specific
tuning to ensure the correct HS400 timing setting.

Signed-off-by: Mengqi Zhang <mengqi.zhang@mediatek.com>
Link: https://lore.kernel.org/r/20231225093839.22931-2-mengqi.zhang@mediatek.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Cc: "Lin Gui (桂林)" <Lin.Gui@mediatek.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/core/mmc.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/mmc/core/mmc.c
+++ b/drivers/mmc/core/mmc.c
@@ -1819,8 +1819,13 @@ static int mmc_init_card(struct mmc_host
 
 		if (err)
 			goto free_card;
-
-	} else if (!mmc_card_hs400es(card)) {
+	} else if (mmc_card_hs400es(card)) {
+		if (host->ops->execute_hs400_tuning) {
+			err = host->ops->execute_hs400_tuning(host, card);
+			if (err)
+				goto free_card;
+		}
+	} else {
 		/* Select the desired bus width optionally */
 		err = mmc_select_bus_width(card);
 		if (err > 0 && mmc_card_hs(card)) {


