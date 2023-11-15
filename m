Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA2A531730
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:46:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oiakQk78"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77A97C433C8;
	Wed, 15 Nov 2023 19:46:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077601;
	bh=1dQu9jXD2q5Bzcx6VwlgjCtwUP9YKubqQXEfYzzysms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oiakQk78G7gk5VKde7GCkPf6bD4B3J1fzx1SY4uHwN0lAmkuJfjAO0cJnNxRO4Ef9
	 yeCdyTIJKNFQmlxxgagO/xkvGOtyMasbayuZ+wX/7Pn5YWJORpucMW4dtLIcj2h6N/
	 SMi0LLPBwozJyspeo1vkzCTIl9N1NcHDOmS759Os=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Damian Muszynski <damian.muszynski@intel.com>,
	Tero Kristo <tero.kristo@linux.intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 403/603] crypto: qat - use masks for AE groups
Date: Wed, 15 Nov 2023 14:15:48 -0500
Message-ID: <20231115191640.922809797@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
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

From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>

[ Upstream commit f7df2329eec1729a606bba8ed1566a1b3c248bad ]

The adf_fw_config structures hardcode a bit mask that represents the
acceleration engines (AEs) where a certain firmware image will have to
be loaded to. Remove the hardcoded masks and replace them with defines.

This does not introduce any functional change.

Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Damian Muszynski <damian.muszynski@intel.com>
Reviewed-by: Tero Kristo <tero.kristo@linux.intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Stable-dep-of: a238487f7965 ("crypto: qat - fix ring to service map for QAT GEN4")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../intel/qat/qat_4xxx/adf_4xxx_hw_data.c     | 46 ++++++++++---------
 1 file changed, 25 insertions(+), 21 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c b/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
index 10839269c4d32..44b732fb80bca 100644
--- a/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
@@ -14,6 +14,10 @@
 #include "adf_cfg_services.h"
 #include "icp_qat_hw.h"
 
+#define ADF_AE_GROUP_0		GENMASK(3, 0)
+#define ADF_AE_GROUP_1		GENMASK(7, 4)
+#define ADF_AE_GROUP_2		BIT(8)
+
 enum adf_fw_objs {
 	ADF_FW_SYM_OBJ,
 	ADF_FW_ASYM_OBJ,
@@ -41,45 +45,45 @@ struct adf_fw_config {
 };
 
 static const struct adf_fw_config adf_fw_cy_config[] = {
-	{0xF0, ADF_FW_SYM_OBJ},
-	{0xF, ADF_FW_ASYM_OBJ},
-	{0x100, ADF_FW_ADMIN_OBJ},
+	{ADF_AE_GROUP_1, ADF_FW_SYM_OBJ},
+	{ADF_AE_GROUP_0, ADF_FW_ASYM_OBJ},
+	{ADF_AE_GROUP_2, ADF_FW_ADMIN_OBJ},
 };
 
 static const struct adf_fw_config adf_fw_dc_config[] = {
-	{0xF0, ADF_FW_DC_OBJ},
-	{0xF, ADF_FW_DC_OBJ},
-	{0x100, ADF_FW_ADMIN_OBJ},
+	{ADF_AE_GROUP_1, ADF_FW_DC_OBJ},
+	{ADF_AE_GROUP_0, ADF_FW_DC_OBJ},
+	{ADF_AE_GROUP_2, ADF_FW_ADMIN_OBJ},
 };
 
 static const struct adf_fw_config adf_fw_sym_config[] = {
-	{0xF0, ADF_FW_SYM_OBJ},
-	{0xF, ADF_FW_SYM_OBJ},
-	{0x100, ADF_FW_ADMIN_OBJ},
+	{ADF_AE_GROUP_1, ADF_FW_SYM_OBJ},
+	{ADF_AE_GROUP_0, ADF_FW_SYM_OBJ},
+	{ADF_AE_GROUP_2, ADF_FW_ADMIN_OBJ},
 };
 
 static const struct adf_fw_config adf_fw_asym_config[] = {
-	{0xF0, ADF_FW_ASYM_OBJ},
-	{0xF, ADF_FW_ASYM_OBJ},
-	{0x100, ADF_FW_ADMIN_OBJ},
+	{ADF_AE_GROUP_1, ADF_FW_ASYM_OBJ},
+	{ADF_AE_GROUP_0, ADF_FW_ASYM_OBJ},
+	{ADF_AE_GROUP_2, ADF_FW_ADMIN_OBJ},
 };
 
 static const struct adf_fw_config adf_fw_asym_dc_config[] = {
-	{0xF0, ADF_FW_ASYM_OBJ},
-	{0xF, ADF_FW_DC_OBJ},
-	{0x100, ADF_FW_ADMIN_OBJ},
+	{ADF_AE_GROUP_1, ADF_FW_ASYM_OBJ},
+	{ADF_AE_GROUP_0, ADF_FW_DC_OBJ},
+	{ADF_AE_GROUP_2, ADF_FW_ADMIN_OBJ},
 };
 
 static const struct adf_fw_config adf_fw_sym_dc_config[] = {
-	{0xF0, ADF_FW_SYM_OBJ},
-	{0xF, ADF_FW_DC_OBJ},
-	{0x100, ADF_FW_ADMIN_OBJ},
+	{ADF_AE_GROUP_1, ADF_FW_SYM_OBJ},
+	{ADF_AE_GROUP_0, ADF_FW_DC_OBJ},
+	{ADF_AE_GROUP_2, ADF_FW_ADMIN_OBJ},
 };
 
 static const struct adf_fw_config adf_fw_dcc_config[] = {
-	{0xF0, ADF_FW_DC_OBJ},
-	{0xF, ADF_FW_SYM_OBJ},
-	{0x100, ADF_FW_ADMIN_OBJ},
+	{ADF_AE_GROUP_1, ADF_FW_DC_OBJ},
+	{ADF_AE_GROUP_0, ADF_FW_SYM_OBJ},
+	{ADF_AE_GROUP_2, ADF_FW_ADMIN_OBJ},
 };
 
 static_assert(ARRAY_SIZE(adf_fw_cy_config) == ARRAY_SIZE(adf_fw_dc_config));
-- 
2.42.0



