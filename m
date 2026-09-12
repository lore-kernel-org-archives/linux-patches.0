Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0E2737E5CD;
	Sat, 12 Sep 2026 07:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197337; cv=none; b=TcWKEnUUp+PUDZS0S+LoZrxdhv/3TRJWs4WlFLhmvZerHWKOfNO1exwn2YBv93ROQ7QzmmR1C6faFE/EohyjE1SlQbN1f8GKbKuOK1d/N1L9pLIq8e4RXY+ljM70asarhws/wuAAUZL2qmWhHtkbQArXNdsQcXkOjtQL/33LuYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197337; c=relaxed/simple;
	bh=7MAAvLJ774wh9OYtn8QepnwOyj0TzHyGzJoOehXyyqQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CfZV6/6A+tRtph2het92jt81pO5HkZHP9VwG5ZO9eUOGeGfgf+DKLEjVMRlzIwotV0LglN51YL9KT/CUKLtVDnQ13cLKtkEK+TFapnhKuO7iyVGbO7D8mKbjztMk2Mry9DK1odp+butI6QHOdxIjdRbLwgEcANQ+1bKX/VsoKd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Uiv/aDDn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Uiv/aDDn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48A461F000FF;
	Sat, 12 Sep 2026 07:15:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197335;
	bh=A/l3mrNu8GxLuLe7h8TcyF4lXIQrW2kXFohtFTcnVEI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Uiv/aDDnm5XbHpTDy/gOgcxnI6D9Wo4kBxeqqJys3MST47/Aga3aetMQTWzpDer7T
	 LKxCEssfpUiXVxcLJt2Gon/yb1zvU5zz1sug1i6g2iyWYKjhfBl/PTT7XwiTzbAFeA
	 jAj7b90yEMGieFbr0kP80DIk4csK66Q5qlQkzeoI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0136/1815] perf tests: Fix flakiness in trace record and replay test
Date: Sat, 12 Sep 2026 08:31:26 +0200
Message-ID: <20260912065652.208912999@linuxfoundation.org>
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

From: Ian Rogers <irogers@google.com>

[ Upstream commit 509a2b9a6e142697dd5f34cdd802e5b86eababa1 ]

The `perf trace record and replay` test fails intermittently on slow or
virtualized hosts because the default recording workload (`sleep 1`)
occasionally completes without scheduling the target `nanosleep` or
`clock_nanosleep` system calls inside the recorded sample window,
resulting in the error: `Failed: cannot find *nanosleep syscall`.

Generalize the `perf_record_with_retry` helper in
`tests/shell/lib/perf_record.sh` to support a custom record command prefix
via the `PERF_RECORD_CMD` environment variable (defaulting to "perf
record").

Update `trace_record_replay.sh` to use this robust retry loop running with
`PERF_RECORD_CMD="perf trace record"` and a base workload of `sleep`. The
test will automatically retry with scaled sleep durations (from 0.01s up
to 2.0s) until the required `nanosleep` event is successfully captured.

Fixes: 15bcfb96d0dd ("perf test: Add trace record and replay test")
Assisted-by: Antigravity:gemini-3.1-pro
Signed-off-by: Ian Rogers <irogers@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/shell/lib/perf_record.sh     |  7 +++-
 tools/perf/tests/shell/trace_record_replay.sh | 38 +++++++++++++++++--
 2 files changed, 40 insertions(+), 5 deletions(-)

diff --git a/tools/perf/tests/shell/lib/perf_record.sh b/tools/perf/tests/shell/lib/perf_record.sh
index e137fa75370de..2b9e11b66dc7a 100644
--- a/tools/perf/tests/shell/lib/perf_record.sh
+++ b/tools/perf/tests/shell/lib/perf_record.sh
@@ -24,9 +24,14 @@ perf_record_with_retry() {
   local duration
   local first_run=true
   local ret=1
+  local cmd_prefix="perf record"
+  if [ -n "${PERF_RECORD_CMD}" ]; then
+    cmd_prefix="${PERF_RECORD_CMD}"
+  fi
+
   for duration in 0.01 0.1 0.3 1.0 2.0; do
     rm -f "${perfdata}".old
-    perf record "$@" -o "${perfdata}" ${testprog_base} ${duration} > "$logfile" 2>&1
+    ${cmd_prefix} "$@" -o "${perfdata}" ${testprog_base} ${duration} > "$logfile" 2>&1
     local record_exit=$?
 
     if [ "$first_run" = true ] && [ $record_exit -ne 0 ]; then
diff --git a/tools/perf/tests/shell/trace_record_replay.sh b/tools/perf/tests/shell/trace_record_replay.sh
index 88d30a03dcecb..38fcafcdfb91c 100755
--- a/tools/perf/tests/shell/trace_record_replay.sh
+++ b/tools/perf/tests/shell/trace_record_replay.sh
@@ -6,16 +6,46 @@
 
 # shellcheck source=lib/probe.sh
 . "$(dirname $0)"/lib/probe.sh
+# shellcheck source=lib/perf_record.sh
+. "$(dirname $0)"/lib/perf_record.sh
 
 skip_if_no_perf_trace || exit 2
 [ "$(id -u)" = 0 ] || exit 2
 
 file=$(mktemp /tmp/temporary_file.XXXXX)
+err=0
 
-perf trace record -o ${file} sleep 1 || exit 1
-if ! perf trace -i ${file} 2>&1 | grep nanosleep; then
-	echo "Failed: cannot find *nanosleep syscall"
+cleanup() {
+	rm -f ${file}
+	perf_record_cleanup
+	trap - EXIT INT TERM
+}
+
+trap_cleanup() {
+	echo "Unexpected signal in ${FUNCNAME[1]}"
+	cleanup
+	exit 1
+}
+trap trap_cleanup EXIT INT TERM
+
+check_nanosleep() {
+  perf trace -i "${file}" 2>&1 | grep -q nanosleep
+}
+
+PERF_RECORD_CMD="perf trace record" perf_record_with_retry "${file}" "check_nanosleep" "sleep"
+err=$?
+
+if [ $err -ne 0 ]; then
+	if [ $err -eq 2 ]; then
+		logfile="${PERF_RECORD_LOGS[${#PERF_RECORD_LOGS[@]}-1]}"
+		echo "perf trace record failed. Log output:"
+		cat "$logfile"
+	else
+		echo "Failed: cannot find *nanosleep syscall"
+	fi
+	cleanup
 	exit 1
 fi
 
-rm -f ${file}
+cleanup
+exit 0
-- 
2.53.0



