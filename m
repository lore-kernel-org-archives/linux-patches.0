Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C302214415;
	Tue, 12 Nov 2024 10:45:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731408334; cv=none; b=nltdNl3VjHL4Cc2w2x4cBtITRtiJd5mNXMOx0TXukA3itVBoQxFDNlW7jqxjpMYo0WS/HWb8vLtbbkehbGJBdMQHlQjmzcBXG86tc9YLGeS1jBotiKs/50c+x3P5BFOIC0V2Zb2pB3k9GYP016l3+m8OztDJL6tMB2T1yRdhR5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731408334; c=relaxed/simple;
	bh=G7vBc6dAock588Agrtx/nc9zo1uN/47JHez/y8dmkxQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QvdIU/VOy9mjJxLhCskB+OyiEmHrwC9Xs2liE8Ti1Xizy5kXnRioQ6FxzffMCbTPKHdPs1kgU38LBijwQW8uzuaS7WFobm/dgmQmu5WOrZLoAk5qVGoRVaLLtzftbUZAfMUMQw7PrJH97JB+YNbRDmp7XKvE5jCGEflVzGZG45k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e9IvYJH8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e9IvYJH8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96974C4CECD;
	Tue, 12 Nov 2024 10:45:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731408334;
	bh=G7vBc6dAock588Agrtx/nc9zo1uN/47JHez/y8dmkxQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e9IvYJH8pK291pj5A9NBI4vHlYNpvWMOTGUbPnO9wu+nawFyrqXmxy71Gl7beuOog
	 2NwRvc1TBdqfE1OdNUZIlwZzTDG3EzV5dyzjqUgjhHvTrwbGKRdxMQCaLngo6Zj9Dr
	 EMBhvjbZ+M2hQsAds0sOgz2JosVIfBFsYNVwSQ1U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kenneth Feng <kenneth.feng@amd.com>,
	Yang Wang <kevinyang.wang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.11 099/184] drm/amd/pm: always pick the pptable from IFWI
Date: Tue, 12 Nov 2024 11:20:57 +0100
Message-ID: <20241112101904.662279749@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101900.865487674@linuxfoundation.org>
References: <20241112101900.865487674@linuxfoundation.org>
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

From: Kenneth Feng <kenneth.feng@amd.com>

commit 1356bfc54c8d4c8e7c9fb8553dc8c28e9714b07b upstream.

always pick the pptable from IFWI on smu v14.0.2/3

Signed-off-by: Kenneth Feng <kenneth.feng@amd.com>
Reviewed-by: Yang Wang <kevinyang.wang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 136ce12bd5907388cb4e9aa63ee5c9c8c441640b)
Cc: stable@vger.kernel.org # 6.11.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu14/smu_v14_0_2_ppt.c |   65 -------------------
 1 file changed, 1 insertion(+), 64 deletions(-)

--- a/drivers/gpu/drm/amd/pm/swsmu/smu14/smu_v14_0_2_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu14/smu_v14_0_2_ppt.c
@@ -354,54 +354,6 @@ static int smu_v14_0_2_store_powerplay_t
 	return 0;
 }
 
-#ifndef atom_smc_dpm_info_table_14_0_0
-struct atom_smc_dpm_info_table_14_0_0 {
-	struct atom_common_table_header table_header;
-	BoardTable_t BoardTable;
-};
-#endif
-
-static int smu_v14_0_2_append_powerplay_table(struct smu_context *smu)
-{
-	struct smu_table_context *table_context = &smu->smu_table;
-	PPTable_t *smc_pptable = table_context->driver_pptable;
-	struct atom_smc_dpm_info_table_14_0_0 *smc_dpm_table;
-	BoardTable_t *BoardTable = &smc_pptable->BoardTable;
-	int index, ret;
-
-	index = get_index_into_master_table(atom_master_list_of_data_tables_v2_1,
-					    smc_dpm_info);
-
-	ret = amdgpu_atombios_get_data_table(smu->adev, index, NULL, NULL, NULL,
-					     (uint8_t **)&smc_dpm_table);
-	if (ret)
-		return ret;
-
-	memcpy(BoardTable, &smc_dpm_table->BoardTable, sizeof(BoardTable_t));
-
-	return 0;
-}
-
-#if 0
-static int smu_v14_0_2_get_pptable_from_pmfw(struct smu_context *smu,
-					     void **table,
-					     uint32_t *size)
-{
-	struct smu_table_context *smu_table = &smu->smu_table;
-	void *combo_pptable = smu_table->combo_pptable;
-	int ret = 0;
-
-	ret = smu_cmn_get_combo_pptable(smu);
-	if (ret)
-		return ret;
-
-	*table = combo_pptable;
-	*size = sizeof(struct smu_14_0_powerplay_table);
-
-	return 0;
-}
-#endif
-
 static int smu_v14_0_2_get_pptable_from_pmfw(struct smu_context *smu,
 					     void **table,
 					     uint32_t *size)
@@ -423,16 +375,12 @@ static int smu_v14_0_2_get_pptable_from_
 static int smu_v14_0_2_setup_pptable(struct smu_context *smu)
 {
 	struct smu_table_context *smu_table = &smu->smu_table;
-	struct amdgpu_device *adev = smu->adev;
 	int ret = 0;
 
 	if (amdgpu_sriov_vf(smu->adev))
 		return 0;
 
-	if (!adev->scpm_enabled)
-		ret = smu_v14_0_setup_pptable(smu);
-	else
-		ret = smu_v14_0_2_get_pptable_from_pmfw(smu,
+	ret = smu_v14_0_2_get_pptable_from_pmfw(smu,
 							&smu_table->power_play_table,
 							&smu_table->power_play_table_size);
 	if (ret)
@@ -442,16 +390,6 @@ static int smu_v14_0_2_setup_pptable(str
 	if (ret)
 		return ret;
 
-	/*
-	 * With SCPM enabled, the operation below will be handled
-	 * by PSP. Driver involvment is unnecessary and useless.
-	 */
-	if (!adev->scpm_enabled) {
-		ret = smu_v14_0_2_append_powerplay_table(smu);
-		if (ret)
-			return ret;
-	}
-
 	ret = smu_v14_0_2_check_powerplay_table(smu);
 	if (ret)
 		return ret;
@@ -1938,7 +1876,6 @@ static const struct pptable_funcs smu_v1
 	.check_fw_status = smu_v14_0_check_fw_status,
 	.setup_pptable = smu_v14_0_2_setup_pptable,
 	.check_fw_version = smu_v14_0_check_fw_version,
-	.write_pptable = smu_cmn_write_pptable,
 	.set_driver_table_location = smu_v14_0_set_driver_table_location,
 	.system_features_control = smu_v14_0_system_features_control,
 	.set_allowed_mask = smu_v14_0_set_allowed_mask,


