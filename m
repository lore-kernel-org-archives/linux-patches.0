Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87BBA32AAB5;
	Fri,  9 Jan 2026 12:22:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961334; cv=none; b=qcEMsmLmj7ZOdBb8xoqVDXWzfj81wzNBrKYtinLJEWpjvlRMa+6znwJF/8CbxMPN4uHk9rZng+d+Atze4EuhgfLgCVY/anxSdhGJoDexkPPu9aZkKGT1EFCUPaaGeCPZZ8wxz3vTFi08wBvkOU68nhC7QSTZejRWReqgPLGJI3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961334; c=relaxed/simple;
	bh=eTS+VRcbaCDW+7FAgbRNus+0IKW6y8xDw9OsMhpEtxg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cr0ndgOIC1JKjvVyXhR5bAl1WNO4Qt/SPf7XQfq558dYHmoWYVm56bLo+9sccO9uH0/Rry9D2gs18G/5X9KDa+CVZWWuCjnRJ4c995DsqxnC9zwQAafBBY5AOyjHRxxv5RutTlhTMncJVvM3K4FXN71VUsPUEk2wZjyGWgKQ1FM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UfUnRWFr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UfUnRWFr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15F74C4CEF1;
	Fri,  9 Jan 2026 12:22:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961334;
	bh=eTS+VRcbaCDW+7FAgbRNus+0IKW6y8xDw9OsMhpEtxg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UfUnRWFrttv+HQhOa1XaOnjAuSLFn4ASfZBc+a1r+pVh3er/XVD8KiOgF8/DQfVwz
	 kgxYsKqkfO8cquQ0ZN90RGinXGe+kCccH6ywheWLTGQtLNwNHktokSVL2pc8h44fL7
	 NnMPawfDHRpk3TAs29r8FTOxV2G3rMiTtT+rEDjU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@google.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 717/737] mm/damon/tests/core-kunit: handle alloc failres in damon_test_new_filter()
Date: Fri,  9 Jan 2026 12:44:16 +0100
Message-ID: <20260109112201.056829191@linuxfoundation.org>
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

commit 28ab2265e9422ccd81e4beafc0ace90f78de04c4 upstream.

damon_test_new_filter() is assuming all dynamic memory allocation in it
will succeed.  Those are indeed likely in the real use cases since those
allocations are too small to fail, but theoretically those could fail.  In
the case, inappropriate memory access can happen.  Fix it by appropriately
cleanup pre-allocated memory and skip the execution of the remaining tests
in the failure cases.

Link: https://lkml.kernel.org/r/20251101182021.74868-14-sj@kernel.org
Fixes: 2a158e956b98 ("mm/damon/core-test: add a test for damos_new_filter()")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: <stable@vger.kernel.org>	[6.6+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/core-test.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/damon/core-test.h
+++ b/mm/damon/core-test.h
@@ -346,6 +346,8 @@ static void damos_test_new_filter(struct
 	struct damos_filter *filter;
 
 	filter = damos_new_filter(DAMOS_FILTER_TYPE_ANON, true);
+	if (!filter)
+		kunit_skip(test, "filter alloc fail");
 	KUNIT_EXPECT_EQ(test, filter->type, DAMOS_FILTER_TYPE_ANON);
 	KUNIT_EXPECT_EQ(test, filter->matching, true);
 	KUNIT_EXPECT_PTR_EQ(test, filter->list.prev, &filter->list);


