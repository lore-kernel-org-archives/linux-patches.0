Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAC735678C9;
	Wed,  9 Sep 2026 14:40:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964854; cv=none; b=PpIjxYhQRda64qRrww+Ka6EET5f66lu5OlW6hfx9epB7EOPkAH62eg28xuSs5a87m7zCNVropQx+7RG9rEthSd3TAgvWiOw5yLDImQq9FlW6e89+9cCorNbVwGJLA/Mehrw3riw8dp4QIXxQL1u/x8gEkmA6q+ZjAgyC/Lv7wDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964854; c=relaxed/simple;
	bh=qATxjjJDxGW15M31GYIuP77lLzIMzO4b6PdUhE1c/Ns=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xwkcmtu+5HTMsAZlbHeBUmyr9uwcp7fhIfMZIdP2Rqb8pe0rmTzIvXDNGYKeXb6947oE7HQ5jJGBUiy2r36IzI+73ytbINjNIgTJPNYfLWDQ7MWIVcjNo5hN43HV03YsyTp/ZoFadEvqdHZ2v2Whp69yP4o9EEWnmBmkchGzdzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m/38W81b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m/38W81b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DB641F00A3A;
	Wed,  9 Sep 2026 14:40:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964852;
	bh=Dr9wc+7vR8BVoh/7XZrEEkzFg845VuEYczDF3MMsSZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m/38W81bJ8ARHj1vnz2qirmYkOp0h1LziXqqYjjT5LVKP6uBQLzVmC5Nwa4MKauNc
	 JwsZK77wmsn7CvpniRK3ueLMPfYBo0Qc4dEdw1PC6WqZ9e0LZbRdpJzaxZ78nCwxZP
	 +GQg/QJx4o2lcgnCdppMxGn0tyyqxQoVBQRnVbws=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 567/583] mm/damon/tests/core-kunit: catch test failure in test_merge_regions_of()
Date: Wed,  9 Sep 2026 15:44:12 +0200
Message-ID: <20260909134257.301911836@linuxfoundation.org>
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
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/tests/core-kunit.h |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -269,11 +269,14 @@ static void damon_test_merge_regions_of(
 	damon_merge_regions_of(t, 9, 9999);
 	/* 0-112, 114-130, 130-156, 156-170 */
 	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 5u);
+	if (damon_nr_regions(t) != 5)
+		goto out;
 	for (i = 0; i < 5; i++) {
 		r = __nth_region_of(t, i);
 		KUNIT_EXPECT_EQ(test, r->ar.start, saddrs[i]);
 		KUNIT_EXPECT_EQ(test, r->ar.end, eaddrs[i]);
 	}
+out:
 	damon_free_target(t);
 }
 


