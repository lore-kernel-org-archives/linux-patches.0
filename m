Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BBD314A0BC;
	Thu, 13 Jun 2024 11:51:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279466; cv=none; b=lcrtor86BsoERlXncKC1Gy/2jvow0NsbWDqnTOK36Alok+DtRseVN7uoG8zLFdCH/BgiytIhklpBhCn2D0DchPFcERZmdOhmu/ddw1xwVGNNwr3Rq3AGGBT76qqIxxyuiLL3IK3Sxwd3uMMUs7PS3GuJC1Z4p7bC4jQAOISuUZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279466; c=relaxed/simple;
	bh=F9kfQOaJ+BqljTzsFdUmN3Hn0e3pNY9yMvIHnoRg/fU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TGzNzgLENm6YWGRccAkfscL061tBWtWidr3Vm1CFyewWBnZihYNJRKBGIdYy3n2yZtnZoy/RM4dT5RACq1x7qbEJ/V0GvIAGfgvXLrj+NzEmJcuGlnHMhn80g+jnvIYosL+iSPIO3WzD1JQBNcB3+kAbT4h8dyE4pHhtx5lDVug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LK+odMWb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LK+odMWb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0304CC2BBFC;
	Thu, 13 Jun 2024 11:51:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279466;
	bh=F9kfQOaJ+BqljTzsFdUmN3Hn0e3pNY9yMvIHnoRg/fU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LK+odMWbT8UFeQ0S7tSrGUOIduQSAvt6k2XDYtKtCxaD93Yb77J4x/BzUNp6IBrZE
	 4/Ol+sJxSsSCQDy4dgIRlpXQMkUuXY51wXFbnppqdVU4EsQD2YybkNb7NguLq4m0BA
	 ZzZQoAqYFQBT412gGnXkMOm0JfP7sZ5jXVWYbGR0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 6.9 058/157] KVM: arm64: Fix AArch32 register narrowing on userspace write
Date: Thu, 13 Jun 2024 13:33:03 +0200
Message-ID: <20240613113229.670697862@linuxfoundation.org>
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


