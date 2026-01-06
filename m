Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F24B12EDD76;
	Tue,  6 Jan 2026 17:42:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721344; cv=none; b=D0LEG9x2Yti3eNLUSkJqV1ObrQplLPmyN0CORQ88n3k39x6E4P55Tx5e/rx6YxBkfVsAX1yTegkSfuYnH49rIBxFOF8jbZuJpvAB+A6tsEQHsgLa7DqsrvAh0VahKldkbVU3DppYU94cv7VPw4R9BL3UZLEsQeCGLGXOdqvvFUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721344; c=relaxed/simple;
	bh=Hoswj/28iDA5I7FILhngHmalhfE1Z06Q2khgjSqvV3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Et6GoywUBtP0WON4Fa0uMpgFLEirY9giyMvqLv84NpohoyxVkdvJCg9UysmCn9CFKAGGQRIJnNwuPB9I1OSTqIB61UX5oiCNxXkwQ3UixSKf662T2r5w33ZiJCrNTJsgiyVq/nFoFXc2cdoiCyeSSFSJ9odTmiTX8Q6DNJy2RwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kec+ieBv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kec+ieBv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A9C9C116C6;
	Tue,  6 Jan 2026 17:42:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721343;
	bh=Hoswj/28iDA5I7FILhngHmalhfE1Z06Q2khgjSqvV3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kec+ieBv7DLVAUMBePbS1+fyDtd+9gCclh6IsNmzIYAYFHWw4o0GxSiftq61sZkBI
	 +fnerGVFEw3d9N5JcV0jxCTzIFqIU1k4cZBuls+foflUXfyBJvChVpmNZM7OZ8FT4L
	 Fa+REvgq5LNLVwqztOznHvlJWEiTLT9fDRhFxn7g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nam Cao <namcao@linutronix.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 509/567] hrtimers: Introduce hrtimer_update_function()
Date: Tue,  6 Jan 2026 18:04:51 +0100
Message-ID: <20260106170510.204740101@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

From: Nam Cao <namcao@linutronix.de>

[ Upstream commit 8f02e3563bb5824eb01c94f2c75f1dcee2d05625 ]

Some users of hrtimer need to change the callback function after the
initial setup. They write to hrtimer::function directly.

That's not safe under all circumstances as the write is lockless and a
concurrent timer expiry might end up using the wrong function pointer.

Introduce hrtimer_update_function(), which also performs runtime checks
whether it is safe to modify the callback.

This allows to make hrtimer::function private once all users are converted.

Signed-off-by: Nam Cao <namcao@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/all/20a937b0ae09ad54b5b6d86eabead7c570f1b72e.1730386209.git.namcao@linutronix.de
Stable-dep-of: 267ee93c417e ("serial: xilinx_uartps: fix rs485 delay_rts_after_send")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/hrtimer.h |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

--- a/include/linux/hrtimer.h
+++ b/include/linux/hrtimer.h
@@ -337,6 +337,28 @@ static inline int hrtimer_callback_runni
 	return timer->base->running == timer;
 }
 
+/**
+ * hrtimer_update_function - Update the timer's callback function
+ * @timer:	Timer to update
+ * @function:	New callback function
+ *
+ * Only safe to call if the timer is not enqueued. Can be called in the callback function if the
+ * timer is not enqueued at the same time (see the comments above HRTIMER_STATE_ENQUEUED).
+ */
+static inline void hrtimer_update_function(struct hrtimer *timer,
+					   enum hrtimer_restart (*function)(struct hrtimer *))
+{
+	guard(raw_spinlock_irqsave)(&timer->base->cpu_base->lock);
+
+	if (WARN_ON_ONCE(hrtimer_is_queued(timer)))
+		return;
+
+	if (WARN_ON_ONCE(!function))
+		return;
+
+	timer->function = function;
+}
+
 /* Forward a hrtimer so it expires after now: */
 extern u64
 hrtimer_forward(struct hrtimer *timer, ktime_t now, ktime_t interval);


