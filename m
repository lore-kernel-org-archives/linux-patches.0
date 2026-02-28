Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06DDA4A2E14
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:48:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772300885; cv=none; b=IBCUkCBy/hHxhZ704DnkidPUkFC4DzyJOxdbo8vNPdHqwGP1J+73UlH18uFFF4G+zurzhzeMaXT65JIFSJoQwK1SwCqZBMz9aqQo9mnoHJdfIV7InhzXXTNzHCiqjZJ9OCG93rlcY/Z+ndoCd93v6rIO6AosnpAXlEdwmH6Brtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772300885; c=relaxed/simple;
	bh=Ym5E9m8p7OyhZ3KnhCyR7rKpXnU+/ukuJfASpTDuh1U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VwrkcSPo8AtDc4WL6uiP41pCGbuHGd2MmaeJCnLQFMBH0qR+5WaBbNdgV5Pg7SJMAEAnyaqlVL9FSdclJmF747U1A1sIwSa2lMbwqJQ9EQ7U++lY6UlRGZ7NafSvqa0aIAbh7xXN1RzlODSEhHIRmwWobO9JDk4slgx2/ZZaVVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eYr2Mh1w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eYr2Mh1w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9966C116D0;
	Sat, 28 Feb 2026 17:48:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772300884;
	bh=Ym5E9m8p7OyhZ3KnhCyR7rKpXnU+/ukuJfASpTDuh1U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eYr2Mh1wMa66CP+q6yn/WEIyQj5o2oe+sj8YIcHfRMb4chZjHPgJJTeHd9TG7PtuX
	 OVKf2mWMm0uir49TBUnfA86p9e9R/7JQXYoqcK65RbB9Tt73x1g6yHaFYp8+J6RyAr
	 tNZdxmH3VbhVzRuYIiLU408Zl/7J8NUtMvCdLRo9mN298aNtZu6ak5ueGtxxjHHwZD
	 2WgU42JL8sWXKVBW49l+lI40fD4haRjk8OpSB7BlV2JJxGwB9h8anDUSEl0ac6qIfx
	 Fw+zoXfaRQnywzdG8Bk/QVm8WN1nJLmgR48y+nZcA59VMxh8uJLESs2G1FgaPqTqgL
	 nEPsvLAQRwXDQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Ian Rogers <irogers@google.com>,
	Aditya Bodkhe <aditya.b1@linux.ibm.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Andi Kleen <ak@linux.intel.com>,
	Athira Rajeev <atrajeev@linux.ibm.com>,
	Chun-Tse Shao <ctshao@google.com>,
	Dmitriy Vyukov <dvyukov@google.com>,
	"Dr. David Alan Gilbert" <linux@treblig.org>,
	Guo Ren <guoren@kernel.org>,
	Haibo Xu <haibo1.xu@intel.com>,
	Howard Chu <howardchu95@gmail.com>,
	Ingo Molnar <mingo@redhat.com>,
	James Clark <james.clark@linaro.org>,
	Jiri Olsa <jolsa@kernel.org>,
	John Garry <john.g.garry@oracle.com>,
	=?UTF-8?q?Krzysztof=20=C5=81opatowski?= <krzysztof.m.lopatowski@gmail.com>,
	Leo Yan <leo.yan@linux.dev>,
	Mark Wielaard <mark@klomp.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <pjw@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Sergei Trofimovich <slyich@gmail.com>,
	Shimin Guo <shimin.guo@skydio.com>,
	Stephen Brennan <stephen.s.brennan@oracle.com>,
	Thomas Falcon <thomas.falcon@intel.com>,
	Will Deacon <will@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 008/752] perf symbol-elf: Fix leak of ELF files with GNU debugdata
Date: Sat, 28 Feb 2026 12:35:19 -0500
Message-ID: <20260228174750.1542406-8-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Ian Rogers <irogers@google.com>

[ Upstream commit 92d65d9c31621befe0a5f7c0bd43bd217613c6b6 ]

The processing of DSO_BINARY_TYPE__GNU_DEBUGDATA in symsrc__init happens
with an open ELF file but the error path only closes the associate fd.

Fix the goto so that the ELF file is also ended and memory released.

Fixes: b10f74308e130527 ("perf symbol: Support .gnu_debugdata for symbols")
Signed-off-by: Ian Rogers <irogers@google.com>
Cc: Aditya Bodkhe <aditya.b1@linux.ibm.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Athira Rajeev <atrajeev@linux.ibm.com>
Cc: Chun-Tse Shao <ctshao@google.com>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Cc: Dr. David Alan Gilbert <linux@treblig.org>
Cc: Guo Ren <guoren@kernel.org>
Cc: Haibo Xu <haibo1.xu@intel.com>
Cc: Howard Chu <howardchu95@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Clark <james.clark@linaro.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: John Garry <john.g.garry@oracle.com>
Cc: Krzysztof Łopatowski <krzysztof.m.lopatowski@gmail.com>
Cc: Leo Yan <leo.yan@linux.dev>
Cc: Mark Wielaard <mark@klomp.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <pjw@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Sergei Trofimovich <slyich@gmail.com>
Cc: Shimin Guo <shimin.guo@skydio.com>
Cc: Stephen Brennan <stephen.s.brennan@oracle.com>
Cc: Thomas Falcon <thomas.falcon@intel.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/symbol-elf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
index 9e820599bab38..9d62386464680 100644
--- a/tools/perf/util/symbol-elf.c
+++ b/tools/perf/util/symbol-elf.c
@@ -1170,7 +1170,7 @@ int symsrc__init(struct symsrc *ss, struct dso *dso, const char *name,
 		Elf *embedded = read_gnu_debugdata(dso, elf, name, &new_fd);
 
 		if (!embedded)
-			goto out_close;
+			goto out_elf_end;
 
 		elf_end(elf);
 		close(fd);
-- 
2.51.0

