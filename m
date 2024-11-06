Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 026AA1F4298;
	Wed,  6 Nov 2024 12:54:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897682; cv=none; b=XxgmUTabd3Ljmrqt86yJ/DkEYOeogV2lwt+mZyKhTQHS4sGXJ8Ql797/nDie+mhB8xPQ64F7Ubkxi7V5rSbtjOz0K1+AE0hEGFudUi3kO4voMdLdMrjQUfC/KVazdQ+qAOeAADti9w/uHB13auYyvtFgwXGRDqJefeo58Jsjz+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897682; c=relaxed/simple;
	bh=N3p6qJe1kqq2cBmrKlOfwcuXKbHi25wqiAg/1kF/AuE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nEa+9EBrnENmOixrOR0brvwRpqcbZymkHMxWvlCSUSB4xqpAmgxUAhNlOncYUiqhtY68gw54AQvIycbVX19QMMefVqe/VT6SecXkMxHKRXnRQiuHXf8oX61yuRWZAeAPScmqaK0FG0XkaXmV6Lpsig0FixMVMa1qNyQ02RDenVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QWZRzJVb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QWZRzJVb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AC2EC4CECD;
	Wed,  6 Nov 2024 12:54:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897681;
	bh=N3p6qJe1kqq2cBmrKlOfwcuXKbHi25wqiAg/1kF/AuE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QWZRzJVbZiu9IirVPK9LQUIMvlOaZtjgkCIo/pbwcBtLA4lTzyT+oPwW1ycTeNTTt
	 mli3n/gTonuz7fMWxYBTFgggtIcvlZWLWmS2yrONTbxYDSmpLJJw420HruvTpqhVtT
	 5w6CiIgNqqeCHeUOBj2qhUZ1wy4BDtIR6nFC/cm0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Samuel Holland <samuel.holland@sifive.com>,
	Sabyrzhan Tasbolatov <snovitoll@gmail.com>,
	Alexander Potapenko <glider@google.com>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Marco Elver <elver@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 135/151] kasan: remove vmalloc_percpu test
Date: Wed,  6 Nov 2024 13:05:23 +0100
Message-ID: <20241106120312.573154511@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120308.841299741@linuxfoundation.org>
References: <20241106120308.841299741@linuxfoundation.org>
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

From: Andrey Konovalov <andreyknvl@gmail.com>

[ Upstream commit 330d8df81f3673d6fb74550bbc9bb159d81b35f7 ]

Commit 1a2473f0cbc0 ("kasan: improve vmalloc tests") added the
vmalloc_percpu KASAN test with the assumption that __alloc_percpu always
uses vmalloc internally, which is tagged by KASAN.

However, __alloc_percpu might allocate memory from the first per-CPU
chunk, which is not allocated via vmalloc().  As a result, the test might
fail.

Remove the test until proper KASAN annotation for the per-CPU allocated
are added; tracked in https://bugzilla.kernel.org/show_bug.cgi?id=215019.

Link: https://lkml.kernel.org/r/20241022160706.38943-1-andrey.konovalov@linux.dev
Fixes: 1a2473f0cbc0 ("kasan: improve vmalloc tests")
Signed-off-by: Andrey Konovalov <andreyknvl@gmail.com>
Reported-by: Samuel Holland <samuel.holland@sifive.com>
Link: https://lore.kernel.org/all/4a245fff-cc46-44d1-a5f9-fd2f1c3764ae@sifive.com/
Reported-by: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
Link: https://lore.kernel.org/all/CACzwLxiWzNqPBp4C1VkaXZ2wDwvY3yZeetCi1TLGFipKW77drA@mail.gmail.com/
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/kasan/kasan_test.c | 27 ---------------------------
 1 file changed, 27 deletions(-)

diff --git a/mm/kasan/kasan_test.c b/mm/kasan/kasan_test.c
index 0119075d2e58e..ecf9f5aa35200 100644
--- a/mm/kasan/kasan_test.c
+++ b/mm/kasan/kasan_test.c
@@ -1381,32 +1381,6 @@ static void vm_map_ram_tags(struct kunit *test)
 	free_pages((unsigned long)p_ptr, 1);
 }
 
-static void vmalloc_percpu(struct kunit *test)
-{
-	char __percpu *ptr;
-	int cpu;
-
-	/*
-	 * This test is specifically crafted for the software tag-based mode,
-	 * the only tag-based mode that poisons percpu mappings.
-	 */
-	KASAN_TEST_NEEDS_CONFIG_ON(test, CONFIG_KASAN_SW_TAGS);
-
-	ptr = __alloc_percpu(PAGE_SIZE, PAGE_SIZE);
-
-	for_each_possible_cpu(cpu) {
-		char *c_ptr = per_cpu_ptr(ptr, cpu);
-
-		KUNIT_EXPECT_GE(test, (u8)get_tag(c_ptr), (u8)KASAN_TAG_MIN);
-		KUNIT_EXPECT_LT(test, (u8)get_tag(c_ptr), (u8)KASAN_TAG_KERNEL);
-
-		/* Make sure that in-bounds accesses don't crash the kernel. */
-		*c_ptr = 0;
-	}
-
-	free_percpu(ptr);
-}
-
 /*
  * Check that the assigned pointer tag falls within the [KASAN_TAG_MIN,
  * KASAN_TAG_KERNEL) range (note: excluding the match-all tag) for tag-based
@@ -1562,7 +1536,6 @@ static struct kunit_case kasan_kunit_test_cases[] = {
 	KUNIT_CASE(vmalloc_oob),
 	KUNIT_CASE(vmap_tags),
 	KUNIT_CASE(vm_map_ram_tags),
-	KUNIT_CASE(vmalloc_percpu),
 	KUNIT_CASE(match_all_not_assigned),
 	KUNIT_CASE(match_all_ptr_tag),
 	KUNIT_CASE(match_all_mem_tag),
-- 
2.43.0



