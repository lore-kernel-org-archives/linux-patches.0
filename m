Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79FA8263C90;
	Tue,  8 Apr 2025 11:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111831; cv=none; b=UXbFUxBYoQDA2kvoaKLun+uTV9hJU9hcAB0UnkoUDMyzvmqdaQ0laWoy6AeTOWHYWN8UkYyMgzRfQ7FMk/xz0boWrvORsA87E1vD99XJa5yqQ+cAo4ftNtMBxq7EcXXjWje03UXKSrgpZD/dAZTXRRZlpq0uDk6N7ssWrkskWvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111831; c=relaxed/simple;
	bh=pUaFfS5kGNLcISyTbT72MQvSbGm2xhYJSs8ripTlkIM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VD7TjWAVkfcFoxva5XGf8GVTjpj5xbXz/ePA0n8cruCkkJBeA7/kYK9CEJVhtjAmiYWJGWUGsU4VzNsuQ37HJSxX3ga2WQeSW6MSoKVKiUpjgw+O2r2KiOz02UjtIJUqH5iSCHjoPscMaAOXdwhsg/kFaOSayuPJhc3xEzV0EiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gWVZIMyJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gWVZIMyJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CABCC4CEE5;
	Tue,  8 Apr 2025 11:30:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111831;
	bh=pUaFfS5kGNLcISyTbT72MQvSbGm2xhYJSs8ripTlkIM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gWVZIMyJBH1SFnKYQiXTtKiu7PsfKo0UesEPNb7r5kK1OpELOWdMG+CVjyD/XwcMH
	 1JCfWc9PioQrKBmJxXWv8vRXNc0x0/GxoTSj8UVhC8qVtyTzyBcHg3c+7J25YUDz9s
	 rlyU2t3o6URspsPZx6BXEox0g4yhP8dvfabs6Zuw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 576/731] rtc: renesas-rtca3: Disable interrupts only if the RTC is enabled
Date: Tue,  8 Apr 2025 12:47:53 +0200
Message-ID: <20250408104927.673177278@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>

[ Upstream commit 27b2fcbd6b98204b0dce62e9aa9540ca0a2b70f1 ]

If the RTC is not enabled and the code attempts to disable the interrupt,
the readb_poll_timeout_atomic() function in the
rtca3_alarm_irq_set_helper() may timeout, leading to probe failures.
This issue is reproducible on some devices because the initial values of
the PIE and AIE bits in the RCR1 register are undefined.

To prevent probe failures in this scenario, disable RTC interrupts only
when the RTC is actually enabled.

Fixes: d4488377609e ("rtc: renesas-rtca3: Add driver for RTCA-3 available on Renesas RZ/G3S SoC")
Signed-off-by: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Link: https://lore.kernel.org/r/20250205095519.2031742-1-claudiu.beznea.uj@bp.renesas.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-renesas-rtca3.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/rtc/rtc-renesas-rtca3.c b/drivers/rtc/rtc-renesas-rtca3.c
index a056291d38876..ab816bdf0d776 100644
--- a/drivers/rtc/rtc-renesas-rtca3.c
+++ b/drivers/rtc/rtc-renesas-rtca3.c
@@ -586,17 +586,14 @@ static int rtca3_initial_setup(struct clk *clk, struct rtca3_priv *priv)
 	 */
 	usleep_range(sleep_us, sleep_us + 10);
 
-	/* Disable all interrupts. */
-	mask = RTCA3_RCR1_AIE | RTCA3_RCR1_CIE | RTCA3_RCR1_PIE;
-	ret = rtca3_alarm_irq_set_helper(priv, mask, 0);
-	if (ret)
-		return ret;
-
 	mask = RTCA3_RCR2_START | RTCA3_RCR2_HR24;
 	val = readb(priv->base + RTCA3_RCR2);
-	/* Nothing to do if already started in 24 hours and calendar count mode. */
-	if ((val & mask) == mask)
-		return 0;
+	/* Only disable the interrupts if already started in 24 hours and calendar count mode. */
+	if ((val & mask) == mask) {
+		/* Disable all interrupts. */
+		mask = RTCA3_RCR1_AIE | RTCA3_RCR1_CIE | RTCA3_RCR1_PIE;
+		return rtca3_alarm_irq_set_helper(priv, mask, 0);
+	}
 
 	/* Reconfigure the RTC in 24 hours and calendar count mode. */
 	mask = RTCA3_RCR2_START | RTCA3_RCR2_CNTMD;
-- 
2.39.5



