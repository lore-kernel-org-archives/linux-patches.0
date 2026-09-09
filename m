Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F971583ABA;
	Wed,  9 Sep 2026 14:16:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963387; cv=none; b=XgNxfy0H43WKRb5JcDtpzGIMHjSG5Qf15+wJbOPTgMNank1ZIr4qoo9dMw1ZoOEkQjzQV0Piu05utxTCLmBLNYZanHBaXXhZVfljAvvxqhfXn2HZ7LcwV1oyfH1G09PhCx/srM2hiVnmFM8EYSxTMgZkr2bATt8K9t+qLRwpTfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963387; c=relaxed/simple;
	bh=/8X2tFpDG7cglO96aJU5eTNTwD2Z/7syA+BtmPSSqX0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qupBRVaGaHzP8Cr81at2ivMA60JT5AcZBREQwFyx679t5ezev93v2Yv0QvbJwXJHXqpMpyKLDhfpZ8mwG7jQGHm0o857Go9pxF6GcjoOOIIbaN7eV8CjTR2H69/eYHSBM25HfZrIrGPn+r1TJDTemuSFXiEUbPlyJhc5I4pwutk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gnUaf+RY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gnUaf+RY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C6FC1F00A3A;
	Wed,  9 Sep 2026 14:16:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963385;
	bh=47qIOlh3ZnINidaXdjRu49GpUzfskvMus07YZ7uZdrw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gnUaf+RYe9lrS2S8DhltCOuBMszl1ioDZ3OAmonTT7l2KZnCIStPgXSEgxANoDt7n
	 HPMzZqE9nREUZDjNdjI9re+W6532DJ7LJ8q8WA1TUscAbBt28sGtgc4JRfIwcEnSug
	 Ipm51X/HEZWw/j4I3/kd0P2Cj4/tKYUYQlI4YeQg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SJ Park <sj@kernel.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 061/583] mm/damon/core-kunit: check region count before testing in split_at()
Date: Wed,  9 Sep 2026 15:35:46 +0200
Message-ID: <20260909134240.157704017@linuxfoundation.org>
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

commit 9b18ef3c3aa1ce24176e340061caf15fa2742564 upstream.

damon_test_split_at() test next region that is assumed to be created by
damon_split_region_at() invocation.  But the split might fail.  In this
case, the succeeding test may dereference invalid pointers returned by
damon_next_region().

The invalid pointer may not cause a really bad user impact, because of the
implementation detail.  It would only read wrong contents in the belonging
damon_target struct.  Depending on the future change of the offset from
the link header to the accessing field, this could also be really
dangerous, though.  Still, the realistic user impact would be limited.  It
would affect only test run setups.

Fix it by testing if the number of regions was also changed as expected
and exit early for the failure.

The issue was discovered [1] by Sashiko.

Link: https://lore.kernel.org/20260718001442.87129-3-sj@kernel.org
Link: https://lore.kernel.org/20260714142352.100478-1-sj@kernel.org [1]
Fixes: 17ccae8bb5c9 ("mm/damon: add kunit tests")
Signed-off-by: SJ Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: <stable@vger.kernel.org> # 5.15.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/tests/core-kunit.h |    5 +++++
 1 file changed, 5 insertions(+)

--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -166,6 +166,10 @@ static void damon_test_split_at(struct k
 	r->last_nr_accesses = 15;
 	damon_add_region(r, t);
 	damon_split_region_at(t, r, 25);
+	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 2);
+	if (damon_nr_regions(t) != 2)
+		goto out;
+
 	KUNIT_EXPECT_EQ(test, r->ar.start, 0ul);
 	KUNIT_EXPECT_EQ(test, r->ar.end, 25ul);
 
@@ -177,6 +181,7 @@ static void damon_test_split_at(struct k
 	KUNIT_EXPECT_EQ(test, r->nr_accesses, r_new->nr_accesses);
 	KUNIT_EXPECT_EQ(test, r->last_nr_accesses, r_new->last_nr_accesses);
 
+out:
 	damon_free_target(t);
 	damon_destroy_ctx(c);
 }


