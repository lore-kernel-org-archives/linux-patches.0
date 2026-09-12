Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32416414A1D;
	Sat, 12 Sep 2026 08:38:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202328; cv=none; b=VuiPe/v1r5quruuYGHl6TNzx+R04/wFVjFajjd+3wVdk32FNNmsOMEJzO8zroIIAgZmrxXr2wX/4FicFHt/96L8CIIIWRZjdp6jYBg/JO/4kgobpTybjYqYNLjIvLbtcviIgnSh2HLmkXyILQ4rMOSbeP2dt3iMsE1gBanNfkdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202328; c=relaxed/simple;
	bh=0z79+DYw+D/mUvESzXNUG0OoPKLJNCNPJarX4Tb1XSs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EJR1fXDzcET26IOLSYe6hjEQztw977DE6QkLbM3pD2thAYgrOILsqhFoSNgKteo+O+TOe2y+3jlo7+0T6GdflgyZykLYWUcWrGycuxISrbxVS+4cfntQgOwHwkGUFy8JOyC8RyhiDCU9NRBDtS0UYa/JLsEAX72GATkvPYSvXMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M0waO29s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M0waO29s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD8C11F00893;
	Sat, 12 Sep 2026 08:38:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789202327;
	bh=o91Mmdx2lZt++Vrk/YCz2L8HioiWOHA4ixEG8xp1kxk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M0waO29sujxUgxrse8DkzMRttBb+eOnxgBZ5ljubNM1YX5iFm6kHQHEm5zBqBB4sF
	 /1r1mXGPX3OyRIu7stKgt2jsVqSsdKEutmqxwYE7vjCc05c6rYwuWBRNndyzuyCzCJ
	 w+c4zxI2yt9IUw66xxPmNT8ZXWeTjiXgBj5zvlFM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Usama Anjum <usama.anjum@arm.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1179/1815] selftests/mm: unpoison pages in memory-failure teardown
Date: Sat, 12 Sep 2026 08:48:49 +0200
Message-ID: <20260912065716.693779543@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

From: Muhammad Usama Anjum <usama.anjum@arm.com>

[ Upstream commit 288058d8db5d35623228d84f48d9bea3707d5c85 ]

The memory-failure tests call cleanup() only after all result checks.  A
failed ASSERT_* invokes fixture teardown and aborts the test, so it skips
cleanup() and leaves the injected page hardware-poisoned.

Invoke cleanup() from FIXTURE_TEARDOWN() instead.  Guard it with
self->injection_attempted so tests that exit before injection do not try
to unpoison a page when no injection was attempted.  Injection can poison
a page before returning an error or delivering SIGBUS, so teardown must
clean up after every injection attempt.  This runs the existing HWPoison
and HardwareCorrupted checks on both normal and assertion-failure paths.

Link: https://lore.kernel.org/20260729091127.1001179-1-usama.anjum@arm.com
Fixes: ff4ef2fbd101 ("selftests/mm: add memory failure anonymous page test")
Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/mm/memory-failure.c | 44 ++++++++++-----------
 1 file changed, 22 insertions(+), 22 deletions(-)

diff --git a/tools/testing/selftests/mm/memory-failure.c b/tools/testing/selftests/mm/memory-failure.c
index 032ed952057c6..1a5a32e22cce2 100644
--- a/tools/testing/selftests/mm/memory-failure.c
+++ b/tools/testing/selftests/mm/memory-failure.c
@@ -46,7 +46,7 @@ FIXTURE(memory_failure)
 	unsigned long pfn;
 	int pagemap_fd;
 	int kpageflags_fd;
-	bool triggered;
+	bool injection_attempted;
 };
 
 FIXTURE_VARIANT(memory_failure)
@@ -122,13 +122,6 @@ static void teardown_sighandler(void)
 	sigaction(SIGBUS, &sa, NULL);
 }
 
-FIXTURE_TEARDOWN(memory_failure)
-{
-	close(self->kpageflags_fd);
-	close(self->pagemap_fd);
-	teardown_sighandler();
-}
-
 static void prepare(struct __test_metadata *_metadata, FIXTURE_DATA(memory_failure) * self,
 		    void *vaddr)
 {
@@ -200,8 +193,7 @@ static void check(struct __test_metadata *_metadata, FIXTURE_DATA(memory_failure
 	ASSERT_EQ(pfn_flags & KPF_HWPOISON, KPF_HWPOISON);
 }
 
-static void cleanup(struct __test_metadata *_metadata, FIXTURE_DATA(memory_failure) * self,
-		    void *vaddr)
+static void cleanup(struct __test_metadata *_metadata, FIXTURE_DATA(memory_failure) * self)
 {
 	unsigned long size;
 	uint64_t pfn_flags;
@@ -217,6 +209,20 @@ static void cleanup(struct __test_metadata *_metadata, FIXTURE_DATA(memory_failu
 	ASSERT_EQ(size, self->corrupted_size);
 }
 
+FIXTURE_TEARDOWN(memory_failure)
+{
+	/*
+	 * Injection may poison the page before failing or delivering SIGBUS, so
+	 * clean up after every injection attempt.
+	 */
+	if (self->injection_attempted)
+		cleanup(_metadata, self);
+
+	close(self->kpageflags_fd);
+	close(self->pagemap_fd);
+	teardown_sighandler();
+}
+
 TEST_F(memory_failure, anon)
 {
 	char *addr;
@@ -231,8 +237,8 @@ TEST_F(memory_failure, anon)
 	prepare(_metadata, self, addr);
 
 	ret = sigsetjmp(signal_jmp_buf, 1);
-	if (!self->triggered) {
-		self->triggered = true;
+	if (!self->injection_attempted) {
+		self->injection_attempted = true;
 		ASSERT_EQ(variant->inject(self, addr), 0);
 		FORCE_READ(*addr);
 	}
@@ -242,8 +248,6 @@ TEST_F(memory_failure, anon)
 	else
 		check(_metadata, self, addr, MADV_SOFT_ANON, ret);
 
-	cleanup(_metadata, self, addr);
-
 	ASSERT_EQ(munmap(addr, self->page_size), 0);
 }
 
@@ -296,8 +300,8 @@ TEST_F(memory_failure, clean_pagecache)
 	prepare(_metadata, self, addr);
 
 	ret = sigsetjmp(signal_jmp_buf, 1);
-	if (!self->triggered) {
-		self->triggered = true;
+	if (!self->injection_attempted) {
+		self->injection_attempted = true;
 		ASSERT_EQ(variant->inject(self, addr), 0);
 		FORCE_READ(*addr);
 	}
@@ -307,8 +311,6 @@ TEST_F(memory_failure, clean_pagecache)
 	else
 		check(_metadata, self, addr, MADV_SOFT_CLEAN_PAGECACHE, ret);
 
-	cleanup(_metadata, self, addr);
-
 	ASSERT_EQ(munmap(addr, self->page_size), 0);
 
 	ASSERT_EQ(close(fd), 0);
@@ -337,8 +339,8 @@ TEST_F(memory_failure, dirty_pagecache)
 	prepare(_metadata, self, addr);
 
 	ret = sigsetjmp(signal_jmp_buf, 1);
-	if (!self->triggered) {
-		self->triggered = true;
+	if (!self->injection_attempted) {
+		self->injection_attempted = true;
 		ASSERT_EQ(variant->inject(self, addr), 0);
 		FORCE_READ(*addr);
 	}
@@ -348,8 +350,6 @@ TEST_F(memory_failure, dirty_pagecache)
 	else
 		check(_metadata, self, addr, MADV_SOFT_DIRTY_PAGECACHE, ret);
 
-	cleanup(_metadata, self, addr);
-
 	ASSERT_EQ(munmap(addr, self->page_size), 0);
 
 	ASSERT_EQ(close(fd), 0);
-- 
2.53.0



