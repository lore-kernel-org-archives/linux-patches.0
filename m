Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FBD81ABEC5;
	Wed, 20 Nov 2024 13:01:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107699; cv=none; b=XfXOyyGvQTkWeQKKdt8Y4YZfxX7TiI1gUEfT7UHoW0HZqq3KOmQOXygeL3Rv8NJZ20iydV1UkI0NvNOAKLGgBxxrf1CRnn2u7FPCWacMQPl7lnBWPMWSaS0xcxjRr8UIGVSubjUH4RX2N5t6HMxQBk/MSbJBuukP3KBRpSBEh7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107699; c=relaxed/simple;
	bh=R3o9fOrYHBvUA7cIvYoqix7Kv6hg+heO7zAXpN+ZLYk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fZnSe1uaaFB/h88Yp2/7R8FnMtzucnQG/Jvx4vBjQyfi/CeBdIQKVC+EmVqwzPUYdCS8UE2MYslIBcrPAEuAjjekRweC73udC04Ya0pZeg+f0pqWuFd1bMTfbkHnd4t7quNYl9Vu+OpSDVSXU/OUQRx8QxK6NtB6gdj3agVO0hk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lvk1J8jA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lvk1J8jA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71747C4CECD;
	Wed, 20 Nov 2024 13:01:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107699;
	bh=R3o9fOrYHBvUA7cIvYoqix7Kv6hg+heO7zAXpN+ZLYk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lvk1J8jAgK+lHqYa5roTnIynsDjJksNOmmKTDiZ0h/wxXTAv2NpInHbZZmmGNAdro
	 5bv4XxGAl1yha7aJFmITtVOxD68CmpYwgU45HwXgkKlz+1OYAgDfsxx/m8IJV0ujiQ
	 hCDpL2gZ+zL2AChbGgIuQfT4dZZkyFYFoI3f9/Ts=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxim Levitsky <mlevitsk@redhat.com>,
	Yong He <zhuangel570@gmail.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.1 23/73] KVM: x86: Unconditionally set irr_pending when updating APICv state
Date: Wed, 20 Nov 2024 13:58:09 +0100
Message-ID: <20241120125810.173328539@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125809.623237564@linuxfoundation.org>
References: <20241120125809.623237564@linuxfoundation.org>
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

From: Sean Christopherson <seanjc@google.com>

commit d3ddef46f22e8c3124e0df1f325bc6a18dadff39 upstream.

Always set irr_pending (to true) when updating APICv status to fix a bug
where KVM fails to set irr_pending when userspace sets APIC state and
APICv is disabled, which ultimate results in KVM failing to inject the
pending interrupt(s) that userspace stuffed into the vIRR, until another
interrupt happens to be emulated by KVM.

Only the APICv-disabled case is flawed, as KVM forces apic->irr_pending to
be true if APICv is enabled, because not all vIRR updates will be visible
to KVM.

Hit the bug with a big hammer, even though strictly speaking KVM can scan
the vIRR and set/clear irr_pending as appropriate for this specific case.
The bug was introduced by commit 755c2bf87860 ("KVM: x86: lapic: don't
touch irr_pending in kvm_apic_update_apicv when inhibiting it"), which as
the shortlog suggests, deleted code that updated irr_pending.

Before that commit, kvm_apic_update_apicv() did indeed scan the vIRR, with
with the crucial difference that kvm_apic_update_apicv() did the scan even
when APICv was being *disabled*, e.g. due to an AVIC inhibition.

        struct kvm_lapic *apic = vcpu->arch.apic;

        if (vcpu->arch.apicv_active) {
                /* irr_pending is always true when apicv is activated. */
                apic->irr_pending = true;
                apic->isr_count = 1;
        } else {
                apic->irr_pending = (apic_search_irr(apic) != -1);
                apic->isr_count = count_vectors(apic->regs + APIC_ISR);
        }

And _that_ bug (clearing irr_pending) was introduced by commit b26a695a1d78
("kvm: lapic: Introduce APICv update helper function"), prior to which KVM
unconditionally set irr_pending to true in kvm_apic_set_state(), i.e.
assumed that the new virtual APIC state could have a pending IRQ.

Furthermore, in addition to introducing this issue, commit 755c2bf87860
also papered over the underlying bug: KVM doesn't ensure CPUs and devices
see APICv as disabled prior to searching the IRR.  Waiting until KVM
emulates an EOI to update irr_pending "works", but only because KVM won't
emulate EOI until after refresh_apicv_exec_ctrl(), and there are plenty of
memory barriers in between.  I.e. leaving irr_pending set is basically
hacking around bad ordering.

So, effectively revert to the pre-b26a695a1d78 behavior for state restore,
even though it's sub-optimal if no IRQs are pending, in order to provide a
minimal fix, but leave behind a FIXME to document the ugliness.  With luck,
the ordering issue will be fixed and the mess will be cleaned up in the
not-too-distant future.

Fixes: 755c2bf87860 ("KVM: x86: lapic: don't touch irr_pending in kvm_apic_update_apicv when inhibiting it")
Cc: stable@vger.kernel.org
Cc: Maxim Levitsky <mlevitsk@redhat.com>
Reported-by: Yong He <zhuangel570@gmail.com>
Closes: https://lkml.kernel.org/r/20241023124527.1092810-1-alexyonghe%40tencent.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-ID: <20241106015135.2462147-1-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/lapic.c |   29 ++++++++++++++++++-----------
 1 file changed, 18 insertions(+), 11 deletions(-)

--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2453,19 +2453,26 @@ void kvm_apic_update_apicv(struct kvm_vc
 {
 	struct kvm_lapic *apic = vcpu->arch.apic;
 
-	if (apic->apicv_active) {
-		/* irr_pending is always true when apicv is activated. */
-		apic->irr_pending = true;
+	/*
+	 * When APICv is enabled, KVM must always search the IRR for a pending
+	 * IRQ, as other vCPUs and devices can set IRR bits even if the vCPU
+	 * isn't running.  If APICv is disabled, KVM _should_ search the IRR
+	 * for a pending IRQ.  But KVM currently doesn't ensure *all* hardware,
+	 * e.g. CPUs and IOMMUs, has seen the change in state, i.e. searching
+	 * the IRR at this time could race with IRQ delivery from hardware that
+	 * still sees APICv as being enabled.
+	 *
+	 * FIXME: Ensure other vCPUs and devices observe the change in APICv
+	 *        state prior to updating KVM's metadata caches, so that KVM
+	 *        can safely search the IRR and set irr_pending accordingly.
+	 */
+	apic->irr_pending = true;
+
+	if (apic->apicv_active)
 		apic->isr_count = 1;
-	} else {
-		/*
-		 * Don't clear irr_pending, searching the IRR can race with
-		 * updates from the CPU as APICv is still active from hardware's
-		 * perspective.  The flag will be cleared as appropriate when
-		 * KVM injects the interrupt.
-		 */
+	else
 		apic->isr_count = count_vectors(apic->regs + APIC_ISR);
-	}
+
 	apic->highest_isr_cache = -1;
 }
 EXPORT_SYMBOL_GPL(kvm_apic_update_apicv);


