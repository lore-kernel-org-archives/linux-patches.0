Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A031BA48
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:15:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F87DC4339E;
	Tue,  7 Mar 2023 18:15:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678212902;
	bh=ZEsx3hybzgMn0/X7Oo4PMhsjxp+KlFZ7CejCUZaKrXc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2LgBl+SNmcfc3P08ctLpRtRFG6U0jr1oR3tKAOcDDuwBTm9E+cy9M2iyPxFPxhoFN
	 l9aWtnhyBc1Pp6T6CXWUvYL7P+Ez8UP/HWE3Ydrw0O8wCpiZqU1+izZmatAPPJU6nN
	 o221unp098lG6khk9Hz04JRm5F7hO6qr7Gw2D8Uk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudiu Beznea <claudiu.beznea@microchip.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 334/885] ASoC: mchp-spdifrx: fix return value in case completion times out
Date: Tue,  7 Mar 2023 17:54:28 +0100
Message-Id: <20230307170016.712938304@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
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

[ Upstream commit a4c4161d6eae3ef5f486d1638ef452d9bc1376b0 ]

wait_for_completion_interruptible_timeout() returns 0 in case of
timeout. Check this into account when returning from function.

Fixes: ef265c55c1ac ("ASoC: mchp-spdifrx: add driver for SPDIF RX")
Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Link: https://lore.kernel.org/r/20230130120647.638049-3-claudiu.beznea@microchip.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/atmel/mchp-spdifrx.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/sound/soc/atmel/mchp-spdifrx.c b/sound/soc/atmel/mchp-spdifrx.c
index 2d86e0ec930fa..7f359371b31bf 100644
--- a/sound/soc/atmel/mchp-spdifrx.c
+++ b/sound/soc/atmel/mchp-spdifrx.c
@@ -524,9 +524,10 @@ static int mchp_spdifrx_cs_get(struct mchp_spdifrx_dev *dev,
 	ret = wait_for_completion_interruptible_timeout(&ch_stat->done,
 							msecs_to_jiffies(100));
 	/* IP might not be started or valid stream might not be present */
-	if (ret < 0) {
+	if (ret <= 0) {
 		dev_dbg(dev->dev, "channel status for channel %d timeout\n",
 			channel);
+		return ret ? : -ETIMEDOUT;
 	}
 
 	memcpy(uvalue->value.iec958.status, ch_stat->data,
@@ -580,7 +581,7 @@ static int mchp_spdifrx_subcode_ch_get(struct mchp_spdifrx_dev *dev,
 		dev_dbg(dev->dev, "user data for channel %d timeout\n",
 			channel);
 		mchp_spdifrx_isr_blockend_dis(dev);
-		return ret;
+		return ret ? : -ETIMEDOUT;
 	}
 
 	spin_lock_irqsave(&user_data->lock, flags);
-- 
2.39.2



