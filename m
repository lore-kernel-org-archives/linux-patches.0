Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B8315540BB;
	Wed,  9 Sep 2026 14:15:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963343; cv=none; b=SJYYnLRncwdElH1Obfd4/4vLtxHI4tFT7j6rqYo8Yd5W5lorVFZNZH8FIVkIr1JB5MSBtnXrwL8TGoLXbF1Laox3+JcSGYOVVocndwyWZEKa9AD/wm7WnmgtwYN/j5yhUoNDIgAix6iFYeyF/6BISy/96EO2ID25yppjXHHTbjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963343; c=relaxed/simple;
	bh=u0coV6wlnAg2yagWqZjZaa8V86p30KvBccEdMgS8Xr0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AbEcMtnzneHCkQmSjPNkXWYn78TBIQxt8o4k52QZZWCVcyMzPPv1lRHf3obZxev2HeRSSU7D+FwXLTwzpybEc6kCQHyQQ/H5+71PosL+bJPGiUqoj0OXN5yh9qmpEnZbtdJasuaiJgVtQKhH1PxkYmAtq1U6qqBOGAzETX8Ju6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l8pYcWmt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l8pYcWmt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 014A71F00A3A;
	Wed,  9 Sep 2026 14:15:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963342;
	bh=7s8CWz5Tl3YSfMN0LgloA8fsZvGkLXf4YqxXzYuM838=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l8pYcWmtVbY9qSgGk/hyZnm1Hb/S18mJDjLImrSI/+WL8TtrfPI6bNii4tu3S8UoH
	 ArI1vBPYf33NomY4K7Za6qsorm7Wut/YCPpNRtFarSUHbpsFNnzWe9lCOmGzYMRV1H
	 AIKGtke3CqJko1pNqbeQFhXuB256Yb5UIEfLkPUw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SJ Park <sj@kernel.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 047/583] mm/damon/vaddr-kunit: check region count in three_regions test
Date: Wed,  9 Sep 2026 15:35:32 +0200
Message-ID: <20260909134239.570973871@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

From: SJ Park <sj@kernel.org>

commit 5fea07e460874c8c7cf00f728efbe22abc62c8d8 upstream.

damon_do_test_apply_three_regions() iterates regions after
damon_set_regions() call assuming the function would succeed at setting
the number of regions the same to the expected one.  It might have failed.
In this case, __nth_region_of() in the iteration could return NULL and
NULL dereference can happen in the test.

The consequent user impact (NULL dereference) is quite bad.  The realistic
user impact would be limited, though.  It would affect only test run
setups.

Fix it by testing if the number of regions was also changed as expected
and exit early for the failure.

The issue was discovered [1] by Sashiko.

Link: https://lore.kernel.org/20260718001442.87129-4-sj@kernel.org
Link: https://lore.kernel.org/20260713144757.39740-1-sj@kernel.org [1]
Fixes: 17ccae8bb5c9 ("mm/damon: add kunit tests")
Signed-off-by: SJ Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: <stable@vger.kernel.org> # 5.15.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/tests/vaddr-kunit.h |    5 +++++
 1 file changed, 5 insertions(+)

--- a/mm/damon/tests/vaddr-kunit.h
+++ b/mm/damon/tests/vaddr-kunit.h
@@ -149,12 +149,17 @@ static void damon_do_test_apply_three_re
 
 	damon_set_regions(t, three_regions, 3, DAMON_MIN_REGION);
 
+	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), nr_expected / 2);
+	if (damon_nr_regions(t) != nr_expected / 2)
+		goto out;
+
 	for (i = 0; i < nr_expected / 2; i++) {
 		r = __nth_region_of(t, i);
 		KUNIT_EXPECT_EQ(test, r->ar.start, expected[i * 2]);
 		KUNIT_EXPECT_EQ(test, r->ar.end, expected[i * 2 + 1]);
 	}
 
+out:
 	damon_destroy_target(t, NULL);
 }
 


