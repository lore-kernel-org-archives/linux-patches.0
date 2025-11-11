Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80980246333;
	Tue, 11 Nov 2025 01:44:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825459; cv=none; b=DqSM2wU5TTaVrNYKVOyOT+fPNNBbCh3D8/mZabDupF88FDXmwmbk96Nv3nnrCdIdWw58HPMC/8Cn4NqcqZ6oOAZ625Uj5no08+Ke0mz8R1WsPaMq8/qHl6aTY6BEpCIsn5vKYOzF+qG16vgwOHLnDstvT4WavvUrzKtHI2TNpTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825459; c=relaxed/simple;
	bh=ESaPQlBzqpq9EqMx3AwvSvGVfcj22h5MONTrMSI2pVg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UdF1A0Z3Kl4UaMaIGeinoLUD+GnvG1+yE+yl5JvDQuWdlxR3+kg9Ps0RFp41el9s9r64l2eXlBaFQfbaFJH9RCuJ7SuxwEU3MP+o7r+zjO8m/kh6UerQI4aDnqB8b1EfTBbr5r5FpomI/y4f9TEWFlpj42MXgPCw1OrhdzX5TNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IwqL4sHB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IwqL4sHB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E812EC19425;
	Tue, 11 Nov 2025 01:44:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825459;
	bh=ESaPQlBzqpq9EqMx3AwvSvGVfcj22h5MONTrMSI2pVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IwqL4sHBrT2uiWMtT9rPJXFcBvgEU4yqcT7DehRKr76KWlNnLkL7CUo0paov7+QCq
	 +DsCE+bYdBqImIDZ+Q421J+GyuTFbXWu7yWzJkfvxiiUvPS0jAUGnBQsTbFXNLeTWe
	 mslu56+mFz/gxKvQl3Z5+CJk8N3PmhvEOLFmFkIE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.17 812/849] parisc: Avoid crash due to unaligned access in unwinder
Date: Tue, 11 Nov 2025 09:46:22 +0900
Message-ID: <20251111004556.056671265@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Helge Deller <deller@gmx.de>

commit fd9f30d1038ee1624baa17a6ff11effe5f7617cb upstream.

Guenter Roeck reported this kernel crash on his emulated B160L machine:

Starting network: udhcpc: started, v1.36.1
 Backtrace:
  [<104320d4>] unwind_once+0x1c/0x5c
  [<10434a00>] walk_stackframe.isra.0+0x74/0xb8
  [<10434a6c>] arch_stack_walk+0x28/0x38
  [<104e5efc>] stack_trace_save+0x48/0x5c
  [<105d1bdc>] set_track_prepare+0x44/0x6c
  [<105d9c80>] ___slab_alloc+0xfc4/0x1024
  [<105d9d38>] __slab_alloc.isra.0+0x58/0x90
  [<105dc80c>] kmem_cache_alloc_noprof+0x2ac/0x4a0
  [<105b8e54>] __anon_vma_prepare+0x60/0x280
  [<105a823c>] __vmf_anon_prepare+0x68/0x94
  [<105a8b34>] do_wp_page+0x8cc/0xf10
  [<105aad88>] handle_mm_fault+0x6c0/0xf08
  [<10425568>] do_page_fault+0x110/0x440
  [<10427938>] handle_interruption+0x184/0x748
  [<11178398>] schedule+0x4c/0x190
  BUG: spinlock recursion on CPU#0, ifconfig/2420
  lock: terminate_lock.2+0x0/0x1c, .magic: dead4ead, .owner: ifconfig/2420, .owner_cpu: 0

While creating the stack trace, the unwinder uses the stack pointer to guess
the previous frame to read the previous stack pointer from memory.  The crash
happens, because the unwinder tries to read from unaligned memory and as such
triggers the unalignment trap handler which then leads to the spinlock
recursion and finally to a deadlock.

Fix it by checking the alignment before accessing the memory.

Reported-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Helge Deller <deller@gmx.de>
Tested-by: Guenter Roeck <linux@roeck-us.net>
Cc: stable@vger.kernel.org # v6.12+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/kernel/unwind.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/arch/parisc/kernel/unwind.c
+++ b/arch/parisc/kernel/unwind.c
@@ -35,6 +35,8 @@
 
 #define KERNEL_START (KERNEL_BINARY_TEXT_START)
 
+#define ALIGNMENT_OK(ptr, type) (((ptr) & (sizeof(type) - 1)) == 0)
+
 extern struct unwind_table_entry __start___unwind[];
 extern struct unwind_table_entry __stop___unwind[];
 
@@ -257,12 +259,15 @@ static int unwind_special(struct unwind_
 	if (pc_is_kernel_fn(pc, _switch_to) ||
 	    pc == (unsigned long)&_switch_to_ret) {
 		info->prev_sp = info->sp - CALLEE_SAVE_FRAME_SIZE;
-		info->prev_ip = *(unsigned long *)(info->prev_sp - RP_OFFSET);
+		if (ALIGNMENT_OK(info->prev_sp, long))
+			info->prev_ip = *(unsigned long *)(info->prev_sp - RP_OFFSET);
+		else
+			info->prev_ip = info->prev_sp = 0;
 		return 1;
 	}
 
 #ifdef CONFIG_IRQSTACKS
-	if (pc == (unsigned long)&_call_on_stack) {
+	if (pc == (unsigned long)&_call_on_stack && ALIGNMENT_OK(info->sp, long)) {
 		info->prev_sp = *(unsigned long *)(info->sp - FRAME_SIZE - REG_SZ);
 		info->prev_ip = *(unsigned long *)(info->sp - FRAME_SIZE - RP_OFFSET);
 		return 1;
@@ -370,8 +375,10 @@ static void unwind_frame_regs(struct unw
 			info->prev_sp = info->sp - frame_size;
 			if (e->Millicode)
 				info->rp = info->r31;
-			else if (rpoffset)
+			else if (rpoffset && ALIGNMENT_OK(info->prev_sp, long))
 				info->rp = *(unsigned long *)(info->prev_sp - rpoffset);
+			else
+				info->rp = 0;
 			info->prev_ip = info->rp;
 			info->rp = 0;
 		}


