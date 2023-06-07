Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8390937325
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:48:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06019C433D2;
	Wed,  7 Jun 2023 20:48:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686170924;
	bh=RJQ0IbZ0oPaulOxZ9aeqSeG2KcvtBy2zygzzhIewGf4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ozcKS8j9ND70/a+PUadQK5MSgA+RO4gF6oyVE6yUnUWOhVWOkWjE6SWNG0Q3OsH0l
	 SdXBqAMhG4e1B7bnmcTWXhSVRtRn/wN+4XI7zmu3PfrhFK1MvMyiyXowNWm9I7lPen
	 rubInOMzC+bYriQC83dhyMOgPCdC8tIdzChv5X4A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 044/120] ASoC: dwc: limit the number of overrun messages
Date: Wed,  7 Jun 2023 22:16:00 +0200
Message-ID: <20230607200902.287682534@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200900.915613242@linuxfoundation.org>
References: <20230607200900.915613242@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Maxim Kochetkov <fido_max@inbox.ru>

[ Upstream commit ab6ecfbf40fccf74b6ec2ba7ed6dd2fc024c3af2 ]

On slow CPU (FPGA/QEMU emulated) printing overrun messages from
interrupt handler to uart console may leads to more overrun errors.
So use dev_err_ratelimited to limit the number of error messages.

Signed-off-by: Maxim Kochetkov <fido_max@inbox.ru
Link: https://lore.kernel.org/r/20230505062820.21840-1-fido_max@inbox.ru
Signed-off-by: Mark Brown <broonie@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/dwc/dwc-i2s.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/dwc/dwc-i2s.c b/sound/soc/dwc/dwc-i2s.c
index 36da0f01571a1..5469399abcb44 100644
--- a/sound/soc/dwc/dwc-i2s.c
+++ b/sound/soc/dwc/dwc-i2s.c
@@ -132,13 +132,13 @@ static irqreturn_t i2s_irq_handler(int irq, void *dev_id)
 
 		/* Error Handling: TX */
 		if (isr[i] & ISR_TXFO) {
-			dev_err(dev->dev, "TX overrun (ch_id=%d)\n", i);
+			dev_err_ratelimited(dev->dev, "TX overrun (ch_id=%d)\n", i);
 			irq_valid = true;
 		}
 
 		/* Error Handling: TX */
 		if (isr[i] & ISR_RXFO) {
-			dev_err(dev->dev, "RX overrun (ch_id=%d)\n", i);
+			dev_err_ratelimited(dev->dev, "RX overrun (ch_id=%d)\n", i);
 			irq_valid = true;
 		}
 	}
-- 
2.39.2



