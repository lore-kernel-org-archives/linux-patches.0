Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2643935BDA8;
	Fri,  9 Jan 2026 12:49:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962941; cv=none; b=loc9iTe49k2n/3yCaswdtk8yHe4fto2W8+F0U1OLQ3YORBrWDaUkoLTNEMpJ/YgxJaX3mP9Dt/Jm6UMWAtLWIfY5Qtr6a8Eodofc/r6zeTJ0Y2g6fTOvMePL39Q8g45rqJwuXn6eKjZQREx/+9g5I3uyxEaGHCnug6cjQ/hmQD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962941; c=relaxed/simple;
	bh=fL3iR2AnJA+w1z/X7AcoF4C1+kxCsc+ZhaOVNVG+/pc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lmIFM5hpABQsTJgZDD4tYpX7iqgCuE8EpURjGv5Z3WA3PaKoVOBK004ZAOhBx7zeMjYX5mYuYc3bEEEicaTwQh9DVA+KktObC5/EydFBtTBukdgN0m5l9RNrx9hX/Eyvhj63yFNykFEBiKTR0/4NwtctclsOGIBeZEsb5NFx8Bo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CdEZhVyP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CdEZhVyP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4186C16AAE;
	Fri,  9 Jan 2026 12:49:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962941;
	bh=fL3iR2AnJA+w1z/X7AcoF4C1+kxCsc+ZhaOVNVG+/pc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CdEZhVyP5wI0ge0bpH2NN/Zt7RAgEaHckGWsbXQDwqT02MDKt0o0RmFuqt5tU0SHJ
	 seadCybJPnXavDQ2ENOYYjzI/OevM5BfWtXLgKeNdKVHq62R7UeEdA5uXdEyxGaX+t
	 e9egeixXJkjZioGvU4tminuOocG6yQol2UpXME8I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@google.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 524/634] mm/damon/tests/core-kunit: handle memory alloc failure from damon_test_aggregate()
Date: Fri,  9 Jan 2026 12:43:22 +0100
Message-ID: <20260109112137.282107724@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: SeongJae Park <sj@kernel.org>

commit f79f2fc44ebd0ed655239046be3e80e8804b5545 upstream.

damon_test_aggregate() is assuming all dynamic memory allocation in it
will succeed.  Those are indeed likely in the real use cases since those
allocations are too small to fail, but theoretically those could fail.  In
the case, inappropriate memory access can happen.  Fix it by appropriately
cleanup pre-allocated memory and skip the execution of the remaining tests
in the failure cases.

Link: https://lkml.kernel.org/r/20251101182021.74868-5-sj@kernel.org
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
@@ -97,8 +97,15 @@ static void damon_test_aggregate(struct
 	struct damon_region *r;
 	int it, ir;
 
+	if (!ctx)
+		kunit_skip(test, "ctx alloc fail");
+
 	for (it = 0; it < 3; it++) {
 		t = damon_new_target();
+		if (!t) {
+			damon_destroy_ctx(ctx);
+			kunit_skip(test, "target alloc fail");
+		}
 		damon_add_target(ctx, t);
 	}
 
@@ -106,6 +113,10 @@ static void damon_test_aggregate(struct
 	damon_for_each_target(t, ctx) {
 		for (ir = 0; ir < 3; ir++) {
 			r = damon_new_region(saddr[it][ir], eaddr[it][ir]);
+			if (!r) {
+				damon_destroy_ctx(ctx);
+				kunit_skip(test, "region alloc fail");
+			}
 			r->nr_accesses = accesses[it][ir];
 			damon_add_region(r, t);
 		}


