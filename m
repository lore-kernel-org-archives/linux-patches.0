Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A67419E966;
	Wed, 23 Apr 2025 14:52:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745419921; cv=none; b=JvAMJ2li0nPRkaKJf5qUd3DjlTJU68kYFcCQ1WtHrqpl0u9EFAd3ST/P3T5Ad+yHJV+jNf6IijfAdPRGdxTN4ZV1RclGnVVqo5rRQQuAmbYXxto+P3UEeI876HXTiI7wizXNqzjvVXNKGIP1/FrylkwR3h3IHYM4eeRZ/KgV8oA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745419921; c=relaxed/simple;
	bh=KVzYnKDglhntuzzI9HTX5wqUBwp9+o2M+E030Ki1+5Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mcNP/JKI3mvgpH3IDsO9PEbHK4k+RMGiKbeGb6+VOGgpf9Bcum21467nZabYk42LmvNXq9FhOQxpGsOTbxd05bmxuszL5M6IYQifH9xJuPseILx4wmVHGM4sv67FRviDqrchJhAc6kYBLbsUrUWWlFqh6ohLXwtQbgaq48Jxeng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bFPdlTVF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bFPdlTVF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20717C4CEE2;
	Wed, 23 Apr 2025 14:52:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745419921;
	bh=KVzYnKDglhntuzzI9HTX5wqUBwp9+o2M+E030Ki1+5Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bFPdlTVFDXwfFCJHtjiDWSqbZtCzNYAXNPIcYZZtEFIaS7uHfSKyL4NesryFXzOX1
	 DLEqCsEyC8P9B3Cwm6dNelg1KYR0WAJkcUJWiJWvdUCuYtMHWxhDMv0o2hVk3CjpZG
	 VdkSKthefWYNZWFRKTcmNuK8YmoNLZMFpAFh+6U8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Zi Yan <ziy@nvidia.com>,
	David Hildenbrand <david@redhat.com>,
	Barry Song <21cnbao@gmail.com>,
	Hugh Dickins <hughd@google.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 043/241] selftests: mincore: fix tmpfs mincore test failure
Date: Wed, 23 Apr 2025 16:41:47 +0200
Message-ID: <20250423142622.267613046@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baolin Wang <baolin.wang@linux.alibaba.com>

[ Upstream commit 8c583e538aa681ecb293d5606054de70f44b5558 ]

When running mincore test cases, I encountered the following failures:

"
mincore_selftest.c:359:check_tmpfs_mmap:Expected ra_pages (511) == 0 (0)
mincore_selftest.c:360:check_tmpfs_mmap:Read-ahead pages found in memory
check_tmpfs_mmap: Test terminated by assertion
          FAIL  global.check_tmpfs_mmap
not ok 5 global.check_tmpfs_mmap
FAILED: 4 / 5 tests passed
"

The reason for the test case failure is that my system automatically enabled
tmpfs large folio allocation by adding the 'transparent_hugepage_tmpfs=always'
cmdline. However, the test case still expects the tmpfs mounted on /dev/shm to
allocate small folios, which leads to assertion failures when verifying readahead
pages.

As discussed with David, there's no reason to continue checking the readahead
logic for tmpfs. Drop it to fix this issue.

Link: https://lkml.kernel.org/r/9a00856cc6a8b4e46f4ab8b1af11ce5fc1a31851.1744025467.git.baolin.wang@linux.alibaba.com
Fixes: d635ccdb435c ("mm: shmem: add a kernel command line to change the default huge policy for tmpfs")
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Barry Song <21cnbao@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../testing/selftests/mincore/mincore_selftest.c | 16 ++--------------
 1 file changed, 2 insertions(+), 14 deletions(-)

diff --git a/tools/testing/selftests/mincore/mincore_selftest.c b/tools/testing/selftests/mincore/mincore_selftest.c
index e949a43a61450..0fd4b00bd345b 100644
--- a/tools/testing/selftests/mincore/mincore_selftest.c
+++ b/tools/testing/selftests/mincore/mincore_selftest.c
@@ -286,8 +286,7 @@ TEST(check_file_mmap)
 
 /*
  * Test mincore() behavior on a page backed by a tmpfs file.  This test
- * performs the same steps as the previous one. However, we don't expect
- * any readahead in this case.
+ * performs the same steps as the previous one.
  */
 TEST(check_tmpfs_mmap)
 {
@@ -298,7 +297,6 @@ TEST(check_tmpfs_mmap)
 	int page_size;
 	int fd;
 	int i;
-	int ra_pages = 0;
 
 	page_size = sysconf(_SC_PAGESIZE);
 	vec_size = FILE_SIZE / page_size;
@@ -341,8 +339,7 @@ TEST(check_tmpfs_mmap)
 	}
 
 	/*
-	 * Touch a page in the middle of the mapping. We expect only
-	 * that page to be fetched into memory.
+	 * Touch a page in the middle of the mapping.
 	 */
 	addr[FILE_SIZE / 2] = 1;
 	retval = mincore(addr, FILE_SIZE, vec);
@@ -351,15 +348,6 @@ TEST(check_tmpfs_mmap)
 		TH_LOG("Page not found in memory after use");
 	}
 
-	i = FILE_SIZE / 2 / page_size + 1;
-	while (i < vec_size && vec[i]) {
-		ra_pages++;
-		i++;
-	}
-	ASSERT_EQ(ra_pages, 0) {
-		TH_LOG("Read-ahead pages found in memory");
-	}
-
 	munmap(addr, FILE_SIZE);
 	close(fd);
 	free(vec);
-- 
2.39.5



