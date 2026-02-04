Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28E5F2D97BB;
	Wed,  4 Feb 2026 15:23:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218588; cv=none; b=MopXKNJVXzrb1BpdVx3j1mALDpwspOw72jbzZ54cgsB63jK42I3iSJ9MVKEds3860qswYl9zXi9rFDQ5K5bx0fjHef7+Y+3EBiI4KTN/wwNDeaf1XwsONSYSUFdrC/EazezH4+XDh4iKdB/eVch3CCqVI5rLCxAuuK08cV/+o/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218588; c=relaxed/simple;
	bh=uAoLLUki/dgPHiCMqW2UzFuyKwB8jNwoEJMHBJrLXKk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hEgKnJlawSpJNg1JmhEZcXPfFecS33dhc0mH9yaOXTZxZ1ljg9zBHJZO/WRWz40Jlcvwv2KYehEiYNPO6HTDt9Y/tfPduV8yXb9p4XHqij+S6UXWwk3oaSvGGgqjz3h9ikqX4AllAYiOeFz1n7AAFXv3jDpKEF32ZhTAOyLurQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sfqQKOsN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sfqQKOsN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F446C4CEF7;
	Wed,  4 Feb 2026 15:23:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218588;
	bh=uAoLLUki/dgPHiCMqW2UzFuyKwB8jNwoEJMHBJrLXKk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sfqQKOsNt52usHDUXRSd5TgbKfHEq4ILP1hn5JuQ9Weg+Z+w1hj3Yr05towRhbUD/
	 PyfZtqYSWMIw5o1zROf0ltyqw7DU3S1K6AiHsn2jzqeOYVx7OjRn7rEpkEhuzyKUez
	 dg3atebQkESxXX7165zweeu4Qdz+np+GZBtbhFmk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Rutland <mark.rutland@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 44/72] arm64/fpsimd: signal: Mandate SVE payload for streaming-mode state
Date: Wed,  4 Feb 2026 15:40:47 +0100
Message-ID: <20260204143847.224605489@linuxfoundation.org>
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

[ Upstream commit b465ace42620970e840c7aeb2c44a6e3b1002fec ]

Non-streaming SVE state may be preserved without an SVE payload, in
which case the SVE context only has a header with VL==0, and all state
can be restored from the FPSIMD context. Streaming SVE state is always
preserved with an SVE payload, where the SVE context header has VL!=0,
and the SVE_SIG_FLAG_SM flag is set.

The kernel never preserves an SVE context where SVE_SIG_FLAG_SM is set
without an SVE payload. However, restore_sve_fpsimd_context() doesn't
forbid restoring such a context, and will handle this case by clearing
PSTATE.SM and restoring the FPSIMD context into non-streaming mode,
which isn't consistent with the SVE_SIG_FLAG_SM flag.

Forbid this case, and mandate an SVE payload when the SVE_SIG_FLAG_SM
flag is set. This avoids an awkward ABI quirk and reduces the risk that
later rework to this code permits configuring a task with PSTATE.SM==1
and fp_type==FP_STATE_FPSIMD.

I've marked this as a fix given that we never intended to support this
case, and we don't want anyone to start relying upon the old behaviour
once we re-enable SME.

Fixes: 85ed24dad290 ("arm64/sme: Implement streaming SVE signal handling")
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Will Deacon <will@kernel.org>
Reviewed-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20250508132644.1395904-4-mark.rutland@arm.com
Signed-off-by: Will Deacon <will@kernel.org>
Stable-dep-of: d2907cbe9ea0 ("arm64/fpsimd: signal: Fix restoration of SVE context")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/signal.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

--- a/arch/arm64/kernel/signal.c
+++ b/arch/arm64/kernel/signal.c
@@ -276,6 +276,7 @@ static int restore_sve_fpsimd_context(st
 	unsigned int vl, vq;
 	struct user_fpsimd_state fpsimd;
 	u16 user_vl, flags;
+	bool sm;
 
 	if (user->sve_size < sizeof(*user->sve))
 		return -EINVAL;
@@ -285,7 +286,8 @@ static int restore_sve_fpsimd_context(st
 	if (err)
 		return err;
 
-	if (flags & SVE_SIG_FLAG_SM) {
+	sm = flags & SVE_SIG_FLAG_SM;
+	if (sm) {
 		if (!system_supports_sme())
 			return -EINVAL;
 
@@ -305,7 +307,16 @@ static int restore_sve_fpsimd_context(st
 	if (user_vl != vl)
 		return -EINVAL;
 
-	if (user->sve_size == sizeof(*user->sve)) {
+	/*
+	 * Non-streaming SVE state may be preserved without an SVE payload, in
+	 * which case the SVE context only has a header with VL==0, and all
+	 * state can be restored from the FPSIMD context.
+	 *
+	 * Streaming SVE state is always preserved with an SVE payload. For
+	 * consistency and robustness, reject restoring streaming SVE state
+	 * without an SVE payload.
+	 */
+	if (!sm && user->sve_size == sizeof(*user->sve)) {
 		clear_thread_flag(TIF_SVE);
 		current->thread.svcr &= ~SVCR_SM_MASK;
 		current->thread.fp_type = FP_STATE_FPSIMD;


