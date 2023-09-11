Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E874711715
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 15:06:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EB6DC433C8;
	Mon, 11 Sep 2023 15:06:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694444802;
	bh=9pP3mGhXVRXjg7VX7ypppd7P70ZFS6op7fOktIAZKvM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=duUHhnABYfgQVWCZEYsloqmvKU0pL6FRZS3lwyhGL4LvQ+6czc2AHg8mCMhuwpYNR
	 2eeAe/C3C3KfxA81eba11ASbcP0/XIg7YcxekQofE2aj4jDPJ1kcZKQASfjbldyZNR
	 KoMFJ/ETRJv3S8gomroUpg+mV7QqNYabyQJxw3fc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Brown <broonie@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 120/600] arm64/fpsimd: Only provide the length to cpufeature for xCR registers
Date: Mon, 11 Sep 2023 15:42:33 +0200
Message-ID: <20230911134637.156474801@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134633.619970489@linuxfoundation.org>
References: <20230911134633.619970489@linuxfoundation.org>
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

From: Mark Brown <broonie@kernel.org>

[ Upstream commit 01948b09edc3fecf8486c57c2d2fb8b80886f3d0 ]

For both SVE and SME we abuse the generic register field comparison
support in the cpufeature code as part of our detection of unsupported
variations in the vector lengths available to PEs, reporting the maximum
vector lengths via ZCR_EL1.LEN and SMCR_EL1.LEN.  Since these are
configuration registers rather than identification registers the
assumptions the cpufeature code makes about how unknown bitfields behave
are invalid, leading to warnings when SME features like FA64 are enabled
and we hotplug a CPU:

  CPU features: SANITY CHECK: Unexpected variation in SYS_SMCR_EL1. Boot CPU: 0x0000000000000f, CPU3: 0x0000008000000f
  CPU features: Unsupported CPU feature variation detected.

SVE has no controls other than the vector length so is not yet impacted
but the same issue will apply there if any are defined.

Since the only field we are interested in having the cpufeature code
handle is the length field and we use a custom read function to obtain
the value we can avoid these warnings by filtering out all other bits
when we return the register value, if we're doing that we don't need to
bother reading the register at all and can simply use the RDVL/RDSVL
value we were filling in instead.

Fixes: 2e0f2478ea37 ("arm64/sve: Probe SVE capabilities and usable vector lengths")
FixeS: b42990d3bf77 ("arm64/sme: Identify supported SME vector lengths at boot")
Signed-off-by: Mark Brown <broonie@kernel.org>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Link: https://lore.kernel.org/r/20230731-arm64-sme-fa64-hotplug-v2-1-7714c00dd902@kernel.org
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/fpsimd.c | 22 ++++------------------
 1 file changed, 4 insertions(+), 18 deletions(-)

diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index 4aa579ff3125d..8c226d79abdfc 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -1133,9 +1133,6 @@ void sve_kernel_enable(const struct arm64_cpu_capabilities *__always_unused p)
  */
 u64 read_zcr_features(void)
 {
-	u64 zcr;
-	unsigned int vq_max;
-
 	/*
 	 * Set the maximum possible VL, and write zeroes to all other
 	 * bits to see if they stick.
@@ -1143,12 +1140,8 @@ u64 read_zcr_features(void)
 	sve_kernel_enable(NULL);
 	write_sysreg_s(ZCR_ELx_LEN_MASK, SYS_ZCR_EL1);
 
-	zcr = read_sysreg_s(SYS_ZCR_EL1);
-	zcr &= ~(u64)ZCR_ELx_LEN_MASK; /* find sticky 1s outside LEN field */
-	vq_max = sve_vq_from_vl(sve_get_vl());
-	zcr |= vq_max - 1; /* set LEN field to maximum effective value */
-
-	return zcr;
+	/* Return LEN value that would be written to get the maximum VL */
+	return sve_vq_from_vl(sve_get_vl()) - 1;
 }
 
 void __init sve_setup(void)
@@ -1292,9 +1285,6 @@ void fa64_kernel_enable(const struct arm64_cpu_capabilities *__always_unused p)
  */
 u64 read_smcr_features(void)
 {
-	u64 smcr;
-	unsigned int vq_max;
-
 	sme_kernel_enable(NULL);
 
 	/*
@@ -1303,12 +1293,8 @@ u64 read_smcr_features(void)
 	write_sysreg_s(read_sysreg_s(SYS_SMCR_EL1) | SMCR_ELx_LEN_MASK,
 		       SYS_SMCR_EL1);
 
-	smcr = read_sysreg_s(SYS_SMCR_EL1);
-	smcr &= ~(u64)SMCR_ELx_LEN_MASK; /* Only the LEN field */
-	vq_max = sve_vq_from_vl(sme_get_vl());
-	smcr |= vq_max - 1; /* set LEN field to maximum effective value */
-
-	return smcr;
+	/* Return LEN value that would be written to get the maximum VL */
+	return sve_vq_from_vl(sme_get_vl()) - 1;
 }
 
 void __init sme_setup(void)
-- 
2.40.1



