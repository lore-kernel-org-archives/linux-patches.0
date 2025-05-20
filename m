Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ADF724676D;
	Tue, 20 May 2025 13:59:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749551; cv=none; b=g/KZM5lnx7tBNfph6G+Oga/JLxo3tFNYdvYRmpwbAqGQP4Bgw5eviLPhZ8uZkmF96m7nC0cdF97YDkQf/GRmqrSKjtLhymsDF5X7t5j1FIx9WIgOcvihocJIo6C4UoBDZ2PnDTP95AAiTXS5ih9r9E2lWKwyv0Xy0hpRZjXyWTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749551; c=relaxed/simple;
	bh=swU1ICKZaV3+lrFWbchn54Ct0yOFYePk3ZSMyPsb2ks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UQcmaUnMktyKETUcZM9iA6IRps14e46+hix7BjZBNQK/MW1ims7aJqlnDfqjTWmrbDsi7hNhZmuqvRBEVPlZJY49Ox/EachG5DhI6Pzu5v2jdlMFvc+qFwvvp9y33p+qBHtuYXFzE7eoD51AB+Bfp9+ihqPVt1aRiF58uzH93us=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M8cSjNDH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M8cSjNDH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E34D6C4CEE9;
	Tue, 20 May 2025 13:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749551;
	bh=swU1ICKZaV3+lrFWbchn54Ct0yOFYePk3ZSMyPsb2ks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M8cSjNDHjVC4XKr+3TXdEmWAEx05uUUG1QquAyYKSDgCSwLYCf6pN8oXG7+/wGAWo
	 NzBZV4kmmGpMdiv0CeK9gGjzSJseUnfR2AzZFVWrgCRE+E/TMT9dlUCdqprJKbcr7s
	 wdu7xg8Xam9TK9I2bK9Wk1S0ausAJl4DxxcoNZDE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Byungchul Park <byungchul@sk.com>,
	Hyeongtak Ji <hyeongtak.ji@sk.com>,
	Oscar Salvador <osalvador@suse.de>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Huang, Ying" <ying.huang@intel.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jianqi Ren <jianqi.ren.cn@windriver.com>,
	He Zhe <zhe.he@windriver.com>
Subject: [PATCH 6.1 80/97] mm/vmscan: fix a bug calling wakeup_kswapd() with a wrong zone index
Date: Tue, 20 May 2025 15:50:45 +0200
Message-ID: <20250520125803.774042930@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125800.653047540@linuxfoundation.org>
References: <20250520125800.653047540@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Byungchul Park <byungchul@sk.com>

commit 2774f256e7c0219e2b0a0894af1c76bdabc4f974 upstream.

With numa balancing on, when a numa system is running where a numa node
doesn't have its local memory so it has no managed zones, the following
oops has been observed.  It's because wakeup_kswapd() is called with a
wrong zone index, -1.  Fixed it by checking the index before calling
wakeup_kswapd().

> BUG: unable to handle page fault for address: 00000000000033f3
> #PF: supervisor read access in kernel mode
> #PF: error_code(0x0000) - not-present page
> PGD 0 P4D 0
> Oops: 0000 [#1] PREEMPT SMP NOPTI
> CPU: 2 PID: 895 Comm: masim Not tainted 6.6.0-dirty #255
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
>    rel-1.16.0-0-gd239552ce722-prebuilt.qemu.org 04/01/2014
> RIP: 0010:wakeup_kswapd (./linux/mm/vmscan.c:7812)
> Code: (omitted)
> RSP: 0000:ffffc90004257d58 EFLAGS: 00010286
> RAX: ffffffffffffffff RBX: ffff88883fff0480 RCX: 0000000000000003
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff88883fff0480
> RBP: ffffffffffffffff R08: ff0003ffffffffff R09: ffffffffffffffff
> R10: ffff888106c95540 R11: 0000000055555554 R12: 0000000000000003
> R13: 0000000000000000 R14: 0000000000000000 R15: ffff88883fff0940
> FS:  00007fc4b8124740(0000) GS:ffff888827c00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00000000000033f3 CR3: 000000026cc08004 CR4: 0000000000770ee0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> PKRU: 55555554
> Call Trace:
>  <TASK>
> ? __die
> ? page_fault_oops
> ? __pte_offset_map_lock
> ? exc_page_fault
> ? asm_exc_page_fault
> ? wakeup_kswapd
> migrate_misplaced_page
> __handle_mm_fault
> handle_mm_fault
> do_user_addr_fault
> exc_page_fault
> asm_exc_page_fault
> RIP: 0033:0x55b897ba0808
> Code: (omitted)
> RSP: 002b:00007ffeefa821a0 EFLAGS: 00010287
> RAX: 000055b89983acd0 RBX: 00007ffeefa823f8 RCX: 000055b89983acd0
> RDX: 00007fc2f8122010 RSI: 0000000000020000 RDI: 000055b89983acd0
> RBP: 00007ffeefa821a0 R08: 0000000000000037 R09: 0000000000000075
> R10: 0000000000000000 R11: 0000000000000202 R12: 0000000000000000
> R13: 00007ffeefa82410 R14: 000055b897ba5dd8 R15: 00007fc4b8340000
>  </TASK>

Link: https://lkml.kernel.org/r/20240216111502.79759-1-byungchul@sk.com
Signed-off-by: Byungchul Park <byungchul@sk.com>
Reported-by: Hyeongtak Ji <hyeongtak.ji@sk.com>
Fixes: c574bbe917036 ("NUMA balancing: optimize page placement for memory tiering system")
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Jianqi Ren <jianqi.ren.cn@windriver.com>
Signed-off-by: He Zhe <zhe.he@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/migrate.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -2422,6 +2422,14 @@ static int numamigrate_isolate_page(pg_d
 			if (managed_zone(pgdat->node_zones + z))
 				break;
 		}
+
+		/*
+		 * If there are no managed zones, it should not proceed
+		 * further.
+		 */
+		if (z < 0)
+			return 0;
+
 		wakeup_kswapd(pgdat->node_zones + z, 0, order, ZONE_MOVABLE);
 		return 0;
 	}


