Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B584E1A01D4;
	Thu,  6 Jun 2024 14:20:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683637; cv=none; b=gDKugj8IZx549a1EZLNqyQKnIQYVsXpQTyLAR87PHl29AXTlmtPGbGwPyyY/uv3ujVcBIn0BRWlLwfdqEjgVi7w4OTC3w1dNyJYgbgQNwSD49XxfzhI+WZV3CDZj1tO8O2vnGRYabQJFUbpMEZjB1lbDg2FFtoL0MfyrVZCPydI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683637; c=relaxed/simple;
	bh=GZ4rCTS0fjRQkr/h9WgKGwLZzfs3rYhiKzzZpHnlgbE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tesjU+mcomnnFO6zhtwdAA+rypDdQapuw5YJJN3wqFSbDQc6LxkfFn5McoFY/507WwczWkaL6BJ+Ucu1pXx0JAebEZApHef3ZYcF6cNt2jNQnB/kZTG4rC9HpxonMdJtOjRLx10T6xuRNhH5OCb5xWYoyWz0cSMw7VF/tgsHdLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BpIGU2WG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BpIGU2WG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DCFEC2BD10;
	Thu,  6 Jun 2024 14:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683637;
	bh=GZ4rCTS0fjRQkr/h9WgKGwLZzfs3rYhiKzzZpHnlgbE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BpIGU2WGZwa2JD3F7XLLIPRgW2WL2PCy/woJG9fCC9h1sstwbEE402akfsOu3EqVQ
	 r8Pfxs7MHbzX9X6BgRs1t11+/gxEBQ/VH2iIM0SzzmwfYzQwrVXMEfvLwsCfPGxXOQ
	 U8F7QECWthVf1QHnaC0gYnK3c6cX8EomvFcJXuoU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Ingo Molnar <mingo@redhat.com>,
	James Clark <james.clark@arm.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Kan Liang <kan.liang@linux.intel.com>,
	Leo Yan <leo.yan@linux.dev>,
	Mark Rutland <mark.rutland@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 509/744] perf thread: Fixes to thread__new() related to initializing comm
Date: Thu,  6 Jun 2024 16:03:01 +0200
Message-ID: <20240606131748.784605579@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Rogers <irogers@google.com>

[ Upstream commit 3536c2575e88a890cf696b4ccd3da36bc937853b ]

Freeing the thread on failure won't work with reference count checking,
use thread__delete().

Don't allocate the comm_str, use a stack allocation instead.

Fixes: f6005cafebab72f8 ("perf thread: Add reference count checking")
Signed-off-by: Ian Rogers <irogers@google.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Clark <james.clark@arm.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Leo Yan <leo.yan@linux.dev>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/r/20240508035301.1554434-5-irogers@google.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/thread.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
index fe5e6991ae4b4..61e9f449c7258 100644
--- a/tools/perf/util/thread.c
+++ b/tools/perf/util/thread.c
@@ -39,12 +39,13 @@ int thread__init_maps(struct thread *thread, struct machine *machine)
 
 struct thread *thread__new(pid_t pid, pid_t tid)
 {
-	char *comm_str;
-	struct comm *comm;
 	RC_STRUCT(thread) *_thread = zalloc(sizeof(*_thread));
 	struct thread *thread;
 
 	if (ADD_RC_CHK(thread, _thread) != NULL) {
+		struct comm *comm;
+		char comm_str[32];
+
 		thread__set_pid(thread, pid);
 		thread__set_tid(thread, tid);
 		thread__set_ppid(thread, -1);
@@ -56,13 +57,8 @@ struct thread *thread__new(pid_t pid, pid_t tid)
 		init_rwsem(thread__namespaces_lock(thread));
 		init_rwsem(thread__comm_lock(thread));
 
-		comm_str = malloc(32);
-		if (!comm_str)
-			goto err_thread;
-
-		snprintf(comm_str, 32, ":%d", tid);
+		snprintf(comm_str, sizeof(comm_str), ":%d", tid);
 		comm = comm__new(comm_str, 0, false);
-		free(comm_str);
 		if (!comm)
 			goto err_thread;
 
@@ -76,7 +72,7 @@ struct thread *thread__new(pid_t pid, pid_t tid)
 	return thread;
 
 err_thread:
-	free(thread);
+	thread__delete(thread);
 	return NULL;
 }
 
-- 
2.43.0



