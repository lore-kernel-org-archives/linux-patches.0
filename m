Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 400071AA1D5;
	Wed,  4 Jun 2025 00:57:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748998655; cv=none; b=CWDBVCD/m3zLY0Yk8dGeWR5nHLaOM/k9TwswThVxUvJBVdvsbMAeI4YXnK9Jrr3JpbkTYksrCBxePohnbHAqaDfgdUyTHz3Slu1x/JEL3hEgfozrIOV6XcnKbQIPFizcu+7kD0T5A1V92j0hTX53/AepL5mB5OT4RC0l0yIqGN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748998655; c=relaxed/simple;
	bh=SBHkQYc0fW0yGvN/zkTj5N352lzox/GN8s21mP3puwc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DPZFssmljOxu/v31MA5uLcQBlwMWuZTC5TriyFXDoyYZJAbVyoNdmOuSk4+Qcg6o3gLD3BcoEb/kGMFvzE+ZIyWxZ2phQ/SKRl4wF0h+cDOHzD9qVBwIlP+zkLbR0WMYY7dUXf0eQcgOw0Wd4mmVQ33/1qDRqayByFyHKF4k5p0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OGatr1Ua; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OGatr1Ua"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F5D1C4CEEF;
	Wed,  4 Jun 2025 00:57:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748998655;
	bh=SBHkQYc0fW0yGvN/zkTj5N352lzox/GN8s21mP3puwc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OGatr1UaHgKV6rk/4HdTvzgWsCrVL0e/dYyuCIIrqTYvFN2YSS5XseB1yXjvdf7PT
	 QZ0/0sydTuk6sfpzofIgGBqlhuYiJMKqdHUHjBQXZmQE6wCpgQHtGSd15OEXaVXDTg
	 HsQJP3eavF0TwF7sU4qdmzRkJvwFQiJer8CvtX85CvOR7Sw6PgKso0f3OZbNTENtJc
	 iAkNZrF6ukdZSglaqiNcXYfyVK0E9w+So7n1KS+2OQchioeu83fDNGCXZNPXlP5+sO
	 2eWu8/tmk+UYb7nuhmlEkdL+GS43pbIQwA1S3bdp5vXyf3z7vZvUe1lo5RW6sD1JA+
	 ij7fwq1GbXAMw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Ilan Peer <ilan.peer@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	emmanuel.grumbach@intel.com,
	yedidya.ben.shimol@intel.com,
	shaul.triebitz@intel.com,
	linux@treblig.org
Subject: [PATCH AUTOSEL 6.14 059/108] wifi: iwlwifi: mvm: fix beacon CCK flag
Date: Tue,  3 Jun 2025 20:54:42 -0400
Message-Id: <20250604005531.4178547-59-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250604005531.4178547-1-sashal@kernel.org>
References: <20250604005531.4178547-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.14.9
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 8d7f08922a8cb621aa5d00bdce6a7afe57af1665 ]

The beacon CCK flag should be set for any CCK rate, not
just for 1 Mbps. Fix that.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Reviewed-by: Ilan Peer <ilan.peer@intel.com>
Link: https://patch.msgid.link/20250505215513.fe18b7d92d7d.I7bb40a92cea102677b695beb1e2a62a5ea72678b@changeid
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

**YES** This commit should be backported to stable kernel trees based on
my analysis of both the commit message and code changes: ## Analysis of
the Bug Fix **The Bug**: The original code incorrectly sets the beacon
CCK flag: ```c if (rate_idx <= IWL_FIRST_CCK_RATE) // WRONG: Only for 1
Mbps rate ``` **The Fix**: Changes the condition to properly include all
CCK rates: ```c if (rate_idx <= IWL_LAST_CCK_RATE) // CORRECT: For all
CCK rates (1, 2, 5.5, 11 Mbps) ``` ## Why This Should Be Backported ###
1. **Fixes Important Functional Bug** This fixes beacon transmission in
Access Point mode for Intel WiFi devices. The beacon CCK flag tells the
firmware which modulation type to use when transmitting beacons. Setting
it incorrectly could cause: - Beacon transmission failures - Radio
configuration errors - Interoperability issues with client devices -
Power management problems ### 2. **Small, Contained Change** The fix is
minimal and surgical - changing `IWL_FIRST_CCK_RATE` to
`IWL_LAST_CCK_RATE` in a single line. This type of targeted fix has
minimal risk of introducing regressions. ### 3. **Affects Critical
Kernel Subsystem** Wireless networking is a critical subsystem, and
beacon transmission is fundamental to WiFi Access Point operation.
Incorrect beacon formatting could prevent devices from connecting or
maintaining stable connections. ### 4. **Follows Stable Tree Criteria**
- **Important bugfix**: ✅ Fixes beacon transmission logic - **Minimal
risk**: ✅ One-line change with clear purpose - **No new features**: ✅
Pure bug fix - **No architectural changes**: ✅ Simple condition fix -
**Confined to subsystem**: ✅ Only affects iwlwifi driver ### 5.
**Matches Successful Backport Patterns** Looking at the similar commits
provided: - **Similar Commit #2** (YES): Fixed netif checksum flags -
also a small wireless driver fix - **Similar Commit #4** (YES): Fixed
beacon protection flags - nearly identical type of beacon-related fix -
**Similar Commit #5** (YES): Fixed MAC filter flags - another small flag
correction This commit has the same characteristics as those marked for
backporting: small driver fixes that correct important functionality
without architectural changes. ### 6. **Affects User-Visible
Functionality** Users running Intel WiFi devices as Access Points could
experience connection issues due to malformed beacons. This is exactly
the type of bug that stable trees should address. The fix is
straightforward, low-risk, and addresses a functional issue that could
impact real-world WiFi operations, making it an excellent candidate for
stable backporting.

 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
index 6b06732441c35..a699b43d475e1 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
 /*
- * Copyright (C) 2012-2014, 2018-2024 Intel Corporation
+ * Copyright (C) 2012-2014, 2018-2025 Intel Corporation
  * Copyright (C) 2013-2014 Intel Mobile Communications GmbH
  * Copyright (C) 2015-2017 Intel Deutschland GmbH
  */
@@ -941,7 +941,7 @@ u16 iwl_mvm_mac_ctxt_get_beacon_flags(const struct iwl_fw *fw, u8 rate_idx)
 	u16 flags = iwl_mvm_mac80211_idx_to_hwrate(fw, rate_idx);
 	bool is_new_rate = iwl_fw_lookup_cmd_ver(fw, BEACON_TEMPLATE_CMD, 0) > 10;
 
-	if (rate_idx <= IWL_FIRST_CCK_RATE)
+	if (rate_idx <= IWL_LAST_CCK_RATE)
 		flags |= is_new_rate ? IWL_MAC_BEACON_CCK
 			  : IWL_MAC_BEACON_CCK_V1;
 
-- 
2.39.5

