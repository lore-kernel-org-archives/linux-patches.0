Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB7F7FBE7
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:18:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E29BC433D2;
	Mon, 15 May 2023 17:18:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684171090;
	bh=N4j3UetDREU97zvtSxjpWrR8AZlNcTWfAVMJuufj21w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N0VnaXZ8bRmtUAE+S5A5MA5xrBCVOnm+Wp2aWAWiSzwRYVOQaBZd/plUtRVa8FxGQ
	 FZk4edqgRbV/YaOxovnJajndiC19mJuJUpNZBByca6mtHqsnVvy9NJ1eZiqiSA6JYO
	 mc0zWp3P/4es47qQ21TfTDgypuBZEXD5gnq43HAA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namhyung Kim <namhyung@kernel.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ian Rogers <irogers@google.com>,
	Ingo Molnar <mingo@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 097/242] perf hist: Improve srcfile sort key performance (really)
Date: Mon, 15 May 2023 18:27:03 +0200
Message-Id: <20230515161724.817887906@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161721.802179972@linuxfoundation.org>
References: <20230515161721.802179972@linuxfoundation.org>
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

[ Upstream commit 6094c7744bb0563e833e81d8df8513f9a4e7a257 ]

The earlier commit f0cdde28fecc0d7f ("perf hist: Improve srcfile sort
key performance") updated the srcfile logic but missed to change the
->cmp() callback which is called for every sample.

It should use the same logic like in the srcline to speed up the
processing because it'd return the same information repeatedly for the
same address.  The real processing will be done in
sort__srcfile_collapse().

Fixes: f0cdde28fecc0d7f ("perf hist: Improve srcfile sort key performance")
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/r/20230323025005.191239-1-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/sort.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 37662cdec5eef..2bf3f88276972 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -603,12 +603,7 @@ static char *hist_entry__get_srcfile(struct hist_entry *e)
 static int64_t
 sort__srcfile_cmp(struct hist_entry *left, struct hist_entry *right)
 {
-	if (!left->srcfile)
-		left->srcfile = hist_entry__get_srcfile(left);
-	if (!right->srcfile)
-		right->srcfile = hist_entry__get_srcfile(right);
-
-	return strcmp(right->srcfile, left->srcfile);
+	return sort__srcline_cmp(left, right);
 }
 
 static int64_t
-- 
2.39.2



