Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 389D82F12CE;
	Thu, 16 Jul 2026 14:16:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211371; cv=none; b=PWaGBvBJiX/GBtjSqojCzZEBeMEG6KJOran+heUoUHv55jXGwNyJYqoRj+E9iWA6sJ8UBRXhHVs3D/K4pAUiarSi5BERH2aGUwdU1gg1bRkaDQf4lqMYNUK/qIntsqL5jO07+9kWdEWqc463g/NTbN7H6yz7GstFY12ECRY7cqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211371; c=relaxed/simple;
	bh=jKkZfELNJszDGy0KZ3BAK0ETD397aMwIhjIL4nCbP0U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sDIJsSZROKhW/ESq1STDmYIHzphTgC5k7eGF6iesQSusMjqV9eUuvrNIDCOFwTzkeoa40Ug0ra0CysOz0MBg1hazuCeJKb3hfOHJzr+F7xLacvzap8Sl2X61JGYH1NnkzqL7mnSiPNawIrJMiMgIEqABYkOvSE0OpBS9CgltCwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RJKy150k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RJKy150k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 721E41F000E9;
	Thu, 16 Jul 2026 14:16:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211370;
	bh=0kkGzKT1YdYhfZOz7Ea/irJ7h0EGDjB+CZQkcDjGvTk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RJKy150krjtkzYtl+NmDUrzCSSJv7I72Ps4k0eYcY5d36OWwyLNvf8LONX0jc2x8g
	 wfbyB+43EWzR3QBtYJLj/3N+8QI2CgkKDrlXS81nKYVp09xuZqUuz3XrOEVhO0uCRX
	 Y3bkHE8S/SjkStd5DNv7XhONKO0w1z6/5dV6zfqo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Aishwarya TCV <Aishwarya.TCV@arm.com>,
	Sarthak Sharma <sarthak.sharma@arm.com>,
	Lance Yang <lance.yang@linux.dev>,
	Dev Jain <dev.jain@arm.com>,
	SeongJae Park <sj@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Anthony Yznaga <anthony.yznaga@oracle.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Mark Brown <broonie@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 401/480] selftests: mm: fix and speedup "droppable" test
Date: Thu, 16 Jul 2026 15:32:28 +0200
Message-ID: <20260716133053.481896286@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

From: David Hildenbrand (Arm) <david@kernel.org>

commit cc13a7a618fe8354f16d74c06aaf9565a68e9ebd upstream.

The droppable test currently relies on creating memory pressure in a child
process to trigger dropping the droppable pages.

That not only takes a long time on some machines (allocating and filling
all that memory), on large machines this will not work as we hardcode the
area size to 134217728 bytes.

...  further, we rely on timeouts to detect that memory was not dropped,
which is really suboptimal.

Instead, let's just use MADV_PAGEOUT on a 2 MiB region.  MADV_PAGEOUT
works with droppable memory even without swap.

There is the low chance of MADV_PAGEOUT failing to drop a page because of
speculative references.  We'll wait 1s and retry 10 times to rule that
unlikely case out as best as we can.

On a machine without swap:

	$ ./droppable
	TAP version 13
	1..1
	ok 1 madvise(MADV_PAGEOUT) behavior
	# Totals: pass:1 fail:0 xfail:0 xpass:0 skip:0 error:0

Link: https://lore.kernel.org/20260611-droppable_test-v1-1-b6a73d99f658@kernel.org
Fixes: 9651fcedf7b9 ("mm: add MAP_DROPPABLE for designating always lazily freeable mappings")
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Reported-by: Aishwarya TCV <Aishwarya.TCV@arm.com>
Tested-by: Sarthak Sharma <sarthak.sharma@arm.com>
Tested-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Tested-by: Lorenzo Stoakes <ljs@kernel.org>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Reviewed-by: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: Anthony Yznaga <anthony.yznaga@oracle.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/mm/droppable.c |   46 ++++++++++++++++++---------------
 1 file changed, 26 insertions(+), 20 deletions(-)

--- a/tools/testing/selftests/mm/droppable.c
+++ b/tools/testing/selftests/mm/droppable.c
@@ -17,10 +17,10 @@
 
 int main(int argc, char *argv[])
 {
-	size_t alloc_size = 134217728;
-	size_t page_size = getpagesize();
+	const size_t alloc_size = 2 * 1024 * 1024;
+	int retry_count = 10;
+	bool dropped;
 	void *alloc;
-	pid_t child;
 
 	ksft_print_header();
 	ksft_set_plan(1);
@@ -28,26 +28,32 @@ int main(int argc, char *argv[])
 	alloc = mmap(0, alloc_size, PROT_READ | PROT_WRITE, MAP_ANONYMOUS | MAP_DROPPABLE, -1, 0);
 	assert(alloc != MAP_FAILED);
 	memset(alloc, 'A', alloc_size);
-	for (size_t i = 0; i < alloc_size; i += page_size)
-		assert(*(uint8_t *)(alloc + i));
 
-	child = fork();
-	assert(child >= 0);
-	if (!child) {
-		for (;;)
-			*(char *)malloc(page_size) = 'B';
-	}
-
-	for (bool done = false; !done;) {
-		for (size_t i = 0; i < alloc_size; i += page_size) {
-			if (!*(uint8_t *)(alloc + i)) {
-				done = true;
-				break;
+	while (retry_count--) {
+		if (madvise(alloc, alloc_size, MADV_PAGEOUT)) {
+			if (errno == EINVAL) {
+				ksft_test_result_skip("madvise(MADV_PAGEOUT) not supported\n");
+				exit(KSFT_SKIP);
 			}
+			ksft_test_result_fail("madvise(MADV_PAGEOUT) error: %s\n", strerror(errno));
+			exit(KSFT_FAIL);
 		}
+
+		dropped = memchr(alloc, 'A', alloc_size) == NULL;
+
+		/*
+		 * Speculative reference can temporarily prevent some
+		 * pages from getting dropped. So sleep and retry.
+		 *
+		 * If a page is not droppable for 10s, something
+		 * is seriously messed up and we want to fail.
+		 */
+		if (dropped)
+			break;
+		sleep(1);
 	}
-	kill(child, SIGTERM);
 
-	ksft_test_result_pass("MAP_DROPPABLE: PASS\n");
-	exit(KSFT_PASS);
+	ksft_test_result(dropped, "madvise(MADV_PAGEOUT) behavior\n");
+
+	ksft_finished();
 }


