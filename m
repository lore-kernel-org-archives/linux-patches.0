Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 419B1299931;
	Sat, 14 Feb 2026 21:26:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771104401; cv=none; b=KuY30gUnKfa51gwuY5kOrIJyDI7VG3dHow+3RVZv1ryCFO5uaF2UHN3SPd1aXXmMoEx10vhH9iu6R0yk14RhTUWjdnv20sMjAi+LrnPZP97BJGwSp6VPERHIA2bByzUrASsyS6TphAPoDSrz5BfnHyvsUQvfUnE5D+otDoBUfRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771104401; c=relaxed/simple;
	bh=u+g9ngQtEpQVymCgGy3CUibeFe01VqPw/hoD20MJWGo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HUlsLjJrQJML6t314ZPve5PrHwUzVsRPLtFdLnn1Rx1mWlYh4cH8g9iQYXhxGpjHwu94QuQbmMH0tz+tIrCa/Ad6T0BQ+pTnMVhim0zoWysRluF2MfePBKNm4kpi6dHac3nz/eMOHUYmf80fctQzYCt8s/kDeUqkQO+SSqyCWfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AwODhSlk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AwODhSlk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67C3DC19422;
	Sat, 14 Feb 2026 21:26:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771104401;
	bh=u+g9ngQtEpQVymCgGy3CUibeFe01VqPw/hoD20MJWGo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AwODhSlktBp7vmfTB7Ab2GMmTCNT5RzPAJtcCCdcDXOTH5akBrQWX6Dz+C3Vj7VdJ
	 NkBAlFgZDZHlnBMEaj5GQP868AHix3DVcQYVeomxvXS4EtOWauzYzsSvEr77RFD2/L
	 UFH1E8yC+uWMyrnENpyVaEr6JOis7MG+ZNFUWgEX01/GoJVq/cvs7SOVSc87RsQ2f0
	 B8tV6wzueA44JuDZrU1D0ZVpeb25Rfs7w7r3hCkN5gtF94s3ykCHvI7a20pJyJCpDK
	 v6cvTuW04YEUznDYnFJpB/fvhV4C0zkzQwehOpKz19/2tKXocXB+AMA/7sZmwve3Tk
	 sScjeb3DgXCmg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	neil.armstrong@linaro.org,
	yelangyan@huaqin.corp-partner.google.com
Subject: [PATCH AUTOSEL 6.19-6.18] wifi: iwlwifi: fix 22000 series SMEM parsing
Date: Sat, 14 Feb 2026 16:23:28 -0500
Message-ID: <20260214212452.782265-63-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260214212452.782265-1-sashal@kernel.org>
References: <20260214212452.782265-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19
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

LLM Generated explanations, may be completely bogus:

This confirms the bug perfectly:

- `mem_cfg->lmac_smem` has **3 entries** (from `iwl_shared_mem_cfg` in
  debug.h: `lmac_smem[3]`)
- `fwrt->smem_cfg.lmac` has **2 entries** (`MAX_NUM_LMAC = 2`)

The old code checked `lmac_num > ARRAY_SIZE(mem_cfg->lmac_smem)` which
is `lmac_num > 3`, so values of 3 pass the check. But then the loop
writes to `fwrt->smem_cfg.lmac[0]`, `[1]`, and `[2]` - but index 2 is
**out of bounds** for the 2-element destination array. This is a clear
buffer overwrite.

### Summary

**What the commit fixes**: An out-of-bounds array write in
`iwl_parse_shared_mem_22000()`. The bounds check validated against the
wrong array (the source array with 3 entries instead of the destination
array with 2 entries). If firmware reports 3 LMACs, writing to
`fwrt->smem_cfg.lmac[2]` overflows the 2-element array, corrupting
adjacent kernel memory.

**Meets stable criteria**:
- **Obviously correct**: YES - the fix changes the bounds check from the
  wrong array (source, 3 entries) to the correct array (destination, 2
  entries)
- **Fixes a real bug**: YES - out-of-bounds write / buffer overflow
- **Important**: YES - memory corruption can lead to crashes, data
  corruption, or potential security issues
- **Small and contained**: YES - only a few lines in one file, minimal
  change
- **No new features**: YES - pure bug fix with improved error reporting

**Risk**: Very low. The only behavioral change is checking against 2
instead of 3, and replacing WARN_ON with IWL_FW_CHECK (which provides
better error messaging but is functionally equivalent for the return-on-
error path).

**Dependency**: The `IWL_FW_CHECK` macro needs to exist in the stable
tree. It's defined in `fw/dbg.h` and is widely used across iwlwifi (28
files). It has been present in the iwlwifi driver for some time and
should be available in recent stable trees. For very old stable trees, a
simple replacement with `WARN_ON` and the corrected array size would
suffice.

**User impact**: Anyone with Intel 22000+ series WiFi hardware (very
common in modern laptops). While the specific trigger requires buggy
firmware, this is a defensive fix that prevents memory corruption.

**YES**

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

