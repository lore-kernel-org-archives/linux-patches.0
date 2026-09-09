Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72CF71C3BFC;
	Wed,  9 Sep 2026 14:41:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964871; cv=none; b=mXL2EzPjbEQk5aOQgTbv50TE+V3DA4OjvEXIE7HLjTQ5wOSkDJ/NqZbvjmk5bDqGarMW+rf9ZBO6vrh4NPKHwQuwc8gRZcvghk/AwTEMFlz3Bmy404E6cuvAloxxCu9JxzwL1WYWhHojAhipkqiDmFanWHIYHFH3jO/P9Zf49oo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964871; c=relaxed/simple;
	bh=YDlsEev+fP2R5IqXvPtSizeboRrpb/Jp40cMf/IMwFg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cxM0tZh9fFfds6CGNNGq/YyNZBX9XmVMLamXjFiKLn9oqPoMkdXUzj5qAhgm7SwoNKOyq81F1M2jIKIEpgChdRePwoSrlDm1GN5/dFoPBh9odt4+6jCtwARDs+xzQrNX+SfnrH3o5/aHpQqBhf0OYTLsAT/wWRohjS8uNq8pvq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2nAz7iWf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2nAz7iWf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85A141F00A3A;
	Wed,  9 Sep 2026 14:41:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964870;
	bh=unMVPPrqDHaF6V0mgovIgzhFtHc/9d4cHIHMQ8pdOSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2nAz7iWffUlNaHIbpSTvQpq2IgeV4Z/+PYLPkiXR5dUO253rCCeMgR4p455SZOWUr
	 40s+apzMGJbxqrTZhFo0iSP+0W0mt5L2OX+s8/wKlUP4Ka4C+4Vp71b8Ww3/c7lyUS
	 BbfFJrm6a4XB5LkHwGdyB2C4mVEy/613ZSJki2p0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SJ Park <sj@kernel.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 573/583] mm/damon/core-kunit: handle region split failure in filter_out()
Date: Wed,  9 Sep 2026 15:44:18 +0200
Message-ID: <20260909134257.677868594@linuxfoundation.org>
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

commit 3423fe70395210e2f0cd795270292f6a27cd57b5 upstream.

damos_test_filter_out() test checks if damos_filter_match() of an address
filter splits the region as expected under a given condition.  But, the
test continued regardless of the split successes.  As a result, the later
part of the test could dereference invalid pointers that returned from
damon_next_region().  Further, it could corrupt memory from
damon_destroy_region().

The consequent user impact (memory corruption) is quite bad.  The
realistic user impact would be limited, though.  It would affect only test
run setups.

Fix it by exiting early for the number of regions test failure.

The issue was discovered [1] by Sashiko.

Link: https://lore.kernel.org/20260718001442.87129-5-sj@kernel.org
Link: https://lore.kernel.org/20260714142352.100478-1-sj@kernel.org [1]
Fixes: 26713c890875 ("mm/damon/core-test: add a unit test for __damos_filter_out()")
Signed-off-by: SJ Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: <stable@vger.kernel.org> # 6.6.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/tests/core-kunit.h |    5 +++++
 1 file changed, 5 insertions(+)

--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -596,6 +596,8 @@ static void damos_test_filter_out(struct
 	KUNIT_EXPECT_EQ(test, r->ar.start, DAMON_MIN_REGION * 1);
 	KUNIT_EXPECT_EQ(test, r->ar.end, DAMON_MIN_REGION * 2);
 	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 2);
+	if (damon_nr_regions(t) != 2)
+		goto out;
 	r2 = damon_next_region(r);
 	KUNIT_EXPECT_EQ(test, r2->ar.start, DAMON_MIN_REGION * 2);
 	KUNIT_EXPECT_EQ(test, r2->ar.end, DAMON_MIN_REGION * 4);
@@ -610,11 +612,14 @@ static void damos_test_filter_out(struct
 	KUNIT_EXPECT_EQ(test, r->ar.start, DAMON_MIN_REGION * 2);
 	KUNIT_EXPECT_EQ(test, r->ar.end, DAMON_MIN_REGION * 6);
 	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 2);
+	if (damon_nr_regions(t) != 2)
+		goto out;
 	r2 = damon_next_region(r);
 	KUNIT_EXPECT_EQ(test, r2->ar.start, DAMON_MIN_REGION * 6);
 	KUNIT_EXPECT_EQ(test, r2->ar.end, DAMON_MIN_REGION * 8);
 	damon_destroy_region(r2, t);
 
+out:
 	damon_free_target(t);
 	damos_free_filter(f);
 }


