Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AF371C84A0;
	Sun,  7 Sep 2025 20:30:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277002; cv=none; b=OVA2YeA47Mlf+wIhhsVcEsNMtZvbjmWrB+n/NMXTkaRvIOGZyufrPZpB6OcQtDQmM5eW/xbUwD0r5mD6iwUItUpJHobLRzvReMdvwwWsUi0oWXaozm9F9xaAPqpoMdQJGQpxBpMAMhdt/3G4xYmQFlKMo+o3UQdSLAcgiTKLUDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277002; c=relaxed/simple;
	bh=u8zplHa06fFwpCSSRCfmkD8W7xuNH/WFrli2d33XDNY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KKpvOZhiRdYa/rgeFjFpmO3OcUHZq56JEHU3CV6Y1mITqgySQLs2O0stdTwg5v9g5yBUmbh3F4xNYYLc2JwznqtqLZyHwLk2NHFUxq0GVzb9LAcohF+82WCGO1wzEqTf/3u4/Zyx0AMRyPXlSniNceJifFzyBBC5OnLW/iUDIQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u1rJWRGV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u1rJWRGV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE164C4CEF8;
	Sun,  7 Sep 2025 20:30:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277002;
	bh=u8zplHa06fFwpCSSRCfmkD8W7xuNH/WFrli2d33XDNY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u1rJWRGVsOi1XeDDXvdrwztJwfoEpyLZAW7CcpVpQc+U6PYt9PLlyakXI1hcD0LAj
	 vv6g2kPRfk7ZXkczMoqMeK3GsSF0/1brgGkqR/kCl8uXvpf9JtC4axbxk7MtBc0xip
	 cOjYbNifwyV6bgqcnJUsyoB+UJ9NjiL6Y9aZnibc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Keller <jacob.e.keller@intel.com>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Rinitha S <sx.rinitha@intel.com>
Subject: [PATCH 6.12 055/175] ice: fix NULL access of tx->in_use in ice_ll_ts_intr
Date: Sun,  7 Sep 2025 21:57:30 +0200
Message-ID: <20250907195616.141756661@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195614.892725141@linuxfoundation.org>
References: <20250907195614.892725141@linuxfoundation.org>
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

[ Upstream commit f6486338fde3f04ed0ec59fe67a69a208c32734f ]

Recent versions of the E810 firmware have support for an extra interrupt to
handle report of the "low latency" Tx timestamps coming from the
specialized low latency firmware interface. Instead of polling the
registers, software can wait until the low latency interrupt is fired.

This logic makes use of the Tx timestamp tracking structure, ice_ptp_tx, as
it uses the same "ready" bitmap to track which Tx timestamps complete.

Unfortunately, the ice_ll_ts_intr() function does not check if the
tracker is initialized before its first access. This results in NULL
dereference or use-after-free bugs similar to the issues fixed in the
ice_ptp_ts_irq() function.

Fix this by only checking the in_use bitmap (and other fields) if the
tracker is marked as initialized. The reset flow will clear the init field
under lock before it tears the tracker down, thus preventing any
use-after-free or NULL access.

Fixes: 82e71b226e0e ("ice: Enable SW interrupt from FW for LL TS")
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Tested-by: Rinitha S <sx.rinitha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 74d4f2fde3e0f..bd5db525f1939 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -3193,12 +3193,14 @@ static irqreturn_t ice_ll_ts_intr(int __always_unused irq, void *data)
 	hw = &pf->hw;
 	tx = &pf->ptp.port.tx;
 	spin_lock_irqsave(&tx->lock, flags);
-	ice_ptp_complete_tx_single_tstamp(tx);
+	if (tx->init) {
+		ice_ptp_complete_tx_single_tstamp(tx);
 
-	idx = find_next_bit_wrap(tx->in_use, tx->len,
-				 tx->last_ll_ts_idx_read + 1);
-	if (idx != tx->len)
-		ice_ptp_req_tx_single_tstamp(tx, idx);
+		idx = find_next_bit_wrap(tx->in_use, tx->len,
+					 tx->last_ll_ts_idx_read + 1);
+		if (idx != tx->len)
+			ice_ptp_req_tx_single_tstamp(tx, idx);
+	}
 	spin_unlock_irqrestore(&tx->lock, flags);
 
 	val = GLINT_DYN_CTL_INTENA_M | GLINT_DYN_CTL_CLEARPBA_M |
-- 
2.50.1



