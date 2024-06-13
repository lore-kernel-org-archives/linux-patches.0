Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1BFE81ABF;
	Thu, 13 Jun 2024 11:51:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279484; cv=none; b=F1kxH3RPSLKek1ditlC3PlCPGAEcXKFgBgtyW9/pojP57v92Hk0RDXMgChynsblqI+rdMKn0MijXHLeHzC5s9QgETiuLhRspI1OJLcAyu18XFeKAYQC3buCjmQyV9zaDxGZQ5ORzN+FKBTvYOzON+cRIhGe71tFiCre24nw/eqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279484; c=relaxed/simple;
	bh=AB23m2GtAfWDuH44GBxg4JAvLquhgdZ2LjICZ5glgKM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=alAw1q2pwhd8L0IPy03jm+9jUP/A89jIQosK8dZ7W44Ovjc5ZF27M7RaqaVMfovc3qEmGkINTZy70XCm97jHjnVANQ5v1gu27JMo0zdOgh9ablV4s22YKP/cUIeqmjxsZOvlj0E7iWoEQC0FXOxOFPfKMAVvP0inSXxon6uE1Cs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bTqzqclZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bTqzqclZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E494C4AF1A;
	Thu, 13 Jun 2024 11:51:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279484;
	bh=AB23m2GtAfWDuH44GBxg4JAvLquhgdZ2LjICZ5glgKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bTqzqclZeLwgd0LU8OX6X7B+ZX3h47bTmL/w6ZF7ZURL6+fF+OEUrEtq3OGi4Pipw
	 ozNivZHjCoy1gTAJw2LGqRAlBUpBqPVv0fUr4RCHPdIOZq/Kkk9yZG/EW7FDcNs43C
	 +QxEsCjFgrIOsdgWxnSZneSfn5oyydATwdG/udqk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 6.9 060/157] KVM: arm64: AArch32: Fix spurious trapping of conditional instructions
Date: Thu, 13 Jun 2024 13:33:05 +0200
Message-ID: <20240613113229.745936890@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.389465891@linuxfoundation.org>
References: <20240613113227.389465891@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Zyngier <maz@kernel.org>

commit c92e8b9eacebb4060634ebd9395bba1b29aadc68 upstream.

We recently upgraded the view of ESR_EL2 to 64bit, in keeping with
the requirements of the architecture.

However, the AArch32 emulation code was left unaudited, and the
(already dodgy) code that triages whether a trap is spurious or not
(because the condition code failed) broke in a subtle way:

If ESR_EL2.ISS2 is ever non-zero (unlikely, but hey, this is the ARM
architecture we're talking about), the hack that tests the top bits
of ESR_EL2.EC will break in an interesting way.

Instead, use kvm_vcpu_trap_get_class() to obtain the EC, and list
all the possible ECs that can fail a condition code check.

While we're at it, add SMC32 to the list, as it is explicitly listed
as being allowed to trap despite failing a condition code check (as
described in the HCR_EL2.TSC documentation).

Fixes: 0b12620fddb8 ("KVM: arm64: Treat ESR_EL2 as a 64-bit register")
Cc: stable@vger.kernel.org
Acked-by: Oliver Upton <oliver.upton@linux.dev>
Link: https://lore.kernel.org/r/20240524141956.1450304-4-maz@kernel.org
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/hyp/aarch32.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

--- a/arch/arm64/kvm/hyp/aarch32.c
+++ b/arch/arm64/kvm/hyp/aarch32.c
@@ -50,9 +50,23 @@ bool kvm_condition_valid32(const struct
 	u32 cpsr_cond;
 	int cond;
 
-	/* Top two bits non-zero?  Unconditional. */
-	if (kvm_vcpu_get_esr(vcpu) >> 30)
+	/*
+	 * These are the exception classes that could fire with a
+	 * conditional instruction.
+	 */
+	switch (kvm_vcpu_trap_get_class(vcpu)) {
+	case ESR_ELx_EC_CP15_32:
+	case ESR_ELx_EC_CP15_64:
+	case ESR_ELx_EC_CP14_MR:
+	case ESR_ELx_EC_CP14_LS:
+	case ESR_ELx_EC_FP_ASIMD:
+	case ESR_ELx_EC_CP10_ID:
+	case ESR_ELx_EC_CP14_64:
+	case ESR_ELx_EC_SVC32:
+		break;
+	default:
 		return true;
+	}
 
 	/* Is condition field valid? */
 	cond = kvm_vcpu_get_condition(vcpu);


