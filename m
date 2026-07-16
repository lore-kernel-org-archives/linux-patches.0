Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF89427732;
	Thu, 16 Jul 2026 14:19:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211541; cv=none; b=kcpHqURT6ohCYnA0XxlrC+o2Ftt9c7j62nFSEiMKUFtEh3uv50OL9luoVIQh7z8W0H7TSpNmV3BFgjYPuZBNyrKml7en9YLjOCDpyu6O2594qZw+UKt44/jEtkjSlogA8OSdqY3a/DzrE6/2s0WXHTxtOLFjAm9oR4uCf5ZoKNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211541; c=relaxed/simple;
	bh=HVuvuDctLBUUpPlDgMl4nQ8f0aKv4E7DJzF8D/GZqoU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UnPbCmU+FtOBmHPN/LEjtEPVWQEPZuwZYG+2vXMLwfORj97sbCUjDRtFhvjz77HbJeHPmYwNngDWIDtuVeBakuMltS8WhjkRF75v3xyIumEjWXtSEK0UomBvNobqKZTLRgpGeECipLml0L3MaemIq3PgaECEjVhiadNOEMkANYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GyI7KJsz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GyI7KJsz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 205E11F000E9;
	Thu, 16 Jul 2026 14:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211540;
	bh=2mV1LZ8KgnPqWN/aTzswnAtOSLZioi1rt5znn4pt9CU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GyI7KJsz2b+UGEGycf/GLjdeGIGZigge3VQ+t/GpDcTNQe8fzzQZQQ2jWB7q2sc2l
	 eXbIjM9xH5Ubf1aWCYYf8n+mc3GDUXY3fvrLt72OQHy2Tx/+VlDlUE6sxIkB6/prRM
	 sgQ/8cTcDLVoee4mu2R6FnCWntA4mil3Y8ac5SAA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Naveen N Rao (AMD)" <naveen@kernel.org>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.18 423/480] KVM: SVM: Disable x2AVIC RDMSR interception for MSRs KVM actually supports
Date: Thu, 16 Jul 2026 15:32:50 +0200
Message-ID: <20260716133053.964764466@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

commit 7f4b7092d9a173a4271e28c0ed1fc235994e309b upstream.

When toggling x2AVIC on/off, use KVM's curated mask of x2APIC MSRs that
can/should be passed through to the guest (or not) when 2AVIC is enabled.
Using the effective list provided by the local APIC emulation fixes
multiple (classes of) bugs, as the existing hand-coded list of MSRs is
wrong on multiple fronts:

 - ARBPRI isn't supported by KVM, isn't accelerated by AVIC (for read or
   write), and its #VMEXIT is fault-like, i.e. requires decoding the
   instruction.  Disabling interception is nonsensical and suboptimal.

 - DFR and ICR2 aren't supported by x2APIC and so don't need their
   intercepts disabled for performance reasons.  While the #GP due to
   x2APIC being abled has higher priority than the trap-like #VMEXIT,
   disabling interception of unsupported MSRs is confusing and unnecessary.

 - RRR is completely unsupported.

 - AVIC currently fails to pass through the "range of vectors" registers,
   IRR, ISR, and TMR, as e.g. X2APIC_MSR(APIC_IRR) only affects IRR0, and
   thus only disables intercept for vectors 31:0 (which are the *least*
   interesting registers).

 - TMCCT (the current APIC timer count) isn't accelerated by hardware, and
   generates a fault-like AVIC_UNACCELERATED_ACCESS #VMEXIT, i.e. requires
   KVM to decode the instruction to figure out what the guest was trying to
   access.  Note, the only reason this isn't a fatal bug is that the AVIC
   architecture had the foresight to guard against buggy hypervisors.  E.g.
   if hardware simply read from the virtual APIC page, the guest would get
   garbage (because the timer is emulated in software).

Fixes: 4d1d7942e36a ("KVM: SVM: Introduce logic to (de)activate x2AVIC mode")
Cc: stable@vger.kernel.org
Reviewed-by: Naveen N Rao (AMD) <naveen@kernel.org>
Link: https://patch.msgid.link/20260514213115.1637082-3-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/avic.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -111,6 +111,9 @@ static bool x2avic_enabled;
 static void avic_set_x2apic_msr_interception(struct vcpu_svm *svm,
 					     bool intercept)
 {
+	struct kvm_vcpu *vcpu = &svm->vcpu;
+	u64 rd_regs;
+
 	static const u32 x2avic_passthrough_msrs[] = {
 		X2APIC_MSR(APIC_ID),
 		X2APIC_MSR(APIC_LVR),
@@ -151,9 +154,15 @@ static void avic_set_x2apic_msr_intercep
 	if (!x2avic_enabled)
 		return;
 
+	rd_regs = kvm_x2apic_disable_read_intercept_reg_mask(vcpu);
+
+	for_each_set_bit(i, (unsigned long *)&rd_regs, BITS_PER_TYPE(rd_regs))
+		svm_set_intercept_for_msr(vcpu, APIC_BASE_MSR + i,
+					  MSR_TYPE_R, intercept);
+
 	for (i = 0; i < ARRAY_SIZE(x2avic_passthrough_msrs); i++)
-		svm_set_intercept_for_msr(&svm->vcpu, x2avic_passthrough_msrs[i],
-					  MSR_TYPE_RW, intercept);
+		svm_set_intercept_for_msr(vcpu, x2avic_passthrough_msrs[i],
+					  MSR_TYPE_W, intercept);
 
 	svm->x2avic_msrs_intercepted = intercept;
 }


