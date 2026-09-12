Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E5EF37CD21;
	Sat, 12 Sep 2026 07:24:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197891; cv=none; b=XIJfyUbyX6hbPh47rXZt3iSpAre8ifQjh4pO7dcWZQ8bc7r51vVj9HLQL6WWjWQIjMURx1nE2+AitKzuAwyOZgdPPbPwKamw2O8EJFCCK1x8IJrctjo41vaCWURoV0QDcI1NUWNgJattbHWzK85ai+xsm+PXjrkgqPvsnYkMm9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197891; c=relaxed/simple;
	bh=jBD4EbouHLqLrpgsv1lhUpud2kH8ZvvgBjmHzu0zXAs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tXgGp8DqiKhdjeFmeLfpYGq5q0CtTzJRHBQVZQXwacOfYjHbrGVSrfWg+XoUWhkJhjHaHdG8zeuF0iBs4Byfw67Ys/f2C+XfC3mFcyU62GAfbj4TqrYsCFj39J1jVRA/mki7tKIJJFpC0cURqJujtMjTe/hs7BHoyrsD1mlsXe0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ywYQbK21; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ywYQbK21"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17F9E1F000FF;
	Sat, 12 Sep 2026 07:24:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197890;
	bh=5W8MN8Xjfi2HGfZMxaAjiHu9g/J/ajo+zCEUmxbADjE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ywYQbK21PrwyUo5RY8Uh3IanF1LYZ2tS5TuM8P9tDd/LuZVbTiy7PLz+HyfQpOJEP
	 ipbdLCNTnqe61F9iye05KXh3SCH5Rz1782VqoxXM1cR0eHay6OtagJygr/RCmhblP1
	 56PaUFKqR1Uowfl0fI6l/+ET0lfVh0Stidl2TYXw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawei Sun <abyssmystery@gmail.com>,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0266/1815] perf record: fix poll storm when monitored threads exit
Date: Sat, 12 Sep 2026 08:33:36 +0200
Message-ID: <20260912065655.216252488@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiawei Sun <abyssmystery@gmail.com>

[ Upstream commit f94563fac26912ef5a51fd16ae1d83f17b24b19d ]

When `perf record` samples a multi-threaded process and one of the
target threads exits during the session, perf itself may start burning
100% CPU (up to 200% across two cores) until the session ends.  A
single dead fd is sufficient to trigger this; it can be reproduced with
15 pthreads in a compute loop where one thread exits halfway through.

The root cause is two independent instances of the same defect: dead
perf_event ring-buffer fds are left in a pollfd array.  When a monitored
thread exits, the kernel closes its ring-buffer fd, which then returns
POLLHUP.  POSIX specifies that poll() always reports POLLHUP and POLLERR
regardless of the events mask, so any dead fd left in the array makes
poll() return immediately every time, spinning in a tight loop:

  3 seconds: 256,600 poll() calls, 0 context switches, only 21 write()
  Woken up count goes from ~0 to 1,300,000+

There are two affected poll paths, fixed together here:

1. Record main loop, via fdarray__filter() (tools/lib/api/fd/array.c).
   Since commit 59b4412f27f1 ("libperf: Avoid internal moving of
   fdarray fds") it only zeroes events/revents without setting fd to
   -1, so poll() keeps reporting POLLHUP for the entry.  Setting
   fd = -1 makes poll() skip it, matching the pattern already used in
   the control-fd path at tools/perf/builtin-record.c:1673.

2. BPF sideband thread, perf_evlist__poll_thread()
   (tools/perf/util/sideband_evlist.c).  This thread polls for
   PERF_RECORD_BPF_EVENT but, unlike the main record loop, never calls
   fdarray__filter() at all, so dead fds accumulate forever and it
   spins at 100% CPU:

     Before fix: dJiffies=101, wchan=0 (running)
     After fix:  dJiffies=0,   wchan=do_sys_poll (blocking)

   Fixed by calling the existing evlist__filter_pollfd() helper after
   evlist__poll(), mirroring the main record loop.  <poll.h> is
   included for the POLLERR/POLLHUP macros (previously unused there).

The two fixes compose: fix 1 makes poll() ignore dead fds (fd=-1); fix
2 ensures the sideband thread actually performs the filtering.  Both
paths are affected in all kernels from v5.1/v5.9 to the current master
(7.2-rc1); the source of both functions is byte-identical across them.

BPF event recording is preserved: after the fix, perf.data still
contains PERF_RECORD_BPF_EVENT records and bpf_prog_info entries.

Verified on perf 6.1.76, 6.6.143 and 7.2-rc1 with a minimal reproducer
(Woken up 1,300,000 -> 3, CPU 100% -> 0%) and an A/B orthogonal test:
keeping the unpatched binary but preventing the target thread from
exiting also makes the storm disappear, confirming the trigger.

Fixes: 59b4412f27f1 ("libperf: Avoid internal moving of fdarray fds")
Fixes: 657ee5531903 ("perf evlist: Introduce side band thread")
Signed-off-by: Jiawei Sun <abyssmystery@gmail.com>
Reviewed-by: Ian Rogers <irogers@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/api/fd/array.c          |  6 ++++++
 tools/perf/util/sideband_evlist.c | 14 ++++++++++++++
 2 files changed, 20 insertions(+)

diff --git a/tools/lib/api/fd/array.c b/tools/lib/api/fd/array.c
index f0f195207fca9..ffe8272af59b2 100644
--- a/tools/lib/api/fd/array.c
+++ b/tools/lib/api/fd/array.c
@@ -122,6 +122,12 @@ int fdarray__filter(struct fdarray *fda, short revents,
 			if (entry_destructor)
 				entry_destructor(fda, fd, arg);
 
+			/*
+			 * Set fd to -1 so poll() ignores this entry; otherwise
+			 * POLLHUP/POLLERR are still reported for events=0 fds
+			 * (POSIX: always checked), causing a poll storm.
+			 */
+			fda->entries[fd].fd = -1;
 			fda->entries[fd].revents = fda->entries[fd].events = 0;
 			continue;
 		}
diff --git a/tools/perf/util/sideband_evlist.c b/tools/perf/util/sideband_evlist.c
index c07dacf3c54c5..ba043db6cedcb 100644
--- a/tools/perf/util/sideband_evlist.c
+++ b/tools/perf/util/sideband_evlist.c
@@ -8,6 +8,7 @@
 #include <perf/mmap.h>
 #include <linux/perf_event.h>
 #include <limits.h>
+#include <poll.h>
 #include <pthread.h>
 #include <sched.h>
 #include <stdbool.h>
@@ -55,6 +56,19 @@ static void *perf_evlist__poll_thread(void *arg)
 		if (!draining)
 			evlist__poll(evlist, 1000);
 
+		/*
+		 * When a thread of the monitored target exits, its per-cpu
+		 * ring-buffer fd is closed and starts returning POLLHUP. Such
+		 * dead fds are never requested for POLLIN, but poll() reports
+		 * POLLHUP/POLLERR unconditionally, so leaving them in the
+		 * pollfd array makes the following evlist__poll() return
+		 * immediately forever, spinning this thread at 100% CPU.
+		 *
+		 * Filter them out here, mirroring what the 'perf record' main
+		 * loop does after fdarray__poll().
+		 */
+		evlist__filter_pollfd(evlist, POLLERR | POLLHUP);
+
 		for (i = 0; i < evlist__core(evlist)->nr_mmaps; i++) {
 			struct mmap *map = &evlist__mmap(evlist)[i];
 			union perf_event *event;
-- 
2.53.0



