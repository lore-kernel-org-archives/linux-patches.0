Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829130;
	b=r7xE8izrfTRV+CjHqp/8PRJdKsCL55GPq/sIiSSJQPcOJ7utcCvxTFbpcm0zzipOzbMX
	 7wQMZt6/Af+s6apRBPXOqXjaHH/ysg6qeiceplrB++moewjy5LLZTNgDbw44A9ip+d+Az
	 qTJAXHjR6NGjQ90/1uUO746VueTPActvClUUdZjr3eXLcEbLnXkHKFGPhSxbi6t+DeF5f
	 P3asx254NWI4l+tTh2TFdd8LFXXc994lprqkAPJc2CcwThGYnHr6db8B6XPQFxjjNomeZ
	 c81ioEzQkwyNtj5cg+06ECeHO8yjA2xY0Ygxow5EnzXu4zli0fQl6AGOfqr21B32a6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829130;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ReG/+abbzgsdhJwhU2hoLMpEPy0A/ijoVCWSharuB8Y=;
	b=XAAoXoJZ8xrFnRh7RpljOi6hDlBmeVuJIdEPTRNx5JDpv6h66x6RzWaGPJAKHDpmy2QS
	 5xlOuKyTOIFhCs94a60/TvV2CvlXBSe4fc60j/Cy+KL+KuK7KY8z/1pIevaEucnAF3Ry0
	 v9rtN1IZ79OTXdBBdqqHU0xbT3BfcoHxxw2IIEh1wSCUoTyd7S71cg40FN6kObBRYk7eb
	 qD3rgJ/LH7LMwFAQk0DkEkh2UXHROKsDaB3NVJDgBF4CXs4XVQOJcEqIoVd5+kb1zBHTp
	 iTsyUF9xxOe3A2YlRpLmsNBwbtDVVpscsvunbEfGQzSuVWIZMz57kYIj9QODdjR5zZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ACwTk5b9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B119A607033E;
	Wed,  4 Nov 2026 21:52:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ACwTk5b9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54A0C1F00919;
	Wed,  4 Nov 2026 21:52:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829129;
	bh=ReG/+abbzgsdhJwhU2hoLMpEPy0A/ijoVCWSharuB8Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ACwTk5b9zx80u76a1iyDujG/Kg2pEaQtL1B1V4uDs/CnPSwC3OdiBT8OlCGsFVtat
	 qxhjhr6N1kjHjxkc/eBASwDT+QagL/s5O/hxsJiIVPESMcf3yfWwJXjm78Op6mDgwZ
	 JP6O8KK9CBvg5+wSAHJMsjSylejtdHPDfPPFeExI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 7.3 464/547] KVM: x86/mmu: Bug the VM if KVM calcs a CPU role with EFER.LMA=1 && CR4.PAE=0
Date: Wed,  4 Nov 2026 16:10:48 -0500
Message-ID: <20261104211051.536779848@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

commit 34dacbe7ae93f2d3c26cd0bf3e08200b1fa2c180 upstream.

Bug the VM if KVM attempts to construct a CPU role with the should-be-
impossible combination of long mode being active without PAE paging being
enabled.  KVM's MMU construction assumes that EFER.LMA can be set if and
only CR4.PAE is set, and will create a completely invalid MMU if that
assumption fails.  FNAME(walk_addr_generic) already has sanity checks to
try and mitigate the fallout, but attempt to catch such bugs earlier, as
this is (at least) the second time KVM has had bugs that escaped into
FNAME(walk_addr_generic), and it's entirely possible the bad state could
cause problems elsewhere.

Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260902232028.2767071-5-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/mmu/mmu.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5916,6 +5916,9 @@ static union kvm_cpu_role kvm_calc_cpu_r
 		return role;
 	}
 
+	if (KVM_BUG_ON(____is_efer_lma(regs) && !____is_cr4_pae(regs), vcpu->kvm))
+		*(u64 *)&regs->efer &= ~EFER_LMA;
+
 	role.base.efer_nx = ____is_efer_nx(regs);
 	role.base.cr0_wp = ____is_cr0_wp(regs);
 	role.base.cr4_smep = ____is_cr4_smep(regs);


