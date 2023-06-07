Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 170E33922F
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:59:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C30CC433EF;
	Wed,  7 Jun 2023 20:59:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686171542;
	bh=442x6XFaqm87DzDkUkHzMtwIJS5bMTZ9ioKgIvjhuW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e9wJA+tUsxih2K6N440raWnxunD7uFFDkgb0sHkLS3k60rtyiFbsBNbF9avgEPQTU
	 S2+fML5y+Ar2aItDrLric3L4hWtFobFaM+mIapV/VHQFanU475IM5DpTty/9urNGEK
	 Pm+WSHs8MlnQta/xVEJ2iKgnG6fNhwcsJGjbcPHg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 058/159] ASoC: dwc: limit the number of overrun messages
Date: Wed,  7 Jun 2023 22:16:01 +0200
Message-ID: <20230607200905.586193509@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200903.652580797@linuxfoundation.org>
References: <20230607200903.652580797@linuxfoundation.org>
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
index 315ca5c4b057a..14ad8023fcdcb 100644
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



