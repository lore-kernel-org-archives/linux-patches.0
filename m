Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A533377A9F;
	Sat, 12 Sep 2026 16:49:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789231787; cv=none; b=awcJzW1N7gOsrWs/0/9uThDzIT+VjK0bBOEsn6nyf0Ja9DUUsU1KXgitIuT1Oq9Lvm7dX4sUZXo5Daz/53I/Fj8vQouLWQsurHYJKrWE+t7009Bpq+Bg69qQ1g5uw3P5o4dSepDFXAdHnKMIleduBnHsGuq1QmfxVBX9u3C8bNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789231787; c=relaxed/simple;
	bh=oQxgsOj6MciHIPitOE405+Rjub+QL4EoaD4HuhTvzMs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZwkIEQOdA851BNTtPMUj/TxAJXBjqqZJnTJGynpjYnjICTExC7SXJAUcz8whq6l1qLcWh88CWRiClS4jlReO+l8fB+IxsXw0cLzIEhzWQhrdgfPeel+Xynsy/vCMETERhDkPLaVn0iXKV/zf8pMIPiTDois/xwpDRzgtbl5jl30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EooiVfs8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EooiVfs8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C70F51F000FF;
	Sat, 12 Sep 2026 16:49:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789231786;
	bh=2/jPjS4OyFCUhKKRh3V7jNolqY5fl3BrTT15s+Zh2Do=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EooiVfs8FFMi13W+qurhvp+Oa71R2nfFQahz/IViCoTONO2H/GmH5I0ErlCAHsiDJ
	 zDJqo68fbRsnWeT/XW3sSNtjfVcdXnl6jewsXED/wEh/XEV28DiJDRys9SfFLEeOOd
	 I3eqNdd2yB6HWY0R4M6JNsYWh9WASpuTwdNMHOFE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yi Ding <yi.s.ding@gmail.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1071/1191] rtc: pcf8563: fix clock provider leak on unbind
Date: Sat, 12 Sep 2026 09:03:19 +0200
Message-ID: <20260912065612.228203507@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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
index dd27acae137cb..4a16334cbbd2d 100644
--- a/drivers/rtc/rtc-pcf8563.c
+++ b/drivers/rtc/rtc-pcf8563.c
@@ -494,7 +494,9 @@ static struct clk *pcf8563_clkout_register_clk(struct pcf8563 *pcf8563)
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



