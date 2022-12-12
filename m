Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4CD92585
	for <patches@lists.linux.dev>; Mon, 12 Dec 2022 13:13:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38374C433F0;
	Mon, 12 Dec 2022 13:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670850833;
	bh=ruZJlf7sf+XEman/fuukO4kreNRFT4FX07jOeVJbGzk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qzHWKrYtK67vR+1TjyKQ2U3VliH9mQD9qIpZh3a18o3kP4LzBgeXQsUYPE6BFXmUa
	 jfhyDXMBdOT0rEgRXn1+vdJYc5WuW9pL7OoUd6xPMpK89pypW2gTNjgAwS85gng4yw
	 fk3ZHXyjcTAtYOxM8SZ7QyyFVNOFyQbxkXJEEvGc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaofei Tan <tanxiaofei@huawei.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 040/106] rtc: cmos: Replace spin_lock_irqsave with spin_lock in hard IRQ
Date: Mon, 12 Dec 2022 14:09:43 +0100
Message-Id: <20221212130926.611534365@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130924.863767275@linuxfoundation.org>
References: <20221212130924.863767275@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Xiaofei Tan <tanxiaofei@huawei.com>

[ Upstream commit 6950d046eb6eabbc271fda416460c05f7a85698a ]

It is redundant to do irqsave and irqrestore in hardIRQ context, where
it has been in a irq-disabled context.

Signed-off-by: Xiaofei Tan <tanxiaofei@huawei.com>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Link: https://lore.kernel.org/r/1612355981-6764-2-git-send-email-tanxiaofei@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-cmos.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/rtc/rtc-cmos.c b/drivers/rtc/rtc-cmos.c
index d419eb988b22..21f2bdd025b6 100644
--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -704,11 +704,10 @@ static struct cmos_rtc	cmos_rtc;
 
 static irqreturn_t cmos_interrupt(int irq, void *p)
 {
-	unsigned long	flags;
 	u8		irqstat;
 	u8		rtc_control;
 
-	spin_lock_irqsave(&rtc_lock, flags);
+	spin_lock(&rtc_lock);
 
 	/* When the HPET interrupt handler calls us, the interrupt
 	 * status is passed as arg1 instead of the irq number.  But
@@ -742,7 +741,7 @@ static irqreturn_t cmos_interrupt(int irq, void *p)
 			hpet_mask_rtc_irq_bit(RTC_AIE);
 		CMOS_READ(RTC_INTR_FLAGS);
 	}
-	spin_unlock_irqrestore(&rtc_lock, flags);
+	spin_unlock(&rtc_lock);
 
 	if (is_intr(irqstat)) {
 		rtc_update_irq(p, 1, irqstat);
-- 
2.35.1



