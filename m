Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A41A6FC9
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 19:45:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81255C433C8;
	Sun, 17 Sep 2023 19:45:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694979918;
	bh=S9SVBmdwFvEBCnoh7dU4+LOSzYNYT8aH33Kf5gF9uuU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DabyCZbYKdf61XFO7Six16To2ztJFRzV5gPXUMlUMlu3nzlk6uUP/s59m90VaMGQw
	 NxS+NVhifcMuTF9mps53sNfp++vHZNIqHkQCU/DcZeeSA8VN5qlTkPlF1nV87LG/0G
	 ka6pesA1LDU48ovuiAJKwi3bXFMnp6V8k/8BXWwM=
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
Subject: [PATCH 6.5 045/285] clk: imx: pll14xx: align pdiv with reference manual
Date: Sun, 17 Sep 2023 21:10:45 +0200
Message-ID: <20230917191053.234397493@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191051.639202302@linuxfoundation.org>
References: <20230917191051.639202302@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

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
@@ -137,11 +137,10 @@ static void imx_pll14xx_calc_settings(st
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
@@ -184,7 +183,7 @@ static void imx_pll14xx_calc_settings(st
 	}
 
 	/* Finally calculate best values */
-	for (pdiv = 1; pdiv <= 7; pdiv++) {
+	for (pdiv = 1; pdiv <= 63; pdiv++) {
 		for (sdiv = 0; sdiv <= 6; sdiv++) {
 			/* calc mdiv = round(rate * pdiv * 2^sdiv) / prate) */
 			mdiv = DIV_ROUND_CLOSEST(rate * (pdiv << sdiv), prate);


