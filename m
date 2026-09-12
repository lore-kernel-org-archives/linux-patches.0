Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7203979DA;
	Sat, 12 Sep 2026 08:29:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201746; cv=none; b=sooG2ZwLQ5+sLzqw/ibejqmmWqpVlaymbh9owMHl8u6Wji6TX7cd1njoOpoLkmEsMZrv1QADYbm+5qhiBXtQwEEO+1Z20hm/meDhGoqpIEW3WPxTklkc1UOJjL8EvrI10u720osNPU3YRxW1TAjhlL6WC1VBecikBWdmoxSionI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201746; c=relaxed/simple;
	bh=6XiX2Vdw3a69mD9b8UKf8X25G70DrksgleHJ/VfhAtY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=stlnAEWL3NEfZ+6fkeRGV8VNLT4ITxIkIG1KWUGI0zDtQMsIOTPn+ky6Qw/6ppRVDH/4wiLgKGcnbYpjQx/qZHFfLE36hhDXAvhOqWQlqg/GdAYlh6DcaWiIBQErC/woPlx2mota/ySfpjKrlKTVq7ZNQIAejYoe44mvsyO7dHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wsTSHK0e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wsTSHK0e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1272D1F000FF;
	Sat, 12 Sep 2026 08:29:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201745;
	bh=Oj3lszRdNVtIUxEeCG4kPYVzn0HpTRjL7ny8FKSktJE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wsTSHK0ey4geoTUO5ewbX65AyuyaNPwHtGoo6lxCzMIMsAuc3KP0QbdypWnHh62pp
	 wJdYImB7R3u7X2jO2v4/xqFDKWykJA8a7sMzGOXvl71MfoMim3mM8sDTF3BTE7fvdx
	 FbWgpkLEOesDASDApBslUUbHG+kIsjFAbuTJnrZE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongfu Li <lihongfu@kylinos.cn>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	SJ Park <sj@kernel.org>,
	Balbir Singh <balbirs@nvidia.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1060/1815] selftests/mm: fix memleak in migration benchmark
Date: Sat, 12 Sep 2026 08:46:50 +0200
Message-ID: <20260912065713.902717438@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hongfu Li <lihongfu@kylinos.cn>

[ Upstream commit f421d67d2c2367ca4b4b16f3a241a390b3ed501a ]

Several early return paths in run_migration_benchmark() skip
hmm_buffer_free(), leaking the buffer.  Replace with a single cleanup
label.

Link: https://lore.kernel.org/20260709081843.1451202-1-lihongfu@kylinos.cn
Fixes: 271a7b2e3c13 ("selftests/mm/hmm-tests: new throughput tests including THP")
Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: SJ Park <sj@kernel.org>
Acked-by: Balbir Singh <balbirs@nvidia.com>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Reviewed-by: Balbir Singh <balbirs@nvidia.com>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: Hongfu Li <lihongfu@kylinos.cn>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/mm/hmm-tests.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/mm/hmm-tests.c b/tools/testing/selftests/mm/hmm-tests.c
index 2f2b9879d1005..6fccbdab02ee8 100644
--- a/tools/testing/selftests/mm/hmm-tests.c
+++ b/tools/testing/selftests/mm/hmm-tests.c
@@ -2829,8 +2829,11 @@ static inline int run_migration_benchmark(int fd, int use_thp, size_t buffer_siz
 	buffer->ptr = mmap(NULL, buffer_size, PROT_READ | PROT_WRITE,
 			  MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
 
-	if (buffer->ptr == MAP_FAILED)
-		return -1;
+	if (buffer->ptr == MAP_FAILED) {
+		buffer->ptr = NULL;
+		ret = -1;
+		goto cleanup;
+	}
 
 	/* Apply THP hint if requested */
 	if (use_thp)
@@ -2839,7 +2842,7 @@ static inline int run_migration_benchmark(int fd, int use_thp, size_t buffer_siz
 		ret = madvise(buffer->ptr, buffer_size, MADV_NOHUGEPAGE);
 
 	if (ret)
-		return ret;
+		goto cleanup;
 
 	/* Initialize memory to make sure pages are allocated */
 	ptr = (int *)buffer->ptr;
@@ -2849,11 +2852,11 @@ static inline int run_migration_benchmark(int fd, int use_thp, size_t buffer_siz
 	/* Warmup iteration */
 	ret = hmm_migrate_sys_to_dev(fd, buffer, npages);
 	if (ret)
-		return ret;
+		goto cleanup;
 
 	ret = hmm_migrate_dev_to_sys(fd, buffer, npages);
 	if (ret)
-		return ret;
+		goto cleanup;
 
 	/* Benchmark iterations */
 	for (i = 0; i < iterations; i++) {
@@ -2862,7 +2865,7 @@ static inline int run_migration_benchmark(int fd, int use_thp, size_t buffer_siz
 
 		ret = hmm_migrate_sys_to_dev(fd, buffer, npages);
 		if (ret)
-			return ret;
+			goto cleanup;
 
 		end = get_time_ms();
 		s2d_total += (end - start);
@@ -2872,7 +2875,7 @@ static inline int run_migration_benchmark(int fd, int use_thp, size_t buffer_siz
 
 		ret = hmm_migrate_dev_to_sys(fd, buffer, npages);
 		if (ret)
-			return ret;
+			goto cleanup;
 
 		end = get_time_ms();
 		d2s_total += (end - start);
@@ -2886,9 +2889,9 @@ static inline int run_migration_benchmark(int fd, int use_thp, size_t buffer_siz
 	results->throughput_d2s = (buffer_size / (1024.0 * 1024.0 * 1024.0)) /
 				 (results->dev_to_sys_time / 1000.0);
 
-	/* Cleanup */
+cleanup:
 	hmm_buffer_free(buffer);
-	return 0;
+	return ret;
 }
 
 /*
-- 
2.53.0



