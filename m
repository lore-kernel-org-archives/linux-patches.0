Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48486FBE8
	for <patches@lists.linux.dev>; Thu,  1 Jun 2023 13:28:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7F40C433EF;
	Thu,  1 Jun 2023 13:28:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685626108;
	bh=LClHBa7uMSl95ldE29wtjSpu3bmaXYOaiTkJ++CAUnA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ttf/ZYXj61QsgMVHMx8mVKmg0y+hy3Ij2nV+yt5f8RSFLdMxX6in9WUfOJCyG6Jo9
	 bXsctNxo0vJHoNG1XL4KQ0g/omkMDHofsoSOBg8BTWZxxLEPHKkqTThK7wpFpLf5kP
	 Xcgus/VHGoVVR6iIoE97PbZHb7G6vUVhefInweMs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudiu Beznea <claudiu.beznea@microchip.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 33/42] dmaengine: at_xdmac: restore the content of grws register
Date: Thu,  1 Jun 2023 14:21:42 +0100
Message-Id: <20230601131940.522389309@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230601131939.051934720@linuxfoundation.org>
References: <20230601131939.051934720@linuxfoundation.org>
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
index cb1374b161291..fc018b633822e 100644
--- a/drivers/dma/at_xdmac.c
+++ b/drivers/dma/at_xdmac.c
@@ -2064,6 +2064,15 @@ static int __maybe_unused atmel_xdmac_resume(struct device *dev)
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



