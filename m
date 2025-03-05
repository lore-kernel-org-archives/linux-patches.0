Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D354F2505A7;
	Wed,  5 Mar 2025 17:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197224; cv=none; b=W2VsHY87r3Um46FQ5cMwfLNw8+wVHt2Hq/MHHbshJncqZsbqiFV5ufC1tLMAPfeqehHsgG/T4r31XVSLjMA588ffcM+LpLL54y1KZ1LNNK8rBiQkHgEXhkwjlyr+z4x1/SIjXttat9CRIPruoxfLjikWBU1YAd5ZlD92C5D89us=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197224; c=relaxed/simple;
	bh=hSv76j594lHsYn3PLaR/yf0gQLzxItxV8XmJCF8rkoQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xlyel7Txh43yWb/wWJJloakwLNXqtMp9kQz0eMwYA/4HpTEAR1h/zDT8gkQ/JApOvf+pRzS5UlY1Qvnt9v40wEipV9U2Z/5eqE0VLfFrQRwYakAvq1sZrl0YqiwvgEoTS77uM0jaS5pAJKm4jfeZ29Yj4AYB0pnSFJbAwNVITgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m8zyeBsB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m8zyeBsB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58B12C4CED1;
	Wed,  5 Mar 2025 17:53:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197224;
	bh=hSv76j594lHsYn3PLaR/yf0gQLzxItxV8XmJCF8rkoQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m8zyeBsBh+zzKuJWDG+XZR4rSm/VrO2T8gQmoLw5QE4kN4yMiqtv+1V5vEsemBmIa
	 JGG2f24/+AHlkIPdetO8qkxzZ68OpUYwWMKqkMXa5hpLVKEt5i3GFbhdMm0k0u3dvb
	 1zgOwpby4pBYIdGa+ZRNB7KVY1NvBh3ssyHzZ0bU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niravkumar L Rabara <niravkumar.l.rabara@intel.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.1 083/176] mtd: rawnand: cadence: fix error code in cadence_nand_init()
Date: Wed,  5 Mar 2025 18:47:32 +0100
Message-ID: <20250305174508.797560793@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.437358097@linuxfoundation.org>
References: <20250305174505.437358097@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niravkumar L Rabara <niravkumar.l.rabara@intel.com>

commit 2b9df00cded911e2ca2cfae5c45082166b24f8aa upstream.

Replace dma_request_channel() with dma_request_chan_by_mask() and use
helper functions to return proper error code instead of fixed -EBUSY.

Fixes: ec4ba01e894d ("mtd: rawnand: Add new Cadence NAND driver to MTD subsystem")
Cc: stable@vger.kernel.org
Signed-off-by: Niravkumar L Rabara <niravkumar.l.rabara@intel.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/raw/cadence-nand-controller.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/drivers/mtd/nand/raw/cadence-nand-controller.c
+++ b/drivers/mtd/nand/raw/cadence-nand-controller.c
@@ -2863,11 +2863,10 @@ static int cadence_nand_init(struct cdns
 	dma_cap_set(DMA_MEMCPY, mask);
 
 	if (cdns_ctrl->caps1->has_dma) {
-		cdns_ctrl->dmac = dma_request_channel(mask, NULL, NULL);
-		if (!cdns_ctrl->dmac) {
-			dev_err(cdns_ctrl->dev,
-				"Unable to get a DMA channel\n");
-			ret = -EBUSY;
+		cdns_ctrl->dmac = dma_request_chan_by_mask(&mask);
+		if (IS_ERR(cdns_ctrl->dmac)) {
+			ret = dev_err_probe(cdns_ctrl->dev, PTR_ERR(cdns_ctrl->dmac),
+					    "%d: Failed to get a DMA channel\n", ret);
 			goto disable_irq;
 		}
 	}


