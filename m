Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 401E6568528;
	Wed,  9 Sep 2026 14:17:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963475; cv=none; b=hoMm/FkYzLEPIjuTI5LrQWMr9wXH3D5G0by1wjh/xL2Dyx6yllj+wmt7WOmq96FApmOOghFTOckxXiRSwX5yyzr83TOxRnqR9T63eCflhMHbX/50pQ6SaKm9GE3Z3KcX4KojtiiWF30FRjIDv8YpZF0SlotWQJ21fbq6N9lzJOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963475; c=relaxed/simple;
	bh=9Fc53dd+hYP7i66wXLv6f5TOd6m89BpomdYMHkGLQQc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oTM5076pqt2HlVPAqpNC8NWagfRivG+la3nI+BSTKzX0wQzUVP+SF3aKeRrHN1sZ4JrZ/onlWxAVBArrnoNpkTH8yi598uhHaMDCttD4muGOSIeaDg1A4ysSNf3h+WkBs4uf0/rjzPe74xzf5YsWjvfMJ+Nt+DqOWJjq6xwPuh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e1oErtvj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e1oErtvj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AC681F00A3A;
	Wed,  9 Sep 2026 14:17:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963474;
	bh=+8iOsFMO1bsppv9hx8kR9q5246OYP3Kk185CrdI+bY0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e1oErtvjGj4SBLVyb3cRDoBRps3eXbO1bKqfsVt/f7LVNRSzvb6QhUYojPHo87bXX
	 V2IVl++LMr4XBOPWwaukYLnqN+zoVHg0hlTBKyualiAkR5esnhk5ynP8F1WEf93Qyz
	 ku49IFC4jSHlGaQg1tYRygfl1LqiaNvasYfddNbQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 6.18 092/583] rtc: rzn1: Disable alarm interrupt before reprogramming alarm registers
Date: Wed,  9 Sep 2026 15:36:17 +0200
Message-ID: <20260909134241.312403751@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

commit 51458d5b0a1cfb1b6013400abc95aadf16ed2a57 upstream.

rzn1_rtc_set_alarm() updates RZN1_RTC_ALM, RZN1_RTC_ALH and
RZN1_RTC_ALW using separate MMIO writes without first disabling the
alarm interrupt. If a previous alarm is still enabled, the interrupt
can fire while the alarm registers contain a mixture of old and newly
written values.

Fix this by disabling the alarm interrupt before reprogramming ALM, ALH
and ALW with a call to rzn1_rtc_alarm_irq_enable().

Fixes: b5ad1bf00d2c4 ("rtc: rzn1: Add alarm support")
Cc: stable@vger.kernel.org
Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Reviewed-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Tested-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Link: https://patch.msgid.link/20260821211032.13554-7-prabhakar.mahadev-lad.rj@bp.renesas.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/rtc/rtc-rzn1.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/rtc/rtc-rzn1.c
+++ b/drivers/rtc/rtc-rzn1.c
@@ -281,6 +281,11 @@ static int rzn1_rtc_set_alarm(struct dev
 	if (time_after(alarm, farest))
 		return -ERANGE;
 
+	/* Disable alarm interrupts before reprogramming the alarm. */
+	ret = rzn1_rtc_alarm_irq_enable(dev, 0);
+	if (ret)
+		return ret;
+
 	writel(bin2bcd(tm->tm_min), rtc->base + RZN1_RTC_ALM);
 	writel(bin2bcd(tm->tm_hour), rtc->base + RZN1_RTC_ALH);
 	writel(BIT(tm->tm_wday), rtc->base + RZN1_RTC_ALW);


