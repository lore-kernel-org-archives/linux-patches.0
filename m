Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 953D738D;
	Thu,  6 Jun 2024 14:08:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717682895; cv=none; b=faBtdJZhTlVGVzK2nlCce4zLCYAp6To0GS4/5+pkR6jclN0rStQ96araFuFlnDD+mk0xKUktOBN+VigAY3k+DFEUELxOeKxvON3WE0n5mJCLgoQD1mFBd40HQfoTdPBmJwLMG2aWWFNqdc+NNk2IH2Bw6AkaG0Up+7792kAJOfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717682895; c=relaxed/simple;
	bh=D0QAg9gR5OEjHbcOSXhNX9jyHg+B/uEYRSAb/xaQ6BQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B1KDWAhyCwumEubV8bBAKV0hcBdHl4hrRteo9fSrOHloAwAHL2Mpu9AseDzovsES2w6Kz9vhj/M6nqSbO5poYfLlTBXzeTs25NCu2osRnbDCUcpwd/IgJgJGc4jZ9pWQ2cWMuyt+dj4MKdbPAEyevMYEfoEPxKYcfcYa7lHy9as=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k+gkxYQ6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k+gkxYQ6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1978FC32781;
	Thu,  6 Jun 2024 14:08:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717682895;
	bh=D0QAg9gR5OEjHbcOSXhNX9jyHg+B/uEYRSAb/xaQ6BQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k+gkxYQ6CcIEy8ePtuc6GhPSbj0A0u573zMa9pjUqcpnmVHE85fmrvIQLIyuPTCBB
	 EgosJxNUAKQQiqjbnWYwcx68g6LYTSzFAVQo7OkjcRPFzggzRl5poZwimdUhvfWKmA
	 CBsSD+cxYUhVANelXfkyav/v6D0VZ7D0YMQKxUpY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Athira Rajeev <atrajeev@linux.vnet.ibm.com>,
	Christian Brauner <brauner@kernel.org>,
	Disha Goel <disgoel@linux.ibm.com>,
	Ingo Molnar <mingo@redhat.com>,
	James Clark <james.clark@arm.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Kajol Jain <kjain@linux.ibm.com>,
	Kan Liang <kan.liang@linux.intel.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Song Liu <songliubraving@fb.com>,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Yicong Yang <yangyicong@hisilicon.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 002/374] perf record: Delete session after stopping sideband thread
Date: Thu,  6 Jun 2024 15:59:41 +0200
Message-ID: <20240606131651.778887231@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Rogers <irogers@google.com>

[ Upstream commit 88ce0106a1f603bf360cb397e8fe293f8298fabb ]

The session has a header in it which contains a perf env with
bpf_progs. The bpf_progs are accessed by the sideband thread and so
the sideband thread must be stopped before the session is deleted, to
avoid a use after free.  This error was detected by AddressSanitizer
in the following:

  ==2054673==ERROR: AddressSanitizer: heap-use-after-free on address 0x61d000161e00 at pc 0x55769289de54 bp 0x7f9df36d4ab0 sp 0x7f9df36d4aa8
  READ of size 8 at 0x61d000161e00 thread T1
      #0 0x55769289de53 in __perf_env__insert_bpf_prog_info util/env.c:42
      #1 0x55769289dbb1 in perf_env__insert_bpf_prog_info util/env.c:29
      #2 0x557692bbae29 in perf_env__add_bpf_info util/bpf-event.c:483
      #3 0x557692bbb01a in bpf_event__sb_cb util/bpf-event.c:512
      #4 0x5576928b75f4 in perf_evlist__poll_thread util/sideband_evlist.c:68
      #5 0x7f9df96a63eb in start_thread nptl/pthread_create.c:444
      #6 0x7f9df9726a4b in clone3 ../sysdeps/unix/sysv/linux/x86_64/clone3.S:81

  0x61d000161e00 is located 384 bytes inside of 2136-byte region [0x61d000161c80,0x61d0001624d8)
  freed by thread T0 here:
      #0 0x7f9dfa6d7288 in __interceptor_free libsanitizer/asan/asan_malloc_linux.cpp:52
      #1 0x557692978d50 in perf_session__delete util/session.c:319
      #2 0x557692673959 in __cmd_record tools/perf/builtin-record.c:2884
      #3 0x55769267a9f0 in cmd_record tools/perf/builtin-record.c:4259
      #4 0x55769286710c in run_builtin tools/perf/perf.c:349
      #5 0x557692867678 in handle_internal_command tools/perf/perf.c:402
      #6 0x557692867a40 in run_argv tools/perf/perf.c:446
      #7 0x557692867fae in main tools/perf/perf.c:562
      #8 0x7f9df96456c9 in __libc_start_call_main ../sysdeps/nptl/libc_start_call_main.h:58

Fixes: 657ee5531903339b ("perf evlist: Introduce side band thread")
Signed-off-by: Ian Rogers <irogers@google.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Athira Rajeev <atrajeev@linux.vnet.ibm.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Disha Goel <disgoel@linux.ibm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Clark <james.clark@arm.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kajol Jain <kjain@linux.ibm.com>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: K Prateek Nayak <kprateek.nayak@amd.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Song Liu <songliubraving@fb.com>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Yicong Yang <yangyicong@hisilicon.com>
Link: https://lore.kernel.org/r/20240301074639.2260708-1-irogers@google.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-record.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index ff7e1d6cfcd2e..40d2c1c486665 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -2881,10 +2881,10 @@ static int __cmd_record(struct record *rec, int argc, const char **argv)
 	}
 #endif
 	zstd_fini(&session->zstd_data);
-	perf_session__delete(session);
-
 	if (!opts->no_bpf_event)
 		evlist__stop_sb_thread(rec->sb_evlist);
+
+	perf_session__delete(session);
 	return status;
 }
 
-- 
2.43.0



