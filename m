Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27D573D1CBD;
	Thu, 15 Jan 2026 17:33:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498400; cv=none; b=oGAe+EFvQ4UmYYEURwML0gDgTKekqiglknZMXvT2aIQDwC3vVMnMm2Kpd9aLVQPTb82hk9+ADabdPJ9y3FemkSGeQ6UWr0IReoGLsSkxJsNvK3chCeS5G1OqY+3AWQzV5F76S5x2N8vKC16vwaVdfNXce6ArLy02xBPjdHesDqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498400; c=relaxed/simple;
	bh=ykfN4tidfekWw3xCczzev4MjDHLTeGdMIdEiPmCK0rU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lh5Pb7j7Amt0MqAfZ4tryPTaa8MICNlyUMMlmpIguHIST/z35M0y7YfytHmRGTP3W2rvp28fTAs1JB74HpIM0J9MCa+lob03e0ZJigLL4ZMe2Vo6CJxX0L+FO82lzviAb2IBrPmtEWkgFfgZ6f8h0CclpQbzbGp9eD9Ij1vDcJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r8dZ3Jwt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r8dZ3Jwt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91825C2BC86;
	Thu, 15 Jan 2026 17:33:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498399;
	bh=ykfN4tidfekWw3xCczzev4MjDHLTeGdMIdEiPmCK0rU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r8dZ3JwteI2GXm76gx0rREEeTXghiWUBSLq755qpA3WRQ0GI+MsEWURIvyITjWcVP
	 LBSWeJqO43XyquIuTv3i3eJ4xAr1WLUIHPwo9V4zldM6A7HkWOkjvooaDBHo6BMOXS
	 CqcDLrIzormaBW96euHeGQGYpv15TdgTth5GqO6g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@google.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.15 417/554] mm/damon/tests/core-kunit: handle alloc failures on damon_test_split_at()
Date: Thu, 15 Jan 2026 17:48:03 +0100
Message-ID: <20260115164301.335013233@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: SeongJae Park <sj@kernel.org>

commit 5e80d73f22043c59c8ad36452a3253937ed77955 upstream.

damon_test_split_at() is assuming all dynamic memory allocation in it will
succeed.  Those are indeed likely in the real use cases since those
allocations are too small to fail, but theoretically those could fail.  In
the case, inappropriate memory access can happen.  Fix it by appropriately
cleanup pre-allocated memory and skip the execution of the remaining tests
in the failure cases.

Link: https://lkml.kernel.org/r/20251101182021.74868-6-sj@kernel.org
Fixes: 17ccae8bb5c9 ("mm/damon: add kunit tests")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: <stable@vger.kernel.org>	[5.15+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/core-test.h |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/mm/damon/core-test.h
+++ b/mm/damon/core-test.h
@@ -128,8 +128,19 @@ static void damon_test_split_at(struct k
 	struct damon_target *t;
 	struct damon_region *r;
 
+	if (!c)
+		kunit_skip(test, "ctx alloc fail");
 	t = damon_new_target(42);
+	if (!t) {
+		damon_destroy_ctx(c);
+		kunit_skip(test, "target alloc fail");
+	}
 	r = damon_new_region(0, 100);
+	if (!r) {
+		damon_destroy_ctx(c);
+		damon_free_target(t);
+		kunit_skip(test, "region alloc fail");
+	}
 	damon_add_region(r, t);
 	damon_split_region_at(c, t, r, 25);
 	KUNIT_EXPECT_EQ(test, r->ar.start, 0ul);


