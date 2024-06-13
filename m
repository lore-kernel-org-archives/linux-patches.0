Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00598144D21;
	Thu, 13 Jun 2024 12:07:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280462; cv=none; b=U5suZj8yssuoQG1kjZyljn2nVweXF5IU9MgrFA1jkFsWxKP9Cmp9PfdLw2uhmspRYEo7kn5TUf7BjzTEURAGoFf1KoJ5R7jYYn1dN/L2s1EXgP0DzcfAtb7h0vDFGIgRmRHEVNSAGatpJPA+G5eupUrmUkXGlbr6WqpxLyw0wHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280462; c=relaxed/simple;
	bh=sH0/jnnTXKMR58clrCqMbubBr2tB2CPAFlbmBBp8QBc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HpxLdUNl58Ye11Xti76ppMHGbpMQe+Z8xWafX1WddzrlNChYLJ8q5nPNrj2q/P7o4u2+/7hjrTj+BUuZiejUWVwDhB+Z1WM2+3UvnEf0o5+ktpQ9vORgEAxhmTWTNw1p6ANR9A/dMq1RHgtszBVF6bCdLt+3ebyISdYjQitet0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p7ATSxYP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p7ATSxYP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 736FBC2BBFC;
	Thu, 13 Jun 2024 12:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280461;
	bh=sH0/jnnTXKMR58clrCqMbubBr2tB2CPAFlbmBBp8QBc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p7ATSxYPKIa5zihPpGmNgbEgfkNII5LZ/+6KK+IEyPPUONNlLiqhtR54H2edVv5TR
	 U5B8zFkSbqKgqYt6ZiFz6nSvbV2nTPGa5wyCRRd9UA5qo5iBru9++C1RMm8RpgKS3g
	 YDXQQg3a7TIJjZqtmqUj7zlvcHQ8tKZgF0tggDVc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 6.6 061/137] KVM: arm64: Fix AArch32 register narrowing on userspace write
Date: Thu, 13 Jun 2024 13:34:01 +0200
Message-ID: <20240613113225.669379953@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113223.281378087@linuxfoundation.org>
References: <20240613113223.281378087@linuxfoundation.org>
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

From: Marc Zyngier <maz@kernel.org>

commit 947051e361d551e0590777080ffc4926190f62f2 upstream.

When userspace writes to one of the core registers, we make
sure to narrow the corresponding GPRs if PSTATE indicates
an AArch32 context.

The code tries to check whether the context is EL0 or EL1 so
that it narrows the correct registers. But it does so by checking
the full PSTATE instead of PSTATE.M.

As a consequence, and if we are restoring an AArch32 EL0 context
in a 64bit guest, and that PSTATE has *any* bit set outside of
PSTATE.M, we narrow *all* registers instead of only the first 15,
destroying the 64bit state.

Obviously, this is not something the guest is likely to enjoy.

Correctly masking PSTATE to only evaluate PSTATE.M fixes it.

Fixes: 90c1f934ed71 ("KVM: arm64: Get rid of the AArch32 register mapping code")
Reported-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Cc: stable@vger.kernel.org
Reviewed-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Acked-by: Oliver Upton <oliver.upton@linux.dev>
Link: https://lore.kernel.org/r/20240524141956.1450304-2-maz@kernel.org
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/guest.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -276,7 +276,7 @@ static int set_core_reg(struct kvm_vcpu
 	if (*vcpu_cpsr(vcpu) & PSR_MODE32_BIT) {
 		int i, nr_reg;
 
-		switch (*vcpu_cpsr(vcpu)) {
+		switch (*vcpu_cpsr(vcpu) & PSR_AA32_MODE_MASK) {
 		/*
 		 * Either we are dealing with user mode, and only the
 		 * first 15 registers (+ PC) must be narrowed to 32bit.


