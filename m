Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AAF92F12D6;
	Fri, 17 Oct 2025 15:08:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713715; cv=none; b=SqZTzwV6K2sl+3NRfAnRTRN87ZTBfC9geMb+7gt8R9drw9RZQSEu8VZ1YP32WBAGVLrNzziWw1aenexqLFoSl7/9TQVXpNcnru1q79GX//XelutNQdRJOS1Dl3vwZRuZ7luRXCeh+grPDV5xB7Ef+VuATitk6Wzex8dJKNTKtxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713715; c=relaxed/simple;
	bh=lGVhUfW2jjHdjMyU2ba+Clb3/kyrUNP+QKHXDel61l0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F+b8EzleqtTqo+HaM/flvEDbBAuPnZBYq+2B2YOeqKBYqvV+q5GWczpMU+lzZoAUGmk93ZGoC+7wWE12G/qLqy17ULYYFYL0jzXKe8c6mYCjTlQrZpTAMrhAqFTJDitOfBkt+WjfWeEau3t3cmlttkTLtMX9zbr5ZnedDaXN8pI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1np7u4fT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1np7u4fT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98BF5C4CEE7;
	Fri, 17 Oct 2025 15:08:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713715;
	bh=lGVhUfW2jjHdjMyU2ba+Clb3/kyrUNP+QKHXDel61l0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1np7u4fTFfrtz0Iwjg4o+/dzwf7rykNcPpMhN14Ok03wUPD6I2BWmZYWGysR0kw1+
	 4CMWd/eYTi920eq7V6jZOXVI0ppHRCRSOwphoOnEgeUZCCoGu32OPRe72u99k/nFj/
	 Szu9zThV0ri99OfKc4/0Em4d5ymrSAOQlbn9KwL0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Anderson <sean.anderson@linux.dev>,
	"OGriofa, Conall" <conall.ogriofa@amd.com>,
	"Erim, Salih" <Salih.Erim@amd.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.6 095/201] iio: xilinx-ams: Unmask interrupts after updating alarms
Date: Fri, 17 Oct 2025 16:52:36 +0200
Message-ID: <20251017145138.241049548@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145134.710337454@linuxfoundation.org>
References: <20251017145134.710337454@linuxfoundation.org>
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

From: Sean Anderson <sean.anderson@linux.dev>

commit feb500c7ae7a198db4d2757901bce562feeefa5e upstream.

To convert level-triggered alarms into edge-triggered IIO events, alarms
are masked when they are triggered. To ensure we catch subsequent
alarms, we then periodically poll to see if the alarm is still active.
If it isn't, we unmask it. Active but masked alarms are stored in
current_masked_alarm.

If an active alarm is disabled, it will remain set in
current_masked_alarm until ams_unmask_worker clears it. If the alarm is
re-enabled before ams_unmask_worker runs, then it will never be cleared
from current_masked_alarm. This will prevent the alarm event from being
pushed even if the alarm is still active.

Fix this by recalculating current_masked_alarm immediately when enabling
or disabling alarms.

Fixes: d5c70627a794 ("iio: adc: Add Xilinx AMS driver")
Signed-off-by: Sean Anderson <sean.anderson@linux.dev>
Reviewed-by: O'Griofa, Conall <conall.ogriofa@amd.com>
Tested-by: Erim, Salih <Salih.Erim@amd.com>
Acked-by: Erim, Salih <Salih.Erim@amd.com>
Link: https://patch.msgid.link/20250715002847.2035228-1-sean.anderson@linux.dev
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/xilinx-ams.c |   45 +++++++++++++++++++++++--------------------
 1 file changed, 25 insertions(+), 20 deletions(-)

--- a/drivers/iio/adc/xilinx-ams.c
+++ b/drivers/iio/adc/xilinx-ams.c
@@ -385,6 +385,29 @@ static void ams_update_pl_alarm(struct a
 	ams_pl_update_reg(ams, AMS_REG_CONFIG3, AMS_REGCFG3_ALARM_MASK, cfg);
 }
 
+static void ams_unmask(struct ams *ams)
+{
+	unsigned int status, unmask;
+
+	status = readl(ams->base + AMS_ISR_0);
+
+	/* Clear those bits which are not active anymore */
+	unmask = (ams->current_masked_alarm ^ status) & ams->current_masked_alarm;
+
+	/* Clear status of disabled alarm */
+	unmask |= ams->intr_mask;
+
+	ams->current_masked_alarm &= status;
+
+	/* Also clear those which are masked out anyway */
+	ams->current_masked_alarm &= ~ams->intr_mask;
+
+	/* Clear the interrupts before we unmask them */
+	writel(unmask, ams->base + AMS_ISR_0);
+
+	ams_update_intrmask(ams, ~AMS_ALARM_MASK, ~AMS_ALARM_MASK);
+}
+
 static void ams_update_alarm(struct ams *ams, unsigned long alarm_mask)
 {
 	unsigned long flags;
@@ -397,6 +420,7 @@ static void ams_update_alarm(struct ams
 
 	spin_lock_irqsave(&ams->intr_lock, flags);
 	ams_update_intrmask(ams, AMS_ISR0_ALARM_MASK, ~alarm_mask);
+	ams_unmask(ams);
 	spin_unlock_irqrestore(&ams->intr_lock, flags);
 }
 
@@ -1025,28 +1049,9 @@ static void ams_handle_events(struct iio
 static void ams_unmask_worker(struct work_struct *work)
 {
 	struct ams *ams = container_of(work, struct ams, ams_unmask_work.work);
-	unsigned int status, unmask;
 
 	spin_lock_irq(&ams->intr_lock);
-
-	status = readl(ams->base + AMS_ISR_0);
-
-	/* Clear those bits which are not active anymore */
-	unmask = (ams->current_masked_alarm ^ status) & ams->current_masked_alarm;
-
-	/* Clear status of disabled alarm */
-	unmask |= ams->intr_mask;
-
-	ams->current_masked_alarm &= status;
-
-	/* Also clear those which are masked out anyway */
-	ams->current_masked_alarm &= ~ams->intr_mask;
-
-	/* Clear the interrupts before we unmask them */
-	writel(unmask, ams->base + AMS_ISR_0);
-
-	ams_update_intrmask(ams, ~AMS_ALARM_MASK, ~AMS_ALARM_MASK);
-
+	ams_unmask(ams);
 	spin_unlock_irq(&ams->intr_lock);
 
 	/* If still pending some alarm re-trigger the timer */


