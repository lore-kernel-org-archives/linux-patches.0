Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 241CA197500;
	Thu,  6 Jun 2024 14:09:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717682945; cv=none; b=r05XKTnCTt4HS1bBqN5112xe8EaO7GTDIATAZtLMbUSIZKyzLJQ+WsS84wj0w70i52w2Bxlaeqh74n1G0v9wQSzMaBdT6cy6jLUPtAyrfIsFzjFpuzEspL4wl4jTU/JEsrnivUqSx0MD6BbJJLB6LWXYWUcCfFyToVUaqfAxi+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717682945; c=relaxed/simple;
	bh=kCG9J3EWaF3CMfB+7bxFjDsqsYTtD8DroHlRJkSl3tQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NHlBhNIXFOrJYaS1kD56fbUjv0aKLRPgofULYyumReNx/DV6E4l6jdMnXVNO5GjygvemGjp0+xPmr/uJ5ixbjhmRXowWBClScGea1JRQkpeiU1z3oshoX5HpbDk3QFmiA/yy0CXk0G2s6Xi4vzo2h2mtDFtXcV3+tKFrw7j3lyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cARr53XQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cARr53XQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7719C2BD10;
	Thu,  6 Jun 2024 14:09:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717682944;
	bh=kCG9J3EWaF3CMfB+7bxFjDsqsYTtD8DroHlRJkSl3tQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cARr53XQeCN/46XOYNpjc1P4WnZT4F0VPm1H7Fn0yB2hhkUfNB9GEksNIR1e6OW7u
	 1pCe/3PbmwF6sEBtiyHgyOIqZIycJsZWTFQgI70pAMM/pNnWTetJp09Vul0tOKx/Cm
	 2jUr4TziCceYbhlIq3jHJaKtp+SIuqx4GCqtCcBw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Clark <james.clark@arm.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Athira Rajeev <atrajeev@linux.vnet.ibm.com>,
	Ian Rogers <irogers@google.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 104/374] perf symbols: Remove map from list before updating addresses
Date: Thu,  6 Jun 2024 16:01:23 +0200
Message-ID: <20240606131655.406390816@linuxfoundation.org>
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

From: James Clark <james.clark@arm.com>

[ Upstream commit 9fe410a7ef483a9aca08bf620d8ddfd35ac99bc7 ]

Make the order of operations remove, update, add. Updating addresses
before the map is removed causes the ordering check to fail when the map
is removed. This can be reproduced when running Perf on an Arm system
with a static kernel and Perf uses kcore rather than other sources:

  $ perf record -- ls
  $ perf report

  util/maps.c:96: check_invariants: Assertion `map__end(prev) <=
    map__start(map) || map__start(prev) == map__start(map)' failed

Fixes: 659ad3492b913c90 ("perf maps: Switch from rbtree to lazily sorted array for addresses")
Signed-off-by: James Clark <james.clark@arm.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Athira Rajeev <atrajeev@linux.vnet.ibm.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/r/20240507141210.195939-2-james.clark@arm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/symbol.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 9ebdb8e13c0b8..cd825241e07d9 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1375,13 +1375,15 @@ static int dso__load_kcore(struct dso *dso, struct map *map,
 		if (RC_CHK_EQUAL(new_map, replacement_map)) {
 			struct map *map_ref;
 
-			map__set_start(map, map__start(new_map));
-			map__set_end(map, map__end(new_map));
-			map__set_pgoff(map, map__pgoff(new_map));
-			map__set_mapping_type(map, map__mapping_type(new_map));
 			/* Ensure maps are correctly ordered */
 			map_ref = map__get(map);
 			maps__remove(kmaps, map_ref);
+
+			map__set_start(map_ref, map__start(new_map));
+			map__set_end(map_ref, map__end(new_map));
+			map__set_pgoff(map_ref, map__pgoff(new_map));
+			map__set_mapping_type(map_ref, map__mapping_type(new_map));
+
 			err = maps__insert(kmaps, map_ref);
 			map__put(map_ref);
 			map__put(new_map);
-- 
2.43.0



