Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF835321445;
	Sat, 17 Oct 2026 17:35:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258549; cv=none; b=J9wP6loNV5rwmMWuXSNFs6V6Yfo80dZcyYMP/9pg0f8gp1OnnWCoqpjaI0rDYeE+kjzJ8MXBWVH9lLADibpmyVLfY67lkxaRE+vxKzMz10wrqVcbgw/1YzI9rytUFo6uONXea2+fey4kCOO/bDfl+UgnMxeGUmldS11DkcmZ81U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258549; c=relaxed/simple;
	bh=ugqM3oKLd9p5VnT/7OZ1DpB1b7miMgQhblJhWd77Z6Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Imzr0jLPP45g+eD2vvteke4x1nKLgv0anhUDeJG8maZuukAKbpW0ryy9OdoBjxLg14DKvB5mP8qILeOxP3xUSQdSbFGK7FXRITrnK6T2isZp6RKQxo4cPY18kYMl52H0Bh44y1OmZPu9g1nzdW7uPh/BHaVV5Y8CO1Dtwyl+KDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MSJWmRU/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MSJWmRU/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C12921F000C4;
	Sat, 17 Oct 2026 17:35:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258548;
	bh=PfoLzgnLIBy4RT+fjdfpDanDn7Qebi3iMusuSN6MlrM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MSJWmRU/FDaxh0NPB/m8Qi3HnqDjOSQU+p9rZY90c6ZHcENDOKaL1gn/7aWpyfQdx
	 K/5StXo++Y60WvMnlC0uxH/+b3KEPxXrGHiPFFFIsNswnIyVS0tz1Okc6rEIIc4Cas
	 yR/RLNLbiYnr2XkgEIp6YWCHxwt8lMnkStMRQE/I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0920/1674] wifi: iwlwifi: fix 22000 series SMEM parsing
Date: Sat, 17 Oct 2026 17:53:12 +0200
Message-ID: <20261017160454.750281538@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 58192b9ce09b0f0f86e2036683bd542130b91a98 ]

If the firmware were to report three LMACs (which doesn't
exist in hardware) then using "fwrt->smem_cfg.lmac[2]" is
an overrun of the array. Reject such and use IWL_FW_CHECK
instead of WARN_ON in this function.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20251110150012.16e8c2d70c26.Iadfcc1aedf43c5175b3f0757bea5aa232454f1ac@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/fw/dbg.h  | 4 ++--
 drivers/net/wireless/intel/iwlwifi/fw/smem.c | 8 ++++++--
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.h b/drivers/net/wireless/intel/iwlwifi/fw/dbg.h
index 4227fbd2b9771..27568a07ff06f 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.h
@@ -331,14 +331,14 @@ void iwl_send_dbg_dump_complete_cmd(struct iwl_fw_runtime *fwrt,
 				    u32 timepoint_data);
 
 #define IWL_FW_CHECK_FAILED(_obj, _fmt, ...)				\
-	IWL_ERR_LIMIT(_obj, _fmt, __VA_ARGS__)
+	IWL_ERR_LIMIT(_obj, _fmt, ##__VA_ARGS__)
 
 #define IWL_FW_CHECK(_obj, _cond, _fmt, ...)				\
 	({								\
 		bool __cond = (_cond);					\
 									\
 		if (unlikely(__cond))					\
-			IWL_FW_CHECK_FAILED(_obj, _fmt, __VA_ARGS__);	\
+			IWL_FW_CHECK_FAILED(_obj, _fmt, ##__VA_ARGS__);	\
 									\
 		unlikely(__cond);					\
 	})
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/smem.c b/drivers/net/wireless/intel/iwlwifi/fw/smem.c
index 3f1272014dafb..e2fc2f5de4426 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/smem.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/smem.c
@@ -6,6 +6,7 @@
  */
 #include "iwl-drv.h"
 #include "runtime.h"
+#include "dbg.h"
 #include "fw/api/commands.h"
 
 static void iwl_parse_shared_mem_22000(struct iwl_fw_runtime *fwrt,
@@ -17,7 +18,9 @@ static void iwl_parse_shared_mem_22000(struct iwl_fw_runtime *fwrt,
 	u8 api_ver = iwl_fw_lookup_notif_ver(fwrt->fw, SYSTEM_GROUP,
 					     SHARED_MEM_CFG_CMD, 0);
 
-	if (WARN_ON(lmac_num > ARRAY_SIZE(mem_cfg->lmac_smem)))
+	/* Note: notification has 3 entries, but we only expect 2 */
+	if (IWL_FW_CHECK(fwrt, lmac_num > ARRAY_SIZE(fwrt->smem_cfg.lmac),
+			 "FW advertises %d LMACs\n", lmac_num))
 		return;
 
 	fwrt->smem_cfg.num_lmacs = lmac_num;
@@ -26,7 +29,8 @@ static void iwl_parse_shared_mem_22000(struct iwl_fw_runtime *fwrt,
 	fwrt->smem_cfg.rxfifo2_size = le32_to_cpu(mem_cfg->rxfifo2_size);
 
 	if (api_ver >= 4 &&
-	    !WARN_ON_ONCE(iwl_rx_packet_payload_len(pkt) < sizeof(*mem_cfg))) {
+	    !IWL_FW_CHECK(fwrt, iwl_rx_packet_payload_len(pkt) < sizeof(*mem_cfg),
+			  "bad shared mem notification size\n")) {
 		fwrt->smem_cfg.rxfifo2_control_size =
 			le32_to_cpu(mem_cfg->rxfifo2_control_size);
 	}
-- 
2.53.0



