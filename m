Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AEF71DF246;
	Sun,  7 Sep 2025 20:40:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277606; cv=none; b=jEdhp05u/V+cPghoV+5sy6M/FGxKQqFyfI/NftvV2WKKhzgzZLtI2z0TcPm2bF4kSRHiwIzLulH1bOCm5DTYoLm1k8Kc067alT7/BwsMJN94Nj0oJ+nJt4JzS9A4ZJlvbr9ZhVjlFG/3r+L+gjATUaUJHJAh3dxsobZLTHLPocw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277606; c=relaxed/simple;
	bh=FQwzufgO325z8ohLE4jpVoyrJf2XqSYWOVdWNygqooA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T/fxIB1IFp7Lfa6D6zaezpcM9/d6c+RbFGZiuLeSL6+H/xvu/mV46Kb2cvUgbNveJ4vpvZ5zzmfqmI7MOpqzH6VR3rbMwrw2fvHUQ9oThn4WRTdtOfqxhj/A8U3mZnnM1yer51t02Nv52i2DGCUjJN/dWA1vKM3XOGjB8rCjwuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xtFITDj0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xtFITDj0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD301C4CEF0;
	Sun,  7 Sep 2025 20:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277606;
	bh=FQwzufgO325z8ohLE4jpVoyrJf2XqSYWOVdWNygqooA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xtFITDj0EnXcTwYVQNEWM4kXUF4CAVwONYv7J4YZTmDqEfTxFPMaBiOC+jhXmigv4
	 ccRmCylbOSD8t1234TlfI//lPy823cGLxyty2ne76htnnmGTLAX5IoQjSwrlVk5VQo
	 N2ToYGA0mDSSNDlhZ+qXx+zAF1IuofbQXDUITTbc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Keller <jacob.e.keller@intel.com>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Rinitha S <sx.rinitha@intel.com>
Subject: [PATCH 6.16 065/183] ice: fix NULL access of tx->in_use in ice_ptp_ts_irq
Date: Sun,  7 Sep 2025 21:58:12 +0200
Message-ID: <20250907195617.336792139@linuxfoundation.org>
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

From: Jacob Keller <jacob.e.keller@intel.com>

[ Upstream commit 403bf043d9340196e06769065169df7444b91f7a ]

The E810 device has support for a "low latency" firmware interface to
access and read the Tx timestamps. This interface does not use the standard
Tx timestamp logic, due to the latency overhead of proxying sideband
command requests over the firmware AdminQ.

The logic still makes use of the Tx timestamp tracking structure,
ice_ptp_tx, as it uses the same "ready" bitmap to track which Tx
timestamps complete.

Unfortunately, the ice_ptp_ts_irq() function does not check if the tracker
is initialized before its first access. This results in NULL dereference or
use-after-free bugs similar to the following:

[245977.278756] BUG: kernel NULL pointer dereference, address: 0000000000000000
[245977.278774] RIP: 0010:_find_first_bit+0x19/0x40
[245977.278796] Call Trace:
[245977.278809]  ? ice_misc_intr+0x364/0x380 [ice]

This can occur if a Tx timestamp interrupt races with the driver reset
logic.

Fix this by only checking the in_use bitmap (and other fields) if the
tracker is marked as initialized. The reset flow will clear the init field
under lock before it tears the tracker down, thus preventing any
use-after-free or NULL access.

Fixes: f9472aaabd1f ("ice: Process TSYN IRQ in a separate function")
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Tested-by: Rinitha S <sx.rinitha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_ptp.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.c b/drivers/net/ethernet/intel/ice/ice_ptp.c
index 55cad824c5b9f..69e05bafb1e37 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.c
@@ -2877,16 +2877,19 @@ irqreturn_t ice_ptp_ts_irq(struct ice_pf *pf)
 		 */
 		if (hw->dev_caps.ts_dev_info.ts_ll_int_read) {
 			struct ice_ptp_tx *tx = &pf->ptp.port.tx;
-			u8 idx;
+			u8 idx, last;
 
 			if (!ice_pf_state_is_nominal(pf))
 				return IRQ_HANDLED;
 
 			spin_lock(&tx->lock);
-			idx = find_next_bit_wrap(tx->in_use, tx->len,
-						 tx->last_ll_ts_idx_read + 1);
-			if (idx != tx->len)
-				ice_ptp_req_tx_single_tstamp(tx, idx);
+			if (tx->init) {
+				last = tx->last_ll_ts_idx_read + 1;
+				idx = find_next_bit_wrap(tx->in_use, tx->len,
+							 last);
+				if (idx != tx->len)
+					ice_ptp_req_tx_single_tstamp(tx, idx);
+			}
 			spin_unlock(&tx->lock);
 
 			return IRQ_HANDLED;
-- 
2.50.1



