Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CC0A2C1595;
	Sun,  7 Jun 2026 10:30:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780828238; cv=none; b=j5iomwgKsnj9qLsg9VaPBJPGD8pFheM4oTjWJYcu7obMPw0419xZnpvbvplIhy1TWpu8AMWEiTm8ebCE9LpHsQUakCxVTG5an8YcWBWbHNc8C5bEuTg/o7/kxf4jNEoP3wBBvbq2L0xEwdORPxN7c0aJBFdxB5wsldi1QRGHeYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780828238; c=relaxed/simple;
	bh=Yy504fP45eY6Tf8i1VJgGnvSVa5zVwftDqewC3tGQkQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sr+SZ/x0ngjsyWNdhm+Zh9TVDaT3tMfwmPEU9E0Pxd2mb4LqrsLnp6iDxEgOvDO7vNH7C4pc9E2fO4dFPyhuMsO7ac4pSJmAvA3qkNR46RuMwi1d8ZQXy0cvaI07h+gsdBKuaEoqdGY7B2jGwn+K/eYqXc4nJ7o4qU7dVwXE2W4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1ylmXdp3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1ylmXdp3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3AA71F00893;
	Sun,  7 Jun 2026 10:30:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780828237;
	bh=tkuvpKAuDpXFnn3356wV0QMhIJ85ppDnKJU9PMj/+jI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1ylmXdp3xOzA/UgSsMW9J5XPQMFG5XuDazwDXNMZbPYzFofCpNVNliDlkGWbg0kUu
	 t7KA50/xURShp75ylCDrl/p1pkhtRNgWnixjQ04zR/aYrAHcNjNpR27cH2kehgPeY0
	 FfI/DgCCpgNyCdOi3KzM88u2cLSn27+owzqfH7lQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Naveen N Rao (AMD)" <naveen@kernel.org>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.18 143/315] KVM: SVM: Flush the current TLB when transitioning from xAVIC => x2AVIC
Date: Sun,  7 Jun 2026 11:58:50 +0200
Message-ID: <20260607095732.852803886@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
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

From: Sean Christopherson <seanjc@google.com>

commit a9e18aa3263f356edae305e29830e5fe63d8597a upstream.

Flush the current TLB when xAVIC *or* x2AVIC is activated, as KVM is
(apparently) responsible for purging TLB entries when transitioning from
xAVIC to x2AVIC.  The APM says a whole lot of nothing about TLB flushing
with respect to (x2)AVIC, but empirical data strongly suggests hardware
also does a whole lot of nothing.

Failure to flush the TLB when enabling x2AVIC can lead to guest accesses
to the APIC base address getting incorrectly redirected to the virtual
APIC page.  The flaw most visibly manifests as failures in KVM-Unit-Test's
verify_disabled_apic_mmio() testcase when x2APIC is enabled (though for
reasons unknown, the test only reliably fails with EFI builds).

Fixes: 0ccf3e7cb95a ("KVM: SVM: Flush the "current" TLB when activating AVIC")
Fixes: 4d1d7942e36a ("KVM: SVM: Introduce logic to (de)activate x2AVIC mode")
Cc: stable@vger.kernel.org
Cc: Naveen N Rao (AMD) <naveen@kernel.org>
Link: https://patch.msgid.link/20260515171536.1841645-1-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/avic.c |   35 +++++++++++++++++++++++++++++------
 1 file changed, 29 insertions(+), 6 deletions(-)

--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -187,6 +187,35 @@ static void avic_activate_vmcb(struct vc
 	svm_clr_intercept(svm, INTERCEPT_CR8_WRITE);
 
 	/*
+	 * Flush the TLB when enabling (x2)AVIC and when transitioning between
+	 * xAVIC and x2AVIC, as the CPU may have inserted a TLB entry for the
+	 * "wrong" mapping.
+	 *
+	 * KVM uses a per-VM "scratch" page to back the APIC memslot, because
+	 * KVM also uses per-VM page tables *and* maintains the page table (NPT
+	 * or shadow page) mappings for said memslot even if one or more vCPUs
+	 * have their local APIC hardware-disabled or are in x2APIC mode, i.e.
+	 * even if one or more vCPUs' APIC MMIO BAR is effectively disabled.
+	 *
+	 * If xAVIC is fully enabled, hardware ignores the physical address in
+	 * KVM's page tables, i.e. in the leaf SPTE for the APIC memslot, and
+	 * instead redirects the access to the AVIC backing page, i.e. to the
+	 * vCPU's virtual APIC page.  If xAVIC is not enabled (APIC is either
+	 * hardware-disabled or in x2APIC mode), then guest accesses will use
+	 * the page table mapping verbatim, i.e. will access the per-VM scratch
+	 * page, as normal memory.
+	 *
+	 * In both cases, the CPU is allowed to cache TLB entries for the APIC
+	 * base GPA.  So, KVM needs to flush the TLB when enabling xAVIC, as
+	 * accesses need to be redirected to the virtual APIC page, but the TLB
+	 * may contain entries pointing at the scratch page.  KVM also needs to
+	 * flush the TLB when enabling x2AVIC, as accesses need to go to the
+	 * scratch page, but the TLB may contain entries tagged as xAVIC, i.e.
+	 * entries pointing to the vCPU's virtual APIC page.
+	 */
+	kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, &svm->vcpu);
+
+	/*
 	 * Note: KVM supports hybrid-AVIC mode, where KVM emulates x2APIC MSR
 	 * accesses, while interrupt injection to a running vCPU can be
 	 * achieved using AVIC doorbell.  KVM disables the APIC access page
@@ -199,12 +228,6 @@ static void avic_activate_vmcb(struct vc
 		/* Disabling MSR intercept for x2APIC registers */
 		avic_set_x2apic_msr_interception(svm, false);
 	} else {
-		/*
-		 * Flush the TLB, the guest may have inserted a non-APIC
-		 * mapping into the TLB while AVIC was disabled.
-		 */
-		kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, &svm->vcpu);
-
 		/* Enabling MSR intercept for x2APIC registers */
 		avic_set_x2apic_msr_interception(svm, true);
 	}


