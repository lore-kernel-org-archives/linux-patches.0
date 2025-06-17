Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5354C2EE607;
	Tue, 17 Jun 2025 15:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175884; cv=none; b=j6ZJvzmAF4nWHFLXLF1QYJcEBcfgFvF3/hF2kG9BTe9nHcZLgikQCIKW6Tp3JRcZ5dQzWnIwU8j4bFHENkxzLKvY+zUhuqEacLs5F+4y+EkXE4aBRk86xXppYSQHVf2YhuHJGWtcJkRnipUl2IBptHrXc5XjQSAW76zlxwvEiMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175884; c=relaxed/simple;
	bh=m8q5k6Io4+ifP+yM2UQxJc6bXZfxvB1x0yCl7MHwk6E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qk4Wrnc9uxEOrNeLvNmxpWv7qOT5cKjRAkHb5Zyddfn5TJEPtxo2CFsRwHUWIYtGQAhZvzUhX6AwKSG0HaDl0+pUQSnlw9/ECVWcRAZmmqHN6c8XeETWYwBk3vg8Xu6+LKWBx/JTdcmodSmE1RRo910bOKmFzgt3QytHDYtXZlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nnajng1K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nnajng1K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F43FC4CEFA;
	Tue, 17 Jun 2025 15:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175883;
	bh=m8q5k6Io4+ifP+yM2UQxJc6bXZfxvB1x0yCl7MHwk6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nnajng1KxmMCQYgaStRLXq5X4GBjkRfxafu39vMojJJBMn5EEZ6iakD17cX1Oxqh0
	 DPsDQY0jDYFTWgYyziLw5KULA897KQuPIN+WHjgrx7S9o6/X/Pfk2K8jx/lO5npzAw
	 m9czfRMlyVnxFlfIRuoU+0SWcG1TIHBEouMf0OdA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Howard Chu <howardchu95@gmail.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ian Rogers <irogers@google.com>,
	Ingo Molnar <mingo@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Kan Liang <kan.liang@linux.intel.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 207/356] perf trace: Fix leaks of struct thread in set_filter_loop_pids()
Date: Tue, 17 Jun 2025 17:25:22 +0200
Message-ID: <20250617152346.542585531@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namhyung Kim <namhyung@kernel.org>

[ Upstream commit 30d20fb1f84ad5c92706fe2c6cbb2d4cc293e671 ]

I've found some leaks from 'perf trace -a'.

It seems there are more leaks but this is what I can find for now.

Fixes: 082ab9a18e532864 ("perf trace: Filter out 'sshd' in the tracer ancestry in syswide tracing")
Reviewed-by: Howard Chu <howardchu95@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/r/20250403054213.7021-1-namhyung@kernel.org
[ split from a larget patch ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-trace.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 12bdbf3ecc6ae..908509df007ba 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -3589,10 +3589,13 @@ static int trace__set_filter_loop_pids(struct trace *trace)
 		if (!strcmp(thread__comm_str(parent), "sshd") ||
 		    strstarts(thread__comm_str(parent), "gnome-terminal")) {
 			pids[nr++] = thread__tid(parent);
+			thread__put(parent);
 			break;
 		}
+		thread__put(thread);
 		thread = parent;
 	}
+	thread__put(thread);
 
 	err = evlist__append_tp_filter_pids(trace->evlist, nr, pids);
 	if (!err && trace->filter_pids.map)
-- 
2.39.5



