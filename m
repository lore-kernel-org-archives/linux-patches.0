Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792773971;
	b=kQTLdBGxbXPqCuz92hUNuMDcCRmm9SxSsrnC3KS7R277TFOe3oCEx2FxmwWw4fLQq9gZ
	 +YXRhKUHTT+R3vbNuQAAt6CS6SlfuI6L2fa4LWnPsfY7wBxie3xgxx/916/ArmNtf9Rbq
	 l0GguYJm6Kl8ZJw0BdfLbQJBS1crgEUxvIjJzBwZsOxVo49EJNlLl/iFq3Kt6qEWyAHQ8
	 I5o2aD8z83OFULKtPGgKCH90N6oKCLEHy9sU198N8gNzQ/WTN1GJjGWZRqqXXv+c6JjVI
	 atbB7Bv1Ex1skHYYzScWBXxutYf+QruhQzpFtH3m5oCEKIjhg2xHdWHD4BDOhYvdj5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792773971;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BPml6ti1trjSxpqmZxBJ9+lqFcu2h6tES8rnHGzrHT8=;
	b=4rNnfhrDAxA4oEuLBjHHtG7vTqCTbCSFUtBAY4yw4ZTyDTPWTuGXkvcTO/9wtpVB9l2g
	 W7IIXWlXwY/tHqkkYdF6+gq3MU0TIlHicB58QV5zgMnWNsxGlJ3/KKEavTgzqN9i53VXw
	 QPa0XoaI4Tds6sMv6Su2JNFyJPmISAdB5Q5ONmipLZoGYp8eRct3ZHaTb5OJdIp58T4Yh
	 0VSCqcemYvi1PLzmwjrFjj8iIlDUiifEw1izE/Tzbk2dND5bRrXIhocWKTqjNu2wroxb6
	 0V9GlJZVea/xV73hnLYY4RiQLCd1NMrw8kWJzRHGZ7aG2WiwPx3Dv3VSb/vNI5eXaAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2MjSjEzm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C820D606A31B;
	Fri, 23 Oct 2026 16:46:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2MjSjEzm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 230851F01825;
	Fri, 23 Oct 2026 16:46:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792773970;
	bh=BPml6ti1trjSxpqmZxBJ9+lqFcu2h6tES8rnHGzrHT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2MjSjEzmWUseuK5gigT5sULhdkIgWgehQCvyu3l+yGRgGgIi+VeAg7U+ecJ9o75Za
	 PfYBBkCmdvXy5XAvcdTlwyXbRYvMz/A1moizI2fsOIrkR4MbdbKW4YI2VPxJkUa/Zg
	 m+P7qEEC0DRfGu6uPNQOdOxtkhif3mvaNXc3Wnpk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	EJ Campbell <ejc3@meta.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.18 077/193] x86/kvm: Dont consume async #PF flags on a kernel #PF in NMI context
Date: Fri, 23 Oct 2026 18:35:54 +0200
Message-ID: <20261023163716.024230370@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: EJ Campbell <ejc3@meta.com>

commit 81d99abe2bd81379abfb595e403bbbee6fbfc624 upstream.

An async #PF "page not present" event arrives through the #PF vector,
and its reason sits in the per-CPU apf_reason.flags until
__kvm_handle_async_pf() reads and clears it. If an NMI arrives after
the event is injected and before the #PF handler reads the flags, and
the NMI handler itself takes a #PF, that fault reads and clears the
flags belonging to the #PF it interrupted. It then finds interrupts
disabled in the NMI context it interrupted, and panics:

  Kernel panic - not syncing: Host injected async #PF in interrupt
disabled region
  Call Trace:
   <NMI>
   panic+0x52/0x60
   __kvm_handle_async_pf+0xb0/0xb0
   exc_page_fault+0x71/0xb0
   asm_exc_page_fault+0x27/0x30
  RIP: 0010:__get_user_nocheck_8+0x6/0x20
   perf_callchain_user+0x147/0x1a0
   get_perf_callchain+0x12d/0x1c0
   ...
   perf_event_nmi_handler+0x26/0x50
   exc_nmi+0xe8/0x110
  RIP: 0010:asm_exc_page_fault+0x0/0x30
   </NMI>

The last RIP line shows the NMI landing on the first instruction of
the #PF entry. perf with user call chains takes such a fault: the
sampling NMI walks the user stack with __get_user(), which faults when
a saved frame pointer is not a valid user address or the walk runs off
the top of the stack. The same window exists when KVM, running as an
L1 hypervisor with DELIVERY_AS_PF_VMEXIT, reads the flags itself after
a #PF VM-exit.

The NMI entry code saves and restores CR2 for this nesting, but not the
async #PF reason. Andy Lutomirski described the race, with perf as the
example, when async #PF delivery was reworked in 2020 [1]. Saving and
clearing the flags across the NMI, next to CR2, was discussed there but
not merged.

Since that rework, Linux has stopped setting KVM_ASYNC_PF_SEND_ALWAYS,
so the host delivers "page not present" only for user mode faults and
a kernel-mode fault in NMI context (including kernel-mode #MC and #DB)
cannot be an async page fault.  In that case, return without touching
the flags so that the interrupted handler finds them intact.

Tested on v7.3-rc5 in a 4-vCPU, 2 GiB guest restored from a snapshot
whose memory is served on demand through userfaultfd, so that reading
it back takes async #PFs, while every thread samples hardware cycles
with user call chains and points its frame pointer at an unmapped page.
Without this patch the guest panicked as above in 3 of 3 runs. With it,
the guest survived 3 of 3 runs of 60 seconds, and the host counted
148,441 to 153,334 kvm_async_pf_not_present events in the first 20
seconds of each. On 6.18.50 the results were the same: the guest
panicked without the patch and survived with it.

Link: https://lore.kernel.org/all/ed71d0967113a35f670a9625a058b8e6e0b2f104.1583547991.git.luto@kernel.org/ [1]
Link: https://lore.kernel.org/all/20211126123145.2772-1-jiangshanlai@gmail.com/ [2]
Cc: stable@vger.kernel.org # v5.9+
Signed-off-by: EJ Campbell <ejc3@meta.com>
Link: https://patch.msgid.link/CADkxfh-uQTca_6jB1JPDq1MsKffF_UKGQR339oQSJNcoV75GNQ@mail.gmail.com
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/kvm.c |   32 +++++++++++++++++++++++++++++---
 1 file changed, 29 insertions(+), 3 deletions(-)

--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -255,11 +255,39 @@ noinstr u32 kvm_read_and_reset_apf_flags
 }
 EXPORT_SYMBOL_GPL(kvm_read_and_reset_apf_flags);
 
+static __always_inline bool kvm_apf_reason_pending(void)
+{
+	return __this_cpu_read(async_pf_enabled) &&
+	       __this_cpu_read(apf_reason.flags);
+}
+
 noinstr bool __kvm_handle_async_pf(struct pt_regs *regs, u32 token)
 {
-	u32 flags = kvm_read_and_reset_apf_flags();
 	irqentry_state_t state;
+	u32 flags;
+
+	if (!kvm_apf_reason_pending())
+		return false;
+
+	/*
+	 * The guest does not enable KVM_ASYNC_PF_SEND_ALWAYS, so the host
+	 * delivers async #PF only to user mode (or as a #PF VM-exit, which KVM
+	 * reads itself). A #PF from kernel mode can still arrive between that
+	 * delivery and the read of the reason flags, inside an NMI that
+	 * interrupted it, for instance perf reading user memory for a call
+	 * chain. Such a fault is not async, so leave the async PF flags
+	 * untouched for the outer handler.  Outside NMI context, on the other
+	 * hand, async PF flags on a kernel-mode fault mean the host is broken.
+	 */
+	if (!user_mode(regs)) {
+		if (likely(in_nmi()))
+			return false;
+		state = irqentry_enter(regs);
+		instrumentation_begin();
+		panic("Host injected async #PF in kernel mode\n");
+	}
 
+	flags = kvm_read_and_reset_apf_flags();
 	if (!flags)
 		return false;
 
@@ -275,8 +303,6 @@ noinstr bool __kvm_handle_async_pf(struc
 		panic("Host injected async #PF in interrupt disabled region\n");
 
 	if (flags & KVM_PV_REASON_PAGE_NOT_PRESENT) {
-		if (unlikely(!(user_mode(regs))))
-			panic("Host injected async #PF in kernel mode\n");
 		/* Page is swapped out by the host. */
 		kvm_async_pf_task_wait_schedule(token);
 	} else {


