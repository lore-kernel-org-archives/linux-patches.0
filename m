Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 783061CA8F;
	Mon,  1 Apr 2024 16:27:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988826; cv=none; b=E2Yd0n5iV/MxDdQm3yEeUkGX3Fn3FnsmCK6Jp8nAyaQp69DNb/v1j8kgq4TG+vPUu53iUxWNIf8qHrQ2NbsIA8CFwTS8BBrK0raoGDr2jLFTYGB9AD16hfPppolv4lN8Bs9zt57snqf0z2lMWzDYeTSTXDQ0tp1uYh9JOvluR6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988826; c=relaxed/simple;
	bh=rTJNyIfz3p6iZBWRubuwA7qpRIxiPNyz5PykmbRwgcY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=um3Ua/OFBU6FcFt3FDaBAx2JXHRgWMaHUReUNlXtQou6lP3/KeKOy9GOHYcs8CXX9t+sc1vZr7f9Rf/oSvEJSLrJs+267m1QZIx4uOdNwXO4pj/bujBR47x7fTe/oa+KPhhEt1a603duARFWl1vuWFG0HXu4+FkJz8GDFNZRtAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cWy2jXkD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cWy2jXkD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A30E3C433F1;
	Mon,  1 Apr 2024 16:27:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988826;
	bh=rTJNyIfz3p6iZBWRubuwA7qpRIxiPNyz5PykmbRwgcY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cWy2jXkDoehXiggX8oX0Ui5y3w9VUz0uWKo9X6e/hIFHIlP8FRfw3s+RSAn2wzo6l
	 ivPMtQO73gsqnK1Axvbw43Q53/cnPTf1QN55e3ZMAAD0cFZf9a6KHj+WzJk8TKZ2nX
	 E4Su/jFgjZB8K0/VTvdwh28o2F9ldJ5xXSjqY+1Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Rapoport <rppt@linux.ibm.com>,
	Yongqiang Liu <liuyongqiang13@huawei.com>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 300/432] ARM: 9359/1: flush: check if the folio is reserved for no-mapping addresses
Date: Mon,  1 Apr 2024 17:44:47 +0200
Message-ID: <20240401152602.135270032@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yongqiang Liu <liuyongqiang13@huawei.com>

[ Upstream commit 0c66c6f4e21cb22220cbd8821c5c73fc157d20dc ]

Since commit a4d5613c4dc6 ("arm: extend pfn_valid to take into account
freed memory map alignment") changes the semantics of pfn_valid() to check
presence of the memory map for a PFN. A valid page for an address which
is reserved but not mapped by the kernel[1], the system crashed during
some uio test with the following memory layout:

 node   0: [mem 0x00000000c0a00000-0x00000000cc8fffff]
 node   0: [mem 0x00000000d0000000-0x00000000da1fffff]
 the uio layout is：0xc0900000, 0x100000

the crash backtrace like:

  Unable to handle kernel paging request at virtual address bff00000
  [...]
  CPU: 1 PID: 465 Comm: startapp.bin Tainted: G           O      5.10.0 #1
  Hardware name: Generic DT based system
  PC is at b15_flush_kern_dcache_area+0x24/0x3c
  LR is at __sync_icache_dcache+0x6c/0x98
  [...]
   (b15_flush_kern_dcache_area) from (__sync_icache_dcache+0x6c/0x98)
   (__sync_icache_dcache) from (set_pte_at+0x28/0x54)
   (set_pte_at) from (remap_pfn_range+0x1a0/0x274)
   (remap_pfn_range) from (uio_mmap+0x184/0x1b8 [uio])
   (uio_mmap [uio]) from (__mmap_region+0x264/0x5f4)
   (__mmap_region) from (__do_mmap_mm+0x3ec/0x440)
   (__do_mmap_mm) from (do_mmap+0x50/0x58)
   (do_mmap) from (vm_mmap_pgoff+0xfc/0x188)
   (vm_mmap_pgoff) from (ksys_mmap_pgoff+0xac/0xc4)
   (ksys_mmap_pgoff) from (ret_fast_syscall+0x0/0x5c)
  Code: e0801001 e2423001 e1c00003 f57ff04f (ee070f3e)
  ---[ end trace 09cf0734c3805d52 ]---
  Kernel panic - not syncing: Fatal exception

So check if PG_reserved was set to solve this issue.

[1]: https://lore.kernel.org/lkml/Zbtdue57RO0QScJM@linux.ibm.com/

Fixes: a4d5613c4dc6 ("arm: extend pfn_valid to take into account freed memory map alignment")
Suggested-by: Mike Rapoport <rppt@linux.ibm.com>
Signed-off-by: Yongqiang Liu <liuyongqiang13@huawei.com>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mm/flush.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm/mm/flush.c b/arch/arm/mm/flush.c
index d19d140a10c7d..0749cf8a66371 100644
--- a/arch/arm/mm/flush.c
+++ b/arch/arm/mm/flush.c
@@ -296,6 +296,9 @@ void __sync_icache_dcache(pte_t pteval)
 		return;
 
 	folio = page_folio(pfn_to_page(pfn));
+	if (folio_test_reserved(folio))
+		return;
+
 	if (cache_is_vipt_aliasing())
 		mapping = folio_flush_mapping(folio);
 	else
-- 
2.43.0



