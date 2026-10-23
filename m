Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774641;
	b=J4jPaJ1ouKRL1rXiMXM0ckdsmNzMpJYS3ku45BC0bmdWJL33B7FhNi+atdoKRYLc8AVL
	 /iKDTtvKucwZDuxsd/kMkEbteLED0nS0bvrWVAEPMOeypZgY6YABAEEgF7sody2pTV621
	 FSKFg5Hultlh150yV60ilSdlYvodw5wlhBu07koBnUIfPT+0yjJQegsoT54GNpmgyFMHy
	 9i4ClT8eGBXbT3AYFoeVOLeOZmQ5sJYrczXNY9vxUBSLI1DF3y1u3s05qlZulwgRqbjUQ
	 cE6HtPPdcp2AqOiKpC+MpvFI+F+Spqt9E50wjTiL7glabxm21A359hlkMHrfD7gNELg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774641;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=s2yidH85zYnFfM5AGlchwzCBID8zdVQmRvjRw8WXwfk=;
	b=1YmSVQGlBP0NAv2Pd0SdoejmKC2502MpBaNYU0kzFhu8dKAxlJFwVZfYu5WVWR6eoj9f
	 mRtmafLPQcFYGUhqJldLNR9qPn+Q8MAIGanIAFIE1mfUaJeZJ13bRsbq4WCX616Q9v9F1
	 w6ImpEAb2iZhn3iqd8x83XYtyj/W3sXiKr3zY6QUFjX3xqEWfvc5NqDZrd07OmcVRwJbi
	 dNheswLnLGIT/2SQ7igi76CgcpAV63DDFdHF+QXSUynUQ8uRh/5bWqvIJvaXJyimXWmEQ
	 KNUkQVNUrlC2YtYAG/1HBSvmUHodjC7jQoXoM7Hq4tSmyNfy62qVgDni4L66WtBdcaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Au9ZT9PU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DA69606A31A;
	Fri, 23 Oct 2026 16:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Au9ZT9PU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADB0B1F01825;
	Fri, 23 Oct 2026 16:57:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774641;
	bh=s2yidH85zYnFfM5AGlchwzCBID8zdVQmRvjRw8WXwfk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Au9ZT9PUUhdkG2mGWaz328b8KCauERvGBzCnA5f57tlw/wbttt9UJe+NVWaqeE9sj
	 Cd2S7aksriZ14fCiQLnQiTICV0RFQyM0WS4JciZHCcc494TIrCjSrqJbo2K0EVNYPO
	 XsmjjoCgP//he4gRf5r3Du3+XSnIUWlWG+udWd/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	EJ Campbell <ejc3@meta.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 7.2 109/242] x86/kvm: Dont consume async #PF flags on a kernel #PF in NMI context
Date: Fri, 23 Oct 2026 18:39:11 +0200
Message-ID: <20261023163716.358557811@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -265,11 +265,39 @@ noinstr u32 kvm_read_and_reset_apf_flags
 }
 EXPORT_SYMBOL_FOR_KVM(kvm_read_and_reset_apf_flags);
 
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
 
@@ -285,8 +313,6 @@ noinstr bool __kvm_handle_async_pf(struc
 		panic("Host injected async #PF in interrupt disabled region\n");
 
 	if (flags & KVM_PV_REASON_PAGE_NOT_PRESENT) {
-		if (unlikely(!(user_mode(regs))))
-			panic("Host injected async #PF in kernel mode\n");
 		/* Page is swapped out by the host. */
 		kvm_async_pf_task_wait_schedule(token);
 	} else {


