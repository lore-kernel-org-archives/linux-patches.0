Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FEF73A383C;
	Wed, 20 May 2026 16:55:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296143; cv=none; b=M6BVUwMyZvZpl+XKbQj/c/LCQgNxle8TsNKbmpe9Sta6GRKRJ+1VXtuZk/M9HRpuVW9n9S0rZuhzKIv8aSiNqm5Z1ceVowTMOB5uw/WCYLiGpv3kTI3UnRM6vpopSCnj2vtsxPjmFktr5fXOqnxLaDoNR7inQyTAbG8NoqRSFtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296143; c=relaxed/simple;
	bh=8Ez8ukCe8TAUfrIC6BBoi1N5kPB+48RSinNNVbLyyD4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JGEKLUbPRYZlEh6ZsatXJnoese4zvyWKDyEZp5hxTy8X0MqaS4F1qaWMV7L1WxagBhSUl2ieNujBmHdUZJ3aGDfdw9rnMAsUsHKDTZDR3tG83mff4OJaQYXQsAJEgTpKcelLkDwSEFu+U7bqNuaeW8Bbini2UEZgvqWfEJCHxUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MU0eBIvL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MU0eBIvL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 844D11F000E9;
	Wed, 20 May 2026 16:55:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296142;
	bh=v68j0a7C5BFlAFxgaRO2di+TJdAmyssvb3gunoTMuXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MU0eBIvLnF/1DpKkVcM1mD5OdZiBmlGN76LMUh/i1bOixRhqyUkktlS7EyazCXEFi
	 FNcO4dz+awlnhncn9XNs7w2dt8KD7kT5HG5p+UEBnOTMaHRy+XXyBc/H0AAK5cVcOq
	 z5KaCa1thhYHeB0TFPJJ9wXiD4wqkap7DgCjlPLw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Sun Jian <sun.jian.kdev@gmail.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0650/1146] perf cgroup: Update metric leader in evlist__expand_cgroup
Date: Wed, 20 May 2026 18:15:00 +0200
Message-ID: <20260520162202.894899531@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Rogers <irogers@google.com>

[ Upstream commit c9ef786c0970991578397043f1c819229e2b7197 ]

When the evlist is expanded the metric leader wasn't being updated. As
the original evsel is deleted this creates a use-after-free in
stat-shadow's prepare_metric. This was detected running the "perf stat
--bpf-counters --for-each-cgroup test" with sanitizers.

The change itself puts the copied evsel into the priv field (known
unused because of evsel__clone use) and then in a second pass over the
list updates the copied values using the priv pointer.

Fixes: d1c5a0e86a4e ("perf stat: Add --for-each-cgroup option")
Signed-off-by: Ian Rogers <irogers@google.com>
Acked-by: Sun Jian <sun.jian.kdev@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/cgroup.c | 30 +++++++++++++++++++++++-------
 1 file changed, 23 insertions(+), 7 deletions(-)

diff --git a/tools/perf/util/cgroup.c b/tools/perf/util/cgroup.c
index 040eb75f08048..1b5664d1481f5 100644
--- a/tools/perf/util/cgroup.c
+++ b/tools/perf/util/cgroup.c
@@ -417,7 +417,6 @@ static bool has_pattern_string(const char *str)
 int evlist__expand_cgroup(struct evlist *evlist, const char *str, bool open_cgroup)
 {
 	struct evlist *orig_list, *tmp_list;
-	struct evsel *pos, *evsel, *leader;
 	struct rblist orig_metric_events;
 	struct cgroup *cgrp = NULL;
 	struct cgroup_name *cn;
@@ -452,6 +451,7 @@ int evlist__expand_cgroup(struct evlist *evlist, const char *str, bool open_cgro
 		goto out_err;
 
 	list_for_each_entry(cn, &cgroup_list, list) {
+		struct evsel *pos;
 		char *name;
 
 		if (!cn->used)
@@ -467,21 +467,37 @@ int evlist__expand_cgroup(struct evlist *evlist, const char *str, bool open_cgro
 		if (cgrp == NULL)
 			continue;
 
-		leader = NULL;
+		/* copy the list and set to the new cgroup. */
 		evlist__for_each_entry(orig_list, pos) {
-			evsel = evsel__clone(/*dest=*/NULL, pos);
+			struct evsel *evsel = evsel__clone(/*dest=*/NULL, pos);
+
 			if (evsel == NULL)
 				goto out_err;
 
+			/* stash the copy during the copying. */
+			pos->priv = evsel;
 			cgroup__put(evsel->cgrp);
 			evsel->cgrp = cgroup__get(cgrp);
 
-			if (evsel__is_group_leader(pos))
-				leader = evsel;
-			evsel__set_leader(evsel, leader);
-
 			evlist__add(tmp_list, evsel);
 		}
+		/* update leader information using stashed pointer to copy. */
+		evlist__for_each_entry(orig_list, pos) {
+			struct evsel *evsel = pos->priv;
+
+			if (evsel__leader(pos))
+				evsel__set_leader(evsel, evsel__leader(pos)->priv);
+
+			if (pos->metric_leader)
+				evsel->metric_leader = pos->metric_leader->priv;
+
+			if (pos->first_wildcard_match)
+				evsel->first_wildcard_match = pos->first_wildcard_match->priv;
+		}
+		/* the stashed copy is no longer used. */
+		evlist__for_each_entry(orig_list, pos)
+			pos->priv = NULL;
+
 		/* cgroup__new() has a refcount, release it here */
 		cgroup__put(cgrp);
 		nr_cgroups++;
-- 
2.53.0



