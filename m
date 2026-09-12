Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80FB33F9F50;
	Sat, 12 Sep 2026 15:58:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789228698; cv=none; b=nB6TGSAZmpdCm8+FFWtfT8R18OXrj4d6ueaAgFmHreeGoXD/utyZRMF/maFTWtONKrJiauQDEtFY829vn6jpYK8MC1HGwFOzG2/PmjUonZnbYhrK7KQaW/jNn+Lb5EJYZ5DiKxW/JojWArzISIQyQ92iyUNQ4fW3g9WJwkmrk+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789228698; c=relaxed/simple;
	bh=B1S7SZr9Cdwp7N2QLIDI+GP73P9g1g8jlJeJ9lUkX/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EOi2VfHCYKKn9njkaWUn7JUzyfdE9BDc13CAyyOLfopM0r3tg4NL730/ukzFJdHaNnshqfAtIaIFyp5sbG1xi2rUDHim1qHliAKwIfvEg22TFIj9NLkun0FAI6PD2bC3s6jhYuoz/AiPsB+0Mh4iAAYHufgIqC3OZjSyfgoP3RA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GFCX4ogd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GFCX4ogd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33D701F00893;
	Sat, 12 Sep 2026 15:58:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789228697;
	bh=TALiVRu4BH/p8McwUPqZ1rKzYOyJXaDjs/0y+9yu+z0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GFCX4ogdRA2syGfiBJ04VBUOy/lEv1zjkdkDcN6eCfYGRphALP1jmka0dTqU4jUaT
	 tPCbFfk97rPyb0SuY3k9ZMpTBdsgOULhkVOnMG3kppm5j0doCpY4yJa8fkFRTPseF5
	 S0jBLjil2lwtWFDyp4jKLRT6O6bFuIGWRZ2sDxN8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SJ Park <sj@kernel.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0438/1191] mm/damon/vaddr-kunit: check region count in three_regions test
Date: Sat, 12 Sep 2026 08:52:46 +0200
Message-ID: <20260912065558.071993207@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: SJ Park <sj@kernel.org>

[ Upstream commit 5fea07e460874c8c7cf00f728efbe22abc62c8d8 ]

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
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/damon/vaddr-test.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/mm/damon/vaddr-test.h b/mm/damon/vaddr-test.h
index dda3c186ffefe..bed92599e9782 100644
--- a/mm/damon/vaddr-test.h
+++ b/mm/damon/vaddr-test.h
@@ -141,12 +141,17 @@ static void damon_do_test_apply_three_regions(struct kunit *test,
 
 	damon_set_regions(t, three_regions, 3);
 
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
 	damon_destroy_target(t);
 }
 
-- 
2.53.0



