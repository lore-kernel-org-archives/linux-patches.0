Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 365E71D1E60;
	Wed,  2 Oct 2024 14:36:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879808; cv=none; b=WF5c0ybaDLlL/QioA8mO0rzY/dKBEQmZ99yrJtRHlZuHV9jcVxi5CEcLEO6gjnzdl8TuVp8xLCxuIPrmVwQ4P/DP/ElxvSs5dvH9T4kMNhhzoMFb5LZckQV6Z6JhqPiA/Ow29zV7cXYsVELpU81QqmG63mPZdhntNjcfz9PXTEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879808; c=relaxed/simple;
	bh=66vRco0kXi6ZUfKE425SzAnNE69CiZOzNfhDXvVgKJw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YionubkFpDgbaMn9pqrHzZ4Vp/uC7NHiG8RZa0cP4WyONz2MNEwAcc7kl1Yt4AmO8aFiXmu+AjBxevyGvdEttEv8ou/6+gMb+ZKH7M9d7JzkqpFyfBWmAkfx9qANx5DL5ID51ClJfOrstknh23N2MolZqMj1z1qL+7U1kDOrlc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iGbuazjU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iGbuazjU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 827D2C4CEC5;
	Wed,  2 Oct 2024 14:36:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879808;
	bh=66vRco0kXi6ZUfKE425SzAnNE69CiZOzNfhDXvVgKJw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iGbuazjU0st92dojzwjs4D4Y/Fhqci5MlqrrKYzxVrPGPvDfBVIJcJGDHZSPgnJLE
	 SxsRT5lo9Jb09tDU37Bhel1pZvo0eZPp1ka/h3Z6itRTUM49TzTehpEJtUoyU5Zwm4
	 EGFpmB7o+bpDsKqvQXDQYHPofVmPUy1IU7NOR55o=
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
Subject: [PATCH 6.6 246/538] perf mem: Free the allocated sort string, fixing a leak
Date: Wed,  2 Oct 2024 14:58:05 +0200
Message-ID: <20241002125801.961334042@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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
index 51499c20da01e..865f321d729b6 100644
--- a/tools/perf/builtin-mem.c
+++ b/tools/perf/builtin-mem.c
@@ -372,6 +372,7 @@ static int report_events(int argc, const char **argv, struct perf_mem *mem)
 		rep_argv[i] = argv[j];
 
 	ret = cmd_report(i, rep_argv);
+	free(new_sort_order);
 	free(rep_argv);
 	return ret;
 }
-- 
2.43.0



