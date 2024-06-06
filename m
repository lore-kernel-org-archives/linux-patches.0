Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1F631A0DEA;
	Thu,  6 Jun 2024 14:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683174; cv=none; b=tFcH+XbpWp/imx6NAWjojFY0mcE5TYyan0ePVELTCQfBH0LbO1HPELEOFSNbwgxwQoMADGaXKyYY6HODjbMlFbDlRDRWH4SLLo7Ls3ZiIMAmRLgAk+nhCO4YcMP+AuuEqLzb9qcy4SVfZcJs8RD/oPdY22K/p664npXU6Z8zFr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683174; c=relaxed/simple;
	bh=bXfKrkmVA0KnT/NF+KADiHOu4etp9CMHHMaStWuMIy4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZtLW0hNnhJk3FhdTuaKcYrX/e7AI7V5e62WBvsK6mkwJA6qri+pqLIJAg3pk90ltY0N0eu9456C/2kmKXffrrdHntqQHBgT05LcOtlfDSzjsyPgLGCPncxevYBd1pvz8DAE335q0SLEwvyWkum7II3PpZkIc5he02OOgSP7nUzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BZuDakru; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BZuDakru"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3A82C4AF07;
	Thu,  6 Jun 2024 14:12:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683173;
	bh=bXfKrkmVA0KnT/NF+KADiHOu4etp9CMHHMaStWuMIy4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BZuDakruAArR/6zJj6Mvwf7gXnMXWLOm3OePMk6+WS7BTPyaQNTXt8YNDDze8UyvX
	 iZZ9xJSmllZQiGdJdg04H3Wem/s+lhFlembGUdLWGVtnPWnKFUdoLVQPLQJmMiDJgi
	 K6zOZxNPu89/8rTA78hUCQBQytRXldfrvwtNY29Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kees Cook <keescook@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 118/744] kunit/fortify: Fix mismatched kvalloc()/vfree() usage
Date: Thu,  6 Jun 2024 15:56:30 +0200
Message-ID: <20240606131736.197403565@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index c8c33cbaae9ec..24f8d6fda2b3b 100644
--- a/lib/fortify_kunit.c
+++ b/lib/fortify_kunit.c
@@ -228,28 +228,28 @@ DEFINE_ALLOC_SIZE_TEST_PAIR(vmalloc)
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



