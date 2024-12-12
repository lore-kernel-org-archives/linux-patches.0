Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4455323589B;
	Thu, 12 Dec 2024 16:06:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019606; cv=none; b=eoMkdQEn1Zr3B0gjx1SaNTH2KclCp0Z6ZfsEiaMVZiBR4iMClC2+WAG9WjASTx6262i/SkKEfPj1wnUFsTDf7v2189LRyP0hawu7bImcnjdfRvCNrRPKNDEYHSAjYgSxDeSg1wfLEZDPEFwXKUq3ZYqzUQihE+XKIp2kjcYuyT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019606; c=relaxed/simple;
	bh=YZxg+w3Hl/LzQqDPTYS5dxTndYMRO4xPfOl6G/Jg3t8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ogfcSRSBbI/og2ohFjQgUoP4ytoAudT7PVYEmrhTxECwN3k7tgrA4BxN/eVx0le99MqygJn/0aNXb+RZRK9P6Q3FFkR6G0ZynE+hIaO4AsZTcZHtYj04yFrIn5fxvcMOGebsw2rF9mLdD/e1APnmQCLUMl3tqOfZsO/DFCmHobY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KriQ5Q/T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KriQ5Q/T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34D67C4CECE;
	Thu, 12 Dec 2024 16:06:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019605;
	bh=YZxg+w3Hl/LzQqDPTYS5dxTndYMRO4xPfOl6G/Jg3t8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KriQ5Q/TNRjKK8KpE6/5uzb41MQUEmJxcgGPVDsIPaUOF0AJsIB/WGPsuf5NGuCY6
	 NJ/AjBTOBMbcNRVNHEQlEtg8XAdmFzmUgijeUillnfd4tL6iUrsJoRtcDlmsrm8sTK
	 LeHpiBf0gvZEWXQB/fqHSGY0TLMPybei5oz0xQ4s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gautam Menghani <gautam@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 250/772] KVM: PPC: Book3S HV: Avoid returning to nested hypervisor on pending doorbells
Date: Thu, 12 Dec 2024 15:53:15 +0100
Message-ID: <20241212144400.254742261@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

From: Gautam Menghani <gautam@linux.ibm.com>

[ Upstream commit 26686db69917399fa30e3b3135360771e90f83ec ]

Commit 6398326b9ba1 ("KVM: PPC: Book3S HV P9: Stop using vc->dpdes")
dropped the use of vcore->dpdes for msgsndp / SMT emulation. Prior to that
commit, the below code at L1 level (see [1] for terminology) was
responsible for setting vc->dpdes for the respective L2 vCPU:

if (!nested) {
	kvmppc_core_prepare_to_enter(vcpu);
	if (vcpu->arch.doorbell_request) {
		vc->dpdes = 1;
		smp_wmb();
		vcpu->arch.doorbell_request = 0;
	}

L1 then sent vc->dpdes to L0 via kvmhv_save_hv_regs(), and while
servicing H_ENTER_NESTED at L0, the below condition at L0 level made sure
to abort and go back to L1 if vcpu->arch.doorbell_request = 1 so that L1
sets vc->dpdes as per above if condition:

} else if (vcpu->arch.pending_exceptions ||
	   vcpu->arch.doorbell_request ||
	   xive_interrupt_pending(vcpu)) {
	vcpu->arch.ret = RESUME_HOST;
	goto out;
}

This worked fine since vcpu->arch.doorbell_request was used more like a
flag and vc->dpdes was used to pass around the doorbell state. But after
Commit 6398326b9ba1 ("KVM: PPC: Book3S HV P9: Stop using vc->dpdes"),
vcpu->arch.doorbell_request is the only variable used to pass around
doorbell state.
With the plumbing for handling doorbells for nested guests updated to use
vcpu->arch.doorbell_request over vc->dpdes, the above "else if" stops
doorbells from working correctly as L0 aborts execution of L2 and
instead goes back to L1.

Remove vcpu->arch.doorbell_request from the above "else if" condition as
it is no longer needed for L0 to correctly handle the doorbell status
while running L2.

[1] Terminology
1. L0 : PowerNV linux running with HV privileges
2. L1 : Pseries KVM guest running on top of L0
2. L2 : Nested KVM guest running on top of L1

Fixes: 6398326b9ba1 ("KVM: PPC: Book3S HV P9: Stop using vc->dpdes")
Signed-off-by: Gautam Menghani <gautam@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://patch.msgid.link/20241109063301.105289-4-gautam@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kvm/book3s_hv.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 479218389e7cd..45708ac55e90e 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -4653,7 +4653,6 @@ int kvmhv_run_single_vcpu(struct kvm_vcpu *vcpu, u64 time_limit,
 			lpcr |= LPCR_MER;
 		}
 	} else if (vcpu->arch.pending_exceptions ||
-		   vcpu->arch.doorbell_request ||
 		   xive_interrupt_pending(vcpu)) {
 		vcpu->arch.ret = RESUME_HOST;
 		goto out;
-- 
2.43.0



