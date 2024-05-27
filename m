Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49365168C4;
	Mon, 27 May 2024 19:23:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837804; cv=none; b=qsqYhURLTNorV8Mim99Um1iVmg6CIbL9ZNuqrs+n+zeFQH7BBCy6/0VACYP2qpAhBJmSU0LXePypBEBIrlw63pnTyCmQ4Ft00VCdbrsZdDJinbgwnVHixMYOuxdXX/6NI4Yqk3n3Xyov9DzWDx5hsKyOQ3WxUxogYZgF5acpL64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837804; c=relaxed/simple;
	bh=TuWxy1FFIiiuUYzb41eQ7txirMqpyFQKs9ppDZiYcnw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QV/EN0WhmfnCQk6oUk4R3v8fgC92niG9LYy93ax30yIfF4glGz/0yZ4BkpQzjPMXM/WFnxjN6kXpGzW0YFpU4ALkUVsSrFYLaohkTiPiL9MiaMAG7tM4cwi3NikZuUQGJQbSFfIZZBOQ9uSR5uoMrLV1TXKsIJXj171bh+6xAnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f2AS+OKc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f2AS+OKc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D735BC2BBFC;
	Mon, 27 May 2024 19:23:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837804;
	bh=TuWxy1FFIiiuUYzb41eQ7txirMqpyFQKs9ppDZiYcnw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f2AS+OKcF/4+aqbXZNq/2GU37RFtcAP/0wIoTBBbldkhgp6VOlq/Ec/h76Xpc1l5r
	 4wK0wzhGq3FADzaMT5whjlZEWR1JwogWEWamshclKmpd5G2Y2TkwYuNjWB4r2Mr2+S
	 D4tu61mcGXscAfOX0chWAuKVDG9Yao8BjMX/Icjw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kees Cook <keescook@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 151/493] kunit/fortify: Fix mismatched kvalloc()/vfree() usage
Date: Mon, 27 May 2024 20:52:33 +0200
Message-ID: <20240527185635.368514130@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <keescook@chromium.org>

[ Upstream commit 998b18072ceb0613629c256b409f4d299829c7ec ]

The kv*() family of tests were accidentally freeing with vfree() instead
of kvfree(). Use kvfree() instead.

Fixes: 9124a2640148 ("kunit/fortify: Validate __alloc_size attribute results")
Link: https://lore.kernel.org/r/20240425230619.work.299-kees@kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/fortify_kunit.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/lib/fortify_kunit.c b/lib/fortify_kunit.c
index 2e4fedc816210..7830a9e64ead7 100644
--- a/lib/fortify_kunit.c
+++ b/lib/fortify_kunit.c
@@ -229,28 +229,28 @@ DEFINE_ALLOC_SIZE_TEST_PAIR(vmalloc)
 									\
 	checker((expected_pages) * PAGE_SIZE,				\
 		kvmalloc((alloc_pages) * PAGE_SIZE, gfp),		\
-		vfree(p));						\
+		kvfree(p));						\
 	checker((expected_pages) * PAGE_SIZE,				\
 		kvmalloc_node((alloc_pages) * PAGE_SIZE, gfp, NUMA_NO_NODE), \
-		vfree(p));						\
+		kvfree(p));						\
 	checker((expected_pages) * PAGE_SIZE,				\
 		kvzalloc((alloc_pages) * PAGE_SIZE, gfp),		\
-		vfree(p));						\
+		kvfree(p));						\
 	checker((expected_pages) * PAGE_SIZE,				\
 		kvzalloc_node((alloc_pages) * PAGE_SIZE, gfp, NUMA_NO_NODE), \
-		vfree(p));						\
+		kvfree(p));						\
 	checker((expected_pages) * PAGE_SIZE,				\
 		kvcalloc(1, (alloc_pages) * PAGE_SIZE, gfp),		\
-		vfree(p));						\
+		kvfree(p));						\
 	checker((expected_pages) * PAGE_SIZE,				\
 		kvcalloc((alloc_pages) * PAGE_SIZE, 1, gfp),		\
-		vfree(p));						\
+		kvfree(p));						\
 	checker((expected_pages) * PAGE_SIZE,				\
 		kvmalloc_array(1, (alloc_pages) * PAGE_SIZE, gfp),	\
-		vfree(p));						\
+		kvfree(p));						\
 	checker((expected_pages) * PAGE_SIZE,				\
 		kvmalloc_array((alloc_pages) * PAGE_SIZE, 1, gfp),	\
-		vfree(p));						\
+		kvfree(p));						\
 									\
 	prev_size = (expected_pages) * PAGE_SIZE;			\
 	orig = kvmalloc(prev_size, gfp);				\
-- 
2.43.0



