Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A33CD154AF
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 11:46:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F696C433C9;
	Wed, 20 Sep 2023 11:46:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695210366;
	bh=5vgmPDHjXg9+VrMyzxP/keIFkMlejDqusSdS79KEgpc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XdbCeFx1RWBQdVfhiIXZ5pbABDgh00TP7/PBhycCbj5mwQ+5gs+7o9w19ViZSnsgK
	 Nv3TtcThmCQVCAUeT2NIRnlIiG14pBUNq5zZBxQ3fImyri2JxDL6d6IR4oAXCgzQkE
	 Z+vJg3rxpJEvi26uvdTRad5ahZT+fC+MlvYZWjFo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avraham Stern <avraham.stern@intel.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 050/211] wifi: iwlwifi: pcie: avoid a warning in case prepare card failed
Date: Wed, 20 Sep 2023 13:28:14 +0200
Message-ID: <20230920112847.335189944@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112845.859868994@linuxfoundation.org>
References: <20230920112845.859868994@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Avraham Stern <avraham.stern@intel.com>

[ Upstream commit 057381ddac0593c6e4ca8f58732830d8542b9c4e ]

In case CSME holds the NIC and SAP connection is already established,
iwl_pcie_prepare_card_hw() during iwl_pci_probe() will fail
(which is fine since CSME will release the nic later when asked with
a SAP message). In this case tring to grab nic access to read the
crf ids will fail with a warning.
Avoid the warning by only trying to read the crf ids in case prepare
card succeeded.

Signed-off-by: Avraham Stern <avraham.stern@intel.com>
Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Link: https://lore.kernel.org/r/20230822103048.9b026fa7b97e.I12bea7e6eef54eeeaf916b68d71583e92ff310fd@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index 73c1fb3c0c5ec..bc83d2ba55c67 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -1132,12 +1132,6 @@ static int get_crf_id(struct iwl_trans *iwl_trans)
 	else
 		sd_reg_ver_addr = SD_REG_VER;
 
-	if (!iwl_trans_grab_nic_access(iwl_trans)) {
-		IWL_ERR(iwl_trans, "Failed to grab nic access before reading crf id\n");
-		ret = -EIO;
-		goto out;
-	}
-
 	/* Enable access to peripheral registers */
 	val = iwl_read_umac_prph_no_grab(iwl_trans, WFPM_CTRL_REG);
 	val |= ENABLE_WFPM;
@@ -1157,9 +1151,6 @@ static int get_crf_id(struct iwl_trans *iwl_trans)
 		 iwl_trans->hw_crf_id, iwl_trans->hw_cnv_id,
 		 iwl_trans->hw_wfpm_id);
 
-	iwl_trans_release_nic_access(iwl_trans);
-
-out:
 	return ret;
 }
 
@@ -1351,6 +1342,7 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		if (ret)
 			goto out_free_trans;
 		if (iwl_trans_grab_nic_access(iwl_trans)) {
+			get_crf_id(iwl_trans);
 			/* all good */
 			iwl_trans_release_nic_access(iwl_trans);
 		} else {
@@ -1360,7 +1352,6 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	}
 
 	iwl_trans->hw_rf_id = iwl_read32(iwl_trans, CSR_HW_RF_ID);
-	get_crf_id(iwl_trans);
 
 	/*
 	 * The RF_ID is set to zero in blank OTP so read version to
-- 
2.40.1



