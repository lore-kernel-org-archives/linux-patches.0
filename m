Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19B29198E78;
	Thu,  6 Jun 2024 14:08:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717682939; cv=none; b=kzpppTgPcot1WRzXCx75WFjgOS7i/yL9cDb9axnrDrOhIaDOzc/hk8dUmsW/CjQ1JbmKMFjIPJigUVCatM0CatCyLz6nD6cRBjq+cavQDzmmTJJ243Ths7Tl9WZQLpgIXZj5xDVa/u5SRg31OoFF7g3j7uRcyRW8tFofVKUyRfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717682939; c=relaxed/simple;
	bh=6PfrXKZdvpkh7jDc8zJn/5syKN18L+Czwie857rKgxA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YccTb0p+ItHQZPFkB5Asr7Gmvi3RMesJ+GbqF8A1qkKd4qBoiZvk6/Oe4OqcKqo53rmA19F01BA2LtwvqqZtx7vC49MAfbVkbbUVrGsz7ubXg7Z9LJAyphB+PeBAs7Ic4f3q67D+UbM/ykRG71gyUYBZSyiTsniBabaAZYtARrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fIft5eew; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fIft5eew"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE8FCC32781;
	Thu,  6 Jun 2024 14:08:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717682939;
	bh=6PfrXKZdvpkh7jDc8zJn/5syKN18L+Czwie857rKgxA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fIft5eewfdteVHb9KcMQUUTvYC41WaZiJBp/vEdkxaITq1CIgEQJCRKnFxyb0p9Rn
	 oTne0IpHfukHzwrpj4QuNGdAqduBi+OE/EVdgQJAVsuBXWsagSISRsdWxCtn8jkjX7
	 Y8zcTDKfttixWXXO11WfHDVjZOmJ/MBZkznYAQA8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	He Zhe <zhe.he@windriver.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Ian Rogers <irogers@google.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 091/374] perf bench internals inject-build-id: Fix trap divide when collecting just one DSO
Date: Thu,  6 Jun 2024 16:01:10 +0200
Message-ID: <20240606131654.933763245@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: He Zhe <zhe.he@windriver.com>

[ Upstream commit d9180e23fbfa3875424d3a6b28b71b072862a52a ]

'perf bench internals inject-build-id' suffers from the following error when
only one DSO is collected.

  # perf bench internals inject-build-id -v
    Collected 1 DSOs
  traps: internals-injec[2305] trap divide error
  ip:557566ba6394 sp:7ffd4de97fe0 error:0 in perf[557566b2a000+23d000]
    Build-id injection benchmark
    Iteration #1
  Floating point exception

This patch removes the unnecessary minus one from the divisor which also
corrects the randomization range.

Signed-off-by: He Zhe <zhe.he@windriver.com>
Fixes: 0bf02a0d80427f26 ("perf bench: Add build-id injection benchmark")
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: https://lore.kernel.org/r/20240507065026.2652929-1-zhe.he@windriver.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/bench/inject-buildid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/bench/inject-buildid.c b/tools/perf/bench/inject-buildid.c
index 49331743c7439..a759eb2328bea 100644
--- a/tools/perf/bench/inject-buildid.c
+++ b/tools/perf/bench/inject-buildid.c
@@ -362,7 +362,7 @@ static int inject_build_id(struct bench_data *data, u64 *max_rss)
 		return -1;
 
 	for (i = 0; i < nr_mmaps; i++) {
-		int idx = rand() % (nr_dsos - 1);
+		int idx = rand() % nr_dsos;
 		struct bench_dso *dso = &dsos[idx];
 		u64 timestamp = rand() % 1000000;
 
-- 
2.43.0



