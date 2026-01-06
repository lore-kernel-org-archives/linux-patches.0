Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EFD136657C;
	Tue,  6 Jan 2026 17:57:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722255; cv=none; b=SY539HWIzY3yPH/b0b0nDp0GfPygGvs+nUFTD064tVTVjd/+C10BNtTJLmtmHCQP0BjJ//WEvPsjI1L7+xJ3o/KYSRooD5J6BbQvuTWdYa+V0C0RWwy62o3msmUXUteaxkrvDH1ecaZy4uyADK/bIAxmODZdAXBS/3xC6sguX6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722255; c=relaxed/simple;
	bh=cTKqugXTuC0I1AIFXGBsudxs97JjQIHlOzd2IBDNRPI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y9CcQO18Og/JVnALF6FBxcGPBsPhI35zWV/ZN0R5H28eN/a+nN0OkfxqPKzj87912paMn331APTS/wH/yBObIhWQ8viWSA6QPlDDZMaMIHofY2EXp2AYf7gA15A6AcGI5U8oWQ+6veyofQVFhtqyjs/6Ec2es2+Sfrr3Uxq/RfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MLAgWYHN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MLAgWYHN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AFECC116C6;
	Tue,  6 Jan 2026 17:57:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767722255;
	bh=cTKqugXTuC0I1AIFXGBsudxs97JjQIHlOzd2IBDNRPI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MLAgWYHNAB7nQf+aLDZaYmlN5ZCSYxGrJaW+T2TgSBHrICdI51jBX7FsQHBlHInbi
	 oJbIvv/s1oo0nOzRNDPFWLIjANQRwGdvfv78jZSMUwr4hzSU8voCNBxrtWM8lF6orH
	 Lrg3GvWKuhkmeM7izH9Bffc8siBs7CWCl4IXJEjE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@google.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 210/312] mm/damon/tests/core-kunit: handle alloc failures in damon_test_set_regions()
Date: Tue,  6 Jan 2026 18:04:44 +0100
Message-ID: <20260106170555.434514092@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

From: SeongJae Park <sj@kernel.org>

commit 74d5969995d129fd59dd93b9c7daa6669cb6810f upstream.

damon_test_set_regions() is assuming all dynamic memory allocation in it
will succeed.  Those are indeed likely in the real use cases since those
allocations are too small to fail, but theoretically those could fail.  In
the case, inappropriate memory access can happen.  Fix it by appropriately
cleanup pre-allocated memory and skip the execution of the remaining tests
in the failure cases.

Link: https://lkml.kernel.org/r/20251101182021.74868-11-sj@kernel.org
Fixes: 62f409560eb2 ("mm/damon/core-test: test damon_set_regions")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: <stable@vger.kernel.org>	[6.1+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/tests/core-kunit.h |   17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -345,13 +345,26 @@ static void damon_test_ops_registration(
 static void damon_test_set_regions(struct kunit *test)
 {
 	struct damon_target *t = damon_new_target();
-	struct damon_region *r1 = damon_new_region(4, 16);
-	struct damon_region *r2 = damon_new_region(24, 32);
+	struct damon_region *r1, *r2;
 	struct damon_addr_range range = {.start = 8, .end = 28};
 	unsigned long expects[] = {8, 16, 16, 24, 24, 28};
 	int expect_idx = 0;
 	struct damon_region *r;
 
+	if (!t)
+		kunit_skip(test, "target alloc fail");
+	r1 = damon_new_region(4, 16);
+	if (!r1) {
+		damon_free_target(t);
+		kunit_skip(test, "region alloc fail");
+	}
+	r2 = damon_new_region(24, 32);
+	if (!r2) {
+		damon_free_target(t);
+		damon_free_region(r1);
+		kunit_skip(test, "second region alloc fail");
+	}
+
 	damon_add_region(r1, t);
 	damon_add_region(r2, t);
 	damon_set_regions(t, &range, 1, DAMON_MIN_REGION);


