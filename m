Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9C2E38910F;
	Tue, 21 Jul 2026 18:58:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660311; cv=none; b=AeQpx4JmpQsiWsYedKgHKK9MnBuAP8WD+MXFFOfIJyOSNFAxzsXz9g5hRtSM7/eW4QsJd1FJdoK7FvnwXvZIBZrEpuelpKjt0y+WOFCQascny/CMBtkfP5RJACpQIko6CT90Gl6Jqk0zW2Ah+nTTE0VfbV1hxDsf4IoAdv6UUYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660311; c=relaxed/simple;
	bh=l1QPfibLV6gqgL0tZlpv2duz9s3qvijCMSkbfAj4cic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dbu074YbiKveI9R/J4uOiEJ+jZi6y/L8vVv/pO8++gD3qg1juaCUg+3mQdTtJx558qAtwNTwi/+6Pz2v2l5RS7/Ulyc1N2z9KqlGr1/umiJ8H/PheWCEa6YcKFXp/hxknml1IG8rdxlBZx7hbIxg9WRX2rUz6Cy69Zzg5oa4mcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jXMtP0j+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jXMtP0j+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0016D1F000E9;
	Tue, 21 Jul 2026 18:58:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660308;
	bh=pnUXI+AFeBltInu0c8UCjfdykoaQVXKf5oOP0B7XNqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jXMtP0j+1+V9YEWIZeCfaNP2sUr4Ml3Z2HNVkuIhGkcMIDBUNytAAc0LwVCnTG0rq
	 srvmX9wWmVb5x35FTiQiUKYer2CU+ik/snMRpbGPgPpe38j5tpGQAh/hJtSZEOrZXk
	 3qY+QGqMN/f2QsE1aAcAEd5BZRw6tzy38cUDvmC8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0932/2077] perf sched: Fix NULL dereference in latency_runtime_event
Date: Tue, 21 Jul 2026 17:10:05 +0200
Message-ID: <20260721152614.800943065@linuxfoundation.org>
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
index adff5d40a15c95..13d9a15a553ec9 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -1216,13 +1216,15 @@ static int latency_runtime_event(struct perf_sched *sched,
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



