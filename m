Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA79619E7F7;
	Sat, 12 Sep 2026 08:17:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201073; cv=none; b=Dsc/PmkNFjZp7pwlvvlFnUS9pmQZhqrVj9jTbyuyNxsh5qH0HkAh7Cu6n9k/uBmSPXWveVGCRuG6LlzGTU2oUr2KDC6pjuHkv8CmAN73gkyIBlZgvXxLTwqiCV4G+zdGS29ZjescU1EZ3OWOj54jfhWcbIcyupVAAD71lLld4JE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201073; c=relaxed/simple;
	bh=zoZO6hCalyXIEBCZd4GdAiL3m1F2+TxAGO+NDHv88og=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WnEkqYHV5DkwH/0oo2C8NhbFikgb6BoFbsoKcXnP1tJMgAOBDuvO4V+XFDiFP/+8PoETDo73JlfeXo4NjDMWdwGGdoTMUwP4X0vdJCTUTfQA9NAkdfv2LaysWrnzBGsE+zPLBVeJzbBKDELiKgLaAe/VulH8zSzYMNJ9xK2T9+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sfS7i+pq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sfS7i+pq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63CC41F000FF;
	Sat, 12 Sep 2026 08:17:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201072;
	bh=JPrx7T5t01HxhtM38JzPCutZFtLLVnDo6fRgkczy13c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sfS7i+pqEYnWDQCZ9YEqINm7+TvmvluevKTBswfS1IRChsNVrOKiSa4XYLJxCdX90
	 MCXK1NUODq0jOM6E8XA33w6HwodYlJqdqzkMcWs7Fxnmp+tNj2M1uP203LnHqxcahd
	 5k0/boYqWbd+C3hGteGv8bPtgF+Mix3KgkPLO4Ws=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alessio Podda <aleph.pi.gh@gmail.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0922/1815] perf unwind-libdw: Fix unwinding of multi-threaded processes
Date: Sat, 12 Sep 2026 08:44:32 +0200
Message-ID: <20260912065710.576906009@linuxfoundation.org>
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

From: Alessio Podda <aleph.pi.gh@gmail.com>

[ Upstream commit f2effca1ef5d30b1ead61d74faea5e251f604a26 ]

The libdw callback API has two levels: dwfl_getthread_frames() first finds
the requested thread using the next_thread() or get_thread() callback and
then walks its stack.

Since perf only has a snapshot of the stack of a single thread, it
provides a stubbed-out API that always returns the pid the Dwfl was
attached with (i.e. whatever was passed to dwfl_attach_state()), rather
than the actual sampled thread's TID.

Commit 6b2658b3f36a ("perf unwind-libdw: Don't discard loaded ELF/DWARF
after every unwind") changed libdw unwinding from recreating the Dwfl
object for each sample to caching it in struct maps, which is shared by
every thread in the process. It left next_thread() unchanged.

Since the pid passed to dwfl_attach_state() is only set at creation, only
the thread of the first sample is ever found. As a result,
dwfl_getthread_frames() fails with ESRCH when asked to unwind a sample
from another thread.

Make next_thread() return the current sample's TID, provide get_thread()
so libdw can find it directly, and pass the process PID expected by
dwfl_attach_state(). This allows libdw to unwind samples from every thread
in a multi-threaded process.

Add a shell regression test that records a four-thread workload and
verifies that libdw recovers the worker callchain for every worker TID.

Fixes: 6b2658b3f36a ("perf unwind-libdw: Don't discard loaded ELF/DWARF after every unwind")
Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Alessio Podda <aleph.pi.gh@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../shell/test_dwarf_unwind_multithreaded.sh  | 65 +++++++++++++++++++
 tools/perf/util/unwind-libdw.c                | 24 ++++++-
 2 files changed, 86 insertions(+), 3 deletions(-)
 create mode 100755 tools/perf/tests/shell/test_dwarf_unwind_multithreaded.sh

diff --git a/tools/perf/tests/shell/test_dwarf_unwind_multithreaded.sh b/tools/perf/tests/shell/test_dwarf_unwind_multithreaded.sh
new file mode 100755
index 0000000000000..49e6e3af771f4
--- /dev/null
+++ b/tools/perf/tests/shell/test_dwarf_unwind_multithreaded.sh
@@ -0,0 +1,65 @@
+#!/bin/sh
+# SPDX-License-Identifier: GPL-2.0
+# Test libdw unwinding of multi-threaded processes (exclusive)
+
+set -e
+
+if ! perf check feature -q libdw-dwarf-unwind; then
+	echo "Skip: libdw DWARF unwinding is not available"
+	exit 2
+fi
+
+tmpdir=$(mktemp -d /tmp/perf-test-dwarf-unwind-multithreaded.XXXXXX)
+perf_data="$tmpdir/perf.data"
+perf_script="$tmpdir/perf-script.txt"
+nr_threads=4
+nr_worker_threads=$((nr_threads - 1))
+
+cleanup()
+{
+	trap - EXIT TERM INT
+	rm -rf "$tmpdir"
+}
+
+trap cleanup EXIT TERM INT
+
+if ! perf record -q -e task-clock:u -F 99 --call-graph dwarf,8192 \
+	-o "$perf_data" -- perf test -w thloop 2 "$nr_threads"
+then
+	echo "Skip: failed to record task-clock:u"
+	exit 2
+fi
+
+if ! perf script --unwind-style=libdw \
+	-F comm,pid,tid,event,ip,sym -i "$perf_data" > "$perf_script"
+then
+	echo "Error: failed to process the recording with libdw" >&2
+	exit 1
+fi
+
+nr_unwound_threads=$(
+	awk '
+		BEGIN { RS = "" }
+
+		# thfunc is the worker-only caller of test_loop. Finding it proves
+		# that libdw unwound beyond the sampled leaf for this worker TID.
+		/thfunc/ {
+			split($2, id, "/")
+			seen[id[2]] = 1
+		}
+
+		END {
+			for (tid in seen)
+				nr_tids++
+			print nr_tids + 0
+		}
+	' "$perf_script"
+)
+
+if [ "$nr_unwound_threads" -ne "$nr_worker_threads" ]; then
+	echo "Error: expected callchains for $nr_worker_threads worker TIDs," \
+		"found $nr_unwound_threads" >&2
+	exit 1
+fi
+
+exit 0
diff --git a/tools/perf/util/unwind-libdw.c b/tools/perf/util/unwind-libdw.c
index 7f35042be5677..63a5c2253174f 100644
--- a/tools/perf/util/unwind-libdw.c
+++ b/tools/perf/util/unwind-libdw.c
@@ -1,4 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
+#include <assert.h>
 #include <linux/compiler.h>
 #include <elfutils/libdw.h>
 #include <elfutils/libdwfl.h>
@@ -173,14 +174,30 @@ static int entry(u64 ip, struct unwind_info *ui)
 	return 0;
 }
 
-static pid_t next_thread(Dwfl *dwfl, void *arg, void **thread_argp)
+static pid_t next_thread(Dwfl *dwfl __maybe_unused, void *arg, void **thread_argp)
 {
+	struct dwfl_ui_thread_info *dwfl_ui_ti = arg;
+
 	/* We want only single thread to be processed. */
 	if (*thread_argp != NULL)
 		return 0;
 
+	assert(dwfl_ui_ti->ui != NULL);
 	*thread_argp = arg;
-	return dwfl_pid(dwfl);
+	return thread__tid(dwfl_ui_ti->ui->thread);
+}
+
+static bool get_thread(Dwfl *dwfl __maybe_unused, pid_t tid, void *arg,
+		       void **thread_argp)
+{
+	struct dwfl_ui_thread_info *dwfl_ui_ti = arg;
+
+	assert(dwfl_ui_ti->ui != NULL);
+	if (tid != thread__tid(dwfl_ui_ti->ui->thread))
+		return false;
+
+	*thread_argp = arg;
+	return true;
 }
 
 static int access_dso_mem(struct unwind_info *ui, Dwarf_Addr addr,
@@ -306,6 +323,7 @@ static bool libdw_set_initial_registers(Dwfl_Thread *thread, void *arg)
 
 static const Dwfl_Thread_Callbacks callbacks = {
 	.next_thread           = next_thread,
+	.get_thread            = get_thread,
 	.memory_read           = memory_read,
 	.set_initial_registers = libdw_set_initial_registers,
 };
@@ -400,7 +418,7 @@ int libdw__get_entries(unwind_entry_cb_t cb, void *arg,
 	if (err)
 		goto out;
 
-	dwfl_attach_state(dwfl, /*elf=*/NULL, thread__tid(thread), &callbacks,
+	dwfl_attach_state(dwfl, /*elf=*/NULL, thread__pid(thread), &callbacks,
 			  /* Dwfl thread function argument*/dwfl_ui_ti);
 	// Ignore thread already attached error.
 
-- 
2.53.0



