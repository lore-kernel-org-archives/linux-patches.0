Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B6C634389F;
	Sat, 30 May 2026 17:40:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162846; cv=none; b=J43HkYtKpQiprFfLrJUSBiBIKpt0kOiNbPBE2xHCA2rAHqgwAm76q2ewJH0n6+Nq05/pIXn5rzLLnYZuhEWehM7x9l214PAS25+V8QYADk2cYH6ya4a3Pr3o2/0dp8jdl8RHDHuovh3aqcQStuIvQG4ZAUgrXvshTUaLlxUbyRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162846; c=relaxed/simple;
	bh=SahZPURBiBgrmZFUU4zWtB+Hc8zfMycF+9Y1VR+FwOg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dSzbwHnkbNMqks3zf4ohs/pIqY+6x9BZ5sf5qKqujROm1ggYb3F/oy+SiE0//He79gyDryoO74bhL5yI5njsf5P+JqqxmqKaXdLBao8s4piqXLgPwfgZrRNsYP+SjkJwIXKWg0Oa1L8LOjExzMNO9WC4LrEMdY3qjnwcMwGcCbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ck+iSjhU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ck+iSjhU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64FBE1F00893;
	Sat, 30 May 2026 17:40:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162845;
	bh=uo/rpiiiJrxEGp5a6eVLDyluXd7jaQcunh2LyBem134=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ck+iSjhUpjWyraxIz3luZLKSRG48MgMTAumtuuraCQ6ktdI4Wa/R2VTTwzIUL906Q
	 T2OvmtY9wBIBv4FfPXHG7umcCg8Wv17tNajOIi7eHv1bq1VC1js/Wa8tmlqnLmylcl
	 BHT+bp3w9NZoTL5k1nX7lvomhM+9hv0ZlP2XlRR0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
	Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.15 081/776] mm/kasan: fix double free for kasan pXds
Date: Sat, 30 May 2026 17:56:35 +0200
Message-ID: <20260530160242.422380550@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>

commit 51d8c78be0c27ddb91bc2c0263941d8b30a47d3b upstream.

kasan_free_pxd() assumes the page table is always struct page aligned.
But that's not always the case for all architectures.  E.g.  In case of
powerpc with 64K pagesize, PUD table (of size 4096) comes from slab cache
named pgtable-2^9.  Hence instead of page_to_virt(pxd_page()) let's just
directly pass the start of the pxd table which is passed as the 1st
argument.

This fixes the below double free kasan issue seen with PMEM:

radix-mmu: Mapped 0x0000047d10000000-0x0000047f90000000 with 2.00 MiB pages
==================================================================
BUG: KASAN: double-free in kasan_remove_zero_shadow+0x9c4/0xa20
Free of addr c0000003c38e0000 by task ndctl/2164

CPU: 34 UID: 0 PID: 2164 Comm: ndctl Not tainted 6.19.0-rc1-00048-gea1013c15392 #157 VOLUNTARY
Hardware name: IBM,9080-HEX POWER10 (architected) 0x800200 0xf000006 of:IBM,FW1060.00 (NH1060_012) hv:phyp pSeries
Call Trace:
 dump_stack_lvl+0x88/0xc4 (unreliable)
 print_report+0x214/0x63c
 kasan_report_invalid_free+0xe4/0x110
 check_slab_allocation+0x100/0x150
 kmem_cache_free+0x128/0x6e0
 kasan_remove_zero_shadow+0x9c4/0xa20
 memunmap_pages+0x2b8/0x5c0
 devm_action_release+0x54/0x70
 release_nodes+0xc8/0x1a0
 devres_release_all+0xe0/0x140
 device_unbind_cleanup+0x30/0x120
 device_release_driver_internal+0x3e4/0x450
 unbind_store+0xfc/0x110
 drv_attr_store+0x78/0xb0
 sysfs_kf_write+0x114/0x140
 kernfs_fop_write_iter+0x264/0x3f0
 vfs_write+0x3bc/0x7d0
 ksys_write+0xa4/0x190
 system_call_exception+0x190/0x480
 system_call_vectored_common+0x15c/0x2ec
---- interrupt: 3000 at 0x7fff93b3d3f4
NIP:  00007fff93b3d3f4 LR: 00007fff93b3d3f4 CTR: 0000000000000000
REGS: c0000003f1b07e80 TRAP: 3000   Not tainted  (6.19.0-rc1-00048-gea1013c15392)
MSR:  800000000280f033 <SF,VEC,VSX,EE,PR,FP,ME,IR,DR,RI,LE>  CR: 48888208  XER: 00000000
<...>
NIP [00007fff93b3d3f4] 0x7fff93b3d3f4
LR [00007fff93b3d3f4] 0x7fff93b3d3f4
---- interrupt: 3000

 The buggy address belongs to the object at c0000003c38e0000
  which belongs to the cache pgtable-2^9 of size 4096
 The buggy address is located 0 bytes inside of
  4096-byte region [c0000003c38e0000, c0000003c38e1000)

 The buggy address belongs to the physical page:
 page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x3c38c
 head: order:2 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
 memcg:c0000003bfd63e01
 flags: 0x63ffff800000040(head|node=6|zone=0|lastcpupid=0x7ffff)
 page_type: f5(slab)
 raw: 063ffff800000040 c000000140058980 5deadbeef0000122 0000000000000000
 raw: 0000000000000000 0000000080200020 00000000f5000000 c0000003bfd63e01
 head: 063ffff800000040 c000000140058980 5deadbeef0000122 0000000000000000
 head: 0000000000000000 0000000080200020 00000000f5000000 c0000003bfd63e01
 head: 063ffff800000002 c00c000000f0e301 00000000ffffffff 00000000ffffffff
 head: ffffffffffffffff 0000000000000000 00000000ffffffff 0000000000000004
 page dumped because: kasan: bad access detected

[  138.953636] [   T2164] Memory state around the buggy address:
[  138.953643] [   T2164]  c0000003c38dff00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[  138.953652] [   T2164]  c0000003c38dff80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[  138.953661] [   T2164] >c0000003c38e0000: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[  138.953669] [   T2164]                    ^
[  138.953675] [   T2164]  c0000003c38e0080: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[  138.953684] [   T2164]  c0000003c38e0100: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[  138.953692] [   T2164] ==================================================================
[  138.953701] [   T2164] Disabling lock debugging due to kernel taint

Link: https://lkml.kernel.org/r/2f9135c7866c6e0d06e960993b8a5674a9ebc7ec.1771938394.git.ritesh.list@gmail.com
Fixes: 0207df4fa1a8 ("kernel/memremap, kasan: make ZONE_DEVICE with work with KASAN")
Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Reported-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/kasan/init.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/kasan/init.c
+++ b/mm/kasan/init.c
@@ -290,7 +290,7 @@ static void kasan_free_pte(pte_t *pte_st
 			return;
 	}
 
-	pte_free_kernel(&init_mm, (pte_t *)page_to_virt(pmd_page(*pmd)));
+	pte_free_kernel(&init_mm, pte_start);
 	pmd_clear(pmd);
 }
 
@@ -305,7 +305,7 @@ static void kasan_free_pmd(pmd_t *pmd_st
 			return;
 	}
 
-	pmd_free(&init_mm, (pmd_t *)page_to_virt(pud_page(*pud)));
+	pmd_free(&init_mm, pmd_start);
 	pud_clear(pud);
 }
 
@@ -320,7 +320,7 @@ static void kasan_free_pud(pud_t *pud_st
 			return;
 	}
 
-	pud_free(&init_mm, (pud_t *)page_to_virt(p4d_page(*p4d)));
+	pud_free(&init_mm, pud_start);
 	p4d_clear(p4d);
 }
 
@@ -335,7 +335,7 @@ static void kasan_free_p4d(p4d_t *p4d_st
 			return;
 	}
 
-	p4d_free(&init_mm, (p4d_t *)page_to_virt(pgd_page(*pgd)));
+	p4d_free(&init_mm, p4d_start);
 	pgd_clear(pgd);
 }
 


