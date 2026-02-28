Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB3464A2E02
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:47:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772300877; cv=none; b=Lnr1t5lsRzAv8aRfUrYkA0ws3fLnlXmM1R6GQLRR/teHkwnuZEmc+kdNgdepGCGTZYkLsvs95U+hI5pJwUHR8jNefBLOiWneUM1sSjrkDsV7wL9Dm0/0+el9N92YY2QIN9cqjaWcXPV4uZ3pPrAUFoXg8OWkL/fxHIvwvKGm+Z0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772300877; c=relaxed/simple;
	bh=krid9cOIMHTsvZ7Qjdu//AWrJ+QyM9fIZuFb2ch7s6o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VdFqeuRXCUbx3aqNlZEl5uSuyA9iantVL6N4gykGOl79Oq29SQJ3iFlmZBT3Mw2bjudyD1hCy+X3Kxy5THmdcz6aeM2VjtRiGzqJMYMYp77kLoqFWhHS6YuLbsaUAB9gGN2ncxhWnVWQXCMnqUoIAMjqGjRrk0v9x9VR/4Ai8jk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C5QKandP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C5QKandP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B0C5C116D0;
	Sat, 28 Feb 2026 17:47:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772300877;
	bh=krid9cOIMHTsvZ7Qjdu//AWrJ+QyM9fIZuFb2ch7s6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C5QKandPm85pKpL0+jkqPJpkBCJKhzdojDicYiSikyycqrF/8o4Le8458ySyc/m1F
	 yoqemEDQlgj78eiGMwBCJEk7VI3VRYGvcXDonS/13v9VzvhresNNABhI9Ws/FF7dfr
	 KQPtSCB1U/+waQxLRBGhEkQ8hPdwZzl3SdmLTJhLGdHel4mXbjnO0p5MyY6LgfNvyE
	 vqq0BpjJ40Wpq6oWwAzDz9AAscFUKC7xSVs2yZhKz4byt1/L1SS71l6wRXyLZPU1ly
	 nYZqgKRdL/IrrLqWOvvcux/N7XWxJnAN+wNoLtL2pGZSwGDBCM8oBOd/fuCdIILqnB
	 kfJahXJWn5hvA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Ian Rogers <irogers@google.com>,
	James Clark <james.clark@linaro.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Howard Chu <howardchu95@gmail.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Stephen Brennan <stephen.s.brennan@oracle.com>,
	Tony Jones <tonyj@suse.de>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 004/752] perf unwind-libdw: Fix invalid reference counts
Date: Sat, 28 Feb 2026 12:35:15 -0500
Message-ID: <20260228174750.1542406-4-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Ian Rogers <irogers@google.com>

[ Upstream commit f815fc0c66e777c727689666cfb46b8d461c2f99 ]

The addition of addr_location__exit() causes use-after put on the maps
and map references in the unwind info. Add the gets and then add the
map_symbol__exit() calls.

Fixes: 0dd5041c9a0eaf8c ("perf addr_location: Add init/exit/copy functions")
Reviewed-by: James Clark <james.clark@linaro.org>
Signed-off-by: Ian Rogers <irogers@google.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Howard Chu <howardchu95@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephen Brennan <stephen.s.brennan@oracle.com>
Cc: Tony Jones <tonyj@suse.de>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/unwind-libdw.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/unwind-libdw.c b/tools/perf/util/unwind-libdw.c
index ae70fb56a0572..3ff427a49e4c5 100644
--- a/tools/perf/util/unwind-libdw.c
+++ b/tools/perf/util/unwind-libdw.c
@@ -136,8 +136,8 @@ static int entry(u64 ip, struct unwind_info *ui)
 	}
 
 	e->ip	  = ip;
-	e->ms.maps = al.maps;
-	e->ms.map = al.map;
+	e->ms.maps = maps__get(al.maps);
+	e->ms.map = map__get(al.map);
 	e->ms.sym = al.sym;
 
 	pr_debug("unwind: %s:ip = 0x%" PRIx64 " (0x%" PRIx64 ")\n",
@@ -325,6 +325,9 @@ int unwind__get_entries(unwind_entry_cb_t cb, void *arg,
 	if (err)
 		pr_debug("unwind: failed with '%s'\n", dwfl_errmsg(-1));
 
+	for (i = 0; i < ui->idx; i++)
+		map_symbol__exit(&ui->entries[i].ms);
+
 	dwfl_end(ui->dwfl);
 	free(ui);
 	return 0;
-- 
2.51.0

