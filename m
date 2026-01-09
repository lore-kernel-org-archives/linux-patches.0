Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97F0D2EC54D;
	Fri,  9 Jan 2026 12:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961360; cv=none; b=ndcwnoDWPm9VhwXmalZWoSRqjy5O36nckzPsbH94DPXAh+GQhx6xaPoY4h4lrdrDrmg5gicP6t5XH8SPI4WyIegx26324oBULYcU49JPEKF2uMVB0SAPpJyPtfqGnicwgH8zAEqMcUlsgjyVzdhtK08f9BwZMcaEUcBj6FhL4V4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961360; c=relaxed/simple;
	bh=MWQaGEFy4Jm5il2qMFVeZFBg/ryXMeb0OyJ1LV2f8IM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AATzlW211DyWEI9JdH2nM+pTSb1M/3ksDsla4p/+Ps5rDMlmrj53PBdjkUp/WSi2erIsMCFFOhKlhaKGAkm/Ji0Y35onnRL43h1XIsP9i35EFcHcpECcu1+vyG17SOzhhpkgkzl5UhQKmrQkNY8/pAOd/+a2T0gIjNH69NuNU0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IoME0JeV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IoME0JeV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EADA8C4CEF1;
	Fri,  9 Jan 2026 12:22:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961360;
	bh=MWQaGEFy4Jm5il2qMFVeZFBg/ryXMeb0OyJ1LV2f8IM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IoME0JeVlXBDcd6fQlBzcAILiKPm3Y/IbtACIlzHW35e0nnpaoA0vs+fihN0EXo44
	 Gg1qmQ9y9ZUyiV3NnSv2wmiGxitmaGVuxYz5SxGQnqGlnGuqBZKld2mdAM8kMZ8YUv
	 rki7xHM+Ar5Ayf+7nv1tokRkKnaB19urfca6VGPs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@google.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 725/737] mm/damon/tests/core-kunit: handle alloc failures on damos_test_filter_out()
Date: Fri,  9 Jan 2026 12:44:24 +0100
Message-ID: <20260109112201.366644064@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: SeongJae Park <sj@kernel.org>

commit d14d5671e7c9cc788c5a1edfa94e6f9064275905 upstream.

damon_test_filter_out() is assuming all dynamic memory allocation in it
will succeed.  Those are indeed likely in the real use cases since those
allocations are too small to fail, but theoretically those could fail.  In
the case, inappropriate memory access can happen.  Fix it by appropriately
cleanup pre-allocated memory and skip the execution of the remaining tests
in the failure cases.

Link: https://lkml.kernel.org/r/20251101182021.74868-16-sj@kernel.org
Fixes: 26713c890875 ("mm/damon/core-test: add a unit test for __damos_filter_out()")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: <stable@vger.kernel.org>	[6.6+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/core-test.h |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/mm/damon/core-test.h
+++ b/mm/damon/core-test.h
@@ -433,11 +433,22 @@ static void damos_test_filter_out(struct
 	struct damos_filter *f;
 
 	f = damos_new_filter(DAMOS_FILTER_TYPE_ADDR, true);
+	if (!f)
+		kunit_skip(test, "filter alloc fail");
 	f->addr_range = (struct damon_addr_range){
 		.start = DAMON_MIN_REGION * 2, .end = DAMON_MIN_REGION * 6};
 
 	t = damon_new_target();
+	if (!t) {
+		damos_destroy_filter(f);
+		kunit_skip(test, "target alloc fail");
+	}
 	r = damon_new_region(DAMON_MIN_REGION * 3, DAMON_MIN_REGION * 5);
+	if (!r) {
+		damos_destroy_filter(f);
+		damon_free_target(t);
+		kunit_skip(test, "region alloc fail");
+	}
 	damon_add_region(r, t);
 
 	/* region in the range */


