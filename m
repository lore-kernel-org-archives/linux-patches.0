Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 523527BAF5;
	Mon,  8 Apr 2024 14:00:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584818; cv=none; b=g5E3CFUQihfmIKRuwEKxT+g88ywIf8lAdTUkfRaZC34UdUNLZoMdJNHBYBeqhAlIvIwUq5M9k6m11m92tT0BdwYNLVyeWRKVkp8aJrtTeUAQDAex0+woaGifjHViBiT2Q9/syR08Ue4Pelm/m4Jb8zHzYlVVF83vHo1Hng+rIlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584818; c=relaxed/simple;
	bh=s9c9LcLqKLKXM4Cpa3Wp3iVkP2Q5CJmz1bSaW76zqFA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kLIQICC0bF0T1SFuUItKdOQLfKab1HnAd82BoQnOnaiRTgO8EIkCmpWIr4CLQ+VgUb6eeAyArzueHEkOvR7ihvQIqCuYW0BWfE1K+HgvKxkSFeNh0x49WsRHqowcvYT3yM9R+wFve38p0xKfvZeNhwjUKEZ4Ypd0g+zGiCJDUJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bbt0Mu3y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bbt0Mu3y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC990C433F1;
	Mon,  8 Apr 2024 14:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584818;
	bh=s9c9LcLqKLKXM4Cpa3Wp3iVkP2Q5CJmz1bSaW76zqFA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bbt0Mu3yuqdIz/SqUe3u7s63ujyeMpsA6Z30C9uYwzEXUQI6YXgcESh0fW3ho4/be
	 QereHIRmhkirZpepcnNhqeSjgkOzG/adTEqw1krxQVgl2hTAJu12Wy1F0gwk2eAs9I
	 F9cUC/6isaHzEQVKWqyLTLlg9sxf1L9zjUOPWKYA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>,
	"GONG, Ruiqi" <gongruiqi1@huawei.com>,
	GONG
Subject: [PATCH 5.15 567/690] serial: sc16is7xx: convert from _raw_ to _noinc_ regmap functions for FIFO
Date: Mon,  8 Apr 2024 14:57:13 +0200
Message-ID: <20240408125420.164826371@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hugo Villeneuve <hvilleneuve@dimonoff.com>

commit dbf4ab821804df071c8b566d9813083125e6d97b upstream.

The SC16IS7XX IC supports a burst mode to access the FIFOs where the
initial register address is sent ($00), followed by all the FIFO data
without having to resend the register address each time. In this mode, the
IC doesn't increment the register address for each R/W byte.

The regmap_raw_read() and regmap_raw_write() are functions which can
perform IO over multiple registers. They are currently used to read/write
from/to the FIFO, and although they operate correctly in this burst mode on
the SPI bus, they would corrupt the regmap cache if it was not disabled
manually. The reason is that when the R/W size is more than 1 byte, these
functions assume that the register address is incremented and handle the
cache accordingly.

Convert FIFO R/W functions to use the regmap _noinc_ versions in order to
remove the manual cache control which was a workaround when using the
_raw_ versions. FIFO registers are properly declared as volatile so
cache will not be used/updated for FIFO accesses.

Fixes: dfeae619d781 ("serial: sc16is7xx")
Cc:  <stable@vger.kernel.org>
Signed-off-by: Hugo Villeneuve <hvilleneuve@dimonoff.com>
Link: https://lore.kernel.org/r/20231211171353.2901416-6-hugo@hugovil.com
Cc: Hugo Villeneuve <hvilleneuve@dimonoff.com>
Signed-off-by: GONG, Ruiqi <gongruiqi1@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/sc16is7xx.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/drivers/tty/serial/sc16is7xx.c
+++ b/drivers/tty/serial/sc16is7xx.c
@@ -376,9 +376,7 @@ static void sc16is7xx_fifo_read(struct u
 	const u8 line = sc16is7xx_line(port);
 	u8 addr = (SC16IS7XX_RHR_REG << SC16IS7XX_REG_SHIFT) | line;
 
-	regcache_cache_bypass(s->regmap, true);
-	regmap_raw_read(s->regmap, addr, s->buf, rxlen);
-	regcache_cache_bypass(s->regmap, false);
+	regmap_noinc_read(s->regmap, addr, s->buf, rxlen);
 }
 
 static void sc16is7xx_fifo_write(struct uart_port *port, u8 to_send)
@@ -394,9 +392,7 @@ static void sc16is7xx_fifo_write(struct
 	if (unlikely(!to_send))
 		return;
 
-	regcache_cache_bypass(s->regmap, true);
-	regmap_raw_write(s->regmap, addr, s->buf, to_send);
-	regcache_cache_bypass(s->regmap, false);
+	regmap_noinc_write(s->regmap, addr, s->buf, to_send);
 }
 
 static void sc16is7xx_port_update(struct uart_port *port, u8 reg,
@@ -489,6 +485,11 @@ static bool sc16is7xx_regmap_precious(st
 	return false;
 }
 
+static bool sc16is7xx_regmap_noinc(struct device *dev, unsigned int reg)
+{
+	return reg == SC16IS7XX_RHR_REG;
+}
+
 static int sc16is7xx_set_baud(struct uart_port *port, int baud)
 {
 	struct sc16is7xx_port *s = dev_get_drvdata(port->dev);
@@ -1439,6 +1440,8 @@ static struct regmap_config regcfg = {
 	.cache_type = REGCACHE_RBTREE,
 	.volatile_reg = sc16is7xx_regmap_volatile,
 	.precious_reg = sc16is7xx_regmap_precious,
+	.writeable_noinc_reg = sc16is7xx_regmap_noinc,
+	.readable_noinc_reg = sc16is7xx_regmap_noinc,
 };
 
 #ifdef CONFIG_SERIAL_SC16IS7XX_SPI


