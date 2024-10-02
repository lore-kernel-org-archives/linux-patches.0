Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB11F1D04A2;
	Wed,  2 Oct 2024 13:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877575; cv=none; b=gcbYpMXG9Tz9bQP7hMTYlYT2oqQKDIWOdGb5fRyOyLwFP7HXjPo8/B9vFw2IUwoKOxiqhq1EoXqitWCkk5V5KcqTpgK/cjF3KU1/0dCaXxFTAt7bytiGsHLQhToDbMY5c9SHPQ72Y5bg0IDw6/GXAeorg1HZv7rrxrLjehFU2f8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877575; c=relaxed/simple;
	bh=q0wryMUUpBx8JTWldiFbHmk2rEUx5tRZpcrtjcO+ucw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XyQ76IP2AaPLIB/JfnrNp2oJvL15zISxl1BsDArzErU4u8B5oyk3flqwTGm/5dIajJssKY89V2VFhiAvhewGD4LZeZpT6TYOBtSnyKCGJdQxdFDZndIkMXwbEddGR4vFroqbeuBp+vNLFjlPm1bfdZXzpk63VM8cDN3CsN0APvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LCCeWKDJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LCCeWKDJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC8EEC4CEC2;
	Wed,  2 Oct 2024 13:59:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877575;
	bh=q0wryMUUpBx8JTWldiFbHmk2rEUx5tRZpcrtjcO+ucw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LCCeWKDJQyPMTA5Ct1eFjIr1dgiHYBGBUF22yQwfR0bqPvp3bx6OdXsmul6Qe3VFk
	 F/yYhji+PHmBWwuUq6F9q1RxvqK7zsBQ0Xg7FHGxTLuZrPd4ZSI0LFieEgWD0VfAg3
	 G/5/QogYfWBuQ4yfmThYTMYvn4bmStbvYQkbfIk8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 121/634] spi: ppc4xx: Avoid returning 0 when failed to parse and map IRQ
Date: Wed,  2 Oct 2024 14:53:41 +0200
Message-ID: <20241002125815.889111755@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 7781f1d120fec8624fc654eda900fc8748262082 ]

0 is incorrect error code when failed to parse and map IRQ.
Replace OF specific old API for IRQ retrieval with a generic
one to fix this issue.

Fixes: 0f245463b01e ("spi: ppc4xx: handle irq_of_parse_and_map() errors")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://patch.msgid.link/20240814144525.2648450-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-ppc4xx.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/spi/spi-ppc4xx.c b/drivers/spi/spi-ppc4xx.c
index 01fdecbf132d6..8f6309f32de0b 100644
--- a/drivers/spi/spi-ppc4xx.c
+++ b/drivers/spi/spi-ppc4xx.c
@@ -27,7 +27,6 @@
 #include <linux/wait.h>
 #include <linux/platform_device.h>
 #include <linux/of_address.h>
-#include <linux/of_irq.h>
 #include <linux/of_platform.h>
 #include <linux/interrupt.h>
 #include <linux/delay.h>
@@ -412,9 +411,10 @@ static int spi_ppc4xx_of_probe(struct platform_device *op)
 	}
 
 	/* Request IRQ */
-	hw->irqnum = irq_of_parse_and_map(np, 0);
-	if (hw->irqnum <= 0)
+	ret = platform_get_irq(op, 0);
+	if (ret < 0)
 		goto free_host;
+	hw->irqnum = ret;
 
 	ret = request_irq(hw->irqnum, spi_ppc4xx_int,
 			  0, "spi_ppc4xx_of", (void *)hw);
-- 
2.43.0



