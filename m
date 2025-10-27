Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD5B232ABCE;
	Mon, 27 Oct 2025 18:52:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591179; cv=none; b=lyzAOxC7LCCN/OM/DEfbjjae2j6mCFj39AjnJtt5hliSht5fCbSaHXVDJ8G164iJg+aR+hNCKD4ShjFXUMKRfGTcBpydnl/ng+PS4wrVMsYy91RxfgeRTIPhzytfh2M2CDvkcf751qOwpYpEOmhjG/pUuBUMFjQlz5LT3aNjFKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591179; c=relaxed/simple;
	bh=C0+2b4KAsMoG41W+DTZuQY6FRkwf9n8H/Qmcj8wlL4s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YpjsUG+F2qHzEGM/lDOTxlGG1mmNd7NyZwm6+xo+O3TUKR/TWLbX1CsSvct8SSyhFpsDIvyugTmLn2i8Zh84ibdMV0h5YEOzwmojCTQ6YaRiaTZ0X8e2v4z7NIgfotwoh9DCVxPmAU04FV0F0T34o+Z4p6vY7BD6q03WamwtZC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1lU9nfQq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1lU9nfQq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5040DC4CEF1;
	Mon, 27 Oct 2025 18:52:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591179;
	bh=C0+2b4KAsMoG41W+DTZuQY6FRkwf9n8H/Qmcj8wlL4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1lU9nfQqqYxoW2y8c+ipzQ6ouyojCuWDkBzk1nhKRtZ36EnssI6l7wwdCE+Oq8Pwy
	 v5JpL0v8wIRR4UJLRGCKbzQPjbiYAddzAXfQZ5K+pnV4vC/QKYcu1tjKp4w2LV9KsQ
	 7qgLe9bVN6w+ao43NuOZ2aa8VmPMWi1WFk3n0wds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhen Ni <zhen.ni@easystack.cn>,
	Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: [PATCH 5.10 097/332] clocksource/drivers/clps711x: Fix resource leaks in error paths
Date: Mon, 27 Oct 2025 19:32:30 +0100
Message-ID: <20251027183527.180470277@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

From: Zhen Ni <zhen.ni@easystack.cn>

commit cd32e596f02fc981674573402c1138f616df1728 upstream.

The current implementation of clps711x_timer_init() has multiple error
paths that directly return without releasing the base I/O memory mapped
via of_iomap(). Fix of_iomap leaks in error paths.

Fixes: 04410efbb6bc ("clocksource/drivers/clps711x: Convert init function to return error")
Fixes: 2a6a8e2d9004 ("clocksource/drivers/clps711x: Remove board support")
Signed-off-by: Zhen Ni <zhen.ni@easystack.cn>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20250814123324.1516495-1-zhen.ni@easystack.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clocksource/clps711x-timer.c |   23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

--- a/drivers/clocksource/clps711x-timer.c
+++ b/drivers/clocksource/clps711x-timer.c
@@ -78,24 +78,33 @@ static int __init clps711x_timer_init(st
 	unsigned int irq = irq_of_parse_and_map(np, 0);
 	struct clk *clock = of_clk_get(np, 0);
 	void __iomem *base = of_iomap(np, 0);
+	int ret = 0;
 
 	if (!base)
 		return -ENOMEM;
-	if (!irq)
-		return -EINVAL;
-	if (IS_ERR(clock))
-		return PTR_ERR(clock);
+	if (!irq) {
+		ret = -EINVAL;
+		goto unmap_io;
+	}
+	if (IS_ERR(clock)) {
+		ret = PTR_ERR(clock);
+		goto unmap_io;
+	}
 
 	switch (of_alias_get_id(np, "timer")) {
 	case CLPS711X_CLKSRC_CLOCKSOURCE:
 		clps711x_clksrc_init(clock, base);
 		break;
 	case CLPS711X_CLKSRC_CLOCKEVENT:
-		return _clps711x_clkevt_init(clock, base, irq);
+		ret =  _clps711x_clkevt_init(clock, base, irq);
+		break;
 	default:
-		return -EINVAL;
+		ret = -EINVAL;
+		break;
 	}
 
-	return 0;
+unmap_io:
+	iounmap(base);
+	return ret;
 }
 TIMER_OF_DECLARE(clps711x, "cirrus,ep7209-timer", clps711x_timer_init);


