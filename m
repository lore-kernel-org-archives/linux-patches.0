Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4B8D1E89C;
	Tue, 27 May 2025 17:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366407; cv=none; b=PBIywn3XTp/T9wBoumZNN/9C1wwn2DyuE9FC+AM1OnXtc8IfSPGnf57N/NwNVjRD+AyGTd2Qcg1TZBv51bDkT8qekF56b8okcmKD5tNvidxEvk7AXCqq8MEtb0PFt2tTO9vdGc8ddC4YnWf6yQBtRAFvmPnVCbTtuSIfjR9/S8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366407; c=relaxed/simple;
	bh=ruYm19ZJteDxRhqhKvUfAiCUYMQqNWq3jaqWiZ94/bw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t9/9i9ScRbULF2BcoYKOC1g6tyeKz1hQuYL9EPSM8OjcgmXL6cK6+p/0G6xUpfkflXIcqCF+czGRTQ/ng+E/XYdXpTMHveoSx1JQ+YMOZIZPPnYML2XahLuIL64WjUM+40nLS6+2skkOPK9/JG/8qlnbXvkHsiFcIchcQQ4OXNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lJ+uQ9fZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lJ+uQ9fZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1A2CC4CEE9;
	Tue, 27 May 2025 17:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366407;
	bh=ruYm19ZJteDxRhqhKvUfAiCUYMQqNWq3jaqWiZ94/bw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lJ+uQ9fZbr2RXc2ZqhuZ35ZnaicYan5BNn01cVdk4beu0Rcrugk/ml/+eR49iVxhs
	 wqzRe5ZXQB5kXr+LYZRev9/STfFPVOEK0aiLGVdnX2lhyzvYQbVRca3iXJzFrV4iOX
	 rc15l2KnvGJHmxjsXbGXT2qNYyA8oIsBhehkT2k0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinqian Yang <yangjinqian1@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 058/783] arm64: Add support for HIP09 Spectre-BHB mitigation
Date: Tue, 27 May 2025 18:17:35 +0200
Message-ID: <20250527162515.491110984@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jinqian Yang <yangjinqian1@huawei.com>

[ Upstream commit e18c09b204e81702ea63b9f1a81ab003b72e3174 ]

The HIP09 processor is vulnerable to the Spectre-BHB (Branch History
Buffer) attack, which can be exploited to leak information through
branch prediction side channels. This commit adds the MIDR of HIP09
to the list for software mitigation.

Signed-off-by: Jinqian Yang <yangjinqian1@huawei.com>
Link: https://lore.kernel.org/r/20250325141900.2057314-1-yangjinqian1@huawei.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/cputype.h | 2 ++
 arch/arm64/kernel/proton-pack.c  | 1 +
 2 files changed, 3 insertions(+)

diff --git a/arch/arm64/include/asm/cputype.h b/arch/arm64/include/asm/cputype.h
index 8c6bd9da3b1ba..3381fdc081ad2 100644
--- a/arch/arm64/include/asm/cputype.h
+++ b/arch/arm64/include/asm/cputype.h
@@ -133,6 +133,7 @@
 #define FUJITSU_CPU_PART_A64FX		0x001
 
 #define HISI_CPU_PART_TSV110		0xD01
+#define HISI_CPU_PART_HIP09			0xD02
 
 #define APPLE_CPU_PART_M1_ICESTORM	0x022
 #define APPLE_CPU_PART_M1_FIRESTORM	0x023
@@ -210,6 +211,7 @@
 #define MIDR_NVIDIA_CARMEL MIDR_CPU_MODEL(ARM_CPU_IMP_NVIDIA, NVIDIA_CPU_PART_CARMEL)
 #define MIDR_FUJITSU_A64FX MIDR_CPU_MODEL(ARM_CPU_IMP_FUJITSU, FUJITSU_CPU_PART_A64FX)
 #define MIDR_HISI_TSV110 MIDR_CPU_MODEL(ARM_CPU_IMP_HISI, HISI_CPU_PART_TSV110)
+#define MIDR_HISI_HIP09 MIDR_CPU_MODEL(ARM_CPU_IMP_HISI, HISI_CPU_PART_HIP09)
 #define MIDR_APPLE_M1_ICESTORM MIDR_CPU_MODEL(ARM_CPU_IMP_APPLE, APPLE_CPU_PART_M1_ICESTORM)
 #define MIDR_APPLE_M1_FIRESTORM MIDR_CPU_MODEL(ARM_CPU_IMP_APPLE, APPLE_CPU_PART_M1_FIRESTORM)
 #define MIDR_APPLE_M1_ICESTORM_PRO MIDR_CPU_MODEL(ARM_CPU_IMP_APPLE, APPLE_CPU_PART_M1_ICESTORM_PRO)
diff --git a/arch/arm64/kernel/proton-pack.c b/arch/arm64/kernel/proton-pack.c
index 8ef3335ecff72..31eaf15d2079a 100644
--- a/arch/arm64/kernel/proton-pack.c
+++ b/arch/arm64/kernel/proton-pack.c
@@ -904,6 +904,7 @@ static u8 spectre_bhb_loop_affected(void)
 		MIDR_ALL_VERSIONS(MIDR_CORTEX_A77),
 		MIDR_ALL_VERSIONS(MIDR_NEOVERSE_N1),
 		MIDR_ALL_VERSIONS(MIDR_QCOM_KRYO_4XX_GOLD),
+		MIDR_ALL_VERSIONS(MIDR_HISI_HIP09),
 		{},
 	};
 	static const struct midr_range spectre_bhb_k11_list[] = {
-- 
2.39.5



