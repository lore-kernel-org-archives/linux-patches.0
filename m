Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6CDC27F4D5;
	Tue,  8 Apr 2025 12:59:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744117160; cv=none; b=HjsjjuE2HXSLJtXUSItvEbDk0eIpH/zvY9scTdkbCn9LhMjjRTqDxHv7WeM9LEQoV/rAXcQ8PW6qYgAFBL8YLl40gTnlJEbShf/kqIEKBA99DIyHFifq3/5HOj3Wg43FdKcXR5BPSVBYaVcg2nA7EGxeB+s08gC7vHkt9tnWi58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744117160; c=relaxed/simple;
	bh=5Y++awOS64NZXp8i7DFq0I+ULUslFjk6jlroqEeKwzM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZbhRYVcjukP/SPZ5pO7kPDPiM1qr2miQNZef8SnidVkch174Ux/5USXmbs4jEObM+mfY0AIML/PP8N23RR1bn2tT/0HHGnACV8KB+7nHmdGVDlR9b5FLu0CStNNHJO7wejfQqyQLGdyNY2WYNLYsOekPm26+O//C02CWExRlXOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o2Fsex9U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o2Fsex9U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08566C4CEE5;
	Tue,  8 Apr 2025 12:59:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744117160;
	bh=5Y++awOS64NZXp8i7DFq0I+ULUslFjk6jlroqEeKwzM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o2Fsex9U+42KA8wGVQXuoFt4f81Xe4G+20Floo7gwFW3C6Qw1nVaQHvKqQx6sP7x7
	 v4E3FCZ7I03cEW2E7XCtB23ZkN+RcDl2rPPwX81MLGAUttPfwMAwK42m1jw9bzilHl
	 z2BuoR0v9TNhHL39FtyRCc71jaYQFhH8LUV5BPus=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ran Xiaokai <ran.xiaokai@zte.com.cn>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.12 406/423] tracing/osnoise: Fix possible recursive locking for cpus_read_lock()
Date: Tue,  8 Apr 2025 12:52:12 +0200
Message-ID: <20250408104855.368149883@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2038,7 +2038,6 @@ static int start_kthread(unsigned int cp
 
 	if (IS_ERR(kthread)) {
 		pr_err(BANNER "could not start sampling thread\n");
-		stop_per_cpu_kthreads();
 		return -ENOMEM;
 	}
 


