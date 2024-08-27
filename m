Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF7841BA294;
	Tue, 27 Aug 2024 15:05:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771102; cv=none; b=aUD6II8WF0y9PL8d/Vn/XJAGU1Vh7P/MLiMErwfPifF5EWnIhoLUPQEOkv6xqWRKWJgwNQFENi/CHk9YmgSOp9j7cxD1Q77HmsxWUirW+mUud44gRnbA1SpMIYRUGBFKLr2KsR6rghCgUPlXzlXNJavcpcf76S4SA2jlQ4ihdg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771102; c=relaxed/simple;
	bh=m1i6dXANf/9fXaQ3yNix6lEhfFlqeoho+v7fgr7GOWY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kpfs8DnkV6HL5gUt+2bwxZ/2WxEyjHgPpR4IElNikphAx3lLQG5BaL3Cw0ubkx2qqRzU4TqPMNGE9Rldmi7JZHoI0pdApzX/vWwQI9BqvTW2V9PgJmK+avgmExUmIqTly8uUECG1C9mbziotVkD+n7bj2Zts9J1BR+uOUZZ0gY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mRGyB+ls; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mRGyB+ls"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55D44C6105B;
	Tue, 27 Aug 2024 15:05:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771102;
	bh=m1i6dXANf/9fXaQ3yNix6lEhfFlqeoho+v7fgr7GOWY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mRGyB+lsLknaxh7jr4NvfYXyCq7Ui2OQTw2e4oOyBUXno1DotDiyur/pfeLHT0Ztl
	 AZjT8Vscg4tjhtam+qTHIf3ydHfjBZh6BX1hxOaTjTNCIhq2GFyB2M9hCflaJhulXH
	 nb05V8F0KsGYs3U4vzPSWCxtkmnKU1xE1HktYbi4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Faizal Rahim <faizal.abdul.rahim@linux.intel.com>,
	Simon Horman <horms@kernel.org>,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	Mor Bar-Gabay <morx.bar.gabay@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 087/273] igc: Fix reset adapter logics when tx mode change
Date: Tue, 27 Aug 2024 16:36:51 +0200
Message-ID: <20240827143836.724910451@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Faizal Rahim <faizal.abdul.rahim@linux.intel.com>

[ Upstream commit 0afeaeb5dae86aceded0d5f0c3a54d27858c0c6f ]

Following the "igc: Fix TX Hang issue when QBV Gate is close" changes,
remaining issues with the reset adapter logic in igc_tsn_offload_apply()
have been observed:

1. The reset adapter logics for i225 and i226 differ, although they should
   be the same according to the guidelines in I225/6 HW Design Section
   7.5.2.1 on software initialization during tx mode changes.
2. The i225 resets adapter every time, even though tx mode doesn't change.
   This occurs solely based on the condition  igc_is_device_id_i225() when
   calling schedule_work().
3. i226 doesn't reset adapter for tsn->legacy tx mode changes. It only
   resets adapter for legacy->tsn tx mode transitions.
4. qbv_count introduced in the patch is actually not needed; in this
   context, a non-zero value of qbv_count is used to indicate if tx mode
   was unconditionally set to tsn in igc_tsn_enable_offload(). This could
   be replaced by checking the existing register
   IGC_TQAVCTRL_TRANSMIT_MODE_TSN bit.

This patch resolves all issues and enters schedule_work() to reset the
adapter only when changing tx mode. It also removes reliance on qbv_count.

qbv_count field will be removed in a future patch.

Test ran:

1. Verify reset adapter behaviour in i225/6:
   a) Enrol a new GCL
      Reset adapter observed (tx mode change legacy->tsn)
   b) Enrol a new GCL without deleting qdisc
      No reset adapter observed (tx mode remain tsn->tsn)
   c) Delete qdisc
      Reset adapter observed (tx mode change tsn->legacy)

2. Tested scenario from "igc: Fix TX Hang issue when QBV Gate is closed"
   to confirm it remains resolved.

Fixes: 175c241288c0 ("igc: Fix TX Hang issue when QBV Gate is closed")
Signed-off-by: Faizal Rahim <faizal.abdul.rahim@linux.intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Acked-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Tested-by: Mor Bar-Gabay <morx.bar.gabay@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igc/igc_tsn.c | 24 +++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_tsn.c b/drivers/net/ethernet/intel/igc/igc_tsn.c
index 8ed7b965484da..ada7514305171 100644
--- a/drivers/net/ethernet/intel/igc/igc_tsn.c
+++ b/drivers/net/ethernet/intel/igc/igc_tsn.c
@@ -49,6 +49,13 @@ static unsigned int igc_tsn_new_flags(struct igc_adapter *adapter)
 	return new_flags;
 }
 
+static bool igc_tsn_is_tx_mode_in_tsn(struct igc_adapter *adapter)
+{
+	struct igc_hw *hw = &adapter->hw;
+
+	return !!(rd32(IGC_TQAVCTRL) & IGC_TQAVCTRL_TRANSMIT_MODE_TSN);
+}
+
 void igc_tsn_adjust_txtime_offset(struct igc_adapter *adapter)
 {
 	struct igc_hw *hw = &adapter->hw;
@@ -365,15 +372,22 @@ int igc_tsn_reset(struct igc_adapter *adapter)
 	return err;
 }
 
-int igc_tsn_offload_apply(struct igc_adapter *adapter)
+static bool igc_tsn_will_tx_mode_change(struct igc_adapter *adapter)
 {
-	struct igc_hw *hw = &adapter->hw;
+	bool any_tsn_enabled = !!(igc_tsn_new_flags(adapter) &
+				  IGC_FLAG_TSN_ANY_ENABLED);
+
+	return (any_tsn_enabled && !igc_tsn_is_tx_mode_in_tsn(adapter)) ||
+	       (!any_tsn_enabled && igc_tsn_is_tx_mode_in_tsn(adapter));
+}
 
-	/* Per I225/6 HW Design Section 7.5.2.1, transmit mode
-	 * cannot be changed dynamically. Require reset the adapter.
+int igc_tsn_offload_apply(struct igc_adapter *adapter)
+{
+	/* Per I225/6 HW Design Section 7.5.2.1 guideline, if tx mode change
+	 * from legacy->tsn or tsn->legacy, then reset adapter is needed.
 	 */
 	if (netif_running(adapter->netdev) &&
-	    (igc_is_device_id_i225(hw) || !adapter->qbv_count)) {
+	    igc_tsn_will_tx_mode_change(adapter)) {
 		schedule_work(&adapter->reset_task);
 		return 0;
 	}
-- 
2.43.0



