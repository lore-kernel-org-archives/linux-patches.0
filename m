Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EE7235F191;
	Sat, 12 Sep 2026 07:39:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198758; cv=none; b=Tr8dna3So2Btcx9XKNOgB3wQ5YmiAZ0864xCO/zwAbuttPz8SxuMIe7J0arEyVbCerzumXnPdybcbMbm8DbvmdnUAe3WJWsAc86mD2mtu7SsDIjSlQNBfS5pCQ62EX6Vw8wtgmWhn1/5bEqqA1+yYL4pPIK7kfY+17ZGqUM6MjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198758; c=relaxed/simple;
	bh=UugyX1lEnekOHYeUHlrZkxLAW+XzUKvp9hHN9rs/h8Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AHcAxdvrB7151OENc+ANiE//E0K40lrBnshiDCOXPEZG/ASsQDEdvRvpZZGYzalNUOz4PCQmWl0nq+lZMazEvCfP9tdfGk7H1cOLm4TC2AVEmPmaw45PTHK5t8ygplk451Jt+CNFRr2YkmuvhIxTH6XFiqPHyxeJeK0MVnpVAuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xkpIarMz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xkpIarMz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A03E01F000FF;
	Sat, 12 Sep 2026 07:39:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198757;
	bh=LXy7lShPj0zFW4+YhrOybkDsHv6OWLa2RSctdqUj4gw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xkpIarMzXOYr3Sd/CDVbgnhtLK5Fw1t4GGmf6FLJWaWBqDNG3HcxfA5KbpVev5bxo
	 jizwe874+Pms9zMoKUU4DVELvd3L7Uyuw8MNuJaQb8KdfLEBdVdMBZP1bElHlX7U6H
	 sDcvGl1heBMH+tiefgTcnjTan4lPNkPQk+9jVQZw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Denis V. Lunev" <den@openvz.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0445/1815] x86/mm/pat: Take cpa_lock around large-page collapse
Date: Sat, 12 Sep 2026 08:36:35 +0200
Message-ID: <20260912065659.341195650@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Denis V. Lunev <den@openvz.org>

[ Upstream commit 1aac65f3e651334259ecb2a5f5ddb81c01f02599 ]

Loading and unloading modules concurrently on several CPUs on a KASAN
build, with a short delay injected at the CPA page-table lookup to
widen the window, faults within minutes:

  BUG: KASAN: use-after-free in __change_page_attr+0x7cc/0x7e0
  Write of size 8 at addr ffff888181139718 by task modprobe
  ...
  The buggy address belongs to the physical page:
   pfn:0x181139 ... page_type: f2(table)

cpa_collapse_large_pages() rebuilds a leaf PMD from its 4K PTEs and
frees the old PTE-table pages, while __change_page_attr() fetches a
PTE pointer from a lockless lookup_address_in_pgd_attr() and writes
it with set_pte_atomic() only later. When module text is served from
a shared large ROX mapping the two run on the same PMD:

  CPU A (module load)              CPU B (module finalize)
  -------------------              -----------------------
  execmem_make_temp_rw
   set_memory_nx
    __change_page_attr
     split 2M -> 4K table P
     kpte = &P[i]  (lockless)
                                   execmem_restore_rox
                                    set_memory_rox (CPA_COLLAPSE)
                                     cpa_collapse_large_pages
                                      rebuild leaf PMD
                                      flush_tlb_all
                                      pagetable_free(P)
     set_pte_atomic(kpte, ...)
       -> writes into freed P

P is a page-table page (page_type: table), reused at once, so the
write corrupts whatever got the page next: a bad-pte or bad-page
splat, or a fatal fault once P has been turned into read-only text.

The flush_tlb_all() before the free does not close this: its IPI only
serializes against page-table walkers that run with interrupts off
(e.g. GUP-fast); the walk in __change_page_attr() runs with interrupts
on, so nothing stops it from holding a stale pointer into P.

Serialize the collapse - the PMD rebuild, TLB flush and PTE-table
free - under cpa_lock, the same lock __change_page_attr() now takes
unconditionally since commit ("x86/mm/pat: stop gating cpa_lock on
debug_pagealloc_enabled()"), so a concurrent walker can no longer
hold a pointer into a table the collapse is about to free.

Fixes: 41d88484c71c ("x86/mm/pat: restore large ROX pages after fragmentation")
Signed-off-by: Denis V. Lunev <den@openvz.org>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Link: https://patch.msgid.link/20260715183453.2381141-1-den@openvz.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/mm/pat/set_memory.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index d023a40a1e034..3b7e807e803c3 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -418,6 +418,8 @@ static void cpa_collapse_large_pages(struct cpa_data *cpa)
 	int collapsed = 0;
 	int i;
 
+	spin_lock(&cpa_lock);
+
 	if (cpa->flags & (CPA_PAGES_ARRAY | CPA_ARRAY)) {
 		for (i = 0; i < cpa->numpages; i++)
 			collapsed += collapse_large_pages(__cpa_addr(cpa, i),
@@ -431,8 +433,10 @@ static void cpa_collapse_large_pages(struct cpa_data *cpa)
 			collapsed += collapse_large_pages(addr, &pgtables);
 	}
 
-	if (!collapsed)
+	if (!collapsed) {
+		spin_unlock(&cpa_lock);
 		return;
+	}
 
 	flush_tlb_all();
 
@@ -440,6 +444,8 @@ static void cpa_collapse_large_pages(struct cpa_data *cpa)
 		list_del(&ptdesc->pt_list);
 		pagetable_free(ptdesc);
 	}
+
+	spin_unlock(&cpa_lock);
 }
 
 static void cpa_flush(struct cpa_data *cpa, int cache)
-- 
2.53.0



