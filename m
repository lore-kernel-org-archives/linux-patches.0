Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42C0A423A7C;
	Tue, 31 Mar 2026 16:54:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976086; cv=none; b=i9X/8aw2OqZ+4tHlCJAcXSfF1qMUK8OVsW4xHYUVw3AHwkPueuWC7VGGXsLyK1LX7EG7QfEtD6pApY1hbHc2okJYF1ZfWirT5VP3EKMlqj2nmbN223hrUTv2KGqC39s3sTX8TArUeFjfS5ZQqSS+JukNTy5SHY4Z/5A8QMD5YHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976086; c=relaxed/simple;
	bh=EAevIMB2GQ0X4nS2k9TuYAwljLh4xaSgzoH3oilfoco=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CNuaTfYXDjGf7N8P21FcWWEKhMLekACQ3jXP/Wc6BOuoW7hl+8gTfvw2LE4FHNquSwmoJfmsXpcDJyTud+fPvaYsNAon6oZGvo4aImDH9sA/Hc67iuOxju23smGHzmVe/MoiLgEcOfQUnZq5/NHGs1SsXW/g/KCnk17OgjVaRwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ip3v+jKc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ip3v+jKc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C45B0C19423;
	Tue, 31 Mar 2026 16:54:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976086;
	bh=EAevIMB2GQ0X4nS2k9TuYAwljLh4xaSgzoH3oilfoco=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ip3v+jKc/B3PXbbQPgti31m8UlplfY93J/n9b2azoXyfiIHrsph+/bm2i8vXbYxcU
	 RsJ5SXQlffEDn/YQYN/D9kOMQRemf7+9SouE4Dpl4J8zktlktzhP3dy9fQ+CyfOaE5
	 1bAxFshRcIraLEcWRyh36S7GPgFlAsATEARCnOr8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Peter Zijlstra <peterz@infradead.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 201/244] tracing: Switch trace_osnoise.c code over to use guard() and __free()
Date: Tue, 31 Mar 2026 18:22:31 +0200
Message-ID: <20260331161749.172325618@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161741.651718120@linuxfoundation.org>
References: <20260331161741.651718120@linuxfoundation.org>
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

From: Steven Rostedt <rostedt@goodmis.org>

[ Upstream commit 930d2b32c0af6895ba4c6ca6404e7f7b6dc214ed ]

The osnoise_hotplug_workfn() grabs two mutexes and cpu_read_lock(). It has
various gotos to handle unlocking them. Switch them over to guard() and
let the compiler worry about it.

The osnoise_cpus_read() has a temporary mask_str allocated and there's
some gotos to make sure it gets freed on error paths. Switch that over to
__free() to let the compiler worry about it.

Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/20241225222931.517329690@goodmis.org
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Stable-dep-of: 1f9885732248 ("tracing: Fix potential deadlock in cpu hotplug with osnoise")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_osnoise.c |   40 +++++++++++++---------------------------
 1 file changed, 13 insertions(+), 27 deletions(-)

--- a/kernel/trace/trace_osnoise.c
+++ b/kernel/trace/trace_osnoise.c
@@ -2099,26 +2099,21 @@ static void osnoise_hotplug_workfn(struc
 {
 	unsigned int cpu = smp_processor_id();
 
-	mutex_lock(&trace_types_lock);
+	guard(mutex)(&trace_types_lock);
 
 	if (!osnoise_has_registered_instances())
-		goto out_unlock_trace;
+		return;
 
-	mutex_lock(&interface_lock);
-	cpus_read_lock();
+	guard(mutex)(&interface_lock);
+	guard(cpus_read_lock)();
 
 	if (!cpu_online(cpu))
-		goto out_unlock;
+		return;
+
 	if (!cpumask_test_cpu(cpu, &osnoise_cpumask))
-		goto out_unlock;
+		return;
 
 	start_kthread(cpu);
-
-out_unlock:
-	cpus_read_unlock();
-	mutex_unlock(&interface_lock);
-out_unlock_trace:
-	mutex_unlock(&trace_types_lock);
 }
 
 static DECLARE_WORK(osnoise_hotplug_work, osnoise_hotplug_workfn);
@@ -2316,31 +2311,22 @@ static ssize_t
 osnoise_cpus_read(struct file *filp, char __user *ubuf, size_t count,
 		  loff_t *ppos)
 {
-	char *mask_str;
+	char *mask_str __free(kfree) = NULL;
 	int len;
 
-	mutex_lock(&interface_lock);
+	guard(mutex)(&interface_lock);
 
 	len = snprintf(NULL, 0, "%*pbl\n", cpumask_pr_args(&osnoise_cpumask)) + 1;
 	mask_str = kmalloc(len, GFP_KERNEL);
-	if (!mask_str) {
-		count = -ENOMEM;
-		goto out_unlock;
-	}
+	if (!mask_str)
+		return -ENOMEM;
 
 	len = snprintf(mask_str, len, "%*pbl\n", cpumask_pr_args(&osnoise_cpumask));
-	if (len >= count) {
-		count = -EINVAL;
-		goto out_free;
-	}
+	if (len >= count)
+		return -EINVAL;
 
 	count = simple_read_from_buffer(ubuf, count, ppos, mask_str, len);
 
-out_free:
-	kfree(mask_str);
-out_unlock:
-	mutex_unlock(&interface_lock);
-
 	return count;
 }
 


