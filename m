Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0578C427A04;
	Sat, 12 Sep 2026 10:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209591; cv=none; b=hf3bnP7fWyRwnQudmTV72/69lxQHKR3S9S9SEJNb+8/6URm0k6tpT1bHSeinkgbseeUBl+FU9H1ehujWPW5FfTRmi/UpN4GaJEjtvFlimBYQhq5PxFahbMLwEy7eALEGJE1L4jbH9qchxVfRSRdzsZGXQqr5YVNawsSpIOhI0Po=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209591; c=relaxed/simple;
	bh=QeFd2pq8lVWkSbP41iO96OtDiVzrPUxtl780asLDYdg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Y+LNLT3m2dErgjExcDwT4VMfhATH/P3UgvLT+W1JzCQj4gMDzaxyw0kQyZTUVzetGxjmH+sKEJL75hf2LmDtLfduVb2QBNZpTgqC3BgER5czokEy4WSKFD4jiPGGnatS1UKY9XsA3I+I4OzTfabv2Q+M4ISwHb6wffCpkaivmLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vCViWT2o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vCViWT2o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D776B1F00893;
	Sat, 12 Sep 2026 10:39:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209585;
	bh=WiDmFf9OpqpaT0H5MVSKpVoQnE7M6B1yLkGwk+4mzDY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vCViWT2oajPJYHAdTnwlPNHtBj9W+uD2+vxJ4DemRbtc7QkdTwIe/QOE/wZHIrmNg
	 F0Ro5XTHEk64nhCpRnZIb2QTEbXsW+O2eLe3PdyMjzlzQU7ePace8QKz0p4diJ6fdn
	 80sgw8U4w8R/fz9Nr0EZsP2dlYOPmEbI6xuPS09I=
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
Subject: [PATCH 6.18 0851/1518] perf auxtrace: Fix queue grow overflow and old array leak
Date: Sat, 12 Sep 2026 08:50:20 +0200
Message-ID: <20260912065642.700092797@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 1539c1dc823c2..1749359aa9a20 100644
--- a/tools/perf/util/auxtrace.c
+++ b/tools/perf/util/auxtrace.c
@@ -235,8 +235,12 @@ static int auxtrace_queues__grow(struct auxtrace_queues *queues,
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
 
@@ -251,16 +255,17 @@ static int auxtrace_queues__grow(struct auxtrace_queues *queues,
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



