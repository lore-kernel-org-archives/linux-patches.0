Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7ACD12C47D;
	Thu, 13 Jun 2024 12:45:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282731; cv=none; b=aDLZAGFqVrkRNJxZ/s/DJsguWF12WvgpEnh8fZXuoWj/yOZNi3mEPxHSowm894rO3vX7OwuU4yj9r9YIQZL3X/I3IkYhfacA6xV2h5NQNeJbzkV3Z+HtsLoWbpio0qJv2Dxb7+4smN6tBvdwbTuIYiML9jWqKVZp0NX3V9uMDXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282731; c=relaxed/simple;
	bh=5wNqid90rr7atYQZY9PakQnfLtSZPNTCRKIeM429Zqk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sUbW1HfYoVrohP/EaEgz3qdGPnqQOoK1x2vNr7nXPfCKloYYjex93gFeXPApfDuesUxYnYSKHA74nLWsi/Wy0GKhisMXc1XX4NWWzlUDA2J5y4CSawVTFkiiPB44iqSqgliitklg2dvSWaIalTCHtbPAaqyBAffoVh0EQTT2O0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zFoMV4o/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zFoMV4o/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38581C2BBFC;
	Thu, 13 Jun 2024 12:45:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282731;
	bh=5wNqid90rr7atYQZY9PakQnfLtSZPNTCRKIeM429Zqk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zFoMV4o/9c3+o7kPLQQDBGOBA8WAb2cr4uRq8SEFf1vX8mKSAVeXpvIx/2t/GafmL
	 wqnW0QyPX6Wqr+U1/+Az45+RGtWum8sOHHGZasNniGL7sxzd5bJqeOn63fu+QZPW0M
	 f6hiKfPv2MxRHAnxUarTkm1CvzZSmPfHHJlA8KaM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 5.15 376/402] KVM: arm64: Fix AArch32 register narrowing on userspace write
Date: Thu, 13 Jun 2024 13:35:33 +0200
Message-ID: <20240613113316.811200647@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -270,7 +270,7 @@ static int set_core_reg(struct kvm_vcpu
 	if (*vcpu_cpsr(vcpu) & PSR_MODE32_BIT) {
 		int i, nr_reg;
 
-		switch (*vcpu_cpsr(vcpu)) {
+		switch (*vcpu_cpsr(vcpu) & PSR_AA32_MODE_MASK) {
 		/*
 		 * Either we are dealing with user mode, and only the
 		 * first 15 registers (+ PC) must be narrowed to 32bit.


