Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F37774F88C;
	Tue, 14 May 2024 11:34:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686454; cv=none; b=S/Bvarj1ri3cYkR5yqsYIPUDNvssYsbE5OQ1KCjZYxP8A4bC7Za1oU+SabCVWC1XwCkKaiW4tSk8xSsIFvra+sAtjOnWMAcncEYNzUZ+nw4hJC3wVAh00LrkjUF5IQPhlxyFddDbmjxvdo4+/GXAR95UGx728P9QFBRQn/dqkNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686454; c=relaxed/simple;
	bh=Q3Tll8zZ0NcKDDbN9BiG4bhdhQl9JKlytmRoB0J24eI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i3CqAVgsoxQqP0byA1Zn2EbvxdOVwD4gv5hI7NPCXTryXN7ZqJHqu28ZhMhEO0e9z/HdWDjDOTZcTUO/HtzjDe1TJ48AVsOjZXLQ1hGptLk2CWfjxfLsslgm7xKvUCY0X1mJId0D5ams0PoBb1764ATVrk73Yg/d0ypZ7z6aISk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NdmGylhW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NdmGylhW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F10E6C32781;
	Tue, 14 May 2024 11:34:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686453;
	bh=Q3Tll8zZ0NcKDDbN9BiG4bhdhQl9JKlytmRoB0J24eI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NdmGylhW9fW2Yv856tZOlsmh7pRw0BBrLPwP4vueVZEBi/sfaZAYm+QJkBkFDJ91W
	 yHxs4bUjJulqOjKx6HMX3kXTRH8HpwEzVGl6gPb4xU2SKemi0EBysJM/e90MGyydOo
	 /ZY2yU08TihczDypX2CsnV0XhzCbsPsG4Wksi4mk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Fangrui Song <maskray@google.com>,
	Ingo Molnar <mingo@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Milian Wolff <milian.wolff@kdab.com>,
	Pablo Galindo <pablogsal@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 142/236] perf unwind-libunwind: Fix base address for .eh_frame
Date: Tue, 14 May 2024 12:18:24 +0200
Message-ID: <20240514101025.761382034@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101020.320785513@linuxfoundation.org>
References: <20240514101020.320785513@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namhyung Kim <namhyung@kernel.org>

[ Upstream commit 4fb54994b2360ab5029ee3a959161f6fe6bbb349 ]

The base address of a DSO mapping should start at the start of the file.
Usually DSOs are mapped from the pgoff 0 so it doesn't matter when it
uses the start of the map address.

But generated DSOs for JIT codes doesn't start from the 0 so it should
subtract the offset to calculate the .eh_frame table offsets correctly.

Fixes: dc2cf4ca866f5715 ("perf unwind: Fix segbase for ld.lld linked objects")
Reviewed-by: Ian Rogers <irogers@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Fangrui Song <maskray@google.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Milian Wolff <milian.wolff@kdab.com>
Cc: Pablo Galindo <pablogsal@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/r/20231212070547.612536-4-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/unwind-libunwind-local.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/unwind-libunwind-local.c b/tools/perf/util/unwind-libunwind-local.c
index 81b6bd6e1536a..b276e36e3fb41 100644
--- a/tools/perf/util/unwind-libunwind-local.c
+++ b/tools/perf/util/unwind-libunwind-local.c
@@ -327,7 +327,7 @@ static int read_unwind_spec_eh_frame(struct dso *dso, struct unwind_info *ui,
 
 	maps__for_each_entry(ui->thread->maps, map) {
 		if (map->dso == dso && map->start < base_addr)
-			base_addr = map->start;
+			base_addr = map->start - map->pgoff;
 	}
 	base_addr -= dso->data.elf_base_addr;
 	/* Address of .eh_frame_hdr */
-- 
2.43.0



