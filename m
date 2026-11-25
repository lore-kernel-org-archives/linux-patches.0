Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623298;
	b=Af9UYxlHOyuXNt3RBfn4QcIk/PLiYES9PrFyaoGJMfABSAPcS9oFyM1f2gkNJMaUTa3y
	 PI5Sd+72N4tLg+6TIIUL3OIOpsvkcftV3O65+SwTz5udqmiKJymKg1rjbnYMSESfBSGxF
	 kbuAJukTlcwKVzEN7Fp+hIIauX5O692caI/HbZZL6tJCxXR+siaHsdi7BaWo6CPH+RlPI
	 JJrtnrME4FW7C8iEr9qWzKosgaDhmRyqZd3jDeFDU/DhlfjdTRjeuCvSZ+gvncvd7VrmL
	 BeGKyTStGytn564doDyTW5/ZbbjRZMXXiy2ufglYIIbJmYMlLuNIxst3fAxGYTh6Hag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623298;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HeAO7qw7h7fmHj1RS5yGPTt6KoX+KLJ7F4qyi2juGKA=;
	b=CYL5I36yJ9wSvmZgfwM4eR3P1AU+AieA/Ld2Fp2BiOLMPX2qaSJGz84FWrI6dBwsCUUP
	 5BlmZRy5UIreThbMTlSQ/mr1KD+egGetIcjkldHo2sTvxydUygx/+2TkYJGjf4V5lOWrC
	 NBTpL7/2E4I/OlavjrAlPRteM6Pu8Sa/tYw3yZV1P/UpZi5O+//cg4s0PYJf+E4pe5BUw
	 VMBlhinmFPi1RqxS1oZTOGxJx0NmaJnd7j8C19k/nJ8BQHU/BOWMp7rLjIlFg/c/ApmyX
	 KBCmqel5hjbccH70KaIpjaOkqO/glJZTZEUbTlqll6s9j6suBxwz01oQhtKsFWd1z0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=E0YvPhK1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C094606A31E;
	Wed, 25 Nov 2026 16:14:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=E0YvPhK1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C0861F000C0;
	Wed, 25 Nov 2026 16:14:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623298;
	bh=HeAO7qw7h7fmHj1RS5yGPTt6KoX+KLJ7F4qyi2juGKA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E0YvPhK1grnjSzODbkl4VNC0h3G01pURHHa2UANl3r/qOMhyPzd+dn7zkLMzPWBtN
	 V2Ej8udVTZ5jDkkBvAV6SX7vkWHcMBr++V4gsC56j0htP1ISvCiITC8+5b03ro9y9k
	 ngqN357P9qAdaGflLcWCztM0VH5Zt2f4+/adk9AE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrea Parri <parri.andrea@gmail.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Juri Lelli <juri.lelli@redhat.com>
Subject: [PATCH 6.18 786/990] sched/deadline: Fix spurious -EPERM for migration-disabled tasks
Date: Wed, 25 Nov 2026 15:35:53 +0100
Message-ID: <20261125143840.458351166@linuxfoundation.org>
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

From: Andrea Parri <parri.andrea@gmail.com>

commit 6616bffa9b52da1338cf8bff9882404e02b9e361 upstream.

sched_setattr() can refuse to make a task SCHED_DEADLINE with -EPERM,
even though the task's affinity covers the whole root domain. A retry
can succeed, but the error blames an affinity the task does not have.

__sched_setscheduler() tests p->cpus_ptr, which is not always the task's
affinity. When a task is scheduled out inside a migrate_disable() section,
migrate_disable_switch() points p->cpus_ptr at the current CPU until
migrate_enable(). On PREEMPT_RT every spinlock_t holder is in such a
section, so ordinary kernel work opens the window. Elsewhere, seccomp
filters run in one.

Test p->cpus_mask instead, which keeps the task's affinity and is what
sched_getaffinity() reports. This should be safe because an admitted
task's cpus_mask covers the root domain, so set_cpus_allowed_dl() moves
no bandwidth when migrate_enable() restores p->cpus_ptr.

The following program, run as root, had 553679, 453720 and 424623 of its
1000000 requests refused on three boots of a 4-CPU PREEMPT_RT guest, and
236182, 217174 and 237183 without PREEMPT_RT. With this applied the count
is 0, also with lockdep, and a task pinned to one CPU is still refused:

  #define _GNU_SOURCE
  #include <errno.h>
  #include <linux/filter.h>
  #include <linux/seccomp.h>
  #include <pthread.h>
  #include <stddef.h>
  #include <stdint.h>
  #include <stdio.h>
  #include <sys/syscall.h>
  #include <unistd.h>

  #define REQUESTS 1000000
  #define INSNS 300

  struct attr {
      uint32_t size, policy;
      uint64_t flags;
      int32_t nice;
      uint32_t prio;
      uint64_t runtime, deadline, period;
  };

  static volatile int stop;
  static volatile pid_t target;

  static long set(struct attr a)
  {
      a.size = sizeof(a);
      return syscall(SYS_sched_setattr, target, &a, 0);
  }

  static void *worker(void *arg)
  {
      struct sock_filter f[INSNS + 1];
      struct sock_fprog prog = { .len = INSNS + 1, .filter = f };
      int i;

      /* Reading the arguments keeps seccomp from caching the result */
      for (i = 0; i < INSNS; i++)
          f[i] = (struct sock_filter)
              BPF_STMT(BPF_LD | BPF_W | BPF_ABS,
                       offsetof(struct seccomp_data, args));
      f[INSNS] = (struct sock_filter)
          BPF_STMT(BPF_RET | BPF_K, SECCOMP_RET_ALLOW);
      syscall(SYS_seccomp, SECCOMP_SET_MODE_FILTER, 0, &prog);

      target = syscall(SYS_gettid);
      while (!stop)
          syscall(SYS_getppid);
      return arg;
  }

  static void *hog(void *arg)
  {
      while (!stop)
          ;
      return arg;
  }

  int main(void)
  {
      pthread_t t[9];
      long refused = 0;
      int i;

      pthread_create(&t[0], NULL, worker, NULL);
      while (!target)
          usleep(100);
      for (i = 1; i < 9; i++)
          pthread_create(&t[i], NULL, hog, NULL);
      for (i = 0; i < REQUESTS; i++) {
          /* SCHED_DEADLINE, 2us every 1s */
          if (set((struct attr){ .policy = 6, .runtime = 2000,
                                 .deadline = 1000000000,
                                 .period = 1000000000 }) && errno == EPERM)
              refused++;
          set((struct attr){ .policy = 0 }); /* SCHED_OTHER */
      }
      stop = 1;
      for (i = 0; i < 9; i++)
          pthread_join(t[i], NULL);
      printf("%ld of %d requests refused\n", refused, REQUESTS);
      return 0;
  }

An LLM helped find this bug and write this patch and its test.

Fixes: af449901b84c ("sched: Add migrate_disable()")
Signed-off-by: Andrea Parri <parri.andrea@gmail.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Acked-by: Juri Lelli <juri.lelli@redhat.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20261102135420.244745-1-parri.andrea@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/syscalls.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/sched/syscalls.c
+++ b/kernel/sched/syscalls.c
@@ -638,7 +638,7 @@ change:
 			 * the entire root_domain to become SCHED_DEADLINE. We
 			 * will also fail if there's no bandwidth available.
 			 */
-			if (!cpumask_subset(span, p->cpus_ptr) ||
+			if (!cpumask_subset(span, &p->cpus_mask) ||
 			    rq->rd->dl_bw.bw == 0) {
 				retval = -EPERM;
 				goto unlock;


