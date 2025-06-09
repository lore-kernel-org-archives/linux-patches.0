Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 741E78BFF;
	Mon,  9 Jun 2025 13:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749476638; cv=none; b=mtmJI/Ai8pStofVzgTF3ea2gDnZv0j2rofyBmbn59rBjkUE4GI7EJvlcdmQo42c4c2UAkuWkO6ixJ9JoY/Eky3Mh+iWpb9SbsOImDNWHe1yBZIrv90w3YT3q79fabaVklkxnYgYfZml/+aoLK5a/zvUs1qtL8VWDYJ7V52oGopo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749476638; c=relaxed/simple;
	bh=lMug/La/kPra131R38jmRMyz3svWbYkjuGKqmZ/sL90=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=OE+xH+zJtc2/qmE8hZ976kUKFHeDeEs4bjSObk0RqzC0WkVtjYyWxJD3Me+2diS0sye7rrrTfcv4Rw72m17g8BIoml8JDmN/hZUFMgrWkf08wHAXeYxgogLU9yrEobpW1v24/Y0j7S7H58pfLTdphZ8GutbiytMRvFJb3m3dRQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YQ1sKOO3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YQ1sKOO3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBF72C4CEEB;
	Mon,  9 Jun 2025 13:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749476638;
	bh=lMug/La/kPra131R38jmRMyz3svWbYkjuGKqmZ/sL90=;
	h=From:To:Cc:Subject:Date:From;
	b=YQ1sKOO3S/Hw08plgRP5u+d8sSCSbk628m2oMmvi0bB8+1z3pcWzafWS+/1Tw0eDT
	 t8vx8+n1uqSKRNKLHpWzj0zOIfClvyXxT99nc40DaHsH/2pfpDugkkEloKwt9f/7oD
	 PzGNG98Abvw6MIvmT2JLoFWODCSINMR690bcLpvm6HyiI/K1WWtwx9AgzLchvZdXxu
	 h7nRzTQIY0pHJw+Q4i1SRG/d5tU6PawS/M2V+Mnf85+fQntETZ+VHB3wn0o2eTGnK8
	 Xu9/j+qJ8pRFgVyw7LE0w0XG/m7evvk0x+o5D68ZN+E3QUJxwPEIom9wKBryu+Gswd
	 6czy7rfd3LrkA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ilan Peer <ilan.peer@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	emmanuel.grumbach@intel.com,
	daniel.gabay@intel.com,
	shaul.triebitz@intel.com
Subject: [PATCH AUTOSEL 6.15 01/35] wifi: iwlwifi: mld: Move regulatory domain initialization
Date: Mon,  9 Jun 2025 09:43:17 -0400
Message-Id: <20250609134355.1341953-1-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.15.1
Content-Transfer-Encoding: 8bit

From: Ilan Peer <ilan.peer@intel.com>

[ Upstream commit f81aa834bfa91c827f290b62a245e23c5ad2813c ]

The regulatory domain information was initialized every time the
FW was loaded and the device was restarted. This was unnecessary
and useless as at this stage the wiphy channels information was
not setup yet so while the regulatory domain was set to the wiphy,
the channel information was not updated.

In case that a specific MCC was configured during FW initialization
then following updates with this MCC are ignored, and thus the
wiphy channels information is left with information not matching
the regulatory domain.

This commit moves the regulatory domain initialization to after the
operational firmware is started, i.e., after the wiphy channels were
configured and the regulatory information is needed.

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20250604061200.f138a7382093.I2fd8b3e99be13c2687da483e2cb1311ffb4fbfce@changeid
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

**YES**

This commit should be backported to stable kernel trees. Here's my
extensive analysis:

## Bug Fix Nature

The commit fixes a real bug where regulatory domain information and
wiphy channel configurations become mismatched. Specifically, from the
commit message:

1. **Timing Issue**: The regulatory domain was being initialized in
   `iwl_mld_load_fw()` before wiphy channels were properly configured
2. **Update Failures**: When a specific MCC (Mobile Country Code) was
   configured during FW initialization, subsequent updates with the same
   MCC would be ignored, leaving channel information inconsistent with
   the regulatory domain

## Code Analysis

The changes are minimal and low-risk:
- **Removed from `iwl_mld_load_fw()`**: Lines removing the
  `iwl_mld_init_mcc()` call and its error handling
- **Added to `iwl_mld_start_fw()`**: The same call is added after
  `iwl_mld_config_fw()`, ensuring proper initialization order

## Comparison with Similar Commits

Most relevant is Similar Commit #4 (marked YES for backporting), which
addressed regulatory domain update issues when firmware starts. That
commit fixed the handling of `MCC_RESP_ILLEGAL` responses to ensure
channel lists were properly updated - a closely related regulatory
compliance issue.

## Stable Kernel Criteria

This commit meets the stable kernel requirements:
1. **Fixes a real bug**: Regulatory domain/channel mismatch is a serious
   issue affecting wireless compliance
2. **Small and contained**: Only moves a function call to the correct
   initialization sequence
3. **Low regression risk**: No new logic introduced, just reordering
   existing initialization
4. **Important functionality**: Regulatory compliance is critical for
   legal wireless operation
5. **Clear root cause**: The issue and fix are well-understood and
   documented

## Repository Context

From examining the kernel repository, I found that regulatory domain
initialization has been an ongoing concern in iwlwifi, with multiple
fixes addressing timing and synchronization issues. The `lar_regdom_set`
flag is critical for preventing operations (like scans) before
regulatory setup is complete.

The fix ensures that `iwl_mld_init_mcc()` is called after the firmware
is fully configured (`iwl_mld_config_fw()`), which is the proper time
when wiphy channels are set up and ready to receive regulatory updates.

This is precisely the type of bug fix that stable kernels should receive
- it corrects a specific functional issue without introducing
architectural changes or new features.

 drivers/net/wireless/intel/iwlwifi/mld/fw.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/fw.c b/drivers/net/wireless/intel/iwlwifi/mld/fw.c
index 4b083d447ee2f..6be9366bd4b14 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/fw.c
@@ -339,10 +339,6 @@ int iwl_mld_load_fw(struct iwl_mld *mld)
 	if (ret)
 		goto err;
 
-	ret = iwl_mld_init_mcc(mld);
-	if (ret)
-		goto err;
-
 	mld->fw_status.running = true;
 
 	return 0;
@@ -535,6 +531,10 @@ int iwl_mld_start_fw(struct iwl_mld *mld)
 	if (ret)
 		goto error;
 
+	ret = iwl_mld_init_mcc(mld);
+	if (ret)
+		goto error;
+
 	return 0;
 
 error:
-- 
2.39.5

