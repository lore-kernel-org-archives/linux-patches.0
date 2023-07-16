Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CA588F57
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:44:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8CD6C433C7;
	Sun, 16 Jul 2023 20:44:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689540257;
	bh=ssS6NoeZPznto/j6tUYLkYkN061S0a1KfAe5TzTjeqE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eG5AfuLnbOV+CtxkJW/6zCsrWWnnSYLxAeFIQVQiiSIeORSy45qKdNd2BfzBeCKw/
	 fCGhWBLH24XcXfANkivF4Ca1UU29dkZtoTev/jhMsHt/eHlnDbXgxHPIhDy6u1e1M9
	 TPseYi84RECx55zMCi7KxutfQJzJshFHZxXs4jHw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Andre Fredette <anfredet@redhat.com>,
	Clark Williams <williams@redhat.com>,
	Dave Tucker <datucker@redhat.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Derek Barbosa <debarbos@redhat.com>,
	Ian Rogers <irogers@google.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 299/591] perf bench: Add missing setlocale() call to allow usage of %d style formatting
Date: Sun, 16 Jul 2023 21:47:18 +0200
Message-ID: <20230716194931.631879294@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 16203e9cd01896b4244100a8e3fb9f6e612ab2b1 ]

Without this we were not getting the thousands separator for big
numbers.

Noticed while developing 'perf bench uprobe', but the use of %' predates
that, for instance 'perf bench syscall' uses it.

Before:

  # perf bench uprobe all
  # Running uprobe/baseline benchmark...
  # Executed 1000 usleep(1000) calls
       Total time: 1054082243ns

   1054082.243000 nsecs/op

  #

After:

  # perf bench uprobe all
  # Running uprobe/baseline benchmark...
  # Executed 1,000 usleep(1000) calls
       Total time: 1,053,715,144ns

   1,053,715.144000 nsecs/op

  #

Fixes: c2a08203052f8975 ("perf bench: Add basic syscall benchmark")
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Andre Fredette <anfredet@redhat.com>
Cc: Clark Williams <williams@redhat.com>
Cc: Dave Tucker <datucker@redhat.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Derek Barbosa <debarbos@redhat.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Tiezhu Yang <yangtiezhu@loongson.cn>
Link: https://lore.kernel.org/lkml/ZH3lcepZ4tBYr1jv@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-bench.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/perf/builtin-bench.c b/tools/perf/builtin-bench.c
index 334ab897aae3b..a5c2a6938b4e4 100644
--- a/tools/perf/builtin-bench.c
+++ b/tools/perf/builtin-bench.c
@@ -21,6 +21,7 @@
 #include "builtin.h"
 #include "bench/bench.h"
 
+#include <locale.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
@@ -256,6 +257,7 @@ int cmd_bench(int argc, const char **argv)
 
 	/* Unbuffered output */
 	setvbuf(stdout, NULL, _IONBF, 0);
+	setlocale(LC_ALL, "");
 
 	if (argc < 2) {
 		/* No collection specified. */
-- 
2.39.2



