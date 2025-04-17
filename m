Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B47302561DF;
	Thu, 17 Apr 2025 17:55:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744912509; cv=none; b=mQo8mFDgxOO8KbyIrsZztmVZQLIaI7VsQYjKGSEAmi6VqipjlRHZKghM3K440g4FvYFDd85xpGYcCRvIdcKv9z350mapBTdc7CumbVN2mRknWkINgeJ1YWQL38e50TQdfyAUWWvfBop93MDpw1sjsdRCCZzxDCSuX3C+X8TYw5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744912509; c=relaxed/simple;
	bh=zRdZSN7Ff7bLql1f4Heg8Hy8U+VN3FTYi70B1kI0wSE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bLpJwO2YB2+F29mU+P5rTE7cfxyV1cOpky25VLU3aMlDNoCGhrG2aRh8O3Qdb6UtpcVVnNNvIRsfBhB7gFTXKgaz4SiQDPFythOWOPZPOnfSGUmMakPH3w3gPvPXdqZS37fgGE5au7kZc09DMr2COws+w6AY9EtlKKL09qDknZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AdoLarBE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AdoLarBE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8CEFC4CEE4;
	Thu, 17 Apr 2025 17:55:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744912509;
	bh=zRdZSN7Ff7bLql1f4Heg8Hy8U+VN3FTYi70B1kI0wSE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AdoLarBEhzR6mRfeJslIzgwLBrfrbjzTnBd2uGyH8uva9LBadFvB+n3Tx/uMiXREF
	 U6Ml2XUs/Q06akJoVZ8ySWFuI9CnI84mgx4yDiccrPd461nWn2g6pZUxsZ6SvT5ZQF
	 P4eSLFT8Aaf0vM93wNUReDf2Z8QDNWg9K78fBycE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Richter <tmricht@linux.ibm.com>,
	Sumanth Korikkar <sumanthk@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 032/449] s390/cpumf: Fix double free on error in cpumf_pmu_event_init()
Date: Thu, 17 Apr 2025 19:45:20 +0200
Message-ID: <20250417175119.293104954@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Richter <tmricht@linux.ibm.com>

[ Upstream commit aa1ac98268cd1f380c713f07e39b1fa1d5c7650c ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/perf_cpum_cf.c | 9 +--------
 arch/s390/kernel/perf_cpum_sf.c | 3 ---
 2 files changed, 1 insertion(+), 11 deletions(-)

diff --git a/arch/s390/kernel/perf_cpum_cf.c b/arch/s390/kernel/perf_cpum_cf.c
index 33205dd410e47..60a60185b1d4d 100644
--- a/arch/s390/kernel/perf_cpum_cf.c
+++ b/arch/s390/kernel/perf_cpum_cf.c
@@ -858,18 +858,13 @@ static int cpumf_pmu_event_type(struct perf_event *event)
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
@@ -1819,8 +1814,6 @@ static int cfdiag_event_init(struct perf_event *event)
 	event->destroy = hw_perf_event_destroy;
 
 	err = cfdiag_event_init2(event);
-	if (unlikely(err))
-		event->destroy(event);
 out:
 	return err;
 }
diff --git a/arch/s390/kernel/perf_cpum_sf.c b/arch/s390/kernel/perf_cpum_sf.c
index 5f60248cb4687..ad22799d8a7d9 100644
--- a/arch/s390/kernel/perf_cpum_sf.c
+++ b/arch/s390/kernel/perf_cpum_sf.c
@@ -885,9 +885,6 @@ static int cpumsf_pmu_event_init(struct perf_event *event)
 		event->attr.exclude_idle = 0;
 
 	err = __hw_perf_event_init(event);
-	if (unlikely(err))
-		if (event->destroy)
-			event->destroy(event);
 	return err;
 }
 
-- 
2.39.5



