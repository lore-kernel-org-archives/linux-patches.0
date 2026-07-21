Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 689553770B;
	Tue, 21 Jul 2026 20:39:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666352; cv=none; b=g0xEgCSr9jHniqsP04nOVIzZSNJs/axaTD1duOjWKndMydFIgIqsQA++/2s6uIz7dVj4cg18CDw0N6ie77ciUmLTLPA0tDxj9clR46l5lr0anJxN/AAzMPatWv5BxbDdqfSqLY4eQqPZnFY3jBfhBtipKzWl/X0u2l4FqmARz1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666352; c=relaxed/simple;
	bh=HVk33YruvtH+o6YesLYtBHGEtkYLsEI9m3O3vGbzfrk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=knn0dfgxK4dVM6MbTaE2IU5cXhOYDbDskktzs8DiXVmIwIM8Js2BfwwQIqB+zp4RDPBvfcBzZWuvE878lCEzLivN0gmwiV86vOF/fNMiTymtMiStsqvBpi4iBPwFyiWLK3PHvtHoZRP/NTT8rcgdwTm5UvxS05ekY39TFzPhSuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nec+/Cyq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nec+/Cyq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E9221F000E9;
	Tue, 21 Jul 2026 20:39:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666351;
	bh=eHlxCWM9QTveP1W4CR5uQt+j2FsCB+jRJ8WMoMEirQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nec+/CyqSavOGC/CPX6+bjTM8E3WMcoMnT++Do/vNvwViOwCrJhQO20nvuuAO2cXZ
	 oASLgYsk6SVJWopLrWfm7WJvneansc03+t8hqswxJgHW7XX6nZRUNpX8e7omdvm1cE
	 BC30iDGr5jmU/au0rjwj1v3o+yMyM+Gcbsj0J64A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ingo Molnar <mingo@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0643/1266] perf sched: Replace BUG_ON and add NULL checks in replay event helpers
Date: Tue, 21 Jul 2026 17:18:00 +0200
Message-ID: <20260721152456.248668348@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 75eafe4a3a93a0143a20c0cc286bfb9008ac1478 ]

get_new_event() has three issues:

1. The zalloc() result is dereferenced without a NULL check, crashing
   on allocation failure.

2. BUG_ON(!task->atoms) kills the process when realloc() fails.
   Since perf.data is untrusted input, this should be a graceful error.

3. The realloc pattern assigns directly to task->atoms, losing the old
   pointer on failure.  task->nr_events is also incremented before the
   realloc, leaving corrupted state on failure.

Fix get_new_event() to:
  - Check the zalloc() result before dereferencing
  - Use a temporary for realloc() to avoid losing the old pointer
  - Increment nr_events only after successful realloc
  - Return NULL instead of calling BUG_ON on failure

Also fix add_sched_event_wakeup() where zalloc() for wait_sem is
passed to sem_init() without a NULL check.

Update all callers (add_sched_event_run, add_sched_event_wakeup,
add_sched_event_sleep) to handle NULL returns by returning early.
The replay may produce incomplete output on OOM but will not crash.

Fixes: ec156764d424 ("perf sched: Import schedbench.c")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-sched.c | 28 +++++++++++++++++++++++++---
 1 file changed, 25 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 0a1a58f33ae651..8b1573515c5781 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -363,14 +363,25 @@ get_new_event(struct task_desc *task, u64 timestamp)
 	struct sched_atom *event = zalloc(sizeof(*event));
 	unsigned long idx = task->nr_events;
 	size_t size;
+	struct sched_atom **atoms_p;
+
+	if (event == NULL) {
+		pr_err("ERROR: sched: failed to allocate event\n");
+		return NULL;
+	}
 
 	event->timestamp = timestamp;
 	event->nr = idx;
 
+	size = sizeof(struct sched_atom *) * (task->nr_events + 1);
+	atoms_p = realloc(task->atoms, size);
+	if (!atoms_p) {
+		pr_err("ERROR: sched: failed to grow atoms array\n");
+		free(event);
+		return NULL;
+	}
+	task->atoms = atoms_p;
 	task->nr_events++;
-	size = sizeof(struct sched_atom *) * task->nr_events;
-	task->atoms = realloc(task->atoms, size);
-	BUG_ON(!task->atoms);
 
 	task->atoms[idx] = event;
 
@@ -401,6 +412,8 @@ static void add_sched_event_run(struct perf_sched *sched, struct task_desc *task
 	}
 
 	event = get_new_event(task, timestamp);
+	if (event == NULL)
+		return;
 
 	event->type = SCHED_EVENT_RUN;
 	event->duration = duration;
@@ -414,6 +427,8 @@ static void add_sched_event_wakeup(struct perf_sched *sched, struct task_desc *t
 	struct sched_atom *event, *wakee_event;
 
 	event = get_new_event(task, timestamp);
+	if (event == NULL)
+		return;
 	event->type = SCHED_EVENT_WAKEUP;
 	event->wakee = wakee;
 
@@ -428,6 +443,10 @@ static void add_sched_event_wakeup(struct perf_sched *sched, struct task_desc *t
 	}
 
 	wakee_event->wait_sem = zalloc(sizeof(*wakee_event->wait_sem));
+	if (!wakee_event->wait_sem) {
+		pr_err("ERROR: sched: failed to allocate semaphore\n");
+		return;
+	}
 	sem_init(wakee_event->wait_sem, 0, 0);
 	wakee_event->specific_wait = 1;
 	event->wait_sem = wakee_event->wait_sem;
@@ -440,6 +459,9 @@ static void add_sched_event_sleep(struct perf_sched *sched, struct task_desc *ta
 {
 	struct sched_atom *event = get_new_event(task, timestamp);
 
+	if (event == NULL)
+		return;
+
 	event->type = SCHED_EVENT_SLEEP;
 
 	sched->nr_sleep_events++;
-- 
2.53.0



