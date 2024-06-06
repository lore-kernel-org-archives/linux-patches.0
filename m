Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6CD41974F3;
	Thu,  6 Jun 2024 14:09:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717682945; cv=none; b=J49hJOSJG4HfuPfTHfgyxh7T5wBGM1E3QvwLI7qOPF9VQznrEgT5aUxIPItddTE76ZPau+9j7jSUNDoKhvsKqqYzf73cLTvAdk2vRtVfWvD2HDiEtxqO5YMukIXVf4R27hTu455xTjmfCIPdKZridSMusN45x/arO5gPAAwtQ8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717682945; c=relaxed/simple;
	bh=7rD5DQz9o8x0Atbb1scwJdg9Hp+3+1I3bQnCB1pUpzg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rK46oe609A1yMKjZg3Si/NhPILstcxuq0O0qelzjdV6MwmCB6Huw8Nxy9Iu/VgK3uMj5inmWnPR5M9GhuiGsj9yADZMBBmIfIKytAX/eigxio5LAVFYIjTsEPRS1tHQFA+RVvXyOomT0/TokRReT3j84uOiV82mOrMQYv/NgnBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yTvfbVTa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yTvfbVTa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D778C2BD10;
	Thu,  6 Jun 2024 14:09:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717682945;
	bh=7rD5DQz9o8x0Atbb1scwJdg9Hp+3+1I3bQnCB1pUpzg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yTvfbVTallrJpxllwoGUuJp8oF+x3jTaAUT5cM1DaYmovVWTWoz4KO6jnVXB96CGT
	 HTqPsoAJRqDncMgk17s6nYmfw/7+7qbmJIgWWCiv4/s5C6zA2za5cjfHd4VkFozb4s
	 nom7jj78aqcQxecJUayWy2PAthzPygPoF8PmCfZw=
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
Subject: [PATCH 6.9 105/374] perf symbols: Update kcore map before merging in remaining symbols
Date: Thu,  6 Jun 2024 16:01:24 +0200
Message-ID: <20240606131655.444177936@linuxfoundation.org>
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

[ Upstream commit f30232b20fadea8c0f2f43f764bc06e51e8cfcdf ]

When loading kcore, the main vmlinux map is updated in the same loop
that merges the remaining maps. If a map that overlaps is merged in
before kcore, the list can become unsortable when the main map addresses
are updated. This will later trigger the check_invariants() assert:

  $ perf record
  $ perf report

  util/maps.c:96: check_invariants: Assertion `map__end(prev) <=
    map__start(map) || map__start(prev) == map__start(map)' failed.
  Aborted

Fix it by moving the main map update prior to the loop so that
maps__merge_in() can split it if necessary.

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
Link: https://lore.kernel.org/r/20240507141210.195939-4-james.clark@arm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/symbol.c | 40 +++++++++++++++++++++-------------------
 1 file changed, 21 insertions(+), 19 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index cd825241e07d9..a1ca1b8156fe5 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1287,7 +1287,7 @@ static int dso__load_kcore(struct dso *dso, struct map *map,
 {
 	struct maps *kmaps = map__kmaps(map);
 	struct kcore_mapfn_data md;
-	struct map *replacement_map = NULL;
+	struct map *map_ref, *replacement_map = NULL;
 	struct machine *machine;
 	bool is_64_bit;
 	int err, fd;
@@ -1365,6 +1365,24 @@ static int dso__load_kcore(struct dso *dso, struct map *map,
 	if (!replacement_map)
 		replacement_map = list_entry(md.maps.next, struct map_list_node, node)->map;
 
+	/*
+	 * Update addresses of vmlinux map. Re-insert it to ensure maps are
+	 * correctly ordered. Do this before using maps__merge_in() for the
+	 * remaining maps so vmlinux gets split if necessary.
+	 */
+	map_ref = map__get(map);
+	maps__remove(kmaps, map_ref);
+
+	map__set_start(map_ref, map__start(replacement_map));
+	map__set_end(map_ref, map__end(replacement_map));
+	map__set_pgoff(map_ref, map__pgoff(replacement_map));
+	map__set_mapping_type(map_ref, map__mapping_type(replacement_map));
+
+	err = maps__insert(kmaps, map_ref);
+	map__put(map_ref);
+	if (err)
+		goto out_err;
+
 	/* Add new maps */
 	while (!list_empty(&md.maps)) {
 		struct map_list_node *new_node = list_entry(md.maps.next, struct map_list_node, node);
@@ -1372,24 +1390,8 @@ static int dso__load_kcore(struct dso *dso, struct map *map,
 
 		list_del_init(&new_node->node);
 
-		if (RC_CHK_EQUAL(new_map, replacement_map)) {
-			struct map *map_ref;
-
-			/* Ensure maps are correctly ordered */
-			map_ref = map__get(map);
-			maps__remove(kmaps, map_ref);
-
-			map__set_start(map_ref, map__start(new_map));
-			map__set_end(map_ref, map__end(new_map));
-			map__set_pgoff(map_ref, map__pgoff(new_map));
-			map__set_mapping_type(map_ref, map__mapping_type(new_map));
-
-			err = maps__insert(kmaps, map_ref);
-			map__put(map_ref);
-			map__put(new_map);
-			if (err)
-				goto out_err;
-		} else {
+		/* skip if replacement_map, already inserted above */
+		if (!RC_CHK_EQUAL(new_map, replacement_map)) {
 			/*
 			 * Merge kcore map into existing maps,
 			 * and ensure that current maps (eBPF)
-- 
2.43.0



