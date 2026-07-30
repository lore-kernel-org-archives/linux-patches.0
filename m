Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F309136493F;
	Thu, 30 Jul 2026 14:49:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422962; cv=none; b=jHHOsY1AA5MARLbTDbksvBaj0IZ99+RcMnmMkAOO4aijN7fCwvLuSgepcfGFdpXa/sgYu4TqSFAClHNp7Gx8Yb6oVnhEHgK6h+NCePR3u2eEISFVxkgWhAh0lXVh8ajtRMfUwH8pAjMtf++pIh0tNuZDznoOd7Nf2wM567OnplI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422962; c=relaxed/simple;
	bh=yTFoM59ydny8YS/utOsDE/8gckVsXOaaFToDgb+RNOk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mc6hXXxmYqO8SyzjtL78tDbuWiojWq8KrdAXd00/SmAENq/iOrNhCNqX9n/gdA2nJ9OqyRl4tLLv+yzNwRd5psKDtdlapPUNPLprM9DD7+EyWNoUaik6dP5iQfJoFE5eS88EMUgC4ebfcj1WwjS3n0egCZLmZnHFeeatH6+zx1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vLiu6//U; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vLiu6//U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AA081F000E9;
	Thu, 30 Jul 2026 14:49:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422960;
	bh=o0lfgLCCFoiyqYxr0DeKcCYLj2W6E+ZFspyd+8yCm3I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vLiu6//UykC5siOvYsA/eP4ZqSIA+JoKpRJNuPhXH+neE0Z6UVpQaFgNFNUD0UPyI
	 uhlfk86gXiDcfxSzOOUJNvHqH8xqq1XQfShV12m/V7fQGBqmZXEO2gbj5xCiOas3fS
	 cPGvXZS5pNVy5usCUar5bNAOEXkd6mUIrTjGjHcQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7.1 618/744] mm/kmemleak: fix checksum computation for per-cpu objects
Date: Thu, 30 Jul 2026 16:14:51 +0200
Message-ID: <20260730141457.409710399@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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
@@ -970,7 +970,7 @@ static void reset_checksum(unsigned long
 	}
 
 	raw_spin_lock_irqsave(&object->lock, flags);
-	object->checksum = 0;
+	object->checksum = ~0;
 	raw_spin_unlock_irqrestore(&object->lock, flags);
 	put_object(object);
 }
@@ -1399,7 +1399,8 @@ static bool update_checksum(struct kmeml
 		for_each_possible_cpu(cpu) {
 			void *ptr = per_cpu_ptr((void __percpu *)object->pointer, cpu);
 
-			object->checksum ^= crc32(0, kasan_reset_tag((void *)ptr), object->size);
+			object->checksum = crc32(object->checksum,
+						 kasan_reset_tag((void *)ptr), object->size);
 		}
 	} else {
 		object->checksum = crc32(0, kasan_reset_tag((void *)object->pointer), object->size);


