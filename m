Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C013171A9
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:49:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BA95C433D2;
	Mon, 22 May 2023 19:49:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684784992;
	bh=ydEK3aU/RWb8e27zwHNLQSr+DRKSEVXK85FwTJnafns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y3S/CCwWenggcOkqJou1ERWPAD5bphSJLN6aTQ6sK60QfsSYvSbFkWSl8cKGfqNTs
	 q0EBr6/oHsXAlF3xakws3dSUid1O0G1qrxLHCVwWoZ93mvLxOVpIf+K3zNFDkSuYI5
	 /97QR4AOgdlLY3HANsjjDUvJzll3Ujth1uj2fhxc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 272/364] wifi: iwlwifi: fw: fix DBGI dump
Date: Mon, 22 May 2023 20:09:37 +0100
Message-Id: <20230522190419.514873889@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190412.801391872@linuxfoundation.org>
References: <20230522190412.801391872@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit d3ae69180bbd74bcbc03a2b6d10ed7eccbe98c23 ]

The DBGI dump is (unsurprisingly) of type DBGI, not SRAM.
This leads to bad register accesses because the union is
built differently, there's no allocation ID, and thus the
allocation ID ends up being 0x8000.

Note that this was already wrong for DRAM vs. SMEM since
they use different parts of the union, but the allocation
ID is at the same place, so it worked.

Fix all of this but set the allocation ID in a way that
the offset calculation ends up without any offset.

Fixes: 34bc27783a31 ("iwlwifi: yoyo: fix DBGI_SRAM ini dump header.")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Link: https://lore.kernel.org/r/20230514120631.19a302ae4c65.I12272599f7c1930666157b9d5e7f81fe9ec4c421@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
index 027360e63b926..3ef0b776b7727 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -1664,14 +1664,10 @@ static __le32 iwl_get_mon_reg(struct iwl_fw_runtime *fwrt, u32 alloc_id,
 }
 
 static void *
-iwl_dump_ini_mon_fill_header(struct iwl_fw_runtime *fwrt,
-			     struct iwl_dump_ini_region_data *reg_data,
+iwl_dump_ini_mon_fill_header(struct iwl_fw_runtime *fwrt, u32 alloc_id,
 			     struct iwl_fw_ini_monitor_dump *data,
 			     const struct iwl_fw_mon_regs *addrs)
 {
-	struct iwl_fw_ini_region_tlv *reg = (void *)reg_data->reg_tlv->data;
-	u32 alloc_id = le32_to_cpu(reg->dram_alloc_id);
-
 	if (!iwl_trans_grab_nic_access(fwrt->trans)) {
 		IWL_ERR(fwrt, "Failed to get monitor header\n");
 		return NULL;
@@ -1702,8 +1698,10 @@ iwl_dump_ini_mon_dram_fill_header(struct iwl_fw_runtime *fwrt,
 				  void *data, u32 data_len)
 {
 	struct iwl_fw_ini_monitor_dump *mon_dump = (void *)data;
+	struct iwl_fw_ini_region_tlv *reg = (void *)reg_data->reg_tlv->data;
+	u32 alloc_id = le32_to_cpu(reg->dram_alloc_id);
 
-	return iwl_dump_ini_mon_fill_header(fwrt, reg_data, mon_dump,
+	return iwl_dump_ini_mon_fill_header(fwrt, alloc_id, mon_dump,
 					    &fwrt->trans->cfg->mon_dram_regs);
 }
 
@@ -1713,8 +1711,10 @@ iwl_dump_ini_mon_smem_fill_header(struct iwl_fw_runtime *fwrt,
 				  void *data, u32 data_len)
 {
 	struct iwl_fw_ini_monitor_dump *mon_dump = (void *)data;
+	struct iwl_fw_ini_region_tlv *reg = (void *)reg_data->reg_tlv->data;
+	u32 alloc_id = le32_to_cpu(reg->internal_buffer.alloc_id);
 
-	return iwl_dump_ini_mon_fill_header(fwrt, reg_data, mon_dump,
+	return iwl_dump_ini_mon_fill_header(fwrt, alloc_id, mon_dump,
 					    &fwrt->trans->cfg->mon_smem_regs);
 }
 
@@ -1725,7 +1725,10 @@ iwl_dump_ini_mon_dbgi_fill_header(struct iwl_fw_runtime *fwrt,
 {
 	struct iwl_fw_ini_monitor_dump *mon_dump = (void *)data;
 
-	return iwl_dump_ini_mon_fill_header(fwrt, reg_data, mon_dump,
+	return iwl_dump_ini_mon_fill_header(fwrt,
+					    /* no offset calculation later */
+					    IWL_FW_INI_ALLOCATION_ID_DBGC1,
+					    mon_dump,
 					    &fwrt->trans->cfg->mon_dbgi_regs);
 }
 
-- 
2.39.2



