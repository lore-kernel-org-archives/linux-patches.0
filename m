Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79B116FA7
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:01:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1B3DC433C8;
	Sun, 17 Sep 2023 20:01:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694980906;
	bh=dkpVewVXS6Qb9OIanEXXPWMXyeatp6FD9zSNUyrmHOE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BsCWDE2tafldNAmGcmbbNA9Tf4BRmp0RYiHgtp0TwJMJKeQPq73sew/T37aSn+M+B
	 6klDwOvFp7in5RCXjj4SGRUDykEnDT0L+lqN6jFmeNuUEr/p2jzU7d6aAmGCOQ+BHg
	 /EoBx6Oewton3ynbwnan8yOFS3YWnt2erxFdJUVA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marco Felsch <m.felsch@pengutronix.de>,
	Abel Vesa <abel.vesa@linaro.org>,
	Adam Ford <aford173@gmail.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Ahmad Fatoum <a.fatoum@pengutronix.de>
Subject: [PATCH 6.1 042/219] clk: imx: pll14xx: align pdiv with reference manual
Date: Sun, 17 Sep 2023 21:12:49 +0200
Message-ID: <20230917191042.518140249@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191040.964416434@linuxfoundation.org>
References: <20230917191040.964416434@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Marco Felsch <m.felsch@pengutronix.de>

commit 37cfd5e457cbdcd030f378127ff2d62776f641e7 upstream.

The PLL14xx hardware can be found on i.MX8M{M,N,P} SoCs and always come
with a 6-bit pre-divider. Neither the reference manuals nor the
datasheets of these SoCs do mention any restrictions. Furthermore the
current code doesn't respect the restrictions from the comment too.

Therefore drop the restriction and align the max pre-divider (pdiv)
value to 63 to get more accurate frequencies.

Fixes: b09c68dc57c9 ("clk: imx: pll14xx: Support dynamic rates")
Cc: stable@vger.kernel.org
Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
Reviewed-by: Abel Vesa <abel.vesa@linaro.org>
Reviewed-by: Adam Ford <aford173@gmail.com>
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Acked-by: Sascha Hauer <s.hauer@pengutronix.de>
Tested-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
Link: https://lore.kernel.org/r/20230807084744.1184791-1-m.felsch@pengutronix.de
Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/imx/clk-pll14xx.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

--- a/drivers/clk/imx/clk-pll14xx.c
+++ b/drivers/clk/imx/clk-pll14xx.c
@@ -135,11 +135,10 @@ static void imx_pll14xx_calc_settings(st
 	/*
 	 * Fractional PLL constrains:
 	 *
-	 * a) 6MHz <= prate <= 25MHz
-	 * b) 1 <= p <= 63 (1 <= p <= 4 prate = 24MHz)
-	 * c) 64 <= m <= 1023
-	 * d) 0 <= s <= 6
-	 * e) -32768 <= k <= 32767
+	 * a) 1 <= p <= 63
+	 * b) 64 <= m <= 1023
+	 * c) 0 <= s <= 6
+	 * d) -32768 <= k <= 32767
 	 *
 	 * fvco = (m * 65536 + k) * prate / (p * 65536)
 	 */
@@ -182,7 +181,7 @@ static void imx_pll14xx_calc_settings(st
 	}
 
 	/* Finally calculate best values */
-	for (pdiv = 1; pdiv <= 7; pdiv++) {
+	for (pdiv = 1; pdiv <= 63; pdiv++) {
 		for (sdiv = 0; sdiv <= 6; sdiv++) {
 			/* calc mdiv = round(rate * pdiv * 2^sdiv) / prate) */
 			mdiv = DIV_ROUND_CLOSEST(rate * (pdiv << sdiv), prate);


