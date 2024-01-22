Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D09477636;
	Tue, 23 Jan 2024 02:05:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975536; cv=none; b=oP82duS6hSwDa0fBxdqUKiLGGWdczyU/zKuchcFdztx6nBnh2Q6NcqFlBQzz3NceJj4FmIHh3LKUlBo3zME7BocCvDeB9+/rnc7tXnf8P8t+OpuXppfh2BgS9CfkiNz3BBTmb3HlX24Oay5JgOQynNfGEc0jXBOeH6XpaFDhMJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975536; c=relaxed/simple;
	bh=bv0CM6HBBiL56wTydBuoLsPDuQ/monk579RChBxyVH8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n1Y3/oQIJbGeAXkXeO3NAlKmhsygk2nSLYvhJaEI4cHR3ptA4oGGnjzKs4snd6A3xzIAVIyKkkzSU3bZIeNUhooZKkqWOWN1RpkITJvuYmSoP4bNoBEK68X6r6eOTB+CTZ7p3z0N0Nokx5EWrMrepr3RzFJ/uEjugRV5t9LAtNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M/F4tU9F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M/F4tU9F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 587A3C43390;
	Tue, 23 Jan 2024 02:05:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975536;
	bh=bv0CM6HBBiL56wTydBuoLsPDuQ/monk579RChBxyVH8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M/F4tU9FTVJFDEyB5JwKK6/uiTBFck56BjR4EvscF42JUnSlfGq9JyXBgNgdz0S7E
	 DBR1uSRvRrtDiVoGslK44nFnJZM/t6j7qJ5g8uYLRZlWPR9R+s980n6LizWFIB2Wkg
	 kR43wEJZ8yMB8XOFeP+KBnNFyTJEoZfiONftQTD8=
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
Subject: [PATCH 6.6 487/583] perf unwind-libunwind: Fix base address for .eh_frame
Date: Mon, 22 Jan 2024 15:58:58 -0800
Message-ID: <20240122235826.917807363@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index c0641882fd2f..5e5c3395a499 100644
--- a/tools/perf/util/unwind-libunwind-local.c
+++ b/tools/perf/util/unwind-libunwind-local.c
@@ -327,7 +327,7 @@ static int read_unwind_spec_eh_frame(struct dso *dso, struct unwind_info *ui,
 
 	maps__for_each_entry(thread__maps(ui->thread), map_node) {
 		struct map *map = map_node->map;
-		u64 start = map__start(map);
+		u64 start = map__start(map) - map__pgoff(map);
 
 		if (map__dso(map) == dso && start < base_addr)
 			base_addr = start;
-- 
2.43.0



