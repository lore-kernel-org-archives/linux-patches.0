Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B764334C3C;
	Sat, 12 Sep 2026 15:02:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789225371; cv=none; b=FYnVgcWoW+VvPEVvtMetcTTfsSta104alSfwIz5LVXWCMvMGGmwJXyoIFnMYOT8UXzROFtcbYcH10E0KKLkA8mgdIjuAzl0EHYbIGIrVk5eke0bgY8aLGZ3Pq20Vzre2483ao1GEQaXmj5+1BUWO2sUOHPNgVwBWoG7XjGBrYVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789225371; c=relaxed/simple;
	bh=Wnt80DnovdiusoptP+aSWtEcmYpXpoSLWRbgiUqvuGg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HupoZUVhdBTqznOXVglXLM4pOtoVCn92fODF41Cb5sdLyqqqRojylMLi5hZ73Tbxd+xP+nA8CzMiWtTt2gzXrp+jF1+vKUdV7VZWZK3VFYrpdEzL2+/vbKuruSSpZ28PUSVfAsaDNn/p0JGMsIAZgz6b0xTHfMmSQD0kJppwvAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M9dDx4n1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M9dDx4n1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68A421F000FF;
	Sat, 12 Sep 2026 15:02:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789225370;
	bh=LH3etJOh1mkABPsuPMjfgNiJ1GZzmDlL8tGMB/I4XRI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M9dDx4n1GjLTSJp1ZlZFOyJPJaVcpsqlG7UIo4UJDrz9vK/ZmEGpHPD3HJPrp4krF
	 o5+5PEEgsFRnYhshxWPjeNv8Pu7MHXsx7dcWbQ7bJM6wDvYWa5x7IeDdtEZt5higUU
	 MMKubSR3g1HH19MEZhK7ZGHd89iocY8M/JNqWzrg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1141/1424] perf synthetic-events: Fix uninitialized pthread_join
Date: Sat, 12 Sep 2026 08:59:33 +0200
Message-ID: <20260912065632.849745077@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Rogers <irogers@google.com>

[ Upstream commit 54ba44db4dddc4ca06b49bae0f9d6c5861430b18 ]

In perf_event__synthesize_threads(), fix an uninitialized pthread_join()
call when thread creation fails by only joining the successfully
created threads.

Assisted-by: Antigravity:gemini-3.1-pro
Fixes: 340b47f510bb ("perf top: Implement multithreading for perf_event__synthesize_threads")
Signed-off-by: Ian Rogers <irogers@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/synthetic-events.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/synthetic-events.c b/tools/perf/util/synthetic-events.c
index a0579c7d7b9e9..2e1c4a1536fd3 100644
--- a/tools/perf/util/synthetic-events.c
+++ b/tools/perf/util/synthetic-events.c
@@ -1075,8 +1075,8 @@ int perf_event__synthesize_threads(struct perf_tool *tool,
 	}
 	err = 0;
 out_join:
-	for (i = 0; i < thread_nr; i++)
-		pthread_join(synthesize_threads[i], NULL);
+	for (j = 0; j < i; j++)
+		pthread_join(synthesize_threads[j], NULL);
 	free(args);
 free_threads:
 	free(synthesize_threads);
-- 
2.53.0



