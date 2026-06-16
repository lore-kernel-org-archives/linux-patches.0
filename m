Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4F4444103A;
	Tue, 16 Jun 2026 15:29:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781623758; cv=none; b=PhmBBhN/+sXCReoWVxnOZ/+XDTNLbs+KQz72RF3kHhu9y/WJosMKs6ypEiU29Fv0MUaW3cN/SUf3ZbmMDdHwWeO41+JW8/sSp/F0SEH48/x7A0Xregw2EMbq2esjLiO4flUJQmUq9821q65Ia+uhnvOanoZNXKHVSmbUSUMzTdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781623758; c=relaxed/simple;
	bh=GUpfUvO5LsQfv9EG0sIzDLdejwm+aXQ13+S6lOr6eDY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MNpgslzZ1ke7doXeP/vLi+lWGi5DggyxAdUJZ/jKMpeN8/qk/dv5GbHgnAyeA0QJ7GsVPxJAUiLQKLOwID/8c8iEGVmzEIt1CAxddW1mq7IU2w3a/uHIm8Bo6jLdZy6olbh/1JuB/aEoQ37Nd6sBAvMRouwlUAfiHJMtDxzpAsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JU9hSklI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JU9hSklI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56A501F000E9;
	Tue, 16 Jun 2026 15:29:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781623754;
	bh=MTdeduRDRurRS3WbxtbTRauqygahWluP9taFt8zOnVw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JU9hSklIJleEcjb6nj0+eRMyPtCqLMCEBZka2+LKuo0exLtEJzQR3pqA3QsKLsNsb
	 APeYal/GrhlVEwbgdneui4pSZ5A8tszcrD8d6R2X1gWMuE7KT1/chTy/vX9AdpGcPy
	 dFnWwsSGFAvY825TMMNQZnzkdTEPgL8g2Y0cwr7U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Judith Mendez <jm@ti.com>,
	Linus Walleij <linusw@kernel.org>
Subject: [PATCH 7.0 202/378] pinctrl: mcp23s08: Initialize mcp->dev and mcp->addr before regmap init
Date: Tue, 16 Jun 2026 20:27:13 +0530
Message-ID: <20260616145121.020553016@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Judith Mendez <jm@ti.com>

commit 8473c3a197b57ff01396f7a2ec6ddf65383820d4 upstream.

Regmap initialization triggers regcache_maple_populate() which attempts
SPI read to populate cache. SPI read requires mcp->dev and mcp->addr to
be set, without them, NULL pointer dereference occurs during probe.

Move initialization before mcp23s08_spi_regmap_init() call.

Cc: stable@vger.kernel.org
Fixes: f9f4fda15e72 ("pinctrl: mcp23s08: init reg_defaults from HW at probe and switch cache type")
Signed-off-by: Judith Mendez <jm@ti.com>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pinctrl/pinctrl-mcp23s08_spi.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/pinctrl/pinctrl-mcp23s08_spi.c
+++ b/drivers/pinctrl/pinctrl-mcp23s08_spi.c
@@ -10,6 +10,7 @@
 #include "pinctrl-mcp23s08.h"
 
 #define MCP_MAX_DEV_PER_CS	8
+#define MCP23S08_SPI_BASE	0x40
 
 /*
  * A given spi_device can represent up to eight mcp23sxx chips
@@ -173,6 +174,8 @@ static int mcp23s08_probe(struct spi_dev
 	for_each_set_bit(addr, &spi_present_mask, MCP_MAX_DEV_PER_CS) {
 		data->mcp[addr] = &data->chip[--chips];
 		data->mcp[addr]->irq = spi->irq;
+		data->mcp[addr]->dev = dev;
+		data->mcp[addr]->addr = MCP23S08_SPI_BASE | (addr << 1);
 
 		ret = mcp23s08_spi_regmap_init(data->mcp[addr], dev, addr, info);
 		if (ret)
@@ -184,7 +187,7 @@ static int mcp23s08_probe(struct spi_dev
 		if (!data->mcp[addr]->pinctrl_desc.name)
 			return -ENOMEM;
 
-		ret = mcp23s08_probe_one(data->mcp[addr], dev, 0x40 | (addr << 1),
+		ret = mcp23s08_probe_one(data->mcp[addr], dev, MCP23S08_SPI_BASE | (addr << 1),
 					 info->type, -1);
 		if (ret < 0)
 			return ret;


