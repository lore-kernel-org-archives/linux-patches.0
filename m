Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 321CC36DA0F;
	Sat, 28 Feb 2026 17:57:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301475; cv=none; b=V59S6FpSeRjGpswrOcc7TjnsEylSX8oKNeeEBBRVcr2R2l+OXVHXr3iVVvd31K7RSs3Lu/c/N8/3BVccOmnnqOonYW/CCwgpzNsVZOnsV/HNTALLBPPEurCbSp/wePekO+wraIHXc8DQ6h6MkUmsiji1jQ0WniL9EVym4QqSpho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301475; c=relaxed/simple;
	bh=r2vRFvSi6DryR8gEDTFDXYBlGB6BbkYnv7ZGKP5MA2k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fIPvIAlJnZkaK26B2UhdScbuWyx+qvIz4nwgO3o49L1T1Ev+e9xuddyPCVNV50bTseES0af6UO19OPW2SBbwZ5p5g/SYZxlh8adtnzwiT9dowLy6Dsg/x7kVaGxfzbeIfEiYATGdaOQfayiT2ZMbg09AHwfiyj22wxG4jUKKuoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mGomZbeR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mGomZbeR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B351C116D0;
	Sat, 28 Feb 2026 17:57:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301475;
	bh=r2vRFvSi6DryR8gEDTFDXYBlGB6BbkYnv7ZGKP5MA2k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mGomZbeR3Ri8hJF7rFZ+RJcfG0j6kUUTS2QwD6/0jyiMzACmAftu5ryxQISVdi+7/
	 rhizhgV3E5Ua0a4uAgAXWyb8anE516VAiayCd54PAqMvYBaKaPcRywq4cY5gA5gJu0
	 pHuypv3UevnWoeKGBp8Zy+TSbQ1cUu4Dp3dIriHMKFwBYOKtKM/SBgethkiX74RsWK
	 fCtKq7DVW/2UWIYOLAwwcC8zwIR9jXB4f4Ho2ggWGb/lHVojCGzZf0azjPSKP0wxyS
	 HxxgKzWX9jgJC+MmJjDq+OVzk2tbX2tGjEriKFtZJ+l8/GKpXr8RU3UPb5ctQg53El
	 fCMP0OGwF3DlA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Harry Yoo <harry.yoo@oracle.com>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	stable@vger.kernel.org,
	Vlastimil Babka <vbabka@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 660/752] mm/slab: use unsigned long for orig_size to ensure proper metadata align
Date: Sat, 28 Feb 2026 12:46:11 -0500
Message-ID: <20260228174750.1542406-660-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Harry Yoo <harry.yoo@oracle.com>

[ Upstream commit b85f369b81aed457acbea4ad3314218254a72fd2 ]

When both KASAN and SLAB_STORE_USER are enabled, accesses to
struct kasan_alloc_meta fields can be misaligned on 64-bit architectures.
This occurs because orig_size is currently defined as unsigned int,
which only guarantees 4-byte alignment. When struct kasan_alloc_meta is
placed after orig_size, it may end up at a 4-byte boundary rather than
the required 8-byte boundary on 64-bit systems.

Note that 64-bit architectures without HAVE_EFFICIENT_UNALIGNED_ACCESS
are assumed to require 64-bit accesses to be 64-bit aligned.
See HAVE_64BIT_ALIGNED_ACCESS and commit adab66b71abf ("Revert:
"ring-buffer: Remove HAVE_64BIT_ALIGNED_ACCESS"") for more details.

Change orig_size from unsigned int to unsigned long to ensure proper
alignment for any subsequent metadata. This should not waste additional
memory because kmalloc objects are already aligned to at least
ARCH_KMALLOC_MINALIGN.

Closes: https://lore.kernel.org/all/aPrLF0OUK651M4dk@hyeyoo
Suggested-by: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: stable@vger.kernel.org
Fixes: 6edf2576a6cc ("mm/slub: enable debugging memory wasting of kmalloc")
Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
Closes: https://lore.kernel.org/all/aPrLF0OUK651M4dk@hyeyoo/
Link: https://patch.msgid.link/20260113061845.159790-2-harry.yoo@oracle.com
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/slub.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index e8cffd89b73d7..bc6156801e8e6 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -863,7 +863,7 @@ static inline bool slab_update_freelist(struct kmem_cache *s, struct slab *slab,
  * request size in the meta data area, for better debug and sanity check.
  */
 static inline void set_orig_size(struct kmem_cache *s,
-				void *object, unsigned int orig_size)
+				void *object, unsigned long orig_size)
 {
 	void *p = kasan_reset_tag(object);
 
@@ -873,10 +873,10 @@ static inline void set_orig_size(struct kmem_cache *s,
 	p += get_info_end(s);
 	p += sizeof(struct track) * 2;
 
-	*(unsigned int *)p = orig_size;
+	*(unsigned long *)p = orig_size;
 }
 
-static inline unsigned int get_orig_size(struct kmem_cache *s, void *object)
+static inline unsigned long get_orig_size(struct kmem_cache *s, void *object)
 {
 	void *p = kasan_reset_tag(object);
 
@@ -889,7 +889,7 @@ static inline unsigned int get_orig_size(struct kmem_cache *s, void *object)
 	p += get_info_end(s);
 	p += sizeof(struct track) * 2;
 
-	return *(unsigned int *)p;
+	return *(unsigned long *)p;
 }
 
 #ifdef CONFIG_SLUB_DEBUG
@@ -1204,7 +1204,7 @@ static void print_trailer(struct kmem_cache *s, struct slab *slab, u8 *p)
 		off += 2 * sizeof(struct track);
 
 	if (slub_debug_orig_size(s))
-		off += sizeof(unsigned int);
+		off += sizeof(unsigned long);
 
 	off += kasan_metadata_size(s, false);
 
@@ -1400,7 +1400,7 @@ static int check_pad_bytes(struct kmem_cache *s, struct slab *slab, u8 *p)
 		off += 2 * sizeof(struct track);
 
 		if (s->flags & SLAB_KMALLOC)
-			off += sizeof(unsigned int);
+			off += sizeof(unsigned long);
 	}
 
 	off += kasan_metadata_size(s, false);
@@ -8013,7 +8013,7 @@ static int calculate_sizes(struct kmem_cache_args *args, struct kmem_cache *s)
 
 		/* Save the original kmalloc request size */
 		if (flags & SLAB_KMALLOC)
-			size += sizeof(unsigned int);
+			size += sizeof(unsigned long);
 	}
 #endif
 
-- 
2.51.0

