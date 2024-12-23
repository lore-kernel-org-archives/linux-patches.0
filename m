Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC7D21AF0CE;
	Mon, 23 Dec 2024 16:07:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970036; cv=none; b=nyCWhBk1JGvpSKqyHh0EA0JJKo4XrTrnpgbzMYn5MTECRNFBa/3ecuznHMl1lqPMQ/vXBfSOlZ4GRhhp8Yo06aJNzwlry9SknnVPSN3NLcM1IhYaFkFXzkF7dswfH00Pz1/xaCY1BF/8TQMhnj5+1A+01S83EXa1sVgB4/k/bYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970036; c=relaxed/simple;
	bh=yXWNdhvbIbDByB0w3u6GupKASKs71yVVi2Pr8xNxYqk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mi15d7ST8zvY49E/hb5zHIPidG0vrFeUevWox9hGLLLhsfmfnTpfv4fL3P61MSnlsXmJH6EUD+rw92xzQVcsbwIdJAKoaKrd1kTfNbrxptRnTEHS+q0n/0vcuUdLp3SFg6ytPnq8XP1cN1RefZtb19LovbWaW6MwklXbfJOcrMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MeaRphgh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MeaRphgh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D7A2C4CED3;
	Mon, 23 Dec 2024 16:07:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970036;
	bh=yXWNdhvbIbDByB0w3u6GupKASKs71yVVi2Pr8xNxYqk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MeaRphghwdh6e3FWGJ1YH60Qd7oOlZHis4ZvLWr+gau+VNAw56VuZXr+6ywznB4B8
	 I6R+xcg+fP6LsnKKvE1Y0StP+fWt/1Vaxz8bdrrw4XHoygZWO42OcWKV2NApVOfy+3
	 apeKPgyaWZwIg9+p3w2CdRzs6cB8aO7/uoUVljNs=
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
Subject: [PATCH 6.12 126/160] KVM: x86: Play nice with protected guests in complete_hypercall_exit()
Date: Mon, 23 Dec 2024 16:58:57 +0100
Message-ID: <20241223155413.647977826@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155408.598780301@linuxfoundation.org>
References: <20241223155408.598780301@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -9991,7 +9991,7 @@ static int complete_hypercall_exit(struc
 {
 	u64 ret = vcpu->run->hypercall.ret;
 
-	if (!is_64_bit_mode(vcpu))
+	if (!is_64_bit_hypercall(vcpu))
 		ret = (u32)ret;
 	kvm_rax_write(vcpu, ret);
 	++vcpu->stat.hypercalls;


