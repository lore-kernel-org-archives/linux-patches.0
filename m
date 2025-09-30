Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6247E302CD6;
	Tue, 30 Sep 2025 15:24:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245843; cv=none; b=oiwZrSny2KAhuyIrcC+1CLAvBAv8vIrQHXdeHRprNfL+D3Z/mmSR0HzoYndtEGdW2nHy/O8pbjFzLJJyZT8D9N1N3F/4vmFUVb9d9tEkTFw57aD492t1X+O/vzd0qhmqev77epoNVA8qq2WZaGByiiNXIuPZNfMVDebMMvekMt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245843; c=relaxed/simple;
	bh=ik9f/6zd8k7rYKqfD22GS+nISOc8N+pcUyysR+hTSHg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PqQVzhh2sPkdR1O19DJtfks632v3ZWDxDA8ld9su+No3iQxWqJ+R8EQedGPGZbc1/9uukiTdbO8k1sg+jF6dmshZRo7FxmRHKHGn0uQYvp6feMU/MMz82F4sLfJI6QUl3UetHRV5IClL1YWbDWYRs73HGhW6q8oBvi4pyZcvKkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iD27invp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iD27invp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B976AC4CEF0;
	Tue, 30 Sep 2025 15:24:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245843;
	bh=ik9f/6zd8k7rYKqfD22GS+nISOc8N+pcUyysR+hTSHg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iD27invpTOnvqioFLUhU51v/94SQyU3xjBigtJj/QkQn1z/LAQ/e4FVvSxi2XTceG
	 sEdKQI94o8xdwXphRbFNE+vNDByszC13be46bmY+tyofmzH4Y8ETe6pzs5JheJ2Hf5
	 pGe9EuIB4DwLyg3u4pTrx67+mq/BBidNeDdlGYlM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@kernel.org>,
	Alexander Potapenko <glider@google.com>,
	Dmitriy Vyukov <dvyukov@google.com>,
	Marco Elver <elver@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 67/91] kmsan: fix out-of-bounds access to shadow memory
Date: Tue, 30 Sep 2025 16:48:06 +0200
Message-ID: <20250930143823.967901008@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143821.118938523@linuxfoundation.org>
References: <20250930143821.118938523@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Biggers <ebiggers@kernel.org>

commit 85e1ff61060a765d91ee62dc5606d4d547d9d105 upstream.

Running sha224_kunit on a KMSAN-enabled kernel results in a crash in
kmsan_internal_set_shadow_origin():

    BUG: unable to handle page fault for address: ffffbc3840291000
    #PF: supervisor read access in kernel mode
    #PF: error_code(0x0000) - not-present page
    PGD 1810067 P4D 1810067 PUD 192d067 PMD 3c17067 PTE 0
    Oops: 0000 [#1] SMP NOPTI
    CPU: 0 UID: 0 PID: 81 Comm: kunit_try_catch Tainted: G                 N  6.17.0-rc3 #10 PREEMPT(voluntary)
    Tainted: [N]=TEST
    Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.17.0-0-gb52ca86e094d-prebuilt.qemu.org 04/01/2014
    RIP: 0010:kmsan_internal_set_shadow_origin+0x91/0x100
    [...]
    Call Trace:
    <TASK>
    __msan_memset+0xee/0x1a0
    sha224_final+0x9e/0x350
    test_hash_buffer_overruns+0x46f/0x5f0
    ? kmsan_get_shadow_origin_ptr+0x46/0xa0
    ? __pfx_test_hash_buffer_overruns+0x10/0x10
    kunit_try_run_case+0x198/0xa00

This occurs when memset() is called on a buffer that is not 4-byte aligned
and extends to the end of a guard page, i.e.  the next page is unmapped.

The bug is that the loop at the end of kmsan_internal_set_shadow_origin()
accesses the wrong shadow memory bytes when the address is not 4-byte
aligned.  Since each 4 bytes are associated with an origin, it rounds the
address and size so that it can access all the origins that contain the
buffer.  However, when it checks the corresponding shadow bytes for a
particular origin, it incorrectly uses the original unrounded shadow
address.  This results in reads from shadow memory beyond the end of the
buffer's shadow memory, which crashes when that memory is not mapped.

To fix this, correctly align the shadow address before accessing the 4
shadow bytes corresponding to each origin.

Link: https://lkml.kernel.org/r/20250911195858.394235-1-ebiggers@kernel.org
Fixes: 2ef3cec44c60 ("kmsan: do not wipe out origin when doing partial unpoisoning")
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Tested-by: Alexander Potapenko <glider@google.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/kmsan/core.c       |   10 +++++++---
 mm/kmsan/kmsan_test.c |   16 ++++++++++++++++
 2 files changed, 23 insertions(+), 3 deletions(-)

--- a/mm/kmsan/core.c
+++ b/mm/kmsan/core.c
@@ -262,7 +262,8 @@ void kmsan_internal_set_shadow_origin(vo
 				      u32 origin, bool checked)
 {
 	u64 address = (u64)addr;
-	u32 *shadow_start, *origin_start;
+	void *shadow_start;
+	u32 *aligned_shadow, *origin_start;
 	size_t pad = 0;
 
 	KMSAN_WARN_ON(!kmsan_metadata_is_contiguous(addr, size));
@@ -281,9 +282,12 @@ void kmsan_internal_set_shadow_origin(vo
 	}
 	__memset(shadow_start, b, size);
 
-	if (!IS_ALIGNED(address, KMSAN_ORIGIN_SIZE)) {
+	if (IS_ALIGNED(address, KMSAN_ORIGIN_SIZE)) {
+		aligned_shadow = shadow_start;
+	} else {
 		pad = address % KMSAN_ORIGIN_SIZE;
 		address -= pad;
+		aligned_shadow = shadow_start - pad;
 		size += pad;
 	}
 	size = ALIGN(size, KMSAN_ORIGIN_SIZE);
@@ -297,7 +301,7 @@ void kmsan_internal_set_shadow_origin(vo
 	 * corresponding shadow slot is zero.
 	 */
 	for (int i = 0; i < size / KMSAN_ORIGIN_SIZE; i++) {
-		if (origin || !shadow_start[i])
+		if (origin || !aligned_shadow[i])
 			origin_start[i] = origin;
 	}
 }
--- a/mm/kmsan/kmsan_test.c
+++ b/mm/kmsan/kmsan_test.c
@@ -523,6 +523,21 @@ DEFINE_TEST_MEMSETXX(16)
 DEFINE_TEST_MEMSETXX(32)
 DEFINE_TEST_MEMSETXX(64)
 
+/* Test case: ensure that KMSAN does not access shadow memory out of bounds. */
+static void test_memset_on_guarded_buffer(struct kunit *test)
+{
+	void *buf = vmalloc(PAGE_SIZE);
+
+	kunit_info(test,
+		   "memset() on ends of guarded buffer should not crash\n");
+
+	for (size_t size = 0; size <= 128; size++) {
+		memset(buf, 0xff, size);
+		memset(buf + PAGE_SIZE - size, 0xff, size);
+	}
+	vfree(buf);
+}
+
 static noinline void fibonacci(int *array, int size, int start)
 {
 	if (start < 2 || (start == size))
@@ -602,6 +617,7 @@ static struct kunit_case kmsan_test_case
 	KUNIT_CASE(test_memset16),
 	KUNIT_CASE(test_memset32),
 	KUNIT_CASE(test_memset64),
+	KUNIT_CASE(test_memset_on_guarded_buffer),
 	KUNIT_CASE(test_long_origin_chain),
 	KUNIT_CASE(test_stackdepot_roundtrip),
 	{},


