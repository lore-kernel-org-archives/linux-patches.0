Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A059D35DA40;
	Tue, 21 Jul 2026 19:35:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662510; cv=none; b=SQSFOZBZ3RwCeZ8zcl9l8U2i4rMAsRVpH+drYK6LHkOpVx63TI/1Jqob+nmpYIwVqBS7oogMKKJcnnM+L6Z7qn+Bc9YMfscDUp14ZbAFBrCE78jyMN2Vch8RT3vz3STA6e047GlJXbiHXcTXz28RqlajKUl220/3Cljkck9/HCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662510; c=relaxed/simple;
	bh=tDfYpepefeBZsmmYd0x7fzNlA5uGV0d3LUV1uvScK+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RzYF3aZ9zp6/cI99Ie3nVXhXTYbaaIayY7N6D5hxk/heYKxWNS7609UtXsibKVhW/Il1uRD7dqE9Sd9o/P4mDOkVIQNVcm8IyF+AwkxLxfpnHTgT1oYuMGd2ZFek0SNhIfM9546zH7oeDDLTcmT0105f9hsMlug0XFkfKGqhyCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jWvo2TgX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jWvo2TgX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1136F1F000E9;
	Tue, 21 Jul 2026 19:35:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662509;
	bh=44L4C6ItpN6Dy9TNZPw2k/lM7n0NaZDVaNuj8N6EK6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jWvo2TgXqD92heHGyXyJzKKCFlFd8rg192toXuYhwevro9RcTVTyrhSa9XBq1KbMJ
	 6/iLxLax0QXg4BgqaXc27wyzNe0jg7OdkJ0lUrU4jl5M1ErK2boa1wSWMBke9YX8QR
	 Cl4+pxUeXMZ1phHLeWS6Tq/hNycup3oIMediNMv8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Alexey Budankov <alexey.budankov@linux.intel.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0473/1276] perf mmap: Fix NULL deref in aio cleanup on alloc failure
Date: Tue, 21 Jul 2026 17:15:16 +0200
Message-ID: <20260721152456.690571832@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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
index 5d2685d9ab4ea6..d011968c031c03 100644
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



