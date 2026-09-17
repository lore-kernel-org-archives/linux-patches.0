Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 384B74DDB5D;
	Thu, 17 Sep 2026 15:41:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659692; cv=none; b=hSBldl3g11jbmqSNfWb4EN7E/6TZIcsUcbzpA8RiDsWnQtPYuAr318mstJ8PapR70qSvq4hniv3cty7MEmTKg7nj7l51+3c+VXNTQeR3cTYM8hGaWIh8+t+FTnFFkFPQnejoi0bj8PshnXhbOta2cSjYQTufYRl0t6x+XNttJJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659692; c=relaxed/simple;
	bh=IRJfpe7tQK0YHSFau7OMykcspDLp398UyoXu5DKh1oI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L1yodQmHp1a1y60gb412uhfflKIasz4RNhlgoqSH3bnpQsA/RxAVVRmzL5r8ZcUQ0NTBilQZza8pMhDeW7hJSs5VclAh2/HqLpDjk2ilODJ5W6W27jiwducpBfojqBR+kgSEgxcmnSZ3eVCCJVhPEDYUudsPvdjMNl8hTq3+4Zw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rsH6d03a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rsH6d03a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E8831F000FF;
	Thu, 17 Sep 2026 15:41:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659685;
	bh=cOm9weGMZCSG5pJLjw7/D5Dy7vEUw8jI5F7JKyUQooQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rsH6d03ao7Hk5aCVFKtpywkkb/HBZu/NZVi69TXT4ZlXDWeSclr40HJz8TkZ/f/mt
	 Zn9p59MvjY1T2bEFXExdBFzq410Z+vK6E8eUco7E3rdm6u98xtv3BTZTA7PTvh/8yr
	 sK6LYTs3RYHoo3vCUCpmBn6xcjGbASOHQVBJjSdU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sascha Bischoff <sascha.bischoff@arm.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 340/733] irqchip/gic-v5: Preserve ICC_CR0_EL1 state
Date: Thu, 17 Sep 2026 16:10:48 +0100
Message-ID: <20260917151400.016754173@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 7cb61aca3797f..03f5e1755a633 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -3736,7 +3736,9 @@ Sysreg	ICC_CR0_EL1	3	1	12	0	1
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
index d6f1c0c8b7473..21c34e7587323 100644
--- a/drivers/irqchip/irq-gic-v5.c
+++ b/drivers/irqchip/irq-gic-v5.c
@@ -974,7 +974,8 @@ static void gicv5_cpu_disable_interrupts(void)
 {
 	u64 cr0;
 
-	cr0 = FIELD_PREP(ICC_CR0_EL1_EN, 0);
+	cr0 = read_sysreg_s(SYS_ICC_CR0_EL1);
+	cr0 &= ~ICC_CR0_EL1_EN_MASK;
 	write_sysreg_s(cr0, SYS_ICC_CR0_EL1);
 	isb();
 }
@@ -991,7 +992,8 @@ static void gicv5_cpu_enable_interrupts(void)
 	pcr = FIELD_PREP(ICC_PCR_EL1_PRIORITY, GICV5_IRQ_PRI_MI);
 	write_sysreg_s(pcr, SYS_ICC_PCR_EL1);
 
-	cr0 = FIELD_PREP(ICC_CR0_EL1_EN, 1);
+	cr0 = read_sysreg_s(SYS_ICC_CR0_EL1);
+	cr0 |= ICC_CR0_EL1_EN_MASK;
 	write_sysreg_s(cr0, SYS_ICC_CR0_EL1);
 }
 
-- 
2.53.0



