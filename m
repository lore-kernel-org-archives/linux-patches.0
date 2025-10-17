Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 959D936999C;
	Fri, 17 Oct 2025 15:37:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715461; cv=none; b=GPNW4dYyKZN/1UmzqelamC6oneCpSTzGQEJe/p1jrefBoMvx3UaxNB2SUnGjKVQvYas2sziN/H299geJ1mGtu6iov5LITF/bqJBJZIlY/WrWmpp+91cQFcj6XCZ8OXT+Hp6Jko/KjaW6FyKxkQfX//Jw+MN9HsS4RCS8OILawIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715461; c=relaxed/simple;
	bh=wUhO5znvV8efi9sWuPtfegINoGQQKyMIrsz61NEUIQo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tTYHaDuWxH1CuWf6owxGg+sZX5wlFC/x/z8mQLTr8nMiyU1HVS0B14YLm3LRV+uOgCFslpR1O+dFByS4B8SzPbmREil3/UKrjqvtrL0Fllnhvkxh5vk4J2YyjXepH/PX4nYPJrRNiltuEy6hJhfKjHxKkEx76CIgbolYTau3XMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MKZElXbB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MKZElXbB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B192C4CEFE;
	Fri, 17 Oct 2025 15:37:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715461;
	bh=wUhO5znvV8efi9sWuPtfegINoGQQKyMIrsz61NEUIQo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MKZElXbBBLtIq9G23Uk8L9aOHf2Vo2T07/xJWSCYOH0N/QgedQycFvJZlHCQMBc9G
	 rUITRv7cV/v67e9MIxJcazibDw51rjbuDGlJcsN2SQUObYgwJQnXkehQLS+vxUt9Sr
	 5ShKaVH83DI+6KkVq49Ic9/XH5Yfu8MWkw4GEcHA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Anderson <sean.anderson@linux.dev>,
	"OGriofa, Conall" <conall.ogriofa@amd.com>,
	"Erim, Salih" <Salih.Erim@amd.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.17 224/371] iio: xilinx-ams: Unmask interrupts after updating alarms
Date: Fri, 17 Oct 2025 16:53:19 +0200
Message-ID: <20251017145210.190910202@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
@@ -389,6 +389,29 @@ static void ams_update_pl_alarm(struct a
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
@@ -401,6 +424,7 @@ static void ams_update_alarm(struct ams
 
 	spin_lock_irqsave(&ams->intr_lock, flags);
 	ams_update_intrmask(ams, AMS_ISR0_ALARM_MASK, ~alarm_mask);
+	ams_unmask(ams);
 	spin_unlock_irqrestore(&ams->intr_lock, flags);
 }
 
@@ -1035,28 +1059,9 @@ static void ams_handle_events(struct iio
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


