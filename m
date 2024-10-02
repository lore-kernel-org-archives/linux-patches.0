Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2987198A1A;
	Wed,  2 Oct 2024 14:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878076; cv=none; b=a+tlpuYnvyRMlg6cpwc31khY5/oShxGfKfzvLG4LGbGY846fRSfw5GE6K+GvF8oAr0nU/FyfbtkP5k3m2q6nM7g7X5VAzmcEZ2hdfYzztURI9UBCWZseGgAzWujmWUgCFwDloVtWsW+RCrcH94/dJD7ZHXgfFW76mLKgwBgLxOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878076; c=relaxed/simple;
	bh=gp3WtIYJWMFUMkipk9J6lnPaNy5gGxlAykaLsPEAIm0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GRe/WOKjGsCndhXUp3FzjLipR4iNRZXWUxbiWt35QUuqKrMNh0rNK/VVRYmnpTmSKQ+4e9veNQfgg8b0c09T6GZZu8nT64WtoQR2M74ZEuOEV18jrMVzMkn2eFvof+iI7AoXPUea6RhVpJRNgJC/tV3kRb3RAVKV0Y2YdkcTjOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gDKOLPO8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gDKOLPO8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1E78C4CEC2;
	Wed,  2 Oct 2024 14:07:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878076;
	bh=gp3WtIYJWMFUMkipk9J6lnPaNy5gGxlAykaLsPEAIm0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gDKOLPO8s2Xrp6xKEn5Qxv20tcof85jcSmqt4luQDKbkgTGwE2+rdS2gIJrJoW7QE
	 vpDvckQL0roTwUktuEcRUWffZGZpe2zTBNy7u/scB1o+rsbFWrihq66Iv14NZh82KR
	 z5N6x2zGf43DANjbrRC5ZaiZTrfwo/OeReHmqS2w=
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
Subject: [PATCH 6.10 293/634] perf mem: Free the allocated sort string, fixing a leak
Date: Wed,  2 Oct 2024 14:56:33 +0200
Message-ID: <20241002125822.676863363@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index 863fcd735daee..93413cfcd585a 100644
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



