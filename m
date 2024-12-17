Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB2231F6661;
	Tue, 17 Dec 2024 17:28:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456526; cv=none; b=V8VdEElQZJ59XKclrCLQrd2FRzFVIpQMmCfxuf01lN2pOEwr9+VnFW47p2qSeeGfwoMDEmT9ZUXyhH0+C36DVR/tZ/CuBV3bnLR9hmzFUEwcTudjsR27KmUoqd/nbCtk0oXyBJMIo0I8lPQZIpYy5oM5TZ3cRMCLNBu2kRlzzU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456526; c=relaxed/simple;
	bh=q+/rrRRkL2Vos38fZR153iBZV/TPyW7As0mxmXVdWfo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YV2C3BlsSV7awqwRLlw5OOChPk0kt5HE1GyQNWxfURGrsoqf5ZmezxE7dN4Gz91BrvBMEcNLi6XPjnzqD8bV4S/fwB//U/HZhorkRO3mGOywZCLfroUUfninSSm2X+95CBoY0A+Nr8uuWcgs2c62/6eym1AtwbYae007KqBPDZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IJNtkpg/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IJNtkpg/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47588C4CED3;
	Tue, 17 Dec 2024 17:28:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456526;
	bh=q+/rrRRkL2Vos38fZR153iBZV/TPyW7As0mxmXVdWfo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IJNtkpg/o7MLu6OuFJgX0r183+52F9DsG+CA1vQgiBejbGtTrZGRFtf0hZKqS6q+2
	 nM2V7bAsPYNpdtX2ByJiN1aKfiEH8xuEuRjP/9g8szcT2NMYNT9G77gWNlTKvYL+bU
	 34ZBYYkSmBJwlbOI1cvrBoA3eY7wZyBnU2BPDE7Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Veronika Molnarova <vmolnaro@redhat.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Michael Petlan <mpetlan@redhat.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 087/172] perf machine: Initialize machine->env to address a segfault
Date: Tue, 17 Dec 2024 18:07:23 +0100
Message-ID: <20241217170549.897533822@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170546.209657098@linuxfoundation.org>
References: <20241217170546.209657098@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@kernel.org>

[ Upstream commit 88a6e2f67cc94f751a74409ab4c21e5fc8ea6757 ]

Its used from trace__run(), for the 'perf trace' live mode, i.e. its
strace-like, non-perf.data file processing mode, the most common one.

The trace__run() function will set trace->host using machine__new_host()
that is supposed to give a machine instance representing the running
machine, and since we'll use perf_env__arch_strerrno() to get the right
errno -> string table, we need to use machine->env, so initialize it in
machine__new_host().

Before the patch:

  (gdb) run trace --errno-summary -a sleep 1
  <SNIP>
   Summary of events:

   gvfs-afc-volume (3187), 2 events, 0.0%

     syscall            calls  errors  total       min       avg       max       stddev
                                       (msec)    (msec)    (msec)    (msec)        (%)
     --------------- --------  ------ -------- --------- --------- ---------     ------
     pselect6               1      0     0.000     0.000     0.000     0.000      0.00%

   GUsbEventThread (3519), 2 events, 0.0%

     syscall            calls  errors  total       min       avg       max       stddev
                                       (msec)    (msec)    (msec)    (msec)        (%)
     --------------- --------  ------ -------- --------- --------- ---------     ------
     poll                   1      0     0.000     0.000     0.000     0.000      0.00%
  <SNIP>
  Program received signal SIGSEGV, Segmentation fault.
  0x00000000005caba0 in perf_env__arch_strerrno (env=0x0, err=110) at util/env.c:478
  478		if (env->arch_strerrno == NULL)
  (gdb) bt
  #0  0x00000000005caba0 in perf_env__arch_strerrno (env=0x0, err=110) at util/env.c:478
  #1  0x00000000004b75d2 in thread__dump_stats (ttrace=0x14f58f0, trace=0x7fffffffa5b0, fp=0x7ffff6ff74e0 <_IO_2_1_stderr_>) at builtin-trace.c:4673
  #2  0x00000000004b78bf in trace__fprintf_thread (fp=0x7ffff6ff74e0 <_IO_2_1_stderr_>, thread=0x10fa0b0, trace=0x7fffffffa5b0) at builtin-trace.c:4708
  #3  0x00000000004b7ad9 in trace__fprintf_thread_summary (trace=0x7fffffffa5b0, fp=0x7ffff6ff74e0 <_IO_2_1_stderr_>) at builtin-trace.c:4747
  #4  0x00000000004b656e in trace__run (trace=0x7fffffffa5b0, argc=2, argv=0x7fffffffde60) at builtin-trace.c:4456
  #5  0x00000000004ba43e in cmd_trace (argc=2, argv=0x7fffffffde60) at builtin-trace.c:5487
  #6  0x00000000004c0414 in run_builtin (p=0xec3068 <commands+648>, argc=5, argv=0x7fffffffde60) at perf.c:351
  #7  0x00000000004c06bb in handle_internal_command (argc=5, argv=0x7fffffffde60) at perf.c:404
  #8  0x00000000004c0814 in run_argv (argcp=0x7fffffffdc4c, argv=0x7fffffffdc40) at perf.c:448
  #9  0x00000000004c0b5d in main (argc=5, argv=0x7fffffffde60) at perf.c:560
  (gdb)

After:

  root@number:~# perf trace -a --errno-summary sleep 1
  <SNIP>
     pw-data-loop (2685), 1410 events, 16.0%

     syscall            calls  errors  total       min       avg       max       stddev
                                       (msec)    (msec)    (msec)    (msec)        (%)
     --------------- --------  ------ -------- --------- --------- ---------     ------
     epoll_wait           188      0   983.428     0.000     5.231    15.595      8.68%
     ioctl                 94      0     0.811     0.004     0.009     0.016      2.82%
     read                 188      0     0.322     0.001     0.002     0.006      5.15%
     write                141      0     0.280     0.001     0.002     0.018      8.39%
     timerfd_settime       94      0     0.138     0.001     0.001     0.007      6.47%

   gnome-control-c (179406), 1848 events, 20.9%

     syscall            calls  errors  total       min       avg       max       stddev
                                       (msec)    (msec)    (msec)    (msec)        (%)
     --------------- --------  ------ -------- --------- --------- ---------     ------
     poll                 222      0   959.577     0.000     4.322    21.414     11.40%
     recvmsg              150      0     0.539     0.001     0.004     0.013      5.12%
     write                300      0     0.442     0.001     0.001     0.007      3.29%
     read                 150      0     0.183     0.001     0.001     0.009      5.53%
     getpid               102      0     0.101     0.000     0.001     0.008      7.82%

  root@number:~#

Fixes: 54373b5d53c1f6aa ("perf env: Introduce perf_env__arch_strerrno()")
Reported-by: Veronika Molnarova <vmolnaro@redhat.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Acked-by: Veronika Molnarova <vmolnaro@redhat.com>
Acked-by: Michael Petlan <mpetlan@redhat.com>
Tested-by: Michael Petlan <mpetlan@redhat.com>
Link: https://lore.kernel.org/r/Z0XffUgNSv_9OjOi@x1
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/machine.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 4f0ac998b0cc..27d5345d2b30 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -134,6 +134,8 @@ struct machine *machine__new_host(void)
 
 		if (machine__create_kernel_maps(machine) < 0)
 			goto out_delete;
+
+		machine->env = &perf_env;
 	}
 
 	return machine;
-- 
2.39.5



