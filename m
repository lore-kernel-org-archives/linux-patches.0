Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C01C4431
	for <patches@lists.linux.dev>; Wed, 15 Mar 2023 12:31:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE01FC433D2;
	Wed, 15 Mar 2023 12:31:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678883481;
	bh=MvlwO+kpLZ3PLjCXt/aB6elSh1+UHr037w3YIsIEYhY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RG0wYVWILizH8JibYKiX/PWPwibsbiIxGk8aCTOKIaJESn1sTR6DZwRU5+/ExG8VX
	 HFbyxtZOmCA9pofKewg1czJQb+1Q+lhUCjXF969htGeGb4y3ci0+AunisUjSgosMKu
	 /uhUU+MsSN2bT2haDaPjZN/1m597xu0/e0HO11K8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ian Rogers <irogers@google.com>,
	Ingo Molnar <mingo@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 6.1 006/143] perf inject: Fix --buildid-all not to eat up MMAP2
Date: Wed, 15 Mar 2023 13:11:32 +0100
Message-Id: <20230315115740.650858204@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115740.429574234@linuxfoundation.org>
References: <20230315115740.429574234@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Namhyung Kim <namhyung@kernel.org>

commit ce9f1c05d2edfa6cdf2c1a510495d333e11810a8 upstream.

When MMAP2 has the PERF_RECORD_MISC_MMAP_BUILD_ID flag, it means the
record already has the build-id info.  So it marks the DSO as hit, to
skip if the same DSO is not processed if it happens to miss the build-id
later.

But it missed to copy the MMAP2 record itself so it'd fail to symbolize
samples for those regions.

For example, the following generates 249 MMAP2 events.

  $ perf record --buildid-mmap -o- true | perf report --stat -i- | grep MMAP2
           MMAP2 events:        249  (86.8%)

Adding perf inject should not change the number of events like this

  $ perf record --buildid-mmap -o- true | perf inject -b | \
  > perf report --stat -i- | grep MMAP2
           MMAP2 events:        249  (86.5%)

But when --buildid-all is used, it eats most of the MMAP2 events.

  $ perf record --buildid-mmap -o- true | perf inject -b --buildid-all | \
  > perf report --stat -i- | grep MMAP2
           MMAP2 events:          1  ( 2.5%)

With this patch, it shows the original number now.

  $ perf record --buildid-mmap -o- true | perf inject -b --buildid-all | \
  > perf report --stat -i- | grep MMAP2
           MMAP2 events:        249  (86.5%)

Committer testing:

Before:

  $ perf record --buildid-mmap -o- perf stat --null sleep 1 2> /dev/null | perf inject -b | perf report --stat -i- | grep MMAP2
           MMAP2 events:         58  (36.2%)
  $ perf record --buildid-mmap -o- perf stat --null sleep 1 2> /dev/null | perf report --stat -i- | grep MMAP2
           MMAP2 events:         58  (36.2%)
  $ perf record --buildid-mmap -o- perf stat --null sleep 1 2> /dev/null | perf inject -b --buildid-all | perf report --stat -i- | grep MMAP2
           MMAP2 events:          2  ( 1.9%)
  $

After:

  $ perf record --buildid-mmap -o- perf stat --null sleep 1 2> /dev/null | perf inject -b | perf report --stat -i- | grep MMAP2
           MMAP2 events:         58  (29.3%)
  $ perf record --buildid-mmap -o- perf stat --null sleep 1 2> /dev/null | perf report --stat -i- | grep MMAP2
           MMAP2 events:         58  (34.3%)
  $ perf record --buildid-mmap -o- perf stat --null sleep 1 2> /dev/null | perf inject -b --buildid-all | perf report --stat -i- | grep MMAP2
           MMAP2 events:         58  (38.4%)
  $

Fixes: f7fc0d1c915a74ff ("perf inject: Do not inject BUILD_ID record if MMAP2 has it")
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20230223070155.54251-1-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/builtin-inject.c |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/perf/builtin-inject.c
+++ b/tools/perf/builtin-inject.c
@@ -538,6 +538,7 @@ static int perf_event__repipe_buildid_mm
 			dso->hit = 1;
 		}
 		dso__put(dso);
+		perf_event__repipe(tool, event, sample, machine);
 		return 0;
 	}
 


