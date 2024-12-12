Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58AEC2210E5;
	Thu, 12 Dec 2024 16:09:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019774; cv=none; b=hrEMMVj/QJKkdFinSIbCxXGQV1WYdC5b6UDGyQ7UxF5dp6yL9Av4bXtqdmIVcsihmYGt9iA1WcR/ceceWBu5fM/0Dq42IuclHCN6nRcnO4zLfAahQc9C81SNHyc6rMeL67cd+odyczkzFYGoFGArxqIsOoCW0JmaytuAnSt7y5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019774; c=relaxed/simple;
	bh=wPqulbLo/mSNHOJdypAHehIlo46yi6/P/ofWvEGUxEs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T9mGary+Url482VXa9as3bkVIzMkqo2jntGTKCwtuiOhnboMZYxP5pCnt4o3E5ZAP0MYqpOnnPCwP4kswY/+hPJeK2E0HerU2l9gMBWEz+R36fBYegyF8NTblWy+xvIAfyy6PFqNG+TR00tEe0wh7FumlpMlYKdzUsqZnO9Ta0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T5zwXgU/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T5zwXgU/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF24FC4CECE;
	Thu, 12 Dec 2024 16:09:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019774;
	bh=wPqulbLo/mSNHOJdypAHehIlo46yi6/P/ofWvEGUxEs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T5zwXgU/4sYqaYym9b4rw2xngBWIwNnhkSlZ1bsci/4sYYuRxHHyVSazhSfMtzZqN
	 eaJfMdZTcrpeV5iT2MIXvbZkgiooMewlPRs5HAjtdIj6yBoPiZUVAmUii9Jb40wBEv
	 AbbGFPIMPWsEzMF5vzsjK8NpyVxy/zaV0K+iHhbs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 264/772] perf stat: Fix affinity memory leaks on error path
Date: Thu, 12 Dec 2024 15:53:29 +0100
Message-ID: <20241212144400.822848943@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Rogers <irogers@google.com>

[ Upstream commit 7f6ccb70e465bd8c9cf8973aee1c01224e4bdb3c ]

Missed cleanup when an error occurs.

Fixes: 49de179577e7 ("perf stat: No need to setup affinities when starting a workload")
Signed-off-by: Ian Rogers <irogers@google.com>
Link: https://lore.kernel.org/r/20241001052327.7052-2-irogers@google.com
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-stat.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 79e058ff8a33a..b243027bc22d8 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -865,6 +865,7 @@ static int __run_perf_stat(int argc, const char **argv, int run_idx)
 		}
 	}
 	affinity__cleanup(affinity);
+	affinity = NULL;
 
 	evlist__for_each_entry(evsel_list, counter) {
 		if (!counter->supported) {
@@ -1005,6 +1006,7 @@ static int __run_perf_stat(int argc, const char **argv, int run_idx)
 	if (forks)
 		evlist__cancel_workload(evsel_list);
 
+	affinity__cleanup(affinity);
 	return err;
 }
 
-- 
2.43.0



