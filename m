Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC9DFE54A
	for <patches@lists.linux.dev>; Thu,  1 Jun 2023 13:24:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 592A9C433D2;
	Thu,  1 Jun 2023 13:24:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685625850;
	bh=cgL6P8mK4oe27gSHKHnEjDlukWGS2CkKrCne481kdR4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KFQrW1XyVMo+9jhDGDw59VbdMUU6FjSCW7AgItkNlUu7RUYfn1Z0SOJuXKe6juex4
	 ADj6pfHaj/xIKqv9Klve8G+M7FOVq5DPNUmLkwPLAwFwjDpn+L8YC1Tla88jkOuuOu
	 OP/WvVCqkZKWK8dyhdfqsymx3vN9zEBiE/t24ShI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudiu Beznea <claudiu.beznea@microchip.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 18/42] dmaengine: at_xdmac: restore the content of grws register
Date: Thu,  1 Jun 2023 14:21:05 +0100
Message-Id: <20230601131937.546872629@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230601131936.699199833@linuxfoundation.org>
References: <20230601131936.699199833@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Claudiu Beznea <claudiu.beznea@microchip.com>

[ Upstream commit 7c5eb63d16b01c202aaa95f374ae15a807745a73 ]

In case the system suspends to a deep sleep state where power to DMA
controller is cut-off we need to restore the content of GRWS register.
This is a write only register and writing bit X tells the controller
to suspend read and write requests for channel X. Thus set GRWS before
restoring the content of GE (Global Enable) regiter.

Fixes: e1f7c9eee707 ("dmaengine: at_xdmac: creation of the atmel eXtended DMA Controller driver")
Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Link: https://lore.kernel.org/r/20230214151827.1050280-5-claudiu.beznea@microchip.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/at_xdmac.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/dma/at_xdmac.c b/drivers/dma/at_xdmac.c
index 4965961f55aa2..66bf570a8bd98 100644
--- a/drivers/dma/at_xdmac.c
+++ b/drivers/dma/at_xdmac.c
@@ -2063,6 +2063,15 @@ static int atmel_xdmac_resume(struct device *dev)
 		if (at_xdmac_chan_is_cyclic(atchan)) {
 			if (at_xdmac_chan_is_paused(atchan))
 				at_xdmac_device_resume_internal(atchan);
+
+			/*
+			 * We may resume from a deep sleep state where power
+			 * to DMA controller is cut-off. Thus, restore the
+			 * suspend state of channels set though dmaengine API.
+			 */
+			else if (at_xdmac_chan_is_paused(atchan))
+				at_xdmac_device_pause_set(atxdmac, atchan);
+
 			at_xdmac_chan_write(atchan, AT_XDMAC_CNDA, atchan->save_cnda);
 			at_xdmac_chan_write(atchan, AT_XDMAC_CNDC, atchan->save_cndc);
 			at_xdmac_chan_write(atchan, AT_XDMAC_CIE, atchan->save_cim);
-- 
2.39.2



