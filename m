Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 149F815CD74;
	Wed,  5 Feb 2025 14:32:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765939; cv=none; b=TAWO5LQuLWcY/GYwUGioADU1hZ64otaRjQB4R546gfRm9zEVs+4atzJ4yjspna2HemJ/0Up3SNLnouie1ICOrolDT19C0jviWDP5hLZV4wZ93EKAvrMQABeCc40XLzs7bjs5YeFP+hzg9OB3K/8iPhJXwdqGas2pbGsFp1kCVeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765939; c=relaxed/simple;
	bh=5D0kLIVzGFhiYwnyUi3d/WkxNnnu8WCgTJjqkOVWxac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bjXdV5zY8bOc9efeOB4mijHXW27GIyS3wIm2+P+C2w73lzQhPRIoOFRkPw8a/jX3ooeqLsqaal94dF1QktM4MHQ00tMJc6ukzsf6nLu0csDAg/EW5a1InVwySROUV0y/HBXRnVRwALUFfRlsxmp3Vcd0ODMZE6l9lh5P3DaeeB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QC3b8uJg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QC3b8uJg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 484EEC4CED1;
	Wed,  5 Feb 2025 14:32:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765939;
	bh=5D0kLIVzGFhiYwnyUi3d/WkxNnnu8WCgTJjqkOVWxac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QC3b8uJgDL1k1xI/AXyNEWnsTKay57OCusYM3zo6Kvuv+Y0URp5FNTCDqp+LijCzb
	 O0zhIsv2jRNH7qTyeTIaye3zCad/umk5D1bcrc4rew1R5HMdiU3zD4hoIKutNoYJHI
	 MJYF9PppfbOsLzfxnBY0AMLtj0hlSx8hrIXHTmP0=
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
Subject: [PATCH 6.12 269/590] perf maps: Fix display of kernel symbols
Date: Wed,  5 Feb 2025 14:40:24 +0100
Message-ID: <20250205134505.565747500@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



