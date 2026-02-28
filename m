Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A63D03090D5
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:48:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772300895; cv=none; b=M3yOWljni6Om9w+rMZH7NfaHSn5hLhpH2Pj1fGiAVGPtV8ZlfWBqiemO8uA8IRwW3spIgA1UJnIMMmFtIUbrVnY2UiVHkCMd6T7YzBkjIvYe1lTZW9/vvxzhEffrd15401JZvpGD77soyWFljRdNcZ9JJgTkFUscU6ShKk4bOG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772300895; c=relaxed/simple;
	bh=nDMylr0e+LTXijSRssaP8NgoS12kAi7h2xpeivKV4is=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hiouwEEd4Z8j5wy7P0xn1ssXc/UDskHpsmKRFHU4BC/oUjj/tfGtcDqqJDPFu41FB/r0iBocUFYafmijF7yig9zVttUNRpCSUu2evZ2rNX0cychV69czpHcAZygTEEsMKMIG747okCEXoettgu+Ktece6LtyOTOmyjVN3avmdS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B64ojH8H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B64ojH8H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BCD9C19424;
	Sat, 28 Feb 2026 17:48:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772300895;
	bh=nDMylr0e+LTXijSRssaP8NgoS12kAi7h2xpeivKV4is=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B64ojH8Hcy545wOgEApjDhQ8awT7og7eohRZhWs7eZmtQpXuNotbD3EhH+JDCrPEO
	 ey9TVqy6YK8AdIo3XpNecwzQNnBPRcAcZrH3DSfIsMFr4oI78G9UcNYPmcR1z7EL3L
	 I46MHsjLz5J+SrVmiqEBCnn4uN1JB8gvPu0kKCZmKt1WSkfVsxx2o5XydIslxCTmWy
	 inzawVU+WZDHcgE6meXnQscKOyWVFEEsC+ctGMajs6B9BR7MFbM8V9mMT/JhPvIRhp
	 3XuyN67FNzZZsOSCGV3WNoxTqy/fPnX2Oqd7HE3whp77l0H6AXkcIt7Zers8e/riGk
	 OIKK5dG3EsXJg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Ian Rogers <irogers@google.com>,
	James Clark <james.clark@linaro.org>,
	Aditya Bodkhe <aditya.b1@linux.ibm.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Athira Rajeev <atrajeev@linux.ibm.com>,
	Bill Wendling <morbo@google.com>,
	"Dr. David Alan Gilbert" <linux@treblig.org>,
	Guo Ren <guoren@kernel.org>,
	Howard Chu <howardchu95@gmail.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jiri Olsa <jolsa@kernel.org>,
	John Garry <john.g.garry@oracle.com>,
	Julia Lawall <Julia.Lawall@inria.fr>,
	Justin Stitt <justinstitt@google.com>,
	=?UTF-8?q?Krzysztof=20=C5=81opatowski?= <krzysztof.m.lopatowski@gmail.com>,
	Leo Yan <leo.yan@linux.dev>,
	Namhyung Kim <namhyung@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <pjw@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Sergei Trofimovich <slyich@gmail.com>,
	Shimin Guo <shimin.guo@skydio.com>,
	Suchit Karunakaran <suchitkarunakaran@gmail.com>,
	Thomas Falcon <thomas.falcon@intel.com>,
	Tianyou Li <tianyou.li@intel.com>,
	Will Deacon <will@kernel.org>,
	Zecheng Li <zecheng@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 012/752] perf maps: Fix reference count leak in maps__find_ams()
Date: Sat, 28 Feb 2026 12:35:23 -0500
Message-ID: <20260228174750.1542406-12-sashal@kernel.org>
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

[ Upstream commit 6fdd2676db55b503c52dd3f1359b5c57f774ab75 ]

ams and so ams->ms.map is an in argument, however, it is also
overwritten. As a map is reference counted, ensure a map__put() is done
before overwriting it.

Fixes: 42fd623b58dbcc48 ("perf maps: Get map before returning in maps__find")
Reviewed-by: James Clark <james.clark@linaro.org>
Signed-off-by: Ian Rogers <irogers@google.com>
Cc: Aditya Bodkhe <aditya.b1@linux.ibm.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Athira Rajeev <atrajeev@linux.ibm.com>
Cc: Bill Wendling <morbo@google.com>
Cc: Dr. David Alan Gilbert <linux@treblig.org>
Cc: Guo Ren <guoren@kernel.org>
Cc: Howard Chu <howardchu95@gmail.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: John Garry <john.g.garry@oracle.com>
Cc: Julia Lawall <Julia.Lawall@inria.fr>
Cc: Justin Stitt <justinstitt@google.com>
Cc: Krzysztof Łopatowski <krzysztof.m.lopatowski@gmail.com>
Cc: Leo Yan <leo.yan@linux.dev>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <nick.desaulniers+lkml@gmail.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <pjw@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Sergei Trofimovich <slyich@gmail.com>
Cc: Shimin Guo <shimin.guo@skydio.com>
Cc: Suchit Karunakaran <suchitkarunakaran@gmail.com>
Cc: Thomas Falcon <thomas.falcon@intel.com>
Cc: Tianyou Li <tianyou.li@intel.com>
Cc: Will Deacon <will@kernel.org>
Cc: Zecheng Li <zecheng@google.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/maps.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/util/maps.c b/tools/perf/util/maps.c
index 779f6230130af..c51ec159ac769 100644
--- a/tools/perf/util/maps.c
+++ b/tools/perf/util/maps.c
@@ -676,6 +676,7 @@ int maps__find_ams(struct maps *maps, struct addr_map_symbol *ams)
 	if (ams->addr < map__start(ams->ms.map) || ams->addr >= map__end(ams->ms.map)) {
 		if (maps == NULL)
 			return -1;
+		map__put(ams->ms.map);
 		ams->ms.map = maps__find(maps, ams->addr);
 		if (ams->ms.map == NULL)
 			return -1;
-- 
2.51.0

