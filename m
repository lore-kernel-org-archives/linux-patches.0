Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8934818B49E;
	Tue, 10 Sep 2024 10:27:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964023; cv=none; b=rYSL7RibXuOMhU+lHBzUe/8buZJsb+f+ht3BEeGmYP9MZ8WsxLiVr1RkEnxZA/de5IgzZ2QGkX988xyprBFtZ34xRieHRECyJ5XQuRKhcKsMIN5SOKZ3G2yA3L2bSuZTZzgpmJ+4AfA/1vsemrq0yAiwscVpWdgZu/watX+KdOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964023; c=relaxed/simple;
	bh=ymSd5k52D5A79No7R2xqvxsU+fkCsOobi6tq8Hmq5L0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qeR69POxuKUWnXmZxR1oQkVEz1onqY61Y7Fjto/yjTfkyucVa6dwFR98A6JjFnsN4HbIpF+KjgxY/jWd49N3P7Nmi3vA6kI5fSXCkOFRsyIYg2pcsGDw+OtSByiCtJf1zFZijGlb4a8F49krMo7rB8fvYM2UV7VlKmtFQpuyaus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EDwwnJLN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EDwwnJLN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C0A3C4CEC3;
	Tue, 10 Sep 2024 10:27:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964023;
	bh=ymSd5k52D5A79No7R2xqvxsU+fkCsOobi6tq8Hmq5L0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EDwwnJLN8AWgXt+dgfnHpGAwHK2+8o4+vZsN95g0tHcaeJYR0CFUbbWT/1oTFMpG9
	 N9UbnYJ3G7jFhduZxrQUuEBw7h3ST0TaVy60BTn/l9BF/8etp7RVr115PeLxbCaUnS
	 /ugAwjf+DcVVGMnRMjgXyW82HxdDzs3DrXjsU9Cw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	"Luis Claudio R. Goncalves" <lgoncalv@redhat.com>,
	Tomas Glozar <tglozar@redhat.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.6 042/269] tracing/timerlat: Only clear timer if a kthread exists
Date: Tue, 10 Sep 2024 11:30:29 +0200
Message-ID: <20240910092609.752466709@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
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

From: Steven Rostedt <rostedt@goodmis.org>

commit e6a53481da292d970d1edf0d8831121d1c5e2f0d upstream.

The timerlat tracer can use user space threads to check for osnoise and
timer latency. If the program using this is killed via a SIGTERM, the
threads are shutdown one at a time and another tracing instance can start
up resetting the threads before they are fully closed. That causes the
hrtimer assigned to the kthread to be shutdown and freed twice when the
dying thread finally closes the file descriptors, causing a use-after-free
bug.

Only cancel the hrtimer if the associated thread is still around. Also add
the interface_lock around the resetting of the tlat_var->kthread.

Note, this is just a quick fix that can be backported to stable. A real
fix is to have a better synchronization between the shutdown of old
threads and the starting of new ones.

Link: https://lore.kernel.org/all/20240820130001.124768-1-tglozar@redhat.com/

Cc: stable@vger.kernel.org
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>
Link: https://lore.kernel.org/20240905085330.45985730@gandalf.local.home
Fixes: e88ed227f639e ("tracing/timerlat: Add user-space interface")
Reported-by: Tomas Glozar <tglozar@redhat.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_osnoise.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/trace_osnoise.c b/kernel/trace/trace_osnoise.c
index d770927efcd9..48e5014dd4ab 100644
--- a/kernel/trace/trace_osnoise.c
+++ b/kernel/trace/trace_osnoise.c
@@ -252,6 +252,11 @@ static inline struct timerlat_variables *this_cpu_tmr_var(void)
 	return this_cpu_ptr(&per_cpu_timerlat_var);
 }
 
+/*
+ * Protect the interface.
+ */
+static struct mutex interface_lock;
+
 /*
  * tlat_var_reset - Reset the values of the given timerlat_variables
  */
@@ -259,14 +264,20 @@ static inline void tlat_var_reset(void)
 {
 	struct timerlat_variables *tlat_var;
 	int cpu;
+
+	/* Synchronize with the timerlat interfaces */
+	mutex_lock(&interface_lock);
 	/*
 	 * So far, all the values are initialized as 0, so
 	 * zeroing the structure is perfect.
 	 */
 	for_each_cpu(cpu, cpu_online_mask) {
 		tlat_var = per_cpu_ptr(&per_cpu_timerlat_var, cpu);
+		if (tlat_var->kthread)
+			hrtimer_cancel(&tlat_var->timer);
 		memset(tlat_var, 0, sizeof(*tlat_var));
 	}
+	mutex_unlock(&interface_lock);
 }
 #else /* CONFIG_TIMERLAT_TRACER */
 #define tlat_var_reset()	do {} while (0)
@@ -331,11 +342,6 @@ struct timerlat_sample {
 };
 #endif
 
-/*
- * Protect the interface.
- */
-static struct mutex interface_lock;
-
 /*
  * Tracer data.
  */
@@ -2591,7 +2597,8 @@ static int timerlat_fd_release(struct inode *inode, struct file *file)
 	osn_var = per_cpu_ptr(&per_cpu_osnoise_var, cpu);
 	tlat_var = per_cpu_ptr(&per_cpu_timerlat_var, cpu);
 
-	hrtimer_cancel(&tlat_var->timer);
+	if (tlat_var->kthread)
+		hrtimer_cancel(&tlat_var->timer);
 	memset(tlat_var, 0, sizeof(*tlat_var));
 
 	osn_var->sampling = 0;
-- 
2.46.0



