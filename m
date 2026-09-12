Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4E19416842;
	Sat, 12 Sep 2026 08:46:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202806; cv=none; b=dYcI8ey1g+sJXgJOBbrej6Gpjx9VtawTHpgke7fRkdrwTVAnxpyA+cZMqs5iMm+86O0ilK9ob9lcsZh8YvFSZbzcswmrhKITJ4ImvQW50mm9xDp9LU6fdxB0Z60dt8YiqCDXDFRj6hKAk6rn9V/GH8sgH4mjxy2/5GFS2sAaEOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202806; c=relaxed/simple;
	bh=XKV4HVvEqq0ZCXBtk96dojxm8Oo9U8sVNmpAkl6nem0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JQqFBQTJDOpTsZsIj3GZLZ0iG1qksUo7I9OtfWjjXs4lM9dCBGLhZVMicSDD8IQeBfq58j1H/gytbs36YkoFhqmEQpEKMWa6NVHhFTdPv1AymIBcHR/G9WjQVhVVMDDCEeZuLeh2k92jtPpWjyLKCg2OfxIMme4FstBzpym68YM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xzrFK/q+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xzrFK/q+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 527E71F00893;
	Sat, 12 Sep 2026 08:46:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789202801;
	bh=rqDyEf0FbQ4+SlRCW3TALJEc1Y7d/ZwmMxFW2RZ5cHk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xzrFK/q+Y+LIhjC8uow2w0vyMI5oQHcU7+VYrsHReyeQcCZgML2y7IApnKs8IE0YW
	 qp7fwjwYxgGpwYTRu8rQfDsCUk9eretnN3Wk09qlpybwjREdtmEMizB+kCsk+EPyWW
	 5PTM+Fn0CybK3Hc3vy3CiiTZ/SN7r+rtwtSz+HKc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1276/1815] perf synthetic-events: Fix uninitialized pthread_join
Date: Sat, 12 Sep 2026 08:50:26 +0200
Message-ID: <20260912065718.971240756@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index b75f9dcf4dbfe..35de41ad14d33 100644
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



