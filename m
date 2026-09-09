Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D38494DF4DC;
	Wed,  9 Sep 2026 13:50:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788961861; cv=none; b=nFxsXP/0lgNXWae+86OjawE8BBjt/sb2kkIxsANtBXI3qFPcmJkPS5q+oGAXKVfiU3H5lZL1UvQZ0C5gwY3KDTvzTbvYOVKGoty0a0fPFeBkoMkDxOI8jcCTWYsRBGPNm3IxfayCpUlqc8gYn4Hdsc+TvRM5j2s3sLTku+bzwbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788961861; c=relaxed/simple;
	bh=HFFh4w0UtEDWhU0Vzr6TNttXF/X9VaFWlOzUdXffG+w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mehWUQ4HO+wlhqgiue9TIAhCPOH2NbIeGAt8De+56cZWZmJm5JXzTDp47B28pqX0uJZXAb3bgLRRW0CyKnr61xIeni5PIDtxAfdPKEnftddnMBlpjPgqcuJH7BmgfJWJbesBn9TQMjyxwDGxbePYpMfqHvY+A1yiqzeV4iS0pMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UYDABoYD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UYDABoYD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9EF11F00A3A;
	Wed,  9 Sep 2026 13:50:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788961859;
	bh=DjoSqzU63WYuMtmAzK9lMx/ZKC2C4UzXz5VRqEI43fI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UYDABoYDz8HmysyYeMidC9Eg4kCQLe02LBOM0pLsyrEWcPA9g39spgw8vntNISVo1
	 IMgWDFmOUh/p46anG2TRlrraMxvg3wZmOwuP4VfrEmmdkBLFkT2GVm4hY9BrRbqn6k
	 ODQibXmKp7lfd9I0R5d/Axv3YiMGTLGwt1WjL4Oc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SJ Park <sj@kernel.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7.2 092/556] mm/damon/core-kunit: skip wrong dest walk in commit_dests_for()
Date: Wed,  9 Sep 2026 15:36:12 +0200
Message-ID: <20260909134233.736417011@linuxfoundation.org>
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

commit 7e2f2c41b27f64caad6599073aaa0ccdd08745e1 upstream.

damos_test_commit_dests_for() traverse damos action destinations after
damos_commit_dests().  It assumes damos_commit_dests() made expected
numbers of destinations for source and destination structures.  It might
not.  Because the traversal is made based on destination struct length, it
could do out of bounds access for source value expectation.

The consequent user impact (out-of-bound access ) is quite bad.  The
realistic user impact would be limited, though.  It would affect only test
run setups.

Fix it by exiting early for the number of regions test failure.

The issue was discovered [1] by Sashiko.

Link: https://lore.kernel.org/20260718001442.87129-6-sj@kernel.org
Link: https://lore.kernel.org/20260713144757.39740-1-sj@kernel.org [1]
Fixes: eec573b8dd65 ("mm/damon/tests/core-kunit: add damos_commit_dests() test")
Signed-off-by: SJ Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: <stable@vger.kernel.org> # 6.19.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/tests/core-kunit.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -902,6 +902,8 @@ static void damos_test_commit_dests_for(
 	skip = false;
 
 	KUNIT_EXPECT_EQ(test, dst.nr_dests, src_nr_dests);
+	if (dst.nr_dests != src_nr_dests)
+		goto out;
 	for (i = 0; i < dst.nr_dests; i++) {
 		KUNIT_EXPECT_EQ(test, dst.node_id_arr[i], src_node_id_arr[i]);
 		KUNIT_EXPECT_EQ(test, dst.weight_arr[i], src_weight_arr[i]);


