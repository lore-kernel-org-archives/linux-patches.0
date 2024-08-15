Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ABED18D630;
	Thu, 15 Aug 2024 13:32:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723728724; cv=none; b=BvMDz+C3GcYUb4AfQ0lO+GhPN60egZy9Hi3RtoJ9Y6RNXtL2b3sDldrOaPFYBk3n6DIr7U4R6S4jRaaaYRRT9Zz8ZtShCIuulPenMxIxTcymZm/m+OtbXGPup0nYe1ky6/O4gLJ+9FXYNnowblCekm3trhLE4Ytau/tY/DB9Uy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723728724; c=relaxed/simple;
	bh=QW8Sk67inKjZPoWIMwIAHgSUrNr/AxhXpdgN+iO+ou4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KUQxjdXICP5ilBywl7eU5F6coN7+aePzkwmuhOnvl1KGRBmunLMmJP/pYpBeSIff3LHLIq1Q7X/LPv6kSra5bQEuArkBbfR4wnG8bbNurtOsP2frgm8XLumKpU/mA6ujNtjY6o5iDJlG1bo3ZdWccw+5iMWKwc9t1v6rYfzoR0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L0dPyEm+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L0dPyEm+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5D96C32786;
	Thu, 15 Aug 2024 13:32:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723728724;
	bh=QW8Sk67inKjZPoWIMwIAHgSUrNr/AxhXpdgN+iO+ou4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L0dPyEm+KvjEr9RUfkoEiRKrXJhYJqZePzZJDLN4yftZrC0t9G0O/xPP1jzxR3/ed
	 FWrNRMtflxtxZcZH6pEabE+jV44V2o5qbDgC8w+8O7a+NwsjO+FRSyiwIKlS/Yg+wp
	 BkRkQNIP/eJLQHDo//58Leg6Du/yVMufH7fzEOfM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	Arjan van de Ven <arjan@linux.intel.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 4.19 090/196] watchdog/perf: properly initialize the turbo mode timestamp and rearm counter
Date: Thu, 15 Aug 2024 15:23:27 +0200
Message-ID: <20240815131855.525292168@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131852.063866671@linuxfoundation.org>
References: <20240815131852.063866671@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -195,6 +199,7 @@ void hardlockup_detector_perf_enable(voi
 	if (!atomic_fetch_inc(&watchdog_cpus))
 		pr_info("Enabled. Permanently consumes one hw-PMU counter.\n");
 
+	watchdog_init_timestamp();
 	perf_event_enable(this_cpu_read(watchdog_ev));
 }
 


