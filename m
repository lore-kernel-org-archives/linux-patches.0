Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD778338918;
	Tue,  6 Jan 2026 17:38:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721087; cv=none; b=LDj1Hd6E84bLlxVUdoSvmcy6Ikfq63jkQ920hLrxIqs0jOy0qFZ4/iPYmaAEK6byMWB5sVinrNYO40Kfte0E8Idd1Oamt3Yjkk2HnDJf19GsKPZnHDvEMvOxbhHWH6TMXywKCXRL1GpsqIyvhonMYJaRqvJqREStpCPp/uNuv5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721087; c=relaxed/simple;
	bh=Ea8k+XUzBi1jWo3PEoLpEZamZiDBfdtWwhFT8x2saDY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F7T3mM+ugsywR0t1HWO3i9f0OfFQLGiEuG0DDspfMD1VQkAe+seFiE3MALHxnXsqZ3CqDGv1j4YQknPu5N7vFDCV4E0LxB26Jjvf78vTYmHPhSwkplhmfa/ULPm5A3LzyDZpzSIRndGEPU/nun+9aeqw+Hj4Xz+YgOGYqmRcERM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fp29V5Jh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fp29V5Jh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D466C116C6;
	Tue,  6 Jan 2026 17:38:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721086;
	bh=Ea8k+XUzBi1jWo3PEoLpEZamZiDBfdtWwhFT8x2saDY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fp29V5Jhc2hFGhOczZNxx8tl+1gFb9TzNrNE9Cou1mwp1PNBanyN+EqJtkW3AR+78
	 ISykHLQKX6JAdeeWQQHPeA/mZWkgWx09cR9EQ4rnB3VzoUjwQAyEutdE82zHE/DFTU
	 ho4VVkJIQ5yUiBPo5zZySmbvFJqvoVLT0/ucMVlA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@google.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 432/567] mm/damon/tests/core-kunit: handle alloc failures in damon_test_ops_registration()
Date: Tue,  6 Jan 2026 18:03:34 +0100
Message-ID: <20260106170507.331377546@linuxfoundation.org>
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

commit 4f835f4e8c863985f15abd69db033c2f66546094 upstream.

damon_test_ops_registration() is assuming all dynamic memory allocation in
it will succeed.  Those are indeed likely in the real use cases since
those allocations are too small to fail, but theoretically those could
fail.  In the case, inappropriate memory access can happen.  Fix it by
appropriately cleanup pre-allocated memory and skip the execution of the
remaining tests in the failure cases.

Link: https://lkml.kernel.org/r/20251101182021.74868-10-sj@kernel.org
Fixes: 4f540f5ab4f2 ("mm/damon/core-test: add a kunit test case for ops registration")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: <stable@vger.kernel.org>	[5.19+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/tests/core-kunit.h |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -300,6 +300,9 @@ static void damon_test_ops_registration(
 	struct damon_operations ops = {.id = DAMON_OPS_VADDR}, bak;
 	bool need_cleanup = false;
 
+	if (!c)
+		kunit_skip(test, "ctx alloc fail");
+
 	/* DAMON_OPS_VADDR is registered only if CONFIG_DAMON_VADDR is set */
 	if (!damon_is_registered_ops(DAMON_OPS_VADDR)) {
 		bak.id = DAMON_OPS_VADDR;


