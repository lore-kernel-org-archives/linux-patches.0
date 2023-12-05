Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E8046FB1;
	Tue,  5 Dec 2023 03:27:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l3Qp3MGc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7EE5C433C8;
	Tue,  5 Dec 2023 03:27:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701746827;
	bh=EGoNz0dKKtitVKc9t+Jr7HV3iPyaAMgNKsHPWpiqpTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l3Qp3MGccv4GuIYCTx6gH7lLyiRkQXJuOEKxemKIiiWEkW5b8mAAXNa+sIrZ7K317
	 tg8elSEAjbglj56LVJGcuXxAzk3+F55qfjbEoBoU8ANZ6qeYlK2kHWEADwOxu1R9xg
	 WYuDQv8ns9/AePwPZIHcTEENCHVg4PDBUkjbfkj0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Murray <andrew.murray@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Will Deacon <will@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 4.19 17/71] KVM: arm64: limit PMU version to PMUv3 for ARMv8.1
Date: Tue,  5 Dec 2023 12:16:15 +0900
Message-ID: <20231205031518.837972807@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031517.859409664@linuxfoundation.org>
References: <20231205031517.859409664@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Murray <andrew.murray@arm.com>

commit c854188ea01062f5a5fd7f05658feb1863774eaa upstream.

We currently expose the PMU version of the host to the guest via
emulation of the DFR0_EL1 and AA64DFR0_EL1 debug feature registers.
However many of the features offered beyond PMUv3 for 8.1 are not
supported in KVM. Examples of this include support for the PMMIR
registers (added in PMUv3 for ARMv8.4) and 64-bit event counters
added in (PMUv3 for ARMv8.5).

Let's trap the Debug Feature Registers in order to limit
PMUVer/PerfMon in the Debug Feature Registers to PMUv3 for ARMv8.1
to avoid unexpected behaviour.

Both ID_AA64DFR0.PMUVer and ID_DFR0.PerfMon follow the "Alternative ID
scheme used for the Performance Monitors Extension version" where 0xF
means an IMPLEMENTATION DEFINED PMU is implemented, and values 0x0-0xE
are treated as with an unsigned field (with 0x0 meaning no PMU is
present). As we don't expect to expose an IMPLEMENTATION DEFINED PMU,
and our cap is below 0xF, we can treat these fields as unsigned when
applying the cap.

Signed-off-by: Andrew Murray <andrew.murray@arm.com>
Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
[Mark: make field names consistent, use perfmon cap]
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Will Deacon <will@kernel.org>
[yuzenghui@huawei.com: adjust the context in read_id_reg()]
Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/sysreg.h |    6 ++++++
 arch/arm64/kvm/sys_regs.c       |   10 ++++++++++
 2 files changed, 16 insertions(+)

--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -622,6 +622,12 @@
 #define ID_AA64DFR0_TRACEVER_SHIFT	4
 #define ID_AA64DFR0_DEBUGVER_SHIFT	0
 
+#define ID_AA64DFR0_PMUVER_8_1		0x4
+
+#define ID_DFR0_PERFMON_SHIFT		24
+
+#define ID_DFR0_PERFMON_8_1		0x4
+
 #define ID_ISAR5_RDM_SHIFT		24
 #define ID_ISAR5_CRC32_SHIFT		16
 #define ID_ISAR5_SHA2_SHIFT		12
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1049,6 +1049,16 @@ static u64 read_id_reg(struct sys_reg_de
 			kvm_debug("LORegions unsupported for guests, suppressing\n");
 
 		val &= ~(0xfUL << ID_AA64MMFR1_LOR_SHIFT);
+	} else if (id == SYS_ID_AA64DFR0_EL1) {
+		/* Limit guests to PMUv3 for ARMv8.1 */
+		val = cpuid_feature_cap_perfmon_field(val,
+						ID_AA64DFR0_PMUVER_SHIFT,
+						ID_AA64DFR0_PMUVER_8_1);
+	} else if (id == SYS_ID_DFR0_EL1) {
+		/* Limit guests to PMUv3 for ARMv8.1 */
+		val = cpuid_feature_cap_perfmon_field(val,
+						ID_DFR0_PERFMON_SHIFT,
+						ID_DFR0_PERFMON_8_1);
 	}
 
 	return val;


