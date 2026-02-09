Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 975AC1AF0AF;
	Mon,  9 Feb 2026 14:33:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647617; cv=none; b=OkiOxD5ES6vVcBlQTQz6GqkrJ0rt13Hz6PbeJ8Ciccm4GGnKlUXTPzejozL63rKXP2dWVYSbAblFY+B0H+gVTeDEAz11Vut7MeHmRZKlmObRJMdfdAmQMuye3dpLtNakooT/gfZ2Q7DxrSz9p7/mCR+EpiCKzNVc/6yHCRTWSrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647617; c=relaxed/simple;
	bh=OsYAwkVl7Y7/Apo1j10G4G1IWOnObAyAq1pRjEqP1J8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fachg3RNKF5mEF3AwfrHDeUWlAyCOWRMErHtR7OoYQuMpsoFNv7j7d4mZ7L9pjxLHNVMqQif95o59bwAVhds5+c+wkdzjSRt1TLX74LaSxBqukGmcp9WiY2jTjkVzGH9+ECeWYAgR8Dcr3ZhVcE2Cnn6mB9PKvf4qq81DsfTPeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rtaBFY6Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rtaBFY6Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C7B4C116C6;
	Mon,  9 Feb 2026 14:33:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647617;
	bh=OsYAwkVl7Y7/Apo1j10G4G1IWOnObAyAq1pRjEqP1J8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rtaBFY6QTKiDN4sYHTFngj1QyOI/u7i4/TQeCjbzdj6n8ZD6yvu1h7dnSHLUcccL4
	 V4P8/WhlJrlxccijrmrIshdbTDuX24mxOW/qFn1fnStDVV01vI5Pz3fYqHh07aHUHU
	 IJaf+Tte+gS3UPOHOCFbJ4zTOwGw2w/A1RoMxzEg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Grzegorz Nitka <grzegorz.nitka@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Sunitha Mekala <sunithax.d.mekala@intel.com>
Subject: [PATCH 6.18 126/175] ice: fix missing TX timestamps interrupts on E825 devices
Date: Mon,  9 Feb 2026 15:23:19 +0100
Message-ID: <20260209142325.043609755@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142320.474120190@linuxfoundation.org>
References: <20260209142320.474120190@linuxfoundation.org>
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

[ Upstream commit 99854c167cfc113ad863832b1601c4ca1a639cfe ]

Modify PTP (Precision Time Protocol) configuration on link down flow.
Previously, PHY_REG_TX_OFFSET_READY register was cleared in such case.
This register is used to determine if the timestamp is valid or not on
the hardware side.
However, there is a possibility that there is still the packet in the
HW queue which originally was supposed to be timestamped but the link
is already down and given register is cleared.
This potentially might lead to the situation in which that 'delayed'
packet's timestamp is treated as invalid one when the link is up
again.
This in turn leads to the situation in which the driver is not able to
effectively clean timestamp memory and interrupt configuration.
>From the hardware perspective, that 'old' interrupt was not handled
properly and even if new timestamp packets are processed, no new
interrupts is generated. As a result, providing timestamps to the user
applications (like ptp4l) is not possible.
The solution for this problem is implemented at the driver level rather
than the firmware, and maintains the tx_ready bit high, even during
link down events. This avoids entering a potential inconsistent state
between the driver and the timestamp hardware.

Testing hints:
- run PTP traffic at higher rate (like 16 PTP messages per second)
- observe ptp4l behaviour at the client side in the following
  conditions:
	a) trigger link toggle events. It needs to be physiscal
           link down/up events
	b) link speed change
In all above cases, PTP processing at ptp4l application should resume
always. In failure case, the following permanent error message in ptp4l
log was observed:
controller-0 ptp4l: err [6175.116] ptp4l-legacy timed out while polling
	for tx timestamp

Fixes: 7cab44f1c35f ("ice: Introduce ETH56G PHY model for E825C products")
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Signed-off-by: Grzegorz Nitka <grzegorz.nitka@intel.com>
Tested-by: Sunitha Mekala <sunithax.d.mekala@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_ptp.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.c b/drivers/net/ethernet/intel/ice/ice_ptp.c
index 8ec0f7d0fcebd..4aa88bac759f8 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.c
@@ -1338,9 +1338,12 @@ void ice_ptp_link_change(struct ice_pf *pf, bool linkup)
 		/* Do not reconfigure E810 or E830 PHY */
 		return;
 	case ICE_MAC_GENERIC:
-	case ICE_MAC_GENERIC_3K_E825:
 		ice_ptp_port_phy_restart(ptp_port);
 		return;
+	case ICE_MAC_GENERIC_3K_E825:
+		if (linkup)
+			ice_ptp_port_phy_restart(ptp_port);
+		return;
 	default:
 		dev_warn(ice_pf_to_dev(pf), "%s: Unknown PHY type\n", __func__);
 	}
-- 
2.51.0



