Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCCBF3309F
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:47:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BZ8jAhlY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B810C433C7;
	Wed, 15 Nov 2023 19:47:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077668;
	bh=1O15XiFFnyrvv54QAkdcrjnXlUMm2Roi/xZ7Vdq4FCs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BZ8jAhlYbNgMvTv18bW9yocvzlTvljmM0HlcCWn7+tEd1oGzzh0CKATkE6cH1H3st
	 XtlxsXxfR3uzXhodgKck0ae9t/H9sRjVmiwyJMttdBjdKMUPVeJaJ3HxkfxVi3b9t4
	 e0WIHxogwGgSlWxB0uqV2/HRrAPCjVKd+uJikfnc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Yang Jihong <yangjihong1@huawei.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Kan Liang <kan.liang@linux.intel.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ravi Bangoria <ravi.bangoria@amd.com>,
	Sandipan Das <sandipan.das@amd.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 422/603] perf kwork: Fix incorrect and missing free atom in work_push_atom()
Date: Wed, 15 Nov 2023 14:16:07 -0500
Message-ID: <20231115191642.013933582@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
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

From: Yang Jihong <yangjihong1@huawei.com>

[ Upstream commit d39710088d82ef100b33cdf4a9de3546fb0bb5df ]

1. Atoms are managed in page mode and should be released using atom_free()
   instead of free().
2. When the event does not match, the atom needs to free.

Fixes: f98919ec4fccdacf ("perf kwork: Implement 'report' subcommand")
Reviewed-by: Ian Rogers <irogers@google.com>
Signed-off-by: Yang Jihong <yangjihong1@huawei.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ravi Bangoria <ravi.bangoria@amd.com>
Cc: Sandipan Das <sandipan.das@amd.com>
Cc: Yang Jihong <yangjihong1@huawei.com>
Link: https://lore.kernel.org/r/20230812084917.169338-2-yangjihong1@huawei.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-kwork.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-kwork.c b/tools/perf/builtin-kwork.c
index 14bf7a8429e76..73b5dc099a8ae 100644
--- a/tools/perf/builtin-kwork.c
+++ b/tools/perf/builtin-kwork.c
@@ -406,12 +406,14 @@ static int work_push_atom(struct perf_kwork *kwork,
 
 	work = work_findnew(&class->work_root, &key, &kwork->cmp_id);
 	if (work == NULL) {
-		free(atom);
+		atom_free(atom);
 		return -1;
 	}
 
-	if (!profile_event_match(kwork, work, sample))
+	if (!profile_event_match(kwork, work, sample)) {
+		atom_free(atom);
 		return 0;
+	}
 
 	if (dst_type < KWORK_TRACE_MAX) {
 		dst_atom = list_last_entry_or_null(&work->atom_list[dst_type],
-- 
2.42.0



