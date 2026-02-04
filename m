Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C204042316B;
	Wed,  4 Feb 2026 15:23:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218591; cv=none; b=n1HhGPm75zB2bI1SUeysBifdObvp15vp3gY53+EQ6OZUjb3h+WDR1HtPJkvA+6ilCDfHVXxTn15LbKrfHFTl++8rr2xxVpeJHzVp1w58dZGXoI0z6HpUAhNFZRf1uzj9SvfuPVNQOeKdDXEu2nLJXL4h8bk4c/fQgCd38asydrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218591; c=relaxed/simple;
	bh=1vsub2FRND57wxHDP7E6DqDOESM7nE1dMyLv3JXke6I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YPrBOXMtdSt/NY82nhAjYkNKOqdX01yTfU1vl/li9AjX3GTNFv35/YbzfvcPHmJwg3Wk8faUyQAn0MjdC/cLpPIpHmHWixLgy55UhPYhx5cKYDJVNabD2t0ZXzGSHYI7r3d2PwFIbe2HTJkq4b97kz9kHs63mCNzJljlTfrAr8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QlXaHIEk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QlXaHIEk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EDB5C4CEF7;
	Wed,  4 Feb 2026 15:23:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218591;
	bh=1vsub2FRND57wxHDP7E6DqDOESM7nE1dMyLv3JXke6I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QlXaHIEkJSmJitvWNOGMgaDMsiDCFWTPIW3G0xjEXvM3RI0kHyNAeRWJh9gdXFAjP
	 dhBPJkyDoQdbFRrP7oWANCcJ+GwPmAXz4DjSWpeNWAFOThnlORGfBca8E+zuWrMQq9
	 0SwFnm717KXPsNP2Dl/dZp60vcBIn28BvtPLz0U0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 45/72] arm64/fpsimd: signal: Consistently read FPSIMD context
Date: Wed,  4 Feb 2026 15:40:48 +0100
Message-ID: <20260204143847.260310999@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143845.603454952@linuxfoundation.org>
References: <20260204143845.603454952@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Mark Rutland <mark.rutland@arm.com>

[ Upstream commit be625d803c3bbfa9652697eb57589fe6f2f24b89 ]

For historical reasons, restore_sve_fpsimd_context() has an open-coded
copy of the logic from read_fpsimd_context(), which is used to either
restore an FPSIMD-only context, or to merge FPSIMD state into an
SVE state when restoring an SVE+FPSIMD context. The logic is *almost*
identical.

Refactor the logic to avoid duplication and make this clearer.

This comes with two functional changes that I do not believe will be
problematic in practice:

* The user_fpsimd_state::size field will be checked in all restore paths
  that consume it user_fpsimd_state. The kernel always populates this
  field when delivering a signal, and so this should contain the
  expected value unless it has been corrupted.

* If a read of user_fpsimd_state fails, we will return early without
  modifying TIF_SVE, the saved SVCR, or the save fp_type. This will
  leave the task in a consistent state, without potentially resurrecting
  stale FPSIMD state. A read of user_fpsimd_state should never fail
  unless the structure has been corrupted or the stack has been
  unmapped.

Suggested-by: Will Deacon <will@kernel.org>
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Will Deacon <will@kernel.org>
Link: https://lore.kernel.org/r/20250508132644.1395904-5-mark.rutland@arm.com
[will: Ensure read_fpsimd_context() returns negative error code or zero]
Signed-off-by: Will Deacon <will@kernel.org>
Stable-dep-of: d2907cbe9ea0 ("arm64/fpsimd: signal: Fix restoration of SVE context")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/signal.c |   57 ++++++++++++++++++++++-----------------------
 1 file changed, 29 insertions(+), 28 deletions(-)

--- a/arch/arm64/kernel/signal.c
+++ b/arch/arm64/kernel/signal.c
@@ -202,29 +202,39 @@ static int preserve_fpsimd_context(struc
 	return err ? -EFAULT : 0;
 }
 
-static int restore_fpsimd_context(struct user_ctxs *user)
+static int read_fpsimd_context(struct user_fpsimd_state *fpsimd,
+			       struct user_ctxs *user)
 {
-	struct user_fpsimd_state fpsimd;
-	int err = 0;
+	int err;
 
 	/* check the size information */
 	if (user->fpsimd_size != sizeof(struct fpsimd_context))
 		return -EINVAL;
 
 	/* copy the FP and status/control registers */
-	err = __copy_from_user(fpsimd.vregs, &(user->fpsimd->vregs),
-			       sizeof(fpsimd.vregs));
-	__get_user_error(fpsimd.fpsr, &(user->fpsimd->fpsr), err);
-	__get_user_error(fpsimd.fpcr, &(user->fpsimd->fpcr), err);
+	err = __copy_from_user(fpsimd->vregs, &(user->fpsimd->vregs),
+			       sizeof(fpsimd->vregs));
+	__get_user_error(fpsimd->fpsr, &(user->fpsimd->fpsr), err);
+	__get_user_error(fpsimd->fpcr, &(user->fpsimd->fpcr), err);
+
+	return err ? -EFAULT : 0;
+}
+
+static int restore_fpsimd_context(struct user_ctxs *user)
+{
+	struct user_fpsimd_state fpsimd;
+	int err;
+
+	err = read_fpsimd_context(&fpsimd, user);
+	if (err)
+		return err;
 
 	clear_thread_flag(TIF_SVE);
 	current->thread.fp_type = FP_STATE_FPSIMD;
 
 	/* load the hardware registers from the fpsimd_state structure */
-	if (!err)
-		fpsimd_update_current_state(&fpsimd);
-
-	return err ? -EFAULT : 0;
+	fpsimd_update_current_state(&fpsimd);
+	return 0;
 }
 
 
@@ -316,12 +326,8 @@ static int restore_sve_fpsimd_context(st
 	 * consistency and robustness, reject restoring streaming SVE state
 	 * without an SVE payload.
 	 */
-	if (!sm && user->sve_size == sizeof(*user->sve)) {
-		clear_thread_flag(TIF_SVE);
-		current->thread.svcr &= ~SVCR_SM_MASK;
-		current->thread.fp_type = FP_STATE_FPSIMD;
-		goto fpsimd_only;
-	}
+	if (!sm && user->sve_size == sizeof(*user->sve))
+		return restore_fpsimd_context(user);
 
 	vq = sve_vq_from_vl(vl);
 
@@ -357,19 +363,14 @@ static int restore_sve_fpsimd_context(st
 		set_thread_flag(TIF_SVE);
 	current->thread.fp_type = FP_STATE_SVE;
 
-fpsimd_only:
-	/* copy the FP and status/control registers */
-	/* restore_sigframe() already checked that user->fpsimd != NULL. */
-	err = __copy_from_user(fpsimd.vregs, user->fpsimd->vregs,
-			       sizeof(fpsimd.vregs));
-	__get_user_error(fpsimd.fpsr, &user->fpsimd->fpsr, err);
-	__get_user_error(fpsimd.fpcr, &user->fpsimd->fpcr, err);
+	err = read_fpsimd_context(&fpsimd, user);
+	if (err)
+		return err;
 
-	/* load the hardware registers from the fpsimd_state structure */
-	if (!err)
-		fpsimd_update_current_state(&fpsimd);
+	/* Merge the FPSIMD registers into the SVE state */
+	fpsimd_update_current_state(&fpsimd);
 
-	return err ? -EFAULT : 0;
+	return 0;
 }
 
 #else /* ! CONFIG_ARM64_SVE */


