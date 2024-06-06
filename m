Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C985196DA2;
	Thu,  6 Jun 2024 14:08:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717682902; cv=none; b=qdZj7Jp+Hl4EDKl32R1fXAqmfYlA7bM4iEa7K5QcBOpYfvxzrE2B3irXDGSG55CdoiNNXwJ78L/Ej8Sg8ql4aZ6RvS4SCP8iZQudBw2nduryJ7s77nzu4VphU7/YcPlKJEt2JJ6yqXqFIaPejBjXcH6ZwDVtW5xAk+l2IX5WnIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717682902; c=relaxed/simple;
	bh=b4Uj0XQOEJEMvBzYSDQ9uCckBWfG67210yA+119Qk5M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LbBBDWStzpLGGPq79mUi/+y9WpOSkai/Adm5gpoQTCoC6KjgQKZygtxDlwE9WGuo5oQxzvVPv/DeJ8RhTpo+HW8A5LTte7DC2/Hyh/lDLTd+Q7dT2pquDwOLdQNufV2GWRKYOMOrLfn3YXq7KloFENEcb6UeEyHRTFHg4d62Cac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0mRy6f7B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0mRy6f7B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29300C32781;
	Thu,  6 Jun 2024 14:08:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717682902;
	bh=b4Uj0XQOEJEMvBzYSDQ9uCckBWfG67210yA+119Qk5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0mRy6f7Ba2g5pOqZbL5dmIOIBU0iXxJiLqXk3S8QWsVYJtT2K0p0h8ZOmbQnVNnsp
	 iBI7KyGKRcdN/qwabYTL518YOUE55RkPsW1ZbAsSCP1vjuzicEWFBOU+iep2nMAhV5
	 kIFGUqJtoo/d6+iSgljU7ubFx9w42dK2QgjEkdLw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namhyung Kim <namhyung@kernel.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ian Rogers <irogers@google.com>,
	Ingo Molnar <mingo@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Kan Liang <kan.liang@linux.intel.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 023/374] perf annotate: Fix annotation_calc_lines() to pass correct address to get_srcline()
Date: Thu,  6 Jun 2024 16:00:02 +0200
Message-ID: <20240606131652.574129161@linuxfoundation.org>
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

From: Namhyung Kim <namhyung@kernel.org>

[ Upstream commit aaf494cf483a1a835c44e942861429b30a00cab0 ]

It should pass a proper address (i.e. suitable for objdump or addr2line)
to get_srcline() in order to work correctly.  It used to pass an address
with map__rip_2objdump() as the second argument but later it's changed
to use notes->start.  It's ok in normal cases but it can be changed when
annotate_opts.full_addr is set.  So let's convert the address directly
instead of using the notes->start.

Also the last argument is an IP to print symbol offset if requested.  So
it should pass symbol-relative address.

Fixes: 7d18a824b5e57ddd ("perf annotate: Toggle full address <-> offset display")
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/r/20240404175716.1225482-2-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/annotate.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index 50ca92255ff62..2ebe2fe92a10b 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -3025,7 +3025,7 @@ void annotation__toggle_full_addr(struct annotation *notes, struct map_symbol *m
 	annotation__update_column_widths(notes);
 }
 
-static void annotation__calc_lines(struct annotation *notes, struct map *map,
+static void annotation__calc_lines(struct annotation *notes, struct map_symbol *ms,
 				   struct rb_root *root)
 {
 	struct annotation_line *al;
@@ -3033,6 +3033,7 @@ static void annotation__calc_lines(struct annotation *notes, struct map *map,
 
 	list_for_each_entry(al, &notes->src->source, node) {
 		double percent_max = 0.0;
+		u64 addr;
 		int i;
 
 		for (i = 0; i < al->data_nr; i++) {
@@ -3048,8 +3049,9 @@ static void annotation__calc_lines(struct annotation *notes, struct map *map,
 		if (percent_max <= 0.5)
 			continue;
 
-		al->path = get_srcline(map__dso(map), notes->start + al->offset, NULL,
-				       false, true, notes->start + al->offset);
+		addr = map__rip_2objdump(ms->map, ms->sym->start);
+		al->path = get_srcline(map__dso(ms->map), addr + al->offset, NULL,
+				       false, true, ms->sym->start + al->offset);
 		insert_source_line(&tmp_root, al);
 	}
 
@@ -3060,7 +3062,7 @@ static void symbol__calc_lines(struct map_symbol *ms, struct rb_root *root)
 {
 	struct annotation *notes = symbol__annotation(ms->sym);
 
-	annotation__calc_lines(notes, ms->map, root);
+	annotation__calc_lines(notes, ms, root);
 }
 
 int symbol__tty_annotate2(struct map_symbol *ms, struct evsel *evsel)
-- 
2.43.0



