Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73A3036657C;
	Tue,  6 Jan 2026 17:57:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722264; cv=none; b=VTHaoE++0ZqzTC5DKR6G896FdORo1eb0jJP5Awxae6EY62SfcdRTvzeXJwEDU78Q7BanE7I1kfw3CT4oXtPoJf/S/bUtWxS4EEnUZ+4fVL5fmOjI7sMKQdc79lD2bg1yF2pgA1/eKSSAgpxou0oXy6kafjFy5uxgXFqh6XKteus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722264; c=relaxed/simple;
	bh=sunjJ9L2HhaeLmC7ubiTvvubGtboqn3U6hvazjCHNtY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tS2aT+gqSaoEAXJdDdEDEw1nUdrVonOT5PqYGv4b3uphB/d0fgow6JaHgKHATfYONCWmzd9I1SshC2W8Ej2snnQSeAlx7JYT8w5s1/56M4FuY+DutQrHTOAH19+GoomNe/5TTofvJG/x6LBh+9j+97hTP9rTOWXZ9j/zSiPjzmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S/LSCkVC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S/LSCkVC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1521C116C6;
	Tue,  6 Jan 2026 17:57:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767722264;
	bh=sunjJ9L2HhaeLmC7ubiTvvubGtboqn3U6hvazjCHNtY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S/LSCkVCV4U7QirdsvKKwICmFi5P7AGrpD/qgi2sL8cv8YthdKDfQgeWtY66JwVNS
	 0hs7otNoGGI3aTvIOzfTi8D1jZSULM95fF/R7DGH8rs0rbs5yyQVII31LsZsjbau5T
	 g8jv58u1qPwR7LZE1tmu3Tny1G9Ev37QakaSUvW8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@google.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 213/312] mm/damon/tests/core-kunit: handle alloc failures on damos_test_filter_out()
Date: Tue,  6 Jan 2026 18:04:47 +0100
Message-ID: <20260106170555.545750438@linuxfoundation.org>
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
 mm/damon/tests/core-kunit.h |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -511,11 +511,22 @@ static void damos_test_filter_out(struct
 	struct damos_filter *f;
 
 	f = damos_new_filter(DAMOS_FILTER_TYPE_ADDR, true, false);
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


