Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E17C3A2E00;
	Sat, 12 Sep 2026 20:03:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789243391; cv=none; b=STrLU4iTJ/qDkqs41i28qLWckjJ+CAGNhOQTRv516DWKH+WUKkdT261yRK9v+qhrcRHWqKTuQuNZHaAPupTIjOjafqc0tem3lU4ttIi/wNXnsBeuADiRl69Lt/wdyRLKHHDTRBaE+nddiiOQ4b0ZdPxKYL/HPmlldA5y0/BF1Zw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789243391; c=relaxed/simple;
	bh=Ge/+ksObRA3O3WVXknAJ9Rj/jdy/umWAt0xqk+YHVFE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PUAOusFY4+4HMcssC56/CMO8ZwWNKmwFW5S6nUNtD9CHIfiCTjfg7j/10W82UJx8fZSHxhf7Y5i4U8pnrUD1QRW9Ewfbfw8NTbGWHBDdJ01nA1MF3Rd6eOqiy05rUD82JMBAwx0Et0On6RnHYjTfbvRkfx1dtIVPoHWOPBvMK+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bgNVfBo+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bgNVfBo+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA4FC1F00893;
	Sat, 12 Sep 2026 20:03:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789243390;
	bh=syebur8G5+U820X12bkZdJVFHdPoEgaCqLB8nQh9Is8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bgNVfBo+BdPmV6pURZyt4V5zizT+ukmaIXBaZ0GvAy/zwH61d21mgDLX3WFLII/AI
	 2jEM+ogRXQN32MWGS8P+g64IQEYXg+CJ+rXvbAutrTmzTHxNpIteirsNEb2r9PO7TK
	 DWd6o3frFCTINI+ViaQgjzn8aECbByZNK0VIGh3E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yi Ding <yi.s.ding@gmail.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 737/798] rtc: pcf8563: fix clock provider leak on unbind
Date: Sat, 12 Sep 2026 09:06:05 +0200
Message-ID: <20260912065533.968117958@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yi Ding <yi.s.ding@gmail.com>

[ Upstream commit 9c48a53685040bb0de45a640b34055cbbfc69d4f ]

pcf8563_clkout_register_clk() registers the CLKOUT clock provider with
of_clk_add_provider(), but nothing ever unwinds it: there is no
of_clk_del_provider() call and the driver has no remove callback. Each
of_clk_add_provider() allocates a struct of_clk_provider, takes a
reference on the OF node and adds an entry to the global of_clk_providers
list, none of which is released when the device is unbound. Every
bind/unbind (or module reload) therefore leaks a provider structure and
an of_node reference.

The clock itself is already device-managed (devm_clk_register()); only
the provider registration was not. Use devm_of_clk_add_hw_provider() so
the provider is removed automatically on unbind. Tie it to the parent
i2c device, whose OF node carries the #clock-cells and clock-output-names
properties (the RTC class device has no OF node of its own).

Fixes: a39a6405d5f9 ("rtc: pcf8563: add CLKOUT to common clock framework")
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Yi Ding <yi.s.ding@gmail.com>
Link: https://patch.msgid.link/20260602035135.62264-1-yi.s.ding@gmail.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-pcf8563.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-pcf8563.c b/drivers/rtc/rtc-pcf8563.c
index 129bd2f517793..815aa3e8180a7 100644
--- a/drivers/rtc/rtc-pcf8563.c
+++ b/drivers/rtc/rtc-pcf8563.c
@@ -507,7 +507,9 @@ static struct clk *pcf8563_clkout_register_clk(struct pcf8563 *pcf8563)
 	clk = devm_clk_register(&client->dev, &pcf8563->clkout_hw);
 
 	if (!IS_ERR(clk))
-		of_clk_add_provider(node, of_clk_src_simple_get, clk);
+		devm_of_clk_add_hw_provider(pcf8563->rtc->dev.parent,
+					    of_clk_hw_simple_get,
+					    &pcf8563->clkout_hw);
 
 	return clk;
 }
-- 
2.53.0



