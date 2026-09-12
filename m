Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F28647884A;
	Sat, 12 Sep 2026 11:40:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789213208; cv=none; b=QKIPJTVJSWumjSctZXJsh2AsqYV8J62nEtOuLpWwmXYoCAqCoY/zElVZbICGQ/ECYSRRcJpxLQ9rRMjWMO0+cxzSUE9veGB1yr+igf9zLS58MxQ8wJNOQkdKhyxw/TE/a8KmKlbILTs84GvFcSZLrwpqblsXB3Q42FTe92PFIC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789213208; c=relaxed/simple;
	bh=kImbyZOufpg4hDdMelb1L4l3aUroP63ccDHuQGJe+V0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=geDPDkoW4GigoWH2VorZqgrZQuSlKuj/GHq81wGL4AUNzZm1s4734U3ymGj/9tNnWVvgnpR9Z/Z9Il47nybzwJWeaXXYgfb4vZk2WgWpSl2AmzxsZPFU98R7vvpPcyOGe9dPyyQB0TN3ptBah3SZKpmsg7hyVQhoQFiuunkUW8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lfpEc4ff; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lfpEc4ff"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C9BA1F000FF;
	Sat, 12 Sep 2026 11:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789213205;
	bh=DVwDUNFYVa3sJ8oLHq3kXztLFTUKTJZzKl4JAeyy/qE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lfpEc4ffZAuZO7WlFT9xdiVDiofPcRUKBaZqKKggW8d2aDjLnxaY1M7u8pyHZzfJt
	 hVyJkc3LJK+TNQj017uMguSS7+xcGhfa7YXyWk9UyY2/yZXMR8CqBbqisraEwT4q7E
	 vdvWEJumB2Wk1SlK+YBR7bCaNubFwwJOWqEtz1eU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 6.12 0074/1376] rtc: rzn1: Disable alarm interrupt before reprogramming alarm registers
Date: Sat, 12 Sep 2026 08:41:40 +0200
Message-ID: <20260912065609.207424082@linuxfoundation.org>
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


