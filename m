Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BCC717555;
	Fri, 15 Nov 2024 07:00:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731654012; cv=none; b=USNpT0Y+E3fDJlU/i4+3thpuzW86S18eQs/5YFsvHqkbsUQE7LFUaXZEP2N16vGQHvmIEjAF4wInmk6RHqF3nulr96tOIfqYtiu2EFJyR6PeEgG/Kkr3V24XTUqJc1th2CgtWBeQeKdd/V2LP/3TZ17MuCC4Jqao5caG5OAkmkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731654012; c=relaxed/simple;
	bh=HntWg3GeWxqq9ZAL/g1sKPDbs39I8xTZ7xv+lPNMwQw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BH6x7OpxC3f0d+iuGZ1m5rLy/8L5OzITIWTlQFgSuU7IS89TrM85UzEe6uOGRgMcXj2q4LDDt7vYpnyjCGo/9NEFFxFsw1jmnH5puOeIU5ol4e9BHidISX0TZlkk0SqTewXHXmpdskv0ASy3/akd29BNawbyM3R9VIW6jmBHZ/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XISMvam4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XISMvam4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE204C4CECF;
	Fri, 15 Nov 2024 07:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731654012;
	bh=HntWg3GeWxqq9ZAL/g1sKPDbs39I8xTZ7xv+lPNMwQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XISMvam4YhFjI5E1dMara/IjxKoV/2nkbMSf2PC1rCd6l+zxdEdMHdbu33KvymP3f
	 /HVKaZuXK9aPr/1zMIG7IyHsFFtOpcIQYYwf9+uaLp6LHuAIoBociYdzVO4pic+hpF
	 oWrWEbgOaNd6lh946pQk8pgJIwdkhxN4A93KrgLs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuanzheng Song <songyuanzheng@huawei.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	David Hildenbrand <david@redhat.com>
Subject: [PATCH 5.15 19/22] mm/memory: add non-anonymous page check in the copy_present_page()
Date: Fri, 15 Nov 2024 07:39:05 +0100
Message-ID: <20241115063721.869017519@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063721.172791419@linuxfoundation.org>
References: <20241115063721.172791419@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Yuanzheng Song <songyuanzheng@huawei.com>

The vma->anon_vma of the child process may be NULL because
the entire vma does not contain anonymous pages. In this
case, a BUG will occur when the copy_present_page() passes
a copy of a non-anonymous page of that vma to the
page_add_new_anon_rmap() to set up new anonymous rmap.

------------[ cut here ]------------
kernel BUG at mm/rmap.c:1052!
Internal error: Oops - BUG: 0 [#1] SMP
Modules linked in:
CPU: 4 PID: 4652 Comm: test Not tainted 5.15.75 #1
Hardware name: linux,dummy-virt (DT)
pstate: 80000005 (Nzcv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : __page_set_anon_rmap+0xc0/0xe8
lr : __page_set_anon_rmap+0xc0/0xe8
sp : ffff80000e773860
x29: ffff80000e773860 x28: fffffc13cf006ec0 x27: ffff04f3ccd68000
x26: ffff04f3c5c33248 x25: 0000000010100073 x24: ffff04f3c53c0a80
x23: 0000000020000000 x22: 0000000000000001 x21: 0000000020000000
x20: fffffc13cf006ec0 x19: 0000000000000000 x18: 0000000000000000
x17: 0000000000000000 x16: 0000000000000000 x15: 0000000000000000
x14: 0000000000000000 x13: 0000000000000000 x12: 0000000000000000
x11: 0000000000000000 x10: 0000000000000000 x9 : ffffdddc5581377c
x8 : 0000000000000000 x7 : 0000000000000011 x6 : ffff2717a8433000
x5 : ffff80000e773810 x4 : ffffdddc55400000 x3 : 0000000000000000
x2 : ffffdddc56b20000 x1 : ffff04f3c9a48040 x0 : 0000000000000000
Call trace:
 __page_set_anon_rmap+0xc0/0xe8
 page_add_new_anon_rmap+0x13c/0x200
 copy_pte_range+0x6b8/0x1018
 copy_page_range+0x3a8/0x5e0
 dup_mmap+0x3a0/0x6e8
 dup_mm+0x78/0x140
 copy_process+0x1528/0x1b08
 kernel_clone+0xac/0x610
 __do_sys_clone+0x78/0xb0
 __arm64_sys_clone+0x30/0x40
 invoke_syscall+0x68/0x170
 el0_svc_common.constprop.0+0x80/0x250
 do_el0_svc+0x48/0xb8
 el0_svc+0x48/0x1a8
 el0t_64_sync_handler+0xb0/0xb8
 el0t_64_sync+0x1a0/0x1a4
Code: 97f899f4 f9400273 17ffffeb 97f899f1 (d4210000)
---[ end trace dc65e5edd0f362fa ]---
Kernel panic - not syncing: Oops - BUG: Fatal exception
SMP: stopping secondary CPUs
Kernel Offset: 0x5ddc4d400000 from 0xffff800008000000
PHYS_OFFSET: 0xfffffb0c80000000
CPU features: 0x44000cf1,00000806
Memory Limit: none
---[ end Kernel panic - not syncing: Oops - BUG: Fatal exception ]---

This problem has been fixed by the commit <fb3d824d1a46>
("mm/rmap: split page_dup_rmap() into page_dup_file_rmap()
and page_try_dup_anon_rmap()"), but still exists in the
linux-5.15.y branch.

This patch is not applicable to this version because
of the large version differences. Therefore, fix it by
adding non-anonymous page check in the copy_present_page().

Cc: stable@vger.kernel.org
Fixes: 70e806e4e645 ("mm: Do early cow for pinned pages during fork() for ptes")
Signed-off-by: Yuanzheng Song <songyuanzheng@huawei.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/memory.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/mm/memory.c
+++ b/mm/memory.c
@@ -903,6 +903,17 @@ copy_present_page(struct vm_area_struct
 	if (likely(!page_needs_cow_for_dma(src_vma, page)))
 		return 1;
 
+	/*
+	 * The vma->anon_vma of the child process may be NULL
+	 * because the entire vma does not contain anonymous pages.
+	 * A BUG will occur when the copy_present_page() passes
+	 * a copy of a non-anonymous page of that vma to the
+	 * page_add_new_anon_rmap() to set up new anonymous rmap.
+	 * Return 1 if the page is not an anonymous page.
+	 */
+	if (!PageAnon(page))
+		return 1;
+
 	new_page = *prealloc;
 	if (!new_page)
 		return -EAGAIN;


