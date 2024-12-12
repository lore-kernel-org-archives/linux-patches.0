Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F65C223E83;
	Thu, 12 Dec 2024 16:29:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020945; cv=none; b=nUvBvv8/XIcNES7W0CNWiNrEMkJwepR07czRYxht5k6IMSkmerfiwXX3sj6Bx3KnN38c20Eg+gF55aTKSJMBUaK5pVliwkxyKr/5kCan0S2MG0Jf1qvxA5WlXZtpcKL8dO/mMZ0hdSdV5c/czukfgWan9NODRh9UQoerdGzXBNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020945; c=relaxed/simple;
	bh=1s+mLff3jAtAyiMH75DTzdtnWR0V+dKLP3LlpxoGPr0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JkG0yKklEoePtBqmvy9Cdr5JBnQ6HE3pNDBrWaI0ZsdTCT6SNe+31nC7KPi+NvBz8TIAK4nxSTLth1FGZFv31In3xwCwbj/xTRd0QTtBF25VfJ28qyIgILb5jOMRGXMBaD+zuqsKTxqqp7z5dDeTNzA+rD9LlgXU57hBzStMVug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BRd4BIQU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BRd4BIQU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1DF3C4CED0;
	Thu, 12 Dec 2024 16:29:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020945;
	bh=1s+mLff3jAtAyiMH75DTzdtnWR0V+dKLP3LlpxoGPr0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BRd4BIQUDlhLEC0nH6ZPx4zvzZpGR9LeHlb+pn5jNVxZKNVS437ppJYpTs/K0/ddV
	 UZWFkeYq1Mikrzme8F49eUg43jX5vuSyX3k54vCJB1s/J3X3kxD4ccUNFjOkvsHIOa
	 G7PSVywO0hiT8Km97wKBKMEdiA0clESmKhG2cHkA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bibo Mao <maobibo@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.1 604/772] LoongArch: Add architecture specific huge_pte_clear()
Date: Thu, 12 Dec 2024 15:59:09 +0100
Message-ID: <20241212144414.879938224@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bibo Mao <maobibo@loongson.cn>

commit 7cd1f5f77925ae905a57296932f0f9ef0dc364f8 upstream.

When executing mm selftests run_vmtests.sh, there is such an error:

 BUG: Bad page state in process uffd-unit-tests  pfn:00000
 page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x0
 flags: 0xffff0000002000(reserved|node=0|zone=0|lastcpupid=0xffff)
 raw: 00ffff0000002000 ffffbf0000000008 ffffbf0000000008 0000000000000000
 raw: 0000000000000000 0000000000000000 00000000ffffffff 0000000000000000
 page dumped because: PAGE_FLAGS_CHECK_AT_FREE flag(s) set
 Modules linked in: snd_seq_dummy snd_seq snd_seq_device rfkill vfat fat
    virtio_balloon efi_pstore virtio_net pstore net_failover failover fuse
    nfnetlink virtio_scsi virtio_gpu virtio_dma_buf dm_multipath efivarfs
 CPU: 2 UID: 0 PID: 1913 Comm: uffd-unit-tests Not tainted 6.12.0 #184
 Hardware name: QEMU QEMU Virtual Machine, BIOS unknown 2/2/2022
 Stack : 900000047c8ac000 0000000000000000 9000000000223a7c 900000047c8ac000
         900000047c8af690 900000047c8af698 0000000000000000 900000047c8af7d8
         900000047c8af7d0 900000047c8af7d0 900000047c8af5b0 0000000000000001
         0000000000000001 900000047c8af698 10b3c7d53da40d26 0000010000000000
         0000000000000022 0000000fffffffff fffffffffe000000 ffff800000000000
         000000000000002f 0000800000000000 000000017a6d4000 90000000028f8940
         0000000000000000 0000000000000000 90000000025aa5e0 9000000002905000
         0000000000000000 90000000028f8940 ffff800000000000 0000000000000000
         0000000000000000 0000000000000000 9000000000223a94 000000012001839c
         00000000000000b0 0000000000000004 0000000000000000 0000000000071c1d
         ...
 Call Trace:
 [<9000000000223a94>] show_stack+0x5c/0x180
 [<9000000001c3fd64>] dump_stack_lvl+0x6c/0xa0
 [<900000000056aa08>] bad_page+0x1a0/0x1f0
 [<9000000000574978>] free_unref_folios+0xbf0/0xd20
 [<90000000004e65cc>] folios_put_refs+0x1a4/0x2b8
 [<9000000000599a0c>] free_pages_and_swap_cache+0x164/0x260
 [<9000000000547698>] tlb_batch_pages_flush+0xa8/0x1c0
 [<9000000000547f30>] tlb_finish_mmu+0xa8/0x218
 [<9000000000543cb8>] exit_mmap+0x1a0/0x360
 [<9000000000247658>] __mmput+0x78/0x200
 [<900000000025583c>] do_exit+0x43c/0xde8
 [<9000000000256490>] do_group_exit+0x68/0x110
 [<9000000000256554>] sys_exit_group+0x1c/0x20
 [<9000000001c413b4>] do_syscall+0x94/0x130
 [<90000000002216d8>] handle_syscall+0xb8/0x158
 Disabling lock debugging due to kernel taint
 BUG: non-zero pgtables_bytes on freeing mm: -16384

On LoongArch system, invalid huge pte entry should be invalid_pte_table
or a single _PAGE_HUGE bit rather than a zero value. And it should be
the same with invalid pmd entry, since pmd_none() is called by function
free_pgd_range() and pmd_none() return 0 by huge_pte_clear(). So single
_PAGE_HUGE bit is also treated as a valid pte table and free_pte_range()
will be called in free_pmd_range().

  free_pmd_range()
        pmd = pmd_offset(pud, addr);
        do {
                next = pmd_addr_end(addr, end);
                if (pmd_none_or_clear_bad(pmd))
                        continue;
                free_pte_range(tlb, pmd, addr);
        } while (pmd++, addr = next, addr != end);

Here invalid_pte_table is used for both invalid huge pte entry and
pmd entry.

Cc: stable@vger.kernel.org
Fixes: 09cfefb7fa70 ("LoongArch: Add memory management")
Signed-off-by: Bibo Mao <maobibo@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/include/asm/hugetlb.h |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/arch/loongarch/include/asm/hugetlb.h
+++ b/arch/loongarch/include/asm/hugetlb.h
@@ -29,6 +29,16 @@ static inline int prepare_hugepage_range
 	return 0;
 }
 
+#define __HAVE_ARCH_HUGE_PTE_CLEAR
+static inline void huge_pte_clear(struct mm_struct *mm, unsigned long addr,
+				  pte_t *ptep, unsigned long sz)
+{
+	pte_t clear;
+
+	pte_val(clear) = (unsigned long)invalid_pte_table;
+	set_pte_at(mm, addr, ptep, clear);
+}
+
 #define __HAVE_ARCH_HUGE_PTEP_GET_AND_CLEAR
 static inline pte_t huge_ptep_get_and_clear(struct mm_struct *mm,
 					    unsigned long addr, pte_t *ptep)


