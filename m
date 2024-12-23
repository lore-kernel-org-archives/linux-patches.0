Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 615221865EB;
	Mon, 23 Dec 2024 16:19:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970765; cv=none; b=qZaIFZVczN9vpghp9agtnnwutS+ghZ982EWJ65ZCTmYGmcA+IlanxzzESW5+3DgC850+8yLJzS1RAM+Ol8cVbci5Ewqe75wi+/Wud90xBvbx2Cp8l+gmxyj/b8njTAE19yrMTRqIBx2ICvMgeA9cVHPyiwp/6O+WwNkZwPdmEQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970765; c=relaxed/simple;
	bh=JvFcxt4GkJJrpIX0dzDsNzR52FIBi1P/b0cHpMbwbE8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h8L0e1k+c8fuDEc/l/u0y+uWZsCxw9hWO04WH0c1e/EGpc5ddv3WpDLEnLUawR1ZhUmWeyxOXky88DMhzbfvygb/fAzNugX1Llicmbx+cIYHRlRJcDqL6sAJ3T7l5Zdgvkcvi69dkr70AW4IeXtYbTMoEsMu/PCY6JgsOEQgxuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u85MGpOc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u85MGpOc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6EC7C4CED3;
	Mon, 23 Dec 2024 16:19:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970765;
	bh=JvFcxt4GkJJrpIX0dzDsNzR52FIBi1P/b0cHpMbwbE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u85MGpOc+m+aZilE9d3HbyakhlBQ3tJbCpPqRTIVQbg1H3jhv7UWjKyi+eiTniEdt
	 R9+XmxT+iTjaKEyvJT+hJT3+epWAIzzdiKKYqAdRWXJmiI7SJLq8V4E54V0JvfZ93j
	 7bqyX9u6F95tSMJSHM3KWvXrlNNsWP9GAWnidXd8=
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
Subject: [PATCH 6.1 61/83] KVM: x86: Play nice with protected guests in complete_hypercall_exit()
Date: Mon, 23 Dec 2024 16:59:40 +0100
Message-ID: <20241223155355.989547466@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155353.641267612@linuxfoundation.org>
References: <20241223155353.641267612@linuxfoundation.org>
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
@@ -9712,7 +9712,7 @@ static int complete_hypercall_exit(struc
 {
 	u64 ret = vcpu->run->hypercall.ret;
 
-	if (!is_64_bit_mode(vcpu))
+	if (!is_64_bit_hypercall(vcpu))
 		ret = (u32)ret;
 	kvm_rax_write(vcpu, ret);
 	++vcpu->stat.hypercalls;


