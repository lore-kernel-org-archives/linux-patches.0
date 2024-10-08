Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC9DF1DED74;
	Tue,  8 Oct 2024 13:07:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392823; cv=none; b=PzdHO9c8rt38z6sf4ygflujdoEjZOG2dni9t6s78ILyA3/6lqepnREyIg5nX+rdus/4/9Pul3FpoIGxh8sqQVhg64c0hacPk91b6OozNTkUsj0HG/EDZarlgWgnmtQ5AEj/MNXt6A82hRFJZCcPw4u03uJ+kPmOrtxyxS5AAbCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392823; c=relaxed/simple;
	bh=XlybraUUfTyOSO1ztJulWQgyr3gtZZhl7pHwgkNcKwg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qhm1Z+RnE7NwQmAxryFV6hpfjv/fNQNC4Mj+0BZ5OBeQsSYjllyKGU92MR0rGsdK7XTWIoRMvlC5YnJSJVneNKrSAe+PrruitMFv5P7kZaYgVz1zU7GZKlikSLyGG56haOD9LeJHjO/ewuHE8tLPidyD9GAFd5Gk82KKG8brcaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B1uQ52+8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B1uQ52+8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52D47C4CECC;
	Tue,  8 Oct 2024 13:07:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392823;
	bh=XlybraUUfTyOSO1ztJulWQgyr3gtZZhl7pHwgkNcKwg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B1uQ52+8b5x4Mrta7GiuU1jc6fo+52oCdbcGXoJnMBCBnf2q7AXpAK93gqCvYkp+8
	 Aq8aAZukE3Aa67aQOfDzmmpOHav4iMFfwb/XEVA0HlbGNp5d7+fDYf+qgxIG0LBMKb
	 Dv2y0jCMoAtN9KTKn47wVcPppqZb00iX7Nqa2C9I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Wei Li <liwei391@huawei.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.11 512/558] tracing/timerlat: Fix duplicated kthread creation due to CPU online/offline
Date: Tue,  8 Oct 2024 14:09:02 +0200
Message-ID: <20241008115722.376088954@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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


