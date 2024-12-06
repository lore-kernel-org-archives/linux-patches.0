Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C017148832;
	Fri,  6 Dec 2024 15:07:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497628; cv=none; b=aE2Chw5qKkypPFpZ5AgpAiDaDfgXz9nyuJWaeQI+X2ZKdyvSgF5mH2swizBgWTDiz3ttSKmSpTkE/+E7gDsKb9Yhvea3gAQ7f81U077LWwThLiCrnrub+kfeeFeT2z7XePPrxreg+7MDa2VRqxwODlU9e4n96cE0ZtGYscWU9cs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497628; c=relaxed/simple;
	bh=OvD3SQkegzLVJZcKkOWIRjhnt6GtWGgGsPhHrsiQPFo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mv0R33g/x3aVh6IlQOtqnFQdqMwy5nYqRhgdCzm46gJk8lT4/Z7bJwhzjCJccGNiZMiOgFyGMmJOt3o4gxQuR7Wnty2VUpFRDlFtYsghGYgDZxQ/y8Z1atCDABDd4vLlaE0OVbSaA4AHoZ7VT8VWslyfWRD+aJSFGZ1QePco0gk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u7lekKag; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u7lekKag"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B124CC4CED1;
	Fri,  6 Dec 2024 15:07:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497628;
	bh=OvD3SQkegzLVJZcKkOWIRjhnt6GtWGgGsPhHrsiQPFo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u7lekKag173h3FQ4QjxDgO8Lkf3pzkiwZ/p9j6edBkVABejgGo0Sp0GKKxm4HiJiT
	 x9uu790TLO0LGGJ6wPXoj+PU/yZseweyvSuV2e1+npMRotB0YtGsOT55+4ev7r0Ch3
	 X6iEBM7YCFjZzA9/AUjf11gklT8uFirA7YvJRECk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 343/676] perf stat: Fix affinity memory leaks on error path
Date: Fri,  6 Dec 2024 15:32:42 +0100
Message-ID: <20241206143706.745540639@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 8bc526e1cb5f4..9692ebdd7f11e 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -823,6 +823,7 @@ static int __run_perf_stat(int argc, const char **argv, int run_idx)
 		}
 	}
 	affinity__cleanup(affinity);
+	affinity = NULL;
 
 	evlist__for_each_entry(evsel_list, counter) {
 		if (!counter->supported) {
@@ -961,6 +962,7 @@ static int __run_perf_stat(int argc, const char **argv, int run_idx)
 	if (forks)
 		evlist__cancel_workload(evsel_list);
 
+	affinity__cleanup(affinity);
 	return err;
 }
 
-- 
2.43.0



