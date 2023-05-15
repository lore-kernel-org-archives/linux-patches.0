Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9FDDFBF0
	for <patches@lists.linux.dev>; Mon, 15 May 2023 16:54:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0955EC4339C;
	Mon, 15 May 2023 16:54:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684169682;
	bh=NaZNEGS6O5ILStabR1IvWojNITJtGUYuoha+BNTrc/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qzXXay/b/Rs65hTH1ucG3havTA+AtX662Vfqp1EIBdWx1Etfu/tpWTJruKqEvcFhS
	 YP0JKYuEczpMssCVEhc/IlevXT/cvtifXgIXi5lwCmdsWdn/7m6RvVCWPBK1u1puvv
	 2EdRIIhjb5FRCZB7eyt2yWH05C70iNsOI08zXbh4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Jihong <yangjihong1@huawei.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Ian Rogers <irogers@google.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 119/246] perf tracepoint: Fix memory leak in is_valid_tracepoint()
Date: Mon, 15 May 2023 18:25:31 +0200
Message-Id: <20230515161726.140668182@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161722.610123835@linuxfoundation.org>
References: <20230515161722.610123835@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yang Jihong <yangjihong1@huawei.com>

[ Upstream commit 9b86c49710eec7b4fbb78a0232b2dd0972a2b576 ]

When is_valid_tracepoint() returns 1, need to call put_events_file() to
free `dir_path`.

Fixes: 25a7d914274de386 ("perf parse-events: Use get/put_events_file()")
Signed-off-by: Yang Jihong <yangjihong1@huawei.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/r/20230421025953.173826-1-yangjihong1@huawei.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/tracepoint.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/util/tracepoint.c b/tools/perf/util/tracepoint.c
index 89ef56c433110..92dd8b455b902 100644
--- a/tools/perf/util/tracepoint.c
+++ b/tools/perf/util/tracepoint.c
@@ -50,6 +50,7 @@ int is_valid_tracepoint(const char *event_string)
 				 sys_dirent->d_name, evt_dirent->d_name);
 			if (!strcmp(evt_path, event_string)) {
 				closedir(evt_dir);
+				put_events_file(dir_path);
 				closedir(sys_dir);
 				return 1;
 			}
-- 
2.39.2



