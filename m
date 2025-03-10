Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4818922B8BD;
	Mon, 10 Mar 2025 17:29:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627743; cv=none; b=CY4A4DgCr0IITHUXG1+aokP1Y9mqC5nlqfzNpjjhZ262rKSE1Txu57BaPEuoV5M7vJuW1nisSNCBkm4sHuHc9UJqmhzoGgeyWYtSbIMKPw0EUmS1pJvX306k3Ut89NTPL8JSUEy22WdO1Ny7O2S+58ButTFTdNuxxZ25u02qLPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627743; c=relaxed/simple;
	bh=ei0cjpbRc+d3hvFdnr9k+9p0mmG7gnFAI2pLLYOecGc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BDlv9hgT9GwTGvkd1adGqE4OCLI+edyAAx6J+ibZmnKeEdd9rA0DAmC4cx5lCv/wk6lxteY158zk/tFiOlAtlWSkIwxJWfIdrGYbNVL30qqhskQ1NwtVZAAYp7Nd0IHWUqLGvHQBp/uUA8prQsMdkM7lkR7sTug7VprgytnJ128=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UY/gwsoM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UY/gwsoM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3694C4CEE5;
	Mon, 10 Mar 2025 17:29:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627743;
	bh=ei0cjpbRc+d3hvFdnr9k+9p0mmG7gnFAI2pLLYOecGc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UY/gwsoM8F+bzHriqbk/e3M8d/VQBH3/EtzQW1D8+6IZ5FluJC2EhHMQpXFwZLSgG
	 r0lpGsSWRyckd7dtTLvykerblr6yhOIWWMhfDK05lWp3D7Kvr8ftKIygyloM6KPzPf
	 my5prFK0EwtzThaIqolyTKkkUxTD/N3ul3p02lu8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	rangemachine@gmail.com,
	whanos@sergal.fun,
	Ravi Bangoria <ravi.bangoria@amd.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.12 234/269] KVM: SVM: Manually context switch DEBUGCTL if LBR virtualization is disabled
Date: Mon, 10 Mar 2025 18:06:27 +0100
Message-ID: <20250310170507.011348557@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
References: <20250310170457.700086763@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

commit 433265870ab3455b418885bff48fa5fd02f7e448 upstream.

Manually load the guest's DEBUGCTL prior to VMRUN (and restore the host's
value on #VMEXIT) if it diverges from the host's value and LBR
virtualization is disabled, as hardware only context switches DEBUGCTL if
LBR virtualization is fully enabled.  Running the guest with the host's
value has likely been mildly problematic for quite some time, e.g. it will
result in undesirable behavior if BTF diverges (with the caveat that KVM
now suppresses guest BTF due to lack of support).

But the bug became fatal with the introduction of Bus Lock Trap ("Detect"
in kernel paralance) support for AMD (commit 408eb7417a92
("x86/bus_lock: Add support for AMD")), as a bus lock in the guest will
trigger an unexpected #DB.

Note, suppressing the bus lock #DB, i.e. simply resuming the guest without
injecting a #DB, is not an option.  It wouldn't address the general issue
with DEBUGCTL, e.g. for things like BTF, and there are other guest-visible
side effects if BusLockTrap is left enabled.

If BusLockTrap is disabled, then DR6.BLD is reserved-to-1; any attempts to
clear it by software are ignored.  But if BusLockTrap is enabled, software
can clear DR6.BLD:

  Software enables bus lock trap by setting DebugCtl MSR[BLCKDB] (bit 2)
  to 1.  When bus lock trap is enabled, ... The processor indicates that
  this #DB was caused by a bus lock by clearing DR6[BLD] (bit 11).  DR6[11]
  previously had been defined to be always 1.

and clearing DR6.BLD is "sticky" in that it's not set (i.e. lowered) by
other #DBs:

  All other #DB exceptions leave DR6[BLD] unmodified

E.g. leaving BusLockTrap enable can confuse a legacy guest that writes '0'
to reset DR6.

Reported-by: rangemachine@gmail.com
Reported-by: whanos@sergal.fun
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=219787
Closes: https://lore.kernel.org/all/bug-219787-28872@https.bugzilla.kernel.org%2F
Cc: Ravi Bangoria <ravi.bangoria@amd.com>
Cc: stable@vger.kernel.org
Reviewed-and-tested-by: Ravi Bangoria <ravi.bangoria@amd.com>
Link: https://lore.kernel.org/r/20250227222411.3490595-5-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/svm.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4275,6 +4275,16 @@ static __no_kcsan fastpath_t svm_vcpu_ru
 	clgi();
 	kvm_load_guest_xsave_state(vcpu);
 
+	/*
+	 * Hardware only context switches DEBUGCTL if LBR virtualization is
+	 * enabled.  Manually load DEBUGCTL if necessary (and restore it after
+	 * VM-Exit), as running with the host's DEBUGCTL can negatively affect
+	 * guest state and can even be fatal, e.g. due to Bus Lock Detect.
+	 */
+	if (!(svm->vmcb->control.virt_ext & LBR_CTL_ENABLE_MASK) &&
+	    vcpu->arch.host_debugctl != svm->vmcb->save.dbgctl)
+		update_debugctlmsr(svm->vmcb->save.dbgctl);
+
 	kvm_wait_lapic_expire(vcpu);
 
 	/*
@@ -4302,6 +4312,10 @@ static __no_kcsan fastpath_t svm_vcpu_ru
 	if (unlikely(svm->vmcb->control.exit_code == SVM_EXIT_NMI))
 		kvm_before_interrupt(vcpu, KVM_HANDLING_NMI);
 
+	if (!(svm->vmcb->control.virt_ext & LBR_CTL_ENABLE_MASK) &&
+	    vcpu->arch.host_debugctl != svm->vmcb->save.dbgctl)
+		update_debugctlmsr(vcpu->arch.host_debugctl);
+
 	kvm_load_host_xsave_state(vcpu);
 	stgi();
 


