Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 712F123536A;
	Mon, 10 Mar 2025 17:31:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627893; cv=none; b=esnyVCvArShUepAiipYvsIjjnhrvQFtEnxG8EHoFE0LCvMfn/ax9lWcWEx8YjeU4swE8ChxwpUSvshHXDAlt2gERBPSn/c7e0H0+g7TZAOBMtK5226Gl4VPyE6c+Z+/riO47jh/0XIpZHFbtjemjCpwec+jOxwmB+OA9+MKS9Ls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627893; c=relaxed/simple;
	bh=r++Fd+wC3KgruAtCSSo/Qpp+vydfHLp6uR4X3GhBXlc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lFGhO3XlTu5VLpur1+LG7EI7oopZeCBeVMSMBaNZvRDQqNFy+BYVnvxPu3Vlb0V9gTlw/68lButsBARS8yTzucCyJqLcIZDTJJR8JKRmZYY2n2gwuUEcnSVNsXfdZsL5/dUTsCewRp8qkwi7NiZsLLjOCKANj3qfHmT99+DOtew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VGDKp0bC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VGDKp0bC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFD72C4CEE5;
	Mon, 10 Mar 2025 17:31:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627893;
	bh=r++Fd+wC3KgruAtCSSo/Qpp+vydfHLp6uR4X3GhBXlc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VGDKp0bCulvNUDIuqJtvAGusP/FgDYrsV16tvwyxqaAVtlW5FP9ihFHibxFj1ialz
	 VZP1ThxvS/bmdtp7/RWSeM4SWYubH39bWzraoVYR/wPqiXPyUZOA+sJ7L9bmWrVa7Z
	 pi5seeC5vfHFHJP+O0blD7vMAOmlignwePye/1DQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeremy Linton <jeremy.linton@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Sunil V L <sunilvl@ventanamicro.com>,
	Yunhui Cui <cuiyunhui@bytedance.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 017/145] riscv: cacheinfo: initialize cacheinfos level and type from ACPI PPTT
Date: Mon, 10 Mar 2025 18:05:11 +0100
Message-ID: <20250310170435.438542200@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170434.733307314@linuxfoundation.org>
References: <20250310170434.733307314@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yunhui Cui <cuiyunhui@bytedance.com>

[ Upstream commit 604f32ea6909b0ebb8ab0bf1ab7dc66ee3dc8955 ]

Before cacheinfo can be built correctly, we need to initialize level
and type. Since RISC-V currently does not have a register group that
describes cache-related attributes like ARM64, we cannot obtain them
directly, so now we obtain cache leaves from the ACPI PPTT table
(acpi_get_cache_info()) and set the cache type through split_levels.

Suggested-by: Jeremy Linton <jeremy.linton@arm.com>
Suggested-by: Sudeep Holla <sudeep.holla@arm.com>
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Reviewed-by: Sunil V L <sunilvl@ventanamicro.com>
Reviewed-by: Jeremy Linton <jeremy.linton@arm.com>
Reviewed-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Yunhui Cui <cuiyunhui@bytedance.com>
Link: https://lore.kernel.org/r/20240617131425.7526-2-cuiyunhui@bytedance.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Stable-dep-of: fb8179ce2996 ("riscv: cacheinfo: Use of_property_present() for non-boolean properties")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/cacheinfo.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/arch/riscv/kernel/cacheinfo.c b/arch/riscv/kernel/cacheinfo.c
index 30a6878287ad4..d6c108c50cba9 100644
--- a/arch/riscv/kernel/cacheinfo.c
+++ b/arch/riscv/kernel/cacheinfo.c
@@ -3,6 +3,7 @@
  * Copyright (C) 2017 SiFive
  */
 
+#include <linux/acpi.h>
 #include <linux/cpu.h>
 #include <linux/of.h>
 #include <asm/cacheinfo.h>
@@ -78,6 +79,27 @@ int populate_cache_leaves(unsigned int cpu)
 	struct device_node *prev = NULL;
 	int levels = 1, level = 1;
 
+	if (!acpi_disabled) {
+		int ret, fw_levels, split_levels;
+
+		ret = acpi_get_cache_info(cpu, &fw_levels, &split_levels);
+		if (ret)
+			return ret;
+
+		BUG_ON((split_levels > fw_levels) ||
+		       (split_levels + fw_levels > this_cpu_ci->num_leaves));
+
+		for (; level <= this_cpu_ci->num_levels; level++) {
+			if (level <= split_levels) {
+				ci_leaf_init(this_leaf++, CACHE_TYPE_DATA, level);
+				ci_leaf_init(this_leaf++, CACHE_TYPE_INST, level);
+			} else {
+				ci_leaf_init(this_leaf++, CACHE_TYPE_UNIFIED, level);
+			}
+		}
+		return 0;
+	}
+
 	if (of_property_read_bool(np, "cache-size"))
 		ci_leaf_init(this_leaf++, CACHE_TYPE_UNIFIED, level);
 	if (of_property_read_bool(np, "i-cache-size"))
-- 
2.39.5



