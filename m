Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B72F329A0;
	Wed,  7 May 2025 19:03:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644629; cv=none; b=JxR84El0B8SAM6RbbWH7dBe1oNEcy9bJJGpbGuquUC9azUtN7sxNGMuONCAW5f3NyrllT/X/OPMeUdDVKU6RL05pAv66xiC/5SmqL8n52HIbeb9YV6UpoQQEal0MUBy/moIUtNm57TAQYOTnWjOmxy8o+U22Qs+ikg1wEpPPFqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644629; c=relaxed/simple;
	bh=46GhVJxXNUdB8tjf3FS+SltI+H/TuzI+eEsPJoRyg3s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FUmJsl04V7MvO4yC2tJ0WmdK4PzILi5lmYR1cbnWSnyrj0TzJ4l2MbW63aMy48dtsG2k6zYhXBsGiOp6Zm59NBbg+qXL1f2xJ6fH0SpK+nAe2yh8WIRC5toyk5ZoZAYXzKWiHIrZikmEhFyyFE05lOPbH0xtnTQPqOjhzz94bEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IM6/W2m/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IM6/W2m/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D719C4CEE2;
	Wed,  7 May 2025 19:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644629;
	bh=46GhVJxXNUdB8tjf3FS+SltI+H/TuzI+eEsPJoRyg3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IM6/W2m/YzW+HIoe9DUTTOZ9DZpHVgEnqf2HCUeIX8XIMdEJx9BqZl9bt2hzo5qdl
	 91Wo7xXJK/TpJceHqRo8k30Gvx780qug8ldgFQLV46L7YqmIlQoYMcxwX63Gcf0n3v
	 5DqxHjvcGbCt1W29BssATLk3loiPTlts6+x/gLC4=
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
Subject: [PATCH 6.12 106/164] igc: fix lock order in igc_ptp_reset
Date: Wed,  7 May 2025 20:39:51 +0200
Message-ID: <20250507183825.273515804@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183820.781599563@linuxfoundation.org>
References: <20250507183820.781599563@linuxfoundation.org>
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
index 612ed26a29c5d..efc7b30e42113 100644
--- a/drivers/net/ethernet/intel/igc/igc_ptp.c
+++ b/drivers/net/ethernet/intel/igc/igc_ptp.c
@@ -1290,6 +1290,8 @@ void igc_ptp_reset(struct igc_adapter *adapter)
 	/* reset the tstamp_config */
 	igc_ptp_set_timestamp_mode(adapter, &adapter->tstamp_config);
 
+	mutex_lock(&adapter->ptm_lock);
+
 	spin_lock_irqsave(&adapter->tmreg_lock, flags);
 
 	switch (adapter->hw.mac.type) {
@@ -1308,7 +1310,6 @@ void igc_ptp_reset(struct igc_adapter *adapter)
 		if (!igc_is_crosststamp_supported(adapter))
 			break;
 
-		mutex_lock(&adapter->ptm_lock);
 		wr32(IGC_PCIE_DIG_DELAY, IGC_PCIE_DIG_DELAY_DEFAULT);
 		wr32(IGC_PCIE_PHY_DELAY, IGC_PCIE_PHY_DELAY_DEFAULT);
 
@@ -1332,7 +1333,6 @@ void igc_ptp_reset(struct igc_adapter *adapter)
 			netdev_err(adapter->netdev, "Timeout reading IGC_PTM_STAT register\n");
 
 		igc_ptm_reset(hw);
-		mutex_unlock(&adapter->ptm_lock);
 		break;
 	default:
 		/* No work to do. */
@@ -1349,5 +1349,7 @@ void igc_ptp_reset(struct igc_adapter *adapter)
 out:
 	spin_unlock_irqrestore(&adapter->tmreg_lock, flags);
 
+	mutex_unlock(&adapter->ptm_lock);
+
 	wrfl();
 }
-- 
2.39.5



