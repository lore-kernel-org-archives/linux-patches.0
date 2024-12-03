Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CB9223CE;
	Tue,  3 Dec 2024 16:05:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241906; cv=none; b=FPWUfPyq39DNKNpCAYxyW4lCuc8DKq8Tn/7HrZfGToK5mm3ea0QpKlt/4+nQCDxP/wb5jRLE74Y3SkIWprvPoauII53k3qpB9Mcy2ASFGL6GQpegp1yKXZkfSxEPSKwFRvH2QiJzf10Fk+GrXsf8KPFXy4EpWn3ya2E5NeP+krU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241906; c=relaxed/simple;
	bh=5/JkGQ3t2oMuJeij3zxKDH6w3aLa0NXfsh8G2we84/s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KheFz8aHxiUDI1BYovCzb+5OrtcfSZwqoECsk3imdxokfpkvmxupWdK2pypZsWWGjweV14clYpyuVh+u00wpsvpUN0Qb7je1Gn/qtpi/PqBF5Eex6k+gRWvvN6KsEp1OGBmEXM6unA5yhIr891QIDVaTLJwemVmDPEZu/zXMkYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A/k3Chkf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A/k3Chkf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54060C4CECF;
	Tue,  3 Dec 2024 16:05:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241905;
	bh=5/JkGQ3t2oMuJeij3zxKDH6w3aLa0NXfsh8G2we84/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A/k3ChkfXyhe0y/CnIiOmDJKMNicHlPG+/vUxvrw/gTyZLVj1ya6SOInANkRDtyFZ
	 V81MVPIgX9BVHd2EsqVGbA+ckGmqDSTLvZOvAsS55YFhIxa8UT46Bk6TR3IDcuGCTk
	 mBnp3RGRJ4beBhw6B0VmTfrF4dacuYRNr59RYurI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Peterson <benjamin@engflow.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Howard Chu <howardchu95@gmail.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Ian Rogers <irogers@google.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Kan Liang <kan.liang@linux.intel.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 518/826] perf trace: Avoid garbage when not printing a syscalls arguments
Date: Tue,  3 Dec 2024 15:44:05 +0100
Message-ID: <20241203144803.969202023@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Peterson <benjamin@engflow.com>

[ Upstream commit 1302e352b26f34991b619b5d0b621b76d20a3883 ]

syscall__scnprintf_args may not place anything in the output buffer
(e.g., because the arguments are all zero). If that happened in
trace__fprintf_sys_enter, its fprintf would receive an unitialized
buffer leading to garbage output.

Fix the problem by passing the (possibly zero) bounds of the argument
buffer to the output fprintf.

Fixes: a98392bb1e169a04 ("perf trace: Use beautifiers on syscalls:sys_enter_ handlers")
Signed-off-by: Benjamin Peterson <benjamin@engflow.com>
Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Tested-by: Howard Chu <howardchu95@gmail.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/r/20241107232128.108981-2-benjamin@engflow.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-trace.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 6fc437be662a1..ffa1295273099 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -2702,6 +2702,7 @@ static int trace__fprintf_sys_enter(struct trace *trace, struct evsel *evsel,
 	char msg[1024];
 	void *args, *augmented_args = NULL;
 	int augmented_args_size;
+	size_t printed = 0;
 
 	if (sc == NULL)
 		return -1;
@@ -2717,8 +2718,8 @@ static int trace__fprintf_sys_enter(struct trace *trace, struct evsel *evsel,
 
 	args = perf_evsel__sc_tp_ptr(evsel, args, sample);
 	augmented_args = syscall__augmented_args(sc, sample, &augmented_args_size, trace->raw_augmented_syscalls_args_size);
-	syscall__scnprintf_args(sc, msg, sizeof(msg), args, augmented_args, augmented_args_size, trace, thread);
-	fprintf(trace->output, "%s", msg);
+	printed += syscall__scnprintf_args(sc, msg, sizeof(msg), args, augmented_args, augmented_args_size, trace, thread);
+	fprintf(trace->output, "%.*s", (int)printed, msg);
 	err = 0;
 out_put:
 	thread__put(thread);
-- 
2.43.0



