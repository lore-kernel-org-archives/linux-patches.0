Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF34736CE0F;
	Tue,  6 Jan 2026 17:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722328; cv=none; b=AuFBNRyfLFnhyYdAts9grlxHBInBRVSqeknrvk7SelMxTB75cnkjqbgCeAjCHu6yobOSh9IVNJEZ38mfZOc7F3KWCXFXbwWAafBTw5JaJsW4PBfds+8GYtTENmQcEIU+jOlboEyBPHWSZ56rNY0GeogqfbtAfzVaCbF98Y+JFWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722328; c=relaxed/simple;
	bh=3VR2kB/vGy3xzND3OFV9RkCM0A/ijs+NEMFYyLmskFU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U+aJJb3RouJlYT4O8O4YWlTPqzTwn7M9MDvukbI3JHZibADuKSy0kHhAWtaSEYn8d2zBsgPrHd1Dr8Gj65+T1SxIgOt+c1u0E00zgebUa4H1Ap9xVdxFPBX3zp+SOz24hCeKjKPBLj5rfSxtAtA/ypIDQlTAwmHXZ2OUcBHkU8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zqwoy5oA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zqwoy5oA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57E07C116C6;
	Tue,  6 Jan 2026 17:58:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767722327;
	bh=3VR2kB/vGy3xzND3OFV9RkCM0A/ijs+NEMFYyLmskFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zqwoy5oAKS1PhYoIUfqLtOfR/en4qsa5MlHte4tvCCrGXiJen91uNFNHDa2OZfOJW
	 g8G0E3Ghpm0TMd9bEGHfYO0JrKANTtFjjBnKqLiyjDTrghOEbRN6NL4HYzSS1+puWO
	 VfXLTdFoSJlbdnZVrvMT5wI4fba2GwvMPfVnp7eE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@google.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 199/312] mm/damon/tests/vaddr-kunit: handle alloc failures on damon_do_test_apply_three_regions()
Date: Tue,  6 Jan 2026 18:04:33 +0100
Message-ID: <20260106170555.026895444@linuxfoundation.org>
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

commit 2b22d0fcc6320ba29b2122434c1d2f0785fb0a25 upstream.

damon_do_test_apply_three_regions() is assuming all dynamic memory
allocation in it will succeed.  Those are indeed likely in the real use
cases since those allocations are too small to fail, but theoretically
those could fail.  In the case, inappropriate memory access can happen.
Fix it by appropriately cleanup pre-allocated memory and skip the
execution of the remaining tests in the failure cases.

Link: https://lkml.kernel.org/r/20251101182021.74868-18-sj@kernel.org
Fixes: 17ccae8bb5c9 ("mm/damon: add kunit tests")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: <stable@vger.kernel.org>	[5.15+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/tests/vaddr-kunit.h |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/mm/damon/tests/vaddr-kunit.h
+++ b/mm/damon/tests/vaddr-kunit.h
@@ -136,8 +136,14 @@ static void damon_do_test_apply_three_re
 	int i;
 
 	t = damon_new_target();
+	if (!t)
+		kunit_skip(test, "target alloc fail");
 	for (i = 0; i < nr_regions / 2; i++) {
 		r = damon_new_region(regions[i * 2], regions[i * 2 + 1]);
+		if (!r) {
+			damon_destroy_target(t, NULL);
+			kunit_skip(test, "region alloc fail");
+		}
 		damon_add_region(r, t);
 	}
 


