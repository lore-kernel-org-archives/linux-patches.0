Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12AC447CC8A;
	Sat, 12 Sep 2026 13:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789218016; cv=none; b=GIAiVJ+zuu1QbGN3A7+eZdYDGKC/2W5s4bY5MH8aDDE9HoWUp76695ecXwmIz64QvG36TsRrE7m6GVC6OC/mlph2itGxPTalqBgi/vqqWwQncA9W7kuldYzJ4ZOCkb+ERCVADnSI4OyCiCAyUTWTdCf148fq3pw1vjjAHTnwe/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789218016; c=relaxed/simple;
	bh=fcYRk9Ua+5NoHHxCl2KhV9nv/pwDxnV09pSM1AxvakM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p5JED9kUkE8Dt471UC3UuR0NK/Bj82k84fvzWmnY0AhYmsgHcS5nHnF/rDnKzxQoZrBSZF/LnTC3Xeo66QhWKed2IE85MNPGBrpmUIN2rxIyZ4P3u/tVOol3N6byWZVpEBmTKlx8PSvKQ1Wmv09c2odlp0jvuOSFqR6X5E4hwDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z9anxdeV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z9anxdeV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D86581F000FF;
	Sat, 12 Sep 2026 13:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789218015;
	bh=+WNdqq5NjUz/KomAejhQljznF+1nNUyYAzqmxTOVSok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z9anxdeVyZKkzE2p/wfc+L1KlzUd+ZxJYsNd4lJLR8XMWWBRJydBgZ0iOwKSK1z37
	 3X/vuuakZ8StPwiT0OmxZkNXiGNvo7qW+pbMrUXoWEsIFnGkktL/rgGfJsZkBSVv+B
	 PEDyhupKFegY/nYynC6CzsdTy8I0ROKoKRi+sTZ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1021/1376] perf synthetic-events: Fix divide by zero in perf_event__synthesize_threads
Date: Sat, 12 Sep 2026 08:57:27 +0200
Message-ID: <20260912065630.318253070@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Rogers <irogers@google.com>

[ Upstream commit 16a12a54e9a1151a37aab74914a51b86f7f58d0e ]

If scandir() finds no matching tasks in /proc, n is 0. If thread_nr is > 1,
we bypass the single-thread fast path and then clamp thread_nr to n, making
it 0. This results in a divide by zero when calculating num_per_thread.

Handle n <= 1 early to use the single-thread fast path and prevent the
crash.

Fixes: 340b47f510bb ("perf top: Implement multithreading for perf_event__synthesize_threads")
Signed-off-by: Ian Rogers <irogers@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/synthetic-events.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/synthetic-events.c b/tools/perf/util/synthetic-events.c
index d972587cf5270..660689968b795 100644
--- a/tools/perf/util/synthetic-events.c
+++ b/tools/perf/util/synthetic-events.c
@@ -1045,7 +1045,7 @@ int perf_event__synthesize_threads(const struct perf_tool *tool,
 	else
 		thread_nr = nr_threads_synthesize;
 
-	if (thread_nr <= 1) {
+	if (thread_nr <= 1 || n <= 1) {
 		err = __perf_event__synthesize_threads(tool, process,
 						       machine,
 						       needs_mmap, mmap_data,
-- 
2.53.0



