Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D500436CE1D;
	Tue,  6 Jan 2026 17:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722337; cv=none; b=Usod7DxXVvVVX/K982RQsua5qnzfbzFmIgPO2oE0KSQ/dp/zupuAaeBB9suBhALcrAEwIjbmsdY4RQqGnHtl+7YZQjMl7/X6aeHa49tOhZ8+a3mNZYmvwFvKsX11WmfVVMjrw0VR6pcXPOtKN9AQuRtLBbD4v2z2LSqdVqsgpQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722337; c=relaxed/simple;
	bh=voXnQC5+hgYdjvuwrcCnjEJ/TgjKJtDY8jBY1kc2GVk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LgipWepA1bIp95r6FKyzUISU1cqm/YQM72Dd53ULSMAuJI8y75EE+c68yoDENhstEXvQhpVFw5eREiRPhDxOe2INZpAkUGODPWmzwUjeuEE3XKsy4vUmfWe1PeIsQj0f2qWtFdUqLhV2T0tPGjVXZGxcUVyGy/xjIp6p482Pu24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qZjlTL8P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qZjlTL8P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1112DC116C6;
	Tue,  6 Jan 2026 17:58:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767722337;
	bh=voXnQC5+hgYdjvuwrcCnjEJ/TgjKJtDY8jBY1kc2GVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qZjlTL8PqaYagQiA3Q7atxkJUdH4zJPK09rh8mL/34hwNevOawexksiWkOOfp/Y/M
	 B6GRFBUiBmllRQWrn2V8Vv4uvtMDc9maVf1qcaWRc9k29nP9oLUaQ6ISL6F2H7RbEZ
	 YNkCfcSN3k+qq9oBzXSgvEi087dua5squbmJ22Eg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@google.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 202/312] mm/damon/tests/core-kunit: fix memory leak in damon_test_set_filters_default_reject()
Date: Tue,  6 Jan 2026 18:04:36 +0100
Message-ID: <20260106170555.138638997@linuxfoundation.org>
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

commit b5ab490d85b772bc99d2648182a282f39f08feb6 upstream.

Patch series "mm/damon/tests: fix memory bugs in kunit tests".

DAMON kunit tests were initially written assuming those will be run on
environments that are well controlled and therefore tolerant to transient
test failures and bugs in the test code itself.  The user-mode linux based
manual run of the tests is one example of such an environment.  And the
test code was written for adding more test coverage as fast as possible,
over making those safe and reliable.

As a result, the tests resulted in having a number of bugs including real
memory leaks, theoretical unhandled memory allocation failures, and unused
memory allocations.  The allocation failures that are not handled well are
unlikely in the real world, since those allocations are too small to fail.
But in theory, it can happen and cause inappropriate memory access.

It is arguable if bugs in test code can really harm users.  But, anyway
bugs are bugs that need to be fixed.  Fix the bugs one by one.  Also Cc
stable@ for the fixes of memory leak and unhandled memory allocation
failures.  The unused memory allocations are only a matter of memory
efficiency, so not Cc-ing stable@.

The first patch fixes memory leaks in the test code for the DAMON core
layer.

Following fifteen, three, and one patches respectively fix unhandled
memory allocation failures in the test code for DAMON core layer, virtual
address space DAMON operation set, and DAMON sysfs interface, one by one
per test function.

Final two patches remove memory allocations that are correctly deallocated
at the end, but not really being used by any code.


This patch (of 22):

Kunit test function for damos_set_filters_default_reject() allocates two
'struct damos_filter' objects and not deallocates those, so that the
memory for the two objects are leaked for every time the test runs.  Fix
this by deallocating those objects at the end of the test code.

Link: https://lkml.kernel.org/r/20251101182021.74868-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20251101182021.74868-2-sj@kernel.org
Fixes: 094fb14913c7 ("mm/damon/tests/core-kunit: add a test for damos_set_filters_default_reject()")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: <stable@vger.kernel.org>	[6.16+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/tests/core-kunit.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index 51369e35298b..69ca44f9270b 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -598,6 +598,9 @@ static void damon_test_set_filters_default_reject(struct kunit *test)
 	 */
 	KUNIT_EXPECT_EQ(test, scheme.core_filters_default_reject, false);
 	KUNIT_EXPECT_EQ(test, scheme.ops_filters_default_reject, true);
+
+	damos_free_filter(anon_filter);
+	damos_free_filter(target_filter);
 }
 
 static struct kunit_case damon_test_cases[] = {
-- 
2.52.0



