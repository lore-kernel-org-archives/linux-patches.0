Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 418F715FCFB;
	Mon, 27 May 2024 19:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836521; cv=none; b=l5icptpz3HF7ZBfkiZ5crVn/i95kV+Pq3By+nfEeeD+HrTgZyxRtL6+8TkIHFmgzhFB4Xl2rXRrQUZOvr2R2Px06+l7Y7mTmBIcOp0Aos+GHZqJ904xW2NCLsJ/1oQupXinSL8wpSZ4m5tMfNBPFuA1j5ZtgkIQzm4PeNI6zOl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836521; c=relaxed/simple;
	bh=+QUpV39nzMPafkA6/M9FOAz33uiI3J7WriqZjqR71f0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tu9XMCrHURuiaEUnivlMZ7O1+1vQ08ZY6RkInf8LrwraqOLshgEh/qd1PofTctRrZfTZ2PzOL70NQ5DpTKOJB2MNmwHBZhGnZwaXHdYykjaDuPqW+7DvjzWOM+YxM7nycMztYPmtVjxHhcZ50ekmRThH2xeV03mTtUpq7rA15QI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S48h1I+R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S48h1I+R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAB0CC2BBFC;
	Mon, 27 May 2024 19:02:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836521;
	bh=+QUpV39nzMPafkA6/M9FOAz33uiI3J7WriqZjqR71f0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S48h1I+RFzsnHf+tfGBIINp+TSl4nh4gK/GFlrCX8sTHOjocIQ6DSefrDjYuSqoY6
	 3hdhHpfweYOMJXUNUwyDHXPYTEirmQD7Eh3fsgw1F+DRTy2GHehWm45xMbTadnZ5VK
	 Oee8h0Jj1TqBTI6PKZOUjGKH7pAeDfOUGT3yHnOs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kees Cook <keescook@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 084/427] kunit/fortify: Fix replaced failure path to unbreak __alloc_size
Date: Mon, 27 May 2024 20:52:11 +0200
Message-ID: <20240527185609.600516232@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <keescook@chromium.org>

[ Upstream commit 74df22453c51392476117d7330bf02cee6e987cf ]

The __alloc_size annotation for kmemdup() was getting disabled under
KUnit testing because the replaced fortify_panic macro implementation
was using "return NULL" as a way to survive the sanity checking. But
having the chance to return NULL invalidated __alloc_size, so kmemdup
was not passing the __builtin_dynamic_object_size() tests any more:

[23:26:18] [PASSED] fortify_test_alloc_size_kmalloc_const
[23:26:19]     # fortify_test_alloc_size_kmalloc_dynamic: EXPECTATION FAILED at lib/fortify_kunit.c:265
[23:26:19]     Expected __builtin_dynamic_object_size(p, 1) == expected, but
[23:26:19]         __builtin_dynamic_object_size(p, 1) == -1 (0xffffffffffffffff)
[23:26:19]         expected == 11 (0xb)
[23:26:19] __alloc_size() not working with __bdos on kmemdup("hello there", len, gfp)
[23:26:19] [FAILED] fortify_test_alloc_size_kmalloc_dynamic

Normal builds were not affected: __alloc_size continued to work there.

Use a zero-sized allocation instead, which allows __alloc_size to
behave.

Fixes: 4ce615e798a7 ("fortify: Provide KUnit counters for failure testing")
Fixes: fa4a3f86d498 ("fortify: Add KUnit tests for runtime overflows")
Link: https://lore.kernel.org/r/20240501232937.work.532-kees@kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/fortify-string.h | 3 ++-
 lib/fortify_kunit.c            | 6 +++---
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/include/linux/fortify-string.h b/include/linux/fortify-string.h
index 6aeebe0a67770..6eaa190d0083c 100644
--- a/include/linux/fortify-string.h
+++ b/include/linux/fortify-string.h
@@ -734,7 +734,8 @@ __FORTIFY_INLINE void *kmemdup(const void * const POS0 p, size_t size, gfp_t gfp
 	if (__compiletime_lessthan(p_size, size))
 		__read_overflow();
 	if (p_size < size)
-		fortify_panic(FORTIFY_FUNC_kmemdup, FORTIFY_READ, p_size, size, NULL);
+		fortify_panic(FORTIFY_FUNC_kmemdup, FORTIFY_READ, p_size, size,
+			      __real_kmemdup(p, 0, gfp));
 	return __real_kmemdup(p, size, gfp);
 }
 
diff --git a/lib/fortify_kunit.c b/lib/fortify_kunit.c
index 86c1b1a6e2c89..fdba0eaf19a59 100644
--- a/lib/fortify_kunit.c
+++ b/lib/fortify_kunit.c
@@ -917,19 +917,19 @@ static void kmemdup_test(struct kunit *test)
 
 	/* Out of bounds by 1 byte. */
 	copy = kmemdup(src, len + 1, GFP_KERNEL);
-	KUNIT_EXPECT_NULL(test, copy);
+	KUNIT_EXPECT_PTR_EQ(test, copy, ZERO_SIZE_PTR);
 	KUNIT_EXPECT_EQ(test, fortify_read_overflows, 1);
 	kfree(copy);
 
 	/* Way out of bounds. */
 	copy = kmemdup(src, len * 2, GFP_KERNEL);
-	KUNIT_EXPECT_NULL(test, copy);
+	KUNIT_EXPECT_PTR_EQ(test, copy, ZERO_SIZE_PTR);
 	KUNIT_EXPECT_EQ(test, fortify_read_overflows, 2);
 	kfree(copy);
 
 	/* Starting offset causing out of bounds. */
 	copy = kmemdup(src + 1, len, GFP_KERNEL);
-	KUNIT_EXPECT_NULL(test, copy);
+	KUNIT_EXPECT_PTR_EQ(test, copy, ZERO_SIZE_PTR);
 	KUNIT_EXPECT_EQ(test, fortify_read_overflows, 3);
 	kfree(copy);
 }
-- 
2.43.0



