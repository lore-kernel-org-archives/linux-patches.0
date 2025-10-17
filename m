Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72A4D337109;
	Fri, 17 Oct 2025 15:28:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714917; cv=none; b=heXUiMxHFyOkeCfEPVGf6Uqfuky1HPxvp+QRLEAqJC5dFMedMUegqC2Xzd6/Z1AMnakSdNzLfodGIDtu3tjcN6lGDIXnbZLuiwaafptuXc4yeI3sOza+XS/KFTV//S1LQdwQg5g80CImZTyKd/ZD7slwWPICKSb/8kVdqNfWEN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714917; c=relaxed/simple;
	bh=8ikhfVYaTjmVLu7pfRYMde6jyNUCApdorKsWmNmDA2w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eLK5MuHhiyVehMknraiyqxWlfXH6wvTLYzVgr2J6egY2YrtUsSwdOt2G0fk+RWLWyxZtXZqCYYC1boX1Sgfct2iEWzfYOx/SsEGsTqn2/oDysyGVkpmUjCygMP/huh08fPh6qqhOvVAqc8AxmKdtAciAopl8uSl7XO8sZ3JAKww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f7YOWhSF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f7YOWhSF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68D70C4CEE7;
	Fri, 17 Oct 2025 15:28:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714916;
	bh=8ikhfVYaTjmVLu7pfRYMde6jyNUCApdorKsWmNmDA2w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f7YOWhSFnpFJdTSToQcgiyRt0Rr1wsQNUfNDoF5wxB8rEAnoW8orGaj7X3WmQzWuM
	 IJwoq6ul/b5h/rlwqCxXvWMVX3dc8h8EPFWB4LPO5QqPhnNi6w04RGP5NaSbQ9T+h5
	 yCbRSePgYgGDYyhSh9sIcxYVwsr2/gO8qwUzlAX4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Ian Rogers <irogers@google.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Kan Liang <kan.liang@linux.intel.com>,
	Leo Yan <leo.yan@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 034/371] perf: Completely remove possibility to override MAX_NR_CPUS
Date: Fri, 17 Oct 2025 16:50:09 +0200
Message-ID: <20251017145203.035099069@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe Leroy <christophe.leroy@csgroup.eu>

[ Upstream commit 6f8fb022ef2c6694e47f6e2f5676eb63be66c208 ]

Commit 21b8732eb447 ("perf tools: Allow overriding MAX_NR_CPUS at
compile time") added the capability to override MAX_NR_CPUS. At
that time it was necessary to reduce the huge amount of RAM used
by static stats variables.

But this has been unnecessary since commit 6a1e2c5c2673 ("perf stat:
Remove a set of shadow stats static variables"), and
commit e8399d34d568 ("libperf cpumap: Hide/reduce scope of
MAX_NR_CPUS") broke the build in that case because it failed to
add the guard around the new definition of MAX_NR_CPUS.

So cleanup things and remove guards completely to officialise it
is not necessary anymore to override MAX_NR_CPUS.

Fixes: e8399d34d568d61c ("libperf cpumap: Hide/reduce scope of MAX_NR_CPUS")
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Leo Yan <leo.yan@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/all/8c8553387ebf904a9e5a93eaf643cb01164d9fb3.1736188471.git.christophe.leroy@csgroup.eu/
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/perf.h                        | 2 --
 tools/perf/util/bpf_skel/kwork_top.bpf.c | 2 --
 2 files changed, 4 deletions(-)

diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index 3cb40965549f5..e004178472d9e 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -2,9 +2,7 @@
 #ifndef _PERF_PERF_H
 #define _PERF_PERF_H
 
-#ifndef MAX_NR_CPUS
 #define MAX_NR_CPUS			4096
-#endif
 
 enum perf_affinity {
 	PERF_AFFINITY_SYS = 0,
diff --git a/tools/perf/util/bpf_skel/kwork_top.bpf.c b/tools/perf/util/bpf_skel/kwork_top.bpf.c
index 73e32e0630301..6673386302e2f 100644
--- a/tools/perf/util/bpf_skel/kwork_top.bpf.c
+++ b/tools/perf/util/bpf_skel/kwork_top.bpf.c
@@ -18,9 +18,7 @@ enum kwork_class_type {
 };
 
 #define MAX_ENTRIES     102400
-#ifndef MAX_NR_CPUS
 #define MAX_NR_CPUS     4096
-#endif
 #define PF_KTHREAD      0x00200000
 #define MAX_COMMAND_LEN 16
 
-- 
2.51.0



