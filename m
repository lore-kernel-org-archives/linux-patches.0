Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 384DF54BD4;
	Tue, 27 Feb 2024 13:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042333; cv=none; b=s6iVER9RScTuv7KR+soK7KY+5B7P3y04R6nMnXkvXS7gz2IZDsamqmcbW2y1Zo6C/s8WWdToCBel0dyzmHm1GLr07sLn8tb32gGyVGqd1/1JHrXjjr6E2w+yD7B3qHxCpgOI6HFFBgg0sqoRa5KHJVBpp3XRCPvENAW0FwAiz5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042333; c=relaxed/simple;
	bh=BQAH0EiRmA3GLb7g50mN9PKiZrustxHpP1fJh3OqRfM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eAmPi3hS7wgldW4djnIzXRLNMRhfkq1zHQQ0lpXRDigMhxaumNmH99GAhT4i/QixrMgQV1zHbYWWd0yKBbrf4+kt4/PphKf9vzP42hz6z7sN0hd+YNMPDq3U0xJkBXydp5HtelXCNSYzFy9QzcNnuPEmszKeFyx+PhQh0Eaq618=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T7TDndRc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T7TDndRc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBEC6C433C7;
	Tue, 27 Feb 2024 13:58:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042333;
	bh=BQAH0EiRmA3GLb7g50mN9PKiZrustxHpP1fJh3OqRfM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T7TDndRcrLLtA5MgQjWDZgu3os3EeXU/c9ZYUq53bF+HSuU8HoTH9iKaGWgyE+Pml
	 VsFslJ5dA6BOqq6ijR9AMhTstfYySTx0mx8iy1ONcqsDciGWMafR2w7CJhZ0p8ME1c
	 F6kjhVHWsM2+eR15ec9D6A8A7QxRsDWuDSd2HjrI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jackson Cooper-Driver <Jackson.Cooper-Driver@arm.com>,
	Mark Brown <broonie@kernel.org>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 258/299] arm64/sme: Restore SME registers on exit from suspend
Date: Tue, 27 Feb 2024 14:26:09 +0100
Message-ID: <20240227131634.010823713@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
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

From: Mark Brown <broonie@kernel.org>

[ Upstream commit 9533864816fb4a6207c63b7a98396351ce1a9fae ]

The fields in SMCR_EL1 and SMPRI_EL1 reset to an architecturally UNKNOWN
value. Since we do not otherwise manage the traps configured in this
register at runtime we need to reconfigure them after a suspend in case
nothing else was kind enough to preserve them for us.

The vector length will be restored as part of restoring the SME state for
the next SME using task.

Fixes: a1f4ccd25cc2 ("arm64/sme: Provide Kconfig for SME")
Reported-by: Jackson Cooper-Driver <Jackson.Cooper-Driver@arm.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20240213-arm64-sme-resume-v3-1-17e05e493471@kernel.org
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/fpsimd.h |  2 ++
 arch/arm64/kernel/fpsimd.c      | 14 ++++++++++++++
 arch/arm64/kernel/suspend.c     |  3 +++
 3 files changed, 19 insertions(+)

diff --git a/arch/arm64/include/asm/fpsimd.h b/arch/arm64/include/asm/fpsimd.h
index 8df46f186c64b..b54506d707380 100644
--- a/arch/arm64/include/asm/fpsimd.h
+++ b/arch/arm64/include/asm/fpsimd.h
@@ -360,6 +360,7 @@ extern void sme_alloc(struct task_struct *task, bool flush);
 extern unsigned int sme_get_vl(void);
 extern int sme_set_current_vl(unsigned long arg);
 extern int sme_get_current_vl(void);
+extern void sme_suspend_exit(void);
 
 /*
  * Return how many bytes of memory are required to store the full SME
@@ -395,6 +396,7 @@ static inline int sme_max_vl(void) { return 0; }
 static inline int sme_max_virtualisable_vl(void) { return 0; }
 static inline int sme_set_current_vl(unsigned long arg) { return -EINVAL; }
 static inline int sme_get_current_vl(void) { return -EINVAL; }
+static inline void sme_suspend_exit(void) { }
 
 static inline size_t sme_state_size(struct task_struct const *task)
 {
diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index 1e1e0511c0081..ce0bc01b4208d 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -1406,6 +1406,20 @@ void __init sme_setup(void)
 		get_sme_default_vl());
 }
 
+void sme_suspend_exit(void)
+{
+	u64 smcr = 0;
+
+	if (!system_supports_sme())
+		return;
+
+	if (system_supports_fa64())
+		smcr |= SMCR_ELx_FA64;
+
+	write_sysreg_s(smcr, SYS_SMCR_EL1);
+	write_sysreg_s(0, SYS_SMPRI_EL1);
+}
+
 #endif /* CONFIG_ARM64_SME */
 
 static void sve_init_regs(void)
diff --git a/arch/arm64/kernel/suspend.c b/arch/arm64/kernel/suspend.c
index 0fbdf5fe64d8d..045af2bfd656a 100644
--- a/arch/arm64/kernel/suspend.c
+++ b/arch/arm64/kernel/suspend.c
@@ -12,6 +12,7 @@
 #include <asm/daifflags.h>
 #include <asm/debug-monitors.h>
 #include <asm/exec.h>
+#include <asm/fpsimd.h>
 #include <asm/mte.h>
 #include <asm/memory.h>
 #include <asm/mmu_context.h>
@@ -80,6 +81,8 @@ void notrace __cpu_suspend_exit(void)
 	 */
 	spectre_v4_enable_mitigation(NULL);
 
+	sme_suspend_exit();
+
 	/* Restore additional feature-specific configuration */
 	ptrauth_suspend_exit();
 }
-- 
2.43.0



