Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AD1F78B69;
	Mon,  4 Mar 2024 21:38:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588305; cv=none; b=GOMVv+KD9QZFn+tRNEEiy39KdFNC1qruYFQOpWMmjiH2PAZ8Lu6dmPcC54OKAkfsMm4MfBd1ySH8qxG8JpfZE6PSbiRa4Qb5ADGp0uiSw1mPIOLypuhg+2AoHIQ/Nqbgpt80k8r5UlAeRkR8JfNNDSieq13rgs9s3/Wjc2eNmGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588305; c=relaxed/simple;
	bh=r+t7GI1mckC+3PB7SahgkK5OTKmwt/f1C72W1Usg0uM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g4J7lqGCkkDtErc7cuH7wH4Swhg+69rh4/pe5hWVoGmOuBnjmg49K8Vh9z2DJkoj4D1EjEjTp9M/i9UjKsS6OKMUzPCvHhR1qTHIU05w2a/8ZW+dfQRMKTlY8/hL2QMVB8zlYhD+q6Q/ncTMIU4hy2VEXl4TBhKq3tBtN81afWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mm/c5B47; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mm/c5B47"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A986AC433F1;
	Mon,  4 Mar 2024 21:38:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588305;
	bh=r+t7GI1mckC+3PB7SahgkK5OTKmwt/f1C72W1Usg0uM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mm/c5B47yUqT+EHcfTUHBy/CpKmcB2bFgcFb8UsZWMrY/wc84mToflfey4fWog4d9
	 Wt9DrQVuulHvTpmDJtsXQHY/2N8KcAtjLpBKvHX5eeBq1q69j7bM/vRhpzR0u2jRIQ
	 IvEqeBRT57IrTs+pxU90CgvOZpqUaO0/quTksksg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Conor Dooley <conor.dooley@microchip.com>,
	Guo Ren <guoren@kernel.org>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 057/143] RISC-V: Ignore V from the riscv,isa DT property on older T-Head CPUs
Date: Mon,  4 Mar 2024 21:22:57 +0000
Message-ID: <20240304211551.745456636@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211549.876981797@linuxfoundation.org>
References: <20240304211549.876981797@linuxfoundation.org>
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

From: Conor Dooley <conor@kernel.org>

[ Upstream commit d82f32202e0df7bf40d4b67c8a4ff9cea32df4d9 ]

Before attempting to support the pre-ratification version of vector
found on older T-Head CPUs, disallow "v" in riscv,isa on these
platforms. The deprecated property has no clear way to communicate
the specific version of vector that is supported and much of the vendor
provided software puts "v" in the isa string. riscv,isa-extensions
should be used instead. This should not be too much of a burden for
these systems, as the vendor shipped devicetrees and firmware do not
work with a mainline kernel and will require updating.

We can limit this restriction to only ignore v in riscv,isa on CPUs
that report T-Head's vendor ID and a zero marchid. Newer T-Head CPUs
that support the ratified version of vector should report non-zero
marchid, according to Guo Ren [1].

Link: https://lore.kernel.org/linux-riscv/CAJF2gTRy5eK73=d6s7CVy9m9pB8p4rAoMHM3cZFwzg=AuF7TDA@mail.gmail.com/ [1]
Fixes: dc6667a4e7e3 ("riscv: Extending cpufeature.c to detect V-extension")
Co-developed-by: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
Acked-by: Guo Ren <guoren@kernel.org>
Link: https://lore.kernel.org/r/20240223-tidings-shabby-607f086cb4d7@spud
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/cpufeature.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/riscv/kernel/cpufeature.c b/arch/riscv/kernel/cpufeature.c
index e12cd22755c78..e39a905aca248 100644
--- a/arch/riscv/kernel/cpufeature.c
+++ b/arch/riscv/kernel/cpufeature.c
@@ -21,6 +21,7 @@
 #include <asm/hwprobe.h>
 #include <asm/patch.h>
 #include <asm/processor.h>
+#include <asm/sbi.h>
 #include <asm/vector.h>
 
 #include "copy-unaligned.h"
@@ -396,6 +397,20 @@ static void __init riscv_fill_hwcap_from_isa_string(unsigned long *isa2hwcap)
 			set_bit(RISCV_ISA_EXT_ZIHPM, isainfo->isa);
 		}
 
+		/*
+		 * "V" in ISA strings is ambiguous in practice: it should mean
+		 * just the standard V-1.0 but vendors aren't well behaved.
+		 * Many vendors with T-Head CPU cores which implement the 0.7.1
+		 * version of the vector specification put "v" into their DTs.
+		 * CPU cores with the ratified spec will contain non-zero
+		 * marchid.
+		 */
+		if (acpi_disabled && riscv_cached_mvendorid(cpu) == THEAD_VENDOR_ID &&
+		    riscv_cached_marchid(cpu) == 0x0) {
+			this_hwcap &= ~isa2hwcap[RISCV_ISA_EXT_v];
+			clear_bit(RISCV_ISA_EXT_v, isainfo->isa);
+		}
+
 		/*
 		 * All "okay" hart should have same isa. Set HWCAP based on
 		 * common capabilities of every "okay" hart, in case they don't
-- 
2.43.0



