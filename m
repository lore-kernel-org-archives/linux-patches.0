Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F39518B0A;
	Wed, 25 Feb 2026 01:34:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983240; cv=none; b=KDWSpPTkX106Cs2yFCBQXCX5w77ebrkLUPUvBRP04n+NrDmBG/cmEwRNEfZqz7FCJyJw+0GDoYMs09HXy/FWQ8ZbCXqPESPrki9h/Q179+bdkRBjuqVy8OucC1AOX+2y+Fv4z2/BSiqLUoqtIaH0SRmcOOGHmKmB2XhEc8ii1+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983240; c=relaxed/simple;
	bh=xo4qb5mJduFiu/eaGHN+pJfHGWJ8tyCfWSY1n4+GSXg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qY1b+Ul11RUGoAm7YjeiDSxN8t1b1mHrzru9aWRdSMdGQdz+aRQ1UgZIKFXFOB0Q81RGm0q+p/ftlnQMFDjHGDe7HYA565PzTY1cnI5JHX3GIVo/8JsaxkmTpZr8mY/wIbzpHMCi2p8MCsAQ0cnBqPtV9LRPRJJfzNlJNb5iRNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oHTl7DVe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oHTl7DVe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58F23C116D0;
	Wed, 25 Feb 2026 01:34:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983240;
	bh=xo4qb5mJduFiu/eaGHN+pJfHGWJ8tyCfWSY1n4+GSXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oHTl7DVe98EsEswKAn/nmbyBerP6UXGOuVej2hrW5AyGgX2KPzvaBvLO/HxGIpfbR
	 VcRnBIDvpRHtUII+GouhNr9vQQQ7VoUvrqvYituHTjBTkNWvVYBLRJdx2NSvvTa105
	 conT93E/uF4gMst/6D9d3dga5xU4go7uM1UFIE+o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	"David Hildenbrand (Red Hat)" <david@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Muhammad Usama Anjum <usama.anjum@arm.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	John Hubbard <jhubbard@nvidia.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Mark Brown <broonie@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	SeongJae Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	wang lian <lianux.mm@gmail.com>,
	Yunsheng Lin <linyunsheng@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 382/781] selftests/mm: fix faulting-in code in pagemap_ioctl test
Date: Tue, 24 Feb 2026 17:18:11 -0800
Message-ID: <20260225012409.064324173@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kevin Brodsky <kevin.brodsky@arm.com>

[ Upstream commit 7e938f00b00319510ae097e20b7487dfa578d53f ]

One of the pagemap_ioctl tests attempts to fault in pages by memcpy()'ing
them to an unused buffer.  This probably worked originally, but since
commit 46036188ea1f ("selftests/mm: build with -O2") the compiler is free
to optimise away that unused buffer and the memcpy() with it.  As a result
there might not be any resident page in the mapping and the test may fail.

We don't need to copy all that memory anyway.  Just fault in every page.

While at it also make sure to compute the number of pages once using
simple integer arithmetic instead of ceilf() and implicit conversions.

Link: https://lkml.kernel.org/r/20260122170224.4056513-8-kevin.brodsky@arm.com
Fixes: 46036188ea1f ("selftests/mm: build with -O2")
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: wang lian <lianux.mm@gmail.com>
Cc: Yunsheng Lin <linyunsheng@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/mm/pagemap_ioctl.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/mm/pagemap_ioctl.c b/tools/testing/selftests/mm/pagemap_ioctl.c
index 2cb5441f29c72..1896c7d4f72ee 100644
--- a/tools/testing/selftests/mm/pagemap_ioctl.c
+++ b/tools/testing/selftests/mm/pagemap_ioctl.c
@@ -1052,11 +1052,10 @@ static void test_simple(void)
 int sanity_tests(void)
 {
 	unsigned long long mem_size, vec_size;
-	long ret, fd, i, buf_size;
+	long ret, fd, i, buf_size, nr_pages;
 	struct page_region *vec;
 	char *mem, *fmem;
 	struct stat sbuf;
-	char *tmp_buf;
 
 	/* 1. wrong operation */
 	mem_size = 10 * page_size;
@@ -1167,14 +1166,14 @@ int sanity_tests(void)
 	if (fmem == MAP_FAILED)
 		ksft_exit_fail_msg("error nomem %d %s\n", errno, strerror(errno));
 
-	tmp_buf = malloc(sbuf.st_size);
-	memcpy(tmp_buf, fmem, sbuf.st_size);
+	nr_pages = (sbuf.st_size + page_size - 1) / page_size;
+	force_read_pages(fmem, nr_pages, page_size);
 
 	ret = pagemap_ioctl(fmem, sbuf.st_size, vec, vec_size, 0, 0,
 			    0, PAGEMAP_NON_WRITTEN_BITS, 0, PAGEMAP_NON_WRITTEN_BITS);
 
 	ksft_test_result(ret >= 0 && vec[0].start == (uintptr_t)fmem &&
-			 LEN(vec[0]) == ceilf((float)sbuf.st_size/page_size) &&
+			 LEN(vec[0]) == nr_pages &&
 			 (vec[0].categories & PAGE_IS_FILE),
 			 "%s Memory mapped file\n", __func__);
 
-- 
2.51.0



