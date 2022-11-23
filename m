Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94B211C29
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:14:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE992C433D7;
	Wed, 23 Nov 2022 09:14:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669194868;
	bh=jjtMGiW/60n+4V6Eqyt3dhA3e10NO5t2LnXBVN95Mrs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EjWubO2QjGGkfPA9SzuNff2nAiIstilVhFOd6HF1gcu33r5i1iaFk/b/e9LOe+JiN
	 hotQrfKNXRNSvceuD+3q5DO+0PftRo93pNrylp2G+mBGbfH5XYMTaYRndQeuxO6OEC
	 qBIIOIyw85cIsOHZ6gkr+K72soOmRGIQcAkodYCQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marex@denx.de>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 082/156] spi: stm32: Print summary callbacks suppressed message
Date: Wed, 23 Nov 2022 09:50:39 +0100
Message-Id: <20221123084600.971866381@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084557.816085212@linuxfoundation.org>
References: <20221123084557.816085212@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Marek Vasut <marex@denx.de>

[ Upstream commit 195583504be28df5d608a4677dd796117aea875f ]

The original fix "spi: stm32: Rate-limit the 'Communication suspended' message"
still leads to "stm32h7_spi_irq_thread: 1696 callbacks suppressed" spew in the
kernel log. Since this 'Communication suspended' message is a debug print, add
RATELIMIT_MSG_ON_RELEASE flag to inhibit the "callbacks suspended" part during
normal operation and only print summary at the end.

Fixes: ea8be08cc9358 ("spi: stm32: Rate-limit the 'Communication suspended' message")
Signed-off-by: Marek Vasut <marex@denx.de>
Link: https://lore.kernel.org/r/20221018183513.206706-1-marex@denx.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-stm32.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/spi/spi-stm32.c b/drivers/spi/spi-stm32.c
index 9ae16092206d..a1961a973839 100644
--- a/drivers/spi/spi-stm32.c
+++ b/drivers/spi/spi-stm32.c
@@ -937,6 +937,7 @@ static irqreturn_t stm32h7_spi_irq_thread(int irq, void *dev_id)
 		static DEFINE_RATELIMIT_STATE(rs,
 					      DEFAULT_RATELIMIT_INTERVAL * 10,
 					      1);
+		ratelimit_set_flags(&rs, RATELIMIT_MSG_ON_RELEASE);
 		if (__ratelimit(&rs))
 			dev_dbg_ratelimited(spi->dev, "Communication suspended\n");
 		if (!spi->cur_usedma && (spi->rx_buf && (spi->rx_len > 0)))
-- 
2.35.1



