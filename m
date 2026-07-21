Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 904C8388E40;
	Tue, 21 Jul 2026 19:13:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661212; cv=none; b=jwY6Mlwo/bl5o15TPO+T4SXaa0DPRTHL0T0CYQqA5l8a7D9iLRw6zv5xU3NNZKuUR6oElDmRbJgEIV2LVsy+kxe4TEhHQugLUWuGSFXHH+Uw5vJJCGfRUyXue27yEIBVVGDtbK1KMEUvF0kRrnJ2y1M+2tz9UvyxpfBn/Yq9r5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661212; c=relaxed/simple;
	bh=/28QGdW5B8eqQTvEXe4pdbH0fRGrs2s8hC0/V5x7Zn4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jaoY9i+xhOUdjbghcnMOU76PaYrIVYslWNmAN/o8JeHbhhSQLSmBz0WxHWslNMfNymCZtY0I4cHX3sxMnK8J+2MGFta1uKcWUNiNR57y0w6fPlDTtG+bH+GJ4KIe8VY6LSspBUr1Vw0qZ29KSXq6B92/7PUJO6KLyFfngaIHuog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mAWgfXtB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mAWgfXtB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0143C1F000E9;
	Tue, 21 Jul 2026 19:13:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661211;
	bh=9l1WazAUSBHKixCyiRXCjW+dVxKQadiFD6VGw2XMJRY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mAWgfXtBOJd/ej1GcGa4tB43SM85Sv0w6P+dk1y0cL1i/JozJlsnx5FtCVplxN4MP
	 vMuwpOiWthgacXqn80Ay66DEVpt4HdAB8zArb+5f7Op7dIgVmh6Xo3WwwWBZLf5auv
	 CCyV2iJNGxdR8rwf6JjuIOdaR6NN8k5zkEAlww2k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1272/2077] rtc: cmos: unregister HPET IRQ handler on probe failure
Date: Tue, 21 Jul 2026 17:15:45 +0200
Message-ID: <20260721152622.820534938@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haoxiang Li <haoxiang_li2024@163.com>

[ Upstream commit a5bb580df018b5d1c5668f05f7979044fb19e23a ]

cmos_do_probe() registers cmos_interrupt() as the HPET RTC IRQ
handler before requesting the RTC IRQ and registering the RTC
device. If either request_irq() or devm_rtc_register_device()
fails afterwards, the error path leaves the HPET RTC IRQ handler
installed. This leaves a stale handler behind and make a later
hpet_register_irq_handler() fail with -EBUSY.

Track whether the HPET handler was registered successfully and
undo the registration on the probe error path. Also mask the HPET
RTC IRQ bits to match the normal shutdown cleanup.

Fixes: 9d8af78b0797 ("rtc: add HPET RTC emulation to RTC_DRV_CMOS")
Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
Link: https://patch.msgid.link/20260623100848.2127281-1-haoxiang_li2024@163.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-cmos.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/rtc/rtc-cmos.c b/drivers/rtc/rtc-cmos.c
index f89ab58f5048a2..fa04ece151b8bb 100644
--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -934,6 +934,7 @@ cmos_do_probe(struct device *dev, struct resource *ports, int rtc_irq)
 	unsigned char			rtc_control;
 	unsigned			address_space;
 	u32				flags = 0;
+	bool				hpet_registered = false;
 	struct nvmem_config nvmem_cfg = {
 		.name = "cmos_nvram",
 		.word_size = 1,
@@ -1091,6 +1092,7 @@ cmos_do_probe(struct device *dev, struct resource *ports, int rtc_irq)
 						" failed in rtc_init().");
 				goto cleanup1;
 			}
+			hpet_registered = true;
 		} else
 			rtc_cmos_int_handler = cmos_interrupt;
 
@@ -1140,6 +1142,10 @@ cmos_do_probe(struct device *dev, struct resource *ports, int rtc_irq)
 	if (is_valid_irq(rtc_irq))
 		free_irq(rtc_irq, cmos_rtc.rtc);
 cleanup1:
+	if (hpet_registered) {
+		hpet_mask_rtc_irq_bit(RTC_IRQMASK);
+		hpet_unregister_irq_handler(cmos_interrupt);
+	}
 	cmos_rtc.dev = NULL;
 cleanup0:
 	if (RTC_IOMAPPED)
-- 
2.53.0



