Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC88E36CE19;
	Wed, 20 May 2026 18:09:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300560; cv=none; b=JnpXGZvjCCsZq8sCxP3U/KKH8VeESNrtqccGjNtKLzKQ+Da3r/V3CnK69bLZCo0/XekB8J/cd1iI5Hd60bLrbXrFSfviYlta8vWseiIvP60QxoTVG2I1s50lcDwG+wwsvb0FuAFc9Pcn1gtm0/zUlM0Up2QVT6HZjv1J8+Rmewg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300560; c=relaxed/simple;
	bh=ME+xed5Hgc0ZklNViv98QZOn9a/c/TBVziB/Gwu8DRE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FhlSeZT2ExpUN4q6QwAbRJeIEDcnW2sahFDuQmAajZMCcTWmaIbLpYqvGhgi+e9cLUHKcKilpH9Z91X20D0H+rFH054upbp2alBcc/KtL4RhrvU+2pjJ/ZCz8QB/GQ4fZkF25We0jjxM5UZ6FBtxAiXKNGEcqzlzIXppkZQeIfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f+WSKgeP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f+WSKgeP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F5691F000E9;
	Wed, 20 May 2026 18:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300559;
	bh=YfhKsm1BrSBtuTSMlVcyF3KXvZTqP0/v3Z1mKjAUJ0E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f+WSKgePyrokTshOx7cyt1r4s/W2roCG1Jmct9GhV+W8Z7EJc9nFv2sp6GJaNnEqo
	 hHU5t7Gc5p8mXvBB3r26Aa0LJVCyGqAQZnq+XFr1RtDHYdqlU+z+rkOfp8Bjo/ruXW
	 W7qeCdP8vrOMmAvZDNJbgfPaXKX+wqjyKbqTivc0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 222/666] crypto: qat - use swab32 macro
Date: Wed, 20 May 2026 18:17:13 +0200
Message-ID: <20260520162116.022640806@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>

[ Upstream commit 35ecb77ae0749a2f1b04872c9978d9d7ddbbeb79 ]

Replace __builtin_bswap32() with swab32 in icp_qat_hw_20_comp.h to fix
the following build errors on architectures without native byte-swap
support:

   alpha-linux-ld: drivers/crypto/intel/qat/qat_common/adf_gen4_hw_data.o: in function `adf_gen4_build_decomp_block':
   drivers/crypto/intel/qat/qat_common/icp_qat_hw_20_comp.h:141:(.text+0xeec): undefined reference to `__bswapsi2'
   alpha-linux-ld: drivers/crypto/intel/qat/qat_common/icp_qat_hw_20_comp.h:141:(.text+0xef8): undefined reference to `__bswapsi2'
   alpha-linux-ld: drivers/crypto/intel/qat/qat_common/adf_gen4_hw_data.o: in function `adf_gen4_build_comp_block':
   drivers/crypto/intel/qat/qat_common/icp_qat_hw_20_comp.h:57:(.text+0xf64): undefined reference to `__bswapsi2'
   alpha-linux-ld: drivers/crypto/intel/qat/qat_common/icp_qat_hw_20_comp.h:57:(.text+0xf7c): undefined reference to `__bswapsi2'

Fixes: 5b14b2b307e4 ("crypto: qat - enable deflate for QAT GEN4")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202603290259.Ig9kDOmI-lkp@intel.com/
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../crypto/intel/qat/qat_common/icp_qat_hw_20_comp.h   | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/icp_qat_hw_20_comp.h b/drivers/crypto/intel/qat/qat_common/icp_qat_hw_20_comp.h
index 7ea8962272f2f..d28732225c9e0 100644
--- a/drivers/crypto/intel/qat/qat_common/icp_qat_hw_20_comp.h
+++ b/drivers/crypto/intel/qat/qat_common/icp_qat_hw_20_comp.h
@@ -3,6 +3,8 @@
 #ifndef _ICP_QAT_HW_20_COMP_H_
 #define _ICP_QAT_HW_20_COMP_H_
 
+#include <linux/swab.h>
+
 #include "icp_qat_hw_20_comp_defs.h"
 #include "icp_qat_fw.h"
 
@@ -54,7 +56,7 @@ ICP_QAT_FW_COMP_20_BUILD_CONFIG_LOWER(struct icp_qat_hw_comp_20_config_csr_lower
 	QAT_FIELD_SET(val32, csr.abd, ICP_QAT_HW_COMP_20_CONFIG_CSR_ABD_BITPOS,
 		      ICP_QAT_HW_COMP_20_CONFIG_CSR_ABD_MASK);
 
-	return __builtin_bswap32(val32);
+	return swab32(val32);
 }
 
 struct icp_qat_hw_comp_20_config_csr_upper {
@@ -106,7 +108,7 @@ ICP_QAT_FW_COMP_20_BUILD_CONFIG_UPPER(struct icp_qat_hw_comp_20_config_csr_upper
 		      ICP_QAT_HW_COMP_20_CONFIG_CSR_NICE_PARAM_BITPOS,
 		      ICP_QAT_HW_COMP_20_CONFIG_CSR_NICE_PARAM_MASK);
 
-	return __builtin_bswap32(val32);
+	return swab32(val32);
 }
 
 struct icp_qat_hw_decomp_20_config_csr_lower {
@@ -138,7 +140,7 @@ ICP_QAT_FW_DECOMP_20_BUILD_CONFIG_LOWER(struct icp_qat_hw_decomp_20_config_csr_l
 		      ICP_QAT_HW_DECOMP_20_CONFIG_CSR_LZ4_BLOCK_CHECKSUM_PRESENT_BITPOS,
 		      ICP_QAT_HW_DECOMP_20_CONFIG_CSR_LZ4_BLOCK_CHECKSUM_PRESENT_MASK);
 
-	return __builtin_bswap32(val32);
+	return swab32(val32);
 }
 
 struct icp_qat_hw_decomp_20_config_csr_upper {
@@ -158,7 +160,7 @@ ICP_QAT_FW_DECOMP_20_BUILD_CONFIG_UPPER(struct icp_qat_hw_decomp_20_config_csr_u
 		      ICP_QAT_HW_DECOMP_20_CONFIG_CSR_MINI_CAM_CONTROL_BITPOS,
 		      ICP_QAT_HW_DECOMP_20_CONFIG_CSR_MINI_CAM_CONTROL_MASK);
 
-	return __builtin_bswap32(val32);
+	return swab32(val32);
 }
 
 #endif
-- 
2.53.0



