Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76FA5468C2C;
	Wed,  9 Sep 2026 13:50:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788961822; cv=none; b=gdofN2PH2DHYZn7RssROr3nc3vYz8uy2ZOOe8hBUn6ub6GSd18TBIXxkohzzhf7utW862lBmYEXM6dD5i+iNGIrGzhI7CaTSVCjzK7I4uZwWJ4OFIzBn5rREqj80hREdmHGJCgxaljsJrPtrtcP57HrTcLJBqZ7WSGA6AkwpXeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788961822; c=relaxed/simple;
	bh=48bU9hnoA6DplFsZLEuW8IFWx0sex0nRtjbkw8LD1GE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R1TM6uR7JpS/+WbtXq72uCVbQQBJreaw1Dsj6+j+/HBvHTrLjmHyGQI/P0bZTg00Qmw2LTCFcxIuzGY5+DTnhG1h5yiZf7s2yi89bB9C7jEAXdIkTKERYyiJ/+QdP2QGgdQap3KGRhm6UDt7Ekt0dkpHINv7TN5sIduH+Xvwl/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fAOPr7ld; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fAOPr7ld"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D116F1F00A3A;
	Wed,  9 Sep 2026 13:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788961820;
	bh=DZBpsvQt5GMoYiSE16jeHw3PtAee6p1rSNRYYtie9cY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fAOPr7ld7f9IEphC0qF3OPVkalUSrvJcbr5OKeVmcAveG4I+GY003jL4wU6cK3ddC
	 BgwSg0xfshtxTOfRrXK5WoXlpA9SyyOQlF2Z48kDM2Wayes0Ez/Ynp74JYJufwYPSo
	 RGgLS51RqINMfo1XfS0tS4rsYOqcIN+MgWtgQlmI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SJ Park <sj@kernel.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7.2 076/556] mm/damon/vaddr-kunit: check region count in three_regions test
Date: Wed,  9 Sep 2026 15:35:56 +0200
Message-ID: <20260909134233.170787593@linuxfoundation.org>
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
@@ -158,12 +158,17 @@ static void damon_do_test_apply_three_re
 		kunit_skip(test, "second damon_set_regions() fail");
 	}
 
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
 


