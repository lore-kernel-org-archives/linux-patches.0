Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68AF42C11CD;
	Wed, 25 Feb 2026 06:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002591; cv=none; b=AL4ce8ElcDiHoRJ3rh+XWKpkOmIAYYHHAvZNF3U4lW/ZY+ESbZ+PJPY7N82sR/hfLtsV1b/wKWMmLRytrgKdM51NUekV5oeUWcaouzl3lnCeG6E2ReGzmC9ODRuYVw8QhV2LLM+osOcmY5G1mbqDmBHRtpV2xyELsTBCyXQNrH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002591; c=relaxed/simple;
	bh=BE4UXTqo3m1qPGPmYHtlmnaRPb0vzjcNVPzrgByLYVw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=COuWAxqEMlRk7zfx+EckAk+MuGEvq8yP1LSXzY3f6fcw4ohHraCwTRyfRWSrO9MkAQ7OkzfjI+wDd3e7YiD/pHTf2XqtBwA82fYmg0O/Y9ZWbsb2NtR8Vnh7N/Nu7uzheI+BYBnAbWtkuCVNwWp7RjzvmwzG0GYh4JD8PDMEIeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nlfEXc6D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nlfEXc6D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAD07C19425;
	Wed, 25 Feb 2026 06:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002591;
	bh=BE4UXTqo3m1qPGPmYHtlmnaRPb0vzjcNVPzrgByLYVw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nlfEXc6DOhErXI5uSdA182NFuIBNOiFPJlYJW66TweX5rLVPytEmREt3RAMQp7A2I
	 aNnUbMDN91Wb6FcojHWzc3Sh3SCM02qUhtpyf2iHSSfHoiJy1Q9loR69YuDyW36TNf
	 btxkL0DLOeIc3/N9g0b9DxY8nejMrgHtU4yX6QwU=
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
Subject: [PATCH 6.18 290/641] selftests/mm: fix faulting-in code in pagemap_ioctl test
Date: Tue, 24 Feb 2026 17:20:16 -0800
Message-ID: <20260225012355.783535810@linuxfoundation.org>
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
index 4fc8e578ec7c3..8978ab0b45a7a 100644
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



