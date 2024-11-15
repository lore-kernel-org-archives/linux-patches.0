Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1CE015FD13;
	Fri, 15 Nov 2024 06:57:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653847; cv=none; b=p5d3rDKwKmWBeCvL2BnlIBlX5MZszH/b4WVDtEep4oOEe+mKuplBijeplKvpRby8yc+ZnG2PznYNMmkgeooLrGZ8DAwBacnIMLN3toE9s/bHo0G5ksCBfVcq+XmcucFOaapjPclYkpwBJVP+fwx0dcc+2nkyuap4G3P34R3s7cU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653847; c=relaxed/simple;
	bh=m2ef4UXVm2eUy+ko6wTqrot0ZiwUnvR73Q1o/PEKghE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kMan3c5lcWToZzHl2XzbnTyjYhDqVFK63q+kjoXSfR4SVfH12DfA2SW72F8uRFZQ5dbdN9R+I0f01d11W6ybfCvlUl8aLekFj+F0Gd1h8uQx1biPoIPeEvYyTRD7/Zy7I2VxVaInejKVWhnpOjz3luPUFuiLkgbgSyP/QK2GEac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pkhu0+bv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pkhu0+bv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38A8FC4CECF;
	Fri, 15 Nov 2024 06:57:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653846;
	bh=m2ef4UXVm2eUy+ko6wTqrot0ZiwUnvR73Q1o/PEKghE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pkhu0+bv4f3MVE63sdI1HY1jCl7Q+i5AqwOtGqMApCfsadQIMhV2RiHSlVEtN6eNC
	 9qIcM8uqM7oER2s9aJM3Y/UiE2Z8kx5D/NWpicFad0h9pKLUIjanbfxMRPm9J8tbOv
	 9uIylIC8XwXpGcKFwEC2XqKphseqEr45VQrvAHPI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Riccardo Mancini <rickyman7@gmail.com>,
	Ian Rogers <irogers@google.com>,
	Jiri Olsa <jolsa@redhat.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Kan Liang <kan.liang@linux.intel.com>,
	Leo Yan <leo.yan@linaro.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Shuai Xue <xueshuai@linux.alibaba.com>
Subject: [PATCH 5.10 52/82] perf session: Add missing evlist__delete when deleting a session
Date: Fri, 15 Nov 2024 07:38:29 +0100
Message-ID: <20241115063727.435598002@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063725.561151311@linuxfoundation.org>
References: <20241115063725.561151311@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Riccardo Mancini <rickyman7@gmail.com>

commit cf96b8e45a9bf74d2a6f1e1f88a41b10e9357c6b upstream.

ASan reports a memory leak caused by evlist not being deleted on exit in
perf-report, perf-script and perf-data.
The problem is caused by evlist->session not being deleted, which is
allocated in perf_session__read_header, called in perf_session__new if
perf_data is in read mode.
In case of write mode, the session->evlist is filled by the caller.
This patch solves the problem by calling evlist__delete in
perf_session__delete if perf_data is in read mode.

Changes in v2:
 - call evlist__delete from within perf_session__delete

v1: https://lore.kernel.org/lkml/20210621234317.235545-1-rickyman7@gmail.com/

ASan report follows:

$ ./perf script report flamegraph
=================================================================
==227640==ERROR: LeakSanitizer: detected memory leaks

<SNIP unrelated>

Indirect leak of 2704 byte(s) in 1 object(s) allocated from:
    #0 0x4f4137 in calloc (/home/user/linux/tools/perf/perf+0x4f4137)
    #1 0xbe3d56 in zalloc /home/user/linux/tools/lib/perf/../../lib/zalloc.c:8:9
    #2 0x7f999e in evlist__new /home/user/linux/tools/perf/util/evlist.c:77:26
    #3 0x8ad938 in perf_session__read_header /home/user/linux/tools/perf/util/header.c:3797:20
    #4 0x8ec714 in perf_session__open /home/user/linux/tools/perf/util/session.c:109:6
    #5 0x8ebe83 in perf_session__new /home/user/linux/tools/perf/util/session.c:213:10
    #6 0x60c6de in cmd_script /home/user/linux/tools/perf/builtin-script.c:3856:12
    #7 0x7b2930 in run_builtin /home/user/linux/tools/perf/perf.c:313:11
    #8 0x7b120f in handle_internal_command /home/user/linux/tools/perf/perf.c:365:8
    #9 0x7b2493 in run_argv /home/user/linux/tools/perf/perf.c:409:2
    #10 0x7b0c89 in main /home/user/linux/tools/perf/perf.c:539:3
    #11 0x7f5260654b74  (/lib64/libc.so.6+0x27b74)

Indirect leak of 568 byte(s) in 1 object(s) allocated from:
    #0 0x4f4137 in calloc (/home/user/linux/tools/perf/perf+0x4f4137)
    #1 0xbe3d56 in zalloc /home/user/linux/tools/lib/perf/../../lib/zalloc.c:8:9
    #2 0x80ce88 in evsel__new_idx /home/user/linux/tools/perf/util/evsel.c:268:24
    #3 0x8aed93 in evsel__new /home/user/linux/tools/perf/util/evsel.h:210:9
    #4 0x8ae07e in perf_session__read_header /home/user/linux/tools/perf/util/header.c:3853:11
    #5 0x8ec714 in perf_session__open /home/user/linux/tools/perf/util/session.c:109:6
    #6 0x8ebe83 in perf_session__new /home/user/linux/tools/perf/util/session.c:213:10
    #7 0x60c6de in cmd_script /home/user/linux/tools/perf/builtin-script.c:3856:12
    #8 0x7b2930 in run_builtin /home/user/linux/tools/perf/perf.c:313:11
    #9 0x7b120f in handle_internal_command /home/user/linux/tools/perf/perf.c:365:8
    #10 0x7b2493 in run_argv /home/user/linux/tools/perf/perf.c:409:2
    #11 0x7b0c89 in main /home/user/linux/tools/perf/perf.c:539:3
    #12 0x7f5260654b74  (/lib64/libc.so.6+0x27b74)

Indirect leak of 264 byte(s) in 1 object(s) allocated from:
    #0 0x4f4137 in calloc (/home/user/linux/tools/perf/perf+0x4f4137)
    #1 0xbe3d56 in zalloc /home/user/linux/tools/lib/perf/../../lib/zalloc.c:8:9
    #2 0xbe3e70 in xyarray__new /home/user/linux/tools/lib/perf/xyarray.c:10:23
    #3 0xbd7754 in perf_evsel__alloc_id /home/user/linux/tools/lib/perf/evsel.c:361:21
    #4 0x8ae201 in perf_session__read_header /home/user/linux/tools/perf/util/header.c:3871:7
    #5 0x8ec714 in perf_session__open /home/user/linux/tools/perf/util/session.c:109:6
    #6 0x8ebe83 in perf_session__new /home/user/linux/tools/perf/util/session.c:213:10
    #7 0x60c6de in cmd_script /home/user/linux/tools/perf/builtin-script.c:3856:12
    #8 0x7b2930 in run_builtin /home/user/linux/tools/perf/perf.c:313:11
    #9 0x7b120f in handle_internal_command /home/user/linux/tools/perf/perf.c:365:8
    #10 0x7b2493 in run_argv /home/user/linux/tools/perf/perf.c:409:2
    #11 0x7b0c89 in main /home/user/linux/tools/perf/perf.c:539:3
    #12 0x7f5260654b74  (/lib64/libc.so.6+0x27b74)

Indirect leak of 32 byte(s) in 1 object(s) allocated from:
    #0 0x4f4137 in calloc (/home/user/linux/tools/perf/perf+0x4f4137)
    #1 0xbe3d56 in zalloc /home/user/linux/tools/lib/perf/../../lib/zalloc.c:8:9
    #2 0xbd77e0 in perf_evsel__alloc_id /home/user/linux/tools/lib/perf/evsel.c:365:14
    #3 0x8ae201 in perf_session__read_header /home/user/linux/tools/perf/util/header.c:3871:7
    #4 0x8ec714 in perf_session__open /home/user/linux/tools/perf/util/session.c:109:6
    #5 0x8ebe83 in perf_session__new /home/user/linux/tools/perf/util/session.c:213:10
    #6 0x60c6de in cmd_script /home/user/linux/tools/perf/builtin-script.c:3856:12
    #7 0x7b2930 in run_builtin /home/user/linux/tools/perf/perf.c:313:11
    #8 0x7b120f in handle_internal_command /home/user/linux/tools/perf/perf.c:365:8
    #9 0x7b2493 in run_argv /home/user/linux/tools/perf/perf.c:409:2
    #10 0x7b0c89 in main /home/user/linux/tools/perf/perf.c:539:3
    #11 0x7f5260654b74  (/lib64/libc.so.6+0x27b74)

Indirect leak of 7 byte(s) in 1 object(s) allocated from:
    #0 0x4b8207 in strdup (/home/user/linux/tools/perf/perf+0x4b8207)
    #1 0x8b4459 in evlist__set_event_name /home/user/linux/tools/perf/util/header.c:2292:16
    #2 0x89d862 in process_event_desc /home/user/linux/tools/perf/util/header.c:2313:3
    #3 0x8af319 in perf_file_section__process /home/user/linux/tools/perf/util/header.c:3651:9
    #4 0x8aa6e9 in perf_header__process_sections /home/user/linux/tools/perf/util/header.c:3427:9
    #5 0x8ae3e7 in perf_session__read_header /home/user/linux/tools/perf/util/header.c:3886:2
    #6 0x8ec714 in perf_session__open /home/user/linux/tools/perf/util/session.c:109:6
    #7 0x8ebe83 in perf_session__new /home/user/linux/tools/perf/util/session.c:213:10
    #8 0x60c6de in cmd_script /home/user/linux/tools/perf/builtin-script.c:3856:12
    #9 0x7b2930 in run_builtin /home/user/linux/tools/perf/perf.c:313:11
    #10 0x7b120f in handle_internal_command /home/user/linux/tools/perf/perf.c:365:8
    #11 0x7b2493 in run_argv /home/user/linux/tools/perf/perf.c:409:2
    #12 0x7b0c89 in main /home/user/linux/tools/perf/perf.c:539:3
    #13 0x7f5260654b74  (/lib64/libc.so.6+0x27b74)

SUMMARY: AddressSanitizer: 3728 byte(s) leaked in 7 allocation(s).

Signed-off-by: Riccardo Mancini <rickyman7@gmail.com>
Acked-by: Ian Rogers <irogers@google.com>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Leo Yan <leo.yan@linaro.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lore.kernel.org/lkml/20210624231926.212208-1-rickyman7@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: stable@vger.kernel.org # 5.10.228
Signed-off-by: Shuai Xue <xueshuai@linux.alibaba.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/util/session.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -299,8 +299,11 @@ void perf_session__delete(struct perf_se
 	perf_session__release_decomp_events(session);
 	perf_env__exit(&session->header.env);
 	machines__exit(&session->machines);
-	if (session->data)
+	if (session->data) {
+		if (perf_data__is_read(session->data))
+			evlist__delete(session->evlist);
 		perf_data__close(session->data);
+	}
 	free(session);
 }
 


