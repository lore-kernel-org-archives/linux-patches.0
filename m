Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 437724FC35A;
	Thu, 17 Sep 2026 17:24:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665885; cv=none; b=cBQgbCncABhj9R9eJW9k1LjffB+54FB0LOTuorlJIXvn4hRWIJRebbk+g4Z65yDgebdLr/h010ldqOTy702LpqX+krtF+HE5dH4ZHwKq6vVA7N37szkUOSBIjB60YMDJjEZ35ojWaW3IPH6ZxVJjqxFIHwnff9GZm8lfMSKhVtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665885; c=relaxed/simple;
	bh=6ODhZ/iqmYtRXN89tJQl9aDoGPFCAYBST88xlCScrxE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LEY7EIP1Bbr14wFuVK2dY7EwdZmDBqAmaet2lnO/duqSZ8KrEgHrwIOPcGrbnKOwIJjey6EnMHyWLjMPpCh8s86FH36Lq+GA66c+qdufRATkhpPO1/HfB1TbenUmbDxtYQFCwR2NUMruEmKeP4kkRCDoH6ckjQFkHRInj6NQKjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rBMOs1tz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rBMOs1tz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D5991F000FF;
	Thu, 17 Sep 2026 17:24:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665884;
	bh=13RT4QWeqhD03zsYW73jw3atFtF73OX5gEvxtfTWB8w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rBMOs1tzdRAkNsge2HeTAfR8ElUBj586A3xg0GOxiOE87KXakzfixGG6sy85fSjEe
	 euo6pLRAZpnA2OTahfMgCMzBCKL//m05gXy9CryKhg5exbDEgLUMXa7arxz9dI2zBc
	 Ql80siMo91eOBJNRnWkKhLwsxHW6vg3xyAucpeGI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sascha Bischoff <sascha.bischoff@arm.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0851/1250] irqchip/gic-v5: Preserve ICC_CR0_EL1 state
Date: Thu, 17 Sep 2026 16:10:46 +0100
Message-ID: <20260917151615.030072423@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sascha Bischoff <Sascha.Bischoff@arm.com>

[ Upstream commit 1017911fcc03584b6854b1b8f0aafeb25f5a8d25 ]

In addition to EN, ICC_CR0_EL1 contains other fields, such as LINK and
LINK_IDLE. The driver only needs to modify EN, and must preserve the
values of all other fields when enabling or disabling the CPU
interface.

Define the missing LINK and LINK_IDLE fields, and use read-modify-write
accesses to update EN without affecting the rest of ICC_CR0_EL1.

Fixes: 7ec80fb3f025 ("irqchip/gic-v5: Add GICv5 PPI support")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Reviewed-by: Marc Zyngier <maz@kernel.org>
Link: https://patch.msgid.link/20260907164945.714545-1-sascha.bischoff@arm.com
Closes: https://lore.kernel.org/r/20260807121703.D4B7A1F00A3A@smtp.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/tools/sysreg      | 4 +++-
 drivers/irqchip/irq-gic-v5.c | 6 ++++--
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index de46df0e3b115..02f16cba0cf1a 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -3672,7 +3672,9 @@ Sysreg	ICC_CR0_EL1	3	1	12	0	1
 Res0	63:39
 Field	38	PID
 Field	37:32	IPPT
-Res0	31:1
+Res0	31:3
+Field	2	LINK_IDLE
+Field	1	LINK
 Field	0	EN
 EndSysreg
 
diff --git a/drivers/irqchip/irq-gic-v5.c b/drivers/irqchip/irq-gic-v5.c
index 222ef50acf100..707c5423e97d0 100644
--- a/drivers/irqchip/irq-gic-v5.c
+++ b/drivers/irqchip/irq-gic-v5.c
@@ -929,7 +929,8 @@ static void gicv5_cpu_disable_interrupts(void)
 {
 	u64 cr0;
 
-	cr0 = FIELD_PREP(ICC_CR0_EL1_EN, 0);
+	cr0 = read_sysreg_s(SYS_ICC_CR0_EL1);
+	cr0 &= ~ICC_CR0_EL1_EN_MASK;
 	write_sysreg_s(cr0, SYS_ICC_CR0_EL1);
 	isb();
 }
@@ -946,7 +947,8 @@ static void gicv5_cpu_enable_interrupts(void)
 	pcr = FIELD_PREP(ICC_PCR_EL1_PRIORITY, GICV5_IRQ_PRI_MI);
 	write_sysreg_s(pcr, SYS_ICC_PCR_EL1);
 
-	cr0 = FIELD_PREP(ICC_CR0_EL1_EN, 1);
+	cr0 = read_sysreg_s(SYS_ICC_CR0_EL1);
+	cr0 |= ICC_CR0_EL1_EN_MASK;
 	write_sysreg_s(cr0, SYS_ICC_CR0_EL1);
 }
 
-- 
2.53.0



