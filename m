Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591448;
	b=YMxpVm73+lfwGFspS5QG4h0s6qQ25y1zH0h209A+wQs+dgVI/I1QLCkHXRFh/CgvbbUp
	 0zXQMNxQxvtwKzM3swdVPHdz3bSKiQOxvQtdOUwx+XmGfZFYaV0i/h1tCBEIZRnY0dYGk
	 LfHT/Pg2VAR9syNuWAgXjw/i3Y6zbyhCRqaI+j1BvhzYn3Uv/QxZ74e492jkR/pVnGUPM
	 dwPT0PkyAeSNG4S2XI6NFfeuK2OWABG4aXiv6jIXriK6yL5EkZ90IrbMXCg+iBMECGCNF
	 g0Ga2dtKT9whEEzVNZSh6XWH7myW/FYocG1oi6ZPsgr1veZABz7oEeiCxV/lGNzmxIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591448;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nUJdH+PDM8fc8NlahXH6TG+k0Jwe22TyL8JnV3+MzzI=;
	b=ePR1fGbhOTED2sa+k4KMeU5z5f8G8mr3rhAURhbK3q2x/rqBFTv5sAdRqUFwY7pVregH
	 WRzheiUbZ/2G2XqfSofd2HZYD16YWkG8AfoftbdpG7CD5/hgX0GzvYLrvSqnh4Osv66Fs
	 /asx2HZ0IbrOakIosfdZLvXVG9HKHMGXjDOn1dm+M0M4vaYr2iLau5iXG49IB09/HTf9e
	 sBae/L+jKBK8ggXuAOsSD7s2INog76si9sIT6rk6ploZakMJ+HIFdhxKsVs/O+H0ddq+d
	 sSCD5SwsEztpp49uCE6NwolJ/RfkkDSKNDvmsL/uQSRmL8lN6gHpz01Z0OPY2xRq3lw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Lzdp16mm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DEB7607C354;
	Fri, 13 Nov 2026 17:37:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Lzdp16mm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA9011F000C4;
	Fri, 13 Nov 2026 17:37:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591448;
	bh=nUJdH+PDM8fc8NlahXH6TG+k0Jwe22TyL8JnV3+MzzI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Lzdp16mmn0kFlQnKoHdLgyiJHl9hhwBb1qUYIJjDJwg+Z4moNJ8TthjXD3R0B0O8+
	 Ssg+ygbuyj1xJ9NAym0EjFrQYgsZWKicL+GagyZc3KZpRGND0HX1GK1TQWynMMncQc
	 KiA0bsU9udLvRRro+alrD/ESSUqoUB5EX5ugf/Ek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	syzbot+49b1021becba70c1f3f6@syzkaller.appspotmail.com,
	Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Rik van Riel <riel@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 537/670] mm: disallow ioremaping ordinary RAM in generic_access_phys()
Date: Fri, 13 Nov 2026 10:51:41 -0500
Message-ID: <20261113153830.098467700@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Hildenbrand (Arm) <david@kernel.org>

[ Upstream commit 4590752e20aa393cc0d4fe538c0747d14a98c97a ]

generic_access_phys() can end up getting called on CoW PFNMAP mappings,
resulting in it trying to ioremap anonymous folios, which especially
the x86 code doesn't enjoy, and which is in general just odd/wrong.

E.g., with a CoW mapping of a PCI BAR:

ioremap on RAM at 0x0000000045623000 - 0x0000000045623fff
  WARNING: arch/x86/mm/ioremap.c:216 at __ioremap_caller.isra.0+0x4c2/0x5f0
  Call Trace:
   generic_access_phys+0x130/0x4d0 mm/memory.c:7178
   kernfs_vma_access+0x1ce/0x280 fs/kernfs/file.c:437
   __access_remote_vm+0x58f/0x890 mm/memory.c:7256
   mem_rw+0x2a1/0x670 fs/proc/base.c:912

But more generically, we should disallow access to anything that looks
like ordinary RAM in the system: including allocating memory (e.g.,
alloc_pages) and mapping them in a VM_PFNMAP.

For pages with an online memmap, allow only pages marked as reserved
(PageReserved). This also includes memblock allocations, however,
distinguishing them from other MMIO is tricky, and nobody should really
be mapping them in a PFNMAP (except someone abusing /dev/mem, which we
do not care about).

So only allow access if there is no online memmap, or if the pages are
marked reserved. Reject other pages with -EINVAL.

Note that, just like other pfn_to_online_page() users, we won't care about
concurrent memory offlining; mapping memory that can concurrently get
offlined is highly dubious.

Link: https://lore.kernel.org/20261013-generic_access_phys-v1-1-b3963ef76e37@kernel.org
Fixes: 28b2ee20c7cb ("access_process_vm device memory infrastructure")
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: <syzbot+49b1021becba70c1f3f6@syzkaller.appspotmail.com>
Closes: https://syzkaller.appspot.com/bug?extid=49b1021becba70c1f3f6
Reported-by: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
Closes: https://lore.kernel.org/r/20261001152524.171115-1-ngocthang2710.1999@gmail.com/
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Tested-by: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Rik van Riel <riel@redhat.com>
Cc: <stable@vger.kernel.org>
[ sashal: adjusted context to preserve unsigned long protection handling with pgprot_val() instead of pgprot_t ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/memory.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/mm/memory.c b/mm/memory.c
index 564c0ce0aa6d7..379ebbb834565 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -6567,6 +6567,7 @@ int generic_access_phys(struct vm_area_struct *vma, unsigned long addr,
 	resource_size_t phys_addr;
 	unsigned long prot = 0;
 	void __iomem *maddr;
+	struct page *page;
 	int offset = offset_in_page(addr);
 	int ret = -EINVAL;
 	bool writable;
@@ -6575,6 +6576,19 @@ int generic_access_phys(struct vm_area_struct *vma, unsigned long addr,
 retry:
 	if (follow_pfnmap_start(&args))
 		return -EINVAL;
+
+	/*
+	 * Reject anything that looks like ordinary RAM, including anonymous
+	 * folios in CoW mappings or allocated kernel memory. Note that we
+	 * cannot distinguish memblock allocations from non-RAM reliably, so
+	 * we cannot easily reject them here.
+	 */
+	page = pfn_to_online_page(args.pfn);
+	if (page && !PageReserved(page)) {
+		follow_pfnmap_end(&args);
+		return -EINVAL;
+	}
+
 	prot = pgprot_val(args.pgprot);
 	phys_addr = (resource_size_t)args.pfn << PAGE_SHIFT;
 	writable = args.writable;
-- 
2.53.0



