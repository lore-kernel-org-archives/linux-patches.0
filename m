Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29AE0442FD1;
	Wed,  9 Sep 2026 13:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788961982; cv=none; b=FrvM9kJ/zwW5ehvD57Puqn+xRD/HYrGgxb4qdVVBMyeSLsCEGR8VQHjA4CTUyCTgh1xn8jtFi/qXDtTEedNXgoO1yBRHwWuHpUYuF5f93pHmYqSanc71WfUIEgQZALCxposljaWUZcXszElHl539ssUwLphznkC1a8+s0uhDXD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788961982; c=relaxed/simple;
	bh=oiAGzEKDLUgjm1kGDiiqsIxfF7PGuN6mvnciKM++P98=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R3kRAcDSgeNMS4Tsof7pfbjWTvU/nA2zWZOA+AvKOIGCGj69ee7hD15RIMr8btQtuEAHhue6uZaiiLivt+VRp8XcwqwI0f7luCTrs6d53eWnS78RjigM+RkK11wqF08inn/6HMdr+Omly8kG8KAeGEv7ZIlmCaD6WypDWoXDvNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hv5ezD0K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hv5ezD0K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACBA91F00A3A;
	Wed,  9 Sep 2026 13:53:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788961981;
	bh=1Ab5U+IfvmgYaG0UxcoJluSphn8agJgkOa1gIeOcV10=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hv5ezD0KiSg2Snk3pWroxwRIkv+6M0dm2wYcc6hEd5MbODE+5JikEpL7zahgJ1jQn
	 PoDWw5CUppNbH6lUUlkOiUNQpUvVP02yG2VqmBAdafWX0kbLilq74UNOWrW9eDrScA
	 xVsIGqWU6rCHKk5458woXwk1IcveLE/IY+dUIyBA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 7.2 133/556] rtc: rzn1: Disable alarm interrupt before reprogramming alarm registers
Date: Wed,  9 Sep 2026 15:36:53 +0200
Message-ID: <20260909134235.136807493@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -280,6 +280,11 @@ static int rzn1_rtc_set_alarm(struct dev
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


