Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213470;
	b=ydwrapfkV9QncLJJKdm87R/TkqYbLaHwgqPPOsRAePegDbkaTY8BCzUT4XIDDL2ukKEJ
	 8pBZcyYIQ0v5ILx5EAFFu9kWJQzryLdgT5iHai9jIHj2mFtxgqYgM8ZZdAwZPFUj3LFai
	 kRSP4RApasFN/+Mdsa9VbquN3GKOsUvaHEGsNv/aJwYYgufNKonGZaY+soyMw0k22IET6
	 2T61f2FhYeG5phz3OqGLa0yoQsjkhHRGf4qHb2eo28SN0tgwmHB78HkaApbYCutEy4wGI
	 3GFXHq9kagARNJgJEn/0A3IAqS9DMuo7BwaT2iQEfTqbGpsLRVWhZAan/rmFPMs71ng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213470;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dfZQAhNCHE0mkoyMoSKTeOmRgB4FklzfWio3szDwRVg=;
	b=tS2aUR3pxCfT3ovic9fURzZuiJD97iqFXi5Nfm/0toqGrASCVVvgJ7FY0BRdsruQaF8W
	 JgGSftsgDsM07FWl/+M2iUIF3E0TkeG3MvDrMx3KZLn26c8u3c6GApRwpDYjI3crZbG2B
	 Rc66PFo3KW8e0XAKEC6/mfIXhPLPfvJC4z1WQ5Wz8u+qJz1Gscyb+YsYjsBrDyH8xgw/q
	 kUp8HPPa8D22fzYyB/e3P8yOmQmfeTjFw0/h6BeLFJUa83/tCqzsS5CWCMH5zK3EQQKCO
	 iGptHmd2pOmgI+yHzEGW3quiWzeBFzi9CHVjZ5U26tF0+G3AIwZEX+azIV/vteQNbkw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bZr+GRmv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 748FD606A31E;
	Wed, 28 Oct 2026 18:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bZr+GRmv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88E0B1F01825;
	Wed, 28 Oct 2026 18:51:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213470;
	bh=dfZQAhNCHE0mkoyMoSKTeOmRgB4FklzfWio3szDwRVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bZr+GRmv+IrbMQ5YmsHi4Z0zZZXYDl2EmqnHnvuhhDRZlmlnR2Y3Zw7DJRMl9xWd1
	 tsHFWdmOM9QQ23V6RzEGbY8dzzbwhsmIdbTh2Ew/wjT66LPkQycU5JkrjfGdpoIb1a
	 fehA6hVeA56Coq2zr/vklhTgTuPixTbaukJuw/M4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Pedro Falcato <pfalcato@suse.de>,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	"Jose A. Perez de Azpillaga" <azpijr@gmail.com>,
	Anirudh Srinivasan <asrinivasan@oss.tenstorrent.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	Brian Geffon <bgeffon@google.com>,
	Minchan Kim <minchan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0516/1887] mm/mremap: fix locked_vm leak by splitting VMA for MREMAP_DONTUNMAP
Date: Wed, 28 Oct 2026 17:43:32 +0100
Message-ID: <20261028170511.060978432@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Stoakes (ARM) <ljs@kernel.org>

[ Upstream commit 597e4b9ab48a3f841080f627722064853d3f650e ]

The MREMAP_DONTUNMAP feature is highly unusual in that it permits mremap()
operations that keep the original VMA in place.

Historically this has led to a lot of bugs where non-obvious interactions
occur between existing mremap() operations and the original VMA.

Fix another of these - partial copies.

The long-standing mremap() partial VMA logic has the baked-in assumption
that the originating VMA is unmapped and thus moved.

However MREMAP_DONTUNMAP defeats this by performing a partial copy
instead since it keeps the source VMA around.

An mremap(..., MREMAP_DONTUNMAP) operation disallows resizing of the VMA,
but the operation can be performed partially:

                           |-----------------|
                           |                 |
                           |                 v
                        <------>          <------>
                        .new_sz.           new_sz
                     |--.------.--|       |------|
                     |  .source.  |       | dest |
                     |--.------.--|       |------|
                     <------------>
                         old_sz

The page tables in the specified range are moved, but the original VMA is
kept intact.

This interacts poorly with mlock()'d VMAs, as the VMA_LOCKED_BIT flag is
cleared for the entire source VMA and set for the entire destination VMA.

This results in an mm->locked_vm leak as the change is therefore not
accounted correctly.

The clear solution here is to make the portion of the source VMA which is
mremap()'d distinct from the rest of it, a.k.a. split it.

Therefore resolve this issue by splitting it ahead of the rest of the
mremap() operation if the VMA is mlock()'d.

This is valid, as the source VMA will lose its VMA_LOCKED_BIT flag, so if a
partial remap it will become distinct from the rest of the VMA.

In order to make this change re-expose split_vma() in vma.h for
CONFIG_MMU (nommu doesn't compile mremap.c and uses a static helper
instead).

Finally, update the sys_map_count check to account for this case.

Note that the early check does not use needs_pre_split() - this is because
the VMA has not been looked up by this point, so be conservative and assume
that the VMA is mlock()'d in this case for the purposes of the
sys_map_count check.

Link: https://lore.kernel.org/20260930-fix-dontunmap-partial-self-merge-v2-2-f388985a0f0a@kernel.org
Fixes: e346b3813067 ("mm/mremap: add MREMAP_DONTUNMAP to mremap()")
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
Tested-by: Anirudh Srinivasan <asrinivasan@oss.tenstorrent.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Brian Geffon <bgeffon@google.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: <stable@vger.kernel.org>
[ sashal: Moved split preparation into move_vma() because prep_move_vma() is absent. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/mremap.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/mm/mremap.c b/mm/mremap.c
index 7e39614d2e0e6..e1d7047f6ee5e 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -585,6 +585,8 @@ static unsigned long move_vma(struct vm_area_struct *vma,
 	int split = 0;
 	int err = 0;
 	bool need_rmap_locks;
+	const bool split_before = vma->vm_start != old_addr;
+	const bool split_after = vma->vm_end != old_addr + old_len;
 
 	/*
 	 * We'd prefer to avoid failure later on in do_munmap:
@@ -597,9 +599,9 @@ static unsigned long move_vma(struct vm_area_struct *vma,
 		to_account = new_len;
 
 	if (vma->vm_ops && vma->vm_ops->may_split) {
-		if (vma->vm_start != old_addr)
+		if (split_before)
 			err = vma->vm_ops->may_split(vma, old_addr);
-		if (!err && vma->vm_end != old_addr + old_len)
+		if (!err && split_after)
 			err = vma->vm_ops->may_split(vma, old_addr + old_len);
 		if (err)
 			return err;
@@ -617,6 +619,19 @@ static unsigned long move_vma(struct vm_area_struct *vma,
 	if (err)
 		return err;
 
+	/*
+	 * To account mlock()'d pages correctly in the MREMAP_DONTUNMAP
+	 * case perform any split ahead of time for an mlock()'d VMA.
+	 */
+	if ((flags & MREMAP_DONTUNMAP) && (vma->vm_flags & VM_LOCKED)) {
+		if (split_before)
+			err = split_vma(mm, vma, old_addr, 1);
+		if (!err && split_after)
+			err = split_vma(mm, vma, old_addr + old_len, 0);
+		if (err)
+			return err;
+	}
+
 	if (vm_flags & VM_ACCOUNT) {
 		if (security_vm_enough_memory_mm(mm, to_account >> PAGE_SHIFT))
 			return -ENOMEM;
-- 
2.53.0



