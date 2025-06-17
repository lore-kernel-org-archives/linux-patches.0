Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D0A82ECD0B;
	Tue, 17 Jun 2025 15:52:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175572; cv=none; b=GNvc8BUrFkWHIDXSBlKJ911auwObPxgEpAjdO4uN7ro6FWsqjV10tsy0lT+rnwzgewdmU2RQS+9ZcTNk1KaEOGL4Etcfl8sKfVeCS3jbm3383zW/SL/OSYNaf50eIEJPDNBceBCO5CCWNRsG8kgJJNiWOMWHqQRNHbWoJX27RdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175572; c=relaxed/simple;
	bh=sV5IniQBymQc/e0TU0XoxGMPBUTm208gNcMjzdgvHuA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MGaZkh90iHsU+BbHvwTbWvPbvdZypY9JbCOu4sPTNhCZXXGD5wuOlCUtfHb/O6ZZIvnH89dNzTrTuQInlfmDfJ6eVgS2g2c+d+hwX5smDkCpNuZRfbBLDB9ylPY21EH5uJ7eJ+Txbr4y7OsvXpHL796SP3PUt+Y7hi0s/ahVkw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=14sp0I78; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="14sp0I78"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60E64C4CEE7;
	Tue, 17 Jun 2025 15:52:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175571;
	bh=sV5IniQBymQc/e0TU0XoxGMPBUTm208gNcMjzdgvHuA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=14sp0I78+vU5NXQ8oFb+JSH79FSi0NzOR+hrM6HnQHqVNeM4r1q7N9RK2hTvFcPwz
	 5ibOKp259DW2YXrpS1eGMSB/vMndoBbyCR5EFdq3GIRXkR7GKyKh+FI5eScTX7Ywqo
	 OmsqjMkccghpQqVge4yICs+7tLXV8wP2JnpHQhuY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Brown <broonie@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 102/780] arm64/fpsimd: Dont corrupt FPMR when streaming mode changes
Date: Tue, 17 Jun 2025 17:16:50 +0200
Message-ID: <20250617152455.664147907@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Brown <broonie@kernel.org>

[ Upstream commit e5fa85fce08b21ed41643cb7968bf66bbd0532e3 ]

When the effective value of PSTATE.SM is changed from 0 to 1 or from 1
to 0 by any method, an entry or exit to/from streaming SVE mode is
performed, and hardware automatically resets a number of registers. As
of ARM DDI 0487 L.a, this means:

* All implemented bits of the SVE vector registers are set to zero.

* All implemented bits of the SVE predicate registers are set to zero.

* All implemented bits of FFR are set to zero, if FFR is implemented in
  the new mode.

* FPSR is set to 0x0000_0000_0800_009f.

* FPMR is set to 0, if FPMR is implemented.

Currently task_fpsimd_load() restores FPMR before restoring SVCR (which
is an accessor for PSTATE.{SM,ZA}), and so the restored value of FPMR
may be clobbered if the restored value of PSTATE.SM happens to differ
from the initial value of PSTATE.SM.

Fix this by moving the restore of FPMR later.

Note: this was originally posted as [1].

Fixes: 203f2b95a882 ("arm64/fpsimd: Support FEAT_FPMR")
Signed-off-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/linux-arm-kernel/20241204-arm64-sme-reenable-v2-2-bae87728251d@kernel.org/
[ Rutland: rewrite commit message ]
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Link: https://lore.kernel.org/r/20250409164010.3480271-7-mark.rutland@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/fpsimd.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index c92c0a08370b2..9466b3c5021ac 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -359,9 +359,6 @@ static void task_fpsimd_load(void)
 	WARN_ON(preemptible());
 	WARN_ON(test_thread_flag(TIF_KERNEL_FPSTATE));
 
-	if (system_supports_fpmr())
-		write_sysreg_s(current->thread.uw.fpmr, SYS_FPMR);
-
 	if (system_supports_sve() || system_supports_sme()) {
 		switch (current->thread.fp_type) {
 		case FP_STATE_FPSIMD:
@@ -413,6 +410,9 @@ static void task_fpsimd_load(void)
 			restore_ffr = system_supports_fa64();
 	}
 
+	if (system_supports_fpmr())
+		write_sysreg_s(current->thread.uw.fpmr, SYS_FPMR);
+
 	if (restore_sve_regs) {
 		WARN_ON_ONCE(current->thread.fp_type != FP_STATE_SVE);
 		sve_load_state(sve_pffr(&current->thread),
-- 
2.39.5



