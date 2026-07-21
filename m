Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E269746DFFD;
	Tue, 21 Jul 2026 19:04:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660691; cv=none; b=CPsR90G/UYvIhvt+vYsNheAQpefNhPseFdZch1F6DvW1K1c6EtZzuClOiJ4WKTHCqJ1yF0reOJOVHgF0V9vTPGhZFPQADE97ayxg2Jum+S4hT3YLYX/oE7Nj8Or/kkZJZqi+hTr42OB9QcNtyil6q0VReDiB/PpO16ulpFAwB1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660691; c=relaxed/simple;
	bh=sDj7F0NwPP940bQ35oB580mGkCDMRWVeVTuhwKEtREQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uSFjx+oUFk9gJgcjCxd2o/IRdxbmFLFkQPMXEwViVsbXfpLeqrRhxsh/hmaDhSCVWIlxbwjhS//LuOrZnlUFB3QWWmWra7bLyYukMRwLEbw32VTSAlmk9ps8mqZXbzrNZI+lI5IBP8nqDNhJqG4CkZCv7iMthk0wB+XtareOLkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0Y5hh2To; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0Y5hh2To"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 534CB1F00A3A;
	Tue, 21 Jul 2026 19:04:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660689;
	bh=/KNK++H6v+sFsXpiKAnqTyX2AlrHcCY1TaEYvSoeG5Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0Y5hh2Tof8mujGPFwSbpAxdeEOXSPXM+iSDt+gB2GsObauYas4tAH1nBQPszD8SUj
	 Kc4idhVpe1tO0jkkYQGnTwg8qex+akmvRsmMpJSTFDpVhOvO4XDDTzGWgsgl+eHYDf
	 gDr6gRkMCpRi9CPMjW1vNNCkYhjcKyGukFLh0mEg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1076/2077] perf sched: Replace (void*)1 sentinel with proper runtime allocation
Date: Tue, 21 Jul 2026 17:12:29 +0200
Message-ID: <20260721152618.201490630@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 500f5dd0a8b6f7bd174102587c7dff5a7d2fecbf ]

map__findnew_thread() marks color-pid threads by storing (void*)1 as
the thread private data via thread__set_priv().  This sentinel value
causes two problems:

1. thread__get_runtime() returns (void*)1 as a struct thread_runtime
   pointer.  Any field access (e.g. tr->shortname) dereferences address
   1, which is an unmapped page — immediate segfault.

2. cmd_sched() registers free() as the thread priv destructor, so thread
   cleanup calls free((void*)1) — undefined behavior that corrupts the
   heap on many allocators.

Fix by adding a 'color' flag to struct thread_runtime and allocating a
real runtime struct for color-pid threads.  thread__has_color() now
checks the flag instead of relying on priv being non-NULL.

Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Fixes: 58a606149c60d5da ("perf sched: Avoid union type punning undefined behavior")
Reviewed-by: Ian Rogers <irogers@google.com>
Cc: Ian Rogers <irogers@google.com>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-sched.c | 23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 2ccda1e382930a..f6c772cde0bc94 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -274,6 +274,7 @@ struct thread_runtime {
 	u64 migrations;
 
 	int prio;
+	bool color;
 };
 
 /* per event run time data */
@@ -1596,22 +1597,32 @@ static int process_sched_wakeup_ignore(const struct perf_tool *tool __maybe_unus
 
 static bool thread__has_color(struct thread *thread)
 {
-	return thread__priv(thread) != NULL;
+	struct thread_runtime *tr = thread__priv(thread);
+
+	return tr != NULL && tr->color;
 }
 
 static struct thread*
 map__findnew_thread(struct perf_sched *sched, struct machine *machine, pid_t pid, pid_t tid)
 {
 	struct thread *thread = machine__findnew_thread(machine, pid, tid);
-	bool color = false;
 
-	if (!sched->map.color_pids || !thread || thread__priv(thread))
+	if (!sched->map.color_pids || !thread)
 		return thread;
 
-	if (thread_map__has(sched->map.color_pids, tid))
-		color = true;
+	/*
+	 * Always check the color-pids map, even if thread__priv() is
+	 * already set.  COMM events processed before the first sched_switch
+	 * allocate a thread_runtime via thread__get_runtime(), so priv is
+	 * non-NULL before we ever get here.  Skipping the check on non-NULL
+	 * priv would prevent those threads from being colored.
+	 */
+	if (thread_map__has(sched->map.color_pids, tid)) {
+		struct thread_runtime *tr = thread__get_runtime(thread);
 
-	thread__set_priv(thread, color ? ((void*)1) : NULL);
+		if (tr)
+			tr->color = true;
+	}
 	return thread;
 }
 
-- 
2.53.0



