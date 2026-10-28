Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209241;
	b=NuXKUgPwNwTD9WC85kA8sAyqt5QIJg/po9JEvUTExmHRbRZzYGK24/TbyMzJz5h/4d/H
	 tNdGWoxx+Z5GXs95qLHGjQgVbeZhfkOmGG7ATDGtOPzrnvjmEFc20DTuzeQWBo7wioWGq
	 wz9cskOO2DLDrPU9FaokiwDZAFWD3OOZbJenbmh5TNkqyhdV5FPixBXIWWKFBrlpVzlYh
	 32FobP0103TfdJI4oCbDBMXPzxta8fQAcsnYYinUTPn28gG5MRlwsXij1dXVGDiDRwKgn
	 T/SoKg9Yec5lN7Z0z+F3Kn7Fbq9VAQarbf9/L2sNMSyvqOWcX0gXZtWuxJgxfM5nGBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209241;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wErNaXL/Y7thRg3K3/BIsWCFZB4gLwcMGbBT7BCHCNI=;
	b=21/Deab4k77rPmQ9fCIH1RPRQ4yGOfuaCe5BzFysmUx/kr+ST3FcCeIsU5W0QqobBRvB
	 HgZ+rrrLv2FN1EI9ouxzm9hln/DapAabscNK56fGnLSQD14ddUkvqHwHWrzqdM4z+q7pr
	 nRGYIXZCnty8+TCcR9hdXcYBVv95TQBS3V48v5QkvA5bamD5STatOt6/CH8nOwJuyRYPX
	 /RUwHi/dEfgiSDw6SRbnTOze0u4mBa5Lg8mdj04PuE/aBgwn26hMYD2uT+iRFl+EHA1bk
	 fo8DlXFZlQ+5t+LJVnIpNhxjyEs2UxNmd0KNwJOPFlPOFozDfAZ4ibEKWN0+gRIrSCA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BSKTwijO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7661A606A31C;
	Wed, 28 Oct 2026 17:40:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BSKTwijO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBBA91F01825;
	Wed, 28 Oct 2026 17:40:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209241;
	bh=wErNaXL/Y7thRg3K3/BIsWCFZB4gLwcMGbBT7BCHCNI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BSKTwijOEVvxrXMdqiLC7gcrOFxWEHs1AtQvLvGOd6Ez2z9NFBavKNfTynjRxAXX/
	 GeVPTebhTX3cSvxF0Ur4FKTy7T9GMQe/ojdcHBT+dQVXb4eEweiZGhVCfZKQ+9YBSZ
	 GQ0UiHTAxHYyaKANCNOsNYTPNuF3635U6Ja+4a5w=
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
Subject: [PATCH 5.10 375/516] mm/mremap: fix locked_vm leak by splitting VMA for MREMAP_DONTUNMAP
Date: Wed, 28 Oct 2026 17:58:47 +0100
Message-ID: <20261028170012.367305576@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Replaced upstream VMA preparation helpers with inline logic in move_vma() using the existing split_vma(mm, ...) API. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/mremap.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/mm/mremap.c b/mm/mremap.c
index 3334c40222101..8d8b39f821380 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -366,6 +366,19 @@ static unsigned long move_vma(struct vm_area_struct *vma,
 	if (err)
 		return err;
 
+	/*
+	 * To account mlock()'d pages correctly in the MREMAP_DONTUNMAP
+	 * case perform any split ahead of time for an mlock()'d VMA.
+	 */
+	if ((flags & MREMAP_DONTUNMAP) && (vma->vm_flags & VM_LOCKED)) {
+		if (vma->vm_start != old_addr)
+			err = split_vma(mm, vma, old_addr, 1);
+		if (!err && vma->vm_end != old_addr + old_len)
+			err = split_vma(mm, vma, old_addr + old_len, 0);
+		if (err)
+			return err;
+	}
+
 	new_pgoff = vma->vm_pgoff + ((old_addr - vma->vm_start) >> PAGE_SHIFT);
 	new_vma = copy_vma(&vma, new_addr, new_len, new_pgoff,
 			   &need_rmap_locks);
-- 
2.53.0



