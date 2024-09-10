Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F507187325;
	Tue, 10 Sep 2024 09:43:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961420; cv=none; b=fMRD6saKpNN9xInMjTU43Xqqha9oo3ActQ0pVJBNlU8wx2yhZND24h4JZIRIoNxkgtu6B4g16Syi7V1dokF3Yh1YnzYY0h52wUnUK6kO9pRY3boHlvS9I0cmEBSFpXh3N8Rvfad7vdNRapC+GkPpnoDDOeVXfOIZ6xUiaLYRx0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961420; c=relaxed/simple;
	bh=elpOTbvEEqPVUWJhjAr4JrbvApgrDq/h76jWtfQfOoY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TDpkyaaUy4Wpwp4ohIj4tMi/d3Yqz43d7LhCJQTUwdukHykJg2B/EZay0xsGon9YnG6ZrBssHomnlWbAQ5fIKAC16FtnxqAP2//b9oLcGx03T4ZBrxbgJJHH33qViVd7zjKYYfUFdBbaSSgga+4NCKr8NRCsMEWNDJO7SxMQXIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KYMv520d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KYMv520d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21743C4CEC3;
	Tue, 10 Sep 2024 09:43:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961420;
	bh=elpOTbvEEqPVUWJhjAr4JrbvApgrDq/h76jWtfQfOoY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KYMv520dOdysV9B5/0e+UiSJlI/6Mrnep/KV7euQaGm66xCMv/1HX0fvWv0sJnq1B
	 LrQ0lkAWixoBlRCblBYMK00IBOmuseHd6r1Kz4z+iVCJngxUg6/no80Jbl0Jeqn9JU
	 bNFBZNsEfZ/GMPmuZNHktspl8QW1frsJyKO/6PUE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	"Luis Claudio R. Goncalves" <lgoncalv@redhat.com>,
	Tomas Glozar <tglozar@redhat.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.10 063/375] tracing/timerlat: Only clear timer if a kthread exists
Date: Tue, 10 Sep 2024 11:27:40 +0200
Message-ID: <20240910092624.341716088@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
 kernel/trace/trace_osnoise.c |   19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

--- a/kernel/trace/trace_osnoise.c
+++ b/kernel/trace/trace_osnoise.c
@@ -253,20 +253,31 @@ static inline struct timerlat_variables
 }
 
 /*
+ * Protect the interface.
+ */
+static struct mutex interface_lock;
+
+/*
  * tlat_var_reset - Reset the values of the given timerlat_variables
  */
 static inline void tlat_var_reset(void)
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
@@ -332,11 +343,6 @@ struct timerlat_sample {
 #endif
 
 /*
- * Protect the interface.
- */
-static struct mutex interface_lock;
-
-/*
  * Tracer data.
  */
 static struct osnoise_data {
@@ -2591,7 +2597,8 @@ static int timerlat_fd_release(struct in
 	osn_var = per_cpu_ptr(&per_cpu_osnoise_var, cpu);
 	tlat_var = per_cpu_ptr(&per_cpu_timerlat_var, cpu);
 
-	hrtimer_cancel(&tlat_var->timer);
+	if (tlat_var->kthread)
+		hrtimer_cancel(&tlat_var->timer);
 	memset(tlat_var, 0, sizeof(*tlat_var));
 
 	osn_var->sampling = 0;


