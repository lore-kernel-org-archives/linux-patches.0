Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A28D31F666B;
	Tue,  3 Dec 2024 14:52:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733237575; cv=none; b=qJIwjvBYLPDeGDlfVOAsgYSLClLQiPAny9FWeJtARu7lUfpK3QXMj+EQpuTJUXUf9ah6/2JKsWV0Fa9kgzbY0e6R+TCBOrJRTiYJ8DNbl3Jm8rOIaIxAmbFsmBvlqWMNcfOYINadm7PbbD1k/3hqmcnyI0oHaIorSlJttFEkl9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733237575; c=relaxed/simple;
	bh=+1/0ic0j8oG8AZAD1mNfhcQiOivNWz91+NLJq/BoUq0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eLT8nGR+COafJyd9FhEaBJt+oW38KnTWqWHlV1C9Dt5GPfEYgX59qot9sNJRX92lsKsAHsB2p+a1SYBNrnza9CVqm/+ztfFqvKE5H3f4qdoVxQUBLrmXFfP9/knK6ltVHbFwpRcZreTNgNxPwXuc4IjrDw6UiDJ5Pba72BoYpLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hzldpT0b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hzldpT0b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0041C4CECF;
	Tue,  3 Dec 2024 14:52:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733237575;
	bh=+1/0ic0j8oG8AZAD1mNfhcQiOivNWz91+NLJq/BoUq0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hzldpT0btIlAkLk3JEykaIQpBGQ2FCwU54Rxagrzmny9WH30KAN+FRaz////L4pXl
	 e35u3oa9kOCPArhJleOzBoFZUKu7btU3pgWXQolciarMohPbM3mpePNmRm697QbvGD
	 PU6B4N+lxv4BNk1Ub+G8k45g55RcyIjx88gZbJkk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 011/817] wifi: iwlwifi: mvm: SAR table alignment
Date: Tue,  3 Dec 2024 15:33:03 +0100
Message-ID: <20241203143956.075193929@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>

[ Upstream commit 32d95ab330069f9c551b8e99770bb4e799730b55 ]

SAR table format in ACPI and local data base are different,
So modified code to read data properly.

Signed-off-by: Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20241010140328.f077aced4dee.I4dc618f12d01f7ad19f9f8881f6e09eea77e9a14@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/fw/acpi.c | 96 ++++++++++++--------
 1 file changed, 58 insertions(+), 38 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/acpi.c b/drivers/net/wireless/intel/iwlwifi/fw/acpi.c
index a7cea0a55b35a..0bc32291815e1 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/acpi.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/acpi.c
@@ -429,38 +429,28 @@ int iwl_acpi_get_eckv(struct iwl_fw_runtime *fwrt, u32 *extl_clk)
 	return ret;
 }
 
-static int iwl_acpi_sar_set_profile(union acpi_object *table,
-				    struct iwl_sar_profile *profile,
-				    bool enabled, u8 num_chains,
-				    u8 num_sub_bands)
+static int
+iwl_acpi_parse_chains_table(union acpi_object *table,
+			    struct iwl_sar_profile_chain *chains,
+			    u8 num_chains, u8 num_sub_bands)
 {
-	int i, j, idx = 0;
-
-	/*
-	 * The table from ACPI is flat, but we store it in a
-	 * structured array.
-	 */
-	for (i = 0; i < BIOS_SAR_MAX_CHAINS_PER_PROFILE; i++) {
-		for (j = 0; j < BIOS_SAR_MAX_SUB_BANDS_NUM; j++) {
+	for (u8 chain = 0; chain < num_chains; chain++) {
+		for (u8 subband = 0; subband < BIOS_SAR_MAX_SUB_BANDS_NUM;
+		     subband++) {
 			/* if we don't have the values, use the default */
-			if (i >= num_chains || j >= num_sub_bands) {
-				profile->chains[i].subbands[j] = 0;
+			if (subband >= num_sub_bands) {
+				chains[chain].subbands[subband] = 0;
+			} else if (table->type != ACPI_TYPE_INTEGER ||
+				   table->integer.value > U8_MAX) {
+				return -EINVAL;
 			} else {
-				if (table[idx].type != ACPI_TYPE_INTEGER ||
-				    table[idx].integer.value > U8_MAX)
-					return -EINVAL;
-
-				profile->chains[i].subbands[j] =
-					table[idx].integer.value;
-
-				idx++;
+				chains[chain].subbands[subband] =
+					table->integer.value;
+				table++;
 			}
 		}
 	}
 
-	/* Only if all values were valid can the profile be enabled */
-	profile->enabled = enabled;
-
 	return 0;
 }
 
@@ -543,9 +533,11 @@ int iwl_acpi_get_wrds_table(struct iwl_fw_runtime *fwrt)
 	/* The profile from WRDS is officially profile 1, but goes
 	 * into sar_profiles[0] (because we don't have a profile 0).
 	 */
-	ret = iwl_acpi_sar_set_profile(table, &fwrt->sar_profiles[0],
-				       flags & IWL_SAR_ENABLE_MSK,
-				       num_chains, num_sub_bands);
+	ret = iwl_acpi_parse_chains_table(table, fwrt->sar_profiles[0].chains,
+					  num_chains, num_sub_bands);
+	if (!ret && flags & IWL_SAR_ENABLE_MSK)
+		fwrt->sar_profiles[0].enabled = true;
+
 out_free:
 	kfree(data);
 	return ret;
@@ -557,7 +549,7 @@ int iwl_acpi_get_ewrd_table(struct iwl_fw_runtime *fwrt)
 	bool enabled;
 	int i, n_profiles, tbl_rev, pos;
 	int ret = 0;
-	u8 num_chains, num_sub_bands;
+	u8 num_sub_bands;
 
 	data = iwl_acpi_get_object(fwrt->dev, ACPI_EWRD_METHOD);
 	if (IS_ERR(data))
@@ -573,7 +565,6 @@ int iwl_acpi_get_ewrd_table(struct iwl_fw_runtime *fwrt)
 			goto out_free;
 		}
 
-		num_chains = ACPI_SAR_NUM_CHAINS_REV2;
 		num_sub_bands = ACPI_SAR_NUM_SUB_BANDS_REV2;
 
 		goto read_table;
@@ -589,7 +580,6 @@ int iwl_acpi_get_ewrd_table(struct iwl_fw_runtime *fwrt)
 			goto out_free;
 		}
 
-		num_chains = ACPI_SAR_NUM_CHAINS_REV1;
 		num_sub_bands = ACPI_SAR_NUM_SUB_BANDS_REV1;
 
 		goto read_table;
@@ -605,7 +595,6 @@ int iwl_acpi_get_ewrd_table(struct iwl_fw_runtime *fwrt)
 			goto out_free;
 		}
 
-		num_chains = ACPI_SAR_NUM_CHAINS_REV0;
 		num_sub_bands = ACPI_SAR_NUM_SUB_BANDS_REV0;
 
 		goto read_table;
@@ -637,23 +626,54 @@ int iwl_acpi_get_ewrd_table(struct iwl_fw_runtime *fwrt)
 	/* the tables start at element 3 */
 	pos = 3;
 
+	BUILD_BUG_ON(ACPI_SAR_NUM_CHAINS_REV0 != ACPI_SAR_NUM_CHAINS_REV1);
+	BUILD_BUG_ON(ACPI_SAR_NUM_CHAINS_REV2 != 2 * ACPI_SAR_NUM_CHAINS_REV0);
+
+	/* parse non-cdb chains for all profiles */
 	for (i = 0; i < n_profiles; i++) {
 		union acpi_object *table = &wifi_pkg->package.elements[pos];
+
 		/* The EWRD profiles officially go from 2 to 4, but we
 		 * save them in sar_profiles[1-3] (because we don't
 		 * have profile 0).  So in the array we start from 1.
 		 */
-		ret = iwl_acpi_sar_set_profile(table,
-					       &fwrt->sar_profiles[i + 1],
-					       enabled, num_chains,
-					       num_sub_bands);
+		ret = iwl_acpi_parse_chains_table(table,
+						  fwrt->sar_profiles[i + 1].chains,
+						  ACPI_SAR_NUM_CHAINS_REV0,
+						  num_sub_bands);
 		if (ret < 0)
-			break;
+			goto out_free;
 
 		/* go to the next table */
-		pos += num_chains * num_sub_bands;
+		pos += ACPI_SAR_NUM_CHAINS_REV0 * num_sub_bands;
 	}
 
+	/* non-cdb table revisions */
+	if (tbl_rev < 2)
+		goto set_enabled;
+
+	/* parse cdb chains for all profiles */
+	for (i = 0; i < n_profiles; i++) {
+		struct iwl_sar_profile_chain *chains;
+		union acpi_object *table;
+
+		table = &wifi_pkg->package.elements[pos];
+		chains = &fwrt->sar_profiles[i + 1].chains[ACPI_SAR_NUM_CHAINS_REV0];
+		ret = iwl_acpi_parse_chains_table(table,
+						  chains,
+						  ACPI_SAR_NUM_CHAINS_REV0,
+						  num_sub_bands);
+		if (ret < 0)
+			goto out_free;
+
+		/* go to the next table */
+		pos += ACPI_SAR_NUM_CHAINS_REV0 * num_sub_bands;
+	}
+
+set_enabled:
+	for (i = 0; i < n_profiles; i++)
+		fwrt->sar_profiles[i + 1].enabled = enabled;
+
 out_free:
 	kfree(data);
 	return ret;
-- 
2.43.0



