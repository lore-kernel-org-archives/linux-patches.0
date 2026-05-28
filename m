Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3C2FDDC5;
	Thu, 28 May 2026 20:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000154; cv=none; b=LTayEMXVSKjoOQUxv6OU6KsdJEsbN5PssunEm11kevKGGY8/g5Ua7qQMJzKaFTIqZE9WnbSom2LvsXB1Www2Mw9w7vG/kW4sTd3PxdsCidwU83moLBwA89nJdgzxPS1MuSoOQDFC1qy1Lzj7b3YIOjEr019xs4P1AIYGoJOYWP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000154; c=relaxed/simple;
	bh=qG8WVeAYzI2ztCzLFVkc4Qf+uTs0B+fsNUkmQrB1vAA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=amSwc4NjWyaXG8cwTD8DgOBi15zyL3kKNkrdr6dv82771jyV/zlc6CkFVZ4Rj96tVdM5o4RYYDSMdbhx1cDAuGTZtGObkx0l/FWkR9jjJq4Tsq/csqFiLeIQB576GOPkFrUujCKLPEKBrKvBkw1KFQKSb8BA/rp6CkbQtwjQL+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dzuPW/ih; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dzuPW/ih"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 567571F000E9;
	Thu, 28 May 2026 20:29:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000153;
	bh=UMuTrMU4M0YlSX0b+MgcOySBnNM3NkN+O8bNrAe6rkw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dzuPW/iha8Jtqj+AAIYCYysFA3+TXCLxA15/isBppJqjN/QuDrcZwXbEDa3CHHTH2
	 LdPL5piGA2IA0JfRqKoMOyVJargEHTnitMWkaWT9ldhS8PbarglzO2iV+plaACi2oi
	 lH62L32eCPL6EY1tQYGP5MIWidF99Ol+d3LEGD1w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arkadiusz Kubalewski <Arkadiusz.kubalewski@intel.com>,
	Grzegorz Nitka <grzegorz.nitka@intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Alexander Nowlin <alexander.nowlin@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 322/377] ice: ptp: serialize E825 PHY timer start with PTP lock
Date: Thu, 28 May 2026 21:49:20 +0200
Message-ID: <20260528194647.727418976@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Grzegorz Nitka <grzegorz.nitka@intel.com>

[ Upstream commit 781ff8f2d575a794a2a4f11605288ae06757f5eb ]

ice_start_phy_timer_eth56g() programs TIMETUS registers and issues
INIT_INCVAL without holding the global PTP semaphore.

This allows concurrent PTP command paths to interleave with PHY timer
start, which can make the sequence fail and leave timer initialization
inconsistent.

Take the PTP lock around TIMETUS registers programming and INIT_INCVAL
command execution, and make sure the lock is released on all error paths.

Keep the subsequent sync step outside of this critical section, since
ice_sync_phy_timer_eth56g() takes the same semaphore internally.

Fixes: 7cab44f1c35f ("ice: Introduce ETH56G PHY model for E825C products")
Reviewed-by: Arkadiusz Kubalewski <Arkadiusz.kubalewski@intel.com>
Signed-off-by: Grzegorz Nitka <grzegorz.nitka@intel.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Tested-by: Alexander Nowlin <alexander.nowlin@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Link: https://patch.msgid.link/20260515182419.1597859-5-anthony.l.nguyen@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_ptp_hw.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ptp_hw.c b/drivers/net/ethernet/intel/ice/ice_ptp_hw.c
index 30b7839398165..0f378e68f72f1 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp_hw.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp_hw.c
@@ -2141,16 +2141,23 @@ int ice_start_phy_timer_eth56g(struct ice_hw *hw, u8 port)
 	}
 	incval = (u64)hi << 32 | lo;
 
+	if (!ice_ptp_lock(hw)) {
+		dev_err(ice_hw_to_dev(hw), "Failed to acquire PTP semaphore\n");
+		return -EBUSY;
+	}
+
 	err = ice_write_40b_ptp_reg_eth56g(hw, port, PHY_REG_TIMETUS_L, incval);
 	if (err)
-		return err;
+		goto err_ptp_unlock;
 
 	err = ice_ptp_one_port_cmd(hw, port, ICE_PTP_INIT_INCVAL);
 	if (err)
-		return err;
+		goto err_ptp_unlock;
 
 	ice_ptp_exec_tmr_cmd(hw);
 
+	ice_ptp_unlock(hw);
+
 	err = ice_sync_phy_timer_eth56g(hw, port);
 	if (err)
 		return err;
@@ -2166,6 +2173,10 @@ int ice_start_phy_timer_eth56g(struct ice_hw *hw, u8 port)
 	ice_debug(hw, ICE_DBG_PTP, "Enabled clock on PHY port %u\n", port);
 
 	return 0;
+
+err_ptp_unlock:
+	ice_ptp_unlock(hw);
+	return err;
 }
 
 /**
-- 
2.53.0



