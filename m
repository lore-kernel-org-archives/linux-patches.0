Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 642C21A704B;
	Sun,  7 Sep 2025 20:38:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277529; cv=none; b=TG0M60i7o0T1PDmqEvrjU1dnYYIrV+sX41i+Pi8YrWj2IpHrwXm78ufZfv0skcWZFU6afwSdhK1/0zdutfCMGyLyC1KNMWxoqihI1aibVsbi0SyJY+B7edFROsbOV3Pv+G5m2r9ljoGmnC8vW5k1Xcg7JssfTRAlSXnpTUj6BQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277529; c=relaxed/simple;
	bh=ylGUFb9R6RkcA7b+LxHLlF0OtEvWMKkV28xG2xT3qbE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LRfl/qzY1Kd1ASEXCzCBTSduXEjqHh+zGtnXxKSpILy4TnyI1593aLUfe6VLwipBDE+nIqt9vnppdEK94vhHrVlSjwjdiAg73Lpj2G41+Wn9zSENmcF7jnjQmSjqMTnRncrCc+XxJkZm84RftxyxzZYQKBv4O1nrFjChsdxbaIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XBRa19qM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XBRa19qM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF76FC4CEF0;
	Sun,  7 Sep 2025 20:38:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277529;
	bh=ylGUFb9R6RkcA7b+LxHLlF0OtEvWMKkV28xG2xT3qbE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XBRa19qMD3juvANX65GddVPZjup+wSl899E46vCLw88vmAGnec8ljRSC5ri6Ak84I
	 wtFHmnRZujoWeTeKHv3o/qp4ke3C8vaEA+F5hPyfyX5HsC4hB+fdYrEBfz4xgu91on
	 SzwNQw+WBBsDOXRLZ06cVa7T5I92U0hLbl6XOTfs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 043/183] wifi: iwlwifi: if scratch is ~0U, consider it a failure
Date: Sun,  7 Sep 2025 21:57:50 +0200
Message-ID: <20250907195616.800796142@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195615.802693401@linuxfoundation.org>
References: <20250907195615.802693401@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

[ Upstream commit 224476613c8499f00ce4de975dd65749c5ca498c ]

We want to see bits being set in the scratch register upon resume, but
if all the bits are set, it means that we were kicked out of the PCI bus
and that clearly doesn't mean we can assume the firmware is still alive
after the suspend / resume cycle.

Fixes: cb347bd29d0d ("wifi: iwlwifi: mvm: fix hibernation")
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20250828095500.0f203e559242.I59eff718cb5fda575db41081a1a389f7af488717@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index 0a9e0dbb58fbf..e4e06bf9161c3 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -1503,11 +1503,15 @@ static int _iwl_pci_resume(struct device *device, bool restore)
 	 * Note: MAC (bits 0:7) will be cleared upon suspend even with wowlan,
 	 * but not bits [15:8]. So if we have bits set in lower word, assume
 	 * the device is alive.
+	 * Alternatively, if the scratch value is 0xFFFFFFFF, then we no longer
+	 * have access to the device and consider it powered off.
 	 * For older devices, just try silently to grab the NIC.
 	 */
 	if (trans->mac_cfg->device_family >= IWL_DEVICE_FAMILY_BZ) {
-		if (!(iwl_read32(trans, CSR_FUNC_SCRATCH) &
-		      CSR_FUNC_SCRATCH_POWER_OFF_MASK))
+		u32 scratch = iwl_read32(trans, CSR_FUNC_SCRATCH);
+
+		if (!(scratch & CSR_FUNC_SCRATCH_POWER_OFF_MASK) ||
+		    scratch == ~0U)
 			device_was_powered_off = true;
 	} else {
 		/*
-- 
2.50.1



