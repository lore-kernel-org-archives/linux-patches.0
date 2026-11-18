Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040948;
	b=vJ1HR7LXq03JLPehT6xD53h8b2vO7+kC1r8TW//sXwncuorXKwiTxfWofhGf+jMDVbL/
	 rmZ+hrj1BX04nyYnyOibukrXUmQiu/zt0EkxTT3qVT9py1SGMHv7VwNzo1RqXaTAKPwIU
	 PIPlHSdQopYYzgHXXLW+0+2LhFMbxotXQ63nJA5kCF1zcVtsHsvlF1kNZ71W6ovahbUMt
	 EQe/puMP1oQ9+JdTlvb6hZwZHTM6pYJfMaeiHjsOXwCyiQo47Tn6sAfSi/UzrAHGvzflP
	 ZYG0CSpyGBjsUt6jg875H3xdlAMWZ6ufDgbbpjhEJeBqV98elPkng6FSQNrUZ2J7HFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040948;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=g/oDZIicukAHpCy12OQhhHMWG0/AQZ+gOhBQWo6eGDE=;
	b=s3b2AVy8fv4T88f7VaqFQbJhjd1K+t4LxdWIZ020qIt68d8h9f/d01znPHw7fMJ3rJ6t
	 UifBUZXes6nlhA2rD6naDMoWWeKwmOMbA/BqydIO+tdiC1KeiYL+1daV0XXPjheJwghLI
	 yEkovf7O0oWqs5q/om9kCTgiJMYUYNC6UysaiVxknf9fdU1wJe6SewCDOVabEjA86yto0
	 T6tg9GPDMAk4265a8MltUGaJi+YbxfSKasdkNuwMcifoH5U94KSBfW8AR9GknChL4ag/4
	 OVBPI+6ZL0Ean941ypOcUYmjWc7h+QRv1iD79kd7x9i9yAUJhqRs2T5p6H3qtYgCe5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gQzPoafX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10B5B606A31C;
	Wed, 18 Nov 2026 22:29:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gQzPoafX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E3861F000C4;
	Wed, 18 Nov 2026 22:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040947;
	bh=g/oDZIicukAHpCy12OQhhHMWG0/AQZ+gOhBQWo6eGDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gQzPoafXydHRjOXPCrm49cVlpBVlLudcpWqe9PTNe+2s8Ta9VfZhKRvJipro5Snum
	 q97d3NY1x2V+o27OgOF5LkuJP+apK5nW18m73qNwP8tbWNmMBPscGsLCl4n7twBQXf
	 xKYUA7lMJs8UdbAtzQc2ZNius0N8VcoP5Siu2l6U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Jonas Rebmann <jre@pengutronix.de>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2639/3318] spi: spi-sun4i: sun4i_spi_transfer_one(): fix setting of clock rate
Date: Wed, 18 Nov 2026 15:54:21 +0100
Message-ID: <20261118150440.245293878@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Kleine-Budde <mkl@pengutronix.de>

[ Upstream commit 672ba6d88324f223634dd2dc4098f6fb6b346b25 ]

A SPI transfer defines the _maximum_ speed of the SPI transfer. However
the driver doesn't take into account that the clock divider is always
rounded down (due to integer arithmetic). This results in a too high
clock rate for the SPI transfer.

E.g.: with an mclk_rate of 24 MHz and an SPI transfer speed of 10 MHz,
the original code calculates a reg of "0", which results in an effective
divider of "2" and a 12 MHz clock for the SPI transfer.

Use DIV_ROUND_UP() instead of a plain integer division to fix the
problem.

While there simplify the divider calculation for the CDR1 case, use
order_base_2() instead of two ilog2() calculations.

Fixes: b5f6517948cc ("spi: sunxi: Add Allwinner A10 SPI controller driver")
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Jonas Rebmann <jre@pengutronix.de>
Link: https://patch.msgid.link/20260914-spi-sun4i-fixes-v3-3-9fe919d5cecf@pengutronix.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-sun4i.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/spi/spi-sun4i.c b/drivers/spi/spi-sun4i.c
index 9b21d3b945b35..59e8a82cd8b64 100644
--- a/drivers/spi/spi-sun4i.c
+++ b/drivers/spi/spi-sun4i.c
@@ -212,7 +212,7 @@ static int sun4i_spi_transfer_one(struct spi_controller *host,
 				  struct spi_transfer *tfr)
 {
 	struct sun4i_spi *sspi = spi_controller_get_devdata(host);
-	unsigned int mclk_rate, div;
+	unsigned int mclk_rate, div, div_cdr1, div_cdr2;
 	unsigned long time_left;
 	unsigned int start, end, tx_time;
 	unsigned int tx_len = 0;
@@ -296,15 +296,13 @@ static int sun4i_spi_transfer_one(struct spi_controller *host,
 	 * First try CDR2, and if we can't reach the expected
 	 * frequency, fall back to CDR1.
 	 */
-	div = mclk_rate / (2 * tfr->speed_hz);
-	if (div <= (SUN4I_CLK_CTL_CDR2_MASK + 1)) {
-		if (div > 0)
-			div--;
-
-		reg = SUN4I_CLK_CTL_CDR2(div) | SUN4I_CLK_CTL_DRS;
+	div_cdr1 = DIV_ROUND_UP(mclk_rate, tfr->speed_hz);
+	div_cdr2 = DIV_ROUND_UP(div_cdr1, 2);
+	if (div_cdr2 <= (SUN4I_CLK_CTL_CDR2_MASK + 1)) {
+		reg = SUN4I_CLK_CTL_CDR2(div_cdr2 - 1) | SUN4I_CLK_CTL_DRS;
 	} else {
-		div = ilog2(mclk_rate) - ilog2(tfr->speed_hz);
-		reg = SUN4I_CLK_CTL_CDR1(div);
+		div = min(SUN4I_CLK_CTL_CDR1_MASK + 1, order_base_2(div_cdr1));
+		reg = SUN4I_CLK_CTL_CDR1(div - 1);
 	}
 
 	sun4i_spi_write(sspi, SUN4I_CLK_CTL_REG, reg);
-- 
2.53.0



