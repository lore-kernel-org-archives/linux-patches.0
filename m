Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4E462DFF17;
	Tue, 17 Jun 2025 16:42:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178531; cv=none; b=EQniLJP9cIP8N6jf3YVhG51DfXj8EJ0ZsL1MNHC9quHs+3Rpy196FLkEzWTKKb7y3O3qqCgvS8NICe4QEx3U4MCQGtRBySfrO1aSiHNDGiyyT432g1vej0uqOqEdsh2WAKPdrxCj+atM4noB6B+36L57ZL5UcGjT3C+HqpdDSfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178531; c=relaxed/simple;
	bh=/rN0YO76mRMKU36m33n05D89mpU3Odkq+Tw4Lx73hv0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sJjEjtNWDqebrA1QxMtEbymVWXHQPX17Iu226zVpg52RSxoefHNDGYFowFjFM9EYviAZw6qsFtKDjhc6xaHur76bLjE/R3scR2EpckZ5DbTm3LmvV/hBq3UAle+TAen16GcgLeHO9xHdEkfj0YwYT2o3tuFmkmkyGYWbFczExEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z4FrAY+4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z4FrAY+4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A7FCC4CEE7;
	Tue, 17 Jun 2025 16:42:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178531;
	bh=/rN0YO76mRMKU36m33n05D89mpU3Odkq+Tw4Lx73hv0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z4FrAY+4oGH0MNSdXuVWUCnQ+HRQbGlSK2gl7Hq937l/dVfbJcRehLjlxE6O20plD
	 O17j+oXcIPWr+v8pMRsYqiw5hbkz2i8sVWAJLPtWXMJNgrAjc9VT068zM5borluXm3
	 Hn6EBtmY1hL8fiuFW5M1bj+8NvMIwIKB+aG5ykL4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Howard Chu <howardchu95@gmail.com>,
	Anubhav Shelat <ashelat@redhat.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Ian Rogers <irogers@google.com>,
	Ingo Molnar <mingo@redhat.com>,
	James Clark <james.clark@linaro.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Kan Liang <kan.liang@linux.intel.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Michael Petlan <mpetlan@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 473/780] perf trace: Always print return value for syscalls returning a pid
Date: Tue, 17 Jun 2025 17:23:01 +0200
Message-ID: <20250617152510.750973106@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anubhav Shelat <ashelat@redhat.com>

[ Upstream commit c7a48ea9b919e2fa0e4a1d9938fdb03e9afe276c ]

The syscalls that were consistently observed were set_robust_list and
rseq. This is because perf cannot find their child process.

This change ensures that the return value is always printed.

Before:
     0.256 ( 0.001 ms): set_robust_list(head: 0x7f09c77dba20, len: 24)                        =
     0.259 ( 0.001 ms): rseq(rseq: 0x7f09c77dc0e0, rseq_len: 32, sig: 1392848979)             =
After:
     0.270 ( 0.002 ms): set_robust_list(head: 0x7f0bb14a6a20, len: 24)                        = 0
     0.273 ( 0.002 ms): rseq(rseq: 0x7f0bb14a70e0, rseq_len: 32, sig: 1392848979)             = 0

Committer notes:

As discussed in the thread in the Link: tag below, these two don't
return a pid, but for syscalls returning one, we need to print the
result and if we manage to find the children in 'perf trace' data
structures, then print its name as well.

Fixes: 11c8e39f5133aed9 ("perf trace: Infrastructure to show COMM strings for syscalls returning PIDs")
Reviewed-by: Howard Chu <howardchu95@gmail.com>
Signed-off-by: Anubhav Shelat <ashelat@redhat.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Dapeng Mi <dapeng1.mi@linux.intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Clark <james.clark@linaro.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Michael Petlan <mpetlan@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/r/20250403160411.159238-2-ashelat@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-trace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index f98b5efb1f96c..7304e62b69fee 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -3005,8 +3005,8 @@ errno_print: {
 	else if (sc->fmt->errpid) {
 		struct thread *child = machine__find_thread(trace->host, ret, ret);
 
+		fprintf(trace->output, "%ld", ret);
 		if (child != NULL) {
-			fprintf(trace->output, "%ld", ret);
 			if (thread__comm_set(child))
 				fprintf(trace->output, " (%s)", thread__comm_str(child));
 			thread__put(child);
-- 
2.39.5



