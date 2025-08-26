Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82B85350D4E;
	Tue, 26 Aug 2025 13:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216389; cv=none; b=Dp0Pe7XHOp9teAk0AlOh3QJeiAdYi8tw/b0F4XpBdBqZekNnrUHDtHjwgfuUNwtGzicWuLBpa0zV6h7+rPVXYnS8u4ezbz3BUi6nIYpMPLeermzU/7cbnwp2ZERLX4V7Vvaiy6/UyAvPkBZkoK+43B/erf1bi1lWhVBgM6e8CwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216389; c=relaxed/simple;
	bh=F+u1btq8G2I7jLH6T7jVUUtROoX4IT5WEisffTnTaf8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V5UdmSC2HE7WTdf9QyzdZpjRYigFyWD2N4t2n1u0t5b5AdqXxobs4UOPRo1rPxSEO7n8unClePzwFf75eXs/NhmhMuSfdoXcqUiEHgnEsaSWPF6Esl4lE+WOiwmO3Zc/jQw79x+gthC2DDPbsgOMHlmga0u0qVnfSlZaFrQ2lf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jrq3vl3W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jrq3vl3W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF220C4CEF1;
	Tue, 26 Aug 2025 13:53:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216389;
	bh=F+u1btq8G2I7jLH6T7jVUUtROoX4IT5WEisffTnTaf8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jrq3vl3Wef5hTfKLh3F1kzOlPAYUsdyTLlDIQoDm1b0l4KBpUXPdE7zy4KbW0yhn1
	 52tCd4U5q7mMDV2k43fVJc3xC+aLpBOVCsUudNSkAAX4rxmaHaPMjkyR+m05IEU9I9
	 YM46TeeoAQyRqWxutgmJbSF47jIRuL5H6j1tG5w8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ziyan Fu <fuzy5@lenovo.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Wim Van Sebroeck <wim@linux-watchdog.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 391/644] watchdog: iTCO_wdt: Report error if timeout configuration fails
Date: Tue, 26 Aug 2025 13:08:02 +0200
Message-ID: <20250826110956.132854940@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ziyan Fu <fuzy5@lenovo.com>

[ Upstream commit 40efc43eb7ffb5a4e2f998c13b8cfb555e671b92 ]

The driver probes with the invalid timeout value when
'iTCO_wdt_set_timeout()' fails, as its return value is not checked. In
this case, when executing "wdctl", we may get:

Device:        /dev/watchdog0
Timeout:       30 seconds
Timeleft:      613 seconds

The timeout value is the value of "heartbeat" or "WATCHDOG_TIMEOUT", and
the timeleft value is calculated from the register value we actually read
(0xffff) by masking with 0x3ff and converting ticks to seconds (* 6 / 10).

Add error handling to return the failure code if 'iTCO_wdt_set_timeout()'
fails, ensuring the driver probe fails and prevents invalid operation.

Signed-off-by: Ziyan Fu <fuzy5@lenovo.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20250704073518.7838-1-13281011316@163.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/iTCO_wdt.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/watchdog/iTCO_wdt.c b/drivers/watchdog/iTCO_wdt.c
index 3cebb83b3e67..02bcbfe8f8c9 100644
--- a/drivers/watchdog/iTCO_wdt.c
+++ b/drivers/watchdog/iTCO_wdt.c
@@ -605,7 +605,11 @@ static int iTCO_wdt_probe(struct platform_device *pdev)
 	/* Check that the heartbeat value is within it's range;
 	   if not reset to the default */
 	if (iTCO_wdt_set_timeout(&p->wddev, heartbeat)) {
-		iTCO_wdt_set_timeout(&p->wddev, WATCHDOG_TIMEOUT);
+		ret = iTCO_wdt_set_timeout(&p->wddev, WATCHDOG_TIMEOUT);
+		if (ret != 0) {
+			dev_err(dev, "Failed to set watchdog timeout (%d)\n", WATCHDOG_TIMEOUT);
+			return ret;
+		}
 		dev_info(dev, "timeout value out of range, using %d\n",
 			WATCHDOG_TIMEOUT);
 	}
-- 
2.39.5



