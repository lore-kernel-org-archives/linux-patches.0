Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F7611DE3C1;
	Tue,  8 Oct 2024 12:13:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728389636; cv=none; b=g91GsVxndNIxWi1ofdoMjcXmyELXS/FyA8qCCI4ABnnKejA8yiDXaJCOkAwLTL/RuNG5X6Nuhqinbdl6BvmMaZ6920ADySQ2Pf5p//OauHrcthZVKpxk5bzehaAv/+2y6GwHcZ+08+jWOsy0pf17479xt20n9t6bMiCk64TFDyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728389636; c=relaxed/simple;
	bh=9FJcBzhpwps6JLy1gSV0qgFSnbc6miQNSOsyb8V4oCE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rKRYdt8veMNsnict6gqIws3B3bh56vjhfejZqnZTxBkrNDrXoiSUG29Ppuu2ccvEgojgwzZi3X9hiI/awDKAX4m++LX6chO5RaznS9Ffiv8cl8+lV1+ewaTFp9XfXCKHBMYjvqmYORXU+CJ8CY5SYjuKD1IS4gkXpc1ZCdee9U8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TiXP2ApJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TiXP2ApJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 630C0C4CEC7;
	Tue,  8 Oct 2024 12:13:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728389636;
	bh=9FJcBzhpwps6JLy1gSV0qgFSnbc6miQNSOsyb8V4oCE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TiXP2ApJ5OW93ygrZkmzaYqO/ISGVYpLWbUASj40PGZlyZBvhpLGCwqopGqC7jG5x
	 uMg1MRGOdfySp7UHBBuF0nDQONyBq3c96PC11EhFwHQhfUp1KtX0SeVL9a4HHwRfHy
	 axoLiydjqysIqyzx1Y35wDYBuRg8o/iHXnXjet3Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Xu <jeffxu@chromium.org>,
	Pedro Falcato <pedro.falcato@gmail.com>,
	Dave Hansen <dave.hansen@intel.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 050/482] selftest mm/mseal: fix test_seal_mremap_move_dontunmap_anyaddr
Date: Tue,  8 Oct 2024 14:01:53 +0200
Message-ID: <20241008115650.274712296@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Xu <jeffxu@chromium.org>

[ Upstream commit 072cd213b75eb01fcf40eff898f8d5c008ce1457 ]

the syscall remap accepts following:

mremap(src, size, size, MREMAP_MAYMOVE | MREMAP_DONTUNMAP, dst)

when the src is sealed, the call will fail with error code:
EPERM

Previously, the test uses hard-coded 0xdeaddead as dst, and it
will fail on the system with newer glibc installed.

This patch removes test's dependency on glibc for mremap(), also
fix the test and remove the hardcoded address.

Link: https://lkml.kernel.org/r/20240807212320.2831848-1-jeffxu@chromium.org
Fixes: 4926c7a52de7 ("selftest mm/mseal memory sealing")
Signed-off-by: Jeff Xu <jeffxu@chromium.org>
Reported-by: Pedro Falcato <pedro.falcato@gmail.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/mm/mseal_test.c | 57 ++++++++++++++++---------
 1 file changed, 36 insertions(+), 21 deletions(-)

diff --git a/tools/testing/selftests/mm/mseal_test.c b/tools/testing/selftests/mm/mseal_test.c
index 09faffbc3d87c..43e6d0c53fe4c 100644
--- a/tools/testing/selftests/mm/mseal_test.c
+++ b/tools/testing/selftests/mm/mseal_test.c
@@ -146,6 +146,16 @@ static int sys_madvise(void *start, size_t len, int types)
 	return sret;
 }
 
+static void *sys_mremap(void *addr, size_t old_len, size_t new_len,
+	unsigned long flags, void *new_addr)
+{
+	void *sret;
+
+	errno = 0;
+	sret = (void *) syscall(__NR_mremap, addr, old_len, new_len, flags, new_addr);
+	return sret;
+}
+
 static int sys_pkey_alloc(unsigned long flags, unsigned long init_val)
 {
 	int ret = syscall(__NR_pkey_alloc, flags, init_val);
@@ -1151,12 +1161,12 @@ static void test_seal_mremap_shrink(bool seal)
 	}
 
 	/* shrink from 4 pages to 2 pages. */
-	ret2 = mremap(ptr, size, 2 * page_size, 0, 0);
+	ret2 = sys_mremap(ptr, size, 2 * page_size, 0, 0);
 	if (seal) {
-		FAIL_TEST_IF_FALSE(ret2 == MAP_FAILED);
+		FAIL_TEST_IF_FALSE(ret2 == (void *) MAP_FAILED);
 		FAIL_TEST_IF_FALSE(errno == EPERM);
 	} else {
-		FAIL_TEST_IF_FALSE(ret2 != MAP_FAILED);
+		FAIL_TEST_IF_FALSE(ret2 != (void *) MAP_FAILED);
 
 	}
 
@@ -1183,7 +1193,7 @@ static void test_seal_mremap_expand(bool seal)
 	}
 
 	/* expand from 2 page to 4 pages. */
-	ret2 = mremap(ptr, 2 * page_size, 4 * page_size, 0, 0);
+	ret2 = sys_mremap(ptr, 2 * page_size, 4 * page_size, 0, 0);
 	if (seal) {
 		FAIL_TEST_IF_FALSE(ret2 == MAP_FAILED);
 		FAIL_TEST_IF_FALSE(errno == EPERM);
@@ -1216,7 +1226,7 @@ static void test_seal_mremap_move(bool seal)
 	}
 
 	/* move from ptr to fixed address. */
-	ret2 = mremap(ptr, size, size, MREMAP_MAYMOVE | MREMAP_FIXED, newPtr);
+	ret2 = sys_mremap(ptr, size, size, MREMAP_MAYMOVE | MREMAP_FIXED, newPtr);
 	if (seal) {
 		FAIL_TEST_IF_FALSE(ret2 == MAP_FAILED);
 		FAIL_TEST_IF_FALSE(errno == EPERM);
@@ -1335,7 +1345,7 @@ static void test_seal_mremap_shrink_fixed(bool seal)
 	}
 
 	/* mremap to move and shrink to fixed address */
-	ret2 = mremap(ptr, size, 2 * page_size, MREMAP_MAYMOVE | MREMAP_FIXED,
+	ret2 = sys_mremap(ptr, size, 2 * page_size, MREMAP_MAYMOVE | MREMAP_FIXED,
 			newAddr);
 	if (seal) {
 		FAIL_TEST_IF_FALSE(ret2 == MAP_FAILED);
@@ -1366,7 +1376,7 @@ static void test_seal_mremap_expand_fixed(bool seal)
 	}
 
 	/* mremap to move and expand to fixed address */
-	ret2 = mremap(ptr, page_size, size, MREMAP_MAYMOVE | MREMAP_FIXED,
+	ret2 = sys_mremap(ptr, page_size, size, MREMAP_MAYMOVE | MREMAP_FIXED,
 			newAddr);
 	if (seal) {
 		FAIL_TEST_IF_FALSE(ret2 == MAP_FAILED);
@@ -1397,7 +1407,7 @@ static void test_seal_mremap_move_fixed(bool seal)
 	}
 
 	/* mremap to move to fixed address */
-	ret2 = mremap(ptr, size, size, MREMAP_MAYMOVE | MREMAP_FIXED, newAddr);
+	ret2 = sys_mremap(ptr, size, size, MREMAP_MAYMOVE | MREMAP_FIXED, newAddr);
 	if (seal) {
 		FAIL_TEST_IF_FALSE(ret2 == MAP_FAILED);
 		FAIL_TEST_IF_FALSE(errno == EPERM);
@@ -1426,14 +1436,13 @@ static void test_seal_mremap_move_fixed_zero(bool seal)
 	/*
 	 * MREMAP_FIXED can move the mapping to zero address
 	 */
-	ret2 = mremap(ptr, size, 2 * page_size, MREMAP_MAYMOVE | MREMAP_FIXED,
+	ret2 = sys_mremap(ptr, size, 2 * page_size, MREMAP_MAYMOVE | MREMAP_FIXED,
 			0);
 	if (seal) {
 		FAIL_TEST_IF_FALSE(ret2 == MAP_FAILED);
 		FAIL_TEST_IF_FALSE(errno == EPERM);
 	} else {
 		FAIL_TEST_IF_FALSE(ret2 == 0);
-
 	}
 
 	TEST_END_CHECK();
@@ -1456,13 +1465,13 @@ static void test_seal_mremap_move_dontunmap(bool seal)
 	}
 
 	/* mremap to move, and don't unmap src addr. */
-	ret2 = mremap(ptr, size, size, MREMAP_MAYMOVE | MREMAP_DONTUNMAP, 0);
+	ret2 = sys_mremap(ptr, size, size, MREMAP_MAYMOVE | MREMAP_DONTUNMAP, 0);
 	if (seal) {
 		FAIL_TEST_IF_FALSE(ret2 == MAP_FAILED);
 		FAIL_TEST_IF_FALSE(errno == EPERM);
 	} else {
+		/* kernel will allocate a new address */
 		FAIL_TEST_IF_FALSE(ret2 != MAP_FAILED);
-
 	}
 
 	TEST_END_CHECK();
@@ -1470,7 +1479,7 @@ static void test_seal_mremap_move_dontunmap(bool seal)
 
 static void test_seal_mremap_move_dontunmap_anyaddr(bool seal)
 {
-	void *ptr;
+	void *ptr, *ptr2;
 	unsigned long page_size = getpagesize();
 	unsigned long size = 4 * page_size;
 	int ret;
@@ -1485,24 +1494,30 @@ static void test_seal_mremap_move_dontunmap_anyaddr(bool seal)
 	}
 
 	/*
-	 * The 0xdeaddead should not have effect on dest addr
-	 * when MREMAP_DONTUNMAP is set.
+	 * The new address is any address that not allocated.
+	 * use allocate/free to similate that.
 	 */
-	ret2 = mremap(ptr, size, size, MREMAP_MAYMOVE | MREMAP_DONTUNMAP,
-			0xdeaddead);
+	setup_single_address(size, &ptr2);
+	FAIL_TEST_IF_FALSE(ptr2 != (void *)-1);
+	ret = sys_munmap(ptr2, size);
+	FAIL_TEST_IF_FALSE(!ret);
+
+	/*
+	 * remap to any address.
+	 */
+	ret2 = sys_mremap(ptr, size, size, MREMAP_MAYMOVE | MREMAP_DONTUNMAP,
+			(void *) ptr2);
 	if (seal) {
 		FAIL_TEST_IF_FALSE(ret2 == MAP_FAILED);
 		FAIL_TEST_IF_FALSE(errno == EPERM);
 	} else {
-		FAIL_TEST_IF_FALSE(ret2 != MAP_FAILED);
-		FAIL_TEST_IF_FALSE((long)ret2 != 0xdeaddead);
-
+		/* remap success and return ptr2 */
+		FAIL_TEST_IF_FALSE(ret2 ==  ptr2);
 	}
 
 	TEST_END_CHECK();
 }
 
-
 static void test_seal_merge_and_split(void)
 {
 	void *ptr;
-- 
2.43.0



