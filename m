Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C87116DED2;
	Wed,  5 Feb 2025 14:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766371; cv=none; b=lSyuqzC6nbPHME81AuOoMVDPhQRxaBZUy9XeTQ0kh9yobSLQ/nO0DtZHOLCuy/jQrkPexQF+2fVnmNLO9O4O1yuHU06wC9SifFEhvIClU5n6WPKTDHRITzA1VBIwAVfrmJOFn9b2yLpAVx7eKOzPoGd7H6OyhLvwg88dxpYx3OU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766371; c=relaxed/simple;
	bh=M6O5YF+Sk1aV1JeGwq3v/ItUpX1d1Jfxd1RYuiPEtkk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UI2qS/QoVhr4HylrjmL9i4cTYBfpKhXUMhdBDbRnd+ZUJunDGljbBjP17TZtksi9F9iSbiZQuKtDMPx6NATD+6vzkP5f/KDSXpkm6iPYEylYJ2sahwbblbvae8vDjwCe/HQbUUowAlcp4bHf9xpBwMSv9kpWQUBtKZy6k1B+8z0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yK59rDs1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yK59rDs1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CB2AC4CED1;
	Wed,  5 Feb 2025 14:39:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766371;
	bh=M6O5YF+Sk1aV1JeGwq3v/ItUpX1d1Jfxd1RYuiPEtkk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yK59rDs1nQRr6nb9IksYO9Z+UzK8Vi3piMrxZOaIVsHGpIsInxQmajFGQXzk8iovy
	 EW25LpFtN6wMqxHuhP0zkIgH9g+LjJ4qz6hKE26j3YkwS4J/WM5yZwgPc+yc7tSDRg
	 nzS2CDpRr/fzFcFvifW6G+bzXx9FrpO1T63TorNk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namhyung Kim <namhyung@kernel.org>,
	Zhongqiu Han <quic_zhonhan@quicinc.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Ian Rogers <irogers@google.com>,
	Ingo Molnar <mingo@redhat.com>,
	James Clark <james.clark@linaro.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Kan Liang <kan.liang@linux.intel.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Song Liu <song@kernel.org>,
	Yicong Yang <yangyicong@hisilicon.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 267/623] perf header: Fix one memory leakage in process_bpf_btf()
Date: Wed,  5 Feb 2025 14:40:09 +0100
Message-ID: <20250205134506.444586546@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhongqiu Han <quic_zhonhan@quicinc.com>

[ Upstream commit 875d22980a062521beed7b5df71fb13a1af15d83 ]

If __perf_env__insert_btf() returns false due to a duplicate btf node
insertion, the temporary node will leak. Add a check to ensure the memory
is freed if the function returns false.

Fixes: a70a1123174ab592 ("perf bpf: Save BTF information as headers to perf.data")
Reviewed-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Zhongqiu Han <quic_zhonhan@quicinc.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Clark <james.clark@linaro.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Song Liu <song@kernel.org>
Cc: Yicong Yang <yangyicong@hisilicon.com>
Link: https://lore.kernel.org/r/20241205084500.823660-2-quic_zhonhan@quicinc.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/header.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 3451e542b69a8..fbba6ffafec4a 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -3205,7 +3205,8 @@ static int process_bpf_btf(struct feat_fd *ff, void *data __maybe_unused)
 		if (__do_read(ff, node->data, data_size))
 			goto out;
 
-		__perf_env__insert_btf(env, node);
+		if (!__perf_env__insert_btf(env, node))
+			free(node);
 		node = NULL;
 	}
 
-- 
2.39.5



