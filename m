Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C20603BB29
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:23:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H4vLq8m0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 743DCC433C8;
	Wed, 15 Nov 2023 19:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076195;
	bh=4irrJKd/lFYjPMQVWkvsA+AyMtKUlUHXFflZKqu2kbo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H4vLq8m0VZFtDJ+tVhbYT8yNXTKVrjh+My7aJC63zn5eaVVpZDuUihCIlwjFk8mEv
	 r/1v/RW/ILIfQLoancmH5h5fGylszFdkvW1b03jFdQ3ZHRNXRtffCLDTvSQDYSfA+o
	 vY6qVft56YKEMvNP/uYyr//ovXXD0cJonmtG9nX0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 135/550] wifi: iwlwifi: increase number of RX buffers for EHT devices
Date: Wed, 15 Nov 2023 14:11:59 -0500
Message-ID: <20231115191610.047441543@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191600.708733204@linuxfoundation.org>
References: <20231115191600.708733204@linuxfoundation.org>
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

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 2cf254c1e24fa8f01f42f5a8c77617e56bf50b86 ]

EHT devices can support 512 MPDUs in an A-MPDU, each of
which might be an A-MSDU and thus further contain multiple
MSDUs, which need their own buffer each. Increase the number
of buffers to avoid running out in high-throughput scenarios.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Link: https://lore.kernel.org/r/20230830112059.824e522927f1.Ie5b4a2d3953072b9d76054ae67e2e45900d6bba4@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Stable-dep-of: 08365d3b9140 ("wifi: iwlwifi: mvm: fix netif csum flags")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/cfg/bz.c | 10 ++++------
 drivers/net/wireless/intel/iwlwifi/cfg/sc.c |  8 +++-----
 2 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/cfg/bz.c b/drivers/net/wireless/intel/iwlwifi/cfg/bz.c
index b9893b22e41da..3d223014cfe6d 100644
--- a/drivers/net/wireless/intel/iwlwifi/cfg/bz.c
+++ b/drivers/net/wireless/intel/iwlwifi/cfg/bz.c
@@ -134,12 +134,10 @@ static const struct iwl_base_params iwl_bz_base_params = {
 	.ht_params = &iwl_gl_a_ht_params
 
 /*
- * If the device doesn't support HE, no need to have that many buffers.
- * These sizes were picked according to 8 MSDUs inside 256 A-MSDUs in an
+ * This size was picked according to 8 MSDUs inside 512 A-MSDUs in an
  * A-MPDU, with additional overhead to account for processing time.
  */
-#define IWL_NUM_RBDS_NON_HE		512
-#define IWL_NUM_RBDS_BZ_HE		4096
+#define IWL_NUM_RBDS_BZ_EHT		(512 * 16)
 
 const struct iwl_cfg_trans_params iwl_bz_trans_cfg = {
 	.device_family = IWL_DEVICE_FAMILY_BZ,
@@ -161,7 +159,7 @@ const struct iwl_cfg iwl_cfg_bz = {
 	.uhb_supported = true,
 	IWL_DEVICE_BZ,
 	.features = IWL_TX_CSUM_NETIF_FLAGS_BZ | NETIF_F_RXCSUM,
-	.num_rbds = IWL_NUM_RBDS_BZ_HE,
+	.num_rbds = IWL_NUM_RBDS_BZ_EHT,
 };
 
 const struct iwl_cfg iwl_cfg_gl = {
@@ -169,7 +167,7 @@ const struct iwl_cfg iwl_cfg_gl = {
 	.uhb_supported = true,
 	IWL_DEVICE_BZ,
 	.features = IWL_TX_CSUM_NETIF_FLAGS_BZ | NETIF_F_RXCSUM,
-	.num_rbds = IWL_NUM_RBDS_BZ_HE,
+	.num_rbds = IWL_NUM_RBDS_BZ_EHT,
 };
 
 
diff --git a/drivers/net/wireless/intel/iwlwifi/cfg/sc.c b/drivers/net/wireless/intel/iwlwifi/cfg/sc.c
index ad283fd22e2a2..d6243025993ea 100644
--- a/drivers/net/wireless/intel/iwlwifi/cfg/sc.c
+++ b/drivers/net/wireless/intel/iwlwifi/cfg/sc.c
@@ -127,12 +127,10 @@ static const struct iwl_base_params iwl_sc_base_params = {
 	.ht_params = &iwl_22000_ht_params
 
 /*
- * If the device doesn't support HE, no need to have that many buffers.
- * These sizes were picked according to 8 MSDUs inside 256 A-MSDUs in an
+ * This size was picked according to 8 MSDUs inside 512 A-MSDUs in an
  * A-MPDU, with additional overhead to account for processing time.
  */
-#define IWL_NUM_RBDS_NON_HE		512
-#define IWL_NUM_RBDS_SC_HE		4096
+#define IWL_NUM_RBDS_SC_EHT		(512 * 16)
 
 const struct iwl_cfg_trans_params iwl_sc_trans_cfg = {
 	.device_family = IWL_DEVICE_FAMILY_SC,
@@ -154,7 +152,7 @@ const struct iwl_cfg iwl_cfg_sc = {
 	.uhb_supported = true,
 	IWL_DEVICE_SC,
 	.features = IWL_TX_CSUM_NETIF_FLAGS_BZ | NETIF_F_RXCSUM,
-	.num_rbds = IWL_NUM_RBDS_SC_HE,
+	.num_rbds = IWL_NUM_RBDS_SC_EHT,
 };
 
 MODULE_FIRMWARE(IWL_SC_A_FM_B_FW_MODULE_FIRMWARE(IWL_SC_UCODE_API_MAX));
-- 
2.42.0



