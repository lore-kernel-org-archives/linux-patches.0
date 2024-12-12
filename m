Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A6ED6F2FE;
	Thu, 12 Dec 2024 17:11:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023474; cv=none; b=p/ZeaennHccXbiB9S8jGICCTSANdS5glUu78IoufIJpY3iQSCNEg96UiI85rUUTYxu45sDa1psoW0R/8nD5+Vku9OiC4dV+LXpNNNFROuOBK7d4YYeUzafqjxdft7T1zaCKs7CyggISZmOyBY1eNcnzdUxO9m5t+xZvVodbMehg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023474; c=relaxed/simple;
	bh=4etn1z2Rd8kUzLZ+Vl7Vsxa4UwLlapaELU+HUVGiqOg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=osNnMhnxDMF5avvt9E5DwV10m56PLDqeBDgT4ixs/TSWocQ3+rKbqu8tqFg6mVeUeepGL4+AL8emHRw0vwudg4k2gb/8fEwUGGysPNKI3aWhjvdUJD0H5vD9zVXtaK3MCOqMvZrPqH9hr0+A4wtVE9lvhegNYm0FbogHhSz1qVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V3OCZGCA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V3OCZGCA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48EECC4CECE;
	Thu, 12 Dec 2024 17:11:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023473;
	bh=4etn1z2Rd8kUzLZ+Vl7Vsxa4UwLlapaELU+HUVGiqOg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V3OCZGCAChi1KdXj43Wd20HWSXF5/cuatAaV7kV1s1Bydlpguubca7nGuiBBevvLV
	 rqN0SOikajuCHAv3Sa/s6WonjvCIdvNIJ2y0Fj+c8aBAGofxVlR1a8nPV9Yq7abuD6
	 thxjOQ40BRT4AStUogP5mV9B6Pw23Di47X40YQwg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	kernel test robot <lkp@intel.com>,
	Brendan Higgins <brendanhiggins@google.com>,
	Shuah Khan <shuah@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.15 544/565] mm/damon/vaddr-test: split a test function having >1024 bytes frame size
Date: Thu, 12 Dec 2024 16:02:19 +0100
Message-ID: <20241212144333.359850773@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: SeongJae Park <sj@kernel.org>

commit 044cd9750fe010170f5dc812e4824d98f5ea928c upstream.

On some configuration[1], 'damon_test_split_evenly()' kunit test
function has >1024 bytes frame size, so below build warning is
triggered:

      CC      mm/damon/vaddr.o
    In file included from mm/damon/vaddr.c:672:
    mm/damon/vaddr-test.h: In function 'damon_test_split_evenly':
    mm/damon/vaddr-test.h:309:1: warning: the frame size of 1064 bytes is larger than 1024 bytes [-Wframe-larger-than=]
      309 | }
          | ^

This commit fixes the warning by separating the common logic in the
function.

[1] https://lore.kernel.org/linux-mm/202111182146.OV3C4uGr-lkp@intel.com/

Link: https://lkml.kernel.org/r/20211201150440.1088-6-sj@kernel.org
Fixes: 17ccae8bb5c9 ("mm/damon: add kunit tests")
Signed-off-by: SeongJae Park <sj@kernel.org>
Reported-by: kernel test robot <lkp@intel.com>
Cc: Brendan Higgins <brendanhiggins@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/vaddr-test.h |   77 +++++++++++++++++++++++++-------------------------
 1 file changed, 40 insertions(+), 37 deletions(-)

--- a/mm/damon/vaddr-test.h
+++ b/mm/damon/vaddr-test.h
@@ -252,59 +252,62 @@ static void damon_test_apply_three_regio
 			new_three_regions, expected, ARRAY_SIZE(expected));
 }
 
-static void damon_test_split_evenly(struct kunit *test)
+static void damon_test_split_evenly_fail(struct kunit *test,
+		unsigned long start, unsigned long end, unsigned int nr_pieces)
 {
-	struct damon_ctx *c = damon_new_ctx();
-	struct damon_target *t;
-	struct damon_region *r;
-	unsigned long i;
-
-	KUNIT_EXPECT_EQ(test, damon_va_evenly_split_region(NULL, NULL, 5),
-			-EINVAL);
-
-	t = damon_new_target(42);
-	r = damon_new_region(0, 100);
-	KUNIT_EXPECT_EQ(test, damon_va_evenly_split_region(t, r, 0), -EINVAL);
+	struct damon_target *t = damon_new_target(42);
+	struct damon_region *r = damon_new_region(start, end);
 
 	damon_add_region(r, t);
-	KUNIT_EXPECT_EQ(test, damon_va_evenly_split_region(t, r, 10), 0);
-	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 10u);
+	KUNIT_EXPECT_EQ(test,
+			damon_va_evenly_split_region(t, r, nr_pieces), -EINVAL);
+	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 1u);
 
-	i = 0;
 	damon_for_each_region(r, t) {
-		KUNIT_EXPECT_EQ(test, r->ar.start, i++ * 10);
-		KUNIT_EXPECT_EQ(test, r->ar.end, i * 10);
+		KUNIT_EXPECT_EQ(test, r->ar.start, start);
+		KUNIT_EXPECT_EQ(test, r->ar.end, end);
 	}
+
 	damon_free_target(t);
+}
+
+static void damon_test_split_evenly_succ(struct kunit *test,
+	unsigned long start, unsigned long end, unsigned int nr_pieces)
+{
+	struct damon_target *t = damon_new_target(42);
+	struct damon_region *r = damon_new_region(start, end);
+	unsigned long expected_width = (end - start) / nr_pieces;
+	unsigned long i = 0;
 
-	t = damon_new_target(42);
-	r = damon_new_region(5, 59);
 	damon_add_region(r, t);
-	KUNIT_EXPECT_EQ(test, damon_va_evenly_split_region(t, r, 5), 0);
-	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 5u);
+	KUNIT_EXPECT_EQ(test,
+			damon_va_evenly_split_region(t, r, nr_pieces), 0);
+	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), nr_pieces);
 
-	i = 0;
 	damon_for_each_region(r, t) {
-		if (i == 4)
+		if (i == nr_pieces - 1)
 			break;
-		KUNIT_EXPECT_EQ(test, r->ar.start, 5 + 10 * i++);
-		KUNIT_EXPECT_EQ(test, r->ar.end, 5 + 10 * i);
+		KUNIT_EXPECT_EQ(test,
+				r->ar.start, start + i++ * expected_width);
+		KUNIT_EXPECT_EQ(test, r->ar.end, start + i * expected_width);
 	}
-	KUNIT_EXPECT_EQ(test, r->ar.start, 5 + 10 * i);
-	KUNIT_EXPECT_EQ(test, r->ar.end, 59ul);
+	KUNIT_EXPECT_EQ(test, r->ar.start, start + i * expected_width);
+	KUNIT_EXPECT_EQ(test, r->ar.end, end);
 	damon_free_target(t);
+}
 
-	t = damon_new_target(42);
-	r = damon_new_region(5, 6);
-	damon_add_region(r, t);
-	KUNIT_EXPECT_EQ(test, damon_va_evenly_split_region(t, r, 2), -EINVAL);
-	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 1u);
+static void damon_test_split_evenly(struct kunit *test)
+{
+	struct damon_ctx *c = damon_new_ctx();
+
+	KUNIT_EXPECT_EQ(test, damon_va_evenly_split_region(NULL, NULL, 5),
+			-EINVAL);
+
+	damon_test_split_evenly_fail(test, 0, 100, 0);
+	damon_test_split_evenly_succ(test, 0, 100, 10);
+	damon_test_split_evenly_succ(test, 5, 59, 5);
+	damon_test_split_evenly_fail(test, 5, 6, 2);
 
-	damon_for_each_region(r, t) {
-		KUNIT_EXPECT_EQ(test, r->ar.start, 5ul);
-		KUNIT_EXPECT_EQ(test, r->ar.end, 6ul);
-	}
-	damon_free_target(t);
 	damon_destroy_ctx(c);
 }
 


