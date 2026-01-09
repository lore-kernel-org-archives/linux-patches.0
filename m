Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AEBA303C87;
	Fri,  9 Jan 2026 12:22:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961343; cv=none; b=XBhvQwn9smbxQClRi9qNQZkEmsdHJ9W0E0G4sgYMF/t8grjriWX6SZ2qDKsl88EOrhz4CsGGLQLcRYNOpIENpvTbcSL20ivxApMz3pjGMe35QDXUH7M20I6kKkxbHQqovn7N+Hg4NmQv+nrhF1WZd0ucGeSRcBgf51suTDfERJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961343; c=relaxed/simple;
	bh=iTi1y8BYbn9CC6wtUH7Vv5CVlJyUudFznCMsTtGFCZI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AO5OLMLhOl4ATIjt72FmoHCvuVZIEpZ9W+BQyTbTWvSQis190OjHlOqC31uf8g1iZ7i9jdS1qff/AscL/H3oQrhbE9XTkII2IXSLp9GdvzCcsyhzGIpRuVovPVqIr2nOR8FIsj3xsrUDAq+UL76SWtm7zId/z1cBSh1pmPYtceQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R6hF/fSQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R6hF/fSQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97D8DC4CEF1;
	Fri,  9 Jan 2026 12:22:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961343;
	bh=iTi1y8BYbn9CC6wtUH7Vv5CVlJyUudFznCMsTtGFCZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R6hF/fSQXNyNZKFy14gfPcxQX0PsoKb82MsVMTnFyyA4U4/9I9zQznxxk3coz0ojd
	 WpRxanyhMV3OkH1qPyrOXPuv71mbifvNw7BnlXnNPimUpu5Ef1givpXLzgkw7E1A9l
	 ZJq8k1n6ZwFNxtZDRpOP3Vn8HLATBFRD/oSGEF54=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@google.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 720/737] mm/damon/tests/core-kunit: handle alloc failures on dasmon_test_merge_regions_of()
Date: Fri,  9 Jan 2026 12:44:19 +0100
Message-ID: <20260109112201.172340523@linuxfoundation.org>
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
 mm/damon/core-test.h |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/mm/damon/core-test.h
+++ b/mm/damon/core-test.h
@@ -210,8 +210,14 @@ static void damon_test_merge_regions_of(
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
 		damon_add_region(r, t);
 	}


