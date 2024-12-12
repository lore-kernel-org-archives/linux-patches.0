Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9C3A21CFEA;
	Thu, 12 Dec 2024 16:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734021492; cv=none; b=o6VXHBD6bLD5RAP2Eo9yu7C4A37rZ5XnN1GFsbN/9HwHxowERqL3o4JRzPzG9d1GgjiDz8VyQr+HmSY9WRXNdiXkOBpTV+HHf/9hWK+saBimW2L3s4O+aR5ACN8xEzxIHmoNnz1+Swoo6AtVnyAXg3m/eDsWxDztTR5NgCRU2bA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734021492; c=relaxed/simple;
	bh=G/4Uy06nuy2TJZSwlNeSS3RTXkJTQ3d9vvlZaPQpXjY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cb4hsM/4c+IKkOanc4Mw/5fmaZAfdTteTzTDcEz5J2RzTMqlnYLnWPsSCik9A3J8B7FMZOo40Xw7JG3iNgNYYaZlTAtqSHdqVeWqWvdEHwcKIujUWhlFUmoWdJQKkH++0U2BajvpOxjHKiFmzk6VZL7W//a+wOkcYs5wdtoNvko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PXzPKgji; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PXzPKgji"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E93EC4CED3;
	Thu, 12 Dec 2024 16:38:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734021492;
	bh=G/4Uy06nuy2TJZSwlNeSS3RTXkJTQ3d9vvlZaPQpXjY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PXzPKgji8aTU2CsmH+x6B8yO1M2hnwJpsXEzKddTOJ/2dTRj2b7xU2wBlHFddL78r
	 wuaZqSt6dkGFju3NPD2Z95z9jTknOMEovTR6O9PCom3gf8sIo7v4YU5A8LFyx4w8O6
	 bIdEaYPIQerSasir2hSihrfb6wM4dVJVCkZfVrjI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zheng Yejian <zhengyejian@huaweicloud.com>,
	SeongJae Park <sj@kernel.org>,
	Fernand Sieber <sieberf@amazon.com>,
	Leonard Foerster <foersleo@amazon.de>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Ye Weihua <yeweihua4@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 745/772] mm/damon/vaddr: fix issue in damon_va_evenly_split_region()
Date: Thu, 12 Dec 2024 16:01:30 +0100
Message-ID: <20241212144420.719417717@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zheng Yejian <zhengyejian@huaweicloud.com>

commit f3c7a1ede435e2e45177d7a490a85fb0a0ec96d1 upstream.

Patch series "mm/damon/vaddr: Fix issue in
damon_va_evenly_split_region()".  v2.

According to the logic of damon_va_evenly_split_region(), currently
following split case would not meet the expectation:

  Suppose DAMON_MIN_REGION=0x1000,
  Case: Split [0x0, 0x3000) into 2 pieces, then the result would be
        acutually 3 regions:
          [0x0, 0x1000), [0x1000, 0x2000), [0x2000, 0x3000)
        but NOT the expected 2 regions:
          [0x0, 0x1000), [0x1000, 0x3000) !!!

The root cause is that when calculating size of each split piece in
damon_va_evenly_split_region():

  `sz_piece = ALIGN_DOWN(sz_orig / nr_pieces, DAMON_MIN_REGION);`

both the dividing and the ALIGN_DOWN may cause loss of precision, then
each time split one piece of size 'sz_piece' from origin 'start' to 'end'
would cause more pieces are split out than expected!!!

To fix it, count for each piece split and make sure no more than
'nr_pieces'.  In addition, add above case into damon_test_split_evenly().

And add 'nr_piece == 1' check in damon_va_evenly_split_region() for better
code readability and add a corresponding kunit testcase.


This patch (of 2):

According to the logic of damon_va_evenly_split_region(), currently
following split case would not meet the expectation:

  Suppose DAMON_MIN_REGION=0x1000,
  Case: Split [0x0, 0x3000) into 2 pieces, then the result would be
        acutually 3 regions:
          [0x0, 0x1000), [0x1000, 0x2000), [0x2000, 0x3000)
        but NOT the expected 2 regions:
          [0x0, 0x1000), [0x1000, 0x3000) !!!

The root cause is that when calculating size of each split piece in
damon_va_evenly_split_region():

  `sz_piece = ALIGN_DOWN(sz_orig / nr_pieces, DAMON_MIN_REGION);`

both the dividing and the ALIGN_DOWN may cause loss of precision,
then each time split one piece of size 'sz_piece' from origin 'start' to
'end' would cause more pieces are split out than expected!!!

To fix it, count for each piece split and make sure no more than
'nr_pieces'. In addition, add above case into damon_test_split_evenly().

After this patch, damon-operations test passed:

 # ./tools/testing/kunit/kunit.py run damon-operations
 [...]
 ============== damon-operations (6 subtests) ===============
 [PASSED] damon_test_three_regions_in_vmas
 [PASSED] damon_test_apply_three_regions1
 [PASSED] damon_test_apply_three_regions2
 [PASSED] damon_test_apply_three_regions3
 [PASSED] damon_test_apply_three_regions4
 [PASSED] damon_test_split_evenly
 ================ [PASSED] damon-operations =================

Link: https://lkml.kernel.org/r/20241022083927.3592237-1-zhengyejian@huaweicloud.com
Link: https://lkml.kernel.org/r/20241022083927.3592237-2-zhengyejian@huaweicloud.com
Fixes: 3f49584b262c ("mm/damon: implement primitives for the virtual memory address spaces")
Signed-off-by: Zheng Yejian <zhengyejian@huaweicloud.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: Fernand Sieber <sieberf@amazon.com>
Cc: Leonard Foerster <foersleo@amazon.de>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Ye Weihua <yeweihua4@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/vaddr-test.h |    1 +
 mm/damon/vaddr.c      |    4 ++--
 2 files changed, 3 insertions(+), 2 deletions(-)

--- a/mm/damon/vaddr-test.h
+++ b/mm/damon/vaddr-test.h
@@ -292,6 +292,7 @@ static void damon_test_split_evenly(stru
 	damon_test_split_evenly_fail(test, 0, 100, 0);
 	damon_test_split_evenly_succ(test, 0, 100, 10);
 	damon_test_split_evenly_succ(test, 5, 59, 5);
+	damon_test_split_evenly_succ(test, 0, 3, 2);
 	damon_test_split_evenly_fail(test, 5, 6, 2);
 }
 
--- a/mm/damon/vaddr.c
+++ b/mm/damon/vaddr.c
@@ -67,6 +67,7 @@ static int damon_va_evenly_split_region(
 	unsigned long sz_orig, sz_piece, orig_end;
 	struct damon_region *n = NULL, *next;
 	unsigned long start;
+	unsigned int i;
 
 	if (!r || !nr_pieces)
 		return -EINVAL;
@@ -80,8 +81,7 @@ static int damon_va_evenly_split_region(
 
 	r->ar.end = r->ar.start + sz_piece;
 	next = damon_next_region(r);
-	for (start = r->ar.end; start + sz_piece <= orig_end;
-			start += sz_piece) {
+	for (start = r->ar.end, i = 1; i < nr_pieces; start += sz_piece, i++) {
 		n = damon_new_region(start, start + sz_piece);
 		if (!n)
 			return -ENOMEM;


