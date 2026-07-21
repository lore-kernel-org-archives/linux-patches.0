Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE7C5415F20;
	Tue, 21 Jul 2026 18:05:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657108; cv=none; b=a0NxuyKRtc0U75Y9u0CgOo2TlLBfyiHrU5YYqYKFe3gWlUZXVciAMIXU1eQv2APrEHueLGCEeXnamYgZa2yA7pztJhK2nFJwyuTuxLYrpxVXagGCVgGstQq8UeaPEAo6YCZAjChiBsfNKn6Ar+hqVy0u3lvTUefy4wSRbG9q81E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657108; c=relaxed/simple;
	bh=MgeytNKK7ENJgdpYIPvYFj0ftBeTbu4w5U/c0pH6WJI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FJtvPSq+cmkSB5KccD81CVHiVir9drtxjLErnFxApJLBit+FRKY4sJkAlaA1MDznUZrlD/hmFkMLQgDvvWNQ4cVRGd+8hfkdQnvj9UcwnpoPBSpHfQh2cpZ79UJ45+VU55AVQZxbNbt1qclLskpyjzIE15a6XEspPQ6ia5NrXV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gO5N01tU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gO5N01tU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 202181F00A3A;
	Tue, 21 Jul 2026 18:05:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657107;
	bh=sRrvg4dylwq2I9dCFlt9RJ06lzfoJsWqLd7BUCp7iM0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gO5N01tUAzURSN6rbz7hl3YAy6HI1/z4XaGdNRowaPComPxOLmXjLh6RHBQWzzoBG
	 wKdpSVLAOMNDq1wuxCxUSE/c7Uxja9eVZoyuflt62QYgFcNz+wafXDM8ikm+4XQnkg
	 ZAFGNnQEiaiDKbvGahJ+17FW+ONWJd3vmrOaCous=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0639/1611] perf sched: Fix NULL dereference in latency_runtime_event
Date: Tue, 21 Jul 2026 17:12:35 +0200
Message-ID: <20260721152529.763883966@linuxfoundation.org>
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

[ Upstream commit 8cbca8a480e15f6326ce94287570993f27a4b2d5 ]

latency_runtime_event() passes the return value of
machine__findnew_thread() directly to thread_atoms_search() at line
1216, before checking for NULL at line 1220.  thread_atoms_search()
calls pid_cmp() which dereferences the thread pointer via
thread__tid(), causing a NULL pointer dereference if the allocation
fails.

All other callers of thread_atoms_search() in this file
(latency_switch_event, latency_wakeup_event,
latency_migrate_task_event) correctly check for NULL first.

Move the atoms assignment after the NULL check to match the pattern
used by the other callers.

Fixes: b91fc39f4ad7 ("perf machine: Protect the machine->threads with a rwlock")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-sched.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 1181a2afd273a3..273a7eadfa8528 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -1209,13 +1209,15 @@ static int latency_runtime_event(struct perf_sched *sched,
 	const u32 pid	   = evsel__intval(evsel, sample, "pid");
 	const u64 runtime  = evsel__intval(evsel, sample, "runtime");
 	struct thread *thread = machine__findnew_thread(machine, -1, pid);
-	struct work_atoms *atoms = thread_atoms_search(&sched->atom_root, thread, &sched->cmp_pid);
+	struct work_atoms *atoms;
 	u64 timestamp = sample->time;
 	int cpu = sample->cpu, err = -1;
 
 	if (thread == NULL)
 		return -1;
 
+	atoms = thread_atoms_search(&sched->atom_root, thread, &sched->cmp_pid);
+
 	/* perf.data is untrusted input — CPU may be absent or corrupted */
 	if (cpu >= MAX_CPUS || cpu < 0) {
 		pr_warning("WARNING: at offset %#" PRIx64 ": out-of-bound sample CPU %d, skipping sample\n",
-- 
2.53.0



