Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98EDE47124F;
	Tue, 21 Jul 2026 18:18:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657916; cv=none; b=EcBx9cPYwQM1ZnLHWWUSg1v+E1ewMOI24V1CIPTXp5q7EVy8eVkZl0otxQ7PBu1eCVwOjHeDyZEEy/fJX5Pye5tUEPFSLVJUpDieblYw4QOpqyjpSFaWJi5ciZnBUaWFr3VsuGKGLN4gw+sDO5t6/DMejfgxga/OwIdPo9SEfj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657916; c=relaxed/simple;
	bh=CxtoMgloU05SfN3Ee6Ft2OmYQLoOjhh64i/G6ERMcJY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o0PrJEffJt6XJj14zha+6V2+TRvAHnsA7R6g1a8CyLKNXAvXcA18hCoqs0V/4HOA3GI6vbTsXblZlsz5dv0Wm+OvCIIj4LA9HWpnPFVfax1uDBcZOZOaS5kgOW7gBzWnwxHLDAAAfcf9NJoZLkUZA5tDiQPuB9RGQKYmoBWGGTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HyamAZ39; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HyamAZ39"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E68101F000E9;
	Tue, 21 Jul 2026 18:18:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657915;
	bh=Y+U/Hmxn7JPtBZjrNxvJv/ngwO3AsgIrcla01P1cwDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HyamAZ39AqRGGxdz/ddFFhZhOPVtxfB9geS0DgHfWThRl1hNFioeEYsMVUOd9riGU
	 TB6aAK8z8wGfVncRKUNsXBtnhqkhEFToiJLROL5/Mpc6bm+2cmrgf1qGR041vB7XP/
	 UifaAJTAQVyrVxiTstxAwBkJa+/5V0+fz6/z4L+A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0929/1611] rtc: cmos: unregister HPET IRQ handler on probe failure
Date: Tue, 21 Jul 2026 17:17:25 +0200
Message-ID: <20260721152536.281801616@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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
index 0743c6acd6e2c1..f8068c717fb852 100644
--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -927,6 +927,7 @@ cmos_do_probe(struct device *dev, struct resource *ports, int rtc_irq)
 	unsigned char			rtc_control;
 	unsigned			address_space;
 	u32				flags = 0;
+	bool				hpet_registered = false;
 	struct nvmem_config nvmem_cfg = {
 		.name = "cmos_nvram",
 		.word_size = 1,
@@ -1084,6 +1085,7 @@ cmos_do_probe(struct device *dev, struct resource *ports, int rtc_irq)
 						" failed in rtc_init().");
 				goto cleanup1;
 			}
+			hpet_registered = true;
 		} else
 			rtc_cmos_int_handler = cmos_interrupt;
 
@@ -1133,6 +1135,10 @@ cmos_do_probe(struct device *dev, struct resource *ports, int rtc_irq)
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



