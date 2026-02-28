Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2C6F4ADD94;
	Sat, 28 Feb 2026 17:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301313; cv=none; b=uN82gOb7QsX3RTd4rEkNeAwWk0uNn/eiMatXL425n+RltiSaj7VXUPpwmD5NpITPmQDHjvNT9bF/UrLf8gFa7+TDs8PhzkmDyrfyb1oW61roEKyFTMdpkRKHdyT2rlvy5Qvd/QSsp7SurNQg2wm/BHpxG9041OLU51oYaQ6GXGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301313; c=relaxed/simple;
	bh=fUc86JP/jpj8gi2ohNBCco1OaO6ZwYQ4e897YP0r/9g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Td+nuXoaD2asMhifIhvWg/Rn2x4sISFIblqr18vV0/Rz2IXGS0nldnER0772TJINGfjK1T3mPTMopvs6Eoo0dEFQqzOrDPZTEoIROaqmQH/PLXPOuytj5yG/PMFervLjyoA1yHE6mRVcAfpaqN6VEzHPwC+acdbIKflzkmXL5Xo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CJuYJSu3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CJuYJSu3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F87EC19425;
	Sat, 28 Feb 2026 17:55:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301312;
	bh=fUc86JP/jpj8gi2ohNBCco1OaO6ZwYQ4e897YP0r/9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CJuYJSu3irxdDZwGKccZPsgXHpxEWa/yqWYefpP0LBJ0RaBVrOkR+pslXe71gKs0Q
	 s5mVvNPcZQva5ZByMqkJt8yyDX0USt6yCAmeEc1v28bJuNjSorkgXktYUelUzqbP83
	 IxhtQL3v+t2KTneDw1Nl9E/Bt95BCI5ixmDfUWnf+S7GXLZg91bu/CC67ObZHZGw9R
	 YD3encG6Vg+DlVsDzOd7SX49sIaVSBKhV1+YNNJv7mpJmZB0BUjA4cMGViKJi6A1Zm
	 74h7xIlo9sBjnJKGRhbWm5Cvfz7MLm0EvbGIBKxfH0NCIYOvWQbAHjvFCm+m2zSTE1
	 qRFljojTUajeA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Sean Christopherson <seanjc@google.com>,
	stable@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 498/752] KVM: nSVM: Remove a user-triggerable WARN on nested_svm_load_cr3() succeeding
Date: Sat, 28 Feb 2026 12:43:29 -0500
Message-ID: <20260228174750.1542406-498-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit fc3ba56385d03501eb582e4b86691ba378e556f9 ]

Drop the WARN in svm_set_nested_state() on nested_svm_load_cr3() failing
as it is trivially easy to trigger from userspace by modifying CPUID after
loading CR3.  E.g. modifying the state restoration selftest like so:

  --- tools/testing/selftests/kvm/x86/state_test.c
  +++ tools/testing/selftests/kvm/x86/state_test.c
  @@ -280,7 +280,16 @@ int main(int argc, char *argv[])

                 /* Restore state in a new VM.  */
                  vcpu = vm_recreate_with_one_vcpu(vm);
  -               vcpu_load_state(vcpu, state);
  +
  +               if (stage == 4) {
  +                       state->sregs.cr3 = BIT(44);
  +                       vcpu_load_state(vcpu, state);
  +
  +                       vcpu_set_cpuid_property(vcpu, X86_PROPERTY_MAX_PHY_ADDR, 36);
  +                       __vcpu_nested_state_set(vcpu, &state->nested);
  +               } else {
  +                       vcpu_load_state(vcpu, state);
  +               }

                  /*
                   * Restore XSAVE state in a dummy vCPU, first without doing

generates:

  WARNING: CPU: 30 PID: 938 at arch/x86/kvm/svm/nested.c:1877 svm_set_nested_state+0x34a/0x360 [kvm_amd]
  Modules linked in: kvm_amd kvm irqbypass [last unloaded: kvm]
  CPU: 30 UID: 1000 PID: 938 Comm: state_test Tainted: G        W           6.18.0-rc7-58e10b63777d-next-vm
  Tainted: [W]=WARN
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
  RIP: 0010:svm_set_nested_state+0x34a/0x360 [kvm_amd]
  Call Trace:
   <TASK>
   kvm_arch_vcpu_ioctl+0xf33/0x1700 [kvm]
   kvm_vcpu_ioctl+0x4e6/0x8f0 [kvm]
   __x64_sys_ioctl+0x8f/0xd0
   do_syscall_64+0x61/0xad0
   entry_SYSCALL_64_after_hwframe+0x4b/0x53

Simply delete the WARN instead of trying to prevent userspace from shoving
"illegal" state into CR3.  For better or worse, KVM's ABI allows userspace
to set CPUID after SREGS, and vice versa, and KVM is very permissive when
it comes to guest CPUID.  I.e. attempting to enforce the virtual CPU model
when setting CPUID could break userspace.  Given that the WARN doesn't
provide any meaningful protection for KVM or benefit for userspace, simply
drop it even though the odds of breaking userspace are minuscule.

Opportunistically delete a spurious newline.

Fixes: b222b0b88162 ("KVM: nSVM: refactor the CR3 reload on migration")
Cc: stable@vger.kernel.org
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>
Reviewed-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Link: https://patch.msgid.link/20251216161755.1775409-1-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/svm/nested.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index e56c9b37e2b5b..db35033999a8e 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1880,10 +1880,9 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 	 * thus MMU might not be initialized correctly.
 	 * Set it again to fix this.
 	 */
-
 	ret = nested_svm_load_cr3(&svm->vcpu, vcpu->arch.cr3,
 				  nested_npt_enabled(svm), false);
-	if (WARN_ON_ONCE(ret))
+	if (ret)
 		goto out_free;
 
 	svm->nested.force_msr_bitmap_recalc = true;
-- 
2.51.0

