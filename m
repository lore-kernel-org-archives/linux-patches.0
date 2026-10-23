Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774926;
	b=IGey8iQIEWz40mEnK/aLMvV0zpRYQoTU5xbEnTSjUTuyC6ggM9D+UNMHwbjZj5JssR7o
	 8HDYXrHaiF0jG0sZqzkXtpmIp2lnUo5I1HsB91/5+c/vYGDMRVf95V/6GvvbzZbRERXv4
	 KQivrkzA3dIgtazK5H3FeJuA6tQtgIUVwtR4TT96JM3+0CLS63Od+QNKHwp21yDPvwWlp
	 t2TecduCG12tLJBHP370n/XBDJcU1ynf9PjAUl8RC8rsBWjVUL1uM/s2e5wroV6KrUgMM
	 m9JyE2HcaSt42u5IJnY3ImrEl8c5HaEVOa9tRQnHhK27vfafU2Ru+fZiJptQFzI6wtQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774926;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fc00XNmRpjhlMWg7oNa0F7/kLjuwkjQnURY+f7KQ4TI=;
	b=jWwE+OM0CwsKPfrah2d5P9k/zDqPDF4MGd1UvcSQroUoijrRrkFDt7yE/pfvR+Rq9/JG
	 1sb0FqBF2627vRceV5czJmJ7JYttxzWVxLCBdCu4VBW+z9WN8a+nOPNaUKziL1S3akT+4
	 /BdUQUFMOzTdiqfIL46qYmsY8eWXhqpBrwiBkMV//720ZxUPM/FXJr0pJMviUc7j5kB0B
	 B265pp7t4Txu/JrIa0y7Aitysu84mDHGrOfKEqViswhDbuRawgEHEJQF4foKJXpf+E1Oj
	 FlMjsymkYBJ/veufWUyvnuaKBadiS8bewMAbbWQl7YyVlUfaIM/7XgSjQ84EReo12sA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FEpFb1Z9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 652D2606A31A;
	Fri, 23 Oct 2026 17:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FEpFb1Z9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACE151F01825;
	Fri, 23 Oct 2026 17:02:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774926;
	bh=fc00XNmRpjhlMWg7oNa0F7/kLjuwkjQnURY+f7KQ4TI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FEpFb1Z9nD2s6kZMk9pZbcBzkUbxGqXcc7NPzCwJ5/FSNpuL/3IwjcdzxlXWWUi82
	 SHZoITP0DjaAIZ44rSBEknfXZQoPspgbAx6Tw4yeszxECN7B8Xbfo+bjokcM6cKVIm
	 YEG/uI51x3a3jibpmULpZ33DLQPlCRydgb7a8sZk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Richter <tmricht@linux.ibm.com>,
	Sumanth Korikkar <sumanthk@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 7.2 203/242] s390/pai: Handle multiple PMU stop callback invocations
Date: Fri, 23 Oct 2026 18:40:45 +0200
Message-ID: <20261023163718.596134076@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Richter <tmricht@linux.ibm.com>

commit f3110e969ad226ffbb2d9b4bf5387e68d0d9ef40 upstream.

Handle the following scenario:
The kernel protects itself against a very high sampling load and
throttles the sampling using:

  perf_event_throttle() --> PMU->stop()

Shortly later the scheduler may terminate the task and removes it from the
CPU. It again calls

  PMU->stop()

which results in two invocations of PMU->stop() called back to back.
Protect against this and check the PERF_HES_STOPPED bit on function
entry.  If it is already set return.
Clear bit PERF_HES_STOPPED in PMU->start().

Prohibit ioctl(fd, PERF_EVENT_IOC_PERIOD, ...) call for this event.
It sets perf_event::event_limit to a positive value and causes
perf_event_overflow() to invoke pai_stop() call back function when
perf_event::event_limit hits zero. This is not supported because the
sample events CRYPTO_ALL and NNPA_ALL are only taken at schedule out
of a task.

Use list_for_each_entry_safe() for safe iteration over syswide_list
in pai_have_samples().

Fixes: 9f66572f2889 ("s390/pai_crypto: Enable per-task and system-wide sampling event")
Fixes: 582cc1b28e8c ("s390/pai_ext: Enable per-task and system-wide sampling event")
Cc: stable@vger.kernel.org # v6.19+
Signed-off-by: Thomas Richter <tmricht@linux.ibm.com>
Reviewed-by: Sumanth Korikkar <sumanthk@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/kernel/perf_pai.c |   25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

--- a/arch/s390/kernel/perf_pai.c
+++ b/arch/s390/kernel/perf_pai.c
@@ -502,6 +502,7 @@ static void pai_start(struct perf_event
 			cpump->event = event;
 		}
 	}
+	event->hw.state &= ~PERF_HES_STOPPED;
 }
 
 static void paicrypt_start(struct perf_event *event, int flags)
@@ -548,6 +549,13 @@ static void pai_stop(struct perf_event *
 	struct pai_mapptr *mp = this_cpu_ptr(pai_root[idx].mapptr);
 	struct pai_map *cpump = mp->mapptr;
 
+	/* Cope with multiple invocations:
+	 *   1. perf_event_throttle() --> PMU->stop()
+	 *   2. task schedules out --> PMU->stop()
+	 * Check for event already stopped.
+	 */
+	if (event->hw.state & PERF_HES_STOPPED)
+		return;
 	if (!event->attr.sample_period) {	/* Counting */
 		pai_pmu[idx].pmu->read(event);
 	} else {				/* Sampling */
@@ -710,9 +718,9 @@ static void pai_have_samples(int idx)
 {
 	struct pai_mapptr *mp = this_cpu_ptr(pai_root[idx].mapptr);
 	struct pai_map *cpump = mp->mapptr;
-	struct perf_event *event;
+	struct perf_event *event, *e2;
 
-	list_for_each_entry(event, &cpump->syswide_list, hw.tp_list)
+	list_for_each_entry_safe(event, e2, &cpump->syswide_list, hw.tp_list)
 		pai_have_sample(event, cpump);
 }
 
@@ -729,6 +737,17 @@ static void paicrypt_sched_task(struct p
 		pai_have_samples(PAI_PMU_CRYPTO);
 }
 
+/* Prevent ioctl(fd, PERF_EVENT_IOC_PERIOD, ...) call.
+ * It sets perf_event::event_limit to a positive value and causes
+ * perf_event_overflow() to invoke pai_stop() call back function when
+ * perf_event::event_limit hits zero. This is not supported because the
+ * sample events CRYPTO_ALL and NNPA_ALL are always taken at schedule out
+ * of a task.
+ */
+static int pai_check_period(struct perf_event *event, u64 value)
+{
+	return -EINVAL;
+}
 /* ============================= paiext ====================================*/
 
 static void paiext_event_destroy(struct perf_event *event)
@@ -842,6 +861,7 @@ static struct pmu paicrypt = {
 	.stop	      = paicrypt_stop,
 	.read	      = paicrypt_read,
 	.sched_task   = paicrypt_sched_task,
+	.check_period = pai_check_period,
 	.attr_groups  = paicrypt_attr_groups
 };
 
@@ -1053,6 +1073,7 @@ static struct pmu paiext = {
 	.stop	      = paiext_stop,
 	.read	      = paiext_read,
 	.sched_task   = paiext_sched_task,
+	.check_period = pai_check_period,
 	.attr_groups  = paiext_attr_groups,
 };
 


