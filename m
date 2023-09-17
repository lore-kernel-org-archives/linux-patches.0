Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6753C746F
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:36:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBC0EC433C8;
	Sun, 17 Sep 2023 20:36:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694982997;
	bh=5BgZq94RkpGlOnCJDfMuqtwAI0+kSkCf2MiSaHnfRTc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hja+hggNWzWuTeTYhkRV5Q04VF0HLpnBFMDyIYy/zNOoixuhgGQ03KlztgiZiXoDz
	 OKe4Y/kCTBXvGR4pmaWcQ8ozaE2f+Sqs54e/DoUPJkZJDLUsO7DGbpnTYZdnRb3l5c
	 ybzFuDSdr0QUWKOqZmK6Kuf20QLCFnrvJT3OwaB0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Riccardo Mancini <rickyman7@gmail.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 412/511] perf trace: Really free the evsel->priv area
Date: Sun, 17 Sep 2023 21:13:59 +0200
Message-ID: <20230917191123.732117232@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191113.831992765@linuxfoundation.org>
References: <20230917191113.831992765@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 7962ef13651a9163f07b530607392ea123482e8a ]

In 3cb4d5e00e037c70 ("perf trace: Free syscall tp fields in
evsel->priv") it only was freeing if strcmp(evsel->tp_format->system,
"syscalls") returned zero, while the corresponding initialization of
evsel->priv was being performed if it was _not_ zero, i.e. if the tp
system wasn't 'syscalls'.

Just stop looking for that and free it if evsel->priv was set, which
should be equivalent.

Also use the pre-existing evsel_trace__delete() function.

This resolves these leaks, detected with:

  $ make EXTRA_CFLAGS="-fsanitize=address" BUILD_BPF_SKEL=1 CORESIGHT=1 O=/tmp/build/perf-tools-next -C tools/perf install-bin

  =================================================================
  ==481565==ERROR: LeakSanitizer: detected memory leaks

  Direct leak of 40 byte(s) in 1 object(s) allocated from:
      #0 0x7f7343cba097 in calloc (/lib64/libasan.so.8+0xba097)
      #1 0x987966 in zalloc (/home/acme/bin/perf+0x987966)
      #2 0x52f9b9 in evsel_trace__new /home/acme/git/perf-tools-next/tools/perf/builtin-trace.c:307
      #3 0x52f9b9 in evsel__syscall_tp /home/acme/git/perf-tools-next/tools/perf/builtin-trace.c:333
      #4 0x52f9b9 in evsel__init_raw_syscall_tp /home/acme/git/perf-tools-next/tools/perf/builtin-trace.c:458
      #5 0x52f9b9 in perf_evsel__raw_syscall_newtp /home/acme/git/perf-tools-next/tools/perf/builtin-trace.c:480
      #6 0x540e8b in trace__add_syscall_newtp /home/acme/git/perf-tools-next/tools/perf/builtin-trace.c:3212
      #7 0x540e8b in trace__run /home/acme/git/perf-tools-next/tools/perf/builtin-trace.c:3891
      #8 0x540e8b in cmd_trace /home/acme/git/perf-tools-next/tools/perf/builtin-trace.c:5156
      #9 0x5ef262 in run_builtin /home/acme/git/perf-tools-next/tools/perf/perf.c:323
      #10 0x4196da in handle_internal_command /home/acme/git/perf-tools-next/tools/perf/perf.c:377
      #11 0x4196da in run_argv /home/acme/git/perf-tools-next/tools/perf/perf.c:421
      #12 0x4196da in main /home/acme/git/perf-tools-next/tools/perf/perf.c:537
      #13 0x7f7342c4a50f in __libc_start_call_main (/lib64/libc.so.6+0x2750f)

  Direct leak of 40 byte(s) in 1 object(s) allocated from:
      #0 0x7f7343cba097 in calloc (/lib64/libasan.so.8+0xba097)
      #1 0x987966 in zalloc (/home/acme/bin/perf+0x987966)
      #2 0x52f9b9 in evsel_trace__new /home/acme/git/perf-tools-next/tools/perf/builtin-trace.c:307
      #3 0x52f9b9 in evsel__syscall_tp /home/acme/git/perf-tools-next/tools/perf/builtin-trace.c:333
      #4 0x52f9b9 in evsel__init_raw_syscall_tp /home/acme/git/perf-tools-next/tools/perf/builtin-trace.c:458
      #5 0x52f9b9 in perf_evsel__raw_syscall_newtp /home/acme/git/perf-tools-next/tools/perf/builtin-trace.c:480
      #6 0x540dd1 in trace__add_syscall_newtp /home/acme/git/perf-tools-next/tools/perf/builtin-trace.c:3205
      #7 0x540dd1 in trace__run /home/acme/git/perf-tools-next/tools/perf/builtin-trace.c:3891
      #8 0x540dd1 in cmd_trace /home/acme/git/perf-tools-next/tools/perf/builtin-trace.c:5156
      #9 0x5ef262 in run_builtin /home/acme/git/perf-tools-next/tools/perf/perf.c:323
      #10 0x4196da in handle_internal_command /home/acme/git/perf-tools-next/tools/perf/perf.c:377
      #11 0x4196da in run_argv /home/acme/git/perf-tools-next/tools/perf/perf.c:421
      #12 0x4196da in main /home/acme/git/perf-tools-next/tools/perf/perf.c:537
      #13 0x7f7342c4a50f in __libc_start_call_main (/lib64/libc.so.6+0x2750f)

  SUMMARY: AddressSanitizer: 80 byte(s) leaked in 2 allocation(s).
  [root@quaco ~]#

With this we plug all leaks with "perf trace sleep 1".

Fixes: 3cb4d5e00e037c70 ("perf trace: Free syscall tp fields in evsel->priv")
Acked-by: Ian Rogers <irogers@google.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Riccardo Mancini <rickyman7@gmail.com>
Link: https://lore.kernel.org/lkml/20230719202951.534582-5-acme@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-trace.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index d912dc878a6e9..6755370483b06 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -3124,13 +3124,8 @@ static void evlist__free_syscall_tp_fields(struct evlist *evlist)
 	struct evsel *evsel;
 
 	evlist__for_each_entry(evlist, evsel) {
-		struct evsel_trace *et = evsel->priv;
-
-		if (!et || !evsel->tp_format || strcmp(evsel->tp_format->system, "syscalls"))
-			continue;
-
-		zfree(&et->fmt);
-		free(et);
+		evsel_trace__delete(evsel->priv);
+		evsel->priv = NULL;
 	}
 }
 
-- 
2.40.1



