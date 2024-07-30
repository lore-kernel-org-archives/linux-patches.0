Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8C5E14831F;
	Tue, 30 Jul 2024 16:49:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358171; cv=none; b=pjstRSAd5YQT3diI5839+5FLdi9ATJaWOiSpM+UvKh8ON9sFj2zfbreUjekbjDaZDR3iiEAL2E5vcyaMoGpdCAKSJj5TK67fN6BdGmfYkSth4Iu5eTJcBSs5ZSVCqrowWXGeRiq+kBgKR619j9c0BrKoouySwMXsbhplVQaEUJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358171; c=relaxed/simple;
	bh=D79/18xN1/+6yjRbMI0CXX3Ehg0xuy+Nklc8EUNFvAk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VLQhixfASom6iaLH13InOvat1gstuo38zm47hiqyL6ILNK+fez4kzKL01jM3tPrUaIxdensV9xP8F2rz4Ft42Tx2iFrmyR7RccXnNBuOk2NlX3eTa/peCVhePZ4WgCnCnX4WEQQlNz+HRW0Zal29sQevokWutYHaTeBWLpVe2b0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E5KHk0MV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E5KHk0MV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F429C32782;
	Tue, 30 Jul 2024 16:49:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358171;
	bh=D79/18xN1/+6yjRbMI0CXX3Ehg0xuy+Nklc8EUNFvAk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E5KHk0MV+l00gjXfsmcqeYCtvc3G/to6h5yFgTi6q0fWhezhSELJoDfaXJPbDB5im
	 insJSFdLq8llcnu3asGSOU8wxuL+qXtUKj4qc7oKT/T351mSCLTgNXjGh56ZfoD2Ti
	 ULwlBaydiV210Gtm+8a1tQG+rwAz1uUG/SLxf/5g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	Arjan van de Ven <arjan@linux.intel.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 363/440] watchdog/perf: properly initialize the turbo mode timestamp and rearm counter
Date: Tue, 30 Jul 2024 17:49:56 +0200
Message-ID: <20240730151629.993252670@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Thomas Gleixner <tglx@linutronix.de>

commit f944ffcbc2e1c759764850261670586ddf3bdabb upstream.

For systems on which the performance counter can expire early due to turbo
modes the watchdog handler has a safety net in place which validates that
since the last watchdog event there has at least 4/5th of the watchdog
period elapsed.

This works reliably only after the first watchdog event because the per
CPU variable which holds the timestamp of the last event is never
initialized.

So a first spurious event will validate against a timestamp of 0 which
results in a delta which is likely to be way over the 4/5 threshold of the
period.  As this might happen before the first watchdog hrtimer event
increments the watchdog counter, this can lead to false positives.

Fix this by initializing the timestamp before enabling the hardware event.
Reset the rearm counter as well, as that might be non zero after the
watchdog was disabled and reenabled.

Link: https://lkml.kernel.org/r/87frsfu15a.ffs@tglx
Fixes: 7edaeb6841df ("kernel/watchdog: Prevent false positives with turbo modes")
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/watchdog_hld.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/kernel/watchdog_hld.c
+++ b/kernel/watchdog_hld.c
@@ -91,11 +91,15 @@ static bool watchdog_check_timestamp(voi
 	__this_cpu_write(last_timestamp, now);
 	return true;
 }
-#else
-static inline bool watchdog_check_timestamp(void)
+
+static void watchdog_init_timestamp(void)
 {
-	return true;
+	__this_cpu_write(nmi_rearmed, 0);
+	__this_cpu_write(last_timestamp, ktime_get_mono_fast_ns());
 }
+#else
+static inline bool watchdog_check_timestamp(void) { return true; }
+static inline void watchdog_init_timestamp(void) { }
 #endif
 
 static struct perf_event_attr wd_hw_attr = {
@@ -196,6 +200,7 @@ void hardlockup_detector_perf_enable(voi
 	if (!atomic_fetch_inc(&watchdog_cpus))
 		pr_info("Enabled. Permanently consumes one hw-PMU counter.\n");
 
+	watchdog_init_timestamp();
 	perf_event_enable(this_cpu_read(watchdog_ev));
 }
 


