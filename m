Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A13C0376A19;
	Tue, 16 Jun 2026 17:05:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781629553; cv=none; b=l3nw7zrQDUF+SaquJJaI3UWr3NgTHmcSwSqQcZnp+YVx2XNrJP9vTX3o9/Q5aMpfU+ykJmm1BsemtiD2VnV55+puzKrz7nc4iTsmrUYcw8GB7uhkkau3oGIfv/pGqmXLWverAhdMEl/+RalZgFpvj5911z15/hQueJ5IsQZiQBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781629553; c=relaxed/simple;
	bh=1VYVNRbmVceGgpE8+NscvQnLCzs3jFlUVYfIxWuiAUU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EyHBD6FLIbIbTctzqsej7egp4ZJmTo9V7SqiZU3U1ENX+9qKtE5sm0FZBp1FHYDUxSxo0SpdrZ1k3FuQPIzs4Y+9VfLJe5JtbMCdcBG78ZRn2nV1/vYM6JsNRovRA1htOo+g+0VJaIuPLEZmWS3Px6oEI6V8AHzWMCBeTTmihjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IZJr305H; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IZJr305H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACA041F000E9;
	Tue, 16 Jun 2026 17:05:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781629552;
	bh=1IbOppDXXFQBgxGiDRFxdjfqGLyvh5j+fkLmPqDeFxQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IZJr305H6yZXoE0aUDW6dH4bmASickFE7K30uQE0SnEr/ot3KEtlIGV/rukwyN13D
	 /4uCI42bP37cm5tT+1LX8MJjzj0jFpi8ua2jPmB0UVbLUVcq/QmB9ocLpr9k1UMISs
	 zvTTLhNsyl2apK/99J2Z2cFRnE7HWsScZG9N+G1Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Inochi Amaoto <inochiama@gmail.com>,
	Gabriel Somlo <gsomlo@gmail.com>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 6.6 295/452] mmc: litex_mmc: Use DIV_ROUND_UP for more accurate clock calculation
Date: Tue, 16 Jun 2026 20:28:42 +0530
Message-ID: <20260616145133.034136235@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Inochi Amaoto <inochiama@gmail.com>

commit b837e38c255dd9f8b53511d52e87f1fda32b3dfe upstream.

The previous clock uses roundup_pow_of_two() to calculate the core
clock frequency. It does not meet the actual hardware meaning.
The actual frequency is calculated by "ref_clk / ((div >> 1) << 1)".

Fix the clock divider calculation.

Fixes: 92e099104729 ("mmc: Add driver for LiteX's LiteSDCard interface")
Signed-off-by: Inochi Amaoto <inochiama@gmail.com>
Reviewed-by: Gabriel Somlo <gsomlo@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/litex_mmc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/mmc/host/litex_mmc.c
+++ b/drivers/mmc/host/litex_mmc.c
@@ -16,6 +16,7 @@
 #include <linux/interrupt.h>
 #include <linux/iopoll.h>
 #include <linux/litex.h>
+#include <linux/math.h>
 #include <linux/mod_devicetable.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
@@ -436,11 +437,10 @@ static void litex_mmc_setclk(struct lite
 	struct device *dev = mmc_dev(host->mmc);
 	u32 div;
 
-	div = freq ? host->ref_clk / freq : 256U;
-	div = roundup_pow_of_two(div);
+	div = freq ? DIV_ROUND_UP(host->ref_clk, freq) : 256U;
 	div = clamp(div, 2U, 256U);
 	dev_dbg(dev, "sd_clk_freq=%d: set to %d via div=%d\n",
-		freq, host->ref_clk / div, div);
+		freq, host->ref_clk / ((div + 1) & ~1U), div);
 	litex_write16(host->sdphy + LITEX_PHY_CLOCKERDIV, div);
 	host->sd_clk = freq;
 }


