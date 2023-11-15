Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58EC93DB8F
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f9vH9jpg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06FFFC433C8;
	Wed, 15 Nov 2023 19:56:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700078166;
	bh=uX33aBOP/cDesQsYZQnM2TU3m4R9wJH5U1kZV28wTcA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f9vH9jpgAL8UjdM4qbIFfo7XbTP8Dsh6ceIKlFTOcrPaZQ5JzbuiFOtacV6RM8ZMS
	 iJoqzcl9bhP7qZ3bj/4b2qC+abbSWXyRMzbBVP7bqpVj7IyespkCIPwWm3/pqNjsqX
	 JcQnQjvnFRBf6t5O4oBP6zyHtdOhcHS8OWKo868Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ross Burton <ross.burton@arm.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 152/379] clocksource/drivers/arm_arch_timer: limit XGene-1 workaround
Date: Wed, 15 Nov 2023 14:23:47 -0500
Message-ID: <20231115192654.102540933@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115192645.143643130@linuxfoundation.org>
References: <20231115192645.143643130@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andre Przywara <andre.przywara@arm.com>

[ Upstream commit 851354cbd12bb9500909733c3d4054306f61df87 ]

The AppliedMicro XGene-1 CPU has an erratum where the timer condition
would only consider TVAL, not CVAL. We currently apply a workaround when
seeing the PartNum field of MIDR_EL1 being 0x000, under the assumption
that this would match only the XGene-1 CPU model.
However even the Ampere eMAG (aka XGene-3) uses that same part number, and
only differs in the "Variant" and "Revision" fields: XGene-1's MIDR is
0x500f0000, our eMAG reports 0x503f0002. Experiments show the latter
doesn't show the faulty behaviour.

Increase the specificity of the check to only consider partnum 0x000 and
variant 0x00, to exclude the Ampere eMAG.

Fixes: 012f18850452 ("clocksource/drivers/arm_arch_timer: Work around broken CVAL implementations")
Reported-by: Ross Burton <ross.burton@arm.com>
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Acked-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
Link: https://lore.kernel.org/r/20231016153127.116101-1-andre.przywara@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/cputype.h     | 3 ++-
 arch/arm64/kvm/guest.c               | 2 +-
 drivers/clocksource/arm_arch_timer.c | 5 +++--
 3 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/cputype.h b/arch/arm64/include/asm/cputype.h
index 357932938b5ab..7dce9c0aa7836 100644
--- a/arch/arm64/include/asm/cputype.h
+++ b/arch/arm64/include/asm/cputype.h
@@ -85,7 +85,8 @@
 #define ARM_CPU_PART_NEOVERSE_N2	0xD49
 #define ARM_CPU_PART_CORTEX_A78C	0xD4B
 
-#define APM_CPU_PART_POTENZA		0x000
+#define APM_CPU_PART_XGENE		0x000
+#define APM_CPU_VAR_POTENZA		0x00
 
 #define CAVIUM_CPU_PART_THUNDERX	0x0A1
 #define CAVIUM_CPU_PART_THUNDERX_81XX	0x0A2
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index dd20b8688d230..f44ae09a51956 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -863,7 +863,7 @@ u32 __attribute_const__ kvm_target_cpu(void)
 		break;
 	case ARM_CPU_IMP_APM:
 		switch (part_number) {
-		case APM_CPU_PART_POTENZA:
+		case APM_CPU_PART_XGENE:
 			return KVM_ARM_TARGET_XGENE_POTENZA;
 		}
 		break;
diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
index 239c70ac120e8..fee1c4bf10214 100644
--- a/drivers/clocksource/arm_arch_timer.c
+++ b/drivers/clocksource/arm_arch_timer.c
@@ -817,8 +817,9 @@ static u64 __arch_timer_check_delta(void)
 		 * Note that TVAL is signed, thus has only 31 of its
 		 * 32 bits to express magnitude.
 		 */
-		MIDR_ALL_VERSIONS(MIDR_CPU_MODEL(ARM_CPU_IMP_APM,
-						 APM_CPU_PART_POTENZA)),
+		MIDR_REV_RANGE(MIDR_CPU_MODEL(ARM_CPU_IMP_APM,
+					      APM_CPU_PART_XGENE),
+			       APM_CPU_VAR_POTENZA, 0x0, 0xf),
 		{},
 	};
 
-- 
2.42.0



