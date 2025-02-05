Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19B9F1519BE;
	Wed,  5 Feb 2025 14:21:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765289; cv=none; b=px4HmmiXf7mPT7pMHd7h3AERL8BXMmlmLZyN/e0C6zcOfKIYDQ788Dy77XOaJ5aU2UmDNpadWH9VLxX4VbmuwVjSKzUK26mCVcU+kbEZss9iZYgTHqhIU0QBv379EkbqLLLrCrrGf9mHokmYy+IpgLjlsLbB3sZH40w6HOx6SS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765289; c=relaxed/simple;
	bh=GGLh/SXP7ZpxKP+b7uqdAe/M0zj1QVaFQxzkSJ/hop8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gi7AhjHA6+Oepy9DmETKSwloBToEk7V3rxIL45k1J50vdpSo5fJApPKUaAq8rguwJAJFZlm2M6+LFjvFcXirA7IP8c97YwaXI/Nz6+9LGHSlF56GIFRykYFQ9YbSCpwZkQ83LdA7ipc8mBpqTu6NPM1DqpI3+T/k3Qo01lytyfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sDLXY/qC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sDLXY/qC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22F3FC4CED1;
	Wed,  5 Feb 2025 14:21:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765288;
	bh=GGLh/SXP7ZpxKP+b7uqdAe/M0zj1QVaFQxzkSJ/hop8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sDLXY/qCEWW0HuM8xGEWUnrKMz5DgVG0Y51GjzMqJ54IQbWdEyZ1pyS4aNgpKwgg4
	 JUxZCO5nHPQwQur1P28GKYY1z6eLkVNkme9ZSN9NYvplQ/snnFq65WrrZ0EKsWk12Y
	 1UxMighFzKZKge8koDA0OFSrRwD39R0moW3VBVXE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Daniel Gabay <daniel.gabay@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 163/623] wifi: iwlwifi: fw: read STEP table from correct UEFI var
Date: Wed,  5 Feb 2025 14:38:25 +0100
Message-ID: <20250205134502.469088526@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 80c2b651fe7fc82e1d1b3e4f9651095896a095f0 ]

This variable exists for the "common" (WiFi/BT) GUID, not the
WiFi-only GUID. Fix that by passing the GUID to the function.
A short-cut for the wifi-only version remains so not all code
must be updated.

However, rename the GUID defines to be clearer.

Fixes: 09b4c35d73a5 ("wifi: iwlwifi: mvm: Support STEP equalizer settings from BIOS.")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Reviewed-by: Daniel Gabay <daniel.gabay@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20241227095718.89a5ad921b6d.Idae95a70ff69d2ba1b610e8eced826961ce7de98@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/fw/uefi.c | 44 +++++++++++++-------
 1 file changed, 30 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/uefi.c b/drivers/net/wireless/intel/iwlwifi/fw/uefi.c
index 091fb6fd7c787..834f7c9bb9e92 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/uefi.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/uefi.c
@@ -13,9 +13,12 @@
 #include <linux/efi.h>
 #include "fw/runtime.h"
 
-#define IWL_EFI_VAR_GUID EFI_GUID(0x92daaf2f, 0xc02b, 0x455b,	\
-				  0xb2, 0xec, 0xf5, 0xa3,	\
-				  0x59, 0x4f, 0x4a, 0xea)
+#define IWL_EFI_WIFI_GUID	EFI_GUID(0x92daaf2f, 0xc02b, 0x455b,	\
+					 0xb2, 0xec, 0xf5, 0xa3,	\
+					 0x59, 0x4f, 0x4a, 0xea)
+#define IWL_EFI_WIFI_BT_GUID	EFI_GUID(0xe65d8884, 0xd4af, 0x4b20,	\
+					 0x8d, 0x03, 0x77, 0x2e,	\
+					 0xcc, 0x3d, 0xa5, 0x31)
 
 struct iwl_uefi_pnvm_mem_desc {
 	__le32 addr;
@@ -61,7 +64,7 @@ void *iwl_uefi_get_pnvm(struct iwl_trans *trans, size_t *len)
 
 	*len = 0;
 
-	data = iwl_uefi_get_variable(IWL_UEFI_OEM_PNVM_NAME, &IWL_EFI_VAR_GUID,
+	data = iwl_uefi_get_variable(IWL_UEFI_OEM_PNVM_NAME, &IWL_EFI_WIFI_GUID,
 				     &package_size);
 	if (IS_ERR(data)) {
 		IWL_DEBUG_FW(trans,
@@ -76,18 +79,18 @@ void *iwl_uefi_get_pnvm(struct iwl_trans *trans, size_t *len)
 	return data;
 }
 
-static
-void *iwl_uefi_get_verified_variable(struct iwl_trans *trans,
-				     efi_char16_t *uefi_var_name,
-				     char *var_name,
-				     unsigned int expected_size,
-				     unsigned long *size)
+static void *
+iwl_uefi_get_verified_variable_guid(struct iwl_trans *trans,
+				    efi_guid_t *guid,
+				    efi_char16_t *uefi_var_name,
+				    char *var_name,
+				    unsigned int expected_size,
+				    unsigned long *size)
 {
 	void *var;
 	unsigned long var_size;
 
-	var = iwl_uefi_get_variable(uefi_var_name, &IWL_EFI_VAR_GUID,
-				    &var_size);
+	var = iwl_uefi_get_variable(uefi_var_name, guid, &var_size);
 
 	if (IS_ERR(var)) {
 		IWL_DEBUG_RADIO(trans,
@@ -112,6 +115,18 @@ void *iwl_uefi_get_verified_variable(struct iwl_trans *trans,
 	return var;
 }
 
+static void *
+iwl_uefi_get_verified_variable(struct iwl_trans *trans,
+			       efi_char16_t *uefi_var_name,
+			       char *var_name,
+			       unsigned int expected_size,
+			       unsigned long *size)
+{
+	return iwl_uefi_get_verified_variable_guid(trans, &IWL_EFI_WIFI_GUID,
+						   uefi_var_name, var_name,
+						   expected_size, size);
+}
+
 int iwl_uefi_handle_tlv_mem_desc(struct iwl_trans *trans, const u8 *data,
 				 u32 tlv_len, struct iwl_pnvm_image *pnvm_data)
 {
@@ -311,8 +326,9 @@ void iwl_uefi_get_step_table(struct iwl_trans *trans)
 	if (trans->trans_cfg->device_family < IWL_DEVICE_FAMILY_AX210)
 		return;
 
-	data = iwl_uefi_get_verified_variable(trans, IWL_UEFI_STEP_NAME,
-					      "STEP", sizeof(*data), NULL);
+	data = iwl_uefi_get_verified_variable_guid(trans, &IWL_EFI_WIFI_BT_GUID,
+						   IWL_UEFI_STEP_NAME,
+						   "STEP", sizeof(*data), NULL);
 	if (IS_ERR(data))
 		return;
 
-- 
2.39.5



