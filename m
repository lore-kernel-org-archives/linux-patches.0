Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A09AA46D0BD;
	Tue, 21 Jul 2026 18:05:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657153; cv=none; b=ehfz53R23i4m8Q2MedZDFz18qWHMO2vpvimlIvYjpjg6nLANb3xiiK1gB+aPYiN4SeJmBBVku1+99t4VDMB0HPPSvxKJsCUrHFffZpf9ZLAH5Ii3THNoHwStFOmSoRWYAnLs7NXTVbJkcdfnJ6cFh9PJTMo1tWKI4nvszQv8oUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657153; c=relaxed/simple;
	bh=x3h9hiUeEr04pmiwZZG0HrYfCLDVymFmzLC8PQ9L3bI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bFE+mt5nNYhdDoThXuewcmG8AqXuTKWNj29gaEBjow9WnWI/af3vgNankXg9gBb4KMDMwmorZECVcKri+vgBgkIPuesI22PYBBcpFl4NucuQ5Jmgc9Bs9+25wU+6ivtxe3BrRoC4sU2aPbW4de8mOuXKxVtL7blEOqFvcpelnMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Em4cjn2d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Em4cjn2d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE7431F00A3A;
	Tue, 21 Jul 2026 18:05:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657152;
	bh=+0lO4Rw0tszIPPQrZm2OOb3OzfhvcEHvL/JbO7wOVwM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Em4cjn2dPAzzsfd1rPyES9c0SkMsx9hMa3qnrInUQiW7Tj7XVMLHUJdCHismGs9H7
	 9OK0Bqk7JX2RHf4QHIol/Uql1/ZIjw0WqnWCjsyA2Qu5CXhxl+j2hZ9OgwUn/4kOyV
	 KD2tkK/qTkktRaHr7lBOyGhoV2gH19oJDN23aJT0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Alexey Budankov <alexey.budankov@linux.intel.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0650/1611] perf mmap: Fix NULL deref in aio cleanup on alloc failure
Date: Tue, 21 Jul 2026 17:12:46 +0200
Message-ID: <20260721152530.010588066@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index ca897999189722..fcc09398468308 100644
--- a/tools/perf/util/mmap.c
+++ b/tools/perf/util/mmap.c
@@ -88,10 +88,10 @@ static int perf_mmap__aio_alloc(struct mmap *map, int idx)
 
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
@@ -140,6 +140,8 @@ static int perf_mmap__aio_alloc(struct mmap *map, int idx)
 
 static void perf_mmap__aio_free(struct mmap *map, int idx)
 {
+	if (!map->aio.data)
+		return;
 	zfree(&(map->aio.data[idx]));
 }
 
-- 
2.53.0



