Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 491F747ACE6;
	Sat, 12 Sep 2026 13:14:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789218864; cv=none; b=n9kD2skQf22Qc8IpP/DrWZoLZA8flUi1Ik2OsCpXXaRMjReo49OTI9gP8iDIcpgmQtYsJP8/i7FDBi6Ua3wi6hbbLhPfIt93mU/wca7YP9L22C01G2B7Maypkvdj5rujVo0/R5pbpwa+wceoRnGsR/K5iHGtPbwxZvSh5VwrDX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789218864; c=relaxed/simple;
	bh=quPwfL92DMXUWlC6cvdhPEEoWmR4yx8VksUfw8pyq8A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hNKofYgXFNxy2ybsyZ26KPQjYtsnvmU/JBgNcdS75vkzmNgau7JA2PIQnKDCyM8gDGSAUdV1mRj+cnlpOe1qHE/6TbRXXLazJcnu+mklL2OnbTQlWTLC3QqwUm9sNPS/APt+v5O+qsi71QHnHLn3S9A7J7cjz6WjkX10WkrIE34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ey5NY104; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ey5NY104"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 110B41F000FF;
	Sat, 12 Sep 2026 13:14:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789218863;
	bh=Ro+CmN7MJq8QTgrkqblfUNMurYQBroTBf2T46ETLTBo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ey5NY104Q7SZGZWCj8OW+Bg0g5RwsYfxbhoZ86y9HtTcy+G6Enm5g7zlRkEGG8slq
	 ujSsB8KlbBCOey9wbvnTR/gzIludFna8Pnunbyaghb1v7TGvSirbnWoFYJi2demwZu
	 0oc75piire4UNdC/tfamxmQOM9M/rY343T6x2LFQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yi Ding <yi.s.ding@gmail.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1232/1376] rtc: pcf8563: fix clock provider leak on unbind
Date: Sat, 12 Sep 2026 09:00:58 +0200
Message-ID: <20260912065635.004330349@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 23b21b9089159..a3d81afff046d 100644
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



