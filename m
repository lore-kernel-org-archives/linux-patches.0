Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA8511DF973;
	Wed, 19 Mar 2025 14:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395005; cv=none; b=WSWbSp+1TdvfpQtWdMu2DpudsghslOteo7vzdJ5/EbuMo4tZ/B9/nm9+PcDytBvgMdmsoNWHlqClyW7oyppTiFTXcS07yZyi/o4scJTUakr3JfktQbHBZD5Nf6sgL11xz6HnCy8glZiMzDB1KddvyYGfEavD5otW0vcdIEgXnRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395005; c=relaxed/simple;
	bh=T9bs0awX5pAORLbKbkLAsziOt0TBddxxjni/hhK6D+Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eWomdAcaGQi7sz8Ud+m9FWRidtb3Va3toxhZAljwLYXB+5vV4635+u1yWq1iw1J6tZsq69edwrebAuIbxRTH32CIU6T8GlLUv96YChbxeK+aaL41sswMKFeVN89DnSHxbFFZQYi1h9TgFp1VZ6hfb0rjAzIapqEeUpWbWP4Ea8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z6cDJ0Uv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z6cDJ0Uv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87695C4CEE4;
	Wed, 19 Mar 2025 14:36:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395005;
	bh=T9bs0awX5pAORLbKbkLAsziOt0TBddxxjni/hhK6D+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z6cDJ0Uv3hVHEhNhCKiZA5+ERlg8E+FKAcL4Pwm+m2sx/kmopy9/m9sdNLo4pvXoq
	 ZIIAB2YbRL18T5+fUpGh+PM+9LxsWqawUWHxIKsO4PZyw3MGQvf9lIzKX6/F7MaZlN
	 Ct+KnZNnqiTBrt9xQ4Y219HyhLpOxiJkTEBItdZ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 014/231] wifi: iwlwifi: mvm: fix PNVM timeout for non-MSI-X platforms
Date: Wed, 19 Mar 2025 07:28:27 -0700
Message-ID: <20250319143027.206298697@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143026.865956961@linuxfoundation.org>
References: <20250319143026.865956961@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

[ Upstream commit b8c8a03e9b7bfc06f366b75daf3d0812400e7123 ]

When MSI-X is not enabled, we mask all the interrupts in the interrupt
handler and re-enable them when the interrupt thread runs. If
STATUS_INT_ENABLED is not set, we won't re-enable in the thread.
In order to get the ALIVE interrupt, we allow the ALIVE interrupt
itself, and RX as well in order to receive the ALIVE notification (which
is received as an RX from the firmware.

The problem is that STATUS_INT_ENABLED is clear until the op_mode calls
trans_fw_alive which means that until trans_fw_alive is called, any
notification from the firmware will not be received.

This became a problem when we inserted the pnvm_load exactly between the
ALIVE and trans_fw_alive.

Fix that by calling trans_fw_alive before loading the PNVM. This will
allow to get the notification from the firmware about PNVM load being
complete and continue the flow normally.

This didn't happen on MSI-X because we don't disable the interrupts in
the ISR when MSI-X is available.

The error in the log looks like this:

iwlwifi 0000:00:03.0: Timeout waiting for PNVM load!
iwlwifi 0000:00:03.0: Failed to start RT ucode: -110
iwlwifi 0000:00:03.0: WRT: Collecting data: ini trigger 13 fired (delay=0ms).

Fixes: 70d3ca86b025 ("iwlwifi: mvm: ring the doorbell and wait for PNVM load completion")
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20250306122425.0f2cf207aae1.I025d8f724b44f52eadf6c19069352eb9275613a8@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index f30b0fc8eca97..2b9a684cf61d5 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
 /*
- * Copyright (C) 2012-2014, 2018-2024 Intel Corporation
+ * Copyright (C) 2012-2014, 2018-2025 Intel Corporation
  * Copyright (C) 2013-2015 Intel Mobile Communications GmbH
  * Copyright (C) 2016-2017 Intel Deutschland GmbH
  */
@@ -422,6 +422,8 @@ static int iwl_mvm_load_ucode_wait_alive(struct iwl_mvm *mvm,
 	/* if reached this point, Alive notification was received */
 	iwl_mei_alive_notif(true);
 
+	iwl_trans_fw_alive(mvm->trans, alive_data.scd_base_addr);
+
 	ret = iwl_pnvm_load(mvm->trans, &mvm->notif_wait,
 			    &mvm->fw->ucode_capa);
 	if (ret) {
@@ -430,8 +432,6 @@ static int iwl_mvm_load_ucode_wait_alive(struct iwl_mvm *mvm,
 		return ret;
 	}
 
-	iwl_trans_fw_alive(mvm->trans, alive_data.scd_base_addr);
-
 	/*
 	 * Note: all the queues are enabled as part of the interface
 	 * initialization, but in firmware restart scenarios they
-- 
2.39.5



