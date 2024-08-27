Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6AF81C578E;
	Tue, 27 Aug 2024 14:45:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724769937; cv=none; b=C0YlYRwYdsSRakav8Z4+kC5cxfoTEiZy6ydjHq7J9Pr9S3z7GQuhzytyIYteEG/yC/Va/Yignl5/Je/S5Lqd5t+bmjI9+sv4/XtYa1nOG94rF3yHRBzO1m26ojIRDVnYTQ8BeeM9pTeXPTws82S/wP28KVsidu+IxvMlr6HSyNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724769937; c=relaxed/simple;
	bh=XZEsibTtekLbj7UHYwn1KpEl7pnS0XFxCSqRnXUocZ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sqN2JTHW2+qvpzJmRd6KVSCQm2Q7BzovuQCr5BITHpm6sTy4IC7HzTqcuRNoO6RJum6tQGA3MZU6McwAGAVWyc33MlP6ZuPdw94FHEXJrdlnfc4NtS77oyHhFZoCOvlD26f13dqVaiHIQem/IuQK6YzhWw6DuBvTXew9r9d9D4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ptW5DgTP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ptW5DgTP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 403EEC61063;
	Tue, 27 Aug 2024 14:45:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724769937;
	bh=XZEsibTtekLbj7UHYwn1KpEl7pnS0XFxCSqRnXUocZ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ptW5DgTPcp29/EGOiVHCun1VkDPnee546EM9acQo+KyVY9q04pnOETMvEpVwNJnTO
	 +xn1dKRcKKNsc1EAgDKOokYiT0PYBuue6n/qke5S5BpM/RaNfAXAHJFICD7DCm7YNZ
	 yKzl9EMnwWnMBEXkLv2uO5AvmtRHUBC1btreH/S4=
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
Subject: [PATCH 6.6 051/341] igc: Fix reset adapter logics when tx mode change
Date: Tue, 27 Aug 2024 16:34:42 +0200
Message-ID: <20240827143845.360929510@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



