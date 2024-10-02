Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 793D5376;
	Wed,  2 Oct 2024 13:36:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876185; cv=none; b=NYaIiliDE4iJqz/rwvisWwPf/M21ggRECExKtXSEPghEgO7sHM9YaZdpTA2Kp7c6J1fgc32Zd5LIoQ0hEEbm0+4nC5I+jQsVi60Il3dz5ihjXare+qY8UB8tMy0eIRTB4VBuu65fjSQdHXunmnNMI73YUBXJziEE0PRcJVgcGfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876185; c=relaxed/simple;
	bh=92OJ6Ley63kgOmH65MjCuTeYB+jvjR7whJfdH6UgvT8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s033HWojCV9ZuvY3RRgVTVtCk7P6nAqodz1xaiEOwegiM7tJ0cHQv0on2uHiErhZGXVl3Nff2uBCgijF9SI9mShtWLd0SzfS40qpZxpAZRU0ti6XEgvMLulA+4KNF6toP4RuJCPWYH5fPVlhC52PxHWPKARL7QWpd8OSzY4i/H0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Eo/mbly1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Eo/mbly1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01F29C4CEC5;
	Wed,  2 Oct 2024 13:36:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876185;
	bh=92OJ6Ley63kgOmH65MjCuTeYB+jvjR7whJfdH6UgvT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Eo/mbly1RtRQlCxGjxeLWVXGcRN/4ky+zDzEuQDPUDTv4Er63TU+w29sl3qWX9jQT
	 m8Dio63eBbLfU010LukX6OhrZpGrVf6pZ5cBntdXPx1/KxMFbS8dX+T5fCCKJMkxec
	 z6gEvyNEL5T4naSIFEJAYYA74IDJkwi4pKsXtCU4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ian Rogers <irogers@google.com>,
	Ingo Molnar <mingo@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Kan Liang <kan.liang@linux.intel.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 327/695] perf lock contention: Change stack_id type to s32
Date: Wed,  2 Oct 2024 14:55:25 +0200
Message-ID: <20241002125835.501175058@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namhyung Kim <namhyung@kernel.org>

[ Upstream commit 040c0f887fdcfe747a3f63c94e9cd29e9ed0b872 ]

The bpf_get_stackid() helper returns a signed type to check whether it
failed to get a stacktrace or not.  But it saved the result in u32 and
checked if the value is negative.

      376         if (needs_callstack) {
      377                 pelem->stack_id = bpf_get_stackid(ctx, &stacks,
      378                                                   BPF_F_FAST_STACK_CMP | stack_skip);
  --> 379                 if (pelem->stack_id < 0)

  ./tools/perf/util/bpf_skel/lock_contention.bpf.c:379 contention_begin()
  warn: unsigned 'pelem->stack_id' is never less than zero.

Let's change the type to s32 instead.

Fixes: 6d499a6b3d90277d ("perf lock: Print the number of lost entries for BPF")
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/r/20240812172533.2015291-1-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/bpf_skel/lock_data.h       | 4 ++--
 tools/perf/util/bpf_skel/vmlinux/vmlinux.h | 1 +
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/bpf_skel/lock_data.h b/tools/perf/util/bpf_skel/lock_data.h
index 36af11faad03c..de12892f992f8 100644
--- a/tools/perf/util/bpf_skel/lock_data.h
+++ b/tools/perf/util/bpf_skel/lock_data.h
@@ -7,11 +7,11 @@ struct tstamp_data {
 	u64 timestamp;
 	u64 lock;
 	u32 flags;
-	u32 stack_id;
+	s32 stack_id;
 };
 
 struct contention_key {
-	u32 stack_id;
+	s32 stack_id;
 	u32 pid;
 	u64 lock_addr_or_cgroup;
 };
diff --git a/tools/perf/util/bpf_skel/vmlinux/vmlinux.h b/tools/perf/util/bpf_skel/vmlinux/vmlinux.h
index e9028235d7717..d818e30c54571 100644
--- a/tools/perf/util/bpf_skel/vmlinux/vmlinux.h
+++ b/tools/perf/util/bpf_skel/vmlinux/vmlinux.h
@@ -15,6 +15,7 @@
 
 typedef __u8 u8;
 typedef __u32 u32;
+typedef __s32 s32;
 typedef __u64 u64;
 typedef __s64 s64;
 
-- 
2.43.0



