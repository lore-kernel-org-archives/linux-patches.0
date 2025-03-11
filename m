Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 738041E1A18;
	Tue, 11 Mar 2025 15:34:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741707277; cv=none; b=YRPlR+kd/5JkbJfA2XrqcwaZi3dvyo3zExVZC+oeXt1LNV7O/px23/DA00aZyPewMfq4oTnkmtoboUw5cW6/OKp6Gmj1pMp4rIsep5RgycSQG8f1Xx1OOCvogrRzLSJymPv4Q4iim1mnIhV7v9SfM/NltDpcglCK9uQ01nbt2bI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741707277; c=relaxed/simple;
	bh=iSfTi5qeiPU2Ofq2zF0S4l+X+Gi/H8oBsolF8yo0lu0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T7eq3vE5htPofTMzhwLlOdv90uTqlKtLJFIjEiVlmfaz62Ae29sW80ElvUCXTpumjLdwq3ch+9ObvYn86jPWZj2hkRZfsU8GGQY3+zx/M/kOcsxSLyYyYykimmOBeetGmaIDMez+5ofBrk0o+/hrkDwC0YWwfBQTkQ6mSeRI7DA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qytJRjbC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qytJRjbC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E94F3C4CEE9;
	Tue, 11 Mar 2025 15:34:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741707277;
	bh=iSfTi5qeiPU2Ofq2zF0S4l+X+Gi/H8oBsolF8yo0lu0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qytJRjbCJU7i8bLtkREtHlusSUcA7u3edQoo4EEBqkc/Qv11Eja6rAfbgkPos+IbT
	 CPzqg2PDlHP1QVfFHm+Uwb/XPhrh3QG+7bczdX44fU+y0pJzl6n9mX6w5/664+mUzc
	 FzGqNzO19FpJ+PGaq0J0QNkkIYeL9+rT84xuwFbM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Erhard Furtner <erhard_f@mailbox.org>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 334/462] powerpc/code-patching: Fix KASAN hit by not flagging text patching area as VM_ALLOC
Date: Tue, 11 Mar 2025 16:00:00 +0100
Message-ID: <20250311145811.562981116@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe Leroy <christophe.leroy@csgroup.eu>

[ Upstream commit d262a192d38e527faa5984629aabda2e0d1c4f54 ]

Erhard reported the following KASAN hit while booting his PowerMac G4
with a KASAN-enabled kernel 6.13-rc6:

  BUG: KASAN: vmalloc-out-of-bounds in copy_to_kernel_nofault+0xd8/0x1c8
  Write of size 8 at addr f1000000 by task chronyd/1293

  CPU: 0 UID: 123 PID: 1293 Comm: chronyd Tainted: G        W          6.13.0-rc6-PMacG4 #2
  Tainted: [W]=WARN
  Hardware name: PowerMac3,6 7455 0x80010303 PowerMac
  Call Trace:
  [c2437590] [c1631a84] dump_stack_lvl+0x70/0x8c (unreliable)
  [c24375b0] [c0504998] print_report+0xdc/0x504
  [c2437610] [c050475c] kasan_report+0xf8/0x108
  [c2437690] [c0505a3c] kasan_check_range+0x24/0x18c
  [c24376a0] [c03fb5e4] copy_to_kernel_nofault+0xd8/0x1c8
  [c24376c0] [c004c014] patch_instructions+0x15c/0x16c
  [c2437710] [c00731a8] bpf_arch_text_copy+0x60/0x7c
  [c2437730] [c0281168] bpf_jit_binary_pack_finalize+0x50/0xac
  [c2437750] [c0073cf4] bpf_int_jit_compile+0xb30/0xdec
  [c2437880] [c0280394] bpf_prog_select_runtime+0x15c/0x478
  [c24378d0] [c1263428] bpf_prepare_filter+0xbf8/0xc14
  [c2437990] [c12677ec] bpf_prog_create_from_user+0x258/0x2b4
  [c24379d0] [c027111c] do_seccomp+0x3dc/0x1890
  [c2437ac0] [c001d8e0] system_call_exception+0x2dc/0x420
  [c2437f30] [c00281ac] ret_from_syscall+0x0/0x2c
  --- interrupt: c00 at 0x5a1274
  NIP:  005a1274 LR: 006a3b3c CTR: 005296c8
  REGS: c2437f40 TRAP: 0c00   Tainted: G        W           (6.13.0-rc6-PMacG4)
  MSR:  0200f932 <VEC,EE,PR,FP,ME,IR,DR,RI>  CR: 24004422  XER: 00000000

  GPR00: 00000166 af8f3fa0 a7ee3540 00000001 00000000 013b6500 005a5858 0200f932
  GPR08: 00000000 00001fe9 013d5fc8 005296c8 2822244c 00b2fcd8 00000000 af8f4b57
  GPR16: 00000000 00000001 00000000 00000000 00000000 00000001 00000000 00000002
  GPR24: 00afdbb0 00000000 00000000 00000000 006e0004 013ce060 006e7c1c 00000001
  NIP [005a1274] 0x5a1274
  LR [006a3b3c] 0x6a3b3c
  --- interrupt: c00

  The buggy address belongs to the virtual mapping at
   [f1000000, f1002000) created by:
   text_area_cpu_up+0x20/0x190

  The buggy address belongs to the physical page:
  page: refcount:1 mapcount:0 mapping:00000000 index:0x0 pfn:0x76e30
  flags: 0x80000000(zone=2)
  raw: 80000000 00000000 00000122 00000000 00000000 00000000 ffffffff 00000001
  raw: 00000000
  page dumped because: kasan: bad access detected

  Memory state around the buggy address:
   f0ffff00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
   f0ffff80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  >f1000000: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
             ^
   f1000080: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
   f1000100: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
  ==================================================================

f8 corresponds to KASAN_VMALLOC_INVALID which means the area is not
initialised hence not supposed to be used yet.

Powerpc text patching infrastructure allocates a virtual memory area
using get_vm_area() and flags it as VM_ALLOC. But that flag is meant
to be used for vmalloc() and vmalloc() allocated memory is not
supposed to be used before a call to __vmalloc_node_range() which is
never called for that area.

That went undetected until commit e4137f08816b ("mm, kasan, kmsan:
instrument copy_from/to_kernel_nofault")

The area allocated by text_area_cpu_up() is not vmalloc memory, it is
mapped directly on demand when needed by map_kernel_page(). There is
no VM flag corresponding to such usage, so just pass no flag. That way
the area will be unpoisonned and usable immediately.

Reported-by: Erhard Furtner <erhard_f@mailbox.org>
Closes: https://lore.kernel.org/all/20250112135832.57c92322@yea/
Fixes: 37bc3e5fd764 ("powerpc/lib/code-patching: Use alternate map for patch_instruction()")
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/06621423da339b374f48c0886e3a5db18e896be8.1739342693.git.christophe.leroy@csgroup.eu
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/lib/code-patching.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/lib/code-patching.c b/arch/powerpc/lib/code-patching.c
index a2e4f864b63d2..0af30b0977833 100644
--- a/arch/powerpc/lib/code-patching.c
+++ b/arch/powerpc/lib/code-patching.c
@@ -47,7 +47,7 @@ static int text_area_cpu_up(unsigned int cpu)
 {
 	struct vm_struct *area;
 
-	area = get_vm_area(PAGE_SIZE, VM_ALLOC);
+	area = get_vm_area(PAGE_SIZE, 0);
 	if (!area) {
 		WARN_ONCE(1, "Failed to create text area for cpu %d\n",
 			cpu);
-- 
2.39.5



