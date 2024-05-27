Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6B9215FD04;
	Mon, 27 May 2024 19:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836505; cv=none; b=VvQPX+PfYaUh4DkIyAYBzE3pqeFeNqL6tw00QknsbiR4aU0yQk/rfZQt6kKYLQmuhIPPdxQwKWBXbzSOjnkBlYTiH2izwg+Yw/d5yCCi5vVn9l84/RM0A2sTObnkaC6gdOsDkBY2YkGYPGkoXRf59fpXXNio3OloKH+icZinRBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836505; c=relaxed/simple;
	bh=sWh5ZgKQ7196ZJh+EThJ2MAJpJw9RgDuu4hYqXGVCwQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SDSlUi0wQPbhBQS6B7XTJALm1S1AmFnChUak0/Uk+d3c3zCx/5DZxzzt6ujXJWGnXP+OR+OzY+CfgmQ5mz48q0mKHHYyblXlBOFF+NdjfO4CvoItCguqk1G8SKkMbW89ixSEQi+OIkqOTs9avLiXYi6fYAoN12DV6HT5LWxIZiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YJZdKclu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YJZdKclu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B22FC2BBFC;
	Mon, 27 May 2024 19:01:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836505;
	bh=sWh5ZgKQ7196ZJh+EThJ2MAJpJw9RgDuu4hYqXGVCwQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YJZdKclut3C6xY/1mj3eWALnHV3hk2l5P7wumtTeo8DnT/Cgf7kuTqmnafsKsTDW7
	 a0FHEEtc5DVXbwh2U2SBuHGQSuLLeZgWtBGCd26iaUursMj3XHb0XgQBAZlSAwIAbF
	 QRbHHfREIRtlyDmKI+uOqaIoqIcWJ+dZxslqMUy0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kees Cook <keescook@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 079/427] kunit/fortify: Fix mismatched kvalloc()/vfree() usage
Date: Mon, 27 May 2024 20:52:06 +0200
Message-ID: <20240527185609.145702025@linuxfoundation.org>
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
index 493ec02dd5b32..86c1b1a6e2c89 100644
--- a/lib/fortify_kunit.c
+++ b/lib/fortify_kunit.c
@@ -267,28 +267,28 @@ DEFINE_ALLOC_SIZE_TEST_PAIR(vmalloc)
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



