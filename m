Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83BB319E7FA;
	Thu, 15 Aug 2024 13:53:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729991; cv=none; b=oEhDzy/PbJe/28O/K23BV8w492L0YesCl4t7aRY1l6vEol7oDyWkxrDdVSPfiZLJHZUm9JHM8UtDeL+DGhOtG9LcHG1s8+8gko16x8b2CQAn0MoRFgrIEkUGz3U8jsesVaNXwkFAvqmqouJgJpI3BUMr5I8VYFd8VwtTATS+G/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729991; c=relaxed/simple;
	bh=Dy5CB0xGzfdbfDMg3BBCtb/7zeVlbOGkI9u22IlShYY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HQiNlFrLBc2O4BrlXKpUj/TkbDO5VqM/Yj98TeDF7D0ifKplgUYzG9bsYTOiG+avCgICZhPfqMYX/FZgUKgZj+2LyR5GwAtdUNkLTAlI2qWCja9MQR6epOKoRJ66z4AYVFWHBekIZ6DltWrYBiFoFkn3HJnotJBcDcqExoefC5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G77kQxF/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G77kQxF/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AC76C32786;
	Thu, 15 Aug 2024 13:53:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729991;
	bh=Dy5CB0xGzfdbfDMg3BBCtb/7zeVlbOGkI9u22IlShYY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G77kQxF/eLJuWoozzmWVY/kGP+EsiO5oqZhTz8eUeW96QaoeVh7Vp+kFyjZ49invw
	 LdJZrXusfC4d6jZCxsiu0FnEm0PbTQ7Xouo/4JEJT9sD9LVHAFXc9JE4Fi3Ls2Mxjf
	 6FduF7bd8OniV1BZcuxZGuRsQxTgO0iNoDk8g27g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	Arjan van de Ven <arjan@linux.intel.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.15 239/484] watchdog/perf: properly initialize the turbo mode timestamp and rearm counter
Date: Thu, 15 Aug 2024 15:21:37 +0200
Message-ID: <20240815131950.636381956@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 


