Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 844B147CC80;
	Tue, 16 Jun 2026 17:41:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781631703; cv=none; b=BUqbsWy9gWLSKCJ3bTTnDqDM3YTyzQ/I4Ln+N0IYRk76UIWqDp7Fy3I28Jcv2QO1WxFa2x55+0Yqm0CFkK/jMHeCwR0ORlMdfsvcUFsA5796A4jXgTvM7b6nTE03/DUyFL1bNdzVjcqz7PkiZN1lZjIGUYfqIuYR2ILYN6Kr4hc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781631703; c=relaxed/simple;
	bh=JBd68w4Yvzmtt9WWMvAEST2HEPFXcBWBuRpMM9VtFhs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DAWfj1GIrBcZNEh3toVsTBVLq6mQr0Dvf2b/wxeeRcFAzkRy/QAj5KQAH7JFf3MAj/P148rLJViienlgWGdMPIGBrOwEUcCljrMsCaNKG8meCQOkU532X4T6PvUEmdjSWVgYADk6rcCXDKXQVQdBIUPpozFiquKC7hOTdoEj6Yk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JkdCvL+p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JkdCvL+p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 597991F000E9;
	Tue, 16 Jun 2026 17:41:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781631700;
	bh=qYs4tJaiyF70KYg9vlVl0Wc4u5uK89jodWro78mnl7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JkdCvL+pJYjjYXVP12cTjYYJi583DQCrnQdgpt0Ih2wCIkqtCtHGzFdJyz7AvJk+i
	 Xp9bw8R7uv3io13Nie+rQJ1KWho4kBu1Cp2F+JzCv0oMtBAMRYKR99aaCX7WgMHnQS
	 foFYoM1lVggm3bFV5JYq6OyB7krCrQf/xee2RpD8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Inochi Amaoto <inochiama@gmail.com>,
	Gabriel Somlo <gsomlo@gmail.com>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 6.1 270/522] mmc: litex_mmc: Use DIV_ROUND_UP for more accurate clock calculation
Date: Tue, 16 Jun 2026 20:26:57 +0530
Message-ID: <20260616145138.589392839@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


