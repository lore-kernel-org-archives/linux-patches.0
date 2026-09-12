Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3714D34CFDA;
	Sat, 12 Sep 2026 12:56:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789217775; cv=none; b=QjANFQSBW1zbVlYWw19ZZe+27x3okmd0GMq6cvNYx83P0mztusczANtvqyAtX4LyC30y8ADwDuM56SdIs3zmGQF/CBofp6Kn3buNf6/ky2oZAgKax0msDtsrV1AH8WSGpmVyO99udwFbV/HRNOGvcLh2OCge+E/hH+zQ3tpaaMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789217775; c=relaxed/simple;
	bh=lToRM1/FPUD26KuTwvs7Y7cwO+abCnA7ug4fYp1fXzQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oKlXgBhIFcQn6SFGaktRTtxhfARqUopaBOCXwHx6WukYJlF5qfLEsk5d+Joxpm++44Tn6lT8wVJ6P7oKKuycedYRetxrcaL/Eo5p7bwU9PGvFXiuzQbyLNYecBi3o0doiG1QcCgBJ/C+CAjoKNV8VS9bR8JnXBppgOCqPSg9wuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jMv3MfWo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jMv3MfWo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3B1C1F000FF;
	Sat, 12 Sep 2026 12:56:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789217774;
	bh=HQOS3NSSANZ6OtSozdkbXb2yl7YtlVw8adoUK8Zr7XI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jMv3MfWoTU/s9vBcHc1Ipl9M/J4YaPnP1Z/5c5xYnav+ixOvQRQaK/loCjHkyBk3r
	 WdCHkQxIlkFDfpTdQuHaT/fdtdzpEsbiBeAaFHzHKXw8OhaSLCNDHruh9fWQe+mHsd
	 zFKyY4BW4gj+9f6pWY7jlmVTlGYRkyZ2Hy7v+SIA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1007/1376] perf synthetic-events: Fix uninitialized pthread_join
Date: Sat, 12 Sep 2026 08:57:13 +0200
Message-ID: <20260912065630.008607082@linuxfoundation.org>
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
index a58444c4aed1f..d972587cf5270 100644
--- a/tools/perf/util/synthetic-events.c
+++ b/tools/perf/util/synthetic-events.c
@@ -1091,8 +1091,8 @@ int perf_event__synthesize_threads(const struct perf_tool *tool,
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



