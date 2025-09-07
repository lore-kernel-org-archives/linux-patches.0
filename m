Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8505921ADAE;
	Sun,  7 Sep 2025 20:38:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277532; cv=none; b=cttZ+JI3bO8FTaTbutSQ/p510SLvlN7mGBtP7xMCmhgiA7wjmV/PplANAGT3ECzb/Re3MJlO6wbRB7CIeOFnbqC2b2jbVRaIHr9GXyGBr8pTyJvM6ZWqw+KUYpHAQQioZ2P/DzHHPPAXBudYIL3dsHyRJfug8ryFtp4T0a4wNgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277532; c=relaxed/simple;
	bh=gYKk/QB+DVJ+AVk01mf+afVjuGuWvpz+gmjUfUhx6/0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Esox9sFY2scYzRZNTE5BkKyGEgZEfSIOii/yVmWqya11kqTl2/KKGIbudvnAomQjs1mEUWit/BMskk9J+BoeAeWjcpDGGdNIrk+XJHOoQFgZcqTRdY6OowgGVK3dYO7dp0g2sY6gTdKSst+A2+icdZgMhsAFIAJ5Umha2Km9Us4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1+8kSC0R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1+8kSC0R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04CFFC4CEF0;
	Sun,  7 Sep 2025 20:38:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277532;
	bh=gYKk/QB+DVJ+AVk01mf+afVjuGuWvpz+gmjUfUhx6/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1+8kSC0R2A4rZpk/KLP6LMNMsXy8lSWqvEBR8IKDjasoVFHMoDWAXhOzSevfvwaSn
	 XQdC8DX6rzIifyKNjmeEtg6EnthRXqsGGIufGCz1FJTIP62Gj/Lv3uKD9Qfpb8ldZP
	 en5Em7YLnWZ6n14F9smHqXcXsznKsiIYGDgtZBTU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 044/183] wifi: iwlwifi: acpi: check DSM func validity
Date: Sun,  7 Sep 2025 21:57:51 +0200
Message-ID: <20250907195616.823854700@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195615.802693401@linuxfoundation.org>
References: <20250907195615.802693401@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 7bf2dfccc2dd70821104d15cbab7b6fca21872be ]

The DSM func 0 (DSM_FUNC_QUERY) returns a bitmap of which
other functions contain valid data, query and check it
before returning other functions data.

Fixes: 9db93491f29e ("iwlwifi: acpi: support device specific method (DSM)")
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=220085
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20250828095500.881e17ff8f6a.Ic6d92997d9d5fad127919d6e1b830cd3fe944468@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/fw/acpi.c  | 25 ++++++++++++++++++-
 .../net/wireless/intel/iwlwifi/fw/runtime.h   |  8 ++++++
 2 files changed, 32 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/acpi.c b/drivers/net/wireless/intel/iwlwifi/fw/acpi.c
index bee7d92293b8d..7ec22738b5d65 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/acpi.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/acpi.c
@@ -169,7 +169,7 @@ int iwl_acpi_get_dsm(struct iwl_fw_runtime *fwrt,
 
 	BUILD_BUG_ON(ARRAY_SIZE(acpi_dsm_size) != DSM_FUNC_NUM_FUNCS);
 
-	if (WARN_ON(func >= ARRAY_SIZE(acpi_dsm_size)))
+	if (WARN_ON(func >= ARRAY_SIZE(acpi_dsm_size) || !func))
 		return -EINVAL;
 
 	expected_size = acpi_dsm_size[func];
@@ -178,6 +178,29 @@ int iwl_acpi_get_dsm(struct iwl_fw_runtime *fwrt,
 	if (expected_size != sizeof(u8) && expected_size != sizeof(u32))
 		return -EOPNOTSUPP;
 
+	if (!fwrt->acpi_dsm_funcs_valid) {
+		ret = iwl_acpi_get_dsm_integer(fwrt->dev, ACPI_DSM_REV,
+					       DSM_FUNC_QUERY,
+					       &iwl_guid, &tmp,
+					       acpi_dsm_size[DSM_FUNC_QUERY]);
+		if (ret) {
+			/* always indicate BIT(0) to avoid re-reading */
+			fwrt->acpi_dsm_funcs_valid = BIT(0);
+			return ret;
+		}
+
+		IWL_DEBUG_RADIO(fwrt, "ACPI DSM validity bitmap 0x%x\n",
+				(u32)tmp);
+		/* always indicate BIT(0) to avoid re-reading */
+		fwrt->acpi_dsm_funcs_valid = tmp | BIT(0);
+	}
+
+	if (!(fwrt->acpi_dsm_funcs_valid & BIT(func))) {
+		IWL_DEBUG_RADIO(fwrt, "ACPI DSM %d not indicated as valid\n",
+				func);
+		return -ENODATA;
+	}
+
 	ret = iwl_acpi_get_dsm_integer(fwrt->dev, ACPI_DSM_REV, func,
 				       &iwl_guid, &tmp, expected_size);
 	if (ret)
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/runtime.h b/drivers/net/wireless/intel/iwlwifi/fw/runtime.h
index 0444a736c2b20..bd3bc2846cfa4 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/runtime.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/runtime.h
@@ -113,6 +113,10 @@ struct iwl_txf_iter_data {
  * @phy_filters: specific phy filters as read from WPFC BIOS table
  * @ppag_bios_rev: PPAG BIOS revision
  * @ppag_bios_source: see &enum bios_source
+ * @acpi_dsm_funcs_valid: bitmap indicating which DSM values are valid,
+ *	zero (default initialization) means it hasn't been read yet,
+ *	and BIT(0) is set when it has since function 0 also has this
+ *	bitmap and is always supported
  */
 struct iwl_fw_runtime {
 	struct iwl_trans *trans;
@@ -189,6 +193,10 @@ struct iwl_fw_runtime {
 	bool uats_valid;
 	u8 uefi_tables_lock_status;
 	struct iwl_phy_specific_cfg phy_filters;
+
+#ifdef CONFIG_ACPI
+	u32 acpi_dsm_funcs_valid;
+#endif
 };
 
 void iwl_fw_runtime_init(struct iwl_fw_runtime *fwrt, struct iwl_trans *trans,
-- 
2.50.1



