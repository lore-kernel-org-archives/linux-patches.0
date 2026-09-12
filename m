Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F2E3381AF4;
	Sat, 12 Sep 2026 13:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789221353; cv=none; b=oWajEYVy82Am3pVhxxIfWazl7EiR7eAxJkorafo0aIB4/beIKwnVoTr03bk+rSPhH+ioSkXs9mxX0CRnj8XhNPEcpGtIG0QtxEYY87OwRxHiuEFz+7KdTVZQuK25H0RHvpKVPuG0I8tY9kSYSXdwOXSsxKLgTY3mWW8YG++hobo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789221353; c=relaxed/simple;
	bh=TRLrhyc+jNJBsZnxTi2DJE3jV2sFnBSbB1AOT3TKYZ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WCpmmfql+Spz3hmC7NDesj0XERjL/IzqSY7ONGLdX7rPAinxuN/J0bcjEI810+cSlTGOFu0HKkJ3TA9rDv4N+M5nCzQ6onwDjpXybsKLiPl9wAxKaaDFgWmkZvtSpr6a2jt80x2Dkqif/Pbv5A+ugjb29WXdjbHX7GbmtDHoCdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GI8IFE9O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GI8IFE9O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB9801F000FF;
	Sat, 12 Sep 2026 13:55:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789221347;
	bh=kmpn4lZokL1nOHi7iOWw31sM1tyXUjZKTZ74E84PsrM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GI8IFE9OmvfIdWDKVenrCmleGwgWIGDn4Rugkm+PbRP+RBPVuXuFlbXpKb2CZeAcE
	 BFHBzoKM7sdLtu2BeDTllyZXwMiN+sCDlSe/qpqFeubwNz16qZv0DoDSmAF0ctnYFE
	 XmQMk29zhH12ZjoXfU7zyqeHFME7ma/h8lKcQ//Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 6.6 0364/1424] rtc: rzn1: Disable alarm interrupt before reprogramming alarm registers
Date: Sat, 12 Sep 2026 08:46:36 +0200
Message-ID: <20260912065615.440666512@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -231,6 +231,11 @@ static int rzn1_rtc_set_alarm(struct dev
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


