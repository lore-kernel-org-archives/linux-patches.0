Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA1FF342169;
	Tue,  6 Jan 2026 17:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721083; cv=none; b=YWVX87cyem3jSlmr77fTucqOZYX8aJQJvy3yYjtYLYRVE53CtJPpwoOomwsVrshKVpIsh2e+7T3rlyfG40aFOpw494LQ6eOGAjGjCrfAgk/S0S/LxR3dPcwSa3/w+Fs98FnT98qnQJPZeEuEXnRU4rtsYnI4IRGXdnQLul1gs8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721083; c=relaxed/simple;
	bh=tFTIEqbQoPjtCHnpfzW+EVnpsrFQbJgIq9QYAUEDVL0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IoDAt82Jx46rEscMyF1nQTa3R5kH7vSV+iNaX8nA1OqNFbSkoy5IrZi7Hr3kXrPvF0pxGdk7ymEtI1dNgrcFhSrtVG/DMERUe5KIv62J5raqtNfeWWKkRgRwqY4nCxOELsW34zf9OOcXAiOfXCDAfS5sdWFFkvlv5h3vHD8R6YM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QdfMpEEC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QdfMpEEC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F89AC16AAE;
	Tue,  6 Jan 2026 17:38:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721083;
	bh=tFTIEqbQoPjtCHnpfzW+EVnpsrFQbJgIq9QYAUEDVL0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QdfMpEECADIR6ypUqF9NRPmR0k9MsWh22i3QYdQoZOYoQZXLDKMIrZA7IrJRGEGH2
	 ur7mWTEUpX9jOouKvHGE/IAquTiYmGq1xlzZ+gQ6+RMPy9p87+wCBDLK4UPZT9YUEh
	 YYUaan19OQK/dm264v1eRDCQgzE15Q5irl2lstt0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@google.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 431/567] mm/damon/tests/core-kunit: handle alloc failures in damon_test_update_monitoring_result()
Date: Tue,  6 Jan 2026 18:03:33 +0100
Message-ID: <20260106170507.294390016@linuxfoundation.org>
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

commit 8cf298c01b7fdb08eef5b6b26d0fe98d48134d72 upstream.

damon_test_update_monitoring_result() is assuming all dynamic memory
allocation in it will succeed.  Those are indeed likely in the real use
cases since those allocations are too small to fail, but theoretically
those could fail.  In the case, inappropriate memory access can happen.
Fix it by appropriately cleanup pre-allocated memory and skip the
execution of the remaining tests in the failure cases.

Link: https://lkml.kernel.org/r/20251101182021.74868-12-sj@kernel.org
Fixes: f4c978b6594b ("mm/damon/core-test: add a test for damon_update_monitoring_results()")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: <stable@vger.kernel.org>	[6.3+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/tests/core-kunit.h |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -406,6 +406,9 @@ static void damon_test_update_monitoring
 	struct damon_attrs new_attrs;
 	struct damon_region *r = damon_new_region(3, 7);
 
+	if (!r)
+		kunit_skip(test, "region alloc fail");
+
 	r->nr_accesses = 15;
 	r->nr_accesses_bp = 150000;
 	r->age = 20;


