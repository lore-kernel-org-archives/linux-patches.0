Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216095;
	b=ZSqmyErXKXZNmBRE4X2YauduwXyyVbhRXjn7QbM0XwyXRQiswHhh9L7UBCYDz2Zhwb91
	 +XkyRMzmOi7kTrPPW6WWz3fha4rQWq0RM1yDf5kM/hYCkxk0fCQR9Cc9YQtjrEL6lRva8
	 e9hlaM5ZrYGu+fKhuZj6tHh4hz33gFP09lpiVKrSMEn3j+NyKeCe5PiK6Q/zAqooX7foK
	 jdquDZqT2WAPrrxI+gtNhL0lWmKfDgdcsvI5cmNpDkmq1kGqGBFlGU8rf9TdgxjYjH6g/
	 CqfKQc42r5v1T/LjKRI/DBJ9ReKvYowD2dh3fBdR6GhuxPGtkBs52IoHSGkS4toorQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216095;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=H6KdFZ7QuhlSTa9wnoky2N981nLXlO0ELlOgo/eIQjU=;
	b=vmvlQu+cnr4F2DLzjQAY/x58jBS2JtBOWueWiSA/6Gti6jy3yQEzyMHD/Q+zyHwEAzBq
	 3L0yaFGwrHl/tdlkRvUxax+WVu5hb5HUTYpfxQVtidAQshuubvW1QMvmpzWbGX/HCk5Fx
	 J83c/a92dZgYvd6R9VbfDCGPyMYOz+Fx1/sNs8qDF8h5Tj0s3PlQKaFGtJQiOiaSInYWT
	 uDXJRkEHcvOD2ZnAarzwu15cV4+EP7isduGoIngD7qg/BXhru/AN2+69/R/3aBLSkCQW9
	 va0fT3XL81sCGtnhPcLobGSIAAvZHT5bxmw6FmkzCDra6E+rjDtwALhiJUFX7ZnhlAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JxIE2WxH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D246606A31C;
	Wed, 28 Oct 2026 19:34:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JxIE2WxH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C66561F01825;
	Wed, 28 Oct 2026 19:34:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216095;
	bh=H6KdFZ7QuhlSTa9wnoky2N981nLXlO0ELlOgo/eIQjU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JxIE2WxHJ2RelZ7NBWvqRz4VJTPlW1UNO3M/N080srF8+OVepdeTve0DXX9i+k1fN
	 WHjVuqGhcnHOgqDUuSUM+Fx0qgnV7CVPFbdJEL7U5L4yF+UtWqS4o7jV3xQINPgqzU
	 gai3vY2JFTjXViHBa1uqRBeTG8y7b+QODT7oijwE=
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
Subject: [PATCH 6.1 1439/1887] mm/shmem: disable PMD-sized page cache if needed
Date: Wed, 28 Oct 2026 17:58:55 +0100
Message-ID: <20261028170532.205956397@linuxfoundation.org>
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

[ Upstream commit 9fd154ba926b34c833b7bfc4c14ee2e931b3d743 ]

For shmem files, it's possible that PMD-sized page cache can't be
supported by xarray.  For example, 512MB page cache on ARM64 when the base
page size is 64KB can't be supported by xarray.  It leads to errors as the
following messages indicate when this sort of xarray entry is split.

WARNING: CPU: 34 PID: 7578 at lib/xarray.c:1025 xas_split_alloc+0xf8/0x128
Modules linked in: binfmt_misc nft_fib_inet nft_fib_ipv4 nft_fib_ipv6   \
nft_fib nft_reject_inet nf_reject_ipv4 nf_reject_ipv6 nft_reject        \
nft_ct nft_chain_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4  \
ip_set rfkill nf_tables nfnetlink vfat fat virtio_balloon drm fuse xfs  \
libcrc32c crct10dif_ce ghash_ce sha2_ce sha256_arm64 sha1_ce virtio_net \
net_failover virtio_console virtio_blk failover dimlib virtio_mmio
CPU: 34 PID: 7578 Comm: test Kdump: loaded Tainted: G W 6.10.0-rc5-gavin+ #9
Hardware name: QEMU KVM Virtual Machine, BIOS edk2-20240524-1.el9 05/24/2024
pstate: 83400005 (Nzcv daif +PAN -UAO +TCO +DIT -SSBS BTYPE=--)
pc : xas_split_alloc+0xf8/0x128
lr : split_huge_page_to_list_to_order+0x1c4/0x720
sp : ffff8000882af5f0
x29: ffff8000882af5f0 x28: ffff8000882af650 x27: ffff8000882af768
x26: 0000000000000cc0 x25: 000000000000000d x24: ffff00010625b858
x23: ffff8000882af650 x22: ffffffdfc0900000 x21: 0000000000000000
x20: 0000000000000000 x19: ffffffdfc0900000 x18: 0000000000000000
x17: 0000000000000000 x16: 0000018000000000 x15: 52f8004000000000
x14: 0000e00000000000 x13: 0000000000002000 x12: 0000000000000020
x11: 52f8000000000000 x10: 52f8e1c0ffff6000 x9 : ffffbeb9619a681c
x8 : 0000000000000003 x7 : 0000000000000000 x6 : ffff00010b02ddb0
x5 : ffffbeb96395e378 x4 : 0000000000000000 x3 : 0000000000000cc0
x2 : 000000000000000d x1 : 000000000000000c x0 : 0000000000000000
Call trace:
 xas_split_alloc+0xf8/0x128
 split_huge_page_to_list_to_order+0x1c4/0x720
 truncate_inode_partial_folio+0xdc/0x160
 shmem_undo_range+0x2bc/0x6a8
 shmem_fallocate+0x134/0x430
 vfs_fallocate+0x124/0x2e8
 ksys_fallocate+0x4c/0xa0
 __arm64_sys_fallocate+0x24/0x38
 invoke_syscall.constprop.0+0x7c/0xd8
 do_el0_svc+0xb4/0xd0
 el0_svc+0x44/0x1d8
 el0t_64_sync_handler+0x134/0x150
 el0t_64_sync+0x17c/0x180

Fix it by disabling PMD-sized page cache when HPAGE_PMD_ORDER is larger
than MAX_PAGECACHE_ORDER.  As Matthew Wilcox pointed, the page cache in a
shmem file isn't represented by a multi-index entry and doesn't have this
limitation when the xarry entry is split until commit 6b24ca4a1a8d ("mm:
Use multi-index entries in the page cache").

Link: https://lkml.kernel.org/r/20240627003953.1262512-5-gshan@redhat.com
Fixes: 6b24ca4a1a8d ("mm: Use multi-index entries in the page cache")
Signed-off-by: Gavin Shan <gshan@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Darrick J. Wong <djwong@kernel.org>
Cc: Don Dutile <ddutile@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: William Kucharski <william.kucharski@oracle.com>
Cc: Zhenyu Zhang <zhenyzha@redhat.com>
Cc: <stable@vger.kernel.org>	[5.17+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/shmem.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 2034b9b3fb718..cfc573e04327c 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -462,8 +462,8 @@ static bool shmem_confirm_swap(struct address_space *mapping,
 
 static int shmem_huge __read_mostly = SHMEM_HUGE_NEVER;
 
-bool shmem_is_huge(struct vm_area_struct *vma, struct inode *inode,
-		   pgoff_t index, bool shmem_huge_force)
+static bool __shmem_is_huge(struct vm_area_struct *vma, struct inode *inode,
+			    pgoff_t index, bool shmem_huge_force)
 {
 	loff_t i_size;
 
@@ -495,6 +495,15 @@ bool shmem_is_huge(struct vm_area_struct *vma, struct inode *inode,
 	}
 }
 
+bool shmem_is_huge(struct vm_area_struct *vma, struct inode *inode,
+		   pgoff_t index, bool shmem_huge_force)
+{
+	if (HPAGE_PMD_ORDER > MAX_PAGECACHE_ORDER)
+		return false;
+
+	return __shmem_is_huge(vma, inode, index, shmem_huge_force);
+}
+
 #if defined(CONFIG_SYSFS)
 static int shmem_parse_huge(const char *str)
 {
-- 
2.53.0



