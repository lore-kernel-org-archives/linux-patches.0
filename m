Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B83A46B5
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:22:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EECE0C433EF;
	Mon, 16 Jan 2023 16:22:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673886156;
	bh=g0qKH8gvQygXxaA0XdDhpfr8FrmKiNbx7fVi2ddaDow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rn2yyfuKEgmixZCLctwTKEQyNN7k9vSqR5W8pTbFc6+SoBdswRd9HMVyYxODB6amg
	 JeOXqMu7R7ZrlN05FNlnkpv/8VOyt9OoFldgkrxrQDW7SAxDs0vzCu86iBtE+oCIDO
	 x8xduqfaaD0qPNXpS0vBmLPCq0WGGDHv/O4wsSVE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Yan <leo.yan@linaro.org>,
	Ian Rogers <irogers@google.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	bpf@vger.kernel.org,
	Ingo Molnar <mingo@redhat.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 324/658] perf trace: Return error if a system call doesnt exist
Date: Mon, 16 Jan 2023 16:46:52 +0100
Message-Id: <20230116154924.388367360@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Leo Yan <leo.yan@linaro.org>

[ Upstream commit d4223e1776c30b2ce8d0e6eaadcbf696e60fca3c ]

When a system call is not detected, the reason is either because the
system call ID is out of scope or failure to find the corresponding path
in the sysfs, trace__read_syscall_info() returns zero.  Finally, without
returning an error value it introduces confusion for the caller.

This patch lets the function trace__read_syscall_info() to return
-EEXIST when a system call doesn't exist.

Fixes: b8b1033fcaa091d8 ("perf trace: Mark syscall ids that are not allocated to avoid unnecessary error messages")
Signed-off-by: Leo Yan <leo.yan@linaro.org>
Acked-by: Ian Rogers <irogers@google.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: bpf@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/r/20221121075237.127706-3-leo.yan@linaro.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-trace.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index a5201de1a191..d333f6c86c98 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -1511,11 +1511,11 @@ static int trace__read_syscall_info(struct trace *trace, int id)
 
 	sc = trace->syscalls.table + id;
 	if (sc->nonexistent)
-		return 0;
+		return -EEXIST;
 
 	if (name == NULL) {
 		sc->nonexistent = true;
-		return 0;
+		return -EEXIST;
 	}
 
 	sc->name = name;
-- 
2.35.1



