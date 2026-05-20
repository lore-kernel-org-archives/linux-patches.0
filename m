Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9351C3F8704;
	Wed, 20 May 2026 18:35:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302123; cv=none; b=IH6RMEVbC2gsl79XRmSUpck315CApgM570uqmH+DY4HU+b7vh1qzfIKirp6g1zRU8tg2eBNatRZM1QSYFj2QFfoV+R0K6GIwcXKU1/h8hf+0b5aYcWNvOHcP6I/VWD7vb5LC8HUC4br+k84SnN1IbS9mElOdpEAWEeJofJBwbb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302123; c=relaxed/simple;
	bh=Q+v/oamsfqLTnP5sA6cc4yW+Qqa/kmplzE0YcGYmM8M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UZxuclvMHaO3ePTgUteRg3WPmqI0HrvQvTlsIbVsThCIdKfB97SKysVu+vbuUQgM1wJ7oSbGo/uFY4VFaewlvHDtJs+DYlMelca6XjqyVXSOuciiQKQzx+slBUqHU0gqXLxQIcfF6yIZf40s/ZVrFqN+Pe4QpOzkhGekmQefGMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n3I3bU0n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n3I3bU0n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 041391F000E9;
	Wed, 20 May 2026 18:35:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302122;
	bh=6DOqR1biFMVFPcwxQ+5vLdQ2CCn9jo9DtZhV7RTHRWY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n3I3bU0n9MtX6RiT51OG3l8SHc+TmSEEslXhPdOmDBfBxEKWMWezA1yIagqVfW2Mk
	 nc9SpIn9KDXo1arFLaKA+OSO+/wji25+6JcSIfW4TnkY+vgEaiZbdU5NoPDoCu1oI8
	 91efZlcapUtEHTFtkEGAOH34gtQoIO9lZlMowAoM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 147/508] crypto: qat - use swab32 macro
Date: Wed, 20 May 2026 18:19:30 +0200
Message-ID: <20260520162101.815378725@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



