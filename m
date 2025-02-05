Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47DB9170A13;
	Wed,  5 Feb 2025 14:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766580; cv=none; b=hhCUHQEdfKxahlD8YlG5tn/F79PG3FGzV+3ELAdmOOYFzjZ0qTMkKsPVun+ouGDf7286DCwCOD/B9VrHnxBKoB6Rp6GyVFbwp4VTTI/Q3DC/0KNPp38/IzVLQt6O8pmTe79sB/wL04Js19FFBDDk9K+EhTUTpqkZQUsKXDBLfX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766580; c=relaxed/simple;
	bh=GNlYFCH5peNiICbmxItCv1YBJ8+iireHoTZry6yXV9o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GxHO8ZOxwSotZYkQz/N/Cq2WAzGTRf93hPhviajPy9g41Z0BoVoZJMToJ/tSCNNFMMATe66HQ/jKHxLr29wc8WmewDGx3PcUuubI9HYloxtv/51VVYUPVT/7hDwMvUl4j+bDFP1TBq01kJvCB0Y+3Fo4bZpQ+daggxqLYYu0o1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b0wDyrgT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b0wDyrgT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 671A4C4CEE2;
	Wed,  5 Feb 2025 14:42:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766580;
	bh=GNlYFCH5peNiICbmxItCv1YBJ8+iireHoTZry6yXV9o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b0wDyrgT2qvep+7zOqbBxT/HBsPs6+K68BdWUfGcg6fWIgl74SgtP7GdIiI+Zm6U8
	 TSxVaY5S2T0GnsP+/BYU8j96AdXs5UyA4/e4Q84kFgFFGaVKg9esKoAjObWQkVAQhP
	 7oMWl2ovWnXlR9JuL1RfxMVAGFlmiJci/uO/f+7o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Ian Rogers <irogers@google.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Kan Liang <kan.liang@linux.intel.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 289/623] perf maps: Fix display of kernel symbols
Date: Wed,  5 Feb 2025 14:40:31 +0100
Message-ID: <20250205134507.287721012@linuxfoundation.org>
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

From: Christophe Leroy <christophe.leroy@csgroup.eu>

[ Upstream commit dae29277fddaaf6670d17dfcbb916a2ca29c912f ]

Since commit 659ad3492b913c90 ("perf maps: Switch from rbtree to lazily
sorted array for addresses"), perf doesn't display anymore kernel
symbols on powerpc, allthough it still detects them as kernel addresses.

	# Overhead  Command     Shared Object  Symbol
	# ........  ..........  ............. ......................................
	#
	    80.49%  Coeur main  [unknown]      [k] 0xc005f0f8
	     3.91%  Coeur main  gau            [.] engine_loop.constprop.0.isra.0
	     1.72%  Coeur main  [unknown]      [k] 0xc005f11c
	     1.09%  Coeur main  [unknown]      [k] 0xc01f82c8
	     0.44%  Coeur main  libc.so.6      [.] epoll_wait
	     0.38%  Coeur main  [unknown]      [k] 0xc0011718
	     0.36%  Coeur main  [unknown]      [k] 0xc01f45c0

This is because function maps__find_next_entry() now returns current
entry instead of next entry, leading to kernel map end address getting
mis-configured with its own start address instead of the start address
of the following map.

Fix it by really taking the next entry, also make sure that entry
follows current one by making sure entries are sorted.

Fixes: 659ad3492b913c90 ("perf maps: Switch from rbtree to lazily sorted array for addresses")
Reviewed-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Reviewed-by: Ian Rogers <irogers@google.com>
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/r/2ea4501209d5363bac71a6757fe91c0747558a42.1736329923.git.christophe.leroy@csgroup.eu
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/maps.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/maps.c b/tools/perf/util/maps.c
index 432399cbe5dd3..09c9cc326c08d 100644
--- a/tools/perf/util/maps.c
+++ b/tools/perf/util/maps.c
@@ -1136,8 +1136,13 @@ struct map *maps__find_next_entry(struct maps *maps, struct map *map)
 	struct map *result = NULL;
 
 	down_read(maps__lock(maps));
+	while (!maps__maps_by_address_sorted(maps)) {
+		up_read(maps__lock(maps));
+		maps__sort_by_address(maps);
+		down_read(maps__lock(maps));
+	}
 	i = maps__by_address_index(maps, map);
-	if (i < maps__nr_maps(maps))
+	if (++i < maps__nr_maps(maps))
 		result = map__get(maps__maps_by_address(maps)[i]);
 
 	up_read(maps__lock(maps));
-- 
2.39.5



