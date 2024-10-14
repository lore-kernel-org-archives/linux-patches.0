Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F92C83A14;
	Mon, 14 Oct 2024 15:35:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728920103; cv=none; b=j+f1R7wYaIktsFfIttvqO9nDPJlFm01hd37G9u96432la8VtlHkIzqXBzQGcBtTT06ITdA72NuMJogCSVRIHhoqHO1nkGiXaHvj/zsmNA1VrDQCOHqWk3ETPQJKsYJhoxaH7PDP6ZFThYeiZUxyfftrD4josMeNJu9Q6D0EWPyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728920103; c=relaxed/simple;
	bh=QLRqouEXLdcG8ovaqcXnGJHMNPYu42jPSSvAjIGs2Eg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TmQJssrnEvRn7STZFROL76cfoF6GZL98K9hckb99/FYLEVXHVh3mbUQyciNLxKdMac+7S70enn6MDtYDjSbyM00JS9AlIOjNQNR9eWheyUUZRPGY2z5ghzuD0PLIzIQt3JxbAXFM2NAyGcUv7HAG6kEhFypLlBgF+ReGfc8OLhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qMsYbCdD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qMsYbCdD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3436C4CEC7;
	Mon, 14 Oct 2024 15:35:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728920103;
	bh=QLRqouEXLdcG8ovaqcXnGJHMNPYu42jPSSvAjIGs2Eg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qMsYbCdDoxnn9Rmsll9JcTKH0S24QQr4ZS0gb5koynYvPbgBDj5t5LCLAVQ/hNwRT
	 j56mesAx/+rqqEsudC3T3+6OCEfRAWn+dZm9d9Xo7hOnOR5/xzcdSoVxjzSIUilefa
	 atnUi0TbuE+0vgpOoe+9uDmun78mPo+dmkwpfr4M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Andi Kleen <ak@linux.intel.com>,
	Ian Rogers <irogers@google.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jiri Olsa <jolsa@kernel.org>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Kan Liang <kan.liang@linux.intel.com>,
	Leo Yan <leo.yan@linaro.org>,
	Mamatha Inamdar <mamatha4@linux.vnet.ibm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Ravi Bangoria <ravi.bangoria@amd.com>,
	Ross Zwisler <zwisler@chromium.org>,
	Sean Christopherson <seanjc@google.com>,
	"Steven Rostedt (VMware)" <rostedt@goodmis.org>,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Yang Jihong <yangjihong1@huawei.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 6.1 796/798] perf lock: Dont pass an ERR_PTR() directly to perf_session__delete()
Date: Mon, 14 Oct 2024 16:22:30 +0200
Message-ID: <20241014141249.344651001@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

commit abaf1e0355abb050f9c11d2d13a513caec80f7ad upstream.

While debugging a segfault on 'perf lock contention' without an
available perf.data file I noticed that it was basically calling:

	perf_session__delete(ERR_PTR(-1))

Resulting in:

  (gdb) run lock contention
  Starting program: /root/bin/perf lock contention
  [Thread debugging using libthread_db enabled]
  Using host libthread_db library "/lib64/libthread_db.so.1".
  failed to open perf.data: No such file or directory  (try 'perf record' first)
  Initializing perf session failed

  Program received signal SIGSEGV, Segmentation fault.
  0x00000000005e7515 in auxtrace__free (session=0xffffffffffffffff) at util/auxtrace.c:2858
  2858		if (!session->auxtrace)
  (gdb) p session
  $1 = (struct perf_session *) 0xffffffffffffffff
  (gdb) bt
  #0  0x00000000005e7515 in auxtrace__free (session=0xffffffffffffffff) at util/auxtrace.c:2858
  #1  0x000000000057bb4d in perf_session__delete (session=0xffffffffffffffff) at util/session.c:300
  #2  0x000000000047c421 in __cmd_contention (argc=0, argv=0x7fffffffe200) at builtin-lock.c:2161
  #3  0x000000000047dc95 in cmd_lock (argc=0, argv=0x7fffffffe200) at builtin-lock.c:2604
  #4  0x0000000000501466 in run_builtin (p=0xe597a8 <commands+552>, argc=2, argv=0x7fffffffe200) at perf.c:322
  #5  0x00000000005016d5 in handle_internal_command (argc=2, argv=0x7fffffffe200) at perf.c:375
  #6  0x0000000000501824 in run_argv (argcp=0x7fffffffe02c, argv=0x7fffffffe020) at perf.c:419
  #7  0x0000000000501b11 in main (argc=2, argv=0x7fffffffe200) at perf.c:535
  (gdb)

So just set it to NULL after using PTR_ERR(session) to decode the error
as perf_session__delete(NULL) is supported.

Fixes: eef4fee5e52071d5 ("perf lock: Dynamically allocate lockhash_table")
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: K Prateek Nayak <kprateek.nayak@amd.com>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Leo Yan <leo.yan@linaro.org>
Cc: Mamatha Inamdar <mamatha4@linux.vnet.ibm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ravi Bangoria <ravi.bangoria@amd.com>
Cc: Ross Zwisler <zwisler@chromium.org>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Steven Rostedt (VMware) <rostedt@goodmis.org>
Cc: Tiezhu Yang <yangtiezhu@loongson.cn>
Cc: Yang Jihong <yangjihong1@huawei.com>
Link: https://lore.kernel.org/lkml/ZN4R1AYfsD2J8lRs@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/builtin-lock.c |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/perf/builtin-lock.c
+++ b/tools/perf/builtin-lock.c
@@ -1660,6 +1660,7 @@ static int __cmd_contention(int argc, co
 	if (IS_ERR(session)) {
 		pr_err("Initializing perf session failed\n");
 		err = PTR_ERR(session);
+		session = NULL;
 		goto out_delete;
 	}
 


