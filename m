Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46B6715F31E;
	Mon, 29 Jan 2024 17:11:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548275; cv=none; b=V/7jqMnuJN86tDxYmtpDWEebDI5zb5c/hgdk1PiQtK2sCI9pks9ilTRFJJjnRA1mZSpFWqGrMy0D8stumJz3EVw4ngIMoTXhTgAECIVVWiIgrMfsqQKtAikSvGq8godOOVxd67gcnXsyPGZoeB4QvcfSNyhjAMHcMbDi6UdLQH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548275; c=relaxed/simple;
	bh=dKBcx8hoEyuvd+/QX7NcDhBbuPpyhYCT2dpMdPRFRXc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BXgavRdrfnNo7du3Wk1NsK0+MuMST0HMCo2047j88bs88onxo0I+bvAnS6MRoBcgekbIPXilO3aSIyq5ulAH6CNm6HM82jnSi9C2Qk/pqh5AoOXPAXbCmONF9RZWDbyyPJyMG46LIMqz5AFD7UZ/63dPRagsWOjisIbe4w1PMOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CXFv8SOj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CXFv8SOj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAFD9C433C7;
	Mon, 29 Jan 2024 17:11:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548274;
	bh=dKBcx8hoEyuvd+/QX7NcDhBbuPpyhYCT2dpMdPRFRXc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CXFv8SOjakdc4VgiS0ph9ckU14Vp+hJS23j19TsnxaNq18Bji/RIeewUHv60RlDmR
	 yTbYVQoM7f9qMv7RZIb+fgHKHhgbshnVxMFRZzZY9D3oKMOgiGQi3luWj13Loq5sa3
	 Srv1yZXNVcG6AULcx0T3Q1Dq+QWbl8/d2bl3UtVw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>
Subject: [PATCH 6.1 063/185] serial: sc16is7xx: convert from _raw_ to _noinc_ regmap functions for FIFO
Date: Mon, 29 Jan 2024 09:04:23 -0800
Message-ID: <20240129170000.626644562@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129165958.589924174@linuxfoundation.org>
References: <20240129165958.589924174@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/sc16is7xx.c |   17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

--- a/drivers/tty/serial/sc16is7xx.c
+++ b/drivers/tty/serial/sc16is7xx.c
@@ -383,9 +383,7 @@ static void sc16is7xx_fifo_read(struct u
 	struct sc16is7xx_port *s = dev_get_drvdata(port->dev);
 	struct sc16is7xx_one *one = to_sc16is7xx_one(port, port);
 
-	regcache_cache_bypass(one->regmap, true);
-	regmap_raw_read(one->regmap, SC16IS7XX_RHR_REG, s->buf, rxlen);
-	regcache_cache_bypass(one->regmap, false);
+	regmap_noinc_read(one->regmap, SC16IS7XX_RHR_REG, s->buf, rxlen);
 }
 
 static void sc16is7xx_fifo_write(struct uart_port *port, u8 to_send)
@@ -400,9 +398,7 @@ static void sc16is7xx_fifo_write(struct
 	if (unlikely(!to_send))
 		return;
 
-	regcache_cache_bypass(one->regmap, true);
-	regmap_raw_write(one->regmap, SC16IS7XX_THR_REG, s->buf, to_send);
-	regcache_cache_bypass(one->regmap, false);
+	regmap_noinc_write(one->regmap, SC16IS7XX_THR_REG, s->buf, to_send);
 }
 
 static void sc16is7xx_port_update(struct uart_port *port, u8 reg,
@@ -494,6 +490,11 @@ static bool sc16is7xx_regmap_precious(st
 	return false;
 }
 
+static bool sc16is7xx_regmap_noinc(struct device *dev, unsigned int reg)
+{
+	return reg == SC16IS7XX_RHR_REG;
+}
+
 static int sc16is7xx_set_baud(struct uart_port *port, int baud)
 {
 	struct sc16is7xx_one *one = to_sc16is7xx_one(port, port);
@@ -1699,6 +1700,10 @@ static struct regmap_config regcfg = {
 	.cache_type = REGCACHE_RBTREE,
 	.volatile_reg = sc16is7xx_regmap_volatile,
 	.precious_reg = sc16is7xx_regmap_precious,
+	.writeable_noinc_reg = sc16is7xx_regmap_noinc,
+	.readable_noinc_reg = sc16is7xx_regmap_noinc,
+	.max_raw_read = SC16IS7XX_FIFO_SIZE,
+	.max_raw_write = SC16IS7XX_FIFO_SIZE,
 	.max_register = SC16IS7XX_EFCR_REG,
 };
 


