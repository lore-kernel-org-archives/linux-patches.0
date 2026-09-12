Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 686A63290D1;
	Sat, 12 Sep 2026 16:39:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789231166; cv=none; b=J6PWFoddk9qhXBFvqbXt1UiTksXE3ykBoMKDnt4NfWRWYei2TqVhgSGkU8EvT5rP+U/73TJL1y8DjCPi0erydmPCBPBeqdoYtaFbHfQW+BnH5yqlsPQAyWFGY5ekH7E0iDkEhgmXVhYL9LRU6/bIMBZr2qCW5DWf2H/UAIu0kIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789231166; c=relaxed/simple;
	bh=38KeVTzubs4kHZAjNNNGVhLk526C9T8on+W/20qTqGc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E/GXmjZR2JBf0gJQ06lQz2utNjW/yG4A2pnQtv1tlDA2jCM2TRK3S4EOsvIq4qtXXIYJZRgP2ZLlVivoUmHWDxnC0g4O8W7vsBc36bFZFCjvexemoVHvf9RrALLIO8+kmgeagJfw0ZVswQV6doJSr8lInCNUIPx0ME4HzV67p7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mOlAyln4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mOlAyln4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4249B1F000FF;
	Sat, 12 Sep 2026 16:39:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789231165;
	bh=iB7GfHEAZBPejuGmrKF0w9EdHer7EsAnmHIQfA9T6iY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mOlAyln4TN8x9q6iIdsxpdo945397o6LV5RtmOrB7Ar2N4+JUJ2xNUHJjgeqTvVD9
	 IHzPgZ0Dm5SuZW3ttzH5S1N2pXtAmz0q1yuPuQre2qPukKZtNdI+x+IypfwILVp72w
	 IRqXHEOah99BpSjftCQDjuoSXW448lm/GhWWWjAc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0943/1191] perf synthetic-events: Fix uninitialized pthread_join
Date: Sat, 12 Sep 2026 09:01:11 +0200
Message-ID: <20260912065609.406267345@linuxfoundation.org>
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
index cccd293b53124..2e55db810f8a3 100644
--- a/tools/perf/util/synthetic-events.c
+++ b/tools/perf/util/synthetic-events.c
@@ -1073,8 +1073,8 @@ int perf_event__synthesize_threads(struct perf_tool *tool,
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



