Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 652F2270540;
	Tue,  6 Jan 2026 17:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721182; cv=none; b=dgpwEZVw0NqQ0Ee1dhm0q0tmDyfzWH3QOvd2T2ad0NTePYK0QUDhDlCWHsM7G8NWZ6Q8GyFzbUfOG5p2CFyBDhsBPwOogYBJLlQff8CY5sQu/iv1GFYR786YDEw0xb/gUp36xLBCob2Ud7+A/I47PMeFu5fxN/LtQvW4QuC/uhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721182; c=relaxed/simple;
	bh=PlnPMOUb5RqarLWb2ygaxhcnBEILweymcvTlaqgOuTQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BDtOHaBrwwuxfgQt0PnrWzLlL6kpzQ1gfXJl60s5O7ZAyxwmLQmD6jkdWLbp9+R2YboPVzsPIsPMQPo7LMYnhULOSWG2dXgxZbSnKS5HryZqDfnnzTrUWNDG0zLxBwSsqTfnY3j4maDXorg1TanCIgty+J/eSPRWWwSaRFDUyBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SB9+fVOI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SB9+fVOI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF393C116C6;
	Tue,  6 Jan 2026 17:39:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721182;
	bh=PlnPMOUb5RqarLWb2ygaxhcnBEILweymcvTlaqgOuTQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SB9+fVOI+e/tFCUjxt1EA9NCJ5nahzBILB2Nuco4jtgXco8rXThFnGPALlz8iRQ0J
	 QUqw9JYVknKgk1ja/eKwB7+lNPZ7dPm1lmj5/aXbulW4Umc4/AuN9dv0NfU1kFI67b
	 7AhL/6MPrMccfezapwS2LO9gEC4AkAUt2la3px0k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@google.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 427/567] mm/damon/tests/core-kunit: handle memory alloc failure from damon_test_aggregate()
Date: Tue,  6 Jan 2026 18:03:29 +0100
Message-ID: <20260106170507.143306441@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 mm/damon/tests/core-kunit.h |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
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
 			r->nr_accesses_bp = accesses[it][ir] * 10000;
 			damon_add_region(r, t);


