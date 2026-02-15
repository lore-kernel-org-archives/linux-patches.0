Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01F8F3EBF02;
	Sun, 15 Feb 2026 15:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771167823; cv=none; b=m4+x4JMVNFJ55J4ZmrbxXSlZ/5nqPNA5TfP+3Q0u2NodylSO66kKwMKf8D525x67tnl18ylOd4rH3awGbJQzLs+eqHtYvZGKI9LSWVSiYHOYFIM9zBvCbXEBbr73gb/psJaKgsPS6vEXLrkWAXFyD0cQ0bnNMKWN/69/HmtDZAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771167823; c=relaxed/simple;
	bh=CgOewkKnli+2mA0CTW36L4EEgHvgmDxVWvqOtfxl6KA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uAhpBkgIWX3V2PK8N06vidT9GjrJgDb4LXuTOIdt7z2o+sD19g+TcHYT14fAN5yQmxAwKzfAyJmzly726opv/xryjCHV2hEtgq67p/CXNMmys34j3aqmy2Su1qZ2FSQbd8BB4r54LVBoI3UNcbEj8v++w/aRYYGFmlXdvOQLGzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oh8sEdnH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oh8sEdnH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED5CAC19422;
	Sun, 15 Feb 2026 15:03:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771167822;
	bh=CgOewkKnli+2mA0CTW36L4EEgHvgmDxVWvqOtfxl6KA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oh8sEdnHnTe/4YTfR/VmxVj7Oku90Kwic+Y47iQr333AG7FSE5c/9onhOGKDtC+a8
	 1OF7ajmVAKTTsOcxxmPmG3e2obohdJWK3QGE78K6qPN6hCaPEs5uPa8+3YEx8In7QW
	 kqWwXZlvFayCtcslJJQXF2BC7CSEWQ7CJAf7Qv7E/JOPgTV+GHwV3kcrBF3kKC/Vfw
	 NtmWWhizN392VTfcHG6ltbNi/Dy+MBzPOyYYbfZ+5C4sAPC6ggiF4PwfXxbnwbothq
	 ZER0XMbP0DnIVbl3b9YaIxVDCYDw4tNkxo/L1V5vUv8kucRoXt0l8fd0AAZw9BQe4R
	 cpn6RZixKc47w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Colin Lord <clord@mykolab.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-5.15] tracing: Fix false sharing in hwlat get_sample()
Date: Sun, 15 Feb 2026 10:03:23 -0500
Message-ID: <20260215150333.2150455-6-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260215150333.2150455-1-sashal@kernel.org>
References: <20260215150333.2150455-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Colin Lord <clord@mykolab.com>

[ Upstream commit f743435f988cb0cf1f521035aee857851b25e06d ]

The get_sample() function in the hwlat tracer assumes the caller holds
hwlat_data.lock, but this is not actually happening. The result is
unprotected data access to hwlat_data, and in per-cpu mode can result in
false sharing which may show up as false positive latency events.

The specific case of false sharing observed was primarily between
hwlat_data.sample_width and hwlat_data.count. These are separated by
just 8B and are therefore likely to share a cache line. When one thread
modifies count, the cache line is in a modified state so when other
threads read sample_width in the main latency detection loop, they fetch
the modified cache line. On some systems, the fetch itself may be slow
enough to count as a latency event, which could set up a self
reinforcing cycle of latency events as each event increments count which
then causes more latency events, continuing the cycle.

The other result of the unprotected data access is that hwlat_data.count
can end up with duplicate or missed values, which was observed on some
systems in testing.

Convert hwlat_data.count to atomic64_t so it can be safely modified
without locking, and prevent false sharing by pulling sample_width into
a local variable.

One system this was tested on was a dual socket server with 32 CPUs on
each numa node. With settings of 1us threshold, 1000us width, and
2000us window, this change reduced the number of latency events from
500 per second down to approximately 1 event per minute. Some machines
tested did not exhibit measurable latency from the false sharing.

Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Link: https://patch.msgid.link/20260210074810.6328-1-clord@mykolab.com
Signed-off-by: Colin Lord <clord@mykolab.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis of the Commit

### 1. Commit Message Analysis

The commit message is very detailed and clearly describes:
- **The bug**: `get_sample()` assumes `hwlat_data.lock` is held, but
  it's not actually held. This leads to unprotected data access and
  false sharing in per-cpu mode.
- **The specific false sharing**: `hwlat_data.sample_width` and
  `hwlat_data.count` are 8 bytes apart, likely sharing a cache line.
  When one thread modifies `count`, other threads reading `sample_width`
  in the latency detection loop fetch the modified cache line, causing
  measurable latency.
- **The self-reinforcing cycle**: The latency from cache line fetch
  triggers a latency event, which increments `count`, which causes more
  cache line invalidation, which causes more latency events — a vicious
  cycle.
- **The data race**: `hwlat_data.count` can end up with duplicate or
  missed values due to unprotected concurrent access.
- **Concrete test results**: On a dual-socket 32-CPUs-per-node server,
  latency events dropped from 500/sec to ~1/min.

Keywords: "false sharing", "false positive latency events", "unprotected
data access", "duplicate or missed values."

### 2. Code Change Analysis

The changes are minimal and surgical:

1. **`hwlat_data.count` converted from `u64` to `atomic64_t`**: This
   fixes a real data race where multiple threads could concurrently
   increment `count` without synchronization, leading to lost updates
   (duplicate/missed values). The `atomic64_inc_return()` replaces
   `hwlat_data.count++; s.seqnum = hwlat_data.count;` with a single
   atomic operation.

2. **`sample_width` pulled into a local variable with `READ_ONCE()`**:
   `u64 sample_width = READ_ONCE(hwlat_data.sample_width);` is used
   instead of reading `hwlat_data.sample_width` in the hot loop (`do {
   ... } while (total <= sample_width)`). This:
   - Prevents the CPU from repeatedly fetching a cache line that may be
     bouncing between cores
   - Eliminates the false sharing between `sample_width` and `count`
   - Uses `READ_ONCE()` for proper load semantics

3. **Init path updated**: `hwlat_data.count = 0` →
   `atomic64_set(&hwlat_data.count, 0)` — consistent with the type
   change.

4. **Comment fix**: Removes the incorrect claim that `get_sample()` is
   "called with hwlat_data.lock held."

### 3. Bug Classification

This commit fixes **multiple real bugs**:

1. **Data race on `hwlat_data.count`**: Concurrent unsynchronized access
   to a shared counter. This is a real correctness bug — sequence
   numbers can be duplicated or skipped.

2. **False sharing causing false positive latency detection**: The hwlat
   tracer is producing bogus results (500 events/sec vs 1/min). This is
   a **functional correctness bug** — the tracer is reporting phantom
   hardware latency that doesn't exist. Users relying on hwlat tracer
   results would be misled.

3. **Self-reinforcing feedback loop**: The false sharing creates a
   pathological cycle that makes the tracer practically unusable on some
   multi-socket systems.

### 4. Scope and Risk Assessment

- **Lines changed**: ~15 lines of actual code changes across 4 hunks in
  a single file
- **Files touched**: 1 (`kernel/trace/trace_hwlat.c`)
- **Risk**: Very low. The changes are:
  - Converting a counter to atomic (well-understood primitive)
  - Caching a value in a local variable (safe, the value doesn't need to
    be re-read)
  - Using `READ_ONCE()` (standard kernel pattern)
- **Subsystem**: Tracing — self-contained, well-maintained by Steven
  Rostedt
- **Could it break something?**: Extremely unlikely. The atomic64
  operations are well-tested primitives, and caching sample_width is
  semantically equivalent (the width doesn't change during a sample).

### 5. User Impact

- **Who is affected**: Anyone using the hwlat tracer in per-cpu mode on
  multi-socket systems
- **Severity**: The tracer produces wildly incorrect results (500x false
  positives) on affected systems
- **Real-world impact**: Users trying to validate hardware latency
  characteristics for real-time workloads would get completely
  misleading data
- **The data race on count**: Could cause sequence number issues that
  affect trace analysis tooling

### 6. Stability Indicators

- **Signed-off by Steven Rostedt** (tracing subsystem maintainer) — high
  confidence
- **Concrete test data** provided showing dramatic improvement
- **Link to mailing list** discussion provided
- The fix uses standard kernel primitives (atomic64_t, READ_ONCE) —
  well-understood patterns

### 7. Dependency Check

- No dependencies on other commits
- `atomic64_t` and `READ_ONCE()` are available in all stable kernel
  versions
- The hwlat tracer exists in all recent stable trees (introduced in
  v4.9)

### Stable Kernel Rules Assessment

1. **Obviously correct and tested**: Yes — tested on real hardware with
   measurable improvement
2. **Fixes a real bug**: Yes — data race + false sharing causing
   incorrect tracer output
3. **Important issue**: Yes — tracer producing 500x false positive
   latency events, plus data race on counter
4. **Small and contained**: Yes — ~15 lines in one file
5. **No new features**: Correct — this is a pure bug fix
6. **Applies cleanly**: Should apply cleanly to recent stable trees

### Risk vs Benefit

- **Risk**: Near zero — atomic counter and local variable caching are
  trivially safe changes
- **Benefit**: High — fixes a data race and makes the hwlat tracer
  produce correct results on multi-socket systems

**YES**

 kernel/trace/trace_hwlat.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/kernel/trace/trace_hwlat.c b/kernel/trace/trace_hwlat.c
index 2f7b94e98317c..3fe274b84f1c2 100644
--- a/kernel/trace/trace_hwlat.c
+++ b/kernel/trace/trace_hwlat.c
@@ -102,9 +102,9 @@ struct hwlat_sample {
 /* keep the global state somewhere. */
 static struct hwlat_data {
 
-	struct mutex lock;		/* protect changes */
+	struct mutex	lock;		/* protect changes */
 
-	u64	count;			/* total since reset */
+	atomic64_t	count;		/* total since reset */
 
 	u64	sample_window;		/* total sampling window (on+off) */
 	u64	sample_width;		/* active sampling portion of window */
@@ -193,8 +193,7 @@ void trace_hwlat_callback(bool enter)
  * get_sample - sample the CPU TSC and look for likely hardware latencies
  *
  * Used to repeatedly capture the CPU TSC (or similar), looking for potential
- * hardware-induced latency. Called with interrupts disabled and with
- * hwlat_data.lock held.
+ * hardware-induced latency. Called with interrupts disabled.
  */
 static int get_sample(void)
 {
@@ -204,6 +203,7 @@ static int get_sample(void)
 	time_type start, t1, t2, last_t2;
 	s64 diff, outer_diff, total, last_total = 0;
 	u64 sample = 0;
+	u64 sample_width = READ_ONCE(hwlat_data.sample_width);
 	u64 thresh = tracing_thresh;
 	u64 outer_sample = 0;
 	int ret = -1;
@@ -267,7 +267,7 @@ static int get_sample(void)
 		if (diff > sample)
 			sample = diff; /* only want highest value */
 
-	} while (total <= hwlat_data.sample_width);
+	} while (total <= sample_width);
 
 	barrier(); /* finish the above in the view for NMIs */
 	trace_hwlat_callback_enabled = false;
@@ -285,8 +285,7 @@ static int get_sample(void)
 		if (kdata->nmi_total_ts)
 			do_div(kdata->nmi_total_ts, NSEC_PER_USEC);
 
-		hwlat_data.count++;
-		s.seqnum = hwlat_data.count;
+		s.seqnum = atomic64_inc_return(&hwlat_data.count);
 		s.duration = sample;
 		s.outer_duration = outer_sample;
 		s.nmi_total_ts = kdata->nmi_total_ts;
@@ -832,7 +831,7 @@ static int hwlat_tracer_init(struct trace_array *tr)
 
 	hwlat_trace = tr;
 
-	hwlat_data.count = 0;
+	atomic64_set(&hwlat_data.count, 0);
 	tr->max_latency = 0;
 	save_tracing_thresh = tracing_thresh;
 
-- 
2.51.0

