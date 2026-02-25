Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D7E72C11CD;
	Wed, 25 Feb 2026 06:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002590; cv=none; b=Cca4jHxC4zrhCZmF6D1BsUHy59xc4+DOwIYTeCGxY+oLe61ldNrZ4QxUrSSmXIFf0Xv/Pbn3sV1xjv2Q9qSQFTK3e+dBjhtcX5YJ3jxaQ0tWa07lLlxas/iEUlGyC6wDr8lws4V/aKui6/4Svs3zAIqOghrMaacWp90Xg/uDO5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002590; c=relaxed/simple;
	bh=QaUz472YFqoyzbQdqYZAbiLr7gv6kV87w5Gu1g2Z5+Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kx/ZqXdWN3wl1iJb9vJcwquw//6aFcP9lpKuAlp1cZHZkiI2xnwJyzHN0wSStSmiGFaomyazI6/u9S+qMxRJQh9YoHgxykwmA6RwCyJRzLbGSfhHuH3xVMx10XjS2kBUg/BaDwBt/6w5RCG3iYnc1Qdxso3m70XkhXs/nj5BqYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VKHtNRkc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VKHtNRkc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35DFEC19422;
	Wed, 25 Feb 2026 06:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002590;
	bh=QaUz472YFqoyzbQdqYZAbiLr7gv6kV87w5Gu1g2Z5+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VKHtNRkcFvFmXmcl8FbwnkkIGHbdLWeAtuOo08wfsRf4bnFqHCRszGSlhVVoPNXhB
	 RV+n7FyZctdvYSi9kjegYsytx/as3sRJksKPILOrpm/ea+XoCibkAmXnSwy9NBDkND
	 UCPKswFaAN/9t4Mmspm6+am1DEqjHLltdwe+iah8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	SeongJae Park <sj@kernel.org>,
	wang lian <lianux.mm@gmail.com>,
	"David Hildenbrand (Red Hat)" <david@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	John Hubbard <jhubbard@nvidia.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Mark Brown <broonie@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Usama Anjum <Usama.Anjum@arm.com>,
	Yunsheng Lin <linyunsheng@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 289/641] selftests/mm: fix usage of FORCE_READ() in cow tests
Date: Tue, 24 Feb 2026 17:20:15 -0800
Message-ID: <20260225012355.761514909@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

From: Kevin Brodsky <kevin.brodsky@arm.com>

[ Upstream commit bce1dabd310e87fefe0645fec9ba98b84d37e418 ]

Commit 5bbc2b785e63 ("selftests/mm: fix FORCE_READ to read input value
correctly") modified FORCE_READ() to take a value instead of a pointer.
It also changed most of the call sites accordingly, but missed many of
them in cow.c.  In those cases, we ended up with the pointer itself being
read, not the memory it points to.

No failure occurred as a result, so it looks like the tests work just fine
without faulting in.  However, the huge_zeropage tests explicitly check
that pages are populated, so those became skipped.

Convert all the remaining FORCE_READ() to fault in the mapped page, as was
originally intended.  This allows the huge_zeropage tests to run again (3
tests in total).

Link: https://lkml.kernel.org/r/20260122170224.4056513-5-kevin.brodsky@arm.com
Fixes: 5bbc2b785e63 ("selftests/mm: fix FORCE_READ to read input value correctly")
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
Acked-by: SeongJae Park <sj@kernel.org>
Reviewed-by: wang lian <lianux.mm@gmail.com>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Usama Anjum <Usama.Anjum@arm.com>
Cc: Yunsheng Lin <linyunsheng@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/mm/cow.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/mm/cow.c b/tools/testing/selftests/mm/cow.c
index 6560c26f47d1f..0df61422467da 100644
--- a/tools/testing/selftests/mm/cow.c
+++ b/tools/testing/selftests/mm/cow.c
@@ -1612,8 +1612,8 @@ static void run_with_huge_zeropage(non_anon_test_fn fn, const char *desc)
 	 * the first sub-page and test if we get another sub-page populated
 	 * automatically.
 	 */
-	FORCE_READ(mem);
-	FORCE_READ(smem);
+	FORCE_READ(*mem);
+	FORCE_READ(*smem);
 	if (!pagemap_is_populated(pagemap_fd, mem + pagesize) ||
 	    !pagemap_is_populated(pagemap_fd, smem + pagesize)) {
 		ksft_test_result_skip("Did not get THPs populated\n");
@@ -1663,8 +1663,8 @@ static void run_with_memfd(non_anon_test_fn fn, const char *desc)
 	}
 
 	/* Fault the page in. */
-	FORCE_READ(mem);
-	FORCE_READ(smem);
+	FORCE_READ(*mem);
+	FORCE_READ(*smem);
 
 	fn(mem, smem, pagesize);
 munmap:
@@ -1719,8 +1719,8 @@ static void run_with_tmpfile(non_anon_test_fn fn, const char *desc)
 	}
 
 	/* Fault the page in. */
-	FORCE_READ(mem);
-	FORCE_READ(smem);
+	FORCE_READ(*mem);
+	FORCE_READ(*smem);
 
 	fn(mem, smem, pagesize);
 munmap:
@@ -1773,8 +1773,8 @@ static void run_with_memfd_hugetlb(non_anon_test_fn fn, const char *desc,
 	}
 
 	/* Fault the page in. */
-	FORCE_READ(mem);
-	FORCE_READ(smem);
+	FORCE_READ(*mem);
+	FORCE_READ(*smem);
 
 	fn(mem, smem, hugetlbsize);
 munmap:
-- 
2.51.0



