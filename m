Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C889D146585;
	Thu, 13 Jun 2024 11:52:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279554; cv=none; b=qGFaXPe2Og3UVW3oRq7c/O8KeTb/RRl13oz4w/QWbBVbli7UlXO+hKh1JqwYns7prkwSHBXUtsOpopWZLTxaM1JrnWQ6e9Icb+CCyX9aI6WJ9j6xV6rAA9NLmugcw/DN/diVDUFcyZ+1y+fVH53rAiLqhh4FEyTY6DwlI0LY00Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279554; c=relaxed/simple;
	bh=omF5G6C33z8RBEAS73/IHdreTDLTFdmuijs9zEFYm+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NJlOEEiJh9TrRHoES0O+qRF9DaUxnEtPqTZGpOo+gy92IZ7DcRULEdONMQXCvRbCRrxCq2QCs/xv+KusVjeGwPc/R1yQlf09CJ3NIh+U30bt1CpBrmxx62vwTWKElxzQtksy7fgOUwq3aMrNIxJxtjs6sjU9yNV/qIMr52elFAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IFlU1BDp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IFlU1BDp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47F47C2BBFC;
	Thu, 13 Jun 2024 11:52:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279554;
	bh=omF5G6C33z8RBEAS73/IHdreTDLTFdmuijs9zEFYm+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IFlU1BDpz/eQu7iHL9rx5vgJxl5nBQ2Sugs+Xbw7itNs/a5VHZbdv5wAOPNWqyyCY
	 tzIThtkzQQH/lYY/YhI12bD7p6mkbYZhiPMFXRD0GHtztN5rsuuiudBPpcCfsf1fB/
	 mNCduthsl1NVXuJB6SFsFV3CbPii9wUl7Z46dC7c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Milian Wolff <milian.wolff@kdab.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ian Rogers <irogers@google.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Kan Liang <kan.liang@linux.intel.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	stable@kernel.org
Subject: [PATCH 6.9 115/157] Revert "perf record: Reduce memory for recording PERF_RECORD_LOST_SAMPLES event"
Date: Thu, 13 Jun 2024 13:34:00 +0200
Message-ID: <20240613113231.865572680@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.389465891@linuxfoundation.org>
References: <20240613113227.389465891@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

commit 5b3cde198878b2f3269d5e7efbc0d514899b1fd8 upstream.

This reverts commit 7d1405c71df21f6c394b8a885aa8a133f749fa22.

This causes segfaults in some cases, as reported by Milian:

  ```
  sudo /usr/bin/perf record -z --call-graph dwarf -e cycles -e
  raw_syscalls:sys_enter ls
  ...
  [ perf record: Woken up 3 times to write data ]
  malloc(): invalid next size (unsorted)
  Aborted
  ```

  Backtrace with GDB + debuginfod:

  ```
  malloc(): invalid next size (unsorted)

  Thread 1 "perf" received signal SIGABRT, Aborted.
  __pthread_kill_implementation (threadid=<optimized out>, signo=signo@entry=6,
  no_tid=no_tid@entry=0) at pthread_kill.c:44
  Downloading source file /usr/src/debug/glibc/glibc/nptl/pthread_kill.c
  44            return INTERNAL_SYSCALL_ERROR_P (ret) ? INTERNAL_SYSCALL_ERRNO
  (ret) : 0;
  (gdb) bt
  #0  __pthread_kill_implementation (threadid=<optimized out>,
  signo=signo@entry=6, no_tid=no_tid@entry=0) at pthread_kill.c:44
  #1  0x00007ffff6ea8eb3 in __pthread_kill_internal (threadid=<optimized out>,
  signo=6) at pthread_kill.c:78
  #2  0x00007ffff6e50a30 in __GI_raise (sig=sig@entry=6) at ../sysdeps/posix/
  raise.c:26
  #3  0x00007ffff6e384c3 in __GI_abort () at abort.c:79
  #4  0x00007ffff6e39354 in __libc_message_impl (fmt=fmt@entry=0x7ffff6fc22ea
  "%s\n") at ../sysdeps/posix/libc_fatal.c:132
  #5  0x00007ffff6eb3085 in malloc_printerr (str=str@entry=0x7ffff6fc5850
  "malloc(): invalid next size (unsorted)") at malloc.c:5772
  #6  0x00007ffff6eb657c in _int_malloc (av=av@entry=0x7ffff6ff6ac0
  <main_arena>, bytes=bytes@entry=368) at malloc.c:4081
  #7  0x00007ffff6eb877e in __libc_calloc (n=<optimized out>,
  elem_size=<optimized out>) at malloc.c:3754
  #8  0x000055555569bdb6 in perf_session.do_write_header ()
  #9  0x00005555555a373a in __cmd_record.constprop.0 ()
  #10 0x00005555555a6846 in cmd_record ()
  #11 0x000055555564db7f in run_builtin ()
  #12 0x000055555558ed77 in main ()
  ```

  Valgrind memcheck:
  ```
  ==45136== Invalid write of size 8
  ==45136==    at 0x2B38A5: perf_event__synthesize_id_sample (in /usr/bin/perf)
  ==45136==    by 0x157069: __cmd_record.constprop.0 (in /usr/bin/perf)
  ==45136==    by 0x15A845: cmd_record (in /usr/bin/perf)
  ==45136==    by 0x201B7E: run_builtin (in /usr/bin/perf)
  ==45136==    by 0x142D76: main (in /usr/bin/perf)
  ==45136==  Address 0x6a866a8 is 0 bytes after a block of size 40 alloc'd
  ==45136==    at 0x4849BF3: calloc (vg_replace_malloc.c:1675)
  ==45136==    by 0x3574AB: zalloc (in /usr/bin/perf)
  ==45136==    by 0x1570E0: __cmd_record.constprop.0 (in /usr/bin/perf)
  ==45136==    by 0x15A845: cmd_record (in /usr/bin/perf)
  ==45136==    by 0x201B7E: run_builtin (in /usr/bin/perf)
  ==45136==    by 0x142D76: main (in /usr/bin/perf)
  ==45136==
  ==45136== Syscall param write(buf) points to unaddressable byte(s)
  ==45136==    at 0x575953D: __libc_write (write.c:26)
  ==45136==    by 0x575953D: write (write.c:24)
  ==45136==    by 0x35761F: ion (in /usr/bin/perf)
  ==45136==    by 0x357778: writen (in /usr/bin/perf)
  ==45136==    by 0x1548F7: record__write (in /usr/bin/perf)
  ==45136==    by 0x15708A: __cmd_record.constprop.0 (in /usr/bin/perf)
  ==45136==    by 0x15A845: cmd_record (in /usr/bin/perf)
  ==45136==    by 0x201B7E: run_builtin (in /usr/bin/perf)
  ==45136==    by 0x142D76: main (in /usr/bin/perf)
  ==45136==  Address 0x6a866a8 is 0 bytes after a block of size 40 alloc'd
  ==45136==    at 0x4849BF3: calloc (vg_replace_malloc.c:1675)
  ==45136==    by 0x3574AB: zalloc (in /usr/bin/perf)
  ==45136==    by 0x1570E0: __cmd_record.constprop.0 (in /usr/bin/perf)
  ==45136==    by 0x15A845: cmd_record (in /usr/bin/perf)
  ==45136==    by 0x201B7E: run_builtin (in /usr/bin/perf)
  ==45136==    by 0x142D76: main (in /usr/bin/perf)
  ==45136==
 -----

Closes: https://lore.kernel.org/linux-perf-users/23879991.0LEYPuXRzz@milian-workstation/
Reported-by: Milian Wolff <milian.wolff@kdab.com>
Tested-by: Milian Wolff <milian.wolff@kdab.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: stable@kernel.org # 6.8+
Link: https://lore.kernel.org/lkml/Zl9ksOlHJHnKM70p@x1
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/builtin-record.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -1956,8 +1956,7 @@ static void record__read_lost_samples(st
 
 				if (count.lost) {
 					if (!lost) {
-						lost = zalloc(sizeof(*lost) +
-							      session->machines.host.id_hdr_size);
+						lost = zalloc(PERF_SAMPLE_MAX_SIZE);
 						if (!lost) {
 							pr_debug("Memory allocation failed\n");
 							return;
@@ -1973,8 +1972,7 @@ static void record__read_lost_samples(st
 		lost_count = perf_bpf_filter__lost_count(evsel);
 		if (lost_count) {
 			if (!lost) {
-				lost = zalloc(sizeof(*lost) +
-					      session->machines.host.id_hdr_size);
+				lost = zalloc(PERF_SAMPLE_MAX_SIZE);
 				if (!lost) {
 					pr_debug("Memory allocation failed\n");
 					return;


