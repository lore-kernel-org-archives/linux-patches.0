Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C64B6220F3E;
	Thu, 16 Jul 2026 13:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210066; cv=none; b=Rv2Uq1gtlQR0ZUNJmEMq1myol4jTqN+4sVPjF3u/FKbmG+Onac9jVZz6irHeuX2gpeSHnB4krKoLrSWJqSg6cqiXWiYV8z+3REsbn/PSM2uPEYwUnfZZ16eHw3eFiXQhrZbALiCU+rHmjyJ/6yYl5Pf2IeLGWn2aboRG2oPZ+Rs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210066; c=relaxed/simple;
	bh=M5QoEdpLTxybxFtJxXrLWPeof0CLUXNzlE3UFq9GRgA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FaFCyULOJuigYMZqKRvwOrGGgT6RzM8TFYUfMN7Jo+LhTruTPU7a03s4oFJY+9OUhL4nwpw9NwnfeaImK1/LIE8CB6hZVIR+QVSeq81Fxw91MMArJfsN5i0P/wg9lrRIwtOx0117BLhYZsT3v6SCSLUxA7OKJCljF2HGckhSidk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DonMMSHo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DonMMSHo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 082711F00AC4;
	Thu, 16 Jul 2026 13:54:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210064;
	bh=Q97cBPWpc7fKQmAQGeb208tGfQppW1gdfjRvJ3kglBU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DonMMSHoxtEBm1LFOHaruZgJ8O47CHNS44ZGmqqAC1Ea21T559vv6b2hhz/nYojqf
	 6vQSdGobkLCcO6YNaSqaYKAR6lzWy5wzbrAw0neLOT04CapP/EuE1MVmYjwL19oc4s
	 qGA5ReBQgL/QQqfFsKZOYXlC4kfc690wi/tz/0hk=
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
Subject: [PATCH 7.1 424/518] selftests: mm: fix and speedup "droppable" test
Date: Thu, 16 Jul 2026 15:31:32 +0200
Message-ID: <20260716133057.116170314@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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


