Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42AC236C0A0;
	Tue,  6 Jan 2026 17:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722248; cv=none; b=tG+OlkzZ0PaQrmIdaDCLAw2fmMFBbQlcPdZViFkf4G1V039Sp7/AIUde59wcwgfD1m5UzNdKHrkoRcX2q3sxDpOv8glbYKnYU9eQ3AVxhVix4owk2SHqbzgQNn3z1eYBdnM68BQlDxDzfQA3cwXzf42CGDqJDAqJB+nr3oqov4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722248; c=relaxed/simple;
	bh=jXlDPGbZQMf/aRzXhXuLgAX2IIWGyrLAHSEf94SYrPQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aiVcp9IRdPtdNnLrAgPJRQozjul3U1/sSL7UC4weubW8wD6fbjOEvF0dKF59knslYWhDtRz0x0d5WChNPZykF4TgrXRjGuF7Tzr9hl7Hv5R/qOCrq7MNCbxYWWuIHG/boEP6CnQJwGWRBYWGz4GSqRBVcTrHRjwCXg3leuCI8VU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gT/KjI/K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gT/KjI/K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A592BC16AAE;
	Tue,  6 Jan 2026 17:57:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767722248;
	bh=jXlDPGbZQMf/aRzXhXuLgAX2IIWGyrLAHSEf94SYrPQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gT/KjI/KeWJGzU1Geg2QHHJhjjRLVw29XX5Vub6CI4KXbzVtPVxA67L4P88ASBjMF
	 tJwdedIFrEcn/5dmyh1r2gPwIz97R9I5Too03MvdCvC4jVziVwj21U10qEFqZlGWB8
	 sLl4LUvmy9zl4L2por7Q7sG8mjDFh5q/JiC3nTjo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@google.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 208/312] mm/damon/tests/core-kunit: handle alloc failures on dasmon_test_merge_regions_of()
Date: Tue,  6 Jan 2026 18:04:42 +0100
Message-ID: <20260106170555.360896721@linuxfoundation.org>
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

commit 0998d2757218771c59d5ca59ccf13d1542a38f17 upstream.

damon_test_merge_regions_of() is assuming all dynamic memory allocation in
it will succeed.  Those are indeed likely in the real use cases since
those allocations are too small to fail, but theoretically those could
fail.  In the case, inappropriate memory access can happen.  Fix it by
appropriately cleanup pre-allocated memory and skip the execution of the
remaining tests in the failure cases.

Link: https://lkml.kernel.org/r/20251101182021.74868-8-sj@kernel.org
Fixes: 17ccae8bb5c9 ("mm/damon: add kunit tests")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: <stable@vger.kernel.org>	[5.15+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/tests/core-kunit.h |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -238,8 +238,14 @@ static void damon_test_merge_regions_of(
 	int i;
 
 	t = damon_new_target();
+	if (!t)
+		kunit_skip(test, "target alloc fail");
 	for (i = 0; i < ARRAY_SIZE(sa); i++) {
 		r = damon_new_region(sa[i], ea[i]);
+		if (!r) {
+			damon_free_target(t);
+			kunit_skip(test, "region alloc fail");
+		}
 		r->nr_accesses = nrs[i];
 		r->nr_accesses_bp = nrs[i] * 10000;
 		damon_add_region(r, t);


