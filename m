Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5A1219E98B;
	Mon, 23 Dec 2024 16:14:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970461; cv=none; b=regxBhrgNzGB3RVr1oYFG7SGDQrDYjyHpcD35fVjjYjlC0eYzCIx+2krxFOt50Hoa/m8wlPdi+5vT1FuTjH3SO+m3uDCpyKBUApDlTDCGxq5kTmYwXY3v5n7mBS4mtNZ0n9YDb3n7pGe82DEHbietD2we3yV/en8fuzVtxq0Mnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970461; c=relaxed/simple;
	bh=16coeFHH6OoD3q+8q/7lBifuIDHFwXRtFk6IrvYQloc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hc3HpYW+auehpEUVknqX0UhBpmIoHoBdv2O0IXUkfJz16h7v6ja+qRthMEeXMRMpNvSIIbaM6/aKfQcLrP0K5CAtYquwCnF90tmFf/6lVIVdMrQ/2qgXJ2/+9PsWXN5xkJMUDAFpIv18GQKf3XkBk9EFed2Mvxb06duVnpsUhKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xHgx6AUM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xHgx6AUM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D731FC4CED3;
	Mon, 23 Dec 2024 16:14:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970461;
	bh=16coeFHH6OoD3q+8q/7lBifuIDHFwXRtFk6IrvYQloc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xHgx6AUMeIDG02+RIu6kYVMO2juO3Blq4oqyerNq1jiIhCtYxU4/X8WDCX1aCIljX
	 cmCHzq77pg2cyTICfz7HUy1zBYXIODB9aLeDahbhbserOANpYsrDQ1kuM/CF6tvaQ9
	 H0uxGBIvPdgqKs4eObyj3VUhIKEbwFcBeJhc392E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Nikunj A Dadhania <nikunj@amd.com>,
	Binbin Wu <binbin.wu@linux.intel.com>,
	Kai Huang <kai.huang@intel.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.6 090/116] KVM: x86: Play nice with protected guests in complete_hypercall_exit()
Date: Mon, 23 Dec 2024 16:59:20 +0100
Message-ID: <20241223155403.063849539@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155359.534468176@linuxfoundation.org>
References: <20241223155359.534468176@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

commit 9b42d1e8e4fe9dc631162c04caa69b0d1860b0f0 upstream.

Use is_64_bit_hypercall() instead of is_64_bit_mode() to detect a 64-bit
hypercall when completing said hypercall.  For guests with protected state,
e.g. SEV-ES and SEV-SNP, KVM must assume the hypercall was made in 64-bit
mode as the vCPU state needed to detect 64-bit mode is unavailable.

Hacking the sev_smoke_test selftest to generate a KVM_HC_MAP_GPA_RANGE
hypercall via VMGEXIT trips the WARN:

  ------------[ cut here ]------------
  WARNING: CPU: 273 PID: 326626 at arch/x86/kvm/x86.h:180 complete_hypercall_exit+0x44/0xe0 [kvm]
  Modules linked in: kvm_amd kvm ... [last unloaded: kvm]
  CPU: 273 UID: 0 PID: 326626 Comm: sev_smoke_test Not tainted 6.12.0-smp--392e932fa0f3-feat #470
  Hardware name: Google Astoria/astoria, BIOS 0.20240617.0-0 06/17/2024
  RIP: 0010:complete_hypercall_exit+0x44/0xe0 [kvm]
  Call Trace:
   <TASK>
   kvm_arch_vcpu_ioctl_run+0x2400/0x2720 [kvm]
   kvm_vcpu_ioctl+0x54f/0x630 [kvm]
   __se_sys_ioctl+0x6b/0xc0
   do_syscall_64+0x83/0x160
   entry_SYSCALL_64_after_hwframe+0x76/0x7e
   </TASK>
  ---[ end trace 0000000000000000 ]---

Fixes: b5aead0064f3 ("KVM: x86: Assume a 64-bit hypercall for guests with protected state")
Cc: stable@vger.kernel.org
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Reviewed-by: Nikunj A Dadhania <nikunj@amd.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
Reviewed-by: Kai Huang <kai.huang@intel.com>
Link: https://lore.kernel.org/r/20241128004344.4072099-2-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/x86.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9825,7 +9825,7 @@ static int complete_hypercall_exit(struc
 {
 	u64 ret = vcpu->run->hypercall.ret;
 
-	if (!is_64_bit_mode(vcpu))
+	if (!is_64_bit_hypercall(vcpu))
 		ret = (u32)ret;
 	kvm_rax_write(vcpu, ret);
 	++vcpu->stat.hypercalls;


