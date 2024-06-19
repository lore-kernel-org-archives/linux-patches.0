Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 797E23C0B;
	Wed, 19 Jun 2024 13:30:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803834; cv=none; b=YytBn0KG/GKXSPNNkyJYf+eYaJN7cd5o7A2A88EJR7UjQhiibjXOFZnOvo2bM09mk7LdaOOn8TGA0kQZbJStcleq32xV2RnqYjbcBihAt29ZatvZOQxxGfYidA0Iol+qPKLiZlw7CzBbrUtp7OufIZwSVw5TMT4wYqvlCHQc+F8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803834; c=relaxed/simple;
	bh=Djk6zTyPC8juspa5rOQyxxkkYbvdWOB3s2PGYvc1AT0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N/jedGNcwo2SH6LlkmRFWzm2+/OlmSZmKGyM57Q1UrmgFHsMsBer7QTDLoZ6HcGCfL1PJ+LpK7V7jIvs9d8JilgMYPRwG/P/3qdWHlpTj13sruQQD2rXh5zS9SkGBzkj0FpH18rZVQNF8J9k8e22Rb9Hc9/MNA9PtiU08zAB2QM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ofkVlSjq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ofkVlSjq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A10B5C2BBFC;
	Wed, 19 Jun 2024 13:30:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803834;
	bh=Djk6zTyPC8juspa5rOQyxxkkYbvdWOB3s2PGYvc1AT0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ofkVlSjqMytpAvo136nlKeMVAeSLxIRL/FJogRoZfLUjvxRsdoF1B3a++vacddAsH
	 dhLsh7rbzeDAtUefte5clqexn1IC4PYiJKDcT7v3ecg/dQbOY+gjAc3IuD8fEzwQKP
	 KVUK1PWcr78D9EqiuqeB9Yn30BUOqcDwHkzAvvsQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Russell King <linux@armlinux.org.uk>,
	Samuel Holland <samuel.holland@sifive.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 119/217] clk: sifive: Do not register clkdevs for PRCI clocks
Date: Wed, 19 Jun 2024 14:56:02 +0200
Message-ID: <20240619125601.281924745@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125556.491243678@linuxfoundation.org>
References: <20240619125556.491243678@linuxfoundation.org>
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
index 916d2fc28b9c1..39bfbd120e0bc 100644
--- a/drivers/clk/sifive/sifive-prci.c
+++ b/drivers/clk/sifive/sifive-prci.c
@@ -4,7 +4,6 @@
  * Copyright (C) 2020 Zong Li
  */
 
-#include <linux/clkdev.h>
 #include <linux/delay.h>
 #include <linux/io.h>
 #include <linux/of_device.h>
@@ -536,13 +535,6 @@ static int __prci_register_clocks(struct device *dev, struct __prci_data *pd,
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



