Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0EEB17555;
	Sat, 30 May 2026 18:23:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165399; cv=none; b=FWzA3jeB9zf9xHuWKRzgAuq3infl1M6fGG7qgGWnw0F9u+WPd5ESudciUksMvkxvqi89flj6FBXY1VddeLHh5th3DwJI3LUr82QbwXWmugglIUQo3NNd+WoeAEwhiOzOV3D/uvtUaOyEAWHa5Wpwo3g6qM2eiKZGpmPMSXSW1JY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165399; c=relaxed/simple;
	bh=LSa+UKTFxEKDeGMDTb/zbyG3+h/NkA97f7G0ln3YyE0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YxbLD/yMefDPVFN9bYmqEqykLmDds5buaXhU6XFoS+pFmM+9dHwRPcGvUWlZspySjHRtQ5RpFgpspMMr/mKYnPqocJgT/m+esK52Nkp6oqfQ4I2HbEHujB92X2tyzjQRnQ3i+gebq/UgPds2PvRrmkmr+/GXaZPU1SxOCILVvw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s/QouLQL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s/QouLQL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 125B81F00893;
	Sat, 30 May 2026 18:23:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165398;
	bh=7yR+8vUlMjfqslzgbH4WAJP3qBvJpfc53U0LAxzcQVI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s/QouLQLInsFWm6ATmwanIoUazZYB6yZVHWmrNQgoTV3aWewwpp1lnCu/8Uq2j+js
	 uFPx/JUjorMe6Z3MmELK/p6aV9MFfSM4FMnR3AgM9n/bd2PlMadUoqFp+sCIr1jDbr
	 +m1pfqYoDrnUgl+wWwDiJHtrLWx/7VRmpw7updk8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Wiehler <stefan.wiehler@nokia.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 037/589] mips: mm: Allocate tlb_vpn array atomically
Date: Sat, 30 May 2026 17:58:38 +0200
Message-ID: <20260530160225.562411607@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Wiehler <stefan.wiehler@nokia.com>

commit 01cc50ea5167bb14117257ec084637abe9e5f691 upstream.

Found by DEBUG_ATOMIC_SLEEP:

  BUG: sleeping function called from invalid context at /include/linux/sched/mm.h:306
  in_atomic(): 1, irqs_disabled(): 1, non_block: 0, pid: 0, name: swapper/1
  preempt_count: 1, expected: 0
  RCU nest depth: 0, expected: 0
  no locks held by swapper/1/0.
  irq event stamp: 0
  hardirqs last  enabled at (0): [<0000000000000000>] 0x0
  hardirqs last disabled at (0): [<ffffffff801477fc>] copy_process+0x75c/0x1b68
  softirqs last  enabled at (0): [<ffffffff801477fc>] copy_process+0x75c/0x1b68
  softirqs last disabled at (0): [<0000000000000000>] 0x0
  CPU: 1 PID: 0 Comm: swapper/1 Not tainted 6.6.119-d79e757675ec-fct #1
  Stack : 800000000290bad8 0000000000000000 0000000000000008 800000000290bae8
          800000000290bae8 800000000290bc78 0000000000000000 0000000000000000
          ffffffff80c80000 0000000000000001 ffffffff80d8dee8 ffffffff810d09c0
          784bb2a7ec10647d 0000000000000010 ffffffff80a6fd60 8000000001d8a9c0
          0000000000000000 0000000000000000 ffffffff80d90000 0000000000000000
          ffffffff80c9e0e8 0000000007ffffff 0000000000000cc0 0000000000000400
          ffffffffffffffff 0000000000000001 0000000000000002 ffffffffc0149ed8
          fffffffffffffffe 8000000002908000 800000000290bae0 ffffffff80a81b74
          ffffffff80129fb0 0000000000000000 0000000000000000 0000000000000000
          0000000000000000 0000000000000000 ffffffff80129fd0 0000000000000000
          ...
  Call Trace:
  [<ffffffff80129fd0>] show_stack+0x60/0x158
  [<ffffffff80a7f894>] dump_stack_lvl+0x88/0xbc
  [<ffffffff8018d3c8>] __might_resched+0x268/0x288
  [<ffffffff803648b0>] __kmem_cache_alloc_node+0x2e0/0x330
  [<ffffffff80302788>] __kmalloc+0x58/0xd0
  [<ffffffff80a81b74>] r4k_tlb_uniquify+0x7c/0x428
  [<ffffffff80143e8c>] tlb_init+0x7c/0x110
  [<ffffffff8012bdb4>] per_cpu_trap_init+0x16c/0x1d0
  [<ffffffff80133258>] start_secondary+0x28/0x128

Fixes: 231ac951faba ("MIPS: mm: kmalloc tlb_vpn array to avoid stack overflow")
Signed-off-by: Stefan Wiehler <stefan.wiehler@nokia.com>
Cc: stable@vger.kernel.org
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/mm/tlb-r4k.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/mm/tlb-r4k.c b/arch/mips/mm/tlb-r4k.c
index 8bc98c311ca62..3aef6acd57bdd 100644
--- a/arch/mips/mm/tlb-r4k.c
+++ b/arch/mips/mm/tlb-r4k.c
@@ -528,7 +528,7 @@ static void __ref r4k_tlb_uniquify(void)
 
 	tlb_vpn_size = tlbsize * sizeof(*tlb_vpns);
 	tlb_vpns = (use_slab ?
-		    kmalloc(tlb_vpn_size, GFP_KERNEL) :
+		    kmalloc(tlb_vpn_size, GFP_ATOMIC) :
 		    memblock_alloc_raw(tlb_vpn_size, sizeof(*tlb_vpns)));
 	if (WARN_ON(!tlb_vpns))
 		return; /* Pray local_flush_tlb_all() is good enough. */
-- 
2.53.0



