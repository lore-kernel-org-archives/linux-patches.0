Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 167162571CF;
	Thu, 17 Apr 2025 18:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915040; cv=none; b=onLcv7uXSFUkdSWt7MzdlyRj20MU2OEZLS+vSnDWgiqOZPzkAAVbN5pyVoJF/jKGZm+JR4rrnKDQaRiS+IBI1EmJ+3PN2leEsGT8GTVFqKMQLBntumiy3HhJtp/qHgoPQlgSKbuwI6CnAqKlSmMg3p7ftraFkX/SyKhU0G4r0TY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915040; c=relaxed/simple;
	bh=GQ7GhfViYU97pSutEyqTfYQ27UCFaKIDCY8Upi7tM2E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IZnxL7zbNEy6MRcyxiuKDcJjwwS3xyzfec/iQSlc71JzwIahc3+YKFR8m3CmXlZB/12w+eo8TcsFF2wMgFNqKtxzJQDeFfEnTXZJhpsqpuDZXXj5oWrvbDsYNo4z61TuVLa9bLzc9eB8f7/h+tY3GHkocBZouoQZVt4/S0q6B/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uEAWwY6q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uEAWwY6q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94516C4CEE7;
	Thu, 17 Apr 2025 18:37:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915040;
	bh=GQ7GhfViYU97pSutEyqTfYQ27UCFaKIDCY8Upi7tM2E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uEAWwY6qEXUNs5ubueT2x3SsCMGrj33/2rOlCY5QlRAPvTCm/XpjjPRc7CXXUB3jO
	 UDS3eHNsAPWuPIOrQXy43jitCsHWq1BBuUjhbh3kGf+5cn38APA0a4DwT7Pm1ksiZ4
	 doXbhNaNI0Uz+atA9yKyyB+3E9zi7JnD8jvhuHN8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Richter <tmricht@linux.ibm.com>,
	Sumanth Korikkar <sumanthk@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 6.13 414/414] s390/cpumf: Fix double free on error in cpumf_pmu_event_init()
Date: Thu, 17 Apr 2025 19:52:52 +0200
Message-ID: <20250417175128.137880077@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Richter <tmricht@linux.ibm.com>

commit aa1ac98268cd1f380c713f07e39b1fa1d5c7650c upstream.

In PMU event initialization functions
 - cpumsf_pmu_event_init()
 - cpumf_pmu_event_init()
 - cfdiag_event_init()
the partially created event had to be removed when an error was detected.
The event::event_init() member function had to release all resources
it allocated in case of error. event::destroy() had to be called
on freeing an event after it was successfully created and
event::event_init() returned success.

With

commit c70ca298036c ("perf/core: Simplify the perf_event_alloc() error path")

this is not necessary anymore. The performance subsystem common
code now always calls event::destroy() to clean up the allocated
resources created during event initialization.

Remove the event::destroy() invocation in PMU event initialization
or that function is called twice for each event that runs into an
error condition in event creation.

This is the kernel log entry which shows up without the fix:

------------[ cut here ]------------
refcount_t: underflow; use-after-free.
WARNING: CPU: 0 PID: 43388 at lib/refcount.c:87	refcount_dec_not_one+0x74/0x90
CPU: 0 UID: 0 PID: 43388 Comm: perf Not tainted 6.15.0-20250407.rc1.git0.300.fc41.s390x+git #1 NONE
Hardware name: IBM 3931 A01 704 (LPAR)
Krnl PSW : 0704c00180000000 00000209cb2c1b88 (refcount_dec_not_one+0x78/0x90)
           R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:0 PM:0 RI:0 EA:3
Krnl GPRS: 0000020900000027 0000020900000023 0000000000000026 0000018900000000
           00000004a2200a00 0000000000000000 0000000000000057 ffffffffffffffea
           00000002b386c600 00000002b3f5b3e0 00000209cc51f140 00000209cc7fc550
           0000000001449d38 ffffffffffffffff 00000209cb2c1b84 00000189d67dfb80
Krnl Code: 00000209cb2c1b78: c02000506727	larl	%r2,00000209cbcce9c6
           00000209cb2c1b7e: c0e5ffbd4431	brasl	%r14,00000209caa6a3e0
          #00000209cb2c1b84: af000000		mc	0,0
          >00000209cb2c1b88: a7480001		lhi	%r4,1
           00000209cb2c1b8c: ebeff0a00004	lmg	%r14,%r15,160(%r15)
           00000209cb2c1b92: ec243fbf0055	risbg	%r2,%r4,63,191,0
           00000209cb2c1b98: 07fe		bcr	15,%r14
           00000209cb2c1b9a: 47000700		bc	0,1792
Call Trace:
 [<00000209cb2c1b88>] refcount_dec_not_one+0x78/0x90
 [<00000209cb2c1dc4>] refcount_dec_and_mutex_lock+0x24/0x90
 [<00000209caa3c29e>] hw_perf_event_destroy+0x2e/0x80
 [<00000209cacaf8b4>] __free_event+0x74/0x270
 [<00000209cacb47c4>] perf_event_alloc.part.0+0x4a4/0x730
 [<00000209cacbf3e8>] __do_sys_perf_event_open+0x248/0xc20
 [<00000209cacc14a4>] __s390x_sys_perf_event_open+0x44/0x50
 [<00000209cb8114de>] __do_syscall+0x12e/0x260
 [<00000209cb81ce34>] system_call+0x74/0x98
Last Breaking-Event-Address:
 [<00000209caa6a4d2>] __warn_printk+0xf2/0x100
---[ end trace 0000000000000000 ]---

Fixes: c70ca298036c ("perf/core: Simplify the perf_event_alloc() error path")
Signed-off-by: Thomas Richter <tmricht@linux.ibm.com>
Reviewed-by: Sumanth Korikkar <sumanthk@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/kernel/perf_cpum_cf.c |    9 +--------
 arch/s390/kernel/perf_cpum_sf.c |    3 ---
 2 files changed, 1 insertion(+), 11 deletions(-)

--- a/arch/s390/kernel/perf_cpum_cf.c
+++ b/arch/s390/kernel/perf_cpum_cf.c
@@ -858,18 +858,13 @@ static int cpumf_pmu_event_type(struct p
 static int cpumf_pmu_event_init(struct perf_event *event)
 {
 	unsigned int type = event->attr.type;
-	int err;
+	int err = -ENOENT;
 
 	if (type == PERF_TYPE_HARDWARE || type == PERF_TYPE_RAW)
 		err = __hw_perf_event_init(event, type);
 	else if (event->pmu->type == type)
 		/* Registered as unknown PMU */
 		err = __hw_perf_event_init(event, cpumf_pmu_event_type(event));
-	else
-		return -ENOENT;
-
-	if (unlikely(err) && event->destroy)
-		event->destroy(event);
 
 	return err;
 }
@@ -1819,8 +1814,6 @@ static int cfdiag_event_init(struct perf
 	event->destroy = hw_perf_event_destroy;
 
 	err = cfdiag_event_init2(event);
-	if (unlikely(err))
-		event->destroy(event);
 out:
 	return err;
 }
--- a/arch/s390/kernel/perf_cpum_sf.c
+++ b/arch/s390/kernel/perf_cpum_sf.c
@@ -885,9 +885,6 @@ static int cpumsf_pmu_event_init(struct
 		event->attr.exclude_idle = 0;
 
 	err = __hw_perf_event_init(event);
-	if (unlikely(err))
-		if (event->destroy)
-			event->destroy(event);
 	return err;
 }
 


