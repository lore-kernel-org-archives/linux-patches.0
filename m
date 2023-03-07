Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EBC5BA4F
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 19:08:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85D37C433D2;
	Tue,  7 Mar 2023 19:08:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678216092;
	bh=RHUy4B4vQ0PoXxZpg2RQcAls5hVdGjFUXWY8DAE5pOU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vtL06XPyYN8VYnSArl4f+73Nuq5IKatuEOy/SnyWn7gkHH4lV/7JuTITZ9DunIRBW
	 tJWZwQ7ViS1Bc0tx4I09HxMiXMrHpXPUclZ52Sm+81gbxdjpG2o44z/tGeQ6Yd46IC
	 JlMO6tTmC+K5uPsdAlh/kx7V+RwQcQoCVy2QRyhg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	David Collins <quic_collinsd@quicinc.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 5.15 431/567] rtc: pm8xxx: fix set-alarm race
Date: Tue,  7 Mar 2023 18:02:47 +0100
Message-Id: <20230307165924.575499073@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
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
@@ -220,7 +220,6 @@ static int pm8xxx_rtc_set_alarm(struct d
 {
 	int rc, i;
 	u8 value[NUM_8_BIT_RTC_REGS];
-	unsigned int ctrl_reg;
 	unsigned long secs, irq_flags;
 	struct pm8xxx_rtc *rtc_dd = dev_get_drvdata(dev);
 	const struct pm8xxx_rtc_regs *regs = rtc_dd->regs;
@@ -232,6 +231,11 @@ static int pm8xxx_rtc_set_alarm(struct d
 		secs >>= 8;
 	}
 
+	rc = regmap_update_bits(rtc_dd->regmap, regs->alarm_ctrl,
+				regs->alarm_en, 0);
+	if (rc)
+		return rc;
+
 	spin_lock_irqsave(&rtc_dd->ctrl_reg_lock, irq_flags);
 
 	rc = regmap_bulk_write(rtc_dd->regmap, regs->alarm_rw, value,
@@ -241,19 +245,11 @@ static int pm8xxx_rtc_set_alarm(struct d
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


