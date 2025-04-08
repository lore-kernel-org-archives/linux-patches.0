Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 732B719AD5C;
	Tue,  8 Apr 2025 11:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112197; cv=none; b=WygQOhuriNCKOrGYzE1VEs/OZBj9qN8xU1xURB2QWfkHqX6kwkNlaRLXV2gwuWyXSimt99ybKNDcoZHKFeDPkbFDKkzoGiNXzvgrsh7pw2a7lg6O4gJB01wydxrI7j8Oaytw8Ly0LCvkyAuOULZz9aWtNeMwhr+dq+5onqSIa3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112197; c=relaxed/simple;
	bh=MXJtFXVTWwRUfaMtp2+jeGZR0/Y9EauUQ8RH4LXSXX0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n30J3Bo/B4HU5Lvi4wRSOfPVk0y9RTM7663SarIgflJqNygJOh3M5SCwm0QWaRTteGVUK0Q7xa09WB+pKqSN0Ez95mbIvTIqdYi9M2ehbYesA5JjiMGY/tEs0+kdpdhHvg71xUGgrpSXALL+uV+vZKy9OFlC2MWJ8DdSRey9iis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JFCjtiDn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JFCjtiDn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04BD5C4CEE5;
	Tue,  8 Apr 2025 11:36:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112197;
	bh=MXJtFXVTWwRUfaMtp2+jeGZR0/Y9EauUQ8RH4LXSXX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JFCjtiDntdMtotPuHIUOpXI6GmzSj8M0dtG3ojuUGIup1FXuRXovBZuyFIU3ge/v4
	 rWr4XMm15mO3WjZ5c+SbRFDGK7Phn0WMJTrcjmkHrgsOkL9OENM5kp4dLJS7ihb64W
	 QcG1N8h4ZHKb4bcyF7+FQ/CbW9mmx/2olbVb43IA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ran Xiaokai <ran.xiaokai@zte.com.cn>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.14 710/731] tracing/osnoise: Fix possible recursive locking for cpus_read_lock()
Date: Tue,  8 Apr 2025 12:50:07 +0200
Message-ID: <20250408104930.787083804@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ran Xiaokai <ran.xiaokai@zte.com.cn>

commit 7e6b3fcc9c5294aeafed0dbe1a09a1bc899bd0f2 upstream.

Lockdep reports this deadlock log:

osnoise: could not start sampling thread
============================================
WARNING: possible recursive locking detected
--------------------------------------------
       CPU0
       ----
  lock(cpu_hotplug_lock);
  lock(cpu_hotplug_lock);

 Call Trace:
  <TASK>
  print_deadlock_bug+0x282/0x3c0
  __lock_acquire+0x1610/0x29a0
  lock_acquire+0xcb/0x2d0
  cpus_read_lock+0x49/0x120
  stop_per_cpu_kthreads+0x7/0x60
  start_kthread+0x103/0x120
  osnoise_hotplug_workfn+0x5e/0x90
  process_one_work+0x44f/0xb30
  worker_thread+0x33e/0x5e0
  kthread+0x206/0x3b0
  ret_from_fork+0x31/0x50
  ret_from_fork_asm+0x11/0x20
  </TASK>

This is the deadlock scenario:
osnoise_hotplug_workfn()
  guard(cpus_read_lock)();      // first lock call
  start_kthread(cpu)
    if (IS_ERR(kthread)) {
      stop_per_cpu_kthreads(); {
        cpus_read_lock();      // second lock call. Cause the AA deadlock
      }
    }

It is not necessary to call stop_per_cpu_kthreads() which stops osnoise
kthread for every other CPUs in the system if a failure occurs during
hotplug of a certain CPU.
For start_per_cpu_kthreads(), if the start_kthread() call fails,
this function calls stop_per_cpu_kthreads() to handle the error.
Therefore, similarly, there is no need to call stop_per_cpu_kthreads()
again within start_kthread().
So just remove stop_per_cpu_kthreads() from start_kthread to solve this issue.

Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/20250321095249.2739397-1-ranxiaokai627@163.com
Fixes: c8895e271f79 ("trace/osnoise: Support hotplug operations")
Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_osnoise.c |    1 -
 1 file changed, 1 deletion(-)

--- a/kernel/trace/trace_osnoise.c
+++ b/kernel/trace/trace_osnoise.c
@@ -2032,7 +2032,6 @@ static int start_kthread(unsigned int cp
 
 	if (IS_ERR(kthread)) {
 		pr_err(BANNER "could not start sampling thread\n");
-		stop_per_cpu_kthreads();
 		return -ENOMEM;
 	}
 


