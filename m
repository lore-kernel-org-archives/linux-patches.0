Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0511A392806;
	Sat, 12 Sep 2026 19:59:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789243164; cv=none; b=EfktVIYh8rJajS7xylRUstPjRabnyuhmafrA6u0j5JFiC1HMxJ+xGVaCTQkwDBBjBrSx8le+dmRCZlUD+7yErRKGvKvR5nD9c7A5mIM93nlVF0UaVVPw4GIE4ANxIX0P/rbfgkHb2GpYbGIv1P7RYHo3SInntBgTlFeIYQo1t0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789243164; c=relaxed/simple;
	bh=vLgE8oM2qWI3s1CraEbAp1i+1CBgEd/F7Ss8sCZlqXE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bxh60phdWNHC0hQ818RetqEKOGMkoUp3DJl51xKhQlxbdY3T/9HKFmE6pyfDwSXo45ujxZo5KF4K/0flkQOATo+jNR1xkf+Oj+279LCPpZ4nMiwbinNWtP9J66yvhIFzEAvqitqvKM0hABhw4RdoOvyne0bxy24W4+ZzXSbgqQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eZzWvTsg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eZzWvTsg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F06B1F000FF;
	Sat, 12 Sep 2026 19:59:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789243162;
	bh=iFHCcoOJwBJOakBASul41lzL2e9KdXu5P+Htb4BUrc0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eZzWvTsgEiRYAdYYBXpadaIz4b6ekwDTq2RJLPLEmbfb/rrzzoOAZkRTb0/idlH/q
	 FTXJ7Avjxugu2+croCHZ32IGEeErVO7YuU+NByMi3ksr5wokIFf6nxTuvJYLj2S5Ex
	 +x0mnc0K6+Qs+BcZvVv17E7V1YoO4ZLslSqq0FE8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 660/798] perf synthetic-events: Fix uninitialized pthread_join
Date: Sat, 12 Sep 2026 09:04:48 +0200
Message-ID: <20260912065532.238507199@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index b4cf6dd57dd6e..fcdafc35d5e48 100644
--- a/tools/perf/util/synthetic-events.c
+++ b/tools/perf/util/synthetic-events.c
@@ -968,8 +968,8 @@ int perf_event__synthesize_threads(struct perf_tool *tool,
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



