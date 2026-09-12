Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5882947986A;
	Sat, 12 Sep 2026 15:46:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789228016; cv=none; b=cgT5iiUVrLfsrpGF03V++jAtLxoWEQZYDia4MJF6ISe4ePC5ARHXb3MpCzj+EAPlu/jgAzKW65oiv41ZDey12Ap2HlmhTM5tZEf/iSG4up596emwid2/t1XusxanzuaQCeHGj+E8FFSqvOUgNVL5dwLAR7SUrdUzJh3I12Q8f9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789228016; c=relaxed/simple;
	bh=5Cqg94+9DdSVpOPROqBLgJAie0pb6Ni/dfN2AyRtNQY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qQcDZE8COeJVqkDi6lkw3ahBGE+V+EAH3aCeq6cYPjTCH5JXJZJt4C57lok0zE/wLjZg4NsjeZazT1nJWYqAZ6mmR76Gb/rqj1DHiKD7XIbACX5IgSaP95k/Qxf6DKTBggrLLEoq10cSsh5O/fahTBl0k1sknqwAr8w6vp/IkIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=umllTZpX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="umllTZpX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA6AC1F00898;
	Sat, 12 Sep 2026 15:46:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789228013;
	bh=u6KyPov/zQs3BxAdLU9+2H9JJf6L69Rz784EOF5D/ZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=umllTZpXrhDwjgnvIHFyBhAYl+EQh7IW401UWjpjczsoJYXqlKCtg4rtXKe9mAUF3
	 jmSJu8FEtiQarbDLrdAFGnZsMvpdAtVxzhcnsoSjaKpDsNhfGhF8pnMAjGLJSkGOyI
	 JQ2GxoWrVtWh9qHC+Ndz5K5NHkYH+NyMuW+UEsJg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 6.1 0300/1191] rtc: rzn1: Disable alarm interrupt before reprogramming alarm registers
Date: Sat, 12 Sep 2026 08:50:28 +0200
Message-ID: <20260912065554.970045214@linuxfoundation.org>
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


