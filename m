Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B8A349620;
	Tue, 21 Jul 2026 20:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666727; cv=none; b=aip2OWN7/b1WYX3i+oH6ztFHXrszHuvZJlMNvFP8e/DPATwiXPT+mz07gcZdTSleYapHGVCViSxKifYd0mwVnEpiZ3XOCMyvX5wd23naqesr62ydtUFQeQ/I0N9+quQDDlp9WYv6+gMJb1HdQ6A70D/OgL7E/jGCKkWzT0SLKfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666727; c=relaxed/simple;
	bh=o2C7IVQL4eZ47ydhbzeMe8p3aJUBc/YzxDX7FU6deI0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UlYnW1myWDMEXiR+O1En7QOk4W27/gXsOHn0Nc6hZCrd8QWkaBjje0houUtzw69lPXKnUne/P6NyzQwcVqTQTm0S4zyGgfPbDnXf2geNfDrtrjg22DeGnM6ExCwJJrqmfs9C+Y06xPfmha7ba+zHZFmh//blQj8kfTXdeiNrMQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qJsxMEA2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qJsxMEA2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A82DC1F00A3A;
	Tue, 21 Jul 2026 20:45:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666726;
	bh=LM5pNb46aX3ZI90aDOkcauIpGIsizNIXUHEUpUEIMgQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qJsxMEA2uzRnfxgWkWL13Joh0BEEG1zAsl8etBjDkF2PsFLViBbNTN6RafDGBE92+
	 keDhOthQ8K6FlL86MP6cJu7vFKHQKvwuzW7Hp4T4J0bGzyT76xEm7MNb7ufsmoALwn
	 arIUUS+LF9Zsezg/jkicIlDXI1x3x2oGlb+2vBsA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0793/1266] rtc: cmos: unregister HPET IRQ handler on probe failure
Date: Tue, 21 Jul 2026 17:20:30 +0200
Message-ID: <20260721152459.605329123@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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
index 095de4e0e4f388..e06f3b9cab2c84 100644
--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -932,6 +932,7 @@ cmos_do_probe(struct device *dev, struct resource *ports, int rtc_irq)
 	unsigned char			rtc_control;
 	unsigned			address_space;
 	u32				flags = 0;
+	bool				hpet_registered = false;
 	struct nvmem_config nvmem_cfg = {
 		.name = "cmos_nvram",
 		.word_size = 1,
@@ -1089,6 +1090,7 @@ cmos_do_probe(struct device *dev, struct resource *ports, int rtc_irq)
 						" failed in rtc_init().");
 				goto cleanup1;
 			}
+			hpet_registered = true;
 		} else
 			rtc_cmos_int_handler = cmos_interrupt;
 
@@ -1138,6 +1140,10 @@ cmos_do_probe(struct device *dev, struct resource *ports, int rtc_irq)
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



