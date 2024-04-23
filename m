Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD3CE14D282;
	Tue, 23 Apr 2024 21:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908815; cv=none; b=hs3iNZ2SRNs2pjdewvxoO649XATx2wVPct5EPCGdgc/RG6Jfb1Ii/aZ4FBiA1fkgGyV2u4E+rfIA7ST23Ub8/IJM8Ein7be8i7jusGzpUCqCOq/1UDh3RWuEx8+Qk7aLZJ1J93a7hP7LVseeEKo/oBk3VqTovN6dGyl+2cXEnqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908815; c=relaxed/simple;
	bh=EFyQS+SQYRNiSbzKYbbi59bV/KVZKXFj0bVRr+JPJ/s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IX2nv34UcVbIU7bpqU0FEJpijpnuuBlDr91XiXzG0xS63sfGeXkQ+xMh5WXadT5/nsqYSL+Z5bJHlFDo+fJqpYhdlRygMQzZp0DOmf5M1nsSOiXt+pNQ2HXGFCNdbQDYYWhMl1CVbifxPGqR/xm5jaBB8C9Q57yLF9BKzPlhoXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yWfSlfhP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yWfSlfhP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C13EC3277B;
	Tue, 23 Apr 2024 21:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908815;
	bh=EFyQS+SQYRNiSbzKYbbi59bV/KVZKXFj0bVRr+JPJ/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yWfSlfhPLT378b+Qyx/Dc7UyGHN85GsSy1H/4iojV6XPeLZuRgAWi2IYeXLKzc9Hm
	 oLxPzR4KH5MUdOKQe2ZK1W/JXGM/AFQdphmJs9UHHwM0OTZugXHsns5gFv3oS6XdZv
	 5Ad+LkTRsHUD2jVZ+PwIIBPb1BDbsQS8w8gZ04HI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Rapoport <rppt@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	xiongxin <xiongxin@kylinos.cn>,
	Yaxiong Tian <tianyaxiong@kylinos.cn>
Subject: [PATCH 5.15 61/71] arm64: hibernate: Fix level3 translation fault in swsusp_save()
Date: Tue, 23 Apr 2024 14:40:14 -0700
Message-ID: <20240423213846.284541718@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213844.122920086@linuxfoundation.org>
References: <20240423213844.122920086@linuxfoundation.org>
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

From: Yaxiong Tian <tianyaxiong@kylinos.cn>

commit 50449ca66cc5a8cbc64749cf4b9f3d3fc5f4b457 upstream.

On arm64 machines, swsusp_save() faults if it attempts to access
MEMBLOCK_NOMAP memory ranges. This can be reproduced in QEMU using UEFI
when booting with rodata=off debug_pagealloc=off and CONFIG_KFENCE=n:

  Unable to handle kernel paging request at virtual address ffffff8000000000
  Mem abort info:
    ESR = 0x0000000096000007
    EC = 0x25: DABT (current EL), IL = 32 bits
    SET = 0, FnV = 0
    EA = 0, S1PTW = 0
    FSC = 0x07: level 3 translation fault
  Data abort info:
    ISV = 0, ISS = 0x00000007, ISS2 = 0x00000000
    CM = 0, WnR = 0, TnD = 0, TagAccess = 0
    GCS = 0, Overlay = 0, DirtyBit = 0, Xs = 0
  swapper pgtable: 4k pages, 39-bit VAs, pgdp=00000000eeb0b000
  [ffffff8000000000] pgd=180000217fff9803, p4d=180000217fff9803, pud=180000217fff9803, pmd=180000217fff8803, pte=0000000000000000
  Internal error: Oops: 0000000096000007 [#1] SMP
  Internal error: Oops: 0000000096000007 [#1] SMP
  Modules linked in: xt_multiport ipt_REJECT nf_reject_ipv4 xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 libcrc32c iptable_filter bpfilter rfkill at803x snd_hda_codec_hdmi snd_hda_intel snd_intel_dspcfg dwmac_generic stmmac_platform snd_hda_codec stmmac joydev pcs_xpcs snd_hda_core phylink ppdev lp parport ramoops reed_solomon ip_tables x_tables nls_iso8859_1 vfat multipath linear amdgpu amdxcp drm_exec gpu_sched drm_buddy hid_generic usbhid hid radeon video drm_suballoc_helper drm_ttm_helper ttm i2c_algo_bit drm_display_helper cec drm_kms_helper drm
  CPU: 0 PID: 3663 Comm: systemd-sleep Not tainted 6.6.2+ #76
  Source Version: 4e22ed63a0a48e7a7cff9b98b7806d8d4add7dc0
  Hardware name: Greatwall GW-XXXXXX-XXX/GW-XXXXXX-XXX, BIOS KunLun BIOS V4.0 01/19/2021
  pstate: 600003c5 (nZCv DAIF -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
  pc : swsusp_save+0x280/0x538
  lr : swsusp_save+0x280/0x538
  sp : ffffffa034a3fa40
  x29: ffffffa034a3fa40 x28: ffffff8000001000 x27: 0000000000000000
  x26: ffffff8001400000 x25: ffffffc08113e248 x24: 0000000000000000
  x23: 0000000000080000 x22: ffffffc08113e280 x21: 00000000000c69f2
  x20: ffffff8000000000 x19: ffffffc081ae2500 x18: 0000000000000000
  x17: 6666662074736420 x16: 3030303030303030 x15: 3038666666666666
  x14: 0000000000000b69 x13: ffffff9f89088530 x12: 00000000ffffffea
  x11: 00000000ffff7fff x10: 00000000ffff7fff x9 : ffffffc08193f0d0
  x8 : 00000000000bffe8 x7 : c0000000ffff7fff x6 : 0000000000000001
  x5 : ffffffa0fff09dc8 x4 : 0000000000000000 x3 : 0000000000000027
  x2 : 0000000000000000 x1 : 0000000000000000 x0 : 000000000000004e
  Call trace:
   swsusp_save+0x280/0x538
   swsusp_arch_suspend+0x148/0x190
   hibernation_snapshot+0x240/0x39c
   hibernate+0xc4/0x378
   state_store+0xf0/0x10c
   kobj_attr_store+0x14/0x24

The reason is swsusp_save() -> copy_data_pages() -> page_is_saveable()
-> kernel_page_present() assuming that a page is always present when
can_set_direct_map() is false (all of rodata_full,
debug_pagealloc_enabled() and arm64_kfence_can_set_direct_map() false),
irrespective of the MEMBLOCK_NOMAP ranges. Such MEMBLOCK_NOMAP regions
should not be saved during hibernation.

This problem was introduced by changes to the pfn_valid() logic in
commit a7d9f306ba70 ("arm64: drop pfn_valid_within() and simplify
pfn_valid()").

Similar to other architectures, drop the !can_set_direct_map() check in
kernel_page_present() so that page_is_savable() skips such pages.

Fixes: a7d9f306ba70 ("arm64: drop pfn_valid_within() and simplify pfn_valid()")
Cc: <stable@vger.kernel.org> # 5.14.x
Suggested-by: Mike Rapoport <rppt@kernel.org>
Suggested-by: Catalin Marinas <catalin.marinas@arm.com>
Co-developed-by: xiongxin <xiongxin@kylinos.cn>
Signed-off-by: xiongxin <xiongxin@kylinos.cn>
Signed-off-by: Yaxiong Tian <tianyaxiong@kylinos.cn>
Acked-by: Mike Rapoport (IBM) <rppt@kernel.org>
Link: https://lore.kernel.org/r/20240417025248.386622-1-tianyaxiong@kylinos.cn
[catalin.marinas@arm.com: rework commit message]
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/mm/pageattr.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/arch/arm64/mm/pageattr.c
+++ b/arch/arm64/mm/pageattr.c
@@ -211,9 +211,6 @@ bool kernel_page_present(struct page *pa
 	pte_t *ptep;
 	unsigned long addr = (unsigned long)page_address(page);
 
-	if (!can_set_direct_map())
-		return true;
-
 	pgdp = pgd_offset_k(addr);
 	if (pgd_none(READ_ONCE(*pgdp)))
 		return false;


