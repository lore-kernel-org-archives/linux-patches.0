Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216090;
	b=ymYCe8C9mBG8Ug8fbSVzkDWY+ZGfM7V1rmnXGmia2rMuW/o7js3j/yJUMNIysXh5/Zg/
	 4/V9/Cj1ny+KwUdwi9wxGKuKX2xDadnroWoY2wgdNLsFrfxJhfYQ056Coy1uVqOZFqiVu
	 jMzXElOETuqsCi3mUGthihACYhxsMrjntk9Ia8aXRnIOIgtZwVYdBpKy/jBoFbtQSL9uw
	 RW8TohHVPnJMuFFd6m9cJVI4ktGOKjjGvJ68iFpyn7QQK1Yvau7nlK0MOkJFJZQvLSu4m
	 apr2vtR/P6JVmbLO006gjchgZUpJ+HYa2AyEmLL2e0s9pnMeaDqNrl0KzneeCoHwlOg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216090;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qCJR8hJEJfSm0N6XiX2h1q8+xztzNPmK5CPPDN2eAnw=;
	b=DFyguyZZCLEe2qvqSMYeR6CNYrOTV/cmWAMZLksKTiLL55ni02eiAY1Q9t2HkoUZxux1
	 9cC7BOmjgFQkiXpqDgQHx9MFLrNMORdtP6hRQr0mJUIzlwysEOU6LfwrWWa8J84e584t9
	 y78nAN9ZBCzbBuNC3NqG/VBQCxsWIJH7PCTjrjFfhjNlE4ghLI8fHANDMhPAe+fsXrw0B
	 3HVU9U45eUPec9vZayU4c8+vfrJh3oO6HArkw1Kjiq69RZRUuEE5W0g8ecW0CxV45mOdp
	 rud5YVDSCufdQDUelnTisbLELGxsZLHL+CPXSGh69/O3FluGAYha+EVE8w3sSPuVnjQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TTtkChu5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F40AB606A31D;
	Wed, 28 Oct 2026 19:34:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TTtkChu5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57DB11F01825;
	Wed, 28 Oct 2026 19:34:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216089;
	bh=qCJR8hJEJfSm0N6XiX2h1q8+xztzNPmK5CPPDN2eAnw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TTtkChu5zjUdWomrjRbt+EptdQCPFDdxU1UcPBREMml+6Q6YXHhyn2et+3hIyf9FP
	 7B4daPNAQx2QcQRa/OZvjvNykeb8Mfap6U8NX5jU0m5QMawDzbTyqdVgj9uCkxcQvz
	 JbGpE61FrMboSoQgCJKrAt14of0o4rsUgFUwrsZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gavin Shan <gshan@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Don Dutile <ddutile@redhat.com>,
	Hugh Dickins <hughd@google.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	William Kucharski <william.kucharski@oracle.com>,
	Zhenyu Zhang <zhenyzha@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1437/1887] mm/filemap: skip to create PMD-sized page cache if needed
Date: Wed, 28 Oct 2026 17:58:53 +0100
Message-ID: <20261028170532.161266581@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gavin Shan <gshan@redhat.com>

[ Upstream commit 3390916aca7af1893ed2ebcdfee1d6fdb65bb058 ]

On ARM64, HPAGE_PMD_ORDER is 13 when the base page size is 64KB.  The
PMD-sized page cache can't be supported by xarray as the following error
messages indicate.

------------[ cut here ]------------
WARNING: CPU: 35 PID: 7484 at lib/xarray.c:1025 xas_split_alloc+0xf8/0x128
Modules linked in: nft_fib_inet nft_fib_ipv4 nft_fib_ipv6 nft_fib  \
nft_reject_inet nf_reject_ipv4 nf_reject_ipv6 nft_reject nft_ct    \
nft_chain_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4    \
ip_set rfkill nf_tables nfnetlink vfat fat virtio_balloon drm      \
fuse xfs libcrc32c crct10dif_ce ghash_ce sha2_ce sha256_arm64      \
sha1_ce virtio_net net_failover virtio_console virtio_blk failover \
dimlib virtio_mmio
CPU: 35 PID: 7484 Comm: test Kdump: loaded Tainted: G W 6.10.0-rc5-gavin+ #9
Hardware name: QEMU KVM Virtual Machine, BIOS edk2-20240524-1.el9 05/24/2024
pstate: 83400005 (Nzcv daif +PAN -UAO +TCO +DIT -SSBS BTYPE=--)
pc : xas_split_alloc+0xf8/0x128
lr : split_huge_page_to_list_to_order+0x1c4/0x720
sp : ffff800087a4f6c0
x29: ffff800087a4f6c0 x28: ffff800087a4f720 x27: 000000001fffffff
x26: 0000000000000c40 x25: 000000000000000d x24: ffff00010625b858
x23: ffff800087a4f720 x22: ffffffdfc0780000 x21: 0000000000000000
x20: 0000000000000000 x19: ffffffdfc0780000 x18: 000000001ff40000
x17: 00000000ffffffff x16: 0000018000000000 x15: 51ec004000000000
x14: 0000e00000000000 x13: 0000000000002000 x12: 0000000000000020
x11: 51ec000000000000 x10: 51ece1c0ffff8000 x9 : ffffbeb961a44d28
x8 : 0000000000000003 x7 : ffffffdfc0456420 x6 : ffff0000e1aa6eb8
x5 : 20bf08b4fe778fca x4 : ffffffdfc0456420 x3 : 0000000000000c40
x2 : 000000000000000d x1 : 000000000000000c x0 : 0000000000000000
Call trace:
 xas_split_alloc+0xf8/0x128
 split_huge_page_to_list_to_order+0x1c4/0x720
 truncate_inode_partial_folio+0xdc/0x160
 truncate_inode_pages_range+0x1b4/0x4a8
 truncate_pagecache_range+0x84/0xa0
 xfs_flush_unmap_range+0x70/0x90 [xfs]
 xfs_file_fallocate+0xfc/0x4d8 [xfs]
 vfs_fallocate+0x124/0x2e8
 ksys_fallocate+0x4c/0xa0
 __arm64_sys_fallocate+0x24/0x38
 invoke_syscall.constprop.0+0x7c/0xd8
 do_el0_svc+0xb4/0xd0
 el0_svc+0x44/0x1d8
 el0t_64_sync_handler+0x134/0x150
 el0t_64_sync+0x17c/0x180

Fix it by skipping to allocate PMD-sized page cache when its size is
larger than MAX_PAGECACHE_ORDER.  For this specific case, we will fall to
regular path where the readahead window is determined by BDI's sysfs file
(read_ahead_kb).

Link: https://lkml.kernel.org/r/20240627003953.1262512-4-gshan@redhat.com
Fixes: 4687fdbb805a ("mm/filemap: Support VM_HUGEPAGE for file mappings")
Signed-off-by: Gavin Shan <gshan@redhat.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Darrick J. Wong <djwong@kernel.org>
Cc: Don Dutile <ddutile@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: William Kucharski <william.kucharski@oracle.com>
Cc: Zhenyu Zhang <zhenyzha@redhat.com>
Cc: <stable@vger.kernel.org>	[5.18+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/filemap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 40c186c7210bf..62bad5bb57764 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -3112,7 +3112,7 @@ static struct file *do_sync_mmap_readahead(struct vm_fault *vmf)
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	/* Use the readahead code, even if readahead is disabled */
-	if (vm_flags & VM_HUGEPAGE) {
+	if ((vm_flags & VM_HUGEPAGE) && HPAGE_PMD_ORDER <= MAX_PAGECACHE_ORDER) {
 		fpin = maybe_unlock_mmap_for_io(vmf, fpin);
 		ractl._index &= ~((unsigned long)HPAGE_PMD_NR - 1);
 		ra->size = HPAGE_PMD_NR;
-- 
2.53.0



