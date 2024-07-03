Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 401D413776F;
	Wed,  3 Jul 2024 11:17:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005449; cv=none; b=CvxD6id4lpsEA8Fxh1tBxHSQmrHNjIUMYmDF96uDbiliwCu0Kzverc0pX8+wuPDoxyIY1xFovEeWnXSh0C9sUMNShpcTRMuxxw68G0JBrSzqS16Bw8jC5VgoKv8pJIcxicjqAQLCi+s3j31tJiSbE3EsHm3Iyk7l24284vIBZ50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005449; c=relaxed/simple;
	bh=fCwr3lEevsBT3kdMhDRikrtpKriz4CQ0KHfXAKmorTY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fz6fRceyVfKQJu9rCw4yxEBcmvj7+YCDbQYYUIURDLZ131RXPGPCEY/5F+XGHwuxHFbl5yEBjHpSJTPOFj8dMrPJFMjIHvp6j4ST1SMPWrJ7P7PQce/EWEYZaD/i8cF2+y2xAzVErjY1TzjMHdpV8bG8JLGN4NqYtvUi+PmGpc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E90vYuek; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E90vYuek"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8DBAC2BD10;
	Wed,  3 Jul 2024 11:17:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005449;
	bh=fCwr3lEevsBT3kdMhDRikrtpKriz4CQ0KHfXAKmorTY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E90vYuekDbGH1o66rm7mq7tbI5/eGlbL+93HauziaVIrsfKjcFCqia3tvwSkykZHH
	 y5HAx/7z/xBN8r9bSFlmuOklvaxxtr+WiFbtwlLl4rbm5PNtH+HmLM5yb0CU60KCGR
	 ADMf5EdBp+lkAERcp1xmG/XgfzyBB5CnHGVWV6Cw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Russell King <linux@armlinux.org.uk>,
	Samuel Holland <samuel.holland@sifive.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 085/356] clk: sifive: Do not register clkdevs for PRCI clocks
Date: Wed,  3 Jul 2024 12:37:01 +0200
Message-ID: <20240703102916.319554571@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

From: Samuel Holland <samuel.holland@sifive.com>

[ Upstream commit 2607133196c35f31892ee199ce7ffa717bea4ad1 ]

These clkdevs were unnecessary, because systems using this driver always
look up clocks using the devicetree. And as Russell King points out[1],
since the provided device name was truncated, lookups via clkdev would
never match.

Recently, commit 8d532528ff6a ("clkdev: report over-sized strings when
creating clkdev entries") caused clkdev registration to fail due to the
truncation, and this now prevents the driver from probing. Fix the
driver by removing the clkdev registration.

Link: https://lore.kernel.org/linux-clk/ZkfYqj+OcAxd9O2t@shell.armlinux.org.uk/ [1]
Fixes: 30b8e27e3b58 ("clk: sifive: add a driver for the SiFive FU540 PRCI IP block")
Fixes: 8d532528ff6a ("clkdev: report over-sized strings when creating clkdev entries")
Reported-by: Guenter Roeck <linux@roeck-us.net>
Closes: https://lore.kernel.org/linux-clk/7eda7621-0dde-4153-89e4-172e4c095d01@roeck-us.net/
Suggested-by: Russell King <linux@armlinux.org.uk>
Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
Link: https://lore.kernel.org/r/20240528001432.1200403-1-samuel.holland@sifive.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/sifive/sifive-prci.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/clk/sifive/sifive-prci.c b/drivers/clk/sifive/sifive-prci.c
index 80a288c59e56d..8b573ff646f65 100644
--- a/drivers/clk/sifive/sifive-prci.c
+++ b/drivers/clk/sifive/sifive-prci.c
@@ -4,7 +4,6 @@
  * Copyright (C) 2020 Zong Li
  */
 
-#include <linux/clkdev.h>
 #include <linux/delay.h>
 #include <linux/io.h>
 #include <linux/of_device.h>
@@ -541,13 +540,6 @@ static int __prci_register_clocks(struct device *dev, struct __prci_data *pd,
 			return r;
 		}
 
-		r = clk_hw_register_clkdev(&pic->hw, pic->name, dev_name(dev));
-		if (r) {
-			dev_warn(dev, "Failed to register clkdev for %s: %d\n",
-				 init.name, r);
-			return r;
-		}
-
 		pd->hw_clks.hws[i] = &pic->hw;
 	}
 
-- 
2.43.0



