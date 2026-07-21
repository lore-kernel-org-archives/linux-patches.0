Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0C5546D2BF;
	Tue, 21 Jul 2026 19:01:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660489; cv=none; b=tLRWMDQipTNjlWYkCLcsRvg6W+2Q0tA1DVF0LBaApmAQvEmljVEfUcyW3+8dFt0R9e0qGWhxoRcRAXR+oLCgW9lwO4Fb1vFykrtJg6HhR9eSmVqltsdRT25putWhviGu9gIK144EiR5b6zl6/0PBOHCiId4a1JXIotL5Hm2EC3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660489; c=relaxed/simple;
	bh=+CIHdQm+7P4hXcEvSlUZTQZftjHSmgSMLtrJFdbbf+k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hwozJ2AP1sSbguql+b2DvYO65BX8UbnKSZa/RtMlWwSJQfQSI1FclDjy4VPPzZ4IXNire9d4L6ks3YDqWPquMBik7RrqyjKqBvLovJPPqW6V/QGVqanGyVSGRyeQHEHJ/t4G1jr/7pgansBVsQCuDkjHG27Kk9gcyia5al/7dLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HReM3FlR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HReM3FlR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B520D1F00ADE;
	Tue, 21 Jul 2026 19:00:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660449;
	bh=in3P0Jg8fDPhsdHN5gx0GjVUdaQZpEkkMit6k+PfhMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HReM3FlRwYcrSieiOjrHcPABj/On1qLIPijSiEBgT94llOB10THgf3nn2l33ArnWv
	 aFMVIMyCfQyMYLBFpz1oRigct4IMuzKby3LHt3NrsKZP3IKX1479xX6zZHF6tEcWCH
	 acqRAx+VXtR3FYAXYDRnvLUlbpilP/TCTl5kKA+s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Alexey Budankov <alexey.budankov@linux.intel.com>,
	Alexey Bayduraev <alexey.v.bayduraev@linux.intel.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0984/2077] perf tools: NULL bitmap pointers after bitmap_free()
Date: Tue, 21 Jul 2026 17:10:57 +0200
Message-ID: <20260721152616.026552017@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit a9e900bc5c5914aca750afafa459363e575d3046 ]

Two call sites free bitmaps without NULLing the pointer, risking
double-free if the structure is reused or cleanup is called twice:

 - mmap__munmap():                 map->affinity_mask.bits
 - record__mmap_cpu_mask_free():   mask->bits

Set each pointer to NULL after bitmap_free().

Fixes: 8384a2600c7ddfc8 ("perf record: Adapt affinity to machines with #CPUs > 1K")
Fixes: f466e5ed6c356d1d ("perf record: Extend --threads command line option")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Reviewed-by: Ian Rogers <irogers@google.com>
Cc: Alexey Budankov <alexey.budankov@linux.intel.com>
Cc: Alexey Bayduraev <alexey.v.bayduraev@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-record.c | 1 +
 tools/perf/util/mmap.c      | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 708825747af5da..1593cf3a834bda 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -3080,6 +3080,7 @@ static int record__mmap_cpu_mask_alloc(struct mmap_cpu_mask *mask, int nr_bits)
 static void record__mmap_cpu_mask_free(struct mmap_cpu_mask *mask)
 {
 	bitmap_free(mask->bits);
+	mask->bits = NULL;
 	mask->nbits = 0;
 }
 
diff --git a/tools/perf/util/mmap.c b/tools/perf/util/mmap.c
index d64aec6c7c843e..358e70c4f3edd0 100644
--- a/tools/perf/util/mmap.c
+++ b/tools/perf/util/mmap.c
@@ -238,6 +238,8 @@ static void perf_mmap__aio_munmap(struct mmap *map __maybe_unused)
 void mmap__munmap(struct mmap *map)
 {
 	bitmap_free(map->affinity_mask.bits);
+	map->affinity_mask.bits = NULL;
+	map->affinity_mask.nbits = 0;
 
 	zstd_fini(&map->zstd_data);
 
-- 
2.53.0



