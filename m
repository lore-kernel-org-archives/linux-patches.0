Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C73E217723;
	Thu, 30 Jul 2026 15:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424833; cv=none; b=D+A9E9yrQzOOPStVcXjgFJwo3drvy2l3cYYn6EXi0stk/TX90Oj3kKE7GzG3nnphyI+GQD34R4G2HVWqBrd9q+qHw8kKTqCEJ5pvQrpurXVOeNamFY37CXCmovYM03XU1wFxRRchj222KSCx99Yr4+IQjMiE6k0O8HQo3sgqrbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424833; c=relaxed/simple;
	bh=/tOR2XoBB/Kg8YiaxV6hwLaLglsDh5uq4huswlk3z5g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N6jdmJhaNJQ0Ndv31C03Ge9Y6+JblYGFkjyZhPjxDSEC+IhQOi3sHY7IEd0lDfUowq5lCmz6flv5tgePEuTlOUkeR0do1tWEl43yTitow/nTCvgnaU12KHXQLHeqSBk4mj/AX0pKGvWpwX2tvqkQhI2Skw9Oo4LvX1phSQlQ8QY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wm8kDIGa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wm8kDIGa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2260B1F000E9;
	Thu, 30 Jul 2026 15:20:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424831;
	bh=neuwtJyRZxXOuLIgqqIO1PjaKr3djMo+LbWYW4OIOjQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wm8kDIGapXzj1OdV2HLsLzf/dB19A9pISi50TKAzrjfCg1ufzHMXobjw0QwP7xVdx
	 p1TfLhygUF+5ifIRDdN6sB8Mc8DGQzEeqcMPUVEn6J6PGd8IO/ItmvRdgwXz8XjTEx
	 IFCX90tevbaNy3tJFwKgm8RvGjwujMUlFC5223e0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 505/675] mm/kmemleak: fix checksum computation for per-cpu objects
Date: Thu, 30 Jul 2026 16:13:55 +0200
Message-ID: <20260730141455.862010979@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

From: Breno Leitao <leitao@debian.org>

commit 79c37ae3733e93d9d8ea12ecb44f717e61439024 upstream.

The per-cpu object checksum folds each CPU's CRC together with XOR and
seeds every CRC with 0.  Both choices make update_checksum() miss content
changes:

  - XOR is self-cancelling, so equal contents on two CPUs cancel out and
    simultaneous identical changes leave the checksum unchanged.
  - crc32(0, ...) over all-zero content is 0, so a freshly allocated,
    zeroed per-cpu area checksums to 0, matching the initial value, and
    the object is never seen to change.

See discussions at [0].

When update_checksum() wrongly reports an actively modified object as
unchanged, kmemleak stops greying it for an extra scan and can report a
live per-cpu object as a leak.

Fold the per-cpu CRC as a single rolling checksum across all CPUs and
initialise the object checksum to ~0 so the first computed value always
registers as a change, even for content that hashes to 0.
reset_checksum() is seeded the same way.

Link: https://lore.kernel.org/all/akfYImSNDh3OjIfR@gmail.com [0]
Link: https://lore.kernel.org/20260703-kmemleak_checksum-v1-1-5e0ab7d6966f@debian.org
Fixes: 6c99d4eb7c5e ("kmemleak: enable tracking for percpu pointers")
Signed-off-by: Breno Leitao <leitao@debian.org>
Co-developed-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/kmemleak.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -676,7 +676,7 @@ static struct kmemleak_object *__alloc_o
 	atomic_set(&object->use_count, 1);
 	object->excess_ref = 0;
 	object->count = 0;			/* white color initially */
-	object->checksum = 0;
+	object->checksum = ~0;
 	object->del_state = 0;
 
 	/* task information */
@@ -972,7 +972,7 @@ static void reset_checksum(unsigned long
 	}
 
 	raw_spin_lock_irqsave(&object->lock, flags);
-	object->checksum = 0;
+	object->checksum = ~0;
 	raw_spin_unlock_irqrestore(&object->lock, flags);
 	put_object(object);
 }
@@ -1401,7 +1401,8 @@ static bool update_checksum(struct kmeml
 		for_each_possible_cpu(cpu) {
 			void *ptr = per_cpu_ptr((void __percpu *)object->pointer, cpu);
 
-			object->checksum ^= crc32(0, kasan_reset_tag((void *)ptr), object->size);
+			object->checksum = crc32(object->checksum,
+						 kasan_reset_tag((void *)ptr), object->size);
 		}
 	} else {
 		object->checksum = crc32(0, kasan_reset_tag((void *)object->pointer), object->size);


