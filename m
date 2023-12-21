Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CD2E59910
	for <patches@lists.linux.dev>; Thu, 21 Dec 2023 17:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Vgr1nOMV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68D8EC433C7;
	Thu, 21 Dec 2023 17:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1703179620;
	bh=j7IMo3IslfxSy6UdippjFzjMlbpaPfIPQIQ0OgZlg1w=;
	h=From:Date:Subject:To:Cc:From;
	b=Vgr1nOMVkPm9qdsHlovJ02nCyLGAxAAIdd2i9lihUPrGXC7l6I0OghRmacqVFFPxM
	 jAGiEDzdgqW+95ZVl3jFjzwA782qUapXNin/1SY+4hAEihUU1kSjUEHaMSRyYBZlSB
	 u6YpUTtWMAzJFOBtY2gj77+XGRqAMOEnbQeoAZ/V9LzbkrCl3Q1LEwuaiewKxPjsrf
	 8uxkA8pWK+DnWayfXL9kIvGCb8+/059vCawCMD4SA9lPP6MnmaAtXGwPU2OtD7uOWN
	 mPNvB2HQ1bBjdbJJyt0r2XSYaQjgOg/Jvi4BL336PkGHgPG6jROMXC2y3tqqTiMR1r
	 812jAGEktzLTA==
From: Nathan Chancellor <nathan@kernel.org>
Date: Thu, 21 Dec 2023 10:26:52 -0700
Subject: [PATCH] kasan: Mark unpoison_slab_object() as static
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20231221-mark-unpoison_slab_object-as-static-v1-1-bf24f0982edc@kernel.org>
X-B4-Tracking: v=1; b=H4sIAFt1hGUC/x3N3QrCMAxA4VcZuTawZsrAVxEZaU23+NOOpoow9
 u4WL7+bczYwKSoG526DIh81zanBHToIC6dZUG/NQD0Njsjhi8sD32nNajlN9mQ/ZX+XUJENrXL
 VgIOPREdxJxojtNJaJOr3f7lc9/0HtDZ9DXUAAAA=
To: akpm@linux-foundation.org, andreyknvl@gmail.com, ryabinin.a.a@gmail.com
Cc: glider@google.com, dvyukov@google.com, vincenzo.frascino@arm.com, 
 kasan-dev@googlegroups.com, linux-mm@kvack.org, patches@lists.linux.dev, 
 Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.13-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1506; i=nathan@kernel.org;
 h=from:subject:message-id; bh=j7IMo3IslfxSy6UdippjFzjMlbpaPfIPQIQ0OgZlg1w=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDKktpcmvE2Ulrdl2PGyrXvBlhcbuZ6K5C74t2VYu42ZRF
 TtHcbNmRykLgxgXg6yYIkv1Y9XjhoZzzjLeODUJZg4rE8gQBi5OAZjIrTOMDA+btzpWWs18o6Ju
 tDyp86WrKqNz1+FXL1oi7N5Kp27yuc7wv2TPynymQ72Lr/y08BNzFc4M8jn0RXyrw4Vyzu0vXO2
 O8AEA
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

With -Wmissing-prototypes enabled, there is a warning that
unpoison_slab_object() has no prototype, breaking the build with
CONFIG_WERROR=y:

  mm/kasan/common.c:271:6: error: no previous prototype for 'unpoison_slab_object' [-Werror=missing-prototypes]
    271 | void unpoison_slab_object(struct kmem_cache *cache, void *object, gfp_t flags,
        |      ^~~~~~~~~~~~~~~~~~~~
  cc1: all warnings being treated as errors

Mark the function as static, as it is not used outside of this
translation unit, clearing up the warning.

Fixes: 3f38c3c5bc40 ("kasan: save alloc stack traces for mempool")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 mm/kasan/common.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/kasan/common.c b/mm/kasan/common.c
index ebb1b23d6480..563cda95240b 100644
--- a/mm/kasan/common.c
+++ b/mm/kasan/common.c
@@ -277,8 +277,8 @@ void __kasan_kfree_large(void *ptr, unsigned long ip)
 	/* The object will be poisoned by kasan_poison_pages(). */
 }
 
-void unpoison_slab_object(struct kmem_cache *cache, void *object, gfp_t flags,
-			  bool init)
+static void unpoison_slab_object(struct kmem_cache *cache, void *object,
+				 gfp_t flags, bool init)
 {
 	/*
 	 * Unpoison the whole object. For kmalloc() allocations,

---
base-commit: eacce8189e28717da6f44ee492b7404c636ae0de
change-id: 20231221-mark-unpoison_slab_object-as-static-3bf224e1527f

Best regards,
-- 
Nathan Chancellor <nathan@kernel.org>

