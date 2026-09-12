Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0518A3909A4;
	Sat, 12 Sep 2026 19:56:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242969; cv=none; b=bSG9h8fj9U1zrqwzfbG7h4yrusK3GAqSh7rc36MbevoSiU8CsjekEMu3ufqS35azB8UehFIPAcwoeFWrWpth6iuvV2oE0Z3WXg0Q2yYv1ZhLyIYD/05idcsXmBjQIv9KGqI+M30nuvcr726qZ9kA9DLkK6oASVV1Zp73uY/3Wd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242969; c=relaxed/simple;
	bh=ntoLZI3QGn4DK1KNvYAM7NQrjz6q79pmtkR/UfoUvZ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fn+l61rmPAacHjh4ltuyYYtxZ6XUt8rmSabJ5fOhGxJpVmruG2aPhcsxOJN8haWE5h8x2fBEu8VhASdRNI3nXi1vfAZtsPyl6VRnQXE+GebRD8Db3redtqxhgajB8i/w0aiMmh8iHKV3ZvQ4cq8NkOmfB7H53ttaw8kXi5aEVXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J52ogngA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J52ogngA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DDFC1F00893;
	Sat, 12 Sep 2026 19:56:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242961;
	bh=AiyLFBQUI/sJnzG9Hs6xeo/6u1W1B5aPJaAS5tCMkVQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J52ogngA1BWWx3LjK0zqvRdGhho7kj5eUTDfbBf5Wo0Qo1BsXNQevSd2XF8GA2hdZ
	 p8BVvKaeSOiY6bbJ7VlWaKmcE74bMkyjs8NuExWHcYLoVzcCc8QE7k+e4CGBxGprbX
	 5HQMRXPDcOKLrKuSgKcIguzKudbdv64Cv0vaQvII=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	James Clark <james.clark@linaro.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 587/798] perf auxtrace: Fix queue grow overflow and old array leak
Date: Sat, 12 Sep 2026 09:03:35 +0200
Message-ID: <20260912065530.578987005@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 96fcc9ea5f18c083a1fa73da23afef7e953f7dca ]

auxtrace_queues__grow() has two bugs:

1. When idx is UINT_MAX, the caller passes new_nr_queues = idx + 1 = 0.
   The function skips growing (since any nr_queues >= 0), returns
   success, and the caller accesses queue_array[UINT_MAX] — an OOB
   heap write.  Fix by rejecting new_nr_queues == 0 up front.

2. The function allocates a new queue_array via calloc and copies
   elements from the old array, but never frees the old array.  Fix
   by saving the old pointer and freeing it after the copy.

Fixes: e502789302a6ece9 ("perf auxtrace: Add helpers for queuing AUX area tracing data")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Reviewed-by: James Clark <james.clark@linaro.org>
Reviewed-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/auxtrace.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/tools/perf/util/auxtrace.c b/tools/perf/util/auxtrace.c
index 41dd4c266cc00..0d71c0a74f964 100644
--- a/tools/perf/util/auxtrace.c
+++ b/tools/perf/util/auxtrace.c
@@ -229,8 +229,12 @@ static int auxtrace_queues__grow(struct auxtrace_queues *queues,
 {
 	unsigned int nr_queues = queues->nr_queues;
 	struct auxtrace_queue *queue_array;
+	struct auxtrace_queue *old_array = queues->queue_array;
 	unsigned int i;
 
+	if (!new_nr_queues)
+		return -EINVAL;
+
 	if (!nr_queues)
 		nr_queues = AUXTRACE_INIT_NR_QUEUES;
 
@@ -245,16 +249,17 @@ static int auxtrace_queues__grow(struct auxtrace_queues *queues,
 		return -ENOMEM;
 
 	for (i = 0; i < queues->nr_queues; i++) {
-		list_splice_tail(&queues->queue_array[i].head,
+		list_splice_tail(&old_array[i].head,
 				 &queue_array[i].head);
-		queue_array[i].tid = queues->queue_array[i].tid;
-		queue_array[i].cpu = queues->queue_array[i].cpu;
-		queue_array[i].set = queues->queue_array[i].set;
-		queue_array[i].priv = queues->queue_array[i].priv;
+		queue_array[i].tid = old_array[i].tid;
+		queue_array[i].cpu = old_array[i].cpu;
+		queue_array[i].set = old_array[i].set;
+		queue_array[i].priv = old_array[i].priv;
 	}
 
 	queues->nr_queues = nr_queues;
 	queues->queue_array = queue_array;
+	free(old_array);
 
 	return 0;
 }
-- 
2.53.0



