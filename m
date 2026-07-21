Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5CFB47127D;
	Tue, 21 Jul 2026 18:11:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657480; cv=none; b=dg7n5hLpjJ2Vvz8ptGbwg2hX54s10r95YUiz7+DplA9zz2XmAPvJt7dhVD6sTmJyBh+TvrRwLHeiJxebiTIw4CeeW5sYHnDo6bQyUxWUgFG7qLUUqm16kTvGUov7E7CNvgKL75OuK/A4scmGLPKpx7T6WqcIW0OWvZiZ3WZKPWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657480; c=relaxed/simple;
	bh=pFmq6kvpSPwbc49uVfxZM5DMeLqagtDFd9gi3cr26Rk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=omQJkzbjqI5yznhOzqCMX9qoeJWflRdgzjSS/rwRteh51aaZD1ZP7c/6tfq12YTI//1b0uKybV44igzlARhI3poZ1bMPzCevII8eVA2WndvEKcbqxDptry0UABAg8834HuAFvopi2kfpVlGLDGDIa7RCoB+bnb0vErgGexkvRhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oNGnToFG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oNGnToFG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47D3D1F000E9;
	Tue, 21 Jul 2026 18:11:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657478;
	bh=so4Ja2xQUrZbWC/y+CRtXL3h3J7h1Xh/Qr/oEFPUnwo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oNGnToFGMCehK9fBgj9vq0/XKTzAs78xMutxIG/n1SUMVyI+4p3VJyGCEQlXy0oJU
	 2Q3BFY5ib+/L1O2jTqQf7uAsPqTRzts7VpEcQbKnjX/d5G6hj2tH7xTb57y0mea1h8
	 9uOG/gG8rk3aYv0FaS/xDA11PhZMLouyBR8GdZfs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0779/1611] perf sched: Replace (void*)1 sentinel with proper runtime allocation
Date: Tue, 21 Jul 2026 17:14:55 +0200
Message-ID: <20260721152532.907517636@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 00d52816185f69..8732b1960687ab 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -267,6 +267,7 @@ struct thread_runtime {
 	u64 migrations;
 
 	int prio;
+	bool color;
 };
 
 /* per event run time data */
@@ -1589,22 +1590,32 @@ static int process_sched_wakeup_ignore(const struct perf_tool *tool __maybe_unus
 
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



