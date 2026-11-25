Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620798;
	b=kz3kwesRe5ghs7yOCJ8LGwvnfVnmSO88U76Az9b2cogaH7vV+ItMF0ETbi0CwmnIljcm
	 dKqNFM3ihFxm1pwrz+VsmAdzfAf25bQJthucBcnrZVYFpUugvU1w/eUNywMLkLHBSPVfM
	 7ZYgiborL7XQSn7fV9dS82EhZVuTWde5HVLIZGAe4Qkpqxfi8sy903icKqpEvNg4Rio84
	 EV60f/AdZYm6NDrwBHr9s1oAtLhEcSjH9Gwsc9BEwgc+bSJRBi8GG712gwtynYV5q2lL/
	 2rd7KrrTzNfC2TlLH3KbJALiCpP7hSdgZwbMnEV7QXtg3OYPv+bdh8O6goFAArzuMjw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620798;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fM3MKErsqSvz2ca2/13LWfEhivqCjB0UiL9N9v/+gAY=;
	b=StsQh9NcRkadok2a9Cn5L8JWHL2g+nXkybLB+/JQ0UYkVPAvUEGqqKc5mdboJtMqc2ou
	 JhmMDfYXT/e44EiQ0SK9XKWO4DAsCi73X/IwGjLhWTQ3u33V2WqQINU932DeB0u62Y/2m
	 XZlxf0KRtoNs2Pq2O0RNaI4mcIASM/uw7JqaCMpLFIhpk1EZggwYTy5zUFz+H8yCb9CI3
	 70/DI93ujpEFDrl/rHUZctIbQo4ZEatqAxFRylcRQuP3t32bsZSIEsD8q04qNEnEz/JYj
	 yPgk2hRLunw1PEVo03NpA/RqM+ZM/6MCl3JaDExreB2KIZ6fQkDgK+NCr+v8VfEaMgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JNnO+UcO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F346606A323;
	Wed, 25 Nov 2026 15:33:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JNnO+UcO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27FFD1F000C0;
	Wed, 25 Nov 2026 15:33:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620797;
	bh=fM3MKErsqSvz2ca2/13LWfEhivqCjB0UiL9N9v/+gAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JNnO+UcOYP/nsOhD15oJgyKMQXLXnOHMKznH/mYvkf+T2noHQyPltVPX/gW+QluS+
	 PMsoPHIN8Laxax9cfRV6jSXx2DodoSD1Uy6V3sk1jaS/7J44bUHmzmR8lXEmG7DuBY
	 p2d9AJbG6R+KPK+j6zl8pa/WDV8ZrUpyAtglGtSU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 027/990] sched: Provide idle_rq() helper
Date: Wed, 25 Nov 2026 15:23:14 +0100
Message-ID: <20261125143822.723938029@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 1e0a2ba7afb1b60f02599093d84b72ce62ad11c0 ]

A fix for the dl_server 'requires' idle_cpu() usage, which made me
note that it and available_idle_cpu() are extern function calls.

And while idle_cpu() is used outside of kernel/sched/,
available_idle_cpu() is not.

This makes it hard to make idle_cpu() an inline helper, so provide
idle_rq() and implement idle_cpu() and available_idle_cpu() using
that.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/sched.h   |  1 -
 kernel/sched/sched.h    | 22 ++++++++++++++++++++++
 kernel/sched/syscalls.c | 30 +-----------------------------
 3 files changed, 23 insertions(+), 30 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index cf5f57cd95104..d3e1262da4354 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1915,7 +1915,6 @@ static inline int task_nice(const struct task_struct *p)
 extern int can_nice(const struct task_struct *p, const int nice);
 extern int task_curr(const struct task_struct *p);
 extern int idle_cpu(int cpu);
-extern int available_idle_cpu(int cpu);
 extern int sched_setscheduler(struct task_struct *, int, const struct sched_param *);
 extern int sched_setscheduler_nocheck(struct task_struct *, int, const struct sched_param *);
 extern void sched_set_fifo(struct task_struct *p);
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 3a38b9a2c9bca..ad7b72317f0f2 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1361,6 +1361,28 @@ static inline u32 sched_rng(void)
 #define cpu_curr(cpu)		(cpu_rq(cpu)->curr)
 #define raw_rq()		raw_cpu_ptr(&runqueues)
 
+static inline bool idle_rq(struct rq *rq)
+{
+	return rq->curr == rq->idle && !rq->nr_running && !rq->ttwu_pending;
+}
+
+/**
+ * available_idle_cpu - is a given CPU idle for enqueuing work.
+ * @cpu: the CPU in question.
+ *
+ * Return: 1 if the CPU is currently idle. 0 otherwise.
+ */
+static inline bool available_idle_cpu(int cpu)
+{
+	if (!idle_rq(cpu_rq(cpu)))
+		return 0;
+
+	if (vcpu_is_preempted(cpu))
+		return 0;
+
+	return 1;
+}
+
 #ifdef CONFIG_SCHED_PROXY_EXEC
 static inline void rq_set_donor(struct rq *rq, struct task_struct *t)
 {
diff --git a/kernel/sched/syscalls.c b/kernel/sched/syscalls.c
index b044a3aa4a0ad..1c48d7eefee7b 100644
--- a/kernel/sched/syscalls.c
+++ b/kernel/sched/syscalls.c
@@ -190,35 +190,7 @@ int task_prio(const struct task_struct *p)
  */
 int idle_cpu(int cpu)
 {
-	struct rq *rq = cpu_rq(cpu);
-
-	if (rq->curr != rq->idle)
-		return 0;
-
-	if (rq->nr_running)
-		return 0;
-
-	if (rq->ttwu_pending)
-		return 0;
-
-	return 1;
-}
-
-/**
- * available_idle_cpu - is a given CPU idle for enqueuing work.
- * @cpu: the CPU in question.
- *
- * Return: 1 if the CPU is currently idle. 0 otherwise.
- */
-int available_idle_cpu(int cpu)
-{
-	if (!idle_cpu(cpu))
-		return 0;
-
-	if (vcpu_is_preempted(cpu))
-		return 0;
-
-	return 1;
+	return idle_rq(cpu_rq(cpu));
 }
 
 /**
-- 
2.53.0



