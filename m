Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C255B24A06D;
	Mon, 23 Jun 2025 13:39:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685963; cv=none; b=XIXHu5BbQ/hUUTUQKEk9F453P7m8K4AkFBxqCgTVYtTd6/k5CwFLgYcvi8KrFeqYYlI7rIR1R16KakYK3+MAOFZavcReOmkRG1pRZh1CxiIPifZRjLTG1S5XI153nVwC6+MsqCM0lFSa7RnAwFaGIG30R7DkNsxUwpwEzwaJodw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685963; c=relaxed/simple;
	bh=dDou7vgWw9qd/wfAUQc/2M4gh3lUYRJS0404t1dl/e4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T1KJbJa6J/1oz54GYt0YZavUjBEwJPV7WxDzZHA3vJayPKeMqGbyeAD50BC7BJ8Zjp1PBFfucWz1EofSyq9qEihfQZEEVBUpSM/BguLwOUiQi8OHsTJ+GRP3MOFCg5yoNmQSFHhF4N1dT3XMAVfhKR1QfoQnkhCss9OhANBHFdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ni0qHQLR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ni0qHQLR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58720C4CEEA;
	Mon, 23 Jun 2025 13:39:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685963;
	bh=dDou7vgWw9qd/wfAUQc/2M4gh3lUYRJS0404t1dl/e4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ni0qHQLRbxpE6w202a124FpC4weRPGShap6mDD58ijbse9MQkITI84WnLoltiK5Ym
	 iAwA9pQ9YyNoGBhGRkdbtJ3irwTeSYjyWNORBOR+gETEkPBrOdCPONgfPLWuAe4/2h
	 Wb5gl2mzPPxBg+wXaK+xYxbf04T0B85anlNvzj/8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Rutland <mark.rutland@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 040/508] arm64/fpsimd: Fix merging of FPSIMD state during signal return
Date: Mon, 23 Jun 2025 15:01:25 +0200
Message-ID: <20250623130646.231328496@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

From: Mark Rutland <mark.rutland@arm.com>

[ Upstream commit c94f2f326146a34066a0070ed90b8bc656b1842f ]

For backwards compatibility reasons, when a signal return occurs which
restores SVE state, the effective lower 128 bits of each of the SVE
vector registers are restored from the corresponding FPSIMD vector
register in the FPSIMD signal frame, overriding the values in the SVE
signal frame. This is intended to be the case regardless of streaming
mode.

To make this happen, restore_sve_fpsimd_context() uses
fpsimd_update_current_state() to merge the lower 128 bits from the
FPSIMD signal frame into the SVE register state. Unfortunately,
fpsimd_update_current_state() performs this merging dependent upon
TIF_SVE, which is not always correct for streaming SVE register state:

* When restoring non-streaming SVE register state there is no observable
  problem, as the signal return code configures TIF_SVE and the saved
  fp_type to match before calling fpsimd_update_current_state(), which
  observes either:

  - TIF_SVE set    AND  fp_type == FP_STATE_SVE
  - TIF_SVE clear  AND  fp_type == FP_STATE_FPSIMD

* On systems which have SME but not SVE, TIF_SVE cannot be set. Thus the
  merging will never happen for the streaming SVE register state.

* On systems which have SVE and SME, TIF_SVE can be set and cleared
  independently of PSTATE.SM. Thus the merging may or may not happen for
  streaming SVE register state.

  As TIF_SVE can be cleared non-deterministically during syscalls
  (including at the start of sigreturn()), the merging may occur
  non-deterministically from the perspective of userspace.

This logic has been broken since its introduction in commit:

  85ed24dad2904f7c ("arm64/sme: Implement streaming SVE signal handling")

... at which point both fpsimd_signal_preserve_current_state() and
fpsimd_update_current_state() only checked TIF SVE. When PSTATE.SM==1
and TIF_SVE was clear, signal delivery would place stale FPSIMD state
into the FPSIMD signal frame, and signal return would not merge this
into the restored register state.

Subsequently, signal delivery was fixed as part of commit:

  61da7c8e2a602f66 ("arm64/signal: Don't assume that TIF_SVE means we saved SVE state")

... but signal restore was not given a corresponding fix, and when
TIF_SVE was clear, signal restore would still fail to merge the FPSIMD
state into the restored SVE register state. The 'Fixes' tag did not
indicate that this had been broken since its introduction.

Fix this by merging the FPSIMD state dependent upon the saved fp_type,
matching what we (currently) do during signal delivery.

As described above, when backporting this commit, it will also be
necessary to backport commit:

  61da7c8e2a602f66 ("arm64/signal: Don't assume that TIF_SVE means we saved SVE state")

... and prior to commit:

  baa8515281b30861 ("arm64/fpsimd: Track the saved FPSIMD state type separately to TIF_SVE")

... it will be necessary for fpsimd_signal_preserve_current_state() and
fpsimd_update_current_state() to consider both TIF_SVE and
thread_sm_enabled(&current->thread), in place of the saved fp_type.

Fixes: 85ed24dad290 ("arm64/sme: Implement streaming SVE signal handling")
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Will Deacon <will@kernel.org>
Reviewed-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20250409164010.3480271-10-mark.rutland@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/fpsimd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index 235131db8b8db..837d1937300a5 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -1783,7 +1783,7 @@ void fpsimd_update_current_state(struct user_fpsimd_state const *state)
 	get_cpu_fpsimd_context();
 
 	current->thread.uw.fpsimd_state = *state;
-	if (test_thread_flag(TIF_SVE))
+	if (current->thread.fp_type == FP_STATE_SVE)
 		fpsimd_to_sve(current);
 
 	task_fpsimd_load();
-- 
2.39.5



