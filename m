Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 589D6130E42;
	Tue, 23 Jan 2024 00:18:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969085; cv=none; b=bgU7g0ulFK1JZJLON9VY45oCgLKlSstxXl4FxvD7QBJN6hM1NgHkrlkVZ3wZgEthpf1sk7zWx8dM0DNpM+By4eZwcmAcEbvjKbMpJVw4H+PhBL0yADceSNHaCTh3PRFjhUfgNYS0nngaoSSNpfRI/ctE1LJ8bQAE5TcmEAiGi+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969085; c=relaxed/simple;
	bh=gJfZhzMQPAKLnYrgKdeiAZFBwmBWEu5DlxM08gyJ5tc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TGl3pZBwJszLfAfpk5xcjxBUJgm82ypeWWPqaTLqfSgEnqwPii1sZZgYIa3UTDGs7BTm9O8MVjJJQTkyxIVtkFnbx+3OmI1v9l2URxROvRe4p+tAxHhv61dUKU1vTS0+ZfiT69B70tTuG4APE7t+V8KhyzMHJ+eg4TS7ywm56yQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VaB1So/5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VaB1So/5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0564CC433C7;
	Tue, 23 Jan 2024 00:18:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969085;
	bh=gJfZhzMQPAKLnYrgKdeiAZFBwmBWEu5DlxM08gyJ5tc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VaB1So/5AW72lLFxwvZW4Tz9ycSJ2bBgXF0NKeRnU41K41VTnIzy7f0w5C0U67Im4
	 PfpPwp36MOWNVS9lgZUrTc7H53otMHK/O3Il1JLKTbQfyZwzv093puP1be981ExC7q
	 Z4xamNHDUU2rG9RmSpE46XXw8XOL0DyDrcHvovm8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Piggin <npiggin@gmail.com>,
	Jordan Niethe <jniethe5@gmail.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 012/641] KVM: PPC: Book3S HV: Handle pending exceptions on guest entry with MSR_EE
Date: Mon, 22 Jan 2024 15:48:36 -0800
Message-ID: <20240122235818.499700403@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicholas Piggin <npiggin@gmail.com>

[ Upstream commit ecd10702baae5c16a91d139bde7eff84ce55daee ]

Commit 026728dc5d41 ("KVM: PPC: Book3S HV P9: Inject pending xive
interrupts at guest entry") changed guest entry so that if external
interrupts are enabled, BOOK3S_IRQPRIO_EXTERNAL is not tested for. Test
for this regardless of MSR_EE.

For an L1 host, do not inject an interrupt, but always
use LPCR_MER. If the L0 desires it can inject an interrupt.

Fixes: 026728dc5d41 ("KVM: PPC: Book3S HV P9: Inject pending xive interrupts at guest entry")
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
[jpn: use kvmpcc_get_msr(), write commit message]
Signed-off-by: Jordan Niethe <jniethe5@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20231201132618.555031-7-vaibhav@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kvm/book3s_hv.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 1ed6ec140701..002a7573a5d4 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -4736,13 +4736,19 @@ int kvmhv_run_single_vcpu(struct kvm_vcpu *vcpu, u64 time_limit,
 
 	if (!nested) {
 		kvmppc_core_prepare_to_enter(vcpu);
-		if (__kvmppc_get_msr_hv(vcpu) & MSR_EE) {
-			if (xive_interrupt_pending(vcpu))
+		if (test_bit(BOOK3S_IRQPRIO_EXTERNAL,
+			     &vcpu->arch.pending_exceptions) ||
+		    xive_interrupt_pending(vcpu)) {
+			/*
+			 * For nested HV, don't synthesize but always pass MER,
+			 * the L0 will be able to optimise that more
+			 * effectively than manipulating registers directly.
+			 */
+			if (!kvmhv_on_pseries() && (__kvmppc_get_msr_hv(vcpu) & MSR_EE))
 				kvmppc_inject_interrupt_hv(vcpu,
-						BOOK3S_INTERRUPT_EXTERNAL, 0);
-		} else if (test_bit(BOOK3S_IRQPRIO_EXTERNAL,
-			     &vcpu->arch.pending_exceptions)) {
-			lpcr |= LPCR_MER;
+							   BOOK3S_INTERRUPT_EXTERNAL, 0);
+			else
+				lpcr |= LPCR_MER;
 		}
 	} else if (vcpu->arch.pending_exceptions ||
 		   vcpu->arch.doorbell_request ||
-- 
2.43.0



