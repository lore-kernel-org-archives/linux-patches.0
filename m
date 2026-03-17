Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F368330B15;
	Tue, 17 Mar 2026 16:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773766505; cv=none; b=jMQbuGQTDONEjqkUF//W/N2z2Przi9P3n1rOa/+RIY/wnIQhQBaTRmkqtPgxI5UD2k1LMwbJdzB6zVOoJwTP4NmarNe8/1toPfzutFEow45YzUnK4aysjVVzU/ko+lc9YiGledYmiwbgmv4ZGz6GFJWQs45KlzU+C6H/C2eeGNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773766505; c=relaxed/simple;
	bh=+csZbB5SRNaeLj5cKPUQN/g7ZlY+WzBylwhfIxkT9CM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QD7umrZBRQclSd5stuKmOKXw7ZRw5zPbKkMH4ycCJE8SjS1lLObD4S7V2fqT8RqxQ1qKPGJOOh9RXvIvBreM+MG6k5eLHA+q8O7zuE85DcIsOYUy2VxnTBKIpqI+UzsAP3FakiJTVWAXZ1+273fLJ2GZdSxc6t1ND5DmHlHePRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FqG5Du9l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FqG5Du9l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8911C4CEF7;
	Tue, 17 Mar 2026 16:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773766505;
	bh=+csZbB5SRNaeLj5cKPUQN/g7ZlY+WzBylwhfIxkT9CM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FqG5Du9lDlhQl6lG/o+OwvaHaM1wPWwVsiGIQNgfboHfeYRHhpo728XRLkRPP1vGN
	 juAR72RUX4eAHGuIJ9Z+Inu6O58khG0Kcb7DZePK4oNv2h0E63xjrOSYFepUJi4/xg
	 rY78EbjpNlWs+XgsrFY4IV+nabn2mpD/iIgarVi8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	YiFei Zhu <zhuyifei@google.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.19 260/378] net: Fix rcu_tasks stall in threaded busypoll
Date: Tue, 17 Mar 2026 17:33:37 +0100
Message-ID: <20260317163016.580189688@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: YiFei Zhu <zhuyifei@google.com>

commit 1a86a1f7d88996085934139fa4c063b6299a2dd3 upstream.

I was debugging a NIC driver when I noticed that when I enable
threaded busypoll, bpftrace hangs when starting up. dmesg showed:

  rcu_tasks_wait_gp: rcu_tasks grace period number 85 (since boot) is 10658 jiffies old.
  rcu_tasks_wait_gp: rcu_tasks grace period number 85 (since boot) is 40793 jiffies old.
  rcu_tasks_wait_gp: rcu_tasks grace period number 85 (since boot) is 131273 jiffies old.
  rcu_tasks_wait_gp: rcu_tasks grace period number 85 (since boot) is 402058 jiffies old.
  INFO: rcu_tasks detected stalls on tasks:
  00000000769f52cd: .N nvcsw: 2/2 holdout: 1 idle_cpu: -1/64
  task:napi/eth2-8265  state:R  running task     stack:0     pid:48300 tgid:48300 ppid:2      task_flags:0x208040 flags:0x00004000
  Call Trace:
   <TASK>
   ? napi_threaded_poll_loop+0x27c/0x2c0
   ? __pfx_napi_threaded_poll+0x10/0x10
   ? napi_threaded_poll+0x26/0x80
   ? kthread+0xfa/0x240
   ? __pfx_kthread+0x10/0x10
   ? ret_from_fork+0x31/0x50
   ? __pfx_kthread+0x10/0x10
   ? ret_from_fork_asm+0x1a/0x30
   </TASK>

The cause is that in threaded busypoll, the main loop is in
napi_threaded_poll rather than napi_threaded_poll_loop, where the
latter rarely iterates more than once within its loop. For
rcu_softirq_qs_periodic inside napi_threaded_poll_loop to report its
qs state, the last_qs must be 100ms behind, and this can't happen
because napi_threaded_poll_loop rarely iterates in threaded busypoll,
and each time napi_threaded_poll_loop is called last_qs is reset to
latest jiffies.

This patch changes so that in threaded busypoll, last_qs is saved
in the outer napi_threaded_poll, and whether busy_poll_last_qs
is NULL indicates whether napi_threaded_poll_loop is called for
busypoll. This way last_qs would not reset to latest jiffies on
each invocation of napi_threaded_poll_loop.

Fixes: c18d4b190a46 ("net: Extend NAPI threaded polling to allow kthread based busy polling")
Cc: stable@vger.kernel.org
Signed-off-by: YiFei Zhu <zhuyifei@google.com>
Reviewed-by: Samiullah Khawaja <skhawaja@google.com>
Link: https://patch.msgid.link/20260227221937.1060857-1-zhuyifei@google.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/dev.c |   17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -7788,11 +7788,12 @@ static int napi_thread_wait(struct napi_
 	return -1;
 }
 
-static void napi_threaded_poll_loop(struct napi_struct *napi, bool busy_poll)
+static void napi_threaded_poll_loop(struct napi_struct *napi,
+				    unsigned long *busy_poll_last_qs)
 {
+	unsigned long last_qs = busy_poll_last_qs ? *busy_poll_last_qs : jiffies;
 	struct bpf_net_context __bpf_net_ctx, *bpf_net_ctx;
 	struct softnet_data *sd;
-	unsigned long last_qs = jiffies;
 
 	for (;;) {
 		bool repoll = false;
@@ -7821,12 +7822,12 @@ static void napi_threaded_poll_loop(stru
 		/* When busy poll is enabled, the old packets are not flushed in
 		 * napi_complete_done. So flush them here.
 		 */
-		if (busy_poll)
+		if (busy_poll_last_qs)
 			gro_flush_normal(&napi->gro, HZ >= 1000);
 		local_bh_enable();
 
 		/* Call cond_resched here to avoid watchdog warnings. */
-		if (repoll || busy_poll) {
+		if (repoll || busy_poll_last_qs) {
 			rcu_softirq_qs_periodic(last_qs);
 			cond_resched();
 		}
@@ -7834,11 +7835,15 @@ static void napi_threaded_poll_loop(stru
 		if (!repoll)
 			break;
 	}
+
+	if (busy_poll_last_qs)
+		*busy_poll_last_qs = last_qs;
 }
 
 static int napi_threaded_poll(void *data)
 {
 	struct napi_struct *napi = data;
+	unsigned long last_qs = jiffies;
 	bool want_busy_poll;
 	bool in_busy_poll;
 	unsigned long val;
@@ -7856,7 +7861,7 @@ static int napi_threaded_poll(void *data
 			assign_bit(NAPI_STATE_IN_BUSY_POLL, &napi->state,
 				   want_busy_poll);
 
-		napi_threaded_poll_loop(napi, want_busy_poll);
+		napi_threaded_poll_loop(napi, want_busy_poll ? &last_qs : NULL);
 	}
 
 	return 0;
@@ -13167,7 +13172,7 @@ static void run_backlog_napi(unsigned in
 {
 	struct softnet_data *sd = per_cpu_ptr(&softnet_data, cpu);
 
-	napi_threaded_poll_loop(&sd->backlog, false);
+	napi_threaded_poll_loop(&sd->backlog, NULL);
 }
 
 static void backlog_napi_setup(unsigned int cpu)


