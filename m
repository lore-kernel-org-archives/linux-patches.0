Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 285AA3B1EFC;
	Tue, 21 Jul 2026 20:38:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666323; cv=none; b=Czo7sFcqJGJg35UyBvc70BvUsEkgtI1irs/oGtDXWQmtVZCnDr5Dxvq4VA5LPYHQTWEH3RLnSqJlXp0ZvQXKMNygEO8R4I7dNcAbmyJv78kNrAMAytKM/WrK1yxoKU6vuyjjY+Y2qrP8wkjnztG4Q20WuGaJrc84buaN8BYa3AI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666323; c=relaxed/simple;
	bh=lfdGjObl9EdyrG2IrRbk8J7x/tOLqXtdNb7Gz4EhU+A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=up39M38IPbaBabmaMCfaCoIYY6A7Ns1Pzz9jmKH1OeQWhlBEEezB4IEq1epUSZtbvg/R0GxBnAq05YsQx1FqWb7uQwT3mzIDtGDFtnWXAVvcnjleg1PddSUhFssh2ot8gh03pREHvPMt8scQOtis+k5lSIOvRY5Y+a4adueFoYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WaaxlgeB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WaaxlgeB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68D4C1F000E9;
	Tue, 21 Jul 2026 20:38:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666321;
	bh=RC2/kb1Zu3Xv3dRRtAIGXN8+XtvwMYYScv60wcUCMvM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WaaxlgeB5Cj33tQg345swmEMHt0vEfGCvG8DM+J6Bu82of39sdw+lbpvlbcXtM7E2
	 L1e256iP8dCugj15fcja92nI6KtS71+DBLHTKxXcOkl//fWWccfVB3OT62enkJIgNt
	 Lt2VdjjsixAlk5B8rJQepGcLxmh77rUfQPeFbc0E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	sashiko-bot@kernel.org
Subject: [PATCH 6.6 0637/1266] perf sched: Replace BUG_ON on invalid CPU with graceful skip
Date: Tue, 21 Jul 2026 17:17:54 +0200
Message-ID: <20260721152456.109948111@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 1e2c83f732deb329ebce23e26cbc482f4c4bf194 ]

latency_switch_event(), latency_runtime_event(), and map_switch_event()
use BUG_ON(cpu >= MAX_CPUS || cpu < 0) to validate the sample CPU.
When PERF_SAMPLE_CPU is absent from the sample type,
evsel__parse_sample() initializes sample->cpu to (u32)-1.  Casting
this to int yields -1, which triggers the BUG_ON and aborts perf sched.

The central CPU validation in perf_session__deliver_event() intentionally
preserves the (u32)-1 sentinel for downstream tools like perf script
and perf inject, so leaf callbacks must handle it themselves.

Replace the three BUG_ON calls with graceful skips using pr_warning(),
matching the existing pattern in process_sched_switch_event() and
process_sched_runtime_event() earlier in the same file.  Include the
file offset for cross-referencing with perf report -D.

Reported-by: sashiko-bot@kernel.org # Running on a local machine
Reviewed-by: Ian Rogers <irogers@google.com>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Stable-dep-of: 8cbca8a480e1 ("perf sched: Fix NULL dereference in latency_runtime_event")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-sched.c | 22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 942fde8a1d52e3..9e9bb19f0bc98b 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -1154,7 +1154,12 @@ static int latency_switch_event(struct perf_sched *sched,
 	int cpu = sample->cpu, err = -1;
 	s64 delta;
 
-	BUG_ON(cpu >= MAX_CPUS || cpu < 0);
+	/* perf.data is untrusted input — CPU may be absent or corrupted */
+	if (cpu >= MAX_CPUS || cpu < 0) {
+		pr_warning("WARNING: at offset %#" PRIx64 ": out-of-bound sample CPU %d, skipping sample\n",
+			   sample->file_offset, cpu);
+		return 0;
+	}
 
 	timestamp0 = sched->cpu_last_switched[cpu];
 	sched->cpu_last_switched[cpu] = timestamp;
@@ -1225,7 +1230,13 @@ static int latency_runtime_event(struct perf_sched *sched,
 	if (thread == NULL)
 		return -1;
 
-	BUG_ON(cpu >= MAX_CPUS || cpu < 0);
+	/* perf.data is untrusted input — CPU may be absent or corrupted */
+	if (cpu >= MAX_CPUS || cpu < 0) {
+		pr_warning("WARNING: at offset %#" PRIx64 ": out-of-bound sample CPU %d, skipping sample\n",
+			   sample->file_offset, cpu);
+		err = 0;
+		goto out_put;
+	}
 	if (!atoms) {
 		if (thread_atoms_insert(sched, thread))
 			goto out_put;
@@ -1596,7 +1607,12 @@ static int map_switch_event(struct perf_sched *sched, struct evsel *evsel,
 	const char *color = PERF_COLOR_NORMAL;
 	char stimestamp[32];
 
-	BUG_ON(this_cpu.cpu >= MAX_CPUS || this_cpu.cpu < 0);
+	/* perf.data is untrusted input — CPU may be absent or corrupted */
+	if (this_cpu.cpu >= MAX_CPUS || this_cpu.cpu < 0) {
+		pr_warning("WARNING: at offset %#" PRIx64 ": out-of-bound sample CPU %d, skipping sample\n",
+			   sample->file_offset, this_cpu.cpu);
+		return 0;
+	}
 
 	if (this_cpu.cpu > sched->max_cpu.cpu)
 		sched->max_cpu = this_cpu;
-- 
2.53.0



