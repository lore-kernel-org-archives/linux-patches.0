Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 867051A682B;
	Tue, 16 Jun 2026 15:27:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781623660; cv=none; b=B4D95jxbuVSfbfbW0Sl0TpaNOiGMixJ9+DSdQjLBzvRp0CJAsar94ZZkLR8RT4c6H+YYePW0Wfv/U0Tl/KrZDCffeP5dcMl4lK5SDL/y5sn869ZG6Gmu9fuqcHoQZ9mNdRg+cH1tMHIhuN4FSVB8dmEWiCTk1h7J9nbMsKlALo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781623660; c=relaxed/simple;
	bh=Wl0G0XKuXMk1MYTpsrXgqPWDptJcSjXetzCOIsfYuKo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=enqkFeQavuPmZOhrYEjgwiD16cJbbwnT+1/4oTzEkErKQk7gxiG2M0uCgZEe7PByn9yKW4PkDetqQDUDlBeWOMi/+BdRKnTaW5cPmoRZjehm+KykGiHbcTNACB8MWHEBcHCiVRz70RN+L8ZP13au2ahcb5P/tpUWiU76bLKO5u0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N/kivOQ3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N/kivOQ3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D6BC1F000E9;
	Tue, 16 Jun 2026 15:27:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781623659;
	bh=UnP5TFa4a5T5FgSdIPM+CQazdADuGZJPSnAuAzDRpN4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N/kivOQ3IpwDRaaFlYjdKnO1ISUpJZAB65YXjS0WZ6HZ6Vk00EdWVtLTSget1W7Wr
	 qLaKG8I3OjZC5K2kjFXW97D/7HlGNocQFW2FV0PyKcRbrO81WranpurJm/9wR7wJLx
	 oxkYGdhImSY/mv4ZgusCx3JsYK6r6tHc2ZA8CUzk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Inochi Amaoto <inochiama@gmail.com>,
	Gabriel Somlo <gsomlo@gmail.com>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 7.0 192/378] mmc: litex_mmc: Use DIV_ROUND_UP for more accurate clock calculation
Date: Tue, 16 Jun 2026 20:27:03 +0530
Message-ID: <20260616145120.484189456@linuxfoundation.org>
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


