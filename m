Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9A102EC54D;
	Fri,  9 Jan 2026 12:22:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961372; cv=none; b=c+5SPVip6dcYeV5TdUGs+QEpg79Hlo4waWTZ6l7q0QD9bZwwLPLnULFG+AfHNJAPrt8OSSSv/8JhMaOTIi7NLSGNv6VxYvG5w8fHm5NO9nhadx1Bhia/NPaHMH3Y4cv2XtWwHe+zrEqVygrvkNW3fAEn87167fqD5VV1UbRV/sA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961372; c=relaxed/simple;
	bh=9XXZxDOT3fNFDBRNu1NnbFYCEZVZhOHuYhR7GEbQFzg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jd2rQkMuA/4LM70HKis6QTmN+ekcHpR7NaMSrSjYBpkPEnkgnFsfAxKolllI8HM3R+UA5tU//R5ALOctWjp+EYBJvQ9GZf2AiCZID2asfVFeIj3b6BLmOfFUMCTRY7T1F1DnV1ZaArA6MMo2b/rw6gfcW+zFHzTqDHQaI1I4rsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cAiFzKWJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cAiFzKWJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70BDAC16AAE;
	Fri,  9 Jan 2026 12:22:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961371;
	bh=9XXZxDOT3fNFDBRNu1NnbFYCEZVZhOHuYhR7GEbQFzg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cAiFzKWJUt8Jg91gSbtCLCC6J54TNiAHT28zEIUGY8AJicXurrZJL4d9rQPvwB8+e
	 eS0I9eO2a16O2U0GhxB3pgXMSlD/T7UHBV3opr51qu8/L4ZYJPO8xR9/jDtWLDDDVK
	 TntuebVeEcQK7dl6sdpo1dpzMKaWzwUZItVeumKs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@google.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 729/737] mm/damon/tests/core-kunit: handle alloc failures in damon_test_update_monitoring_result()
Date: Fri,  9 Jan 2026 12:44:28 +0100
Message-ID: <20260109112201.528057001@linuxfoundation.org>
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
 mm/damon/core-test.h |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/damon/core-test.h
+++ b/mm/damon/core-test.h
@@ -383,6 +383,9 @@ static void damon_test_update_monitoring
 	struct damon_attrs new_attrs;
 	struct damon_region *r = damon_new_region(3, 7);
 
+	if (!r)
+		kunit_skip(test, "region alloc fail");
+
 	r->nr_accesses = 15;
 	r->age = 20;
 


