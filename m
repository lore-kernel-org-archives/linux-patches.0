Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCD9B4315F;
	Wed, 19 Jun 2024 13:16:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803004; cv=none; b=cwaj2UAL+HJktwKSWi/Nrh/YmJ5gQXgMh8UEAC3JD+pwllinAo7dxaJviJsEwohfM9oBBhuMjRUlBB1ncMeMX/GFa8cqVV3RNQ6INjt4W+NFhJ2Jwnpy2orwmVqZQEo814GbL/VHl7fQAMiVeHgkTokBdWGMbnRyI1quCe3YKV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803004; c=relaxed/simple;
	bh=7Z48nCJ9Sw2Ehfr0KWkCF0B+9cTDNFoLwoA4WKAD6p8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=plqbIbVJUBBDi/sWN1XHDSO1nirvcyNZNqZqdF2QwlfTbLzOKwtQG0AsUj5x8KJqZ7WjL55xXcimAHJl7pLchWYmSAvLQes0M3XjnzW//vCDN+zSvWbitgqtZQYTTMo92nI2UuMYKueU14d3WE47mQKIa6LlVm9YWoWwKQ68Kwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hQX8c4W0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hQX8c4W0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53C9BC2BBFC;
	Wed, 19 Jun 2024 13:16:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803004;
	bh=7Z48nCJ9Sw2Ehfr0KWkCF0B+9cTDNFoLwoA4WKAD6p8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hQX8c4W0t2FV+sh6uApPdHZroMkxNJbi1FCbIh+L+4Z2mQ1/PRVrdqtDL57bL0Gy+
	 Mje0FQBLwkYFBEJOLhS1ncj5mevbLwoqMLBMsUhUDOqC/GPpkFyWHDb+Fe5tSEdVDS
	 IFpAobT6e3CFtTJbWiqwlk0wORTmfFzWptDqj1kE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Russell King <linux@armlinux.org.uk>,
	Samuel Holland <samuel.holland@sifive.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 121/281] clk: sifive: Do not register clkdevs for PRCI clocks
Date: Wed, 19 Jun 2024 14:54:40 +0200
Message-ID: <20240619125614.501756683@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index 25b8e1a80ddce..b32a59fe55e74 100644
--- a/drivers/clk/sifive/sifive-prci.c
+++ b/drivers/clk/sifive/sifive-prci.c
@@ -4,7 +4,6 @@
  * Copyright (C) 2020 Zong Li
  */
 
-#include <linux/clkdev.h>
 #include <linux/delay.h>
 #include <linux/io.h>
 #include <linux/module.h>
@@ -537,13 +536,6 @@ static int __prci_register_clocks(struct device *dev, struct __prci_data *pd,
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



