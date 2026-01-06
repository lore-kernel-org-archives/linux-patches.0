Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F9EA36CE1C;
	Tue,  6 Jan 2026 17:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722334; cv=none; b=qKxH6aS49ndadb6vktGsYb1p2dbR0e767tayDYxauPve3mSjdJpGqCOdrj1/d0seeZOCNWfvEwt0i3UhxFTdJaNO5DU+bjAsnOkXkRF4VBTkNN6J8PJmL9mFXX1r6+jDrksHX8BgSASSvdSMnE3wTH7VoadynxEHaD7+hYUCVmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722334; c=relaxed/simple;
	bh=MVZGGY26anjnfzoiHnCkcd8DnxqQuraDDRCMuBBvUlg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TUOlfAK/Sr5CT7TneEwbR+QI/f0jnjrq3GK3rkXvHTEX9SU+cJK9xvBu2K7wDAa/3sqLsr8wycVmHJ+P3gyqtI8bZ+wpms/0JmubFQ9I/ft28atU5FrzFptZqRRc6Pc/HTGOE1KAibXEymamfIyBbFo7WocgFHn6m7XBndhMPVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s7F+aSyn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s7F+aSyn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBC31C16AAE;
	Tue,  6 Jan 2026 17:58:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767722334;
	bh=MVZGGY26anjnfzoiHnCkcd8DnxqQuraDDRCMuBBvUlg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s7F+aSynCtpHJBmOMNmnunjmVgJU7DEN5qeUZvd1QI0huC/oqhYy3tyr4RMfrgiDK
	 x56Bp7Ky9R0KOlktJPFC2YFKtdSUpe8zP8RnA9NJNIGx5TI1nDIisQIAOlVqnbQ8mW
	 6CCBQ2ED4cDDrhrBbovBE5sPK9CG6/Ez914xmvJw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@google.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 201/312] mm/damon/tests/vaddr-kunit: handle alloc failures on damon_test_split_evenly_succ()
Date: Tue,  6 Jan 2026 18:04:35 +0100
Message-ID: <20260106170555.101672508@linuxfoundation.org>
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

commit 0a63a0e7570b9b2631dfb8d836dc572709dce39e upstream.

damon_test_split_evenly_succ() is assuming all dynamic memory allocation
in it will succeed.  Those are indeed likely in the real use cases since
those allocations are too small to fail, but theoretically those could
fail.  In the case, inappropriate memory access can happen.  Fix it by
appropriately cleanup pre-allocated memory and skip the execution of the
remaining tests in the failure cases.

Link: https://lkml.kernel.org/r/20251101182021.74868-20-sj@kernel.org
Fixes: 17ccae8bb5c9 ("mm/damon: add kunit tests")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: <stable@vger.kernel.org>	[5.15+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/tests/vaddr-kunit.h |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/mm/damon/tests/vaddr-kunit.h
+++ b/mm/damon/tests/vaddr-kunit.h
@@ -284,10 +284,17 @@ static void damon_test_split_evenly_succ
 	unsigned long start, unsigned long end, unsigned int nr_pieces)
 {
 	struct damon_target *t = damon_new_target();
-	struct damon_region *r = damon_new_region(start, end);
+	struct damon_region *r;
 	unsigned long expected_width = (end - start) / nr_pieces;
 	unsigned long i = 0;
 
+	if (!t)
+		kunit_skip(test, "target alloc fail");
+	r = damon_new_region(start, end);
+	if (!r) {
+		damon_free_target(t);
+		kunit_skip(test, "region alloc fail");
+	}
 	damon_add_region(r, t);
 	KUNIT_EXPECT_EQ(test,
 			damon_va_evenly_split_region(t, r, nr_pieces), 0);


