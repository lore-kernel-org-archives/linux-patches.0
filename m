Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA830612D7;
	Tue, 20 Feb 2024 21:39:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708465189; cv=none; b=FQ6e736ndmkT2eErTZwXAnOiLLuRgCNFTneYCI954xxqtihjAKrMEZf9LAmgr608MOtiuRN0FDdShSgCAtYXYbfCnZq8vRnR6zhgN4gQ0889FcIkzDQWiCDg6WxwR/WAbf7HIzZiWP3/z8uCCL/lM+weOMM1aCxh+CfE21XRV2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708465189; c=relaxed/simple;
	bh=sg3Ul7GCXQynCf/YzAOVbPIYRJU/fnECqO3oNr72PWI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S3dpmSIezteSXNeu8B8vj9AYk2uWW6xiUOWICUwnQWephhpeOEidzxJRyJdmQYBfUQ3qlL4/CEy2S5OHNiYvHPGy4pDv6eUp+WfwduEU9BuUnBAb4BxHhRummDjcRxdinAB+U/RQB3I4KLrx91M2/MeMxDlv84WX+EI1tY7jhf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PkRiAzor; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PkRiAzor"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17863C433C7;
	Tue, 20 Feb 2024 21:39:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708465189;
	bh=sg3Ul7GCXQynCf/YzAOVbPIYRJU/fnECqO3oNr72PWI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PkRiAzorm3E6hYMfFUK0lVDS81tOADx9Ehr6EnnAM7JTuvO5Bkx69P/HneMUKALOf
	 RDhN+rBgjKNJsPgv6Yz+yMyQI/DkOH16AY2v07k2+rQS9uRGFsWxbpSPjuYgr+XFGq
	 Cmx+K90X8CeEuL9k10NTmfmTpiIqzomAl/GXx1dc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Brown <broonie@kernel.org>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 6.7 265/309] arm64/signal: Dont assume that TIF_SVE means we saved SVE state
Date: Tue, 20 Feb 2024 21:57:04 +0100
Message-ID: <20240220205641.444053190@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

From: Mark Brown <broonie@kernel.org>

commit 61da7c8e2a602f66be578cbbcebe8638c10e0f48 upstream.

When we are in a syscall we will only save the FPSIMD subset even though
the task still has access to the full register set, and on context switch
we will only remove TIF_SVE when loading the register state. This means
that the signal handling code should not assume that TIF_SVE means that
the register state is stored in SVE format, it should instead check the
format that was recorded during save.

Fixes: 8c845e273104 ("arm64/sve: Leave SVE enabled on syscall if we don't context switch")
Signed-off-by: Mark Brown <broonie@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240130-arm64-sve-signal-regs-v2-1-9fc6f9502782@kernel.org
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/fpsimd.c |    2 +-
 arch/arm64/kernel/signal.c |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -1628,7 +1628,7 @@ void fpsimd_preserve_current_state(void)
 void fpsimd_signal_preserve_current_state(void)
 {
 	fpsimd_preserve_current_state();
-	if (test_thread_flag(TIF_SVE))
+	if (current->thread.fp_type == FP_STATE_SVE)
 		sve_to_fpsimd(current);
 }
 
--- a/arch/arm64/kernel/signal.c
+++ b/arch/arm64/kernel/signal.c
@@ -242,7 +242,7 @@ static int preserve_sve_context(struct s
 		vl = task_get_sme_vl(current);
 		vq = sve_vq_from_vl(vl);
 		flags |= SVE_SIG_FLAG_SM;
-	} else if (test_thread_flag(TIF_SVE)) {
+	} else if (current->thread.fp_type == FP_STATE_SVE) {
 		vq = sve_vq_from_vl(vl);
 	}
 
@@ -878,7 +878,7 @@ static int setup_sigframe_layout(struct
 	if (system_supports_sve() || system_supports_sme()) {
 		unsigned int vq = 0;
 
-		if (add_all || test_thread_flag(TIF_SVE) ||
+		if (add_all || current->thread.fp_type == FP_STATE_SVE ||
 		    thread_sm_enabled(&current->thread)) {
 			int vl = max(sve_max_vl(), sme_max_vl());
 


