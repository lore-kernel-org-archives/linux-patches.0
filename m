Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C0A71EBFE0;
	Tue, 12 Aug 2025 18:24:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023042; cv=none; b=AX6zSD7h7ZUCeOgen3zPLvR+HKS4pJfMcOi8CzyI0TQyDYndhm9CGrUV4EDFgIForVYT4Jr1BNESIdrqq8jJXaI9hKz+hAVZWDSlYbUYJcheJ1cBtciqjsoM+E34TYhopPDEe8OUHnMGyrvQNpIShQQPhYjNRZGOF5l2uFe+iJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023042; c=relaxed/simple;
	bh=qEUnqEwr9QPWDGpv1m2lR1LVBNwpPPTG6rec6G/0A/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M6xT+B6PU1BnXxI3INn3cKusYsl2wfzErtOQ35vPEEKQ1PO6xHfcQua9XkEckJlyEiK3GzDBkaYO4rtr7hXHn2HhzKLtQL0Q0KxgkRoOJVFBvk2Znba/KzpRaVMl+rrt2sPC6wOIYQCl6/Mp/eVhG6ULHsCJP0WBVi/iH1kAcBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2mVDqcHu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2mVDqcHu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D0D5C4CEF7;
	Tue, 12 Aug 2025 18:24:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023042;
	bh=qEUnqEwr9QPWDGpv1m2lR1LVBNwpPPTG6rec6G/0A/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2mVDqcHuBg/tx3qepeM62lb+t1jnkrhRDfBs64FQZ0aFvpCu2a44tg4nn4ACcQ23M
	 QeIF1ngsOHaNVCVbYYJ3rIRuJ7SwZ5K1hFWxhIEcqnSvbSAA4Bl4DF+tJ3vS3LlMo6
	 Dl6Ad3kTWsObQeysJvqeitfok5vGqexVa4+R819g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Starovoitov <ast@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Yifei Liu <yifei.l.liu@oracle.com>
Subject: [PATCH 6.12 333/369] selftests/bpf: Add a test for arena range tree algorithm
Date: Tue, 12 Aug 2025 19:30:30 +0200
Message-ID: <20250812173029.234535275@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexei Starovoitov <ast@kernel.org>

commit e58358afa84e8e271a296459d35d1715c7572013 upstream.

Add a test that verifies specific behavior of arena range tree
algorithm and adjust existing big_alloc1 test due to use
of global data in arena.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Link: https://lore.kernel.org/bpf/20241108025616.17625-3-alexei.starovoitov@gmail.com
Signed-off-by: Yifei Liu <yifei.l.liu@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/bpf/progs/verifier_arena_large.c |  110 ++++++++++++++-
 1 file changed, 108 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/bpf/progs/verifier_arena_large.c
+++ b/tools/testing/selftests/bpf/progs/verifier_arena_large.c
@@ -29,12 +29,12 @@ int big_alloc1(void *ctx)
 	if (!page1)
 		return 1;
 	*page1 = 1;
-	page2 = bpf_arena_alloc_pages(&arena, base + ARENA_SIZE - PAGE_SIZE,
+	page2 = bpf_arena_alloc_pages(&arena, base + ARENA_SIZE - PAGE_SIZE * 2,
 				      1, NUMA_NO_NODE, 0);
 	if (!page2)
 		return 2;
 	*page2 = 2;
-	no_page = bpf_arena_alloc_pages(&arena, base + ARENA_SIZE,
+	no_page = bpf_arena_alloc_pages(&arena, base + ARENA_SIZE - PAGE_SIZE,
 					1, NUMA_NO_NODE, 0);
 	if (no_page)
 		return 3;
@@ -66,4 +66,110 @@ int big_alloc1(void *ctx)
 #endif
 	return 0;
 }
+
+#if defined(__BPF_FEATURE_ADDR_SPACE_CAST)
+#define PAGE_CNT 100
+__u8 __arena * __arena page[PAGE_CNT]; /* occupies the first page */
+__u8 __arena *base;
+
+/*
+ * Check that arena's range_tree algorithm allocates pages sequentially
+ * on the first pass and then fills in all gaps on the second pass.
+ */
+__noinline int alloc_pages(int page_cnt, int pages_atonce, bool first_pass,
+		int max_idx, int step)
+{
+	__u8 __arena *pg;
+	int i, pg_idx;
+
+	for (i = 0; i < page_cnt; i++) {
+		pg = bpf_arena_alloc_pages(&arena, NULL, pages_atonce,
+					   NUMA_NO_NODE, 0);
+		if (!pg)
+			return step;
+		pg_idx = (pg - base) / PAGE_SIZE;
+		if (first_pass) {
+			/* Pages must be allocated sequentially */
+			if (pg_idx != i)
+				return step + 100;
+		} else {
+			/* Allocator must fill into gaps */
+			if (pg_idx >= max_idx || (pg_idx & 1))
+				return step + 200;
+		}
+		*pg = pg_idx;
+		page[pg_idx] = pg;
+		cond_break;
+	}
+	return 0;
+}
+
+//SEC("syscall")
+//__success __retval(0)
+int big_alloc2(void *ctx)
+{
+	__u8 __arena *pg;
+	int i, err;
+
+	base = bpf_arena_alloc_pages(&arena, NULL, 1, NUMA_NO_NODE, 0);
+	if (!base)
+		return 1;
+	bpf_arena_free_pages(&arena, (void __arena *)base, 1);
+
+	err = alloc_pages(PAGE_CNT, 1, true, PAGE_CNT, 2);
+	if (err)
+		return err;
+
+	/* Clear all even pages */
+	for (i = 0; i < PAGE_CNT; i += 2) {
+		pg = page[i];
+		if (*pg != i)
+			return 3;
+		bpf_arena_free_pages(&arena, (void __arena *)pg, 1);
+		page[i] = NULL;
+		cond_break;
+	}
+
+	/* Allocate into freed gaps */
+	err = alloc_pages(PAGE_CNT / 2, 1, false, PAGE_CNT, 4);
+	if (err)
+		return err;
+
+	/* Free pairs of pages */
+	for (i = 0; i < PAGE_CNT; i += 4) {
+		pg = page[i];
+		if (*pg != i)
+			return 5;
+		bpf_arena_free_pages(&arena, (void __arena *)pg, 2);
+		page[i] = NULL;
+		page[i + 1] = NULL;
+		cond_break;
+	}
+
+	/* Allocate 2 pages at a time into freed gaps */
+	err = alloc_pages(PAGE_CNT / 4, 2, false, PAGE_CNT, 6);
+	if (err)
+		return err;
+
+	/* Check pages without freeing */
+	for (i = 0; i < PAGE_CNT; i += 2) {
+		pg = page[i];
+		if (*pg != i)
+			return 7;
+		cond_break;
+	}
+
+	pg = bpf_arena_alloc_pages(&arena, NULL, 1, NUMA_NO_NODE, 0);
+
+	if (!pg)
+		return 8;
+	/*
+	 * The first PAGE_CNT pages are occupied. The new page
+	 * must be above.
+	 */
+	if ((pg - base) / PAGE_SIZE < PAGE_CNT)
+		return 9;
+	return 0;
+}
+#endif
 char _license[] SEC("license") = "GPL";


