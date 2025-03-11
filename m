Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4233725E820;
	Tue, 11 Mar 2025 15:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706445; cv=none; b=YfA4eJGAe4t8qaabjUV21usFnnW/lXTDdalzBfjVMbLS7X6XxP6mhfuCiYffjbuCIb0Ozm5IqVFK19y0jcGs5sifJ0n8C3oJSgjyR6zMJuaYqGwOCkDHwpwLd2atRXEl+N7zGfhs1b/LzaS6G24z4aLb5SROXZe1Np9ZP1j41q8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706445; c=relaxed/simple;
	bh=og6QMxh9RwqLkj4aPusMTxv8/RhhvIz32h/lVhPd5wg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MawNZzFGXCwujC/ZFQ81hvkLhZ6NG/spvbnbQ0mgvxS8J26NBHhZEuT9c1WADmwOY0pxVLuVszSuhF+t1IEv1RECGlXptS8eaCK5zCADwR9XphcsO4roBmnCdVkd6dfa8cNoFf0SE6NVb2RjZnmxeD1knjqc8tKkX2qzhPCZthA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=soY5ulqL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="soY5ulqL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 201A1C4CEEC;
	Tue, 11 Mar 2025 15:20:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706444;
	bh=og6QMxh9RwqLkj4aPusMTxv8/RhhvIz32h/lVhPd5wg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=soY5ulqLcIzu/2+fok83laiA2ApLwiOiA8A5q1bHUqM3giNsMDnesnKDTpKitEfx5
	 kHQo+VNcQfazHzNvYv+0QbbgC+0yoyXLxAbyWBcJoPGD4BlaZM5eAxjy3mjT9fkANz
	 TlvXROLpgih/ChkYpoJ9UuoH0fBQ/cE89QjfrGy4=
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
Subject: [PATCH 5.10 051/462] perf header: Fix one memory leakage in process_bpf_btf()
Date: Tue, 11 Mar 2025 15:55:17 +0100
Message-ID: <20250311145800.369633891@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index d2812d98968df..a0a83e5de762a 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -2980,7 +2980,8 @@ static int process_bpf_btf(struct feat_fd *ff, void *data __maybe_unused)
 		if (__do_read(ff, node->data, data_size))
 			goto out;
 
-		__perf_env__insert_btf(env, node);
+		if (!__perf_env__insert_btf(env, node))
+			free(node);
 		node = NULL;
 	}
 
-- 
2.39.5



