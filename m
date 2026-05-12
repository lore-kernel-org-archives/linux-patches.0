Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E6163EDE42;
	Tue, 12 May 2026 17:52:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608376; cv=none; b=kHqOKDoYcKCgaODh7p3RAzrKVA8aX0MpoBIxv2oQNmnU5VoAi6fcJ7EN92ZhD1b6MjPlyXGeeNCYtDUxGDugkAKepUOnV7M0qDIg6TDOyMHIlZJH+7XO9AogevQMZEn7axlwhvYyhe4azw6MnTg1Vmsqr1HlRi811Zwn8zKVcHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608376; c=relaxed/simple;
	bh=8787JHNdt3uV/zLR0ROUwIuZ9cXoyMMPLjVcZOq8iX8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XBzDXuCbIHpCi8jnf85HXr2Oh5mwXqnMXSg2sk1BtYBA7jyKQQWpda86aPQL5U/KIz3Xr7IFeJY1wuBQ8KUNMgBbfyf0qf8C3icdGB2kpBSIVoSvs5WxDLvjzoHriYDjzEpQJH/bDQuj2qu/v8g3loMES9Juo68fxbj3NFFrphI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SI+EAnCN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SI+EAnCN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C79D3C2BCB0;
	Tue, 12 May 2026 17:52:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608376;
	bh=8787JHNdt3uV/zLR0ROUwIuZ9cXoyMMPLjVcZOq8iX8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SI+EAnCNuwr3/0b57O+0F9YYX7weftCL8yXMNhxnEBDBptuHWxEuJfZTolTuEk1In
	 rhEdp+OVO3xAJnIMckBaVxPAUAc0kt8s85++/NtLLpozYOhfT8e2JoA2sjPEUNLMZ+
	 eDrOxyOewkWgLKR2CEFjojTanlIL/ifFgs5M74QY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@kernel.org>,
	Ivan Hu <ivan.hu@canonical.com>,
	x86@kernel.org,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 6.18 055/270] x86/efi: Restore IRQ state in EFI page fault handler
Date: Tue, 12 May 2026 19:37:36 +0200
Message-ID: <20260512173939.609241947@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173938.452574370@linuxfoundation.org>
References: <20260512173938.452574370@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ard Biesheuvel <ardb@kernel.org>

commit 2c340aab5485ebe9e33c01437dd4815ef33c8df5 upstream.

The kernel's softirq API does not permit re-enabling softirqs while IRQs
are disabled. The reason for this is that local_bh_enable() will not
only re-enable delivery of softirqs over the back of IRQs, it will also
handle any pending softirqs immediately, regardless of whether IRQs are
enabled at that point.

For this reason, commit

  d02198550423 ("x86/fpu: Improve crypto performance by making kernel-mode FPU reliably usable in softirqs")

disables softirqs only when IRQs are enabled, as it is not permitted
otherwise, but also unnecessary, given that asynchronous softirq
delivery never happens to begin with while IRQs are disabled.

However, this does mean that entering a kernel mode FPU section with
IRQs enabled and leaving it with IRQs disabled leads to problems, as
identified by Sashiko [0]: the EFI page fault handler is called from
page_fault_oops() with IRQs disabled, and thus ends the kernel mode FPU
section with IRQs disabled as well, regardless of whether IRQs were
enabled when it was started. This may result in schedule() being called
with a non-zero preempt_count, causing a BUG().

So take care to re-enable IRQs when handling any EFI page faults if they
were taken with IRQs enabled.

[0] https://sashiko.dev/#/patchset/20260430074107.27051-1-ivan.hu%40canonical.com

Cc: Eric Biggers <ebiggers@kernel.org>
Cc: Ivan Hu <ivan.hu@canonical.com>
Cc: x86@kernel.org
Cc: <stable@vger.kernel.org>
Fixes: d02198550423 ("x86/fpu: Improve crypto performance by making kernel-mode FPU reliably usable in softirqs")
Reviewed-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/efi.h     |    3 ++-
 arch/x86/mm/fault.c            |    2 +-
 arch/x86/platform/efi/quirks.c |   11 ++++++++++-
 3 files changed, 13 insertions(+), 3 deletions(-)

--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -137,7 +137,8 @@ extern void __init efi_dump_pagetable(vo
 extern void __init efi_apply_memmap_quirks(void);
 extern int __init efi_reuse_config(u64 tables, int nr_tables);
 extern void efi_delete_dummy_variable(void);
-extern void efi_crash_gracefully_on_page_fault(unsigned long phys_addr);
+extern void efi_crash_gracefully_on_page_fault(unsigned long phys_addr,
+					       const struct pt_regs *regs);
 extern void efi_unmap_boot_services(void);
 
 void arch_efi_call_virt_setup(void);
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -686,7 +686,7 @@ page_fault_oops(struct pt_regs *regs, un
 	 * avoid hanging the system.
 	 */
 	if (IS_ENABLED(CONFIG_EFI))
-		efi_crash_gracefully_on_page_fault(address);
+		efi_crash_gracefully_on_page_fault(address, regs);
 
 	/* Only not-present faults should be handled by KFENCE. */
 	if (!(error_code & X86_PF_PROT) &&
--- a/arch/x86/platform/efi/quirks.c
+++ b/arch/x86/platform/efi/quirks.c
@@ -761,7 +761,8 @@ int efi_capsule_setup_info(struct capsul
  * @return: Returns, if the page fault is not handled. This function
  * will never return if the page fault is handled successfully.
  */
-void efi_crash_gracefully_on_page_fault(unsigned long phys_addr)
+void efi_crash_gracefully_on_page_fault(unsigned long phys_addr,
+					const struct pt_regs *regs)
 {
 	if (!IS_ENABLED(CONFIG_X86_64))
 		return;
@@ -811,6 +812,14 @@ void efi_crash_gracefully_on_page_fault(
 	}
 
 	/*
+	 * The API does not permit entering a kernel mode FPU section with
+	 * interrupts enabled and leaving it with interrupts disabled.  So
+	 * re-enable interrupts now if they were enabled when the page fault
+	 * occurred.
+	 */
+	local_irq_restore(regs->flags);
+
+	/*
 	 * Before calling EFI Runtime Service, the kernel has switched the
 	 * calling process to efi_mm. Hence, switch back to task_mm.
 	 */


