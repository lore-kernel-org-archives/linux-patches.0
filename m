Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 025EC1FF5EC;
	Wed,  7 May 2025 18:52:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746643922; cv=none; b=TXcfkAqdL6K6wX+0KpcsODli5aFOKfYLefbqTHYFK6KG669V/DCGgbxeD+URudjIG8uxVjKf0oxPQZ4mHiHi1Sq+3p3lsKXxVSA1LmJ3PvYYa2cSm6QP00qlHVMqkW172+WQw5vh97vm/nUMpGQkuknWoNQaHM7R4E4tJdouZYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746643922; c=relaxed/simple;
	bh=4gSwpihJSKKZvH2r+TuXsC3p84Cs6u6dCn4mSFNlXZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jRP9scNTwo9yWkSe3MhbN9/eKiDpBN+Z8ggVvzop2Aw3drolevGBmnJhgEqTbC5OIGmPp5SBiPopmf1Mb9mxm/BUzZdsjVT0bu8A+I0Qlt7mXGNDNfUKK6GXAFYExH/Ou+q41uZJVBf0ih8kMegYnTRmuNb6viLhn57jVvWrcg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uCVat27C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uCVat27C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E68CC4CEE2;
	Wed,  7 May 2025 18:52:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746643921;
	bh=4gSwpihJSKKZvH2r+TuXsC3p84Cs6u6dCn4mSFNlXZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uCVat27CR1giK4oTivNEG88qw3T0EzMBWhZy6d4OoxdqzHqxGRgkE7hJCuYHrxqh5
	 0YkLmlJ0CDEdeacwsHRrixBWt1q2HUYz5KYiPNsRD9QcEp19LTbKHuZE+4tRH3Dvss
	 pUpjoamguqLe0CzZKTGQEqrUH2gNtKXHwUj6yJgg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 062/183] wifi: iwlwifi: dont warn if the NIC is gone in resume
Date: Wed,  7 May 2025 20:38:27 +0200
Message-ID: <20250507183827.198954270@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183824.682671926@linuxfoundation.org>
References: <20250507183824.682671926@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

[ Upstream commit 15220a257319ffe3bf95796326dfe0aacdbeb1c4 ]

Some BIOSes decide to power gate the WLAN device during S3. Since
iwlwifi doesn't expect this, it gets very noisy reporting that the
device is no longer available. Wifi is still available because iwlwifi
recovers, but it spews scary prints in the log.

Fix that by failing gracefully.

Fixes: e8bb19c1d590 ("wifi: iwlwifi: support fast resume")
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=219597
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20250420095642.d8d58146c829.I569ca15eaaa774d633038a749cc6ec7448419714@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/intel/iwlwifi/iwl-trans.c    |  1 -
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c | 20 ++++++++++++++++---
 .../wireless/intel/iwlwifi/pcie/internal.h    |  9 +++++----
 .../net/wireless/intel/iwlwifi/pcie/trans.c   | 13 +++++++++---
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c  |  2 +-
 5 files changed, 33 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-trans.c b/drivers/net/wireless/intel/iwlwifi/iwl-trans.c
index 8ad2bd64dbd3d..ced8261c725f8 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-trans.c
@@ -555,7 +555,6 @@ void __releases(nic_access)
 iwl_trans_release_nic_access(struct iwl_trans *trans)
 {
 	iwl_trans_pcie_release_nic_access(trans);
-	__release(nic_access);
 }
 IWL_EXPORT_SYMBOL(iwl_trans_release_nic_access);
 
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index e0b657b2f74b0..89a28e42975cb 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -1703,10 +1703,24 @@ static int _iwl_pci_resume(struct device *device, bool restore)
 	 * need to reset it completely.
 	 * Note: MAC (bits 0:7) will be cleared upon suspend even with wowlan,
 	 * so assume that any bits there mean that the device is usable.
+	 * For older devices, just try silently to grab the NIC.
 	 */
-	if (trans->trans_cfg->device_family >= IWL_DEVICE_FAMILY_BZ &&
-	    !iwl_read32(trans, CSR_FUNC_SCRATCH))
-		device_was_powered_off = true;
+	if (trans->trans_cfg->device_family >= IWL_DEVICE_FAMILY_BZ) {
+		if (!iwl_read32(trans, CSR_FUNC_SCRATCH))
+			device_was_powered_off = true;
+	} else {
+		/*
+		 * bh are re-enabled by iwl_trans_pcie_release_nic_access,
+		 * so re-enable them if _iwl_trans_pcie_grab_nic_access fails.
+		 */
+		local_bh_disable();
+		if (_iwl_trans_pcie_grab_nic_access(trans, true)) {
+			iwl_trans_pcie_release_nic_access(trans);
+		} else {
+			device_was_powered_off = true;
+			local_bh_enable();
+		}
+	}
 
 	if (restore || device_was_powered_off) {
 		trans->state = IWL_TRANS_NO_FW;
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
index 45460f93d24ad..114a9195ad7f7 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
@@ -558,10 +558,10 @@ void iwl_trans_pcie_free(struct iwl_trans *trans);
 void iwl_trans_pcie_free_pnvm_dram_regions(struct iwl_dram_regions *dram_regions,
 					   struct device *dev);
 
-bool __iwl_trans_pcie_grab_nic_access(struct iwl_trans *trans);
-#define _iwl_trans_pcie_grab_nic_access(trans)			\
+bool __iwl_trans_pcie_grab_nic_access(struct iwl_trans *trans, bool silent);
+#define _iwl_trans_pcie_grab_nic_access(trans, silent)		\
 	__cond_lock(nic_access_nobh,				\
-		    likely(__iwl_trans_pcie_grab_nic_access(trans)))
+		    likely(__iwl_trans_pcie_grab_nic_access(trans, silent)))
 
 void iwl_trans_pcie_check_product_reset_status(struct pci_dev *pdev);
 void iwl_trans_pcie_check_product_reset_mode(struct pci_dev *pdev);
@@ -1105,7 +1105,8 @@ void iwl_trans_pcie_set_bits_mask(struct iwl_trans *trans, u32 reg,
 int iwl_trans_pcie_read_config32(struct iwl_trans *trans, u32 ofs,
 				 u32 *val);
 bool iwl_trans_pcie_grab_nic_access(struct iwl_trans *trans);
-void iwl_trans_pcie_release_nic_access(struct iwl_trans *trans);
+void __releases(nic_access_nobh)
+iwl_trans_pcie_release_nic_access(struct iwl_trans *trans);
 
 /* transport gen 1 exported functions */
 void iwl_trans_pcie_fw_alive(struct iwl_trans *trans, u32 scd_addr);
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index b1ccace7377fb..102a6123bba0e 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -2406,7 +2406,7 @@ EXPORT_SYMBOL(iwl_trans_pcie_reset);
  * This version doesn't disable BHs but rather assumes they're
  * already disabled.
  */
-bool __iwl_trans_pcie_grab_nic_access(struct iwl_trans *trans)
+bool __iwl_trans_pcie_grab_nic_access(struct iwl_trans *trans, bool silent)
 {
 	int ret;
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
@@ -2458,6 +2458,11 @@ bool __iwl_trans_pcie_grab_nic_access(struct iwl_trans *trans)
 	if (unlikely(ret < 0)) {
 		u32 cntrl = iwl_read32(trans, CSR_GP_CNTRL);
 
+		if (silent) {
+			spin_unlock(&trans_pcie->reg_lock);
+			return false;
+		}
+
 		WARN_ONCE(1,
 			  "Timeout waiting for hardware access (CSR_GP_CNTRL 0x%08x)\n",
 			  cntrl);
@@ -2489,7 +2494,7 @@ bool iwl_trans_pcie_grab_nic_access(struct iwl_trans *trans)
 	bool ret;
 
 	local_bh_disable();
-	ret = __iwl_trans_pcie_grab_nic_access(trans);
+	ret = __iwl_trans_pcie_grab_nic_access(trans, false);
 	if (ret) {
 		/* keep BHs disabled until iwl_trans_pcie_release_nic_access */
 		return ret;
@@ -2498,7 +2503,8 @@ bool iwl_trans_pcie_grab_nic_access(struct iwl_trans *trans)
 	return false;
 }
 
-void iwl_trans_pcie_release_nic_access(struct iwl_trans *trans)
+void __releases(nic_access_nobh)
+iwl_trans_pcie_release_nic_access(struct iwl_trans *trans)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 
@@ -2525,6 +2531,7 @@ void iwl_trans_pcie_release_nic_access(struct iwl_trans *trans)
 	 * scheduled on different CPUs (after we drop reg_lock).
 	 */
 out:
+	__release(nic_access_nobh);
 	spin_unlock_bh(&trans_pcie->reg_lock);
 }
 
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
index 7c1dd5cc084ac..83c6fcafcf1a4 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
@@ -1021,7 +1021,7 @@ static int iwl_pcie_set_cmd_in_flight(struct iwl_trans *trans,
 	 * returned. This needs to be done only on NICs that have
 	 * apmg_wake_up_wa set (see above.)
 	 */
-	if (!_iwl_trans_pcie_grab_nic_access(trans))
+	if (!_iwl_trans_pcie_grab_nic_access(trans, false))
 		return -EIO;
 
 	/*
-- 
2.39.5



