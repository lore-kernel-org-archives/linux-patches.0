Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B64F1FBE7
	for <patches@lists.linux.dev>; Mon, 15 May 2023 16:46:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F301BC433D2;
	Mon, 15 May 2023 16:46:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684169169;
	bh=MA3pOBcw0Blx9oc3CB8MKCWytyOZvgd1wY1tuTwyo90=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a5O0LrGAbo/4O9bIdxr+YctZIdzxiTD501CX9a8ckg5Fvfny6vqXvNTwtALLEiCzA
	 cBenwGzxZrc4A42wbAHnk7qj6nzdCEz7oLmnK+Lh/g8MC6FtYuectdnNpAMxC1HKw6
	 nzmTM3c1kFqVfrlt8VEtgn/a4idBzzExrfqrG7FQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	elfring@users.sourceforge.net,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Andi Kleen <ak@linux.intel.com>,
	German Gomez <german.gomez@arm.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Kan Liang <kan.liang@linux.intel.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 165/191] perf map: Delete two variable initialisations before null pointer checks in sort__sym_from_cmp()
Date: Mon, 15 May 2023 18:26:42 +0200
Message-Id: <20230515161713.423658582@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161707.203549282@linuxfoundation.org>
References: <20230515161707.203549282@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Markus Elfring <Markus.Elfring@web.de>

[ Upstream commit c160118a90d4acf335993d8d59b02ae2147a524e ]

Addresses of two data structure members were determined before
corresponding null pointer checks in the implementation of the function
“sort__sym_from_cmp”.

Thus avoid the risk for undefined behaviour by removing extra
initialisations for the local variables “from_l” and “from_r” (also
because they were already reassigned with the same value behind this
pointer check).

This issue was detected by using the Coccinelle software.

Fixes: 1b9e97a2a95e4941 ("perf tools: Fix report -F symbol_from for data without branch info")
Signed-off-by: <elfring@users.sourceforge.net>
Acked-by: Ian Rogers <irogers@google.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: German Gomez <german.gomez@arm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: https://lore.kernel.org/cocci/54a21fea-64e3-de67-82ef-d61b90ffad05@web.de/
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/sort.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 85ff4f68adc00..66e11e6bb7197 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -735,8 +735,7 @@ static int hist_entry__dso_to_filter(struct hist_entry *he, int type,
 static int64_t
 sort__sym_from_cmp(struct hist_entry *left, struct hist_entry *right)
 {
-	struct addr_map_symbol *from_l = &left->branch_info->from;
-	struct addr_map_symbol *from_r = &right->branch_info->from;
+	struct addr_map_symbol *from_l, *from_r;
 
 	if (!left->branch_info || !right->branch_info)
 		return cmp_null(left->branch_info, right->branch_info);
-- 
2.39.2



