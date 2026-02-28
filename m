Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED0A3340A47
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:51:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301105; cv=none; b=RSzyqdfs4C31NfmrQrUq8J53K+XzWhQjjAJf91rJ+FFDMwovTzlTlQ5Tz8Gqxk3vftVuG9nfmQeS4SgHUeV4T7bdJwEZE4IDfEJ69zPRL0/8iJuC5iSgCFoxlg958n/810zsU1HE3lIBZ7WWG2w4RGu7bswBdalwITp4gedjhiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301105; c=relaxed/simple;
	bh=RzstUXFG7JLCuxr8fK6201BQ2AMv30CU3hWOpQjt/BA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Er1nj+YQ/ecXomWvG59JPHT9XxYRHl2AgzXyUEJJ8Wi3Uw9UOL10C8zuT/1b8XYQoIfIX4A7WW9p5FOtyHi9f5J1alwyC7Rxt1TS++1fgbLKYuY9C5krkBTHaHWVWbYLtYbdwvLORKnttsF3T8YcnBzyCYUare6/IcW4E8vzY2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RlhmgqDF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RlhmgqDF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BD4AC19423;
	Sat, 28 Feb 2026 17:51:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301104;
	bh=RzstUXFG7JLCuxr8fK6201BQ2AMv30CU3hWOpQjt/BA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RlhmgqDF2hXfe2N+Fxo5YeoBAQUT/jDBeAhj7TvnUyvB/glKVrXBD4nAAC7YHzCWo
	 5JqvxDUag0w0odOSM40DnpBwI02GSMYIO25VIRoWCndaBPJbLYEg03Hhss7XGfdAxh
	 iLtJskhDMNqnY4l2vg2PxlUTmX22LnN2gsQyOIL+7Z+4VW1TMO05wtuElvBQT1V6ZM
	 SDPtGJJ1J/I312srIXJm/meDrFyHNRZoFk/XuVJrzNZLYtlvFuOzRbaVsoWZD4r1ih
	 eP6Ki0C9NEqhBFOpmOa8Pqcy9a5cetdQtratFNa6hKyi86z6LL5uQXGoFJLrOxIqnV
	 EcPlc6A30rCww==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 258/752] wifi: iwlwifi: fix 22000 series SMEM parsing
Date: Sat, 28 Feb 2026 12:39:29 -0500
Message-ID: <20260228174750.1542406-258-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

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
 drivers/net/wireless/intel/iwlwifi/fw/smem.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/smem.c b/drivers/net/wireless/intel/iwlwifi/fw/smem.c
index 90fd69b4860c1..344ddde85b189 100644
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
2.51.0

