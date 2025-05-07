Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 229522144C1;
	Wed,  7 May 2025 19:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746645052; cv=none; b=OYqPdkfWZ9zKZeSriVSG52PcnPUyHqeM8FF11BYOCiglPYApKLw7qsfh62kjDXjip0MtT8xxzfK9/tUkvqQjq+T/ejhBpVGfsgyPMhzBvHhmNvIMVBKZHMKAbrHZIqVbow6A/U9AFT3Fq2eUzqQs/RzjEtgAuOrS2Y3W9J8iSGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746645052; c=relaxed/simple;
	bh=o+Raj4bPClfzU0VVz/Kjgs3yc+tDQpDEaJLVsUMX0ts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h8jhM2ZbnJqjCeTo753Tkk2rimVHYw95gN5FzMYp/dNXIK7TZ/lWbr5ajJYj0gK9QMkamDwleffiwOH18rcKoGA+9bgktRKdKApRv605001XB9D1k7bF1Fw5w0Ea/j7zsFLSB7tANXuHWy+xE9YbPGvopMgJbt/Pe8COfIq2IKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qE843KW6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qE843KW6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AA32C4CEE2;
	Wed,  7 May 2025 19:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746645051;
	bh=o+Raj4bPClfzU0VVz/Kjgs3yc+tDQpDEaJLVsUMX0ts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qE843KW6s0Zvlu1UxEZBk8c7xWmphJAegIk+ugl2R17ATLwdFireOFNaMSlvzaNxY
	 3nGkdMn9W3Kv+jmtqxhATfPYDrFu0MuVwXltUv+7RzfoYDqT1ASKOD+cfiXadMDle+
	 CLKrgNcx0GPOCflzDKzm2WdLEyLMQw/F+viHAeo8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Keller <jacob.e.keller@intel.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Vitaly Lifshits <vitaly.lifshits@intel.com>,
	Mor Bar-Gabay <morx.bar.gabay@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 077/129] igc: fix lock order in igc_ptp_reset
Date: Wed,  7 May 2025 20:40:13 +0200
Message-ID: <20250507183816.633899451@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183813.500572371@linuxfoundation.org>
References: <20250507183813.500572371@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jacob Keller <jacob.e.keller@intel.com>

[ Upstream commit c7d6cb96d5c33b5148f3dc76fcd30a9b8cd9e973 ]

Commit 1a931c4f5e68 ("igc: add lock preventing multiple simultaneous PTM
transactions") added a new mutex to protect concurrent PTM transactions.
This lock is acquired in igc_ptp_reset() in order to ensure the PTM
registers are properly disabled after a device reset.

The flow where the lock is acquired already holds a spinlock, so acquiring
a mutex leads to a sleep-while-locking bug, reported both by smatch,
and the kernel test robot.

The critical section in igc_ptp_reset() does correctly use the
readx_poll_timeout_atomic variants, but the standard PTM flow uses regular
sleeping variants. This makes converting the mutex to a spinlock a bit
tricky.

Instead, re-order the locking in igc_ptp_reset. Acquire the mutex first,
and then the tmreg_lock spinlock. This is safe because there is no other
ordering dependency on these locks, as this is the only place where both
locks were acquired simultaneously. Indeed, any other flow acquiring locks
in that order would be wrong regardless.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Fixes: 1a931c4f5e68 ("igc: add lock preventing multiple simultaneous PTM transactions")
Link: https://lore.kernel.org/intel-wired-lan/Z_-P-Hc1yxcw0lTB@stanley.mountain/
Link: https://lore.kernel.org/intel-wired-lan/202504211511.f7738f5d-lkp@intel.com/T/#u
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Reviewed-by: Vitaly Lifshits <vitaly.lifshits@intel.com>
Tested-by: Mor Bar-Gabay <morx.bar.gabay@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igc/igc_ptp.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_ptp.c b/drivers/net/ethernet/intel/igc/igc_ptp.c
index b6bb01a486d9d..a82af96e6bd12 100644
--- a/drivers/net/ethernet/intel/igc/igc_ptp.c
+++ b/drivers/net/ethernet/intel/igc/igc_ptp.c
@@ -1237,6 +1237,8 @@ void igc_ptp_reset(struct igc_adapter *adapter)
 	/* reset the tstamp_config */
 	igc_ptp_set_timestamp_mode(adapter, &adapter->tstamp_config);
 
+	mutex_lock(&adapter->ptm_lock);
+
 	spin_lock_irqsave(&adapter->tmreg_lock, flags);
 
 	switch (adapter->hw.mac.type) {
@@ -1255,7 +1257,6 @@ void igc_ptp_reset(struct igc_adapter *adapter)
 		if (!igc_is_crosststamp_supported(adapter))
 			break;
 
-		mutex_lock(&adapter->ptm_lock);
 		wr32(IGC_PCIE_DIG_DELAY, IGC_PCIE_DIG_DELAY_DEFAULT);
 		wr32(IGC_PCIE_PHY_DELAY, IGC_PCIE_PHY_DELAY_DEFAULT);
 
@@ -1279,7 +1280,6 @@ void igc_ptp_reset(struct igc_adapter *adapter)
 			netdev_err(adapter->netdev, "Timeout reading IGC_PTM_STAT register\n");
 
 		igc_ptm_reset(hw);
-		mutex_unlock(&adapter->ptm_lock);
 		break;
 	default:
 		/* No work to do. */
@@ -1296,5 +1296,7 @@ void igc_ptp_reset(struct igc_adapter *adapter)
 out:
 	spin_unlock_irqrestore(&adapter->tmreg_lock, flags);
 
+	mutex_unlock(&adapter->ptm_lock);
+
 	wrfl();
 }
-- 
2.39.5



