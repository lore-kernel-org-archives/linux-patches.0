Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31891288B9;
	Sat, 12 Sep 2026 16:39:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789231171; cv=none; b=WI7WzV7JUyL1+GuLYSWwFsGKoljM84FAJCj4S/RPfTca8t5FoTteh4CR3YKhfGBaiRHDMAgOaW4evAfCWFKlcQraj7eIKxsh/T6DWU2msB7I01bTA2lZXNtOLOHj9dekdZOhu4iASLX4IAiZQ9y94eXdeAq+KDzAXUzHOqYWO50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789231171; c=relaxed/simple;
	bh=9IqTc0I6xPyY2qIKa7XG5LjH2/n5MMWPTGB07UZFRR0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QY1bV1hma79s/tXs3/5gH5EVLV8DPMFWfaMJfwlaOfNM5aLzDpzPtKuQrJaz7a+RaWb83ulHhoTFE4OmJTBfkYQXCpPrD63fxRedIJCBctsv2lQL06hwecGhtKRRK1WlvCCd9LN8oklgadK7uIrWbCG1jhLxkUlVy+yovuCOwPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P9ohyAG1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P9ohyAG1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FDA91F000FF;
	Sat, 12 Sep 2026 16:39:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789231170;
	bh=0MKvIdcN1SPJpHg+GBVnK2ZD0mPzdgxMnKnpE2EkpVM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P9ohyAG1tNCtQTSIcv1mPRkbxlCzuWddPU18z5NclRt7qELe6cQMNweSMNmk8ny/I
	 hvgty87nGIVckcTMTrkYSXrNn44uD7agEscw+hjiN+TDOJgRN1ldwzA0C3V/rQtTzo
	 MTlSczbqBiEHkovnqa2/2ipRaWrR+XCNkfCMzeBg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0944/1191] perf synthetic-events: Fix divide by zero in perf_event__synthesize_threads
Date: Sat, 12 Sep 2026 09:01:12 +0200
Message-ID: <20260912065609.427899174@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 2e55db810f8a3..70a8431937c54 100644
--- a/tools/perf/util/synthetic-events.c
+++ b/tools/perf/util/synthetic-events.c
@@ -1027,7 +1027,7 @@ int perf_event__synthesize_threads(struct perf_tool *tool,
 	else
 		thread_nr = nr_threads_synthesize;
 
-	if (thread_nr <= 1) {
+	if (thread_nr <= 1 || n <= 1) {
 		err = __perf_event__synthesize_threads(tool, process,
 						       machine,
 						       needs_mmap, mmap_data,
-- 
2.53.0



