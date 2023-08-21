Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78DAD1171A
	for <patches@lists.linux.dev>; Mon, 21 Aug 2023 20:09:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65F8EC433C9;
	Mon, 21 Aug 2023 20:09:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692648592;
	bh=yfr9ouv8Hp1Er3PAtgy96F6elTtE90Us+wIaxyFy3pQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AZwJxyo03LjLcECd3IzCQLv9LWt90p/1c2NZd9mwswjptSHT097RMU2qAD8r+2W/R
	 tzGRaHZpLO45AZCb8hMRMe7SXPNOXh0FSmUNu0t70ZkvyqPSnLxigPhekvgbi8wN1F
	 hhvPyLQUe6fRjzvsP5HkhHDPHU1WGkgYHlfYIeaE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	Artem Savkov <asavkov@redhat.com>,
	Andrii Nakryiko <andrii.nakryiko@gmail.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Ian Rogers <irogers@google.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Milian Wolff <milian.wolff@kdab.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 6.4 231/234] Revert "perf report: Append inlines to non-DWARF callchains"
Date: Mon, 21 Aug 2023 21:43:14 +0200
Message-ID: <20230821194139.137391592@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230821194128.754601642@linuxfoundation.org>
References: <20230821194128.754601642@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Arnaldo Carvalho de Melo <acme@kernel.org>

commit c0b067588a4836b762cfc6a4c83f122ca1dbb93a upstream.

This reverts commit 46d21ec067490ab9cdcc89b9de5aae28786a8b8e.

The tests were made with a specific workload, further tests on a
recently updated fedora 38 system with a system wide perf.data file
shows 'perf report' taking excessive time resolving inlines in vmlinux,
so lets revert this until a full investigation and improvement on the
addr2line support code is made.

Reported-by: Jesper Dangaard Brouer <hawk@kernel.org>
Acked-by: Artem Savkov <asavkov@redhat.com>
Tested-by: Jesper Dangaard Brouer <hawk@kernel.org>
Cc: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Milian Wolff <milian.wolff@kdab.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/r/ZMl8VyhdwhClTM5g@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/util/machine.c |    5 -----
 1 file changed, 5 deletions(-)

--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -44,7 +44,6 @@
 #include <linux/zalloc.h>
 
 static void __machine__remove_thread(struct machine *machine, struct thread *th, bool lock);
-static int append_inlines(struct callchain_cursor *cursor, struct map_symbol *ms, u64 ip);
 
 static struct dso *machine__kernel_dso(struct machine *machine)
 {
@@ -2371,10 +2370,6 @@ static int add_callchain_ip(struct threa
 	ms.maps = al.maps;
 	ms.map = al.map;
 	ms.sym = al.sym;
-
-	if (!branch && append_inlines(cursor, &ms, ip) == 0)
-		return 0;
-
 	srcline = callchain_srcline(&ms, al.addr);
 	err = callchain_cursor_append(cursor, ip, &ms,
 				      branch, flags, nr_loop_iter,


