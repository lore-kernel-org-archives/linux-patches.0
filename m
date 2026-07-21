Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0748415F33;
	Tue, 21 Jul 2026 21:34:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669673; cv=none; b=WjORaYoQH1YFlmtepGlF7DgW8w10P04Y/Reb8PI2BDR1HChReh20CZkWJ+xmbpJ5PhN+B/zEn2aQBAZp0fvjb/CeP4wC4zYAToN+YX6Cmkn1O5xdwORjrSiArmBVJFRkvzVJvkh/Ag8yOnoXAxM6QAfAbamSbxVeiPkC5dKr2Lw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669673; c=relaxed/simple;
	bh=gaoGdYhOAJNHQ0lcJtA1ItYELpaMz7Ez7DrEGwkolkg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mzbS7untdB4Vj7weUem1+yIEOu2lQVE9Ah4F3dBBUFwR5p9AsFdukeCbA+n3kCxhhMlpR3OwUb5k4n0JJ22eicqVLnenLciTI9paLyTwy1rLsYsZ0tKPrLt/LxNn9w4MI1Qlc/kxtVEo+YR4xQ/U5ksMAbYSLE1iDlC9UNsvkw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pRV1Snb7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pRV1Snb7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F370F1F00A3D;
	Tue, 21 Jul 2026 21:34:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669671;
	bh=xyo/2wkoXP+uCL+25sa2WpsFrJx16dKo8mbNvQszLgQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pRV1Snb7e8Acy08XHRRp1gc0iHak95vyBud5cp1mrK+FXSo8aXt2t2CIm5GFtW+/F
	 +2OYhiZh7HU7YIhkgDukmGIhYCI6nO9f9F0t1DTeV8OiMHqSo+h6AhaPosFGYXyEsG
	 p+RQWRDHBDNE5d0oNdNYc7kxYoPUX4L3rKNFNQJA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0642/1067] rtc: cmos: unregister HPET IRQ handler on probe failure
Date: Tue, 21 Jul 2026 17:20:43 +0200
Message-ID: <20260721152438.953629110@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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
index 1442c629d0d550..47799baa32d760 100644
--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -928,6 +928,7 @@ cmos_do_probe(struct device *dev, struct resource *ports, int rtc_irq)
 	unsigned char			rtc_control;
 	unsigned			address_space;
 	u32				flags = 0;
+	bool				hpet_registered = false;
 	struct nvmem_config nvmem_cfg = {
 		.name = "cmos_nvram",
 		.word_size = 1,
@@ -1078,6 +1079,7 @@ cmos_do_probe(struct device *dev, struct resource *ports, int rtc_irq)
 						" failed in rtc_init().");
 				goto cleanup1;
 			}
+			hpet_registered = true;
 		} else
 			rtc_cmos_int_handler = cmos_interrupt;
 
@@ -1127,6 +1129,10 @@ cmos_do_probe(struct device *dev, struct resource *ports, int rtc_irq)
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



