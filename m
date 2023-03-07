Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6D99BA49
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:31:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18914C433EF;
	Tue,  7 Mar 2023 18:31:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678213893;
	bh=eiyPRHTKbFMhk/WfNo54jTafuAH6RpDmIKMet5d2GsI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NCL9MULPzFaBdNhVJJWDd1QGOZkgI5VbutkYbP9zuTTNVoZNyPo0qqVybIPPRzKwd
	 BzV+rIAKqi3D28cg0JIYgogxXdEzwRLGtN3CmVDCGKdTmb3LSr2GJYdmd7XOKAsu2g
	 5LtgAd5K/2NJlsreJ3/ey/WKGHDFjpEmEMpA4cMc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	David Collins <quic_collinsd@quicinc.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 6.1 653/885] rtc: pm8xxx: fix set-alarm race
Date: Tue,  7 Mar 2023 17:59:47 +0100
Message-Id: <20230307170030.518636430@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Johan Hovold <johan+linaro@kernel.org>

commit c88db0eff9722fc2b6c4d172a50471d20e08ecc6 upstream.

Make sure to disable the alarm before updating the four alarm time
registers to avoid spurious alarms during the update.

Note that the disable needs to be done outside of the ctrl_reg_lock
section to prevent a racing alarm interrupt from disabling the newly set
alarm when the lock is released.

Fixes: 9a9a54ad7aa2 ("drivers/rtc: add support for Qualcomm PMIC8xxx RTC")
Cc: stable@vger.kernel.org      # 3.1
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Reviewed-by: David Collins <quic_collinsd@quicinc.com>
Link: https://lore.kernel.org/r/20230202155448.6715-2-johan+linaro@kernel.org
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/rtc/rtc-pm8xxx.c |   24 ++++++++++--------------
 1 file changed, 10 insertions(+), 14 deletions(-)

--- a/drivers/rtc/rtc-pm8xxx.c
+++ b/drivers/rtc/rtc-pm8xxx.c
@@ -221,7 +221,6 @@ static int pm8xxx_rtc_set_alarm(struct d
 {
 	int rc, i;
 	u8 value[NUM_8_BIT_RTC_REGS];
-	unsigned int ctrl_reg;
 	unsigned long secs, irq_flags;
 	struct pm8xxx_rtc *rtc_dd = dev_get_drvdata(dev);
 	const struct pm8xxx_rtc_regs *regs = rtc_dd->regs;
@@ -233,6 +232,11 @@ static int pm8xxx_rtc_set_alarm(struct d
 		secs >>= 8;
 	}
 
+	rc = regmap_update_bits(rtc_dd->regmap, regs->alarm_ctrl,
+				regs->alarm_en, 0);
+	if (rc)
+		return rc;
+
 	spin_lock_irqsave(&rtc_dd->ctrl_reg_lock, irq_flags);
 
 	rc = regmap_bulk_write(rtc_dd->regmap, regs->alarm_rw, value,
@@ -242,19 +246,11 @@ static int pm8xxx_rtc_set_alarm(struct d
 		goto rtc_rw_fail;
 	}
 
-	rc = regmap_read(rtc_dd->regmap, regs->alarm_ctrl, &ctrl_reg);
-	if (rc)
-		goto rtc_rw_fail;
-
-	if (alarm->enabled)
-		ctrl_reg |= regs->alarm_en;
-	else
-		ctrl_reg &= ~regs->alarm_en;
-
-	rc = regmap_write(rtc_dd->regmap, regs->alarm_ctrl, ctrl_reg);
-	if (rc) {
-		dev_err(dev, "Write to RTC alarm control register failed\n");
-		goto rtc_rw_fail;
+	if (alarm->enabled) {
+		rc = regmap_update_bits(rtc_dd->regmap, regs->alarm_ctrl,
+					regs->alarm_en, regs->alarm_en);
+		if (rc)
+			goto rtc_rw_fail;
 	}
 
 	dev_dbg(dev, "Alarm Set for h:m:s=%ptRt, y-m-d=%ptRdr\n",


