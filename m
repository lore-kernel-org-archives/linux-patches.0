Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 217014BEE2A;
	Sat, 12 Sep 2026 10:56:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789210571; cv=none; b=ZSVkkL2uihlArtu5A1SkB4s4eIxTN9r6wETIG64u+65f7K+fSTPjlcSQxUra/DJ9HGhGKm8KYsVGLiAwuUtuSn7nfihylNu3erneI+n48F3v8ju9ATy9j0hJ7lnYwGYb1b3rAvENUNfYK5g48dgUurM7KGdJMknioG5l+uwmsKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789210571; c=relaxed/simple;
	bh=bZmurKyfVPFmqacdKqYyIIC/r+KLvqdjmoJUqrpjYvQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EByaJT3Tm6EIehnUiCt7IH4/IdNHs6vJe4S78yp3yY6cCT2JEk9Pv0+ETOtgmlI2MT54IL8c2Z6MW2WDaBq4Bu/uoRM7NWjQfe10FW8dSgRO4ZRsVKOPZLyE4g8ee6K0g/f+NoMrdMzTwUStXLYrxVfkWxq3+X4Jw5ti6LKny2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YXDmt2NL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YXDmt2NL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 265531F000FF;
	Sat, 12 Sep 2026 10:56:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789210570;
	bh=xuur42ELqAWuHWlvcZ9NH8LGjF1u1aONH3tYohNjQPU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YXDmt2NLmp45bQjkoe8FCkUQBhQ/AW6bToeNBY5PAI/SlbRVTbF0T9eZ8f5OgKFKx
	 cTzqzPD/skLLAnHuX8WgRKvS/Xmp6gb1fy1BlQqDB+eG789n0NpQLUZyfAFhRo4rtU
	 5pqqnppPh5oHXr8dZ8frkBWn1HI/AIHuqKZ6FQzE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1051/1518] perf synthetic-events: Fix uninitialized pthread_join
Date: Sat, 12 Sep 2026 08:53:40 +0200
Message-ID: <20260912065647.225044481@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index c5b0ba775098f..f2d09fcaafb76 100644
--- a/tools/perf/util/synthetic-events.c
+++ b/tools/perf/util/synthetic-events.c
@@ -1104,8 +1104,8 @@ int perf_event__synthesize_threads(const struct perf_tool *tool,
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



