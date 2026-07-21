Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6701C46D2DF;
	Tue, 21 Jul 2026 18:59:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660357; cv=none; b=dcLdSHlzbJs39fTzgv8/fyKwBLPTFCWugH0xD46Buk+2MIgt2iWNNKBZQz7V8BVPdYfiIIKVUB4BU6+f9q6Utl/0Cwfl2YfWYsUnvI5mGfhkg6HYynxFMSmTi9d1KDWsAEGXdqMm8dw+ATT9sF7Mh8PW6esTIIRDOYM7bKhi5no=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660357; c=relaxed/simple;
	bh=rzR3Q9AEoxjbL4tAiIIR/sFdo0VswKKGWbjR2hs6DxE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rGlyTCfgkKg18pKSxAHnGh1QymzfpLmFMiN47Op+SILZLxYbMCH055ewPnwSjBZ1HogTfAWruaJxRSdxtHkvkKSHqLkihd/V3GUCB2pY557bsD17DSwbblxKBLMWf7VVU9SJgVRmlmGYnRcH8LVt0SSJzl9aCSTu5q14xKjLs6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b/UOzbsp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b/UOzbsp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2B501F000E9;
	Tue, 21 Jul 2026 18:59:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660356;
	bh=baknpDd3ZNs9SFEQOKtDA3RbjF1FYSUuEvGALCQCRo0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b/UOzbspfDICpIBX5F9+J8NvB834+gXPPgbrnkacacbtQAHaC2Ae/ApMz6oUOtfHL
	 VqHl3V5SMffDQwTnte8wNdi/ccnDoYvP8cp387/GzecQ4SQ0UH1D7xxDo/OIVq37vi
	 sw/mVResn1DLXl47/XFnpLXU8MAeVxEBM5Wggvf8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Alexey Budankov <alexey.budankov@linux.intel.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0948/2077] perf mmap: Fix NULL deref in aio cleanup on alloc failure
Date: Tue, 21 Jul 2026 17:10:21 +0200
Message-ID: <20260721152615.178242455@linuxfoundation.org>
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

[ Upstream commit 25627346b10e6a564610ea2c49dc6dd54812226d ]

perf_mmap__aio_mmap() sets map->aio.nr_cblocks before allocating the
data array.  If calloc() for aiocb or cblocks fails before the data
array is allocated, the return -1 path leads to perf_mmap__aio_munmap()
which loops nr_cblocks times calling perf_mmap__aio_free().  Both
versions of perf_mmap__aio_free() (NUMA and non-NUMA) dereference
map->aio.data[idx] without checking if data is NULL, causing a NULL
pointer dereference.

Add NULL checks for map->aio.data at the top of both
perf_mmap__aio_free() variants so the cleanup path is safe when
allocation fails partway through perf_mmap__aio_mmap().

Fixes: d3d1af6f011a553a ("perf record: Enable asynchronous trace writing")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Cc: Alexey Budankov <alexey.budankov@linux.intel.com>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/mmap.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/mmap.c b/tools/perf/util/mmap.c
index 4404a99eee45f9..d64aec6c7c843e 100644
--- a/tools/perf/util/mmap.c
+++ b/tools/perf/util/mmap.c
@@ -89,10 +89,10 @@ static int perf_mmap__aio_alloc(struct mmap *map, int idx)
 
 static void perf_mmap__aio_free(struct mmap *map, int idx)
 {
-	if (map->aio.data[idx]) {
-		munmap(map->aio.data[idx], mmap__mmap_len(map));
-		map->aio.data[idx] = NULL;
-	}
+	if (!map->aio.data || !map->aio.data[idx])
+		return;
+	munmap(map->aio.data[idx], mmap__mmap_len(map));
+	map->aio.data[idx] = NULL;
 }
 
 static int perf_mmap__aio_bind(struct mmap *map, int idx, struct perf_cpu cpu, int affinity)
@@ -141,6 +141,8 @@ static int perf_mmap__aio_alloc(struct mmap *map, int idx)
 
 static void perf_mmap__aio_free(struct mmap *map, int idx)
 {
+	if (!map->aio.data)
+		return;
 	zfree(&(map->aio.data[idx]));
 }
 
-- 
2.53.0



