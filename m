Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A3FE53A7;
	Fri,  6 Dec 2024 15:07:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497651; cv=none; b=uSaevVx8hBgJ1vKB5YhNwRpTWqp8i5CZRO38nkv5CSxzvLLs+FtPfDbRBVSu2mDuSllTnVx4RX8fT1YyT3A3UGFZWgEbKMbDw1susFYIndMh5HWja4f9FGihQGlI26n6/MzJQtMmRTKek6p2nbA2uHhULfg0CkvsjYix1mDfGog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497651; c=relaxed/simple;
	bh=l6vM25Sjbf9IUmZVLiiGCTfY2p/gSwm/E6JT09ha2qo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jQCiVY6SuvNwYxhSb3nF6kDXfK+9rKPvlj7r/rUcUsXQGemK7XbpYDLqp7hXCUoVqCqN2XDlDj2QMG8P+LzItiCEH5McZEWeOBjPaPo21Lko++k2gdP5p9LzeW4yofqXWlnh4TAIhKN6UKhn1YMtseIG9zqhwWXVyV/9hosxVKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uNpDAibq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uNpDAibq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2AD7C4CEE1;
	Fri,  6 Dec 2024 15:07:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497651;
	bh=l6vM25Sjbf9IUmZVLiiGCTfY2p/gSwm/E6JT09ha2qo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uNpDAibqzz35iYZm0cDxcMc9whiS7lc5oXK2ppSUryaJFBTHjPxmBjgzCkAA6ZeG6
	 XfLVNOCbS6Y5TpsiwVQwRU+tO1jzeb3xrFW92cgGHQk3irr/F1uRWIGpn7Y3w0T+XY
	 7GPWXjrevqyNQ/+6OTRgx0TBP7LS1wpu1WpI8ER0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gautam Menghani <gautam@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 320/676] KVM: PPC: Book3S HV: Avoid returning to nested hypervisor on pending doorbells
Date: Fri,  6 Dec 2024 15:32:19 +0100
Message-ID: <20241206143705.844671913@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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
index 14511e457ade1..924689fa5efa1 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -4687,7 +4687,6 @@ int kvmhv_run_single_vcpu(struct kvm_vcpu *vcpu, u64 time_limit,
 				lpcr |= LPCR_MER;
 		}
 	} else if (vcpu->arch.pending_exceptions ||
-		   vcpu->arch.doorbell_request ||
 		   xive_interrupt_pending(vcpu)) {
 		vcpu->arch.ret = RESUME_HOST;
 		goto out;
-- 
2.43.0



