Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 843FD35CBD5;
	Fri,  9 Jan 2026 12:47:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962866; cv=none; b=FcqUfWOyC8a7UL+9DbNP5Jmw1e0sw6cceUCJdyrdtQXupyw8Wlip//XTpMYNnz90QMSbRtYhQi8OYAojPNrtfpbpJyZUV+Vach5bz4/0DXAU2XoNsYSVyOf5NwG3FyYfeV9QruPHpi0XSnFx8Fbh3SjUh7nPH06dthW50eHxm0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962866; c=relaxed/simple;
	bh=lpdVPXQ3G1wFniadD+uHFVOXfKtIVFhvioE+0e5bNDs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QNhHQh612TiYZ9iq2rEAQ+76wOag0Id1F7ZfKzXRw9PAprr5mRNxcp5TNLkFn4O4Y6hCMhDXhy7rZE52ppSCLKRTWlICAFDCjJe8A3wCLKJ+Q6uFvdf8P9bnku7u8NSMtbrlTXS6wNmBV7y/8EbF+PnqlzpnN1hcS0EXYFu95q8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l6tgzTSh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l6tgzTSh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1363EC16AAE;
	Fri,  9 Jan 2026 12:47:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962866;
	bh=lpdVPXQ3G1wFniadD+uHFVOXfKtIVFhvioE+0e5bNDs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l6tgzTSh2zjDXD1yyzGiBz2ahMWraJJVor5p/gnvaa+XQgTTHgVRZJC0xTyc+HKmk
	 1Pfy7oGQ0ISo65rjqbrqGAPjoEpygJWm2pTPNSWDX+RNSLnQDgIHc82gZ648QRHi8O
	 XYnHEpcJlH2Qb7ziOtjQ1znRM++sdb7Ft7+YjReM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@google.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 515/634] mm/damon/tests/vaddr-kunit: handle alloc failures on damon_do_test_apply_three_regions()
Date: Fri,  9 Jan 2026 12:43:13 +0100
Message-ID: <20260109112136.933148496@linuxfoundation.org>
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

commit 2b22d0fcc6320ba29b2122434c1d2f0785fb0a25 upstream.

damon_do_test_apply_three_regions() is assuming all dynamic memory
allocation in it will succeed.  Those are indeed likely in the real use
cases since those allocations are too small to fail, but theoretically
those could fail.  In the case, inappropriate memory access can happen.
Fix it by appropriately cleanup pre-allocated memory and skip the
execution of the remaining tests in the failure cases.

Link: https://lkml.kernel.org/r/20251101182021.74868-18-sj@kernel.org
Fixes: 17ccae8bb5c9 ("mm/damon: add kunit tests")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: <stable@vger.kernel.org>	[5.15+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/vaddr-test.h |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/mm/damon/vaddr-test.h
+++ b/mm/damon/vaddr-test.h
@@ -128,8 +128,14 @@ static void damon_do_test_apply_three_re
 	int i;
 
 	t = damon_new_target();
+	if (!t)
+		kunit_skip(test, "target alloc fail");
 	for (i = 0; i < nr_regions / 2; i++) {
 		r = damon_new_region(regions[i * 2], regions[i * 2 + 1]);
+		if (!r) {
+			damon_destroy_target(t);
+			kunit_skip(test, "region alloc fail");
+		}
 		damon_add_region(r, t);
 	}
 


