Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61AAB4E1D8;
	Tue, 23 Jan 2024 00:33:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970003; cv=none; b=uuAOaFpkscFuqt7Z2fYn4LZF62kwkNPIE+76GNFkwDkK0AGLqPRBJfXgukhwond5/mkO+d1ga/4VHm/8PTnuKwPbtaolihB/Yu+76Xu3+HOb7jdAvXaDPMbV0/9/5EhIvf0BPsdNRIMS9hRaE8ZTiVWTQi5t07BxWiMs8U/yIVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970003; c=relaxed/simple;
	bh=a+vEKBhGU/TR1im6bY5Zx0mUAifvTl5DnXwBas2gzKM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t71mE+D+sJRtMqJVlnTeHgRion7SCijlYCmR4aRt+91ROSZkRsauUYmN3J9cKXwee1DMoXMl8CDAvL5z13zXi2+dHNtRf895wcwLqxYuYbZFg2tOI0BZluBHiAd/OADFnDrxg7JIj1mQwHt0l91l5cQhSnfkPRBMGNCWDkFTcUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X2Q6ED3n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X2Q6ED3n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7845C433F1;
	Tue, 23 Jan 2024 00:33:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970003;
	bh=a+vEKBhGU/TR1im6bY5Zx0mUAifvTl5DnXwBas2gzKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X2Q6ED3ntRkzomkZcJPnIWrJ1JgVDECjTZfabCsCiO8M3cgUBOL5RplDxrDlJcEKR
	 tetRYjwkjwXlhbdGYbp28k0mF/t7ANwWa9P3HORAWmpLJ70cUAsW8w0iCj6PgtQ4f9
	 t4lS4Ym2WIV0d7HG4fY6sUKQRvjgGrA5IkfQAK5s=
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
Subject: [PATCH 6.7 536/641] perf unwind-libunwind: Fix base address for .eh_frame
Date: Mon, 22 Jan 2024 15:57:20 -0800
Message-ID: <20240122235834.894829842@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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



