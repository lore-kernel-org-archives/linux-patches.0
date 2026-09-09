Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9017953FD2B;
	Wed,  9 Sep 2026 13:50:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788961818; cv=none; b=Wp6xDmC8iO05aqAIraEkOVv+GougipXAbJFj1PIB9L/o1T0KJ6VNpr2SQuAx5cdBh+95tblZc8hnSkiuHKiq5KQELOGGAEik8uKUPr7RvjkBj5HZJ4hNa1DuLwGAbMQsradOqON+hy5DM0hwn62VoYzlxSodf7OKHmUDZ8LVUQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788961818; c=relaxed/simple;
	bh=pFVVr9X60kLKkiQ8n+/D+NQXXSwrCTvw2dWM93cjAeQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uuAPPJIITrF2YCsMzCO2FSHfk1ysC8WKgLaUBIayx0C7e1xKyKx0DGkfjubZHx4D23P3z/ZXM5SVPMA5gonfHgb0kx7tjazrB+EnnsIie478zrtV4bfo+RnAu/Rq926UkvYby/CBFNaJTfwNIn7fVKFNCwKJAKIXx2zpVTlAF98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kMPDshid; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kMPDshid"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E80D11F00A3A;
	Wed,  9 Sep 2026 13:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788961817;
	bh=2HqYw274e6v/X30VpkvhypS/yrlbJU9YEvxZ5gHOW+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kMPDshidJYxZjgPc90XjVzQXVjTjXelddMGeBLua0b19CJIARqWb08rmxCrng8iIA
	 Dincssj7AZSGf5fnOqq0CNbUeWIolIATv9aaNLGfyvPfaKyOCrlFyEBfuNdUoW+XTD
	 4Ax80q749ir1JCMqpPjDl8yQGGWgPUkKinN8WGBg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7.2 075/556] mm/damon/tests/core-kunit: catch test failure in test_merge_regions_of()
Date: Wed,  9 Sep 2026 15:35:55 +0200
Message-ID: <20260909134233.135930785@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: SJ Park <sj@kernel.org>

commit b640708929aa956235866bf7717d89018c661083 upstream.

KUNIT_EXPECT_EQ() does not abort the execution of test code when the
expectation is not met.  But damon_test_merge_regions_of() code after its
initial KUNIT_EXPECT_EQ() call assumes the expectation is met.  It does a
per-region test with a hard-coded number of regions that is correct only
if the expectation was met.  As a result, __nth_region_of() could return
NULL, and the test code can dereference NULL pointers.  Fix the issue by
catching the expectation failure and skip the per-region tests.

The user impact on realistic setups should be negligible, as it is a unit
test.

The issue was discovered [1] by Sashiko.

Link: https://lore.kernel.org/20260715031002.108504-3-sj@kernel.org
Link: https://lore.kernel.org/20260710144937.26981-1-sj@kernel.org [1]
Fixes: 17ccae8bb5c9 ("mm/damon: add kunit tests")
Signed-off-by: SJ Park <sj@kernel.org>
Cc: <stable@vger.kernel.org> # 5.15.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/tests/core-kunit.h |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -259,11 +259,14 @@ static void damon_test_merge_regions_of(
 	damon_merge_regions_of(t, 9, 9999);
 	/* 0-112, 114-130, 130-156, 156-170, 170-230, 230-10170 */
 	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 6u);
+	if (damon_nr_regions(t) != 6)
+		goto out;
 	for (i = 0; i < 6; i++) {
 		r = __nth_region_of(t, i);
 		KUNIT_EXPECT_EQ(test, r->ar.start, saddrs[i]);
 		KUNIT_EXPECT_EQ(test, r->ar.end, eaddrs[i]);
 	}
+out:
 	damon_free_target(t);
 }
 


