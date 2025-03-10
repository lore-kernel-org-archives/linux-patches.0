Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22EE217CA12;
	Mon, 10 Mar 2025 17:48:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628911; cv=none; b=AcsE/0abpeQyEPBuswzR8HkC4+myJMSD3jwaBvs4e2bFxkIIdCQlmf27E/UJGUVxFO+uDjma8/+uL6IIQrGQfr2JdicU7SN+9l1fShaKk+DiXxzLrQn6qUhDE4YNLDrQGiY9Zo12D51WO7g5lnNDOXdtqHsr9U/7fB3ZOLzKXOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628911; c=relaxed/simple;
	bh=BUVbQMiILl6zJNnN87jE4tt638LWwT3DLkxUy2+sbSI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DFnP8VgEAh8vwANxS07Il4QyRxqBxdcUUbC/FD2WGiy7wDv64rzI8BktSdTMQxrGW+5vKXhixwpGY9tVM9M94Icqw3PvhXyLDoSCiYn45HZhNUg2hMQQI6ClSFCJh8LPlR4LkZdzy7ZC+J/gsFaoFVLuijhpdZebXys0aGvLunc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t7oAvqFs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t7oAvqFs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09BCAC4CEE5;
	Mon, 10 Mar 2025 17:48:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628910;
	bh=BUVbQMiILl6zJNnN87jE4tt638LWwT3DLkxUy2+sbSI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t7oAvqFszTwggzq9kcvCzPrJCxSdgnEWV5FBJv3z/rdcWsp7P6x3TgN7NCI+9JIFS
	 0cBQ3vnURiNoU/H6V3YGpFI5q+hx/hP0CKO212Ml3i7vWjo8gD5/+ktJOyBKvQKBpr
	 E7zYqg8sqJNRE1jY7Z+RlwBteSKkUaR96YOQBfsU=
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
Subject: [PATCH 5.15 080/620] perf header: Fix one memory leakage in process_bpf_btf()
Date: Mon, 10 Mar 2025 17:58:46 +0100
Message-ID: <20250310170548.741041534@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 8b0a8ac7afefd..7937ff460c446 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -3120,7 +3120,8 @@ static int process_bpf_btf(struct feat_fd *ff, void *data __maybe_unused)
 		if (__do_read(ff, node->data, data_size))
 			goto out;
 
-		__perf_env__insert_btf(env, node);
+		if (!__perf_env__insert_btf(env, node))
+			free(node);
 		node = NULL;
 	}
 
-- 
2.39.5



