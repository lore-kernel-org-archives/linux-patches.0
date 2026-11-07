Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063217;
	b=I/Z1PrSsHu2Zs5g3RoRrosqoVNcoyagTq4XqGW+QxOMW9JacU7SAFi/nnXnMSGfLQ0MX
	 qkaN2qykTtONiFKDfeINRTB2Ev8EnJlrZqMGRvszQdamz7VWlR/Xh/MKU/ITstLu/zeMK
	 QU+yx9C1g+uWC3/OPYh3ySgjMFcLorItLLutMUi6tpEm+GQYdrW6LlK3J9O2PRV0dW6uu
	 cZqs/ymnmZvH9gNxEgSy3xHgtv5wnmMT3+O4WfVp+SZ3B6xkKfUqmYLYeWAYqIdXdi+uc
	 ni1rTOinel4ag1nTbsRtGnGRl49K2SjfWvT+EkbRkFSnizqZHDotHUvNLClP+49iQSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063217;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QNXGdtVmqsnIf4FUyQmCG5l511tkCxbNJia2kXXUcb0=;
	b=WqbfH51PINe28X64U7omxYZ/Wr2PXs0TCyZ0pjHeq93pwEfzftQVEHs37d3XPiudFmEZ
	 t2wQ12l+H05WTJ5iX2DsXhqu4PtKAmz9zJ2zuwe4NFqAwMIgRsjDWdsUb774J2QlVkMlG
	 ZddyveSEQCKPX4jxqiY6cwCaZ5VP0VhhSxMF0x5P2xMaJgxfnMyZuUtCpIWshx1YD0/cP
	 7Q0zMKYiXtYpO+XtKccem7S7omxru+PZEBQPLJ6YMLQh5RKsREfFyfrf71d74Fbjuhej/
	 fAneYOB5Zd4P1H+cshYbhTTM78hoJW7QK+BBojle/TDZyc78WWPhqt0+S3HGRUbpVfA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uzKrogCX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 595B5606A326;
	Sat,  7 Nov 2026 14:53:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uzKrogCX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCA031F0089F;
	Sat,  7 Nov 2026 14:53:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063217;
	bh=QNXGdtVmqsnIf4FUyQmCG5l511tkCxbNJia2kXXUcb0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uzKrogCXhaSOta2mdkXMPMmoJ+pAv8UUYvfj0Mq1NZLLSVHBtBIuRHkx9ru/WyeXi
	 VwPVTWjlX/sBROL+IEadkY5BXEBHNFfIXlXWeWLreiXRfJtbo14az4njl2EG6lNbku
	 ULdBk0QSlN9CTZ009nyPZlevZ6mp4sGHyD6cc3MU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luxiao Xu <rakukuip@gmail.com>,
	Ren Wei <weir@nebusec.ai>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vega <vega@nebusec.ai>,
	David Hildenbrand <david@kernel.org>,
	Grazvydas Ignotas <notasas@gmail.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 426/869] mm/memory: constrain generic_access_phys() to page boundary
Date: Sat,  7 Nov 2026 08:51:48 -0500
Message-ID: <20261107134908.306276564@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luxiao Xu <rakukuip@gmail.com>

[ Upstream commit ae0298a5fbeff32951c0d31398ccec97ec6aa0ea ]

This patch addresses an issue in generic_access_phys() where accessing
memory across page boundaries in PFNMAP VMAs assumes physical pages are
contiguous, which can lead to accessing unintended physical memory or
exceeding VMA boundaries.

generic_access_phys() improperly validates the memory access range: it
only validates the start address using follow_pfnmap_start() and passes
PAGE_ALIGN(len + offset) to ioremap_prot().

This poses two problems:
1. In PFNMAP VMAs, consecutive virtual pages are not guaranteed to be
   physically contiguous, and individual PTEs may have different access
   permissions or writability.
2. The mapping may cross VMA boundaries if len extends beyond vma->vm_end.

Constrain the access in generic_access_phys() to at most the current page
boundary (PAGE_SIZE - offset) and map only a single PAGE_SIZE via
ioremap_prot().  Since the caller __access_remote_vm() already loops over
the requested length and handles partial transfers, it will naturally
iterate over the remaining pages.

Also add a missing (resource_size_t) cast during PFN re-validation to
avoid truncation on 32-bit PAE systems.

Link: https://lore.kernel.org/e06e28a46c2a176238f03b5740df0913e57c2861.1788842306.git.rakukuip@gmail.com
Fixes: 9cb12d7b4cca ("mm/memory.c: actually remap enough memory")
Signed-off-by: Luxiao Xu <rakukuip@gmail.com>
Signed-off-by: Ren Wei <weir@nebusec.ai>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Vega <vega@nebusec.ai>
Suggested-by: David Hildenbrand <david@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Assisted-by: LLM
Cc: Grazvydas Ignotas <notasas@gmail.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/memory.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 72793ec631072..d755b5c1f1287 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -6813,6 +6813,12 @@ int generic_access_phys(struct vm_area_struct *vma, unsigned long addr,
 	bool writable;
 	struct follow_pfnmap_args args = { .vma = vma, .address = addr };
 
+	/*
+	 * Limit access to one page at a time, as that's what follow_pfnmap_start()
+	 * guarantees; expect the caller to retry to read larger ranges.
+	 */
+	len = min_t(int, len, PAGE_SIZE - offset);
+
 retry:
 	if (follow_pfnmap_start(&args))
 		return -EINVAL;
@@ -6824,7 +6830,7 @@ int generic_access_phys(struct vm_area_struct *vma, unsigned long addr,
 	if ((write & FOLL_WRITE) && !writable)
 		return -EINVAL;
 
-	maddr = ioremap_prot(phys_addr, PAGE_ALIGN(len + offset), prot);
+	maddr = ioremap_prot(phys_addr, PAGE_SIZE, prot);
 	if (!maddr)
 		return -ENOMEM;
 
@@ -6832,7 +6838,7 @@ int generic_access_phys(struct vm_area_struct *vma, unsigned long addr,
 		goto out_unmap;
 
 	if ((pgprot_val(prot) != pgprot_val(args.pgprot)) ||
-	    (phys_addr != (args.pfn << PAGE_SHIFT)) ||
+	    (phys_addr != ((resource_size_t)args.pfn << PAGE_SHIFT)) ||
 	    (writable != args.writable)) {
 		follow_pfnmap_end(&args);
 		iounmap(maddr);
-- 
2.53.0



