Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2C9719D081;
	Thu,  6 Jun 2024 14:17:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683463; cv=none; b=Db8lmswwgQGZ7L0gT+aWOG6AWgTSHl/1koVleEmaG9BXts/aCaaYKo6tF2gDpYsS5UtdX9NwLXzSLcsaOoSFdBpir/m3mJkhv3v8u3M3y201PDcUy9DsaRv7eDkX4epm0lw6Xs9wf6yxbbIilPtXgQ5vXY3l7Xc+KhWCC6q6nBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683463; c=relaxed/simple;
	bh=XEHm8iXqyNnrEnD0Ux8r9h6aB9Se15bD3iyRORCuEiU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dujGl51d/djX1+EJ+t3CWfvhk0upGFmHTTP0Kex/PUpxWZ/JoekGLIbQDMxeypqyiUCHxXtCAw9rPOjIuEVClaP8AATBQr4B/cRko1W5spEy1slFb+y52XRzVpctrdAtJrDwvio7ea9tPQYFcnqnQZitEVZQe1A5rzhlcPisq2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F94Z4Sfg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F94Z4Sfg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAD3AC2BD10;
	Thu,  6 Jun 2024 14:17:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683462;
	bh=XEHm8iXqyNnrEnD0Ux8r9h6aB9Se15bD3iyRORCuEiU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F94Z4SfgtVMVS/CkiPUJf/OUnVz+sVR8NCMfUVFygtjkN7Nletn89pvMircVc/zS5
	 mfOYXjYmrjMNgXDjazrKl9iZzbCjuGYAJsjL6ljaDZoRAcEOHE8pIVjs2GACUEr2TT
	 HfJP5jTwUjznJBXTVK3Yf9oB4NJzN5sF+mkcWufM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Andi Kleen <ak@linux.intel.com>,
	Athira Jajeev <atrajeev@linux.vnet.ibm.com>,
	Changbin Du <changbin.du@huawei.com>,
	Colin Ian King <colin.i.king@gmail.com>,
	Dmitrii Dolgov <9erthalion6@gmail.com>,
	German Gomez <german.gomez@arm.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	James Clark <james.clark@arm.com>,
	Jiri Olsa <jolsa@kernel.org>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Kajol Jain <kjain@linux.ibm.com>,
	Kan Liang <kan.liang@linux.intel.com>,
	Leo Yan <leo.yan@linaro.org>,
	Li Dong <lidong@vivo.com>,
	Liam Howlett <liam.howlett@oracle.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Ming Wang <wangming01@loongson.cn>,
	Nick Terrell <terrelln@fb.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Ravi Bangoria <ravi.bangoria@amd.com>,
	Sandipan Das <sandipan.das@amd.com>,
	Sean Christopherson <seanjc@google.com>,
	"Steinar H. Gunderson" <sesse@google.com>,
	Vincent Whitchurch <vincent.whitchurch@axis.com>,
	Wenyu Liu <liuwenyu7@huawei.com>,
	Yang Jihong <yangjihong1@huawei.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 407/744] perf record: Lazy load kernel symbols
Date: Thu,  6 Jun 2024 16:01:19 +0200
Message-ID: <20240606131745.517224945@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Rogers <irogers@google.com>

[ Upstream commit 1a27fc01700fbff2f205000edf0d1d315b5f85cc ]

Commit 5b7ba82a75915e73 ("perf symbols: Load kernel maps before using")
changed it so that loading a kernel DSO would cause the symbols for the
DSO to be eagerly loaded.

For 'perf record' this is overhead as the symbols won't be used. Add a
field to 'struct symbol_conf' to control the behavior and disable it for
'perf record' and 'perf inject'.

Reviewed-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Ian Rogers <irogers@google.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Athira Jajeev <atrajeev@linux.vnet.ibm.com>
Cc: Changbin Du <changbin.du@huawei.com>
Cc: Colin Ian King <colin.i.king@gmail.com>
Cc: Dmitrii Dolgov <9erthalion6@gmail.com>
Cc: German Gomez <german.gomez@arm.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Clark <james.clark@arm.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: K Prateek Nayak <kprateek.nayak@amd.com>
Cc: Kajol Jain <kjain@linux.ibm.com>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Leo Yan <leo.yan@linaro.org>
Cc: Li Dong <lidong@vivo.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Ming Wang <wangming01@loongson.cn>
Cc: Nick Terrell <terrelln@fb.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ravi Bangoria <ravi.bangoria@amd.com>
Cc: Sandipan Das <sandipan.das@amd.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Steinar H. Gunderson <sesse@google.com>
Cc: Vincent Whitchurch <vincent.whitchurch@axis.com>
Cc: Wenyu Liu <liuwenyu7@huawei.com>
Cc: Yang Jihong <yangjihong1@huawei.com>
Link: https://lore.kernel.org/r/20231102175735.2272696-3-irogers@google.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Stable-dep-of: aaf494cf483a ("perf annotate: Fix annotation_calc_lines() to pass correct address to get_srcline()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-inject.c   | 6 ++++++
 tools/perf/builtin-record.c   | 2 ++
 tools/perf/util/event.c       | 4 ++--
 tools/perf/util/symbol_conf.h | 3 ++-
 4 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
index c8cf2fdd9cff9..eb3ef5c24b662 100644
--- a/tools/perf/builtin-inject.c
+++ b/tools/perf/builtin-inject.c
@@ -2265,6 +2265,12 @@ int cmd_inject(int argc, const char **argv)
 		"perf inject [<options>]",
 		NULL
 	};
+
+	if (!inject.itrace_synth_opts.set) {
+		/* Disable eager loading of kernel symbols that adds overhead to perf inject. */
+		symbol_conf.lazy_load_kernel_maps = true;
+	}
+
 #ifndef HAVE_JITDUMP
 	set_option_nobuild(options, 'j', "jit", "NO_LIBELF=1", true);
 #endif
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index ea80bf4dc4343..5c54fda63b581 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -3936,6 +3936,8 @@ int cmd_record(int argc, const char **argv)
 # undef set_nobuild
 #endif
 
+	/* Disable eager loading of kernel symbols that adds overhead to perf record. */
+	symbol_conf.lazy_load_kernel_maps = true;
 	rec->opts.affinity = PERF_AFFINITY_SYS;
 
 	rec->evlist = evlist__new();
diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 923c0fb151222..68f45e9e63b6e 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -617,13 +617,13 @@ struct map *thread__find_map(struct thread *thread, u8 cpumode, u64 addr,
 	if (cpumode == PERF_RECORD_MISC_KERNEL && perf_host) {
 		al->level = 'k';
 		maps = machine__kernel_maps(machine);
-		load_map = true;
+		load_map = !symbol_conf.lazy_load_kernel_maps;
 	} else if (cpumode == PERF_RECORD_MISC_USER && perf_host) {
 		al->level = '.';
 	} else if (cpumode == PERF_RECORD_MISC_GUEST_KERNEL && perf_guest) {
 		al->level = 'g';
 		maps = machine__kernel_maps(machine);
-		load_map = true;
+		load_map = !symbol_conf.lazy_load_kernel_maps;
 	} else if (cpumode == PERF_RECORD_MISC_GUEST_USER && perf_guest) {
 		al->level = 'u';
 	} else {
diff --git a/tools/perf/util/symbol_conf.h b/tools/perf/util/symbol_conf.h
index 0b589570d1d09..2b2fb9e224b00 100644
--- a/tools/perf/util/symbol_conf.h
+++ b/tools/perf/util/symbol_conf.h
@@ -42,7 +42,8 @@ struct symbol_conf {
 			inline_name,
 			disable_add2line_warn,
 			buildid_mmap2,
-			guest_code;
+			guest_code,
+			lazy_load_kernel_maps;
 	const char	*vmlinux_name,
 			*kallsyms_name,
 			*source_prefix,
-- 
2.43.0



