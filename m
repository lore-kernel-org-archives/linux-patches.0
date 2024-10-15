Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16E9B1E7C34;
	Tue, 15 Oct 2024 11:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992878; cv=none; b=ShQuuX5GlscAHmWzp07wzA2PRRmhY/6LQpAFQHnCXlWCbxOvhytNk64leRlJ2eDmu/UENhTe77AhOl8kygUWIL0Imzd2OrUKyD9ZNcJe+bxEAG/Roy4+XW9eKK/PQdkGXu5fKpHi0IqKjCISsqD/JigwiZXI8Wk4iMY7mYqo4p4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992878; c=relaxed/simple;
	bh=7NDMpc1gxJEeLVtnAQ+nVpl2ho6LgRfxUkEjGYoUNp8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qu36ts/7/U497y7QLdrRI4ncQh1Mf8Xxh2IWJHIUgmZsD/rBNMPTf+qb1Foo9I3Avbk62pBTjfMZjzS11u0+m5O5zSp0LKn5dqVq/54N5NSLW8Ca2JdZc7BzcjBetLRJh9FUa51mbzHuIx3xkiZPDTz2Albsd6rGzM6/C15lFOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GNaB+c6K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GNaB+c6K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65A54C4CEC6;
	Tue, 15 Oct 2024 11:47:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992878;
	bh=7NDMpc1gxJEeLVtnAQ+nVpl2ho6LgRfxUkEjGYoUNp8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GNaB+c6K6eMVdGtEf8/Z+CjMVy30b0jf/g+Dc+Fi94yEM4EsI8pecQYs3ki6lDe+p
	 WTCZffkXAg8zRiKC5HMq1nJv4vYpnCC9AFji0mFixWk5YihXEIx0VhXOF9QIvbDolR
	 Eem2RE9ywbvSJ8sCP7W0bQ1UCzYU8AAVngM/2sUg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namhyung Kim <namhyung@kernel.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Athira Rajeev <atrajeev@linux.vnet.ibm.com>,
	Ian Rogers <irogers@google.com>,
	Ingo Molnar <mingo@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Kan Liang <kan.liang@linux.intel.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Stephane Eranian <eranian@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 214/691] perf mem: Free the allocated sort string, fixing a leak
Date: Tue, 15 Oct 2024 13:22:42 +0200
Message-ID: <20241015112448.851668639@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namhyung Kim <namhyung@kernel.org>

[ Upstream commit 3da209bb1177462b6fe8e3021a5527a5a49a9336 ]

The get_sort_order() returns either a new string (from strdup) or NULL
but it never gets freed.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Fixes: 2e7f545096f954a9 ("perf mem: Factor out a function to generate sort order")
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Athira Rajeev <atrajeev@linux.vnet.ibm.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: https://lore.kernel.org/r/20240731235505.710436-3-namhyung@kernel.org
[ Added Fixes tag ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-mem.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/builtin-mem.c b/tools/perf/builtin-mem.c
index fcf65a59bea21..f0a452338e642 100644
--- a/tools/perf/builtin-mem.c
+++ b/tools/perf/builtin-mem.c
@@ -358,6 +358,7 @@ static int report_events(int argc, const char **argv, struct perf_mem *mem)
 		rep_argv[i] = argv[j];
 
 	ret = cmd_report(i, rep_argv);
+	free(new_sort_order);
 	free(rep_argv);
 	return ret;
 }
-- 
2.43.0



