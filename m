Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211578;
	b=O2F5skljhHkSHa2fjwsVLX2HuIkUMYXGd02GrcChG+SnoeBMl3g/jdidmX+IIx0u32Oc
	 5VWhHlu5x5avi0wPD7BGGDE/mclNHGCOoDevGJv2rw+ZkjJWnVgXlAjXwIIkjxz84jRu+
	 5Nwqps4JNxFf06FIBZydfsKtm8ONjRS3vZfnboYdNJetWov8Amawg8bfFhtvvcI2w94Yd
	 2H7tQlCMInLueKU2Z3QTFuVepsAMROkfbZZ6OJFBYGwCaaRQ2Ox9SAJytL1Pdg7yMkSpc
	 6Jncca5nsCN6vb8aNd0XIndevIpzGnv/B+7ka4CZxKQrzu756RD+6oAb0VtHkUbMXYQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211578;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eFTz/RV6IxDnHtTYuNBpN1DsUhaRtXcF7urEB5g7l6s=;
	b=IbthMisz7KC44yj/KNAvRkUswidHx8RoVDqPUNz5++59NpciD8eUQgC0INt1K1nMlG90
	 TIavOnJZGoc3ptSCOPfLuKaYdXqqNnNYYk2qJy0VdSAZdHtld9AOOciS/I/uzPKOpyFHs
	 VnhgQ1qoXtDIa/lTajL1uZuIL/J85WwpdZ/LjoHx7n/VVoIyeUT36hldjhSx51Isst2bX
	 ETHHX1+h4V2TXS7RFZ9v7UcDsQcNNy0lM33fhr9vo8NwwYrjTTTTAC+3Yuvk7HYX2SH8O
	 9WjylRqdCEiRinJh209vJv29vYH1oV7u9oYVDcdCIIYBBb2aW1tctDyKBcn61on64Rg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cVT2llVS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89437606A31D;
	Wed, 28 Oct 2026 18:19:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cVT2llVS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E08771F01825;
	Wed, 28 Oct 2026 18:19:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211578;
	bh=eFTz/RV6IxDnHtTYuNBpN1DsUhaRtXcF7urEB5g7l6s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cVT2llVSMTcHKLrSmW1qLBinTphH9aIwxDQOeO7PHmJJpJb91dulc8v4UGZ8yWnXN
	 eGhi+NaSmLjVcb/rTKN7NS2hfPIHXvdW/EYxOBYsldKl7LSw1Zq89wAKiykRlDBiHJ
	 LuHrcoYa3IUS0vl66PhmY0kT+gfBHwiPJA/npJSU=
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
Subject: [PATCH 5.15 428/571] mm/mremap: fix locked_vm leak by splitting VMA for MREMAP_DONTUNMAP
Date: Wed, 28 Oct 2026 17:59:35 +0100
Message-ID: <20261028170018.173307343@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Inlined VMA preparation into move_vma() because the upstream preparation helpers are absent. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/mremap.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/mm/mremap.c b/mm/mremap.c
index 89f198933af4a..f7a5f1106699d 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -578,6 +578,8 @@ static unsigned long move_vma(struct vm_area_struct *vma,
 	int split = 0;
 	int err = 0;
 	bool need_rmap_locks;
+	const bool split_before = vma->vm_start != old_addr;
+	const bool split_after = vma->vm_end != old_addr + old_len;
 
 	/*
 	 * We'd prefer to avoid failure later on in do_munmap:
@@ -587,9 +589,9 @@ static unsigned long move_vma(struct vm_area_struct *vma,
 		return -ENOMEM;
 
 	if (vma->vm_ops && vma->vm_ops->may_split) {
-		if (vma->vm_start != old_addr)
+		if (split_before)
 			err = vma->vm_ops->may_split(vma, old_addr);
-		if (!err && vma->vm_end != old_addr + old_len)
+		if (!err && split_after)
 			err = vma->vm_ops->may_split(vma, old_addr + old_len);
 		if (err)
 			return err;
@@ -607,6 +609,19 @@ static unsigned long move_vma(struct vm_area_struct *vma,
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
 	if (unlikely(flags & MREMAP_DONTUNMAP && vm_flags & VM_ACCOUNT)) {
 		if (security_vm_enough_memory_mm(mm, new_len >> PAGE_SHIFT))
 			return -ENOMEM;
-- 
2.53.0



