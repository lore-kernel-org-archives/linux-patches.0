Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D4672820AC;
	Wed, 23 Apr 2025 15:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745422165; cv=none; b=EpBH5DHx3NLkaZVgwna4hA9h60BQciylNvBbkmPvBfwY6XTijuMZGOXsBRByIkbukuvzmsfkaFEu8UwypfMlMKQTCvvpup7W+dzfMm/uEhsJozGDlmgq20xeHG8JexRg3wY4ZB7BsXXe69kRyw5w79wVPV3cHn+JNrrihDwMk+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745422165; c=relaxed/simple;
	bh=+Y1yKls/L5V92Y8GJu8oyksDhZRkzqh6pOONKfFLIT4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nngjpg3ixxA46n1FadKX8TK7EzavtipDurVUNZh/pC4Ea2tVUkBDTsVnPImKFOmFnXAgG/8TjOsM5Mh8uo0RK6RcITp/FtwHt0vzK+AIz36GS69bUHgy1LXWUyj4AaKeHPf6YmcARwVsSNFn2a35S61Fzj6vstV4xmzDG1zKo1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j2wolQtu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j2wolQtu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 947FBC4CEE2;
	Wed, 23 Apr 2025 15:29:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745422164;
	bh=+Y1yKls/L5V92Y8GJu8oyksDhZRkzqh6pOONKfFLIT4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j2wolQtuk+RU17roevU6IQs4tG9lJQUoti2cYfpTmvPcSshN5pFHuF3g5F6ZbkG26
	 LJXhgE8xKkZRUVlZiQ8R55oNxeE7Tm/lSr3zPE+uPlzNWLDL0oK5zW/qvuHQeFuoIf
	 37GxomSFNnW8mxVG7+jPRG9WcOaatfSKNqcMxaxA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Brown <broonie@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH 6.1 248/291] arm64/fpsimd: Stop using TIF_SVE to manage register saving in KVM
Date: Wed, 23 Apr 2025 16:43:57 +0200
Message-ID: <20250423142634.551972488@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Mark Brown <broonie@kernel.org>

[ Upstream commit 62021cc36add7b2c015b837f7893f2fb4b8c2586 ]

Now that we are explicitly telling the host FP code which register state
it needs to save we can remove the manipulation of TIF_SVE from the KVM
code, simplifying it and allowing us to optimise our handling of normal
tasks. Remove the manipulation of TIF_SVE from KVM and instead rely on
to_save to ensure we save the correct data for it.

There should be no functional or performance impact from this change.

Signed-off-by: Mark Brown <broonie@kernel.org>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20221115094640.112848-5-broonie@kernel.org
Signed-off-by: Will Deacon <will@kernel.org>
[ Mark: trivial backport ]
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/fpsimd.c |   22 ++++------------------
 arch/arm64/kvm/fpsimd.c    |    3 ---
 2 files changed, 4 insertions(+), 21 deletions(-)

--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -439,8 +439,8 @@ static void task_fpsimd_load(void)
  * last, if KVM is involved this may be the guest VM context rather
  * than the host thread for the VM pointed to by current. This means
  * that we must always reference the state storage via last rather
- * than via current, other than the TIF_ flags which KVM will
- * carefully maintain for us.
+ * than via current, if we are saving KVM state then it will have
+ * ensured that the type of registers to save is set in last->to_save.
  */
 static void fpsimd_save(void)
 {
@@ -457,27 +457,13 @@ static void fpsimd_save(void)
 	if (test_thread_flag(TIF_FOREIGN_FPSTATE))
 		return;
 
-	if (test_thread_flag(TIF_SVE)) {
+	if ((last->to_save == FP_STATE_CURRENT && test_thread_flag(TIF_SVE)) ||
+	    last->to_save == FP_STATE_SVE) {
 		save_sve_regs = true;
 		save_ffr = true;
 		vl = last->sve_vl;
 	}
 
-	/*
-	 * Validate that an explicitly specified state to save is
-	 * consistent with the task state.
-	 */
-	switch (last->to_save) {
-	case FP_STATE_CURRENT:
-		break;
-	case FP_STATE_FPSIMD:
-		WARN_ON_ONCE(save_sve_regs);
-		break;
-	case FP_STATE_SVE:
-		WARN_ON_ONCE(!save_sve_regs);
-		break;
-	}
-
 	if (system_supports_sme()) {
 		u64 *svcr = last->svcr;
 
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -151,7 +151,6 @@ void kvm_arch_vcpu_ctxsync_fp(struct kvm
 					 &vcpu->arch.fp_type, fp_type);
 
 		clear_thread_flag(TIF_FOREIGN_FPSTATE);
-		update_thread_flag(TIF_SVE, vcpu_has_sve(vcpu));
 	}
 }
 
@@ -208,7 +207,5 @@ void kvm_arch_vcpu_put_fp(struct kvm_vcp
 			sysreg_clear_set(CPACR_EL1, CPACR_EL1_ZEN_EL0EN, 0);
 	}
 
-	update_thread_flag(TIF_SVE, 0);
-
 	local_irq_restore(flags);
 }


