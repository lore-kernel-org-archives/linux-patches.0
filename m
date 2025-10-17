Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5CF9336EEB;
	Fri, 17 Oct 2025 15:22:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714522; cv=none; b=fewvFA+dDmR8089nrdljIp0CVfiV4ZMhHyUwiygD2BWGqaUaZqtKQy5c9a1R6nbnqxn76o9ImztUFhnerJpo4CmawwS/ggaL0OXPgFg+0Sr/FuLs2fFDcsxy0DnlWabrc6xWzcobs5aju6wBK1rMMgvr8DoIQBgnDBIWMIitnA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714522; c=relaxed/simple;
	bh=7IboneY1KHeYSajwrZKpwYDuYMxI+RxZUivUJGtULEs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wk4j9FnkjbXadjTA77Ccoc7aPpm4WPqjege0OAFTTod9KTntcpxhMEGtpOVx5DuIG4LXUFihKt30qV78YcvUJpyZ1jouk0z0gj5u5kS7geMWx9WQi4xx5mAdwlJaSrnmXgHPQLIoLxhG6V7+WTx7lM57USAhAUjK8iGz/xyHG4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jgWgR6e/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jgWgR6e/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AA86C4CEE7;
	Fri, 17 Oct 2025 15:22:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714521;
	bh=7IboneY1KHeYSajwrZKpwYDuYMxI+RxZUivUJGtULEs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jgWgR6e/yK8gTCliNqzPaoLzn9OhQj/3Ufzc45sp/GUvxKnZd9hNdhqCy0/DK9DM3
	 iyFNgWy4+kEAtsBmMLCXi7ovXa8Ov92YtaB1ioHWgHMgAD1iI+mmGuCWUBvE5vdAK3
	 kHpllOzQa3cGvfGjrEkYlGo6zE6NNHHFOR9KSgNI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Anderson <sean.anderson@linux.dev>,
	"OGriofa, Conall" <conall.ogriofa@amd.com>,
	"Erim, Salih" <Salih.Erim@amd.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.12 141/277] iio: xilinx-ams: Unmask interrupts after updating alarms
Date: Fri, 17 Oct 2025 16:52:28 +0200
Message-ID: <20251017145152.274378237@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


