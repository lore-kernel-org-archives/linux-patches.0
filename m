Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC9211DEFF7;
	Tue,  8 Oct 2024 13:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728394014; cv=none; b=NKkfpyI622sgxkEJYXghDQFgCh/2spW8PdTEwAVMBP+z6j6zCxc4SDJn76dochIpM5C91chwA92r8PImm6VvNrzNdUAeieQdVhtCSPgodRoRNJkysYZq3HtMaxvWvrnlPKwQloLGc/t2Yjp06bICAdo/b5IFfGvUsedUJfZm9rw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728394014; c=relaxed/simple;
	bh=Hf1NcmOd0BnfBd6rWvR0IP4EuIIPlrEfZA9io3N12nY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i0/s6nfd7vmmDk6MAbWydA/sAOMASCPV/jFlzLyOgDhV5x/fkP5oWhSRbnBY4KpLZRc9n6h+17d4cmdKncQ6GNi1uVd5nkUBPamKwRfCq6oYQDGc0ehheew+di5zGgSUcmG6wFJ5XDx5HXo6c8RmS1Egs+Lg3m+oJjxfEWWPGzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yV6Xhiei; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yV6Xhiei"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46187C4CECC;
	Tue,  8 Oct 2024 13:26:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728394014;
	bh=Hf1NcmOd0BnfBd6rWvR0IP4EuIIPlrEfZA9io3N12nY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yV6XhieiycrEeCGMnJI9Rm8/YJWeMLg/O5J1dq4dZuIv5ydPXPAiiF8fWgM5zKp19
	 pnOTWAA1WaolCIhiyoEenGLfLmW92rZz4Db3h1lAFiMezCRW1HD7zbKyzWselUveQP
	 qK036aCUxPJquaEgxCz/wDChzOhhNQBzmTT/RL2E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Wei Li <liwei391@huawei.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.6 320/386] tracing/timerlat: Fix duplicated kthread creation due to CPU online/offline
Date: Tue,  8 Oct 2024 14:09:25 +0200
Message-ID: <20241008115641.978266568@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Li <liwei391@huawei.com>

commit 0bb0a5c12ecf36ad561542bbb95f96355e036a02 upstream.

osnoise_hotplug_workfn() is the asynchronous online callback for
"trace/osnoise:online". It may be congested when a CPU goes online and
offline repeatedly and is invoked for multiple times after a certain
online.

This will lead to kthread leak and timer corruption. Add a check
in start_kthread() to prevent this situation.

Cc: stable@vger.kernel.org
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Link: https://lore.kernel.org/20240924094515.3561410-2-liwei391@huawei.com
Fixes: c8895e271f79 ("trace/osnoise: Support hotplug operations")
Signed-off-by: Wei Li <liwei391@huawei.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_osnoise.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/kernel/trace/trace_osnoise.c
+++ b/kernel/trace/trace_osnoise.c
@@ -2006,6 +2006,10 @@ static int start_kthread(unsigned int cp
 	void *main = osnoise_main;
 	char comm[24];
 
+	/* Do not start a new thread if it is already running */
+	if (per_cpu(per_cpu_osnoise_var, cpu).kthread)
+		return 0;
+
 	if (timerlat_enabled()) {
 		snprintf(comm, 24, "timerlat/%d", cpu);
 		main = timerlat_main;
@@ -2060,11 +2064,10 @@ static int start_per_cpu_kthreads(void)
 		if (cpumask_test_and_clear_cpu(cpu, &kthread_cpumask)) {
 			struct task_struct *kthread;
 
-			kthread = per_cpu(per_cpu_osnoise_var, cpu).kthread;
+			kthread = xchg_relaxed(&(per_cpu(per_cpu_osnoise_var, cpu).kthread), NULL);
 			if (!WARN_ON(!kthread))
 				kthread_stop(kthread);
 		}
-		per_cpu(per_cpu_osnoise_var, cpu).kthread = NULL;
 	}
 
 	for_each_cpu(cpu, current_mask) {


