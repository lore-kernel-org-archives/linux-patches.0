Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038649;
	b=B4BP2j+QlQaAaGiGRwqpkcsptmDsmFrMwCVH1PD/N3BMdCWMXFQNIPmCvgOm1IbuxQ1x
	 xDBSQSCpgI6sPzu0EhXxI+zRWxoN4k/IYLCnlhv+cyFfusM0i1ir3UZ+LErdegCRvP37K
	 NkcwmrAUOFTh2H2waaa+SuGigw1q4pYwNxVAYJYW/CM5cx1ehEu9APYMYC5b0WymciaIe
	 puLNyk1Vze7Z7kjzTv3n/d0LN2BdxxKb/5aOvErYwYKDMQ5YthvQ1aplejqiZY6fGyCpy
	 4aXtW8Q3/VnajPHoEuo+rDsKra4NgzwjHdAW8//ymAjqjyJitgvws41XKygHYZQcVLw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038649;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ElfeDeJtuCPkVNtu49DkXWruBge7fZ9pIOikn1Nr038=;
	b=Y8d9J1N4ZVz2wFaC9f6iEgL1QzqWS2bIzQ2eoRl8r8yrPoG+yCEkC+Wlt/gPamAFyIiA
	 +5BUqydw5gawIrAk6IO6CLyKTbC36/ZpLhylWDj2QiT0TZx83BBG+GBG5iIcEvV/LFf41
	 Az3vtRo6FElvoGMxAOYvPrS9dfuMuwtUDPAprGRZ2xTW/br/wc0Q95Y5MJCx3bzh6eepv
	 kQuzHtVDT24BvzHfUZD/DKIdfveULSxLyWKhu0c1/DUqPiUPit5yX2V86CCKVxQ5E5KKV
	 FLL4YTGPdw4hl/sz35GI20b+uLY5oSRYsvR+zAe+ME6yUfOJvIGSbp7N+8Jcn+NQLSw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xeHIy1tI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3589606A31C;
	Wed, 18 Nov 2026 21:50:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xeHIy1tI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 955F11F000C4;
	Wed, 18 Nov 2026 21:50:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038649;
	bh=ElfeDeJtuCPkVNtu49DkXWruBge7fZ9pIOikn1Nr038=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xeHIy1tIFN/Z2mUSRNc1ChQPQMKSli2sYIIx2m+ym0aWNipZfdy8fsNe7MMnkDY9k
	 1g++kwcw1ibk+5+oxtZPNODsEd9aDc5qdPmz3sTiHCXdqv0CAMl5ElaiMf0wyyGiYf
	 /6AE3OLrtmWrAUz+SvSm2oWQHf7kkGLgu1C3GY0k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	shaos <shawnq1@163.com>,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	"Gregory Price (Meta)" <gourry@gourry.net>,
	Xueyuan Chen <xueyuan.chen21@gmail.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Mike Rapoport <rppt@linux.vnet.ibm.com>,
	Peter Xu <peterx@redhat.com>,
	David Hildenbrand <david@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1817/3318] mm/vma: avoid broken uffd merge on mremap
Date: Wed, 18 Nov 2026 15:40:39 +0100
Message-ID: <20261118150416.370949606@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Stoakes (ARM) <ljs@kernel.org>

[ Upstream commit 68cb098eadda190783f8f8bdf9fe764df59f7d32 ]

Userfaultfd often causes unexpected interactions within mm, and does so at
the intersection of uffd, mremap() and VMA merging.

When an mremap of a VMA occurs, copy_vma_and_data() calls
mremap_userfaultfd_prep() to notify uffd of this.

However, mremap_userfaultfd_prep() simply drops the UFFD context for the
VMA if the user did not register it for remap, i.e. didn't specify the
UFFD_FEATURE_EVENT_REMAP flag.

This is OK for the VMA itself, as upon page table move, move_ptes() clears
UFFD page table flags, using vma_has_uffd_without_event_remap() to
determine whether to do so.

However, this doesn't account for merging with adjacent VMAs, whose page
tables won't have received this treatment, and thus latent UFFD markers
will be left around.

Worse, it'll break UFFD for any VMAs it is merged with. This is very
surprising behaviour for a user, who will then simply not receive UFFD
events for VMAs they ought to.

Resolve the issue by explicitly checking for this case via
vma_has_uffd_without_event_remap() in vma_merge_copied_range(), the merge
function explicitly designated for mremap() operations.

Also update the userland VMA tests accordingly.

Link: https://lore.kernel.org/20261020-uffd-remap-fix-v1-1-0f34fc181f0a@kernel.org
Fixes: 3cfd22be0ad6 ("userfaultfd: clear flag if remap event not enabled")
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: shaos <shawnq1@163.com>
Closes: https://lore.kernel.org/all/20261020110748.959870-1-shawnq1@163.com/
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: <stable@vger.kernel.org>
[ sashal: Adapted the guard from vma_merge_copied_range() to copy_vma(), assigning new_vma = NULL instead of returning NULL. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/mmap.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/mmap.c b/mm/mmap.c
index 4fb3f7156dc35..10d5e416e80d1 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -3426,6 +3426,9 @@ struct vm_area_struct *copy_vma(struct vm_area_struct **vmap,
 	if (can_self_merge && keep_source &&
 	    (addr == vma->vm_end || vma->vm_start == addr + len))
 		new_vma = NULL;
+	else if (vma_has_uffd_without_event_remap(vma))
+		/* If not registered for remap, uffd context will be cleared. */
+		new_vma = NULL;
 	else
 		new_vma = vma_merge(&vmi, mm, prev, addr, addr + len,
 				    vma->vm_flags, vma->anon_vma, vma->vm_file,
-- 
2.53.0



